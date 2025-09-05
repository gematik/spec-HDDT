FROM hl7fhir/ig-publisher-base:latest AS builder

# Bootstrap the IG Publisher environment
RUN /usr/local/bin/docker-entrypoint.sh true

# Clone the FHIR IG Template repository
RUN git clone --depth 1 https://github.com/gematik/fhir-ig-template.git /home/publisher/fhir-ig-template

WORKDIR /home/publisher/ig
COPY . .

RUN set -eux; \
    sushi .; \
    _updatePublisher.sh -y; \
    _genonce.sh; \
    test -d output; \
    cd temp/pages; \
    jekyll build --destination "/home/publisher/ig/output"; \
    cp -rf /home/publisher/ig/input/files/. /home/publisher/ig/output/files/; \
    cp -rf /home/publisher/ig/temp/pages/_includes/*.svg /home/publisher/ig/output/assets/images/; \
    rm /home/publisher/ig/output/assets/css/prism.css;

# ---------- Export-only stage ----------
FROM scratch AS export
COPY --from=builder /home/publisher/ig/output /output


FROM nginx:alpine AS final

# Copy the static site produced by the build stage
COPY --from=builder /home/publisher/ig/output /usr/share/nginx/html

# Optional: basic healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s CMD wget -qO- http://localhost/ || exit 1

EXPOSE 80