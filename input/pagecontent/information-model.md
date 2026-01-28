
__Caution__: In HL7 FHIR R4 the definitions of the [Device](https://hl7.org/fhir/R4/device.html) and [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resources are not very clear about the separation between an operational instance of a device and the general description of the product. This has been corrected with R5. In order to be compliant with FHIR R4, R5, and R6 the HDDT information model does not make use of elements, which are not compliant across these releases._ 

<hr>

As depicted in the definition of the [HDDT logical building blocks](logical-viewpoints.html#logical-building-blocks), each medical aid or implant in the sense of § 374a SGB V can be divided into
* __Personal Health Device__: the hardware part including the __sensors__ that measure vital data of the patient
* __Device Data Recorder__: components responsible for accepting, storing and further processing the measured data. The Device Data Recorder consists of
    * __Personal Health Gateway__: an intermediate hardware and/or software that retrieves the sensor data at the patient's or doctor's side and takes care of securely forwarding it to a Health Record
    * __Health Record__: a backend platform that stores the measured data

This logical model builds the foundation of the HDDT FHIR based information model. Every artefact of the logical model is mapped onto a class in the HDDT information model. Each class again can be implemented by a standard FHIR R4 resource definition.

| Logical model        | HDDT information model              | HL7 FHIR R4 Resource Definition | 
|----------------------|-------------------------------------|---------------------------------|
| Personal Health Device      | Personal Health Device<br>Personal Health Device Definition  | [Device](https://hl7.org/fhir/R4/device.html)<br>[DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) |
| sensor / dynamic configuration    | Sensor Type and Calibration Status  | [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)             |
| vital data as measured by the sensor        | Interoperable Value                 | [Observation](https://hl7.org/fhir/R4/observation.html)              |
| Device Data Recorder | Device Data Recorder Definition     | _BfArM internal resource_       |

### Measured Data 

Data which is measured by a Personal Health Device is shared with a DiGA as an __Interoperable Value__. Each __Interoperable Value__ is a FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource that implements a defined __Observation Profile__. These profiles are managed by gematik and made available as FHIR [StructureDefinition](https://hl7.org/fhir/R4/structuredefinition.html) resources on [Simplifier](https://simplifier.net/hddt-workflow). Each such profile constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition to match the requirements and specific characteristics of a defined __Mandatory Interoperable Value (MIV)__. Each __MIV__ is expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) which is managed with the _ZTS_ (German Central Terminology Server). By this, each __Interoperable Value__ is linked with a __MIV__ with respect to its syntax (Observation Profile) and semantics (definition of the MIV).


<figure>
<div class="gem-ig-svg-container" style="width: 60%;">
  {% include HDDT_Informationsmodell_Generisch_MIV.svg %}
  </div>
   <figcaption><em><strong>Figure: </strong>HDDT FHIR Data Model (Values and MIVs)</em></figcaption>
</figure>

<br clear="all"/>

_Remark: In order to keep the UML class diagrams in this section simple and easy to read, not all attributes of the FHIR resources and their HDDT profiles are shown. Only those attributes that are relevant for understanding the HDDT information model are depicted. For the full definitions of the resources please refer to the HDDT profiles in the artifact summary._

Each measured data is described by:
* a LOINC `code` that defines the kind of data, e.g. a blood sugar value measured as mass per volume. This `code` MUST be included with the value set of the MIV that is linked with the [Observation](https://hl7.org/fhir/R4/observation.html)
* a timestamp (`effective[x]`) that marks the time or period at which the measurement was performed
* a `value[x]` that gives the measured value as defined by the `code` including the `unit` of the value and the sample rate (for data streams). The `value` can either be a single point of data, a composite data item, or a sampled stream of data. An example of a single data point is an ad hoc measurement of capillary blood sugar using a blood glucose meter. An example of a composite data item is a blood pressure value made up from systolic and diastolic blood pressure. An example of a stream of data is a sequence of continuous measurements done by a real time Continuous Glucose Monitoring device (rtCGM) during a defined period of time.
* a `status` that signals the status of the `value`; e.g. signaling if a data stream is finalized or not

These four elements are the common defined elements of each HDDT __Observation Profile__ on top of the standard FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition. Further [Observation](https://hl7.org/fhir/R4/observation.html) elements may be constrained by MIV-specific HDDT __Observation Profiles__. This includes even references between interoperable values, e.g. as in the case of lung function testing, where a measured value may refer to another interoperable value as its baseline ("personal best").

Beside single observation data, a Device Data Recorder MUST be able to provide aggregated data in the form of a report. Which reports have to be provided and how these reports are implemented on top of standard FHIR resource definitions is defined per MIV in the HDDT specifications. 

__Example:__ The __MIV__ _Continuous Glucose Measurement_ defines a HDDT __Observation Profile__ for sampled glucose measurements as performed by real-time Continuous Glucose Monitoring devices (rtCGM). For these devices HL7 International defines a summary report, that holds a PDF report together with coded clinical metrics such as times in ranges, glucose management index and data quality indicators. HDDT requests Device Data Recorders to provide a machine-readable subset of this HL7 report as a [HDDT CGM summary report](StructureDefinition-hddt-cgm-summary.html) resource.

While the aggregated data in the glucose example is a Collection [Bundle](https://hl7.org/fhir/R4/bundle.html), other __MIV__'s reports may be implemented as FHIR [DiagnosticReport](https://hl7.org/fhir/R4/diagnosticreport.html)s or other FHIR resources.

Details on the definition of the MIV [ValueSet](https://hl7.org/fhir/R4/valueset.html)s are given at the end of this section. 

### Personal Health Device and Device Data Recorder 

The part of the HDDT information model that is related to the Personal Health Device is implemented using profiles on standard HL7 FHIR resource definitions as shown in the UML class diagram below. Instances of the classes shown in the blue box are used by the DiGA for [retrieving interoperable values](retrieving-data.html) and information about the patient's specific __Personal Health Device__ from the Device Data Recorder.   

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Informationsmodell_Generisch_DevicePart.svg %}
  </div>
  <figcaption><em><strong>Figure: </strong>HDDT FHIR Data Model (Values, Devices, and MIVs)</em></figcaption>
</figure>

<br clear="all"/>

Personal Health Devices need to be calibrated in order to provide safe measurements. Some devices are already calibrated by the manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. Whether a Personal Health Device transmits data from a non-calibrated sensor to the Health Record at all depends on the concrete product. For a DiGA to process measured data in a safe manner, the DiGA must know if the data it received was gathered by a calibrated sensor or not. 

For Personal Health Devices where the sensor that measures the values requires automated or manual calibration, the __Interoperable Value__ MUST refer to the __Sensor Type and Calibration Status__. The Sensor Type and Calibration Status is mapped onto a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which holds calibration information in a `calibration.type`, a `calibration.state` and a `calibration.date` element. In addition, the __Sensor Type and Calibration Status__ can provide a definition of the `unit` that is preferably to be used for presenting measured values to the patient. This `unit` MAY differ from the `unit` that is used with the `value` of the Interoperable Value (which is provided through a backend system).

Example: A rtCGM sensor measures glucose values as _mg/dl_. All data is stored in the Health Record in this unit. The FHIR Resource Server on top of the Health Record provides the data only using _mg/dl_ as the unit. At the mobile app that came with the rtCGM (the rtCGM's Personal Health Gateway) the patient configured the preferred unit as _mmol/l_. Therefore, all data is calculated (by the device or the app) to _mmol/l_ before displaying it to the patient. In this example `value.unit` of the __Interoperable Value__ is _mg/dl_ while _unit_ within __Sensor Type and Calibration Status__ is _mmol/l_. The motivation for this behavior is to allow the DiGA to obtain information about the patient's preference and thus to be in sync with the medical aid by displaying measured values in the same unit.

The __Sensor Type and Calibration Status__ of a measurement refers to the __Personal Health Device__ that contains the sensor. This is a many-to-one relationship which allows for a __Personal Health Device__ to contain multiple sensors for different measured values. E.g. by this a pulse oximeter __Personal Health Device__ can provide _pulse_ and _SPO2_ as two different Interoperable Values with each of these values being linked with a dedicated __Sensor Type and Calibration Status__. 

In cases where no __Sensor Type and Calibration Status__ reference is provided with the measured value, the __Interoperable Value__ directly refers to the __Personal Health Device__ (element `device`).

Each instance of a __Personal Health Device__ is represented by a FHIR [Device](https://hl7.org/fhir/R4/device.html) resource and described by 
* a human readable `devicename` and the name of the `manufacturer`
* its `serialNumber`. This element is flagged as _Must Support_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html#must-support-elements)) and as such MUST be provided by the Device Data Recorder's FHIR Resource Server. This allows the patient to verify that the data processed by the DiGA really originated from the device he is using.
* an `expirationDate` for devices which have a defined end-of-life. An example for this is an rtCGM sensor which only transmits data for 14 or 15 days (depending on the product) and after this is to be replaced by another device.

Each __Interoperable Value__ MUST contain a `device` element (as defined by the FHIR Observation resource). This element is mandatory in HDDT profiles.  It MUST reference either a __Sensor Type and Calibration Status__ or directly a __Personal Health Device__ (exclusive OR). The exclusive choice between these two types of references depends on the device's characteristics: A reference to a __Sensor Type and Calibration Status__ MUST be provided from the observation if the personal health device needs to be calibrated (either automatically or by the user) or changes its calibration status over time. If no direct reference to a __Personal Health Device__ is given from the observation, the __Personal Health Device__ MUST be linked with the __Sensor Type and Calibration Status__. By this, there is always a - direct or indirect - link from any __Interoperable Value__ to the __Personal Health Device__ that originally measured this value. The reasons for this mandatory linking are:
* provenance: the DiGA can always be sure about the full chain of provenance (Personal Health Device -> Device Data Recorder -> DiGA). This information is e.g. needed when a DiGA exports data into the patient's _ePA_ (personal health record).
* patient safety: There may be situations where a value shown in the device app differs from the same data item when shown in a DiGA, e.g. due to different rounding algorithms or data smoothing. In this cases the `serial number` provided with the __Personal Health Device__ resource allows the DiGA and the patient to verify that the processed data really originated from the patient's physical device. 

### BfArM Registries: Device Definitions

___Remark:__ The following definitions about the BfArM Registries only define the logical viewpoint by describing what kind of information manufactures of DiGA and Device Data Recorders can expect to be available at the BfArM registries. The specification of the BfArM Registries and their FHIR RESTful APIs is the responsibility of BfArM and therefore out of scope of the HDDT specification (see [HIIS-API](registries-and-zts.html#hiis-vz) and [DiGA Verzeichnis](registries-and-zts.html#diga-verzeichnis) for references to the BfArM specifications which are needed by manufacturers of DiGA, medical aids and implants for managing and discovering DiGA properties and FHIR DeviceDefinitions for Personal Health Devices and Device Data Recorders)._ 

#### Device Data Recorder Definition
As described in the section on [certification relevant systems](certification-relevant-systems.html), the responsibility for implementing the HDDT API is with a __Device Data Recorder__ who operates the Health Record where measured data is stored and made accessible to authorized DiGA through a FHIR Resource Server. These __Device Data Recorders__ must also register themselves with the _HIIS-VZ_ (BfArM Device Registry) such that a DiGA can e.g. discover the API endpoints of the Device Data Recorder's FHIR Resource Server and OAuth2 Authorization Server. For each __Device Data Recorder__ the HDDT information model incorporates respective resources which are maintained within the _HIIS-VZ_:

* __Device Data Recorder Definition__ (based on FHIR [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html)): 
  * human readable device name and name of the manufacturer of the Device Data Recorder
  * contact data of the owner of the Device Data Recorder
  * additional static properties of the Device Data Recorder that describe how data for a specific MIV is provided to requesting DiGA (see subsection _MIV-Specific Properties of Device Data Recorders_ below)
  * trust anchors for secure pairing and secure communications (see [Security and Privacy](security-and-privacy.html) for details)

* __Device Data Recorder FHIR Endpoint__ (based on FHIR [Endpoint](https://hl7.org/fhir/R4/endpoint.html)): 
  * URL of the FHIR endpoint that a DiGA must call for getting access to the FHIR resources managed by the Device Data Recorder (see previous section). 
  * Fully Qualified Domain Name (FQDN) as stated in the FHIR endpoint's X.509 certificate. This allows a DiGA to securely authenticate the FHIR endpoint.
  
* __Device Data Recorder AuthZ Endpoint__ (based on FHIR [Endpoint](https://hl7.org/fhir/R4/endpoint.html)):
  * URL of the Device Data Recorder's [Authorization Server](authorization-server.html) that must be called for obtaining the access token for getting access to the FHIR API
  * Fully Qualified Domain Name (FQDN) as stated in the AuthZ server's X.509 certificate. This allows a DiGA to securely authenticate the authorization endpoint of the Device Data Recorder.

The links between these resources are maintained within the _HIIS-VZ_ as extensions to the FHIR [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) that represents the Device Data Recorder Definition (see _[HIIS-VZ API](registries-and-zts.html#hiis-vz)_ and [https://simplifier.net/guide/hiis/Home/Informationsmodell.page.md?version=current](https://simplifier.net/guide/hiis/Home/Informationsmodell.page.md?version=current) for details). 

#### MIV-Specific Properties of Device Data Recorders
For each supported MIV, a Device Data Recorder MUST register the following static properties with the _HIIS-VZ_:

| property             | value | comments |
|----------------------|-------|----------|
| Historic-Data-Period | The `Historic Data Period` defines the maximum number of days into the past for which a Device Data Recorder is able to provide data. E.g. if a Device Data Recorder announces a _Historic-Data-Period_ of 30 days, it MUST be able to serve any request for data that was measured within the last 30 days. If a DiGA queries for data that is older than the declared _Historic-Data-Period_, the Device Data Recorder will return a _404 Not Found_ error along with an appropriate [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) describing that the requested data lies outside the supported historic data period. (See [Searching Observations using FHIR-search interactions](retrieving-data.html#searching-observations-using-fhir-search-interactions)). | _Historic-Data-Period_ MUST NOT be shorter than the minimum historic data period defined for the affected MIV (see [MIV profiles](mivs.html) for details). |
| Delay-From-Real-Time | Average number of seconds until data measured by the Personal Health Device is available under normal operational conditions at the Device Data Recorder's FHIR end point. | If a DiGA polls for continuously measured device data in fixed intervals, the _Delay-From-Real-Time_ denotes the overlap of two consecutive intervals in order to catch all measured data. |
| Grace-Period | The _Grace-Period_ defines the number of minutes that a DiGA MUST wait after a previous request for data from the same patient before a new request for data from that patient can be sent to the Device Data Recorder. If a DiGA sends a request for data from a patient before the _Grace-Period_ has elapsed since the last request for that patient, the Device Data Recorder MAY reject the new request. | _Grace-Period_ MUST NOT exceed the maximum grace period defined for the affected MIV (see [MIV profiles](mivs.html) for details).  | 

 A DiGA can retrieve a Device Data Recorder's specific values for these properties per MIV through the BfArM [HIIS-VZ](registries-and-zts.html#hiis-vz) API.

#### Personal Health Device Definition

Owners of medical aids and implants that fall under the regulation of § 374a SGB V must register at the _HIIS-VZ_ (BfArM Device Registry). This leads to a __Personal Health Device Definition__ which is exposed as a [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource. A __Personal Health Device__ resource MAY be linked with a __Personal Health Device Definition__ in the _HIIS-VZ_ through the `Device.definition` element.

___Note__: The reference from a __Personal Health Device__ to its __Personal Health Device Definition__ is optional for the initial version of the HDDT specification because the Personal Health Device Definition resource does not hold use case relevant information which could not as well be placed in the Device resource (e.g. name and manufacturer of the medcal aid or implant). If a Device resource refers to a Device Definition, this reference MUST point to the respective Personal Health Device Definition entry in the BfArM HIIS VZ._ 

The __Personal Health Device Definition__ resource for a medical aid or implant is created upon registration of this medical aid or implant with the _HIIS-VZ_. The information bound to this [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource include
* a human readable `deviceName` 
* the name of the `manufacturer` of the device
* the `type` of the device given as a SNOMED CT or ISO/IEEE 11073-10101:2020 code

A Personal Health Device may connect to different __Device Data Recorders__. E.g. a manufacturer of a blood glucose meter may support different diabetes management platforms of different partners that can all import data from the glucose meter. Each of these solutions may have its own Personal Health Gateway and Health Record (e.g. a SmartPen that can be linked to diabetes diary apps from many different vendors). All of these Device Data Recorders must be able to provide imported blood glucose values to DiGA via the HDDT API (see [certification relevant systems](certification-relevant-systems.html)). By this there is a many-to-many relationship between Personal Health Devices and Device Data Recorders. 

#### DiGA Definition
While DiGA use the _[HIIS-VZ RESTful API](registries-and-zts.html#hiis-vz)_ for retrieving information about registered __Personal Health Devices__ and __Device Data Recorders__, the manufacturers of Device Data Recorders may use the API of the BfArM _[DiGA Verzeichnis](registries-and-zts.html#diga-verzeichnis)_ (BfArM DiGA Registry) for retrieving information about a DiGA that wants to connect to a devive through the HDDT API. This API gives access to __DiGA Device Definition__ data which was provided by DiGA manufacturers to BfArM during registration with the _[DiGA-Verzeichnis](https://diga.bfarm.de/de/verzeichnis)_. 

#### HDDT Information Model - Devices and Device Definitions
The orange box in the class diagram below shows the classes of the HDDT information model which are managed with the BfArM Registries. Correlations and dependencies between objects which are managed by the BfArM Registries are shown as dotted lines as it is the responsibility of BfArM to define the respective extensions to the standard FHIR resource types (see [https://simplifier.net/guide/hiis/Home/Informationsmodell.page.md?version=current](https://simplifier.net/guide/hiis/Home/Informationsmodell.page.md?version=current) for the current version of the _HIIS-VZ_ information model) 

<figure> 
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Informationsmodell_Generisch_Device_and_Definition.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT FHIR Data Model (Devices and Device Definitions)</em></figcaption>
</figure>

<br clear="all"/>

### MIVs

As written in the beginning of this section, a _MIV_ is technically expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) of LOINC observation codes. Each code in a MIV matches the conceptual definition of the _MIV_ and therefore is usable for the intended purposes of a DiGA when processing that _MIV_. Each MIV's [ValueSet](https://hl7.org/fhir/R4/valueset.html) is defined by:
* a `description` that normatively describes the properties and purposes of the MIV
* a canonical `url` as a unique identifier that can be used for referencing the [ValueSet](https://hl7.org/fhir/R4/valueset.html) in the HDDT specification and in BfArM registry entries. 
* a business `version` number that allows MIV value sets to evolve over time (e.g. adding new LOINC codes or splitting MIVs). 
* a human-understandable `title` and a machine-friendly `name`. 
* an extensional list of the LOINC codes that make up the _MIV_.

`url` and `version` together are an unambiguous and widely usable identifier for a _MIV_ [ValueSet](https://hl7.org/fhir/R4/valueset.html). 

Most of the previously introduced classes of the HDDT information model hold references to a _MIV_ as a whole or to a code from a _MIV's_ [ValueSet](https://hl7.org/fhir/R4/valueset.html):

| HDDT class                          | MIV/code reference | FHIR resource and element |
|-------------------------------------|--------------------|---------------------------|
| Interoperable Value                 | The `code` element signals the _MIV_ of the value. The `code` MUST be included with the _MIV's_ value set. | `Observation.code` |
| Personal Health Device Definition | For each registered Personal Health Device the BfArM keeps a list of the supported _MIVs_.  | _BfArM internal reference_ |
| Device Data Recorder Definition | For each Device Data Recorder the BfArM keeps a list of the supported _MIVs_. | _BfArM internal reference_ |
| DiGA Definition | For each DiGA the BfArM keeps a list of the _MIVs_ that this DiGA may process for its intended purposes. | _BfArM internal reference_ |

All FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that represent the defined _MIVs_ are managed within the _ZTS_ (German Central Terminology Service). DiGA vendors and providers of Device Data Recorders can download all _MIV_ value sets as FHIR packages through a standard API (see section [_ZTS_](registries-and-zts.html#zentraler-terminologieserver) for details).

The UML class diagram below shows the full HDDT information model. The resources in the blue box are managed by the Device Data Recorder and can be accessed by DiGA via the Device Data Recorder's FHIR Resource Server. The resources in the orange box reflect the contents of the BfArM registries (Device Registry and DiGA Registry). They can be accessed by DiGA through the BfArM _[HIIS-VZ API](registries-and-zts.html#hiis-vz)_ and BfARM _[DiGA Verzeichnis API](registries-and-zts.html#diga-verzeichnis)_. The green box marks the _[ZTS](registries-and-zts.html#zentraler-terminologieserver)_ (German Central Terminology Service) that maintains the definitions and encodings of all _MIVs_. The [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that span the single _MIVs_ can be obtained from this service through a standard RESTful API. The yellow box holds the FHIR Observation Profiles defined for the MIVs and the FHIR profiles for aggregated reports on top of defined MIVs. Upon final approval, these profiles will be made available by gematik on [Simplifier](https://simplifier.net/hddt-workflow).

<figure>
<div class="gem-ig-svg-container" style="width: 100%;">
  {% include HDDT_Informationsmodell_Generisch_Complete.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT FHIR Data Model (complete)</em></figcaption>
</figure>

<br clear="all"/>
