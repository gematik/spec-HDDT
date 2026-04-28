FROM hl7fhir/ig-publisher-base:latest AS builder

# Bootstrap the IG Publisher environment
RUN /usr/local/bin/docker-entrypoint.sh true

# Clone the FHIR IG Template repository
RUN git clone --depth 1 https://github.com/gematik/fhir-ig-template.git /home/publisher/fhir-ig-template

WORKDIR /home/publisher/ig
RUN ls -la /home/publisher/ig
COPY . .

# Ensure script is executable
RUN chmod +x _genonce.sh
RUN chmod +x _updatePublisher.sh

RUN set -eux; \
    sushi .; \
    bash _updatePublisher.sh -y; \
    bash _genonce.sh; \
    test -d output; \
    cd temp/pages; \
    cp /home/publisher/ig/output/qa.html /home/publisher/ig/qa.html; \
    jekyll build --destination "/home/publisher/ig/output"; \
    cp /home/publisher/ig/qa.html /home/publisher/ig/output/qa.html; \
    mkdir -p /home/publisher/ig/output/fhir-profiles; \
    cp -r /home/publisher/ig/fsh-generated/. /home/publisher/ig/output/fhir-profiles/

# ---------- Export-only stage ----------
FROM scratch AS export
COPY --from=builder /home/publisher/ig/output /output


FROM nginx:alpine AS final

# Copy the static site produced by the build stage
COPY --from=builder /home/publisher/ig/output /usr/share/nginx/html

# Optional: basic healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s CMD wget -qO- http://localhost/ || exit 1

EXPOSE 80
