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
* code from https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-glucose-measurement (required)
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


