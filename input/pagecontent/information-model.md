# Status: Draft
* Verantwortlich: @jcaumann
* ToDo:
    * Durchsprache im Team
    * QS (insb. Sprache)
    * Vereinheitlichen der formalen Darstellung (_a_ vs __a__ vs `a`)

# HDDT Information Model

__Caution__: In HL7 FHIR R4 the definitions of the [Device](https://hl7.org/fhir/R4/device.html) and [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resources are not very clear about the separation between an operational instance of a device and the general description of the product. This has been corrected with R5 (e.g. by removing the _url_ element from the product description). Due to the comprehensive changes on [Device](https://hl7.org/fhir/R4/device.html) and [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) from R4 to R5, the HDDT information model reflects the logical model of R5 while making sure that it can be implemented using the definitions from R4.  

As depicted in the definition of (certification relevant systems)[certification-relevant-systems.md], each medical aid or implant can be divided into
* __personal device__: the hardware part including the __sensors__ that measure __patient data__ (e.g. vital signs)
* __device data recorder__: components responsible for accepting, storing and further processing the device data. The device data recorder consists of
    * __aggregation manager__: an intermediate hardware and/or software that retrieves the sensor data at the patient's or doctor's side and takes care of securely forwarding it to a health record
    * __health record__: a backend platform that stores the device data

This logical model builds the foundation of the HDDT FHIR based information model. Every artefact of the logical model is mapped onto a class in the HDDT information model. Each class again can be implemented by a standard FHIR R4 resource definition.

| Logical model        | HDDT information model              | HL7 FHIR R4 Resource Definition | 
|----------------------|-------------------------------------|---------------------------------|
| personal device      | Personal Health Device              | [Device](https://hl7.org/fhir/R4/device.html)                   |
| sensor               | Sensor Type and Calibration Status  | [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)             |
| patient data         | Interoperable Value                 | [Observation](https://hl7.org/fhir/R4/observation.html)              |
| device data recorder | Device Data Recorder                | [Device](https://hl7.org/fhir/R4/device.html)                   |

## Measurements and Devices

This core part of the HDDT information model can be implemented using standard HL7 FHIR resource definitions as shown in the UML class diagram below. Instances of the classes shown in the light blue box are used by the DiGA for [retrieving device data](retrieving-data.md) from the device data recorder. Theses instances are managed and provided by the manufacturer of the device data recorder. The device data recorder instance itself is requested by the DiGA during the [pairing flow](pairing.md) and therefore registered with the BfArM device registry. 

<div style="width: 60%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_DevicePart.svg" style="width: 100%;" />
</div>

An __Interoperable Value__ represents the data that is measured by the sensor. This data can either be a single point of data or a sampled stream of data. An example of a single data point is an ad hoc measurement of capillary blood sugar using a blood glucose meter. An example of a stream of data is a sequence of continuous measurements done by a real time Continuous Glucose Monitoring device (rtCGM) during a defined period of time. Each measured data is classified by defined elements of a FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource:
* a LOINC `code` that defines the kind of data, e.g. a blood sugar value measured as mass per volume
* a timestamp (`date[x]`) that marks the time or period at which the measurement was performed
* a `value[x]` that gives the measured value as defined by the `code` including the `unit` of the value and the sample rate (for data streams)
* a `status` that signals the status of the `value`; e.g. signaling if a data stream is finalized or not

Medical aids need to be calibrated in order to provide safe measurements. Some aids are already calibated by the manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. If a medical aid transmits data from a non calibrated sensor to the health record depends on the concrete product. For a DiGA to process device data in a safe manner, the DIGA must know if the data it received was gathered by a calibrated sensor or not. 

For devices where the sensor that measured the value requires automatted or manual calibration, the __Interoperable Value__ MUST refer to the __Sensor Type and Calibration Status__. The sensor type is mapped onto a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which holds calibration information in a `calibration.state` and a `calibration.date` element. In addition the __Sensor Type and Calibration Status__ can provide a definition of the `unit` that is preferrably to be used for presenting measured values to the patient. This `unit` MAY differ from the `unit` that is used with the `value of the Interoperable Value.

Example: A rtCGM sensor measures glucose values as _mg/dl_. All data is stored in the health record in this unit. The HDDT API at the health record provides the data only using _mg/dl_ as the unit. At the mobile app that came with the rtCGM (the rtCGM's aggregation manager) the patient configured the preferred unit as _mmol/l_. Therefore even though the mobile app retrieves all data as mg/dl from the health record it transfers it to _mmol/l_ before displaying it to the patient. In this example `value.unit` of the __Interoperable Value__ is _mg/dl_ while _unit_ within __Sensor Type and Calibration Status__ is _mmol/l_. The motivation for this behaviour is to allow the DiGA to obtain information about the patient's preference and thus to be in sync with the medical aid by displying measured values in the same unit.

The __Sensor Type and Calibration Status__ of a measurement refers to the __Personal Health Device__ that contains the sensor. This is a many-to-one relationship which allows for a personal device to contain multiple sensors for different measured values. E.g. by this a pulseoximeter __Personal Health Device__ can provide _pulse_ and _SPO2_ as two diffferent interoperable values with each of this values being linked with a dedicated __Sensor Type and Calibration Status__. 

In cases where no __Sensor Type and Calibration Status__ referènce is provided with the measured value, the __Interoperable Value__ directly refers to the __Personal Health Instance__ (element `device`).

Each __Personal Health Device__ is implemented through a FHIR [Device](https://hl7.org/fhir/R4/device.html) resource and described by 
* a human readable _device name_ and the name of the _manufacturer_
* its _serial number_. This element is flagged as _Must Support_ (see [Use of HL7 FHIR](use_of_hl7_fhir.md#must-support-elements)) and as such MUST be provided by the medical device through the health record. This allows the patient to verify that the data processed by the DiGA really originated from the device he is wearing in/at his body.
* an _expiration date_ for devices which have a defined end-of-life. An example for this is an rtCGM sensor which only transmits data for 14 or 15 days (depending on the product) and after this is to be replaced by another device.
* further _property_ elements may be defined by the HDDT specification to cover specific configuration settings of specific decvice types.

## BfArM Registries

As described in the section on (certification relevant systems)[certification-relevant-systems.md], a personal device may connect to different __Device Data Recorders__. E.g. a manufacturer of a blood glucose meter may have different diabetes management platforms for different user groups that all can import data from the glucose meter. Each of these solutions may have its own aggregation manager and health record (e.g. a diabetes diary for patients as a mobile app and a monitoring website for doctors). All of these device data recorders must be able to provide the imported blood glucose values to DiGA via the HDDT API. By this there is a many-to-many relationship between devices and data recorders. This is reflected in the HDDT FHIR information model by linking each __Personal Health Device__ resource with an __Device Data Recorder__ resource. 

In contrast to the previously described resources, the __Device Data Recorder__ is managed by BfArM as part of the __BfArM Device Registry__. The resource is assembled from data that the owner of the device data recorder provided to BfArM upon registration for HDDT-compliance. When pairing with a device data recorder, a DiGA first discovers the respective __Device Data Recorder__ resource from the BfArM device registry. This resource is defined as a FHIR `Device` resource and holds almost all information a DiGA needs for successfully connecting to the device data recorders OAuth and FHIR endpoints:
* the `status` signals, if the health record of the device data recorder is active at all. 
* the `name` of the device data recorder is the name of the mobile app that the patient uses to aggregate and forward data from the personal health device 
* the `url` element points to the FHIR endpoint that the DiGA must call for getting access to the FHIR resources managed by the device data recorder (see previous section). Through the `url` the DiGA can as well access the SMART capabilities of the device data recorder that contain information an how to obtain the access token for getting access to the FHIR API (see [OAuth API](oauth-api.md))
* global configuration settings (e.g. the frequencey the device data recorder's health record synchronizes with the aggregation manager) can be obtained through the _capability_ element

The information missing with the __Devide Data Recorder__ is the sets of types of interoperable values that are supported by the device data recorder. For this, for each __Device Data Recorder__ BfArM will add an __Device Data Recorder Definition__ entry to the device registry, that is implemented as another [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource. This resource holds references to the MIV valueSets that define the shared interoperable values (see nexzt section).

Owners of medical aids and implants that fall under the regulation of § 374a SGB V must register at the BfArM device registry, too. This leads to a __Personal Health Device Definition__ which is defined as a `DeviceDefinition` resource. The resource is created upon registration of a medical aid or implant with the BfArM Device Registry. The information bound to this resource include
* a human readable _device name_ and the name of the _manufacturer_
* the _type_ of the device given as a SNOMED CT or ISO/IEEE 11073-10101:2020 code
* additional static _properties_ of the product

The _type_ code is fixed per device type. It is defined as part of the MIV-specific FHIR implementation guides. HL7 FHIR R4 does not give guidance on how _properties_ are to be defined and encoded. The HDDT specifiaction will therefore as much as possible rely on device properties as defined in device-specific ISO/IEEE-11073 domain models.

The class diagram below extends the previous figure by the classes of the HDDT information modell which are managed with the BfArM Device Registry. 

<div style="width: 100%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Device_and_Definition.svg" style="width: 100%;" />
</div>

## MIVs
A core idea of the HDDT specification is the definition of _Mandatory Interoperable Values (MIVs)_. A MIV is a conceptual definition of a value that MUST be provided in an interoperable manner by a medical aid or implant through a device data recorder's HDDT API. A "conceptual definition" defines a value by it properties and purposes within the context of a DiGA device data processing scenario. It therefore reflects the legal obligation from § 374a SGB V that a DiGA must only process device data if and only if this data is needed for the intended purposes of the DiGA. Therefore for example _Glucose in capillary Blood_ and _Glucose in interstitial fluid_ are two different _MIVs_: While the first is measured ad hoc and usable for clinical decisions the second is measured continuously and suitable for calculating key indicators for the status of the treatment (e.g. %TIR and GMI). 

Technically a _MIV_ is expressed as a FHIR `ValueSet` of LOINC observation codes. Each code in a MIV's value set matches the conceptual definiton of the _MIV_ and therefore is usable for the intended purposes of a DiGA when processing that _MIV_. Each MIV `ValueSet` is defined by:
* a _description_ that normatively describes the poperties and purposes of the MIV
* a canonical _url_ as a unique identifier that can be used for referencing the `ValueSet` in the HDDT specification, in BfArM registry entries and in device data instances. 
* a _version_ number that allows MIV value sets to evolve over time (e.g. adding new LOINC codes or splitting MIVs). 
* a human-understandable _title_ and a machine-friendly _name_ 
* an extensional list of the LOINC codes that make up the _MIV_.

_url_ and _version_ together are an unambiguous and widely usable identifier for a _MIV_ `ValueSet`. 

Most of the previously introduced classes of the HDDT information model hold references to a _MIV_ as a whole or to a code from a _MIV's_ `ValueSet`:

| HDDT class                          | MIV/code reference | FHIR resource and element |
|-------------------------------------|--------------------|---------------------------|
| Interoperable Value                 | The _code_ element signals the _MIV_ of the value. The _code_ MUST be included with the _MIV's_ value set. | `Observation.code` |
| Sensor Type and Calibration Status  | The _type_ element signals the _MIV_ that is measured by the sensor. The _type_ MUST be included with the _MIV's_ value set. | `DeviceMetric.type` | 
| Personal Health Device Definition | For each registered medical aid or implant the BfArM lists the supported _MIVs_ by providing references from the Personal Health Device Registry Entry to the _MIV's_ `ValueSet` resources using the canonical url and version number. | `DeviceDefinition.capability[*]` |
| Device Data Recorder Definition | For each device data recorder the BfArM lists the supported _MIVs_ by providing references from the Device Data Recorder Registry Entry to the _MIV's_ `ValueSet` resources using the canonical url and version number. | `DeviceDefinition.capability[*]` |

The FHIR `ValueSet` resources that represent the defined _MIVs_ are managed within the German Central Terminology Service (ZTS). DiGA vendors and providers of device data recorders can download all _MIV_ value sets as FHIR packages through a standard NMP API (see section (ZTS API)[zts-api.md] for details).

The UML class diagram below shows the full HDDT data model. The resources in the light blue boy are managed by the Device Data Recorder and can be accessed by DiGA via the HDDT FHIR API. The resources in the orange box reflect the contents of the BfArM device registry. They can be accessed by DiGA through the [BfARM Device Registry API](diga-vz-api.md). The green box marks the German Central Terminology Service that maintains the definitions and encodings of all _MIVs_. The `ValueSet` resources that span the single _MIVs_ can be obtained from this service through the NPM-based [ZTS-API](zts-api.md).

<div style="width: 70%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_Complete.svg" style="width: 100%;" />
</div>
