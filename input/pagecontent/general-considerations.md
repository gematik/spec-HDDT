The HDDT specification is based on several fundamental decisions intended to reduce complexity and ensure that its
interfaces remain economically viable for manufacturers.

### Holistic Approach

The HDDT solution enables a DiGA to retrieve standardised health data of the same patient from medical aids and implants - after explicit consent of the patient - without establishing bilateral contractual relationships between the manufacturers. The system is based on a holistic 4-pillar architectural approach:
- Model: The FHIR-based transmission of health data in the form of [FHIR Observation resources](https://hl7.org/fhir/R4/observation.html) for vital signs (blood sugar, blood pressure, body temperature) builds upon a comprehensive [information model](information-model.html) which can be tailored for specific [Mandatory Interoperable Values (MIVs)](methodology.html#from-use-cases-to-mivs).
- Components: Five main systems orchestrate the legally compliant data exchange:  [_DiGA Verzeichnis_](registries-and-zts.html#diga-verzeichnis) (BfArM DiGA Registry), [_HIIS-VZ_](registries-and-zts.html#hiis-vz) (BfArM Device Registry), [_ZTS_](registries-and-zts.html#zentraler-terminologieserver) (Central Terminology Server), backend/front-end systems of DiGA, and backend/front-end systems of Device Data Recorders as responsible controllers of the data (see [Logical Building Blocks](logical-viewpoints.html#logical-building-blocks) for details). 
- Interfaces: OAuth 2.0 for [secure authorization](authorization-server.html) combined with [RESTful FHIR APIs](ddr-diga-api.html) allow for an interoperable data transfer based on international standards.
- Processes: Three clearly defined main processes - [pairing of the systems](pairing.html) with user consent, [continuous data transmission](retrieving-data.html), and [regular review of authorizations](security-and-privacy.html#obligations-for-regular-inspections) to use the HDDT FHIR APIs - ensure a legally compliant data exchange.

### Use of International Standards

The key requirement for the Health Device Data Transfer (HDDT) specification is to build on existing international
standards wherever possible. This applies not only to data formats and interfaces, but also to how medical aids and
implants are broken down into abstract components, to the information model behind the exchanged data, to security
services, and to the technical representation of meaningful artifacts.

| Standard       | Use with HDDT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| HL7 FHIR       | The HDDT logical model is fully aligned with a FHIR-compliant [information model](information-model.html). Device data is accessed through FHIR's [read](https://hl7.org/fhir/R4/http.html#read) and [search](https://hl7.org/fhir/R4/http.html#search) interactions. All data exchanged through this API MUST conform to HL7 FHIR R4. HDDT places strong emphasis on compliance with the FHIR base specification and, where possible, with existing FHIR profiles for device data (see [Use of HL7 FHIR](use_of_hl7_fhir.html)). |
| SNOMED CT | Properties and configuration settings of Personal Health Devices MUST be encoded using SNOMED CT codes.                                                                                                                                                                                                                                                                            |
| OAuth2         | The [pairing flow](pairing.html) for authorizing a DiGA to access device data is an implementation of the OAuth2 Code flow with PKCE.                                                                                                                                                                                                                                                                                                                                                                                           |
| SMART on FHIR  | HDDT makes use of SMART 2.0 "Finer-grained resource constraints" and SMART 2.0 "patient-specific-scopes" for access permissions to FHIR resources (see [SMART Scopes](smart-scopes.html)).                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| LOINC          | HDDT [Mandatory Interoperable Values](methodology.html) (MIVs) are mapped onto sets of LOINC codes.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| UCUM           | Units of measures are consistently encoded in UCUM.                                                                                                                                                                                                                                                                                                                                                                                                                                                             |

### Trust Model

The HDDT solution design imposes trust as well on the transport layer of communicating IT-systems as on the application level of a medical aid sharing data with a DiGA. The following principles apply:
- Trust attributes of the technical communication partners are provided by the BfArM via the [_DiGA Verzeichnis_](registries-and-zts.html#diga-verzeichnis) (BfArM DiGA Directory) and the [_HIIS-VZ_](registries-and-zts.html#hiis-vz) (BfArM Device Registry). Existing directory processes are reused.
- § 374a SGB V requests DiGA and controllers of medical device data to obtain the patient's explicit consent for data sharing. The HDDT specification mandates that the consent is granted during the [pairing process](pairing.html) but leaves the details on how consent is presented and acknowledged in a GDPR-compliant manner to the manufacturers.  
- Access permissions are granted through [SMART Scopes](smart-scopes.html). These scopes directly map onto FHIR resources but can as well be assessed by the underlying value sets of consented LOINC codes. By this manufacturers can either efficiently use native FHIR stores for their resource servers or enforce the access restrictions using their existing policy decision points.

All flows and interfaces for authorized access to HDDT FHIR resources have been validated for easy implementability using established open-source libraries and tools (HAPI FHIR as [FHIR Resource Server](ddr-diga-api.html) and Keycloak for the [OAuth2 Authorization Server](authorization-server.html)).

### Minimization of HDDT-specific Implementation Efforts

Personal Health Devices store their collected data in a Health Record in the device backend. The Health Record collects
measurement data for each patient and acts as a resource server for external parties. It provides interfaces that allow
patients and their physicians to access data through mobile apps or other interactive front-end systems.

The HDDT specification is intended to allow manufacturers of backend systems for Personal Health Devices to extend their existing resource servers' interfaces with
HDDT-specific processes and data models in a straightforward way. Ideally, any required adjustments should be limited to
the syntax of data exchange, without changes to the core architecture that connects the Personal Health Device, the
Personal Health Gateway (e.g. the mobile app that controls the device), and the Health Record. To support this, the specification and its non-functional requirements are
based on the following principles:

* HDDT
  follows [HL7-D best practices for profiling](https://simplifier.net/guide/Best-Practice-bei-der-Implementierung-und-Spezifizierung-mit-HL7/%C3%9Cbersicht/Spezifikation/Profilierung?version=current)
  FHIR resource definitions. The standard itself serves as the basis for all documentation, and profiling or restricting
  standard elements is done only when necessary to ensure interoperability. For cardinalities, [_Must
  Support_](use_of_hl7_fhir.html#mandatory-must-support-and-optional-elements) semantics are preferred over hard
  constraints to give Health Record providers maximum flexibility. Any elements that modify data are either restricted
  or marked as [_Must Support_](use_of_hl7_fhir.html#mandatory-must-support-and-optional-elements).
* The resource server SHOULD remain free to
  provide [_optional_ elements](use_of_hl7_fhir.html#mandatory-must-support-and-optional-elements) for a HDDT FHIR resource, even if a
  DiGA MAY ignore them. This approach allows a resource server to reuse FHIR profiles that are already implemented in
  other contexts.
* Only data that is managed in the Health Record is affected by the HDDT interface. Manufacturers SHOULD NOT forward
  data that is processed exclusively on the device or in the Personal Health Gateway to the Health Record solely to comply
  with the HDDT specification.

### Role of the Controller

The HDDT specification follows the reference model of
the [Continua Health Alliance](https://www.slideserve.com/kanoa/continua-health-alliance), which is also adopted by the [HL7 Personal Health Device WG](https://hl7.org/fhir/uv/phd/index.html). This model defines that a Personal
Health Device connects to a Personal Health Gateway (e.g. a mobile app) that serves as a gateway to the Health Record. In
HDDT, the Personal Health Gateway and Health Record together are referred to as the _Device Data Recorder_ (see [Logical Building Blocks](logical-viewpoints.html#logical-building-blocks) for details). The _Device Data Recorder_
provides the FHIR resource server. A DiGA connects to this server to request and obtain data measured by a connected
Personal Health Device.

The _Device Data Recorder_ controls all data and communication flows between the patient’s Personal Health Device and
the Health Record on the backend system. The HDDT specification MUST NOT affect this role. The specification also MUST NOT set requirements for:

* the frequency of data collection on the Personal Health Device
* the method and frequency of synchronization between the Personal Health Device and the Personal Health Gateway
* the frequency of data transmission from the Personal Health Gateway to the Health Record (e.g. if the Personal Health Gateway
  transmits data only once per day, then a DiGA will only be able to access data at that frequency through the HDDT
  interface)
* how the Personal Health Gateway handles data from uncalibrated devices (e.g. whether this data is sent to the Health
  Record or not)
* which specific algorithms the _Device Data Recorder_ uses to calculate clinical metrics (e.g. whether an rtCGM includes
  data from its warm-up phase when calculating values such as the Glucose Management Index)
* whether and how the Personal Health Gateway pre-processes raw data (e.g. whether outliers are smoothed to produce cleaner
  curves)

### Easy Maintenance and Economical Operations

The HDDT specifications apply to all types of Personal Health Devices and Device Data Recorders. Rules for pairing,
authentication, authorization, and logging are the same for all devices and are therefore provided as one common
technical specification.

The [Mandatory Interoperable Values (MIVs)](methodology.html#from-use-cases-to-mivs) that a resource server exposes to a
DiGA depend on the types of Personal Health Devices connected to it. Each MIV has its own defined data set and rules for
exchange. To help manufacturers identify the relevant requirements, the data set for each MIV is defined individually
and documented in dedicated sections of the HDDT specification. An overview of the defined MIVs by domain, along with their
MIV-specific specification parts, can be found [here](mivs.html).

In HDDT, [slicing](https://hl7.org/fhir/R4/profiling.html#slicing) of FHIR attributes is only applied when all slices
belong to the same type of data. Domain-specific types of data, such as blood glucose and peak expiratory flow, each
always have their own definitions of the [FHIR Observation resource](https://hl7.org/fhir/R4/observation.html) type — even if they differ only by LOINC codes and units. This separation
ensures that future changes affecting one data type do not impact manufacturers of devices for other domains.

§ 374a SGB V requires that aggregated data from Personal Health Devices MUST also be made available through the HDDT interface. For example, a Device Data Recorder for a real-time Continuous Glucose Monitoring device (rtCGM) MUST provide values that can be computed from the continuously measured glucose values. Which values are to be provided is normatively defined on a per-MIV basis in the respective MIV-specific specification parts (see [Mandatory Interoperable Values (MIVs)](mivs.html)). To reduce the workload for manufacturers of Device Data Recorders, the HDDT allows for aggregated data to be provided as standardized reports. By this, Device Data Recorders can calculate all requested clinical metrics at once instead of parsing through the same data series multiple times for serving requests for single clinical metrics. Consequently HDDT does not provide APIs to DiGA for requesting single clinical metrics which are computed from sampled data, such as the number of hypoglycemic episodes or a the average glucose value. Such values MUST only be provided as part of structured reports consisting of multiple clinical metrics. Where possible, HDDT adopts existing specifications for such reports — e.g. for rtCGM data, the [HDDT CGM summary report](StructureDefinition-hddt-cgm-summary.html) is a subset of the [HL7 CGM Summary Profile](https://github.com/HL7/cgm).

The HDDT specification requires that data be exchanged primarily as FHIR resources. Because FHIR clinical resources are
designed for storage and versioning, each resource SHOULD be permanently retrievable under its identifier. In practice,
most Health Records linked to Personal Health Devices store data only for a limited time. HDDT therefore states that
manufacturers MUST NOT extend existing storage periods solely to comply with the specification. However, every
Health Record is assumed to be able to store data for a defined number of days and keep it accessible under a fixed
identifier during that period. This period, called the _Historic-Data-Period_, is defined per MIV based on typical DiGA
use cases and is listed in the MIV-specific specification tables in the chapter [_Mandatory Interoperable Values (MIVS)_](mivs.html).