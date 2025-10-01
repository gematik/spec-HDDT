
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
The elements defined within the HDDT FHIR profiles consist of _Mandatory_, _Must Support_ and _Optional_ elements. This section defines, how resource servers as device data providers and DIGA as device data consumers MUST process _Mandatory_, _Must Support_ and _Optional_ elements. Basis for these definitions are the [HL7-D Best Practices for Profiling FHIR](https://simplifier.net/guide/Best-Practice-bei-der-Implementierung-und-Spezifizierung-mit-HL7/%C3%9Cbersicht/Spezifikation/Profilierung?version=current).

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


### Using Existing and Derived Profiles  
Manufacturers who implement the HDDT FHIR API MAY use any FHIR profile that is compliant with the _mandatory_ and _Must Support_ elements of the HDDT profiles. Such profiles MAY further constrain any _optional_ elements from the HDDT profile.

Manufacturers who implement the HDDT FHIR API MAY use any FHIR profiles that further constrain the HDDT FHIR profiles as long as
* _Must Support_ elements from the HDDT profile are _mandatory_ or _Must Support_ in the derived profile
* _Mandatory_ elements from the HDDT profile are still _mandatory_ with the derived profile

When using derived or compliant profiles, the manufacturer MAY include a respective `meta.profile` reference with a resource instance. A DiGA MAY ignore such `meta.profile` references. A DiGA MUST always validate received resources against the HDDT profile regardless of value of the `meta.profile` element.

In addition, the implementor of a HDDT profile MUST be aware that a DiGA as the consumer of the HDDT FHIR resources
* MAY ignore any `extension` elements with the resource unless these extensions are defined by the HDDT specification
* MUST throw an error upon receipt of resources that contain `modifierExtension` that the DiGA is not ableto interpret.

Implementations that regularly trigger errors with a resource consuming DiGA MAY be considered as not compliant with the HDDT specifications. DiGA manufacturers who are affected by such errors MAY request gematik for a renewal of the conformance approval of the resource providing Health Record's HDDT implementation.


### Compatibility of the HDDT FHIR Profiles

While deriving FHIR profiles from the assessed use cases (see [methodology](methodology.html)), existing profiles from other countries and organizations have been considered in order to be as compliant as possible with existing solutions. 

| HDDT FHIR profile | international profile  | HDDT compliance statement |
|-------------------|-----------------|---------|
| blood glucose measurement ([Observation](https://hl7.org/fhir/R4/observation.html)) | [UK Core Observation Blood Glucose](https://simplifier.net/hl7fhirukcorer4/ukcore-observation-bloodglucose) | UK Core allows only SNOMED CT for the `Observation.code` element while HDDT only allows LOINC. <br>`Observation.device` is optional for UK Core. |
| | [US Core R4 Observation](https://hl7.org/fhir/us/core/STU4/Observation-blood-glucose.json.html) | fully compliant except that `Observation.device` is mandatory with HDDT. |
| | [International Patient Summary: Observation Results](https://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition-Observation-results-uv-ips.html) | `Observation.device` is optional for IPS. Other derivations are minor issues that do not affect the compatibility with HDDT blood sugar measurements: IPS only allows for _final_ as an observation's `status`. IPS allows for explicitly missing effective[x] elements using an extension. |
| | [Clinivault Observation](https://simplifier.net/clinivault/example-10) (India) | fully compliant except that `Observation.device` is mandatory with HDDT. |
| | [KBV Basisprofile](https://simplifier.net/base1x0/kbv_pr_base_observation_glucose_concentration) (Germany) | `Observation.device` is mandatory with HDDT. HDDT only allows for a single `Observation.code` while KBV requests two (LOINC and SCT). |
| | [ISiKLebensZustand](https://simplifier.net/guide/isik-basis-stufe-5/Einfuehrung/Artefakte/Datenobjekte_Lebenszustand?version=5.0.0) (Germany) | `Observation.device` is mandatory with HDDT. HDDT only allows for a single LOINC `code` while ISiK allows for an additional SCT code. ISiK sets `Observation.value[x]`to [1..1], while HDDT allows for values to be absent. |
| | [Finnish PHR Blood Glucose Profile](https://simplifier.net/digious-fi/fiphrsdbloodglucose) | Finnish PHR allows for LOINC Codes which are not part of the HDDT MIVs. Finnish PHR disallows `Observation.device` which is mandatory for HDDT.  |
| CGM summary report ([Bundle](https://hl7.org/fhir/R4/bundle.html)) | [HL7 CGM IG](https://github.com/HL7/cgm) | The HDDT _cgm summary report_ capsuled with the FHIR bundle is fully compliant with the machine readable part of the HL7 CGM IG (_CGMSummaryObservation_ profile). |
| ISF glucose measurement ([Observation](https://hl7.org/fhir/R4/observation.html)) || _Recently there seem to be no dedicated profiles available for capturing continuous glucose monitoring (CGM) raw data as FHIR SampledData. Available CGM profile either only cover key values (see [HL7 CGM IG](https://github.com/HL7/cgm)) or provide one Observation resource per data point. The later approach was discarded due to severe efficiency problems with modern CGM with sample rates of up to one value per minute._ |

As can bee seen in the table, the only derivation from existing profiles is that HDDT makes the `Observation.device` element mandatory with raw glucose measurement data. The reason for this is to address specific patient safety issues which arise from the specific HDDT use cases:
* neither DiGA nor the medical aids' backend systems do securely identify the patient. They just match authenticated patient accounts. Therefore the `Device.serialNumber` as provided with a [Device](https://hl7.org/fhir/R4/device.html) resource is the only identifier that allows the patient to verify that data originated from his personal health device.
* DiGA can be medical devices of MDR class IIa or even MDR class IIb that process medical data for therapeutic purposes, e.g. including the adaptation of insulin correction factors. For this a DiGA MUST be able to verify that data comes from a calibrated system. The respective information is only available through the [DeviceMetric](https://hl7.org/fhir/R4/observation.html) resource.
