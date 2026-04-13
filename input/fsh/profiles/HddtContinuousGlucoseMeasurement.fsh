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
* code from https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement (required)
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

