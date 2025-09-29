In oder to [authenticate with each other](security-and-privacy.html) and to share device data after successful [authorization](pairing.html) for the processing of defined [Mandatory Interoperable Values](methodology.html#from-use-cases-to-mivs) (MIVs), a DiGA and a Device Data Recorder 
- need to discover relevant information about each other, including the MIVs the other party is eligible to process
- must obtain information about the other party's X.509 certificates from a trusted third party
- must be able to expand MIV-defining FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) and other ValueSets used by the HDDT-specific resource definitions

These services are usable through the BfARM DiGA Registry and BfARM Device Registry (_DIGA Verzeichnis_ and _HiMi-SST-VZ_) and the German Central Terminology Service (_Zentraler Terminologiesrevr_, ZTS). The following class diagram shows the section of the [HDDT information model](information-model.html) that displays the BfARM registries and the ZTS along with their mutual cross-references. 

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_BfArM.svg" style="width: 100%;" />
</div>

For further information an the displayed classes and attributes and their mappings to FHIR resource defintions see the detailed explanation at the [HDDT information model](information-model.html#BfArM-registries).

### HiMi-SST-VZ
The BfARM Device Registry (_HiMi-SST-VZ_ ) is operated by BfArM and provides access to definitions of registered Personal Health Devices and Device Data Recorders. For HDDT the _HiMi-SST-VZ_ provides the following functions:
- providing information about Personal Health Devices (medical aids and implants) that are registered as HDDT [certification relevant systems](certification-relevant-systems.html), e.g. 
   - device information (name, version, etc.)
   - manufacturer and contact data 
   - static properties (e.g. amount od measured data that can be temporarely be stored on the device)
   - versioning of information about registered Personal Health Devices
- providing information about Device Data Recorders that successfully implemented § 374a SGB V HDDT interfaces
   - product information (name, version, etc.)
   - manufacturer and contact data
   - supported Personal Health Devices
   - endpoint addresses of the provided FHIR Resource Server and OAuth2 Authorization Server
   - information for verifying the authenticity of the Device Data Recorder in electronic communications
   - versioning of information about registered Device Data Recorders 
- listing the MIVs supported by defined Personal Health Devices and Device Data Recorders
- listing Personal Health Devices and Device Data Recorders that support a defined MIV

The _HiMi-SST-VZ_ and the processes for registering Personal Health Devices and Device Data Recorders are recently being build up by BfArM. A first draft of the APIs that provide the above listed functions will be published by end of October 2025. 

### DiGA Verzeichnis
The BfARM DiGA Registry (_DiGA Verzeichnis_) is operated by BfArM and provides access to definitions of registered DiGA (Digital Health Applications acc. § 33a SGB V). For HDDT the _DiGA Verzeichnis_ provides the following functions:
- providing information about registred DiGA
   - product information (name, version, etc.)
   - manufacturer and contact data
   - information for verifying the authenticity of the DiGA in electronic communications
   - versioning of information about registered DiGA
- listing the MIVs a defined DiGA is eligible to process
- listing all DiGA that are eligible to process a defined MIV

The _DiGA Verzeichnis_ can be reached at the URL https://diga.bfarm.de/de/verzeichnis. 

The _DiGA Verzeichnis_ is currently being expanded to include the data, registration processes, and interfaces needed for the implementation of § 374a SGB V.

A first draft of the APIs that provide the above listed functions will be published by end of October 2025. 

### Zentraler Terminologieserver

The **Central Terminology Server** (_Zentraler Terminologieserver_, ZTS) operated by **BfArM** provides access to medical terminologies and classification systems in FHIR package format.
These packages include CodeSystems, ValueSets, and ConceptMaps and and serve as the foundation for semantic interoperability in the German healthcare ecosystem.

In the ZTS, all terminology artifacts relevant to a specific domain or application (e.g., active ingredients of drugs or dosages, classification of diseases or HDDT MIV definitions) are bundled and provided as FHIR packages.
This ensures that implementers always receive a complete set of logically related ValueSets, CodeSystems, and ConceptMaps in one package – simplifying integration and guaranteeing consistency.

The _ZTS_ can be reached at the URL [https://terminologien.bfarm.de](https://terminologien.bfarm.de). This site allows to navigate through the provided FHIR CodeSystems and ValueSets and to manually download these as FHIR packages.

For HDDT the ZTS provides the following functions: 
- Provision of binding MIV definitions as FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html)
- Versioning of MIV definitions and signaling changes to MIV definitions
- Provisioning of FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) for device types
- Provisioning of [German translations of LOINC codes](https://terminologien.bfarm.de/fhir/CodeSystem/loinc-linguistic-variant-de-de) 
- Provisioning of [German translations of UCUM codes](https://terminologien.bfarm.de/fhir/CodeSystem/ucum-common-units-translation-de-de)

In addition to the GUI the ZTS provides several APIs which are designed for automation and integration into IT systems: * Packages API: Search and retrieve FHIR Packages ([openAPi](https://terminologien.bfarm.de/api-docs/packages.json))
* Feeds API: Stay informed about new or updated releases ([openAPI](https://terminologien.bfarm.de/api-docs/feeds.json))
* Redirector API: Resolve canonical URLs to the correct version of a resource [openAPI](https://terminologien.bfarm.de/api-docs/redirect.json)
* Token API: Access protected packages via token-based authentication

A short description of these APIs is provided below. More detailed descriptions are available as part of the [ZTS documentation](https://terminologien.bfarm.de/fhirpackages.html) (German only).

#### FHIR Package Structure

A FHIR Package is distributed as a tarball (`.tar.gz`) file. Each package contains:

* Directory `package/`
* Index file: `package/.index.json`
* Manifest: `package/package.json`
* FHIR resources (`package/*.json`)

#### General Requirements

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

#### API Endpoints

##### Token API

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

##### Package API

Used to search, list, and download packages.

| Endpoint                                   | Method | Description                         | Parameters                                                                                      | Response                                | Auth                                |
| ------------------------------------------ | ------ | ----------------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------- | ----------------------------------- |
| `/packages/{packageName}/{packageVersion}` | GET    | Download a specific package version | `packageName`, `packageVersion`                                                                 | Binary `.tgz` package                   | Bearer token for protected packages |
| `/packages/{packageName}`                  | GET    | List all versions of a package      | `packageName`                                                                                   | JSON with versions, dist-tags, unlisted | optional                            |
| `/packages/catalog`                        | GET    | Search FHIR packages                | `name`, `version`, `canonical`, `fhirVersion`, `prerelease`, `unlisted`, `protected`, `keyword` | JSON array of package objects           | optional                            |

---

##### Feeds API

Used to monitor updates via RSS feeds.

| Endpoint                  | Method | Description                                                                  | Parameters                                                                             | Response                     | Notes                 |
| ------------------------- | ------ | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------- | --------------------- |
| `/feeds/package-feed.xml` | GET    | Retrieve static HL7 RSS feed                                                 | None                                                                                   | XML feed (`application/xml`) | Static feed           |
| `/feeds/**`               | GET    | Retrieve dynamic RSS feed filtered by publisher, package name, keyword, type | `publisher`, `packageName`, `keyword`, `type` (PACKAGE or PUBLICATION), `publishToHl7` | XML feed (`application/xml`) | Dynamic filtered feed |

---

##### Canonical Redirector API

Used to resolve canonical URLs and resource identifiers.

| Endpoint                            | Method | Description                                             | Parameters                                                      | Response                           | Notes                                |
| ----------------------------------- | ------ | ------------------------------------------------------- | --------------------------------------------------------------- | ---------------------------------- | ------------------------------------ |
| `/resolve`                          | GET    | Resolve canonical URL and redirect to ZTS resource page | `url` (required), `version` (optional)                          | `302 Found` with `Location` header | 404 if not found, 503 if unavailable |
| `/fhir/{resourceType}/{resourceId}` | GET    | Resolve FHIR resource by type and ID                    | `resourceType` (CodeSystem, ValueSet, ConceptMap), `resourceId` | `302 Found` with `Location` header | 404 if not found, 503 if unavailable |



#### Example Tools and Scripts

To simplify integration, Gematik provides **example clients and configurations**:

-  [https://github.com/gematik/zts-api-client-examples](https://github.com/gematik/zts-api-client-examples)

These examples illustrate in practice how to:

* work with useful tools and helper scripts,
* automate the download and management of FHIR packages,
* handle authentication and token management in a secure way.

The repository is continuously evolving — not only to demonstrate new and relevant use cases, but also to provide full transparency regarding the ongoing development and extension of the API.


