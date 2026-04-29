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
- `code` is constrained to a subset of the _MIV Lung Function Relative Values_ ValueSet, defined by the _HddtLungFunctionRelativeValues_ ValueSet.
- `effective[x]` is restricted to `effectiveDateTime` and constrained as mandatory.
- `value[x]` is restricted to `valueQuantity`. The elements `valueQuantity.value`, `valueQuantity.system`, and `valueQuantity.code` are constrained in a way that a value MUST be provided and that UCUM MUST be used for encoding the unit of measurement. `Observation.valueQuantity` MAY only be omitted in case of an error that accured with the measurement. In this case, `Observation.dataAbsentReason` MUST be provided.
- `derivedFrom` is constrained to require exactly two references: one to the raw lung function testing Observation and one to the lung function reference value Observation.
"""
* ^status = #active
* ^date = "2026-04-29"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* code from https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-relative-values (required)
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
