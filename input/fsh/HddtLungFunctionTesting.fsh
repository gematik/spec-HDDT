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
* code from https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-testing-values (required)
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
