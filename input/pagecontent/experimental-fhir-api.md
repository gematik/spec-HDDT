
A HiMi manufacturer MUST implement the following endpoints, for the purpose of allowing DiGA to access data from personal health devices and medical aids.

<p style="color:red">Experimental page: will not necessarily be in the final version.</p>

### Endpoints

- [API: CapabilityStatement (Metadata)](experimental-api-metadata.html)
- [API: Observation (Measurement data)](experimental-api-observation.html)
- [API: DeviceMetric (Device calibration)](experimental-api-devicemetric.html)
- [API: Device (Device instance and configuration)](experimental-api-device.html)


<p style="color:red">Optionally all the sections below can be removed, since they are described in other chapters. E.g. FHIR interactions and content type is described in [Use of HL7 FHIR](use_of_hl7_fhir.html).</p>

### Read Interactions

Endpoints that are required to support the REST interaction "READ" **MUST** be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions **MUST** conform to the HDDT FHIR Profiles.

### Search Interactions

Endpoints that are required to support the "SEARCH" interactions **MUST** allow searching via HTTP GET. Endpoints **MAY** choose to support search requests via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).

### Authentication

The authentication mechanism is described in chapter [Pairing - Tokens and Token Response](pairing.html#tokens-and-the-token-response).

### Error Handling

The [Endpoints](#endpoints) section lists the expected HTTP error codes, the type of error, and likely reasons for the occurrence of the error.

**Considerations:**

- The server **MUST** return the defined HTTP error codes when the listed reason occurs.
- The server **MUST** return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource if `[OperationOutcome]` is specified as the error type by the OpenAPI description.
- The server **SHOULD** provide a reason for the error, but the concrete contents of the [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) are not specified. The server can choose to use a code in `ObservationOutcome.issue.details`, or use the free text input in `ObservationOutcome.issue.diagnostics`. This means that using the default error messages of your FHIR server implementations is likely supported.

### Auditing

The server should create and store audit logs, as defined by chapter [Security and Privacy](security-and-privacy.html).

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to request only resources matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code.

The endpoint specification lists the most important search parameters for the generic API and for individual MIV-Specific APIs.

For each resource type, all standard FHIR search parameters MAY be supported. See [FHIR Search](https://www.hl7.org/fhir/R4/search.html).

### Content-type
  - The server **MUST** support headers `Content-type` and `Accept`.
  - The server **MUST** support interpreting content types `application/fhir+json` and `application/fhir+xml`.
  - The server **MUST** return the response in the format that was requested (via the `Accept` header) from the client application.