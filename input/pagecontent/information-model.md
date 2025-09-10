# Status: Draft
* Verantwortlich: @jcaumann
* ToDo:
    * Durchsprache im Team
    * QS (insb. Sprache)
    * Vereinheitlichen der formalen Darstellung (_a_ vs __a__ vs `a`)

# HDDT Information Model

___Caution__: In HL7 FHIR R4 the definitions of the [Device](https://hl7.org/fhir/R4/device.html) and [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resources are not very clear about the separation between an operational instance of a device and the general description of the product. This has been corrected with R5. In order to be compliant with FHIR R4, R5, and R6 the HDDT information model does not make use of elements, which are not compliant accross these releases. This especially affects the binding of the device data recorder's FHIR endpoint to the definition of the device data recorder._ 

As depicted in the definition of [certification relevant systems](certification-relevant-systems.md), each medical aid or implant can be divided into
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
| device data recorder | Device Data Recorder Definition     | [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html)<br>[Endpoint](https://hl7.org/fhir/R4/endpoint.html)                   |

## Measurements and Devices

This core part of the HDDT information model can be implemented using standard HL7 FHIR resource definitions as shown in the UML class diagram below. Instances of the classes shown in the light blue box are used by the DiGA for [retrieving device data](retrieving-data.html) from the device data recorder. Theses instances are managed and provided by the manufacturer of the device data recorder. The device data recorder instance itself is requested by the DiGA during the [pairing flow](pairing.html) and therefore registered with the BfArM device registry. 

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_DevicePart.svg" style="width: 100%;" />
</div>

An __Interoperable Value__ represents the data that is measured by the sensor. This data can either be a single point of data or a sampled stream of data. An example of a single data point is an ad hoc measurement of capillary blood sugar using a blood glucose meter. An example of a stream of data is a sequence of continuous measurements done by a real time Continuous Glucose Monitoring device (rtCGM) during a defined period of time. Each measured data is classified by defined elements of a FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource:
* a LOINC `code` that defines the kind of data, e.g. a blood sugar value measured as mass per volume
* a timestamp (`date[x]`) that marks the time or period at which the measurement was performed
* a `value[x]` that gives the measured value as defined by the `code` including the `unit` of the value and the sample rate (for data streams)
* a `status` that signals the status of the `value`; e.g. signaling if a data stream is finalized or not

Medical aids need to be calibrated in order to provide safe measurements. Some aids are already calibated by the manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. If a medical aid transmits data from a non calibrated sensor to the health record at all depends on the concrete product. For a DiGA to process device data in a safe manner, the DIGA must know if the data it received was gathered by a calibrated sensor or not. 

For devices where the sensor that measured the value requires automated or manual calibration, the __Interoperable Value__ MUST refer to the __Sensor Type and Calibration Status__. The sensor type and calibration status is mapped onto a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which holds calibration information in a `calibration.type`, a `calibration.state` and a `calibration.date` element. In addition the __Sensor Type and Calibration Status__ can provide a definition of the `unit` that is preferrably to be used for presenting measured values to the patient. This `unit` MAY differ from the `unit` that is used with the `value of the Interoperable Value (which is provided through a backend system).

Example: A rtCGM sensor measures glucose values as _mg/dl_. All data is stored in the health record in this unit. The HDDT API at the health record provides the data only using _mg/dl_ as the unit. At the mobile app that came with the rtCGM (the rtCGM's aggregation manager) the patient configured the preferred unit as _mmol/l_. Therefore even though the mobile app retrieves all data as mg/dl from the health record it transfers it to _mmol/l_ before displaying it to the patient. In this example `value.unit` of the __Interoperable Value__ is _mg/dl_ while _unit_ within __Sensor Type and Calibration Status__ is _mmol/l_. The motivation for this behaviour is to allow the DiGA to obtain information about the patient's preference and thus to be in sync with the medical aid by displying measured values in the same unit.

The __Sensor Type and Calibration Status__ of a measurement refers to the __Personal Health Device__ that contains the sensor. This is a many-to-one relationship which allows for a personal device to contain multiple sensors for different measured values. E.g. by this a pulseoximeter __Personal Health Device__ can provide _pulse_ and _SPO2_ as two diffferent interoperable values with each of this values being linked with a dedicated __Sensor Type and Calibration Status__. 

In cases where no __Sensor Type and Calibration Status__ reference is provided with the measured value, the __Interoperable Value__ directly refers to the __Personal Health Device__ (element `device`).

Each instance of a __Personal Health Device__ is represented by a FHIR [Device](https://hl7.org/fhir/R4/device.html) resource and described by 
* a human readable `devicename` and the name of the `manufacturer`
* its `serialNumber`. This element is flagged as _Must Support_ (see [Use of HL7 FHIR](use_of_hl7_fhir.md#must-support-elements)) and as such MUST be provided by the medical device through the health record. This allows the patient to verify that the data processed by the DiGA really originated from the device he is using.
* an `expirationDate` for devices which have a defined end-of-life. An example for this is an rtCGM sensor which only transmits data for 14 or 15 days (depending on the product) and after this is to be replaced by another device.
* further `property` elements may be defined by the HDDT specification to cover specific configuration settings of specific decvice types.

## BfArM Registries

Owners of medical aids and implants that fall under the regulation of § 374a SGB V must register at the BfArM device registry. This leads to a __Personal Health Device Definition__ which is defined as a [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource. Each __Personal Health Device__ can be linked with a __Personal Health Device Definition__ in the BfArM Device Registry through the `Device.definition' element.

The __Personal Health Device Definition__ resource for a medical aid or implant is created upon registration of this medical aid or implant with the BfArM Device Registry. The information bound to this resource include
* a human readable `deviceName` and the name of the `manufacturer`
* the `type` of the device given as a SNOMED CT or ISO/IEEE 11073-10101:2020 code
* additional static properties (`property`) of the product, e.g. the minimum and maximum glucose values that can be measured by a specific blood glucose meter

The `type` code is fixed per device type. It is defined as part of the MIV-specific FHIR implementation guides. HL7 FHIR R4 does not give guidance on how _properties_ are to be defined and encoded. The HDDT specification will therefore as much as possible rely on device properties as defined in device-specific ISO/IEEE-11073 domain models.

As described in the section on (certification relevant systems)[certification-relevant-systems.md], the responsibility for implementing the HDDT API is with a __Device Data Recorder__ who operates the health record where measured data is stored and accessible to authorized DiGA. These __Device Data Recorders__ must as well register themselves with the DiGA Device Registry such that a DiGA can e.g. discover the endpoints of the health record's FHIR API. For each __Device Data Recorder__ the HDDT FHIR based information model incorporates two resources which are both maintained within the BfArM Device Registry:
* __Device Data Recorder Definition__ ([DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html)): 
  * human readable `deviceName` and name of the `manufacturer` of the device data recorder
  * `contact` data of the owner of the device data recorder, e.g. to allow a DiGA manufacturer to check for testing capabilities 
  * global configuration settings (e.g. the frequencey the device data recorder's health record synchronizes with the aggregation manager) can be obtained through the _capability_ element  
  * additional static properties (`property`) of the platform, that implements the device data recorder
* __Device Data Recorder FHIR Endpoint__ ([Endpoint](https://hl7.org/fhir/R4/endpoint.html)): 
  * `address` of the FHIR endpoint that a DiGA must call for getting access to the FHIR resources managed by the device data recorder (see previous section). Through the `address` the DiGA can as well access the SMART capabilities of the device data recorder that contain information an how to obtain the access token for getting access to the FHIR API (see [OAuth API](oauth-api.md))

The link between these two resources is maintained within the BfArM Device Registry. Users of the registry can retieve the __Device Data Recorder FHIR Endpoint__ of a device data recorder through the [BfArM Device Directory API](himi-vz-api.md). 

A personal device may connect to different __Device Data Recorders__. E.g. a manufacturer of a blood glucose meter may have different diabetes management platforms for different user groups that all can import data from the glucose meter. Each of these solutions may have its own aggregation manager and health record (e.g. a diabetes diary for patients as a mobile app and a monitoring website for doctors). All of these device data recorders must be able to provide the imported blood glucose values to DiGA via the HDDT API. By this there is a many-to-many relationship between devices and data recorders. 

The class diagram below extends the previous figure by the classes of the HDDT information modell which are managed with the BfArM Device Registry. Correlations and dependencies between objects which are managed by the BfArM Device Directory internally are shown as functions on dotted lines. If such resolutions will be available as APIs or only via the device directory's GUI has no impact on the technical specification of the HDDT API and therefore is not part of this specification. 

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Device_and_Definition.svg" style="width: 100%;" />
</div>

## MIVs

A core idea of the HDDT specification is the definition of _Mandatory Interoperable Values (MIVs)_. A MIV is a conceptual definition of a value that MUST be provided in an interoperable manner by a medical aid or implant through a device data recorder's HDDT API. A "conceptual definition" defines a value by it properties and purposes within the context of a DiGA device data processing scenario. It therefore reflects the legal obligation from § 374a SGB V that a DiGA must only process device data if and only if this data is needed for the intended purposes of the DiGA. Therefore for example _Glucose in capillary Blood_ and _Glucose in interstitial fluid_ are two different _MIVs_: While the first is measured ad hoc and usable for clinical decisions the second is measured continuously and suitable for calculating key indicators for the status of the treatment (e.g. %TIR and GMI). 

Technically a _MIV_ is expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) of LOINC observation codes. Each code in a MIV's matches the conceptual definiton of the _MIV_ and therefore is usable for the intended purposes of a DiGA when processing that _MIV_. Each MIV's [ValueSet](https://hl7.org/fhir/R4/valueset.html) is defined by:
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
| Sensor Type and Calibration Status  | The `type` element signals the _MIV_ that is measured by the sensor. The `type` MUST be included with the _MIV's_ value set. | `DeviceMetric.type` | 
| Personal Health Device Definition | For each registered medical aid or implant the BfArM keeps a list of the supported _MIVs_.  | _BfArM internal reference_ |
| Device Data Recorder Definition | For each device data recorder the BfArM keeps as list of the supported _MIVs_. | _BfArM internal reference_ |

All FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that represent the defined _MIVs_ are managed within the German Central Terminology Service (ZTS). DiGA vendors and providers of device data recorders can download all _MIV_ value sets as FHIR packages through a standard NMP API (see section (ZTS API)[zts-api.md] for details).

The UML class diagram below shows the full HDDT data model. The resources in the light blue boy are managed by the Device Data Recorder and can be accessed by DiGA via the HDDT FHIR API. The resources in the orange box reflect the contents of the BfArM device registry. They can be accessed by DiGA through the [BfARM Device Registry API](diga-vz-api.md). The green box marks the German Central Terminology Service that maintains the definitions and encodings of all _MIVs_. The [ValueSet](https://hl7.org/fhir/R4/valueset.html) resources that span the single _MIVs_ can be obtained from this service through the NPM-based [ZTS-API](zts-api.md).

<div style="width: 85%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Complete.svg" style="width: 100%;" />
</div>
