Alias: $cgm-summary = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary
Alias: $cgm-summary-mean-glucose-mass-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-mass-per-volume
Alias: $cgm-summary-mean-glucose-moles-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-moles-per-volume
Alias: $cgm-summary-times-in-ranges = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-times-in-ranges
Alias: $cgm-summary-gmi = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-gmi
Alias: $cgm-summary-coefficient-of-variation = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-coefficient-of-variation
Alias: $cgm-summary-days-of-wear = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-days-of-wear
Alias: $cgm-summary-sensor-active-percentage = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-sensor-active-percentage
Alias: $bp-sd = http://fhir.de/StructureDefinition/observation-de-vitalsign-blutdruck
Alias: $ucum-units = http://hl7.org/fhir/ValueSet/ucum-units
Alias: $LNC = http://loinc.org
Alias: $LNC-versioned = http://loinc.org|2.81
Alias: $mdc = urn:iso:std:iso:11073:10101

// change both 'version' and 'version-suffix'!!!
Alias: $sct = http://snomed.info/sct
Alias: $sct-version-suffix = http://snomed.info/sct/11000274103/version/20251115
Alias: $sct-version = http://snomed.info/sct|http://snomed.info/sct/11000274103/version/20251115 // german Snomed

Alias: $shareable-vs = http://hl7.org/fhir/StructureDefinition/shareablevalueset
// since the VS is an instance, we need to hardcode the URI for bindings, etc.
Alias: $vs-device-type = https://gematik.de/fhir/hddt/ValueSet/hddt-device-type
// placeholder does not work for includes, references, bindings, etc., so replace manually !!
Alias: $term-version = 1.0.0-rc2

Profile: HddtCgmSummary
Parent: Bundle
Id: hddt-cgm-summary
Title: "Bundle – HDDT CGM Summary Report"
Description: """
This profile defines the exchange of aggregated measurement data for the Mandatory Interoperable Value (MIV) \"Continuous 
Glucose Measurement\". By this it provides a patient's glucose profile for a defined period. The MIV \"Continuous 
Glucose Measurement\" is e.g. implemented by real-time Continuous Glocose Monitoring devices (rtCGM) and Automated Insulin Delivery systems (AID) that control 
an insulin pump from rtCGM data. Future non-invasive measuring methods will expectedly be linked with this MIV and therefore use this profile for sharing aggregated glucose profile data with DiGA, too.

This profile constrains the FHIR Bundle resource for use as the result container of the `$hddt-cgm-summary` operation.  
The operation requests a patient's glucose profile. The glucose profile is calculated form continuous glucose measurement data
and consists of the machine-readable parts of the [_HL7 CGM summary profile_](https://hl7.org/fhir/uv/cgm/). 

The Bundle is of type *collection* and MUST contain only resources of the following types:  
- Observations conforming to [HL7 CGM profiles](https://hl7.org/fhir/uv/cgm/): 
    - [CGM Summary Observation](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary.html)
    - [Mean Glucose (Mass)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
    - [Mean Glucose (Moles)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
    - [Times in Ranges](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-times-in-ranges.html)
    - [Glycemic Variability Index (GMI)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-gmi.html)
    - [Coefficient of Variation](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-coefficient-of-variation.html)
    - [Days of Wear](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-days-of-wear.html)
    - [Sensor Active Percentage](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-sensor-active-percentage.html)

- Device resources conforming to `HddtPersonalHealthDevice` to provide context about the actual Personal Health Device device used.  

The purpose of this Bundle profile is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic.  
It ensures interoperability across different implementations by defining a predictable response format.  
This supports use cases such as:  
- Retrieval of CGM summary metrics over a given time interval in support for the upcoming digital disease management program (dDMP) on Diabetes, e.g. for 
    - continuous therapy monitoring and adjustment
    - forwarding key data to treating physicians, e.g. for clinical decision support
    - supporting asynchonous telemonitoring by ad hoc provisioning of condensed status information
- Combining aggregated measurement data and device metadata for downstream applications such as visualization or compliance monitoring

**Constraints applied:**  
- `Bundle.type` is fixed to `collection`.  
- `Bundle.entry.resource` is restricted to CGM Observation profiles and `HddtPersonalHealthDevice`. No other resource types are allowed in the Bundle.  
- `Bundle.entry` is set as mandatory. A requests for a CGM summary that would result in an empty bundle, MUST give an _OperationOutcome_ with an error or warning message as its response. Therefore there is no scenario where an empty bundle would be shared with a DiGA.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of CGM summary Observations and optionally related Device and DeviceMetric resources returned by the $hddt-cgm-summary operation."
* entry 1..*
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or HddtPersonalHealthDevice 
* entry.resource ^short = "Observations with their related Device and DeviceMetric information"

Invariant: device-definition-reference-check-1
Description: "Ensures that any device definition reference points to the HIIS domain."
Severity: #error
Expression: "definition.exists() implies definition.reference.contains('hiis.bfarm.de') or definition.resolve().identifier.where(system ='http://fhir.de/sid/gkv/hmnr').exists()"


Profile: HddtPersonalHealthDevice
Parent: Device
Id: hddt-personal-health-device
Title: "Device – Personal Health Device"
Description: """
This profile defines a Personal Health Device within the context of § 374a SGB V. A Personal Health Device acc. to this profile is any
medical aid or implant that 
- is distributed to patients at the expense of the statutory health insurance and 
- transmits the data about the patient electronically to the device manufacturer or third parties, which make the data available to patients and/or physicians via publicly accessible networks. 
 
Personal Health Devices that fulfill the criteria of this regulation MUST be able to pass on data to authorized Digital Health Applications (DiGA acc. § 374a SGB V) using the protocols 
and interfaces as defined in the HDDT specification.

This profile helps a device data consuming DiGA to
- increase patient safety by comparing the serial number of a Personal Health Device as presented with this profile with the serial number the patient may have provided to the DiGA
- increase data quality by getting information about the current status of the end-to-end communication flow from the Personal Health Device to the device backend and thus being able to detect if there may be more data available for the requested period
- optimize its interactions with the device data providing resource server by getting access to the DeviceDefinition resource that holds static attributes about the device and its connected backend (e.g. minimum delay between data measurement and data availability)

**Obligations and Conventions:**

The Personal Health Device's backend regularely synchronizes with the device hardware through a gateway (_Personal Health Gateway_). 
The maximum delay that the concrete end-to-end synchronization from the Personal Health Device to the FHIR resource server imposes is provided by the BfArM _HIIS-VZ_ (Device Registry) per MIV
through the static attribute `Delay-From-Real-Time`. If a resource server has not synchronized with the connected Personal Health Device for a time span 
longer than `Delay-From-Real-Time`(e.g. due to temporarely lost Bluetooth or internet connectivity), the `status` of the Device resource that represents the 
Personal Health Device MUST be set to `unknown`.

**Constraints applied:**  
- `status` is set to _Must Support_ in order to allow a DiGA to detect missing data (e.g. due to connection issues)
- `deviceName` and `serialNumber` are set to _Must Support_ to allow a validation of the source of device data by comparing this information with information printed on the Personal Health Device
- `definition` is optional. If present it MUST refer to a DeviceDefinition resource in the BfARM HIIS VZ. This ensures that DiGA can only receive static product information which was registered by the vendor of the device.
- `expirationDate` is set to _Must Support_ to allow a DiGA to be aware of regular sensor changes (e.g. for patient wearing a rtCGM)
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* . ^short = "Personal Health Device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device MUST be a medical aid or implant."
* type from $vs-device-type (required)
* type ^short = "The machine-readable type of the Personal health device"
* status MS
* status ^requirements = "allow a requesting party to detect missing data (e.g. due to connection issues)"
* status ^comment = """
The `status` values _active_ and _inactive_ refer to the ability of the Personal Health Device to record and share measured data. E.g. a real-time 
Continuous Glucose Monitoring device usually stops recording and sharing glucose values after 14 days of wear, 
even though the sensor is still alive for a longer time. After these 14 days, the `status` switches from _active_ to _inactive_.

If a resource server has not synchronized with the connected Personal Health Device for a time span longer 
than stated in the static attribute `Delay-From-Real-Time`(e.g. due to temporarely lost Bluetooth or internet connectivity), 
the `status` of the Device resource that represents the Personal Health Device MUST be set to `unknown`. The device 
specific value of the static attribute `Delay-From-Real-Time` can be obtained through the device's DeviceDefinition resource.
"""
* definition 0..1
// * definition only Reference(DeviceDefinition)
* definition ^short = "Definition of the Personal health device"
* definition ^definition = "Reference to a DeviceDefinition resource of the HIIS that describes the technical and functional details of the Personal health device."
* obeys device-definition-reference-check-1
* expirationDate MS
* expirationDate ^short = "Date and time of expiry of this Personal health device (if applicable)"
* expirationDate ^definition = "The date and time beyond which this Personal Health Device is no longer valid or should not be used (if applicable)."
* expirationDate ^comment = """
The expiration date signals the _end of communication_ (which is latest the devices _end of life_). E.g. a real-time 
Continuous Glucose Monitoring device usually stops recording and sharing glucose values after 14 days of wear, 
even though the sensor is still alive for a longer time. The `expirationDate` in this case is 14 days after the 
patient started the sensor.  
"""
* serialNumber MS
* serialNumber ^short = "Serial number of the Personal health device"
* serialNumber ^definition = "The serial number that uniquely identifies the Personal Health Device instance."
* serialNumber ^comment = "The serial number MAY only be omitted if neither the Personal Health Device nor its manual and packaging hold the printed serial number and if the Personal Health Device does not provide an API for reading a unique number from the device hardware."
* deviceName MS
* deviceName ^short = "Name of the Personal health device"
* deviceName ^definition = "The name of the Personal health device as given by the manufacturer and listed in the _HIIS-VZ_ (BfARM Device Registry)."


Profile: HddtSensorTypeAndCalibrationStatus
Parent: DeviceMetric
Id: hddt-sensor-type-and-calibration-status
Title: "DeviceMetric – Sensor Type and Calibration Status"
Description: """
The HddtSensorTypeAndCalibrationStatus profile captures the calibration status of a sensor which is part of a Personal Health Device. 

Personal Health Devices need to be calibrated in order to provide safe measurements. Some devices are already calibrated by the 
manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. 
If a Personal Health Device transmits data from a non calibrated sensor to the resource server at all depends on the concrete product. 
For a DiGA as a device data consumer to process device data in a safe manner, it must be transparent if the data it received was 
measured by a calibrated sensor or not. 

For devices where the sensor that measured a value requires automated or manual calibration, the Observation capturing this value 
MUST refer to a HddtSensorTypeAndCalibrationStatus resource through its `Observation.device` element. 
The HddtSensorTypeAndCalibrationStatus implements a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which 
holds calibration information in a `calibration.type`, a `calibration.state` and a `calibration.date` element. In addition 
the HddtSensorTypeAndCalibrationStatus can provide a definition of the `unit` that is preferrably to be used for presenting 
measured values to the patient. 

The HddtSensorTypeAndCalibrationStatus of a measurement MUST always refer to a HddTPersonalHealthDevice [Device](https://hl7.org/fhir/R4/device.html) resource that represents the 
Personal Health Device that contains the sensor. This is a many-to-one relationship which allows for a Personal Health Device to 
contain multiple sensors for different measured values. E.g. by this a pulse oximeter as a HDDT Personal Health Device can 
provide _pulse_ and _SPO2_ as two different interoperable values with each of this values being linked with a 
dedicated HddtSensorTypeAndCalibrationStatus resource. 

**Obligations and Conventions:**

DiGA as device data consumers SHOULD NOT rely on the `DeviceMetric.operationalStatus` of a sensor as this status does only reflect the status of the sensor 
and does not provide information about the end-to-end status of the flow of device data from the sensor within the Personal Health Device 
to the resource server in the device backend. Instead DiGA SHOULD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element considers the end-to-end availability of data and therefore is the only source for 
information about potentially missing data (e.g. due to temporal problems with the bluetooth or internet connection).

**Constraints applied:**  
- `unit` is restricted to UCUM. 
- `source` is constrained as a mandatory element in order to enable a DiGA to obtain dynamic and static device attributes through this reference
- `calibration` is set to _Must Support_. This element and respective status information MUST be provided if the sensor performs automated or requires manual calibration after the device has been put into operation with the patient (`Device.status`is `active`).
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* . ^short = "Configuration or setting capability of a personal health device"
* . ^definition = "Describes the sensor type and calibration status of a sensor within a Personal Health Device as a DeviceMetric."
* unit from $ucum-units (required)
* unit ^short = "UCUM code of the unit of the measurement as it is used when presenting data to the patient"
* unit ^definition = "The unit in which the Personal Health Device presents its measurement values to the patient."
* unit ^requirements = "allow a DiGA to detect the unit the patient is used to"
* unit ^comment = """
This element holds the unit of measurement that is preferrably to be used for presenting measured values to the patient. 
This unit MAY differ from the unit that is used with the `Observation.value[x]` of measured data.

_Example_: A rtCGM sensor measures glucose values as mg/dl. All data is stored in the health record in this unit. 
The resource server provides the data only using mg/dl as the unit. At the mobile app that came with the rtCGM (the rtCGM’s 
Personal Health Gateway) the patient configured the preferred unit as mmol/l. Therefore all data is calculated (by the device or 
the app) to mmol/l before displaying it to the patient. In this example the unit of `Observation.value[x]` is mg/dl 
while `DeviceMetric.unit` is mmol/l. The motivation for this behaviour is to allow the DiGA to obtain information about the 
patient’s preference and thus to be in sync with the medical aid by displaying measured values in the same unit.
"""
* unit ^binding.description = "For HDDT only codes from UCUM MUST be used for coding units of measurements"
* source 1..
* source only Reference(HddtPersonalHealthDevice)
* source ^short = "Reference to the Personal Health Device holding the sensor"
* source ^definition = "Points to the specific Device resource that holds the sensor for which the documented calibration status applies."
* operationalStatus 0..1
* operationalStatus ^comment = """
DiGA as device data consumers SHOULD NOT rely on the `operationalStatus` of a sensor as this status does only reflect the status of the sensor 
and does not provide information about the end-to-end status of the flow of device data from the sensor within the Personal Health device 
to the resource server in the device backend. Instead DiGA SHOILD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element considers the end-to-end availability of data and therefore is the only source for 
information about potentially missing data (e.g. due to temporal problems with the bluetooth or internet connection).
"""
* calibration MS
* calibration.state 1..1
* calibration.time MS
* calibration.time ^short = "Time when the last calibration has been performed"
* calibration.time ^definition = """
The time when the last calibration has been performed. This element covers both manual calibration performed 
by the patient and automated calibration performed by the device itself. E.g. with a self-calibrating rtCGM `calibration.time`
signals the time when the device started sending calibrated values after the initial calibration phase. 

If the sensor does not require calibration, this element MAY be omitted. 
"""

Profile: HddtBloodGlucoseMeasurement
Parent: Observation
Id: hddt-blood-glucose-measurement
Title: "Observation – Blood Glucose Measurement"
Description: """
Profile for capturing blood glucose measurements as FHIR Observation resources.

This profile defines the exchange of a single measurement data for the Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\" which is technically defined 
by the ValueSet _hddt-miv-blood-glucose-measurement_. This MIV is e.g. implemented by blood glucose meter (glucometer) that can connect to 
a Personal Health Gateway (e.g. a mobile app for keeping diabetes diary) through wireless or wired communication.

**Obligations and Conventions:**

Each Blood Glucose Measurement MUST either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). A reference to _Sensor Type And Calibration Status_ MUST be provided 
from the Observation resource if the sensor for measuring blood glucose needs to be calibrated (either automatically or by the user) 
or if the sensor may change its calibration status over time. 

**Constraints applied:**  
- `status` is restricted to _final_
- `code` is constrained to the ValueSet that represents the MIV _Blood Glucose Measurement_
- `effective[x]` is restricted to `effectiveDateTime` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `device` is set to be mandatory in order to provide the DiGA with information about the sensor's calibration status and with information about the static and dynamic attributes of the Personal Health Device.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* code from HddtMivBloodGlucoseMeasurement (required)
* code ^short = "Measurement type of blood glucose"
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for blood glucose measurements."
* effective[x] 1..1
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time or period when the blood glucose measurement was taken."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Measured blood glucose value"
* value[x] ^definition = "The quantitative blood glucose value, measured either in mass/volume (mg/dL) or moles/volume (mmol/L), represented as a UCUM Quantity."
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code ^definition = "The UCUM code representing the unit of the blood glucose measurement. The UCUM code MUST be compliant with the example unit that is linked with the LOINC code given as `Observation.code`."
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet. The UCUM code MUST be compliant with the unit that is linked with the LOINC code given as `Observation.code`."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "References a DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference to the Device resource that describes the personal health device itself."


Profile: HddtContinuousGlucoseMeasurement
Parent: Observation
Id: hddt-continuous-glucose-measurement
Title: "Observation – Continuous Glucose Measurement"
Description: """
Profile for capturing continuous glucose measurements from real-time monitoring devices (esp. rtCGM). 

This profile defines the exchange of raw measurement data for the Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\" which is technically defined 
by the ValueSet _hddt-miv-continuous-glucose-measurement_. This MIV is e.g. implemented by real-time Continuous Glocose Monitoring devices (rtCGM) and Automated Insulin Delivery systems (AID) that control 
an insulin pump from rtCGM data. Future non-invasive measuring methods will expectedly be linked with this MIV and therefore use this profile for sharing data with DiGA, too.

**Obligations and Conventions:**

Devices for continuously measuring glucose values may produce data with a sample rate of more than 1000 values per day (e.g. current
rtCGM provide measures for glucose in interstitial fluid with up to one value per minute). For sharing such data efficently, this profile
makes use of the FHIR [sampledData](https://hl7.org/fhir/R4/datatypes.html#SampledData) data type. Sampled data is portioned into
chunks of a fixed size (for an exception see below), with the chunk size being set by the resource server (e.g. such that 24 h of measurements fit into a single chunk). If a DiGA
requests data for a period where the end time is earlier that the expected end time of the current chunk, the resource server only fills up the chunk 
up to the requested end time and sets the `Observation.status` to _incomplete_ while `Observation.effectivePeriod` captures the 
full period of the chunk (see section \"Retrieving Data\" in the HDDT specification for details on chunks and missing data). 

Each Continuous Glucose Measurement MUST either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). A reference to _Sensor Type And Calibration Status_ MUST be provided 
from the Observation resource if the sensor for continuous measuring needs to be calibrated (either automatically or by the user) 
or if the sensor may change its calibration status over time. A change in `DeviceMetric.calibration.state` or a change of `Device.status` to _inactive_ finalizes the
current chunk and therefore is the only reason why a chunk may be smaller than the defined fixed size. 

**Constraints applied:**  
- `code` is constrained to the ValueSet that represents the MIV _Continuous Glucose Measurement_
- `effective[x]` is restricted to `effectivePeriod` and constrained as mandatory. Both a starting time and an end tme MUST be given.
- `value[x]` is restricted to _valueSampledData_. The elements `valueSampledData.origin.unit`, `valueSampledData.origin.system`, and `valueSampledData.origin.code` are mandatory. `valueSampledData.origin.system` is restricted to UCUM. `Observation.valueSampledData` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `device` is set to be mandatory in order to provide the DiGA with information about the sensor's calibration status and with information about the static and dynamic attributes of the Personal Health Device.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* . ^short = "Chunk of continuous glucose measurements"
* . ^definition = "An Observation representing a continuous glucose measurement (CGM) series over a defined effective period, captured as SampledData from a personal health device."
* status ^short = "Status of the continuous glucose measurements chunk"
* status ^definition = "The status of the continuous glucose measurements chunk. The status 'final' means the measurement is complete and verified; 'preliminary' means the data MAY be still being collected and not complete. It SHOULD be called at a later time for collecting complete data."
* code from HddtMivContinuousGlucoseMeasurement (required)
* code ^short = "Type of continuous glucose measurement"
* code ^binding.description = "Specifies the type of continuous glucose measurement using codes from the ValueSet for CGM measurements."
* effective[x] 1..1
* effective[x] only Period
* effective[x] ^short = "Time interval covered by the CGM measurement chunk"
* effective[x] ^definition = """
The time span covered by this chunk of continuous glucose measurements. The length of every time span is a fixed value defined 
internaly by the data recorder per personal health device.
"""
* effective[x].start 1..1
* effective[x].start 
* effective[x].end 1..1
* value[x] MS
* value[x] only SampledData
* value[x] ^short = "Series of glucose measurements"
* value[x].origin.unit ^short = "Unit of continuous glucose measurement"
* value[x].origin.unit ^definition = "The unit of measurement used for all data in `valueSampledData.data`."
* value[x].origin.system 1..1
* value[x].origin.system = "http://unitsofmeasure.org" (exactly)
* value[x].origin.code 1..1
* value[x].origin.code from $ucum-units (required)
* value[x].origin.code ^short = "UCUM code for unit of measurements"
* value[x].origin.code ^definition = "The UCUM code representing the unit of the continuous glucose measurement. The UCUM code MUST be compliant with the example unit that is linked with the LOINC code given as `Observation.code`."
* value[x].origin.code ^binding.description = "Defines the measurement unit for continuous glucose values using UCUM codes."
* value[x].data 1..
* dataAbsentReason 0..1
* dataAbsentReason ^definition = """
Indicates why the measurement data is missing. A value of 'temp-unknown' MUST only be used if no data is available at all
for the requested period but may be available later (e.g. because the Device Data Recorder could temporarely not 
connect with the Personal Health Device). 
"""
* dataAbsentReason ^comment = """
If some data is available for the requested period with more data expected to come, an incomplete chunk MUST 
be provided with with the avialable vaues and `Observation.status` MUST set to _incomplete_. See section 
\"Retrieving Data\" in the HDDT specification for more details on how to deal with incomplete or missing data.
"""
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "Reference to the DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference to the Device resource that describes the personal health device itself."


ValueSet: HddtMivBloodGlucoseMeasurement
Id: hddt-miv-blood-glucose-measurement
Title: "Blood Glucose Measurement from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivBloodGlucoseMeasurement_ definiert den Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Blood Glucose Measurement_ umfasst Werte aus „blutigen Messungen“, z. B. mit kapillarem Blut aus der Fingerkuppe. Die Messungen erfolgen gemäß Versorgungsplan
(z. B. Blutzuckermessung vor jeder Mahlzeit) oder ad hoc (z. B. bei Unwohlsein des Patienten, was auf eine Hypoglykämie hindeuten kann).
DiGA-Anwendungsfälle, die durch diesen MIV abgedeckt werden, erfordern sehr genaue Glukosewerte, die für therapeutische Entscheidungen geeignet sind.

Das ValueSet für den MIV _Blood Glucose Measurement_ enthält LOINC-Codes für Blutzuckermessungen mit Blut oder Plasma als Referenzmethoden, wobei die Werte als Masse/Volumen und Mol/Volumen angegeben werden.
Zusätzlich sind granularere LOINC-Codes für „Glukose im Kapillarblut mittels Glukometer“ als Masse/Volumen und Mol/Volumen enthalten, da diese Codes bereits von mehreren Herstellern von Glukometern verwendet werden.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The ValueSet _HddtMivBloodGlucoseMeasurement_ defines the Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Blood Glucose Measurement_ covers values from \"bloody measurements\" e.g. using capillary blood from the 
finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc 
(e.g. a patient feeling dim what may be an indicator for a hypoglycamia). 
DiGA use cases served by this MIV require glucose values that are very acurate and therefore suited for therapeutical decision making. 

The ValueSet for the MIV _Blood Glucose Measurement_ contains LOINC codes for blood glucose measurements using 
blood or plasma as reference methods with the values provided as mass/volume and moles/volume. 
In addition more granular LOINC codes for \"Glucose in Capillary blood by Glucometer\" provided as mass/volume 
and moles/volume are included with the value set because these codes are already in use by several 
manufacturers of glucometers.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#2339-0 "Glucose [Mass/volume] in Blood"
* $LNC-versioned#15074-8 "Glucose [Moles/volume] in Blood"
* $LNC-versioned#2345-7 "Glucose [Mass/volume] in Serum or Plasma"
* $LNC-versioned#14749-6 "Glucose [Moles/volume] in Serum or Plasma"
* $LNC-versioned#41653-7 "Glucose [Mass/volume] in Capillary blood by Glucometer"
* $LNC-versioned#14743-9 "Glucose [Moles/volume] in Capillary blood by Glucometer"


ValueSet: HddtMivContinuousGlucoseMeasurement
Id: hddt-miv-continuous-glucose-measurement
Title: "Continuous Glucose Measurement from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivContinuousGlucoseMeasurement_ definiert den Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Continuous Glucose Measurement_ umfasst Werte aus der kontinuierlichen Überwachung des Glukosespiegels, z. B. 
durch rtCGM im Interstitialfluid (ISF). Die Messungen werden mit Sensoren durchgeführt, die eine Abtastrate von bis zu 
einem Wert pro Minute (oder sogar mehr) ermöglichen. Dadurch kann der MIV _Continuous Glucose Measurement_ z. B. genutzt werden, um Zusammenhänge
zwischen den individuellen Gewohnheiten und dem Glukosespiegel eines Patienten zu beurteilen. Aufgrund der hohen Dichte an Werten über einen langen
Zeitraum können aus _Continuous Glucose Measurement_ viele Schlüsselmetriken berechnet werden, die dem Patienten und seinem Arzt helfen,
den Gesundheits- und Therapiezustand des Patienten einfach zu erfassen.

Das ValueSet für den MIV _Continuous Glucose Measurement_ enthält Codes, die für die kontinuierliche Glukoseüberwachung (CGM) im Interstitialfluid (ISF) relevant sind, 
wobei Masse/Volumen und Mol/Volumen als gebräuchliche Einheiten berücksichtigt werden. In Zukunft können diesem ValueSet Codes für nicht-invasive Glukosemessmethoden hinzugefügt werden.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

This ValueSet defines the Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Continuous Glucose Measurement_ covers values from continuous monitoring of the glucose level, e.g. 
by rtCGM in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to 
one value per minute (or even more). By this, the MIV _Continuous Glucose Measurement_ can e.g. be used to assess dependencies between a 
patient's individual habits and behavious and his glucose level. Due to the high density of values over a long period 
of time, many key metrics can be calculated from _Continuous Glucose Measurement_ which help the patient and 
his doctor to easily capture the status of the patient's health and therapy.

The ValueSet for the MIV _Continuous Glucose Measurement_ includes codes relevant to continuous glucose 
monitoring (CGM) in interstitial fluid (ISF), considering mass/volume and moles/volume as commonly used units. 
In the future codes defining non-invasive glucose measuring methods may be added to this value set.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-03-04"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#105272-9 "Glucose [Moles/volume] in Interstitial fluid"
* $LNC-versioned#99504-3 "Glucose [Mass/volume] in Interstitial fluid"


// this is an instance, because we need to add an extension to the include for copyrights.
// for instances, we can't explicitely set `id`, but it is automaticly generated from the 'Instance' field. We also need to explicitely set the name.
Instance: hddt-device-type
InstanceOf: $shareable-vs
Usage: #definition
Title: "Device Type of personal health devices"
* name = "HddtDeviceType"
* description = """
Dieses ValueSet enthält Codes zur Identifikation von _Personal Health Devices_ und _Device Data Recordern_.

Die Definition dieses ValueSets ist eine Teilmenge der Definition des FHIR R5 ValueSet [Device Type](https://hl7.org/fhir/R5/valueset-device-type.html),
angepasst für die Verwendung mit den auf FHIR R4 basierenden HDDT-Profilen.

Dieses Material enthält SNOMED Clinical Terms® (SNOMED CT®), die mit Genehmigung der International Health Terminology Standards Development Organisation (IHTSDO) verwendet werden.
Alle Rechte vorbehalten. SNOMED CT® wurde ursprünglich vom College of American Pathologists entwickelt. 'SNOMED' und 'SNOMED CT' sind eingetragene Warenzeichen der IHTSDO.

Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch 
zwischen Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Der Inhalt des ValueSets umfasst immer mindestens alle Gerätetypen,
für die HDDT _Mandatory Interoperable Values_ (MIVs) definiert. Damit kann dieses ValueSet zukünftig auch Codes enthalten, die nicht Teil des FHIR ValueSet _Device Type_ sind.

--

This ValueSet includes codes used to identify Personal Health Devices and Device Data Recorders.

This ValueSet's definition is a subset of the definition of the FHIR R5 ValueSet 
[Device Type](https://hl7.org/fhir/R5/valueset-device-type.html), adapted for use with the FHIR R4 based HDDT profiles. 

This material includes SNOMED Clinical Terms® (SNOMED CT®) which is used by permission of the International Health Terminology Standards Development Organisation (IHTSDO).
All rights reserved. SNOMED CT®, was originally created by The College of American Pathologists. 'SNOMED' and 'SNOMED CT' are registered trademarks of the IHTSDO.

CAVE: This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). The content of the value set will always at latest
cover all types of device types for whoch HDDT defines _Mandatory Interoperable Values_ (MIVs). By this, this value set MAY
in the future include codes which are not part of the FHIR ValueSet _Device Type_. 
"""
* meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-01"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"

* status = #active
* experimental = false
* date = "2026-03-04"
* publisher = "gematik GmbH"
* contact.telecom[0].system = #url
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "The copyright for the compilation of this value set is held by gematik GmbH and by Federal Institute for Drugs and Medical Devices (BfArM)."
* compose.include[0].system = $sct
* compose.include[0].version = $sct-version-suffix
* compose.include[0].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[0].extension[0].valueString = "his valueset includes SNOMED Clinical Terms® (SNOMED CT®) which is used by permission of the International Health Terminology Standards Development Organisation (IHTSDO). All rights reserved. SNOMED CT®, was originally created by The College of American Pathologists. 'SNOMED' and 'SNOMED CT' are registered trademarks of the IHTSDO."
* compose.include[0].concept[0].code = #337414009
* compose.include[0].concept[=].display = "Blood glucose meter (physical object)"
* compose.include[0].concept[+].code = #700585005
* compose.include[0].concept[=].display = "Invasive interstitial-fluid glucose monitoring system (physical object)"
* compose.include[0].concept[+].code = #701815004
* compose.include[0].concept[=].display = "Non-invasive interstitial-fluid glucose monitoring system (physical object)"
* compose.include[0].concept[+].code = #702203005
* compose.include[0].concept[=].display = "Invasive interstitial fluid glucose monitoring/insulin infusion system (physical object)"
* compose.include[0].concept[+].code = #463729000
* compose.include[0].concept[=].display = "Point-of-care blood glucose continuous monitoring system (physical object)"
* compose.include[0].concept[+].code = #701750003
* compose.include[0].concept[=].display = "Subcutaneous glucose sensor (physical object)"
* compose.include[0].concept[+].code = #70665002
* compose.include[0].concept[=].display = "Blood pressure cuff, device (physical object)"
* compose.include[0].concept[+].code = #334990001
* compose.include[0].concept[=].display = "Peak flow meter (physical object)"
* compose.include[0].concept[+].code = #303501006
* compose.include[0].concept[=].display = "Spirometer (physical object)"



Instance: HddtCgmSummaryOperation
InstanceOf: OperationDefinition
Usage: #definition
Title: "Search Operation for summary data measurement"
Description: """
The `$hddt-cgm-summary` operation is defined on the *Observation* resource type.  
It allows clients to request CGM summary data filtered by effective period, and optionally include related device context (Device, DeviceMetric).  

**Use cases supported by this operation include:**  
- Retrieving CGM summary statistics (mean glucose, time-in-range, GMI, etc.) for a patient over a specified interval  

**Input Parameters:**  
- `effectivePeriodStart` *(dateTime, optional)*: Lower bound of the observation effective period.  
- `effectivePeriodEnd` *(dateTime, optional)*: Upper bound of the observation effective period.  
- `related` *(boolean, optional)*: If true, the response bundle also contains related Device and DeviceMetric resources.  

**Output Parameter:**  
- `result` *(Reference, required)*: A Bundle conforming to profile `HddtCgmSummary` profile containing all matching CGM Observations and, if requested, their related devices.  

**Error handling (OperationOutcome):**  
- `MSG_PARAM_UNKNOWN`: Returned when an unsupported input parameter is used.  
- `MSG_PARAM_INVALID`: Returned when a parameter value is invalid (e.g., bad date format).  
- `MSG_NO_MATCH`: Returned when no matching observations are found. 
- `MSG_BAD_SYNTAX`: Returned when the request is malformed.  
"""

* id = "hddt-cgm-summary-operation"
* name = "HddtCgmSummaryOperation"
* title = "Search Operation for summary data measurement"
* status = #active
* version = $term-version
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2026-03-04"
* affectsState = false
* code = #hddt-cgm-summary
* system = false
* type = true
* instance = false
* parameter[+].name = #effectivePeriodStart
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "Start of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #effectivePeriodEnd
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "End of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #related
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "If true, include related Device and DeviceMetric in the result bundle"
* parameter[=].type = #boolean
* parameter[+].name = #result
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].documentation = "Result bundle (HTTP 200 OK) containing summary data of measurements and optionally related resources"
* parameter[=].type = #Reference
* parameter[=].targetProfile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-cgm-summary"


Instance: hddt-miv-lung-function-testing
InstanceOf: $shareable-vs
Usage: #definition
Title: "MIV Lung Function Testing from LOINC"

* name = "HddtMivLungFunctionTesting"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivLungFunctionTesting_ definiert den Mandatory Interoperable Value (MIV) \"Lung Function Testing\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Lung Function Testing_ umfasst Werte aus Lungenfunktionstests, die durch Ausatmen in ein handgehaltenes Peak-Flow-Meter oder Spirometer durchgeführt werden.
Die Messungen erfolgen zweimal täglich oder häufiger, wenn dies durch den Versorgungsplan oder den Zustand des Patienten erforderlich ist.

Das ValueSet für den MIV _Lung Function Testing_ enthält LOINC-Codes für die Messung des _Peak Expiratory Flow_ (PEF) und des Forcierten Exspiratorischen Volumens in 1 Sekunde (FEV1).
Ebenfalls enthalten sind LOINC-Codes für die entsprechenden Referenzwerte sowie relative Werte (z. B. _FEV1 measured/predicted_). Dieses ValueSet enthält die LOINC-Codes nicht direkt, sondern die Codes stammen aus drei separaten ValueSets:
- HddtLungFunctionTestingValues: Codes für einzelne Lungenfunktionstests
- HddtLungFunctionReferenceValues: Codes für Referenzwerte der Lungenfunktion
- HddtLungFunctionRelativeValues: Codes für relative Lungenfunktionswerte, berechnet in Prozent (%)

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

This ValueSet defines the Mandatory Interoperable Value (MIV) \"Lung Function Testing\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_.

The MIV _Lung Function Testing_ covers values from lung function testings that are performed by exhaling air
into a hand-held peak flow meter or spirometer. Measurements are performed twice a day, or more frequently if required
by the care plan or the patient's condition.

The ValueSet for the MIV _Lung Function Testing_ includes LOINC codes for measuring the Peak Expiratory Flow (PEF) and
Forced Expiratory Volume in 1 second (FEV1). Also included are LOINC codes for the corresponding reference values, and 
relative values (e.g. FEV1 measured/predicted). This ValueSet does not include LOIC codes directly, instead the codes 
come from three separate ValueSets:
- HddtLungFunctionTestingValues: codes for individual lung function testings
- HddtLungFunctionReferenceValues: codes for lung function reference values
- HddtLungFunctionRelativeValues: codes for relative lung function values, calculated in percentages (%)
"""
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-01"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"
* status = #active
* experimental = false
* date = "2026-03-04"
* publisher = "gematik GmbH"
* contact.telecom[0].system = #url
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[0].valueSet = Canonical(HddtLungFunctionTestingValues|1.0.0-rc2)
* compose.include[1].valueSet = Canonical(HddtLungFunctionReferenceValues|1.0.0-rc2)
* compose.include[2].valueSet = Canonical(HddtLungFunctionRelativeValues|1.0.0-rc2)


ValueSet: HddtLungFunctionTestingValues
Id: hddt-lung-function-testing-values
Title: "Lung Function Testing Values from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die Codes für einzelne Lungenfunktionstests, die mit handgehaltenen Peak-Flow-Metern oder Spirometern gemessen werden.
Enthalten sind Codes für den _Peak Expiratory Flow_ (PEF) und das Forcierte Exspiratorische Volumen in 1 Sekunde (FEV1).

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the codes used for individual lung function testings, measured by hand-held peak flow meters or spirometers.
Included are codes for Peak Expiratory Flow (PEF) and Forced Expiratory Volume in 1 second (FEV1).
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#19935-6 "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
* $LNC-versioned#20150-9 "FEV1"

ValueSet: HddtLungFunctionReferenceValues
Id: hddt-lung-function-reference-values
Title: "Lung Function Reference Values from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die LOINC-Codes, die für Referenzwerte der Lungenfunktion verwendet werden:
- Der Referenzwert für den _Peak Expiratory Flow_ (PEF) ist der persönliche Bestwert, den der Patient innerhalb eines bestimmten Zeitraums erreicht hat.
- Der Referenzwert für das Forcierte Exspiratorische Volumen in 1 Sekunde (FEV1) ist in den meisten Fällen ein vorhergesagter Wert, der auf Basis der demografischen Daten des Patienten berechnet wird.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the LOINC codes, used for lung function reference values:
- The reference value for Peak Expiratory Flow (PEF) is the personal best value achieved by the patient within a certain time frame. 
- The reference value for Forced Expiratory Volume in 1 second (FEV1) is in most cases a predicted value, calculated based on demographic data of the patient.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#83368-1 "Personal best peak expiratory gas flow Respiratory system airway"
* $LNC-versioned#20149-1 "FEV1 predicted"

ValueSet: HddtLungFunctionRelativeValues
Id: hddt-lung-function-relative-values
Title: "Lung Function Relative Values from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die LOINC-Codes, die für relative Lungenfunktionswerte verwendet werden. Der relative Wert wird berechnet, indem die 
individuelle Messung durch den Referenzwert geteilt wird, was zu einem Prozentwert (%) führt. Enthaltene Codes sind für
- FEV1 measured/predicted
- PEF measured/predicted

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the LOINC codes, used for relative lung function values. The relative value is calculated by dividing the 
individual measurement by the reference value, resulting in a percentage value (%). Included codes are for 
- FEV1 measured/predicted
- PEF measured/predicted
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#20152-5 "FEV1 measured/predicted"
* HddtLungFunctionTemporaryCodes|1.0.0-rc2#PEF-measured/predicted

Profile: HddtLungFunctionTesting
Parent: Observation
Id: hddt-lung-function-testing
Title: "Observation – Lung Function Testing"
Description: """
Profile for capturing lung function testings as FHIR Observation resources.

This profile defines the exchange of a single measurement data for the Mandatory Interoperable Value (MIV) \"Lung Function Testing\" which is technically defined 
by the ValueSet _hddt-miv-lung-function-testing_. This MIV is e.g. implemented by peak flow meter that can connect to 
a Personal Health Gateway (e.g. a mobile app for tracking lung function values) through wireless or wired communication.

**Obligations and Conventions:**

Each Lung Function Testing MUST either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). Typically the reference will be 
to a [Device](https://hl7.org/fhir/R4/device.html) resource, but the option to reference a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) 
resource is provided for compatibility with the overarching HDDT specification.

**Constraints applied:**  
- `status` is restricted to _final_
- `code` is constrained to a subset of the _MIV Lung Function Testing_ ValueSet, defined by the _HddtLungFunctionTestingValues_ ValueSet.
- `effective[x]` is restricted to `effectiveDateTime` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `device` is set to be mandatory in order to provide the DiGA with information about the sensor's calibration status and with information about the static and dynamic attributes of the Personal Health Device.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url 
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* code from HddtLungFunctionTestingValues (required)
* code ^short = "Raw measurement type for lung function"
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for lung function testings. Constrained via invariant to either PEF or FEV1."
* effective[x] 1..1
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time when the lung function testing was taken."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Measured lung function value"
* value[x] ^definition = "The quantitative lung function value, measured either in liters (L) for FEV1 or liters per minute (L/min) for PEF, represented as a UCUM Quantity."
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code ^definition = "The UCUM code representing the unit of the lung function testing. The UCUM code MUST be compliant with the example unit that is linked with the LOINC code given as `Observation.code`."
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet. The UCUM code MUST be compliant with the unit that is linked with the LOINC code given as `Observation.code`."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device"
* device ^definition = "References a Device resource that describes the personal health device."


CodeSystem: HddtLungFunctionReferenceValueMethodCodes
Id: hddt-lung-function-reference-value-method-codes
Title: "Lung Function Reference Value Method Codes"
Description: """
Dieses CodeSystem ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Der MIV _HddtMivLungFunctionTesting_ erfordert Referenzwerte zur Bewertung gemessener Lungenfunktionswerte. Diese Referenzwerte können mit unterschiedlichen
Methoden bestimmt werden. Dieses CodeSystem stellt Codes zur Verfügung, um typische Methoden zur Bestimmung von Lungenfunktions-Referenzwerten auszudrücken.

--

This CodeSystem is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The MIV _HddtMivLungFunctionTesting_ requires reference values for evaluating measured lung function values. These reference
values can be determined using different methods. This CodeSystem provides codes to express typical methods for determining lung function reference values.
"""
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^publisher = "gematik GmbH"
* ^date = "2026-03-04"
* ^contact.telecom[0].system = #url 
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* ^experimental = false
* ^caseSensitive = false

* #personal-best "Personal Best"
    "Reference value based on the personal best value achieved by the patient within a certain time frame."
* #GLI-2012 "Predicted Value according to Global Lung Initiative 2012"
    "Reference value calculated based on the Global Lung Initiative 2012 equations. I.e the patient's 'race' is considered."
* #GLI-2022 "Predicted Value according to Global Lung Initiative 2022"
    "Reference value calculated based on the Global Lung Initiative 2022 equations. I.e. a 'race'-neutral approach is used."
* #other "Other"
    "Other method used to determine the lung function reference value. Specify details via text input."

CodeSystem: HddtLungFunctionTemporaryCodes
Id: hddt-lung-function-temporary-codes
Title: "Lung Function Temporary Codes"
Description: """
Temporäre Codes für den MIV _Lung Function Testing_, bis LOINC-Codes verfügbar sind.

--

Temporary codes for the MIV _Lung Function Testing_ until LOINC codes are avaiblable.
"""
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^experimental = false
* ^caseSensitive = false
* ^status = #active
* ^publisher = "gematik GmbH"
* ^date = "2026-03-04"
* ^contact.telecom[0].system = #url 
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* #PEF-measured/predicted "PEF measured/predicted"

Instance: HddtLungFunctionTemporaryToLoinc
InstanceOf: ConceptMap
Usage: #definition
Title: "Lung Function Temporary Codes to LOINC"
Description: """
Eine Abbildung von temporären Codes, die im CodeSystem _HddtLungFunctionTemporaryCodes_ definiert sind, auf LOINC-Codes.
Falls noch kein LOINC-Code verfügbar ist, wird dies mit einer Äquivalenz von 'unmatched' angezeigt.
Sobald ein LOINC-Code für einen temporären Code verfügbar ist, wird diese ConceptMap entsprechend aktualisiert.

--

A mapping from temporary codes defined in the _HddtLungFunctionTemporaryCodes_ CodeSystem to LOINC codes.
In case no LOINC code is available yet, the mapping indicates that with an equivalence of 'unmatched'.
Whenever a LOINC code becomes available for a temporary code, this ConceptMap will be updated accordingly.
"""
* experimental = false
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-01"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"
* name = "HddtLungFunctionTemporaryToLoinc"
* status = #active
* publisher = "gematik GmbH"
* date = "2026-03-04"
* contact.telecom[0].system = #url 
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "gematik GmbH."
* group[+].source = Canonical(HddtLungFunctionTemporaryCodes|1.0.0-rc2)
* group[=].target = $LNC
* group[=].element[+].code = #PEF-measured/predicted
* group[=].element[=].target.comment = "No target LOINC code available yet."
* group[=].element[=].target.equivalence = #unmatched


ValueSet: HddtLungFunctionReferenceValueMethod
Id: hddt-lung-function-reference-value-method
Title: "Lung Function Reference Value Method"
Description: """
Ein ValueSet für Codes, die die Methode zur Bestimmung von Referenzwerten der Lungenfunktion angeben. Enthalten sind Codes aus dem CodeSystem _HddtLungFunctionReferenceValueMethodCodes_:
- Personal Best (persönlicher Bestwert)
- Vorhergesagter Wert gemäß Global Lung Initiative 2012
- Vorhergesagter Wert gemäß Global Lung Initiative 2022
- Sonstige

--

A ValueSet for codes used to specify the method used to determine lung function reference values. Included are codes from the _HddtLungFunctionReferenceValueMethodCodes_ CodeSystem:
- Personal Best
- Predicted Value according to Global Lung Initiative 2012
- Predicted Value according to Global Lung Initiative 2022
- Other
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* include codes from system https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-reference-value-method-codes|1.0.0-rc2

Profile: HddtLungFunctionReferenceValue
Parent: Observation
Id: hddt-lung-reference-value
Title: "Observation – Lung Function Reference Value"
Description: """
Profile for capturing the refence values as a FHIR Observation resource when evaluating lung function testings.

This profile defines the exchange of a single reference value for the Mandatory Interoperable Value (MIV) \"Lung Function Testing\" which is technically defined 
by the ValueSet _hddt-miv-lung-function-testing_. This MIV is e.g. implemented by peak flow meter that can connect to 
a Personal Health Gateway (e.g. a mobile app for tracking lung function values) through wireless or wired communication.

**Obligations and Conventions:**

Each Lung Function Testing MAY either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). Typically the reference will be 
to a [Device](https://hl7.org/fhir/R4/device.html) resource, but the option to reference a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) 
resource is provided for compatibility with the overarching HDDT specification.

**Constraints applied:**  
- `status` is restricted to _final_
- `code` is constrained to a subset of the _MIV Lung Function Reference Values_ ValueSet, defined by the _HddtLungFunctionReferenceValues_ ValueSet.
- `effective[x]` is restricted to `effectivePeriod` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `method` is considered mandatory in order to provide information about the method used to determine the reference value. It can be either a code from the _HddtLungFunctionReferenceValueMethod_ ValueSet or a text description.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* code from HddtLungFunctionReferenceValues (required)
* code ^short = "Reference measurement type for lung function"
* code ^binding.description = "Specifies for which measurement type the reference value is, using codes from the ValueSet for lung function testings. Constrained via invariant to either PEF or FEV1."
* effective[x] 0..1
* effective[x] only Period
* effective[x] ^short = "Time period for which reference value is valid"
* effective[x] ^definition = "The time period for which the lung function reference value is valid. If the reference value is still active, then only the start of the period is provided."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Reference lung function value"
* value[x] ^definition = "The quantitative reference value, measured either in liters (L) for FEV1 or liters per minute (L/min) for PEF, represented as a UCUM Quantity."
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code ^definition = "The UCUM code representing the unit of the lung function testing. The UCUM code MUST be compliant with the example unit that is linked with the LOINC code given as `Observation.code`."
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet. The UCUM code MUST be compliant with the unit that is linked with the LOINC code given as `Observation.code`."
* method 0..1
* method MS
* method only CodeableConcept
* method ^short = "Method for determining the reference value"
* method ^definition = "The method used to determine the lung function reference value. Preferred is the usage of a code from the Lung Function Reference Value Method ValueSet, but as an alternative a text description of the used formula for calculating the reference value can be provided."
* method.coding 0..1
* method.coding from HddtLungFunctionReferenceValueMethod (required)
* method.coding ^binding.description = "Specifies the method used to determine the lung function reference value using codes from the Lung Function Reference Value Method ValueSet."
* method.text 0..1
* method.text ^definition = "In case no code is provided, specify whether the value is a personal best or predicted or calculated based on some formula."
* device 0..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device"
* device ^definition = "References a Device resource that describes the personal health device."

Profile: HddtLungFunctionTestingComplete
Parent: Observation
Id: hddt-lung-function-testing-complete
Title: "Observation – Complete Lung Function Testing"
Description: """
Profile for capturing the relative lung function testings (i.e. an individual measurement divided by the corresponding reference value) 
as FHIR Observation resources.

This profile defines the exchange of a single relative value for the Mandatory Interoperable Value (MIV) \"Lung Function Testing\" which is technically defined 
by the ValueSet _hddt-miv-lung-function-testing_. This MIV is e.g. implemented by peak flow meter that can connect to 
a Personal Health Gateway (e.g. a mobile app for tracking lung function values) through wireless or wired communication.

**Obligations and Conventions:**

Each Lung Function Testing MAY either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). Typically the reference will be 
to a [Device](https://hl7.org/fhir/R4/device.html) resource, but the option to reference a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) 
resource is provided for compatibility with the overarching HDDT specification.

Each instance of this Observation MUST reference the Observations holding the corresponding raw measurement and reference value via the `derivedFrom` element.

**Constraints applied:**  
- `status` is restricted to _final_
- `code` is constrained to a subset of the _MIV Lung Function Relative Values_ ValueSet, defined by the _HddtLungFunctionRelativeValues_ ValueSet.
- `effective[x]` is restricted to `effectiveDateTime` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `derivedFrom` is constrained to require exactly two references: one to the raw lung function testing Observation and one to the lung function reference value Observation.
"""
* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* code from HddtLungFunctionRelativeValues (required)
* code ^short = "Percentage measurement type for lung function"
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for lung function testing as percentage of the reference value. Constrained via invariant to either PEF or FEV1."
* effective[x] 1..1
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time when the lung function testing was taken."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Calculated lung function value as percentage of reference value"
* value[x] ^definition = "The lung function value represented as percentage of the reference value"
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code ^definition = "The UCUM code representing the unit of the lung function testing. The UCUM code MUST be compliant with the example unit that is linked with the LOINC code given as `Observation.code`."
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet. The UCUM code MUST be compliant with the unit that is linked with the LOINC code given as `Observation.code`."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device"
* device ^definition = "References a Device resource that describes the personal health device."
* derivedFrom 2..2
* derivedFrom ^slicing.discriminator.type = #profile
* derivedFrom ^slicing.discriminator.path = "resolve()"
* derivedFrom ^slicing.rules = #closed
* derivedFrom ^slicing.description = "Slice to require one reference to a measurement and one to a reference value"
* derivedFrom contains
    measurement 1..1 and
    referenceValue 1..1
* derivedFrom[measurement] only Reference(HddtLungFunctionTesting)
* derivedFrom[measurement] ^short = "Reference to raw lung function testing"
* derivedFrom[measurement] ^definition = "Reference to the lung function testing Observation that holds the actual measured value."
* derivedFrom[referenceValue] only Reference(HddtLungFunctionReferenceValue)
* derivedFrom[referenceValue] ^short = "Reference to lung function reference value"
* derivedFrom[referenceValue] ^definition = "Reference to the Observation holding the reference range and information about the reference range determination method."


ValueSet: HddtMivBloodPressureValue
Id: hddt-miv-blood-pressure-value
Title: "Blood Pressure Value from LOINC"
Description: """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivBloodPressureValue_ definiert den Mandatory Interoperable Value (MIV) \"Blood Pressure Monitoring\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Blood Pressure Monitoring_ umfasst Werte aus Blutdruckmessungen, die mit oszillometrischen oder auskultatorischen, automatisierten 
Sphygmomanometern durchgeführt werden. Die Messungen erfolgen gemäß Versorgungsplan (z. B. täglich oder einmal pro Woche).
DiGA-Anwendungsfälle, die durch diesen MIV abgedeckt werden, erfordern genaue Blutdruckwerte, die für therapeutische Entscheidungen geeignet sind.

Das ValueSet für den MIV _Blood Pressure Monitoring_ enthält den LOINC-Code für das vollständige Blutdruck-Panel, sollte aber auch die Möglichkeit bieten, in zukünftigen Updates zusätzliche Codes aufzunehmen.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The ValueSet _HddtMivBloodPressureValue_ defines the Mandatory Interoperable Value (MIV) \"Blood Pressure Monitoring\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Blood Pressure Monitoring_ covers values from blood pressure measurements performed using oszillometric or auscultatory, automated 
sphygmomanometers. Measurements are performed based on a care plan (e.g., daily or once per week).
DiGA use cases served by this MIV require blood pressure values that are accurate and therefore suited for therapeutic decision making. 

The ValueSet for the MIV _Blood Pressure Monitoring_ contains the LOINC code for complete blood pressure panel, but should still have the option to include additional code in future updates.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-04"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* $LNC-versioned#85354-9 "Blood pressure panel with all children optional"


Profile: HddtBloodPressureValue
Parent: $bp-sd
Id: hddt-blood-pressure-value
Title: "Observation - HDDT Blood Pressure Value"
Description: """
Profile for capturing blood pressure value as FHIR Observation resources.

This profile defines the exchange of blood pressure value data for the Mandatory Interoperable Value (MIV) \"Blood Pressure Monitoring\" which is technically defined 
by the ValueSet _hddt-miv-blood-pressure-value_. This MIV is e.g. implemented by automated sphygmomanometers (oszillometric, auscultatory) that can connect to 
a Personal Health Gateway (e.g. a mobile app for tracking blood pressure values) through wireless communication.

Blood pressure measurements consist of multiple components: systolic blood pressure, diastolic blood pressure, and optionally mean blood pressure. 
This profile uses the LOINC panel code #85354-9 "Blood pressure panel with all children optional" defined in the MIV _hddt-miv-blood-pressure-value_ to represent the complete measurement.

**Obligations and Conventions:**

Each Blood Pressure Measurement MUST hold a reference to a _Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource. 
Blood pressure devices typically do not require calibration.

This profile inherits from the FHIR Blood Pressure profile (`http://hl7.org/fhir/StructureDefinition/bp`) and adds HDDT-specific constraints. The blood pressure components 
(systolic and diastolic are mandatory; mean is optional) are inherited from the parent profile with the MeanBP component added as an optional slice.
Each component MUST include a value in mmHg (millimeters of mercury).

Caution: For privacy and data protection, the subject reference MUST only use pseudonymized or anonymized identifiers. Direct patient identification is not permitted.

**Constraints applied:**  
- `status` is restricted to _final_
- `code.coding[BPCode]` is constrained to ValueSet HddtMivBloodPressureValue containing LOINC panel code 85354-9
- `component` cardinality is set to 2..3 to require systolic and diastolic components (inherited from parent), with mean blood pressure as optional
- `component[MeanBP]` is added as an optional slice (0..1) for mean blood pressure with LOINC code 8478-0
- Each component's `valueQuantity` MUST use UCUM code mm[Hg] for the unit
- `device` is mandatory and restricted to reference only HddtPersonalHealthDevice
"""
* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* status MS
* subject ^short = "Patient reference in anonymized or pseudonymized form only"
* subject ^definition = "Reference to the patient. The patient MUST NOT be identified directly. Only anonymized or pseudonymized forms are permitted."
* code 1..1
// * code.coding[BPCode] from HddtMivBloodPressureValue (required)
* code.coding[loinc] from HddtMivBloodPressureValue (required)
* code.coding[snomed] 0..0
* code ^short = "Type of blood pressure measurement"
* code ^binding.description = "Specifies the type of blood pressure measurement using codes from the ValueSet for blood pressure measurements."
* device 1..1
* device only Reference(HddtPersonalHealthDevice)
* device ^short = "Reference to the blood pressure measurement device"
* device MS
* component[SystolicBP].value[x] MS
* component[SystolicBP].valueQuantity MS
* component[DiastolicBP].value[x] MS
* component[DiastolicBP].valueQuantity MS
