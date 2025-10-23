Alias: $cgm-summary = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary
Alias: $cgm-summary-mean-glucose-mass-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-mass-per-volume
Alias: $cgm-summary-mean-glucose-moles-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-moles-per-volume
Alias: $cgm-summary-times-in-ranges = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-times-in-ranges
Alias: $cgm-summary-gmi = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-gmi
Alias: $cgm-summary-coefficient-of-variation = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-coefficient-of-variation
Alias: $cgm-summary-days-of-wear = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-days-of-wear
Alias: $cgm-summary-sensor-active-percentage = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-sensor-active-percentage
Alias: $ucum-units = http://hl7.org/fhir/ValueSet/ucum-units
// Alias: $DeviceDefinition = http://device-registry.bfarm.de/fhir/StructureDefinition/DeviceDefinition

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
and consists of the machine-readable parts of the [_HL7 CGM summary profile_](https://build.fhir.org/ig/HL7/cgm/). 

The Bundle is of type *collection* and MUST contain only resources of the following types:  
- Observations conforming to [HL7 CGM profiles](https://build.fhir.org/ig/HL7/cgm/): 
    - [CGM Summary Observation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)
    - [Mean Glucose (Mass)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
    - [Mean Glucose (Moles)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
    - [Times in Ranges](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-times-in-ranges.html)
    - [Glycemic Variability Index (GMI)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-gmi.html)
    - [Coefficient of Variation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-coefficient-of-variation.html)
    - [Days of Wear](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-days-of-wear.html)!
    - [Sensor Active Percentage](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-sensor-active-percentage.html)

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
// * ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of CGM summary Observations and optionally related Device and DeviceMetric resources returned by the $hddt-cgm-summary operation."
* entry 1..*
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or HddtPersonalHealthDevice 
* entry.resource ^short = "Observations with their related Device and DeviceMetric information"

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
The minimum delay that the concrete end-to-end synchronization from the Personal Health Device to the device backend imposes is provided by the BfArM _HIIS-VZ_ (Device Registry)
through the static attribute `Delay-From-Real-Time`. If a resource server has not synchronized with the connected Personal Health Device for a time span 
longer than `Delay-From-Real-Time`(e.g. due to temporarely lost Bluetooth or internet connectivity), the `status` of the Device resource that represents the 
Personal Health Device MUST be set to `unknown`.

**Constraints applied:**  
- `status` is set to _Must Support_ in order to allow a DiGA to detect missing data (e.g. due to connection issues)
- `deviceName` and `serialNumber` are set to _Must Support_ to allow a validation of the source of device data by comparing this information with information printed on the Personal Health Device
- `definition` is constrained as a mandatory element in order to enable a DiGA to obtain static device attributes through this reference
- `expirationDate` is set to _Must Support_ to allow a DiGA to be aware of regular sensor changes (e.g. for patient wearing a rtCGM)
"""
// * ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Personal Health Device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device MUST be a medical aid or implant."
* type from HddtDeviceType (required)
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
* definition 1..1
* definition only Reference(DeviceDefinition)
* definition ^short = "Definition of the Personal health device"
* definition ^definition = "Reference to a DeviceDefinition resource that describes the technical and functional details of the Personal health device."
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

Personal Health Devices need to be calibrated in order to provide safe measurements. Some devcices are already calibrated by the 
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
contain multiple sensors for different measured values. E.g. by this a pulseoximeter as a HDDT Personal Health Device can 
provide _pulse_ and _SPO2_ as two diffferent interoperable values with each of this values being linked with a 
dedicated HddtSensorTypeAndCalibrationStatus resource. 

**Obligations and Conventions:**

DiGA as device data consumers SHOULD NOT rely on the `DeviceMetric.operationalStatus` of a sensor as this status does only reflects the status of the sensor 
and does not provide information abaout the end-to-end status of the flow of device data from the sensor within the Personal Health device 
to the resource server in the device backend. Instead DiGA SHOILD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element consideres the end-to-end availability of data and therefore is the only source for 
information about potentially missing data (e.g. due to temporal problems with the bluetooth or internet connection).

**Constraints applied:**  
- `unit` is restricted to UCUM. 
- `source` is constrained as a mandatory element in order to enable a DiGA to obtain dynamic and static device attributes through this reference
- `calibration` is set to _Must Support_. This element and respective status information MUST be provided if the sensor performs automated or requires manual calibration after the device has been put into operation with the patient (`Device.status`is `active`).
"""
// * ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
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
DiGA as device data consumers SHOULD NOT rely on the `operationalStatus` of a sensor as this status does only reflects the status of the sensor 
and does not provide information abaout the end-to-end status of the flow of device data from the sensor within the Personal Health device 
to the resource server in the device backend. Instead DiGA SHOILD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element consideres the end-to-end availability of data and therefore is the only source for 
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
an Personal Health Gateway (e.g. a mobile app for keeping diabetes diary) through wireless or wired communication.

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
// * ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
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
// * ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Chunk of continuous glucose measurements"
* . ^definition = "An Observation representing a continuous glucose measurement (CGM) series over a defined effective period, captured as SampledData from a personal health device."
* status ^short = "Status of the continuous glucose measurements chunk"
* status ^definition = "The status of the continuous glucose measurements chunk. The status 'final' means the measurement is complete and verified; 'preliminary' means the data MAY be still being collected and not complete. It SHOULD be called at a later time for collecting complete data."
* code from HddtMivContinuousGlucoseMeasurement (required)
* code ^short = "Type of continuous glucose measurement"
* code ^binding.description = "Specifies the type of continuous glucose measurement using codes from the ValueSet for CGM measurements."
* effective[x] 1..1
* effective[x] only Period
* effective[x] ^short = "Time interval of CGM measurements chunk"
* effective[x] ^definition = "The time span covered by this chunk of continuous glucose measurements. The chunk-time-span is defined by the data recorder of the personal health device."
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
Title: "ValueSet - Blood Glucose Measurement from LOINC"
Description: """
This ValueSet defines the Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Blood Glucose Measurement_ covers values from \"bloody measurements\" e.g. using capillary blood from the 
finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc 
(e.g. a patient feeling dim what may be an indicator for a hypoglycamia). 
Values are very acurate and therefore suited for therapeutical decision making. 

The ValueSet for the MIV _Blood Glucose Measurement_ contains LOINC codes for blood glucose measurements using 
blood or plasma as reference methods with the values provided as mass/volume and moles/volume. 
In addition more granular LOINC codes for \"Glucose in Capillary blood by Glucometer\" provided as mass/volume 
and moles/volume are included with the value set because these codes are already in use by several 
manufacturers of glucometers.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
// * ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-blood-glucose-measurement"
// * ^version = "0.1.1"
* ^status = #draft
* ^experimental = false
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* LOINC#2339-0 "Glucose [Mass/volume] in Blood"
* LOINC#15074-8 "Glucose [Moles/volume] in Blood"
* LOINC#2345-7 "Glucose [Mass/volume] in Serum or Plasma"
* LOINC#14749-6 "Glucose [Moles/volume] in Serum or Plasma"
* LOINC#41653-7 "Glucose [Mass/volume] in Capillary blood by Glucometer"
* LOINC#14743-9 "Glucose [Moles/volume] in Capillary blood by Glucometer"


ValueSet: HddtMivContinuousGlucoseMeasurement
Id: hddt-miv-continuous-glucose-measurement
Title: "ValueSet – Continuous Glucose Measurement from LOINC"
Description: """
This ValueSet defines the Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Continuous Glucose Measurement_ covers values from continuous monitoring of the glucose level, e.g. 
by rtCGM in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to 
one value per minute. By this _Continuous Glucose Measurement_ can e.g. be used to assess dependencies between a 
patient's individual habits and behavious and his glucose level. Due to the high density of values over a long period 
of time, many key metrics can be calculated from _Continuous Glucose Measurement_ which help the patient and 
his doctor to easily capture the status of the patient's health and therapy.

The ValueSet for the MIV _Continuous Glucose Measurement_ includes codes relevant to continuous glucose 
monitoring (CGM) in interstitial fluid (ISF), considering mass/volume and moles/volume as commonly used units. 
In the future codes defining non-invasive glucose measuring methods may be added to this value set.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
// * ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-continuous-glucose-measurement"
// * ^version = "0.1.1"
* ^status = #draft
* ^experimental = false
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* LOINC#105272-9 "Glucose [Moles/volume] in Interstitial fluid"
* LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"


ValueSet: HddtDeviceType
Id: hddt-device-type
Title: "Device Type of personal health devices"
Description: """
This ValueSet includes codes used to identify Personal Health Devices, Device Data Recorders, and DIGA. 

This ValueSet's definition is an unchanged copy of the definition of the FHIR R5 ValueSet 
[Device Type](https://hl7.org/fhir/R5/valueset-device-type.html) for use with the FHIR R4 based HDDT profiles. 

This ValueSet includes
concepts from ISO/IEEE 11073-10101:2020, SNOMED CT and HL7 International. Codes from the 
_ISO/IEEE 11073-10101 Health informatics — Point-of-care medical device communication — Nomenclature standard_ are 
included under the terms of HL7 International’s licensing agreement with the IEEE. Users of this specification 
may reference individual codes as part of HL7 FHIR-based implementations. However, the full ISO/IEEE 11073 
code system and its contents remain copyrighted by ISO and IEEE.
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-device-type"
// * ^version = "0.1.1"
* ^status = #draft
* ^experimental = true
* ^date = "2025-09-26"
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* Mdc#528391 "Blood Pressure Cuff"
* Mdc#528404 "Body Composition Analyzer"
* Mdc#528425 "Cardiovascular Device"
* Mdc#528402 "Coagulation meter"
* Mdc#528409 "Continuous Glucose Monitor"
* Mdc#528390 "Electro cardiograph"
* Mdc#528457 "Generic 20601 Device"
* Mdc#528401 "Glucose Monitor"
* Mdc#528455 "Independent Activity/Living Hub"
* Mdc#528403 "Insulin Pump"
* Mdc#528405 "Peak Flow meter"
* Mdc#528388 "Pulse Oximeter"
* Mdc#528397 "Respiration rate"
* Mdc#528408 "Sleep Apnea Breathing Equipment"
* Mdc#528426 "Strength Equipment"
* Mdc#528392 "Thermometer"
* Mdc#528399 "Weight Scale"
// * urn:oid:2.16.840.1.113883.6.276#38017 "Dry salt inhalation therapy device"
// * urn:oid:2.16.840.1.113883.6.276#38663 "Flexible video nephroscope"
// * urn:oid:2.16.840.1.113883.6.276#42347 "Dental implant, endosseous, partially-embedded"
// * urn:oid:2.16.840.1.113883.6.276#46352 "Bare-metal intracranial vascular stent"
// * urn:oid:2.16.840.1.113883.6.276#47264 "Dual-chamber implantable pacemaker, demand"
// * urn:oid:2.16.840.1.113883.6.276#62163 "Intrauterine cannula, reusable"
// * urn:oid:2.16.840.1.113883.6.276#62260 "Air-conduction hearing aid acoustic tube"
// * urn:oid:2.16.840.1.113883.6.276#62423 "Spinal cord/peripheral nerve implantable analgesic electrical stimulation system lead, wired connection"
// * urn:oid:2.16.840.1.113883.6.276#62414 "Blue-light phototherapy lamp, home-use"
// * urn:oid:2.16.840.1.113883.6.276#64587 "Uncoated knee femur prosthesis, ceramic"
// * urn:oid:2.16.840.1.113883.6.276#64992 "ADAMTS13 activity IVD, kit, chemiluminescent immunoassay"
* include codes from system SNOMED_CT where concept is-a #49062001


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
// * version = "0.1.1"
* id = "hddt-cgm-summary-operation"
* name = "HddtCgmSummaryOperation"
* title = "Search Operation for summary data measurement"
* status = #draft
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2025-09-19"
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
