The HDDT specification is based on several fundamental decisions intended to reduce complexity and ensure that its
interfaces remain economically viable for manufacturers.

### Holistic Approach

The HDDT solution enables a DiGA to retrieve standardised health data of the same insured person of medical aids and after explicit consent of the insured person - without establishing bilateral contractual relationships between the manufacturers. The system is based on a holistic 4-pillar architectural approach:
- Model: The FHIR-based transmission of health data as [Mandatory Interoperable Values (MIVs)](methodology.html#from-use-cases-to-mivs) in the form of [FHIR Observation resources](https://hl7.org/fhir/R4/observation.html) for vital signs (blood sugar, blood pressure, body temperature) builds upon a comprehensive [information model](information-model.md).
- Components: Five main systems orchestrate the legally compliant data exchange:  [_DiGA Verzeichnis_](registries-and-zts.html#diga-verzeichnis) (BfArM DiGA Directory), [_HiMi-SST-VZ_](registries-and-zts.html#himi-sst-vz) (BfArM Device Directory), [ZTS](registries-and-zts.html#zentraler-terminologieserver) (Central Terminology Server), backend/front-end systems of DiGA, and backend/front-end systems of Device Data Recorders as responsible controllers of the data (see [Logical Building Blocks](logical-viewpoints.html#logical-building-blocks) for details). 
- Interfaces: OAuth 2.0 for [secure authorization](authorization-server.html) combined with [RESTful FHIR APIs](himi-diga-api.html) allow for an interoperable data transfer based on international standards.
- Processes: Three clearly defined main processes - [coupling of the systems](pairing.html) with user consent, [continuous data transmission](retrieving-data.html), and [regular review of authorizations](smart-scopes.html) to use the HDDT FHIR APIs - ensure a legally compliant data exchange.

### Use of International Standards

The key requirement for the Health Device Data Transfer (HDDT) specification is to build on existing international
standards wherever possible. This applies not only to data formats and interfaces, but also to how medical aids and
implants are broken down into abstract components, to the information model behind the exchanged data, to security
services, and to the technical representation of meaningful artifacts.

| Standard       | Use with HDDT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| HL7 FHIR       | The HDDT logical model is fully aligned with a FHIR-compliant [information model](information-model.md). Device data is accessed through FHIR's [read](https://hl7.org/fhir/R4/http.html#read) and [search](https://hl7.org/fhir/R4/http.html#search) interactions. All data exchanged through this API MUST conform to HL7 FHIR R4. HDDT places strong emphasis on compliance with the FHIR base specification and, where possible, with existing FHIR profiles for device data (see [Use of HL7 FHIR](use_of_hl7_fhir.md)). |
| ISO/IEEE 11073 | Properties and configuration settings of Personal Health Devices SHOULD be encoded using ISO/IEEE 11073 nomenclature. The HDDT information model considers the ISO/IEEE 11073 domain models of the devices evaluated during the HDDT MVP phase.                                                                                                                                                                                                                                                                             |
| OAuth2         | The [pairing flow](pairing.md) for authorizing a DiGA to access device data is an implementation of the OAuth2 Code flow with PKCE.                                                                                                                                                                                                                                                                                                                                                                                           |
| SMART on FHIR  | DiGA authorizations are restricted by [SMART Scopes](smart-scopes.html).                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| LOINC          | HDDT [Mandatory Interoperable Values](methodology.md)(MIVs) are mapped onto sets of LOINC codes.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| UCUM           | Units of measures are consistently encoded in UCUM.                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

### Authentication and Authorization 
The HDDT solution design imposes trust as well on the transport layer of communicating IT-systemes as on the application level of a medical aid sharing data with a DiGA. The following principles apply:
- Trust attributes of the technical communication partners are provided by the BfArM via the [_DiGA Verzeichnis_](registries-and-zts.html#diga-verzeichnis) (BfArM DiGA Directory) and the [_HiMi-SST-VZ_](registries-and-zts.html#himi-sst-vz) (BfArM Device Directory). Existing directory processes are reused.
- § 374a SGB V requests DiGA and controllers of medical device data to obtain the patient's explicit consent for data sharing. The HDDT specification mandates that the consent is granted during the [pairing process](pairing.html) but leaves the details on how consent is presented and acknowledged in a GDPR-compliant manner to the manufacturers.  
- Access permissions are granted through [SMART Scopes](smart-scopes.html). These scopes directly map onto FHIR resources but can as well be assessed by the underlying value sets of consented LOINC codes. By this manufacturers can either efficiently use native FHIR stores for their resource servers or enforce the access restrictions using their existing policy decision points.

All flows and interfaces for authorized access to HDDT FHIR resources have been validated for easy implementability using established open-source libraries and tools (HAPI FHIR as [FHIR Resource Server](himi-diga-api.html) and Keycloak for the [OAuth2 Authorization Server](authorization-server.html)).

### Minimization of HDDT-specific Implementation Efforts

Personal Health Devices store their collected data in a Health Record in the device backend. The Health Record collects
measurement data for each patient and acts as a resource server for external parties. It provides interfaces that allow
patients and their physicians to access data through mobile apps or other interactive front-end systems.

The HDDT specification is intended to allow manufacturers of backend systems for Personal Health Devices to extend their existing resource servers' interfaces with
HDDT-specific processes and data models in a straightforward way. Ideally, any required adjustments should be limited to
the syntax of data exchange, without changes to the core architecture that connects the Personal Health Device, the
Aggregation Manager (e.g. the mobile app that controls the device), and the Health Record. To support this, the specification and its non-functional requirements are
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
  data that is processed exclusively on the device or in the Aggregation Manager to the Health Record solely to comply
  with the HDDT specification.

### Role of the Controller

The HDDT specification follows the reference model of
the [Continua Health Alliance](https://www.slideserve.com/kanoa/continua-health-alliance). It assumes that a Personal
Health Device connects to an Aggregation Manager (e.g. a mobile app) that serves as a gateway to the Health Record. In
HDDT, the Aggregation Manager and Health Record together are referred to as the _Device Data Recorder_ (see [Logical Building Blocks](logical-viewpoints.html#logical-building-blocks) for details). The _Device Data Recorder_
provides the FHIR resource server. A DiGA connects to this server to request and obtain data measured by a connected
Personal Health Device.

The _Device Data Recorder_ controls all data and communication flows between the patient’s Personal Health Device and
the Health Record on the backend system. The HDDT specification MUST NOT affect this role. The specification also MUST NOT set requirements for:

* the frequency of data collection on the Personal Health Device
* the method and frequency of synchronization between the Personal Health Device and the Aggregation Manager
* the frequency of data transmission from the Aggregation Manager to the Health Record (e.g. if the Aggregation Manager
  transmits data only once per day, then a DiGA will only be able to access data at that frequency through the HDDT
  interface)
* how the Aggregation Manager handles data from uncalibrated devices (e.g. whether this data is sent to the Health
  Record or not)
* which specific algorithms the _Device Data Recorder_ uses to calculate key figures (e.g. whether an rtCGM includes
  data from its warm-up phase when calculating therapeutic key values such as the Glucose Management Index)
* whether and how the Aggregation Manager pre-processes raw data (e.g. whether outliers are smoothed to produce cleaner
  curves)

### Easy Maintenance and Economical Operations

The HDDT specifications apply to all types of Personal Health Devices and Device Data Recorders. Rules for pairing,
authentication, authorization, and logging are the same for all devices and are therefore provided as one common
technical specification.

The [Mandatory Interoperable Values (MIVs)](methodology.html#from-use-cases-to-mivs) that a resource server exposes to a
DiGA depend on the types of Personal Health Devices connected to it. Each MIV has its own defined data set and rules for
exchange. To help manufacturers identify the relevant requirements, the data set for each MIV is defined individually
and documented in dedicated specification documents. An overview of the defined MIVs by domain, along with their
MIV-specific specification parts, can be found [here](mivs.html).

In HDDT, [slicing](https://hl7.org/fhir/R4/profiling.html#slicing) of FHIR attributes is only applied when all slices
belong to the same type of data. Domain-specific types of data, such as blood glucose and peak expiratory flow, each
always have their own specification documents — even if they differ only by LOINC codes and units. This separation
ensures that future changes affecting one data type do not impact manufacturers of devices for other domains.

§ 374a SGB V requires that aggregated and derived data MUST also be made available through the HDDT interface. In HDDT,
this requirement is limited to data that can be calculated from the MIVs provided by the medical aid. For example, an
rtCGM is only REQUIRED to provide derived values that can be computed from its continuous glucose
measurements ([MIV - Continuous Glucose Measurement](measurement-tissue-glucose.html)). To reduce the workload for
Health Record manufacturers, derived data MUST be provided as standardized reports whenever it is calculated over a
period of time. A DiGA therefore SHALL NOT request a single metric, such as the number of hypoglycemias, but instead
MUST retrieve the full report (e.g. the Ambulatory Glucose Profile (AGP)). Where possible, HDDT adopts existing
specifications for such reports unchanged — for rtCGM data, this includes
the [CGM Summary Observation from HL7 International](https://github.com/HL7/cgm).

The HDDT specification requires that data be exchanged primarily as FHIR resources. Because FHIR clinical resources are
designed for storage and versioning, each resource SHOULD be permanently retrievable under its identifier. In practice,
most Health Records linked to Personal Health Devices store data only for a limited time. HDDT therefore states that
manufacturers MUST NOT extend existing storage periods solely to comply with the specification. However, every
Health Record is assumed to be able to store data for a defined number of days and keep it accessible under a fixed
identifier during that period. This period, called the _Historic-Data-Period_, is defined per MIV based on typical DiGA
use cases and is listed in the MIV-specific specification tables in the chapter [_Mandatory Interoperable Values (MIVS)_](mivs.html).