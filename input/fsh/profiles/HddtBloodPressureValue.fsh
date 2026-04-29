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

Each Blood Pressure Measurement MUST either hold a reference to a _Sensor Type And Calibration Status_ [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or to a 
_Personal Health Device_ [Device](https://hl7.org/fhir/R4/device.html) resource (eXclusive OR). Typically the reference will be 
to a [Device](https://hl7.org/fhir/R4/device.html) resource, but the option to reference a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) 
resource is provided for compatibility with the overarching HDDT specification.

This profile inherits from the FHIR Blood Pressure profile (`http://hl7.org/fhir/StructureDefinition/bp`) and adds HDDT-specific constraints. The blood pressure components 
(systolic and diastolic are mandatory; mean is optional) are inherited from the parent profile with the MeanBP component added as an optional slice.
Each component MUST include a value in mmHg (millimeters of mercury).

Caution: For privacy and data protection, the subject reference MUST only use pseudonymized or anonymized identifiers. Direct patient identification is not permitted.

**Constraints applied:**  
- `code.coding[BPCode]` is constrained to ValueSet HddtMivBloodPressureValue containing LOINC panel code 85354-9
- `component` cardinality is set to 2..3 to require systolic and diastolic components (inherited from parent), with mean blood pressure as optional
- `component[MeanBP]` is added as an optional slice (0..1) for mean blood pressure with LOINC code 8478-0
- Each component's `valueQuantity` MUST use UCUM code mm[Hg] for the unit
- `device` is set to be mandatory in order to provide the DiGA with information about the sensor's calibration status and with information about the static and dynamic attributes of the Personal Health Device."""
* ^status = #active
* ^date = "2026-04-29"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* subject ^short = "Patient reference in anonymized or pseudonymized form only"
* subject ^definition = "Reference to the patient. The patient MUST NOT be identified directly. Only anonymized or pseudonymized forms are permitted."
* code 1..1
// * code.coding[BPCode] from HddtMivBloodPressureValue (required)
* code.coding[loinc] from https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-pressure-value (required)
* code.coding[snomed] 0..0
* code ^short = "Type of blood pressure measurement"
* code ^binding.description = "Specifies the type of blood pressure measurement using codes from the ValueSet for blood pressure measurements."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to the blood pressure measurement device"
* device MS
* component[SystolicBP].value[x] MS
* component[SystolicBP].valueQuantity MS
* component[DiastolicBP].value[x] MS
* component[DiastolicBP].valueQuantity MS