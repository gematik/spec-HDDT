
The **Central Terminology Server** (Zentrale Terminologieserver - ZTS) operated by **BfArM** provides access to medical terminologies and classification systems in FHIR package format.
These packages include CodeSystems, ValueSets, and ConceptMaps and and serve as the foundation for semantic interoperability in the German healthcare ecosystem.

In the ZTS, all terminology artifacts relevant to a specific domain or application (e.g., active ingredients of drugs or dosages, classification of diseases or health device data transfer – HDDT) are bundled and provided as FHIR packages.
This ensures that implementers always receive a complete set of logically related ValueSets, CodeSystems, and ConceptMaps in one package – simplifying integration and guaranteeing consistency.

**ZTS homepage**: [https://terminologien.bfarm.de](https://terminologien.bfarm.de)

The ZTS APIs are designed for automation and integration into IT systems. They allow vendors to:

* Search and retrieve FHIR Packages
* Stay informed about new or updated releases
* Resolve canonical URLs to the correct version of a resource
* Access protected packages via token-based authentication

---

### FHIR Package Structure

A FHIR Package is distributed as a tarball (`.tar.gz`) file. Each package contains:

* Directory `package/`
* Index file: `package/.index.json`
* Manifest: `package/package.json`
* FHIR resources (`package/*.json`)


---

### General Requirements

* All requests **MUST** use HTTPS (`https://terminologien.bfarm.de`).
* Responses are JSON unless explicitly noted (feeds are XML).
* Clients **MUST** handle HTTP status codes:

  * `200 OK` – Success
  * `302 Found` – Redirect
  * `400 Bad Request` – Invalid parameters
  * `401 Unauthorized` – Missing/invalid token
  * `404 Not Found` – Resource does not exist
  * `503 Service Unavailable` – Temporary outage
* Protected packages require a Bearer token.
* Clients **SHOULD** implement caching.
* Clients **SHOULD** implement retry logic with exponential backoff.

---

### API Endpoints

#### Token API

Used to access protected packages.

| Endpoint              | Method | Description                           | Request Body                      | Response                 | Notes                                   |
| --------------------- | ------ | ------------------------------------- | --------------------------------- | ------------------------ | --------------------------------------- |
| `/api/generate-token` | POST   | Generate token for protected packages | JSON object with `packages` array | JSON object with `token` | Token is sent in `Authorization` header |

**Request Example**

```
POST https://terminologien.bfarm.de/api/generate-token
Content-Type: application/json

{
  "packages": ["bfarm.terminologien.hddt"]
}
```

**Response Example**

```json
{ "token": "eyJhbGciOiJIUzI1NiIsInR..." }
```

---

#### Package API

Used to search, list, and download packages.

| Endpoint                                   | Method | Description                         | Parameters                                                                                      | Response                                | Auth                                |
| ------------------------------------------ | ------ | ----------------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------- | ----------------------------------- |
| `/packages/{packageName}/{packageVersion}` | GET    | Download a specific package version | `packageName`, `packageVersion`                                                                 | Binary `.tgz` package                   | Bearer token for protected packages |
| `/packages/{packageName}`                  | GET    | List all versions of a package      | `packageName`                                                                                   | JSON with versions, dist-tags, unlisted | optional                            |
| `/packages/catalog`                        | GET    | Search FHIR packages                | `name`, `version`, `canonical`, `fhirVersion`, `prerelease`, `unlisted`, `protected`, `keyword` | JSON array of package objects           | optional                            |

---

#### Feeds API

Used to monitor updates via RSS feeds.

| Endpoint                  | Method | Description                                                                  | Parameters                                                                             | Response                     | Notes                 |
| ------------------------- | ------ | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------- | --------------------- |
| `/feeds/package-feed.xml` | GET    | Retrieve static HL7 RSS feed                                                 | None                                                                                   | XML feed (`application/xml`) | Static feed           |
| `/feeds/**`               | GET    | Retrieve dynamic RSS feed filtered by publisher, package name, keyword, type | `publisher`, `packageName`, `keyword`, `type` (PACKAGE or PUBLICATION), `publishToHl7` | XML feed (`application/xml`) | Dynamic filtered feed |

---

#### Canonical Redirector API

Used to resolve canonical URLs and resource identifiers.

| Endpoint                            | Method | Description                                             | Parameters                                                      | Response                           | Notes                                |
| ----------------------------------- | ------ | ------------------------------------------------------- | --------------------------------------------------------------- | ---------------------------------- | ------------------------------------ |
| `/resolve`                          | GET    | Resolve canonical URL and redirect to ZTS resource page | `url` (required), `version` (optional)                          | `302 Found` with `Location` header | 404 if not found, 503 if unavailable |
| `/fhir/{resourceType}/{resourceId}` | GET    | Resolve FHIR resource by type and ID                    | `resourceType` (CodeSystem, ValueSet, ConceptMap), `resourceId` | `302 Found` with `Location` header | 404 if not found, 503 if unavailable |

---

### Step-by-Step Usage Guide

This section describes how DiGA and personal health device manufacturers can integrate the ZTS APIs.

#### Access Protected Packages

1. Generate a token

   ```
   POST /api/generate-token
   ```

   Body:

   ```json
   { "packages": ["bfarm.terminologien.hddt"] }
   ```
2. Store the token securely.

3. Attach token in every request:

   ```
   Authorization: Bearer <token>
   ```

4. Refresh token when expired.

---

#### Search for Packages

1. Send request:

   ```
   GET /packages/catalog?name=hddt&fhirVersion=R4&keyword=HDDT
   ```
2. Check JSON response for available versions.

---

#### Retrieve Package Versions

1. Request:

   ```
   GET /packages/bfarm.terminologien.hddt
   ```
2. Response lists all versions, e.g.:

   ```json
   {
     "name": "bfarm.terminologien.hddt",
     "versions": ["1.0.0", "1.1.0"]
   }
   ```

---

#### Download a Package

```
GET /packages/bfarm.terminologien.hddt/1.0.0
Authorization: Bearer <token>
```

Response: binary `.tgz`.

---

#### Monitor Updates

- Use RSS feeds to automatically detect updates.
- Example:

  ```
  GET /feeds/?publisher=BfArM&keyword=HDDT&type=PACKAGE
  Accept: application/xml
  ```

---

#### Resolve Canonical URLs

```
GET /resolve?url=https://terminologien.bfarm.de/fhir/ValueSet/VS-Tissue-Glucose-CGM
```

Response: `302 Found` → redirect to correct resource.

---

### Example Clients

To simplify integration, Gematik provides **example clients and configurations**:

-  [https://github.com/gematik/zts-api-client-examples](https://github.com/gematik/zts-api-client-examples)

These show:

* Useful tools
* Automated download of FHIR Packages
* Token handling


---

### Error Handling & Best Practices

* Always validate HTTP status codes
* Using retry with exponential backoff for `503`
* Caching fhir cache to avoid unnecessary calls
* Validating package integrity after download


---

### OpenAPI Specifications

Machine-readable OpenAPI files:

* [Packages API](https://terminologien.bfarm.de/api-docs/packages.json)
* [Feeds API](https://terminologien.bfarm.de/api-docs/feeds.json)
* [Redirector API](https://terminologien.bfarm.de/api-docs/redirect.json)

---

