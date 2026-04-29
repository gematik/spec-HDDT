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
- `code` is constrained to a subset of the _MIV Lung Function Reference Values_ ValueSet, defined by the _HddtLungFunctionReferenceValues_ ValueSet.
- `effective[x]` is restricted to `effectivePeriod` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `method` is considered mandatory in order to provide information about the method used to determine the reference value. It can be either a code from the _HddtLungFunctionReferenceValueMethod_ ValueSet or a text description.
"""

* ^status = #active
* ^date = "2026-04-29"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* code from https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-reference-values (required)
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
