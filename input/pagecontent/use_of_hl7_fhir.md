
### FHIR Version
This specification is based on HL7 FHIR R4 (v4.0.1), which is the normative FHIR version for the German healthcare system.

Considering that existing implementations at affected manufactures of resource servers may use FHIR R5 or may even prepare for the upcoming release R6, serious efforts have been made to not rely on elements from FHIR R4 resource definitions that do not have corresponding elements in R5 and R6. This even is a prerequisite for a sematics-preserving possible future upgrade of the HDDT specifications to a higher FHIR version than R4. 

### Representation Format
The FHIR standard defines three different representation formats: XML, JSON, and RDF (Turtle). Within the scope of the HDDT specification, resource servers as HDDT device data providers MUST support both the XML and JSON formats. 

DiGA as HDDT device data consumers may choose between XML and JSON representations but MUST indicate the chosen representation in the HTTP `Accept` and `Content-Type` headers.

If a HDDT device data consumer requests a format in the `Accept` header that is not supported by the HDDT device data provider, the HDDT device data provider MUST respond with the error code _406 Not Acceptable_. If a HDDT device data consumer sends a format in the `Content-Type` header that is not supported by the HDDT device data provider, the HDDT device data provider MUST respond with the error code _415 Unsupported Media Type_.

It should be noted that the `Content-Type` and `Accept` headers may include additional FHIR-specific and general parameters:
* HDDT device data providers MUST support [FHIR HTTP Version Parameters](https://www.hl7.org/fhir/R4/http.html#version-parameter). If a request specifies a FHIR version other than version 4.0 the HDDT device data provider MUST respond to with error code _406 Not Acceptable_.
* HDDT device data providers SHOULD support the [FHIR HTTP `_format` Parameter](https://www.hl7.org/fhir/R4/http.html#parameters) and MAY support the other parameters defined at https://www.hl7.org/fhir/R4/http.html#parameters.

### _Mandatory_, _Must Support_ and _Optional_ Elements
The elements defined within the HDDT FHIR profiles consist of _Mandatory_, _Must Support_ and _Optional_ elements. 
#### _Mandatory_ Elements
Mandatory elements are elements with a minimum cardinality of 1 (min=1). A HDDT device data provider always MUST provide a valid value for such elements. A HDDT device data consumer MUST be able to process such elements according to the semantics as defined with the HDDT specifications or the core HL7 FHIR R4 specification.

#### _Must Support_ Elements
_Must Support_ elements are flagged with an "S" in the HDDT FHIR profile definitions. A HDDT device data provider SHOULD provide a valid value for each _Must Support_ element. Omitting a _Must Support_ element in response to a query is only allowed if 
* an exceptional case exists which is described in the HDDT specification
* the element holds a codable value which is bound to a required [ValueSet](https://hl7.org/fhir/R4/valueset.html) where none of the defined codes match the value.

A HDDT device data consumer MUST be able to process all _Must Support_ elements according to the semantics as defined with the HDDT specification or the core HL7 FHIR R4 specification. 

#### _Optional_ Elements
Optional elements are elements with a minimum cardinality of 0 (min=0) which are not flagged as _Must Support_. A HDDT device data provider MAY omit optional elements from a response to a request. A HDDT device data consumer MAY ignore optional elements included with the response to a request. 

Remark: _Ignoring_ an element means that the element is not interpreted by the device data consumer and does not affect the device data consumer's perception of the semantics of the resource.

### Interactions and Endpoints
HDDT builds upon standard FHIR RESTful interactions on [Observation](https://hl7.org/fhir/R4/observation.html) resources for sharing measured device data. Aggregated reports are shared using dedicated FHIR operations. Access to observational device attributes (e.g. calibration status) is possible through standard FHIR RESTful interactions on [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources. 

This paragraph defines some common definitions that hold for all FHIR RESTful interactions and operations that are used in HDDT.

#### Read Interactions
Endpoints that are required to support the REST interaction __read__ MUST be available under `[BASE_URL]/[resourceType]/[id]`, [as specified in FHIR R4](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions MUST conform to the defined HDDT FHIR Profiles.

#### Search Interactions
Endpoints that are required to support the __search__ interactions MUST allow searching via HTTP GET. Endpoints MAY choose to support search requests via HTTP POST (see [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction)).

For each FHIR resource that is profiled by HDDT, the HDDT specification defines a set of search parameters that MUST be supported by Device Data Recorder actors as device data providers. This ensures that DiGA as device data consumers can rely on certain filter and search functionalities that they MAY need for processing activities on top of this data. In addition, a Device Data Recorder MAY support all other defined standard FHIR search parameters (see [FHIR Search](https://www.hl7.org/fhir/R4/search.html)). 

A Device Data Recorder MUST publish the list of supported search parameters as part of its [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) (see "`/metadata` endpoint" below).

#### Authentication
The DiGA MUST provide an OAuth2 Bearer Token in the HTTP `Authorization` header with each FHIR RESTful interaction or operation request, using the format `Authorization: Bearer <access_token>`. For details on how to obtain an Access Token see [Pairing - Tokens and Token Response](pairing.html#tokens-and-the-token-response).

#### Error Handling

For each FHIR endpoint that a Device Data Recorder MUST support, the respective HDDT specification part lists possible errors. For each error the expected HTTP error code, the type of error, and likely reasons for the occurrence of the error are given.

In case of an error, the Device Data Recorder MUST return the defined HTTP error code. It MUST return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource if `[OperationOutcome]` is specified as the error type by the specification of the affected interaction or operation. The Device Data Recorder SHOULD provide a reason for the error. For this the Device Data Recorder SHOULD either use a coded value in `OperationOutcome.issue.details`, or use the free text input in `ObservationOutcome.issue.diagnostics`. 

### `/metadata` Endpoint
Each Device Data Recorder MUST provide a `/metadata` endpoint to allow a DiGA to obtain the Device Data Recorder's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html).

| | |
|-|-|
| **Endpoint** | `/metadata` |
| **HTTP Method** | GET |
| **Description** | Provides a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) with information about supported FHIR version, resource types, profiles, interactions, search parameters, and filters. |
| **Authentication** | None (public endpoint, no mTLS client authentication) |
| **Returned Objects** | FHIR CapabilityStatement |
| **Specifications** | • FHIR version **MUST** be R4 <br>• Must declare supported FHIR version, resources, operations, search parameters, and profiles. <br> • Supported FHIR Resource types: Device, DeviceMetric, Observation. |
| **Error codes** | `500` (Internal Server Error) |


### Derived Profiles and Extensions 
Manufacturers who implement the HDDT FHIR API with their Health Record MAY implement any FHIR profiles that
* further constrain the HDDT FHIR profiles as long as
    * _Must Support_ elements from the HDDT profile are _mandatory_ or _Must Support_ in the derived profile
    * _Mandatory_ elements from the HDDT profile are still _mandatory_ with the derived profile
* is compliant with the _mandatory_ and _Must Support_ elements of the HDDT profiles. Such profiles MAY further constrain any _optional_ elements from the HDDT profile.

In any case the implementor MUST be aware that a DiGA as the consumer of the HDDT FHIR resources MAY
* ignore any `extension` elements with the resource unless these extensions are defined by the HDDT specification
* throw an error upon receipt of resources that contain `modifierExtension`.

Implementations that regularly trigger errors with a resource consuming DiGA MAY be considered as not compliant with the HDDT specifications. DiGA manufacturers who are affected by such errors MAY request gematik for a renewal of the conformance approval of the resource providing Health Record's HDDT implementation.