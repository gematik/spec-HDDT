
A HiMi manufacturer MUST implement the following endpoints, for the purpose of allowing DiGA to access data from personal health devices and medical aids.

<p style="color:red">Experimental page: will not necessarily be in the final version.</p>

### Endpoints

- [API: CapabilityStatement (Metadata)](fhir-api-metadata.html)
- [API: Observation (Measurement data)](fhir-api-observation.html)
- [API: DeviceMetric (Device calibration)](fhir-api-devicemetric.html)
- [API: Device (Device instance and configuration)](fhir-api-device.html)

<p style="color:red">Optionally all the sections below can be removed, since they are described in other chapters. E.g. FHIR interactions and content type is described in [Use of HL7 FHIR](use_of_hl7_fhir.html).</p>

### Read Interactions

Endpoints that are required to support the REST interaction "READ" MUST be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions MUST conform to the HDDT FHIR Profiles.

### Search Interactions

Endpoints that are required to support the "SEARCH" interactions MUST allow searching via HTTP GET. Endpoints MAY choose to support search requests via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).

### Authentication

The authentication mechanism is described in chapter [Pairing - Tokens and Token Response](pairing.html#tokens-and-the-token-response).

### Error Handling

Error handling requirements for Device Data Recorders are detailed in [Use of HL7 FHIR](use_of_hl7_fhir.html#error-handling).

A comprehensive list of HTTP status codes, error scenarios, and response bodies is provided in [Error Codes](error-codes.html).

Each endpoint listed in the [Endpoints](#endpoints) section includes a summary of expected HTTP error codes, error types, and common causes.

**Considerations:**

- The server MUST return the defined HTTP error codes when the listed reason occurs.
- The server MUST return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource if `[OperationOutcome]` is specified as the error type by the OpenAPI description.
- The server SHOULD provide a reason for the error, but the concrete contents of the [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) are not specified. The server can choose to use a code in `OperationOutcome.issue.details`, or use the free text input in `OperationOutcome.issue.diagnostics`. This means that using the default error messages of your FHIR server implementations is likely supported.

### Auditing

The server should create and store audit logs, as defined by chapter [Security and Privacy](security-and-privacy.html).

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to request only resources matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code, as well as including of additional FHIR resources in the search result, sorting of search results, etc.

The table below lists what search parameters MUST, SHOULD, or MAY be supported. Each entry links to the search parameters section of the relevant FHIR resource specification. Implementation details for each search parameter (such as syntax and behavior) are defined by their data type on the linked page. For example, `code` uses the [token](https://hl7.org/fhir/R4/search.html#token) data type, while `device-name` uses the [string](https://hl7.org/fhir/R4/search.html#string) data type.

| Search parameter | Support | Applies to | Note |
|------------------|---------|------|------|
| `code`           | MUST | [Observation](https://hl7.org/fhir/R4/observation.html) | Constraining the search to a specific LOINC code, or code from a MIV [ValueSet](https://hl7.org/fhir/R4/valueset.htm).<br>[Link to search parameter list](https://hl7.org/fhir/R4/observation.html#search). |
| `date`           | MUST | [Observation](https://hl7.org/fhir/R4/observation.html) | Constrain search results based on a date or date range.<br>[Link to search parameter list](https://hl7.org/fhir/R4/observation.html#search).|
| `device-name`    | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their name.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `type`           | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their coded type.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `manufacturer`   | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their manufacturer.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `_id`            | MUST | all | Search for resources by their logical id.<br>[Link](https://hl7.org/fhir/R4/search.html#id) |
|`_include`        | MUST | all | Request an additional FHIR resource to be included in the search results, e.g. search for [Observation](https://hl7.org/fhir/R4/observation.html) resources and include the referenced [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources in the resulting [Bundle](https://hl7.org/fhir/R4/bundle.html).<br>[Link](https://hl7.org/fhir/R4/search.html#include) |
| `_sort`          | MUST | all | Specifies the order to return search results, with optional descending order using a '-' prefix.<br>[Link](https://hl7.org/fhir/R4/search.html#sort) |
| `_count`         | MUST | all | Specifies the maximum number of resources to return in a single page of search results.<br>[Link](https://hl7.org/fhir/R4/search.html#count) |
| `_lastUpdated`   | SHOULD | all | Search for resources based on the last time they were changed.<br>[Link](https://hl7.org/fhir/R4/search.html#lastUpdated) |
| `_has`           | MAY | all | Allows selecting resources based on the properties of resources that refer to them (reverse chaining).<br>[Link](https://hl7.org/fhir/R4/search.html#has) |
| `_revinclude`    | MAY | all | Requests that resources which refer to the matched search results also be included in the resulting [Bundle](https://hl7.org/fhir/R4/bundle.html).<br>[Link](https://hl7.org/fhir/R4/search.html#revinclude) |



For each resource type, all standard FHIR search parameters MAY be supported. See [FHIR Search](https://www.hl7.org/fhir/R4/search.html).

### Content-type
  - The server MUST support headers `Content-type` and `Accept`.
  - The server MUST support interpreting content types `application/fhir+json` and `application/fhir+xml`.
  - The server MUST return the response in the format that was requested (via the `Accept` header) from the client application.