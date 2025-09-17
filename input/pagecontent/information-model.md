
___Caution__: In HL7 FHIR R4 the definitions of the [Device](https://hl7.org/fhir/R4/device.html) and [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resources are not very clear about the separation between an operational instance of a device and the general description of the product. This has been corrected with R5. In order to be compliant with FHIR R4, R5, and R6 the HDDT information model does not make use of elements, which are not compliant accross these releases. This especially affects the binding of the device data recorder's FHIR endpoint to the definition of the device data recorder._ 

<hr>

As depicted in the definition of [certification relevant systems](certification-relevant-systems.html), each medical aid or implant can be divided into
* __personal device__: the hardware part including the __sensors__ that measure __patient data__ (e.g. vital signs)
* __device data recorder__: components responsible for accepting, storing and further processing the device data. The device data recorder consists of
    * __aggregation manager__: an intermediate hardware and/or software that retrieves the sensor data at the patient's or doctor's side and takes care of securely forwarding it to a health record
    * __health record__: a backend platform that stores the device data

This logical model builds the foundation of the HDDT FHIR based information model. Every artefact of the logical model is mapped onto a class in the HDDT information model. Each class again can be implemented by a standard FHIR R4 resource definition.

| Logical model        | HDDT information model              | HL7 FHIR R4 Resource Definition | 
|----------------------|-------------------------------------|---------------------------------|
| personal device      | Personal Health Device<br>Personal Health Device Definition  | [Device](https://hl7.org/fhir/R4/device.html)<br>[DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) |
| sensor               | Sensor Type and Calibration Status  | [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)             |
| patient data         | Interoperable Value                 | [Observation](https://hl7.org/fhir/R4/observation.html)              |
| device data recorder | Device Data Recorder Definition     | _BfArM internal resource_       |

### Measured Data 

Data which is measured by a Personal Health Device is shared with a DiGA as an __Interoperable Value__. Each __Interoperable Value__ is a FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource that implements a defined __Observation Profile__. These profiles are managed by gematik and made available as FHIR [StructureDefinition](https://hl7.org/fhir/R4/structuredefinition.html) resources on Simplifier. Each such profile constraints the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition to match the requirements and specialities of a defined __Mandatory Interoperable Value (MIV)__. Each __MIV__ is expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) which is managed with the German Central Terminology Server (ZTS). By this, each __Interoperable Value__ is linked with a __MIV__ with respect to its syntax (Observation Profile) and semantics (defintion of the MIV).

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_MIV.svg" style="width: 100%;" />
</div>

Each measured data is described by:
* a LOINC `code` that defines the kind of data, e.g. a blood sugar value measured as mass per volume. This `code` MUST be included with the value set of the MIV that is linked with the [Observation](https://hl7.org/fhir/R4/observation.html)
* a timestamp (`date[x]`) that marks the time or period at which the measurement was performed
* a `value[x]` that gives the measured value as defined by the `code` including the `unit` of the value and the sample rate (for data streams). The `value` can either be a single point of data or a sampled stream of data. An example of a single data point is an ad hoc measurement of capillary blood sugar using a blood glucose meter. An example of a stream of data is a sequence of continuous measurements done by a real time Continuous Glucose Monitoring device (rtCGM) during a defined period of time.
* a `status` that signals the status of the `value`; e.g. signaling if a data stream is finalized or not

These four elements are the common defined elements of each HDDT __Observation Profile__ on top of the standard FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition. Further [Observation](https://hl7.org/fhir/R4/observation.html) elements may be constrained by MIV-specific HDDT __Obeservation Profiles__. 

Beside single observation data, a device data recorder must be able to provide aggregated and derived data in the form of a report. Which reports have to be provided and how these reports are implemented on top of standard FHIR resource definitions is defined per MIV in the HDDT specifications. 

__Example:__ The __MIV__ _ISF Glucose Sampled Value_ defines a HDDT __Observation Profile__ for sampled glucose measurements as performed by real-time Continuous Glucose Monitoring (rtCGM). For these devices HL7 International defines a summary report, that holds a PDF report together with coded key figures such as times in ranges, glucose management index and data quality indicators. HDDT requests device data recorders to implement the machine readable part of this HL7 report as aggregated data for the __MIV__ _ISF Glucose Sampled Value_.

While the aggregated data in the glucose example is a profile on top of FHIR [Observation](https://hl7.org/fhir/R4/observation.html), other __MIV__'s reports may be implemented as FHIR [DiagnosticReport]s(https://hl7.org/fhir/R4/diagnosticreport.html) or other FHIR resources.

Details on the definition of the MIV [ValueSet](https://hl7.org/fhir/R4/valueset.html) are given at the end of this section. 

### Personal Health Device and Device Data Recorder 

The part of the HDDT information model that is related to the Personal Health Device is implemented using standard HL7 FHIR resource definitions as shown in the UML class diagram below. Instances of the classes shown in the light blue box are used by the DiGA for [retrieving device data](retrieving-data.html) and data about the status and properties of the __Personal Health Device__ from the device data recorder.   

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_DevicePart.svg" style="width: 100%;" />
</div>

Medical aids need to be calibrated in order to provide safe measurements. Some aids are already calibated by the manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. If a medical aid transmits data from a non calibrated sensor to the health record at all depends on the concrete product. For a DiGA to process device data in a safe manner, the DIGA must know if the data it received was gathered by a calibrated sensor or not. 

For devices where the sensor that measured the value requires automated or manual calibration, the __Interoperable Value__ MUST refer to the __Sensor Type and Calibration Status__. The sensor type and calibration status is mapped onto a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which holds calibration information in a `calibration.type`, a `calibration.state` and a `calibration.date` element. In addition the __Sensor Type and Calibration Status__ can provide a definition of the `unit` that is preferrably to be used for presenting measured values to the patient. This `unit` MAY differ from the `unit` that is used with the `value of the Interoperable Value (which is provided through a backend system).

Example: A rtCGM sensor measures glucose values as _mg/dl_. All data is stored in the health record in this unit. The HDDT API at the health record provides the data only using _mg/dl_ as the unit. At the mobile app that came with the rtCGM (the rtCGM's aggregation manager) the patient configured the preferred unit as _mmol/l_. Therefore all data is calculated (by the device or the app) to _mmol/l_ before displaying it to the patient. In this example `value.unit` of the __Interoperable Value__ is _mg/dl_ while _unit_ within __Sensor Type and Calibration Status__ is _mmol/l_. The motivation for this behaviour is to allow the DiGA to obtain information about the patient's preference and thus to be in sync with the medical aid by displaying measured values in the same unit.

The __Sensor Type and Calibration Status__ of a measurement refers to the __Personal Health Device__ that contains the sensor. This is a many-to-one relationship which allows for a personal device to contain multiple sensors for different measured values. E.g. by this a pulseoximeter __Personal Health Device__ can provide _pulse_ and _SPO2_ as two diffferent interoperable values with each of this values being linked with a dedicated __Sensor Type and Calibration Status__. 

In cases where no __Sensor Type and Calibration Status__ reference is provided with the measured value, the __Interoperable Value__ directly refers to the __Personal Health Device__ (element `device`).

Each instance of a __Personal Health Device__ is represented by a FHIR [Device](https://hl7.org/fhir/R4/device.html) resource and described by 
* a human readable `devicename` and the name of the `manufacturer`
* its `serialNumber`. This element is flagged as _Must Support_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html#must-support-elements)) and as such MUST be provided by the medical device through the health record. This allows the patient to verify that the data processed by the DiGA really originated from the device he is using.
* an `expirationDate` for devices which have a defined end-of-life. An example for this is an rtCGM sensor which only transmits data for 14 or 15 days (depending on the product) and after this is to be replaced by another device.
* further `property` elements may be defined by the HDDT specification to cover specific configuration settings of specific decvice types, e.g. the unit configured by the patient to be used for displaying data on the device display.

Each __Interoperable Value__ MUST either hold a reference to a __Sensor Type and Calibration Status__ or to a __Personal Health Device__ (eXclusive OR). A reference __Sensor Type and Calibration Status__ MUST be provided from the observation if the personal health device needs to be calibrated (either automatocally or by the user) or changes its calibration status over time. If no direct reference to a __Personal Health Device__ is given from the observation, the to a __Personal Health Device__ MUST be linked with the __Sensor Type and Calibration Status__. By this, there is alway a - direct or indirect - link from any __Interoperable Value__ to the __Personal Health Device__ that originaly measured this value. The reason for this mandatory linking are:
* provenance: the DiGA can always be sure about the full chain of provenance (device -> device data recorder -> DiGA). This information is e.g. needed when a DiGA exports data into the patient's personal health record.
* patient safety: There may be situations where a value shown in the device app differs from the same data item when shown in a DiGA, e.g. due to different rounding algorithms or data smooting. In this cases the `serial number`provided with the __Personal Health Device__ resource allows the DiGA and the patient to verify that the processed data really originated from the patient's pyhsical device. 

### BfArM Registries

___Remark:__ The following definitions about the BfArM Registries only define the external viewpoint. The information modell focusses on what kind of information DiGA and device manufactures can expect to be available at the BfArM registries. The information model does not make any assumptions on how this information will be exposed (except for the __Personal Health Device Definition__). APIs for accessing information about registered devices and DIGA will be defined by BfArM in a separat specification (see [BfArM Device Directory API](himi-vz-api.html) and [BfArM DiGA Directory API](diga-vz-api.html) for details)._ 

Owners of medical aids and implants that fall under the regulation of § 374a SGB V must register at the BfArM device registry. This leads to a __Personal Health Device Definition__ which is exposed as a [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource. Each __Personal Health Device__ can be linked with a __Personal Health Device Definition__ in the BfArM Device Registry through the `Device.definition' element.

The __Personal Health Device Definition__ resource for a medical aid or implant is created upon registration of this medical aid or implant with the BfArM Device Registry. The information bound to this resource include
* a human readable `deviceName` and the name of the `manufacturer`
* the `type` of the device given as a SNOMED CT or ISO/IEEE 11073-10101:2020 code
* additional static properties (`property`) of the product. An example is the size of the device's internal buffer that can temporarely store measured data in case the device is not connected to the device data recorder.

The `type` code is fixed per device type. It is defined as part of the MIV-specific FHIR implementation guides. HL7 FHIR R4 does not give guidance on how _properties_ are to be defined and encoded. The HDDT specification will therefore as much as possible rely on device properties as defined in device-specific ISO/IEEE-11073 domain models.

As described in the section on [certification relevant systems](certification-relevant-systems.html), the responsibility for implementing the HDDT API is with a __Device Data Recorder__ who operates the health record where measured data is stored and accessible to authorized DiGA. These __Device Data Recorders__ must as well register themselves with the DiGA Device Registry such that a DiGA can e.g. discover the endpoints of the health record's FHIR and Authorization APIs. For each __Device Data Recorder__ the HDDT information model incorporates respective resources which are maintained within the BfArM Device Registry:

* __Device Data Recorder Definition__: 
  * human readable device name and name of the manufacturer of the device data recorder
  * contact data of the owner of the device data recorder, e.g. to allow a DiGA manufacturer to check for testing capabilities 
  * additional static properties of the decvice data recorder platform (e.g. the frequencey the device data recorder's health record synchronizes with the aggregation manager)   

* __Device Data Recorder FHIR Endpoint__: 
  * URL of the FHIR endpoint that a DiGA must call for getting access to the FHIR resources managed by the device data recorder (see previous section). 
  * Fully Qualified Domain Name (FQDN) as stated in the FHIR endpoint's X.509 certificate. This allows a DIGA to securely authenticate the FHIR endpoint.
  
*__Device Data Recorder AuthZ Endpoint__:
  * URL of the device data recorder's Authorization Server that must be called for obtaining the access token for getting access to the FHIR API (see [OAuth API](oauth-api.html))
  * Fully Qualified Domain Name (FQDN) as stated in the AuthZ servers's X.509 certificate. This allows a DIGA to securely authenticate the authorization endpoint of the device fdata recorder.

The links between these resources is maintained within the BfArM Device Registry. Users of the registry can discover the __Device Data Recorder FHIR Endpoint__ and the __Device Data Recorder AuthZ Endpoint__ of a device data recorder through the [BfArM Device Directory API](himi-vz-api.html). 

A personal device may connect to different __Device Data Recorders__. E.g. a manufacturer of a blood glucose meter may have different diabetes management platforms for different user groups that all can import data from the glucose meter. Each of these solutions may have its own aggregation manager and health record (e.g. a diabetes diary for patients as a mobile app and a monitoring website for doctors). All of these device data recorders must be able to provide the imported blood glucose values to DiGA via the HDDT API. By this there is a many-to-many relationship between devices and data recorders. 

While DiGA use the the [BfArM Device Directory API](himi-vz-api.html) for retrieving information about registered __Personal Health Devices__ and __Device Data Recorders__, these manufacturers of these entities may use the [BfArM DiGA Directory API](diga-vz-api.html) of the BfArM DiGA Registry for retrieving information about a DiGA that wants to connect to a devive through the HDDT API. The [BfArM DiGA Directory API](himi-diga-api.html) builds upon a __DiGA Device Definition__ which holds data that a DiGA provided to BfARM during registration with the [DiGA directory](https://diga.bfarm.de/de/verzeichnis). 

The class diagram below shows the classes of the HDDT information modell which are managed with the BfArM Registries together with connected classes. Correlations and dependencies between objects which are managed by the BfArM Registries internally are shown as functions on dotted lines. If such resolutions will be available as APIs or only via the registries' GUIs has no impact on the technical specification of the HDDT API and therefore is not part of this specification. 

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Device_and_Definition.svg" style="width: 100%;" />
</div>

### MIVs

As written in the beginning of this section, a _MIV_ is technically expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) of LOINC observation codes. Each code in a MIV's matches the conceptual definiton of the _MIV_ and therefore is usable for the intended purposes of a DiGA when processing that _MIV_. Each MIV's [ValueSet](https://hl7.org/fhir/R4/valueset.html) is defined by:
* a `description` that normatively describes the poperties and purposes of the MIV
* a canonical `url` as a unique identifier that can be used for referencing the [ValueSet](https://hl7.org/fhir/R4/valueset.html) in the HDDT specification and in BfArM registry entries. 
* a `version` number that allows MIV value sets to evolve over time (e.g. adding new LOINC codes or splitting MIVs). 
* a human-understandable `title` and a machine-friendly `name`. 
* an extensional list of the LOINC codes that make up the _MIV_.

`url` and `version` together are an unambiguous and widely usable identifier for a _MIV_ [ValueSet](https://hl7.org/fhir/R4/valueset.html). 

Most of the previously introduced classes of the HDDT information model hold references to a _MIV_ as a whole or to a code from a _MIV's_ [ValueSet](https://hl7.org/fhir/R4/valueset.html):

| HDDT class                          | MIV/code reference | FHIR resource and element |
|-------------------------------------|--------------------|---------------------------|
| Interoperable Value                 | The `code` element signals the _MIV_ of the value. The `code` MUST be included with the _MIV's_ value set. | `Observation.code` |
| Personal Health Device Definition | For each registered medical aid or implant the BfArM keeps a list of the supported _MIVs_.  | _BfArM internal reference_ |
| Device Data Recorder Definition | For each device data recorder the BfArM keeps as list of the supported _MIVs_. | _BfArM internal reference_ |
| DiGA Definition | For each DiGA the BfArM keeps as list of the _MIVs_ that this DiGA may process for its intended purposes. | _BfArM internal reference_ |

All FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that represent the defined _MIVs_ are managed within the German Central Terminology Service (ZTS). DiGA vendors and providers of device data recorders can download all _MIV_ value sets as FHIR packages through a standard API (see section [ZTS API](zts-api.html) for details).

The UML class diagram below shows the full HDDT data model. The resources in the light blue box are managed by the Device Data Recorder and can be accessed by DiGA via the HDDT FHIR API. The resources in the orange box reflect the contents of the BfArM registries (Device Registry and DiGA Registry). They can be accessed by DiGA through the [BfARM Device Registry API](himi-vz-api.html) and [BfARM DiGA Registry API](diga-vz-api.html). The green box marks the German Central Terminology Service that maintains the definitions and encodings of all _MIVs_. The [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that span the single _MIVs_ can be obtained from this service through the [ZTS-API](zts-api.html). The light yellow box holds the FHIR Observation Profiles defined for the MIVs and the FHIR profiles for aggregated reports on top of defined MIVs. These profiles will be made available by gematik through Simplifier.

<div style="width: 90%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Complete.svg" style="width: 100%;" />
</div>
