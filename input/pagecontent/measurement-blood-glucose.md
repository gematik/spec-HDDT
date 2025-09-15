**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

## Observation for a Single Measurement - MIV Blood Sugar

This [Observation](https://hl7.org/fhir/R4/observation.html) profile captures a single blood glucose measurement obtained from a glucometer. For this use case, only `valueQuantity` is permitted as the result of the Observation.

The `code` element must be selected from the [Blood Glucose ValueSet](ValueSet-vs-blood-glucose.html), reflecting both the measurement method and the units supported by the device. The unit defined in the LOINC code’s display must align with the `valueQuantity.unit` or `valueQuantity.code`.

Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-DeviceMetric-Personal-Health-Device.html) resource via the `device` element is required. This ensures that the calibration status of the sensor is properly captured.

The table below identifies elements that are further constrained by this profile, or that carry particular semantic importance for this use case of measuring blood glucose.


**FHIR resource type**: Observation

| Description | FHIR Attribute | FHIR Data Type | Cardinality | Note |
|------------|----------------|----------------|------------|------|
| Status of the Observation | `status` | code | 1..1 | Should be "final". |
| The result of the Observation | `valueuQuantity` | Quantity | 0..1 | May be missing, but in such cases, a `dataAbsentReason` must be specified. |
| Unit of individual measurement | `valueQuantity.unit` | string | 1..1 | Text representation fo the unit, e.g., "mg/dL" |
| Code system of the measurement unit | `valueQuantity.system` | uri | 1..1 | UCUM: http://unitsofmeasure.org |
| Code of the measurement unit from the specified code system | `valueQuantity.code` | code | 1..1 | Code from UCUM, e.g., "mg/dL".Should match the unit specified in the LOINC code in `Observation.code`. |
| Coding of this measurement (type of measurement) | `code` | CodeableConcept | 1..1 | e.g., "2339-0" (blood glucose) from ValueSet [VS_HiMi_BloodGlucose](ValueSet-vs-blood-glucose.html) |
| Reason for missing data | `dataAbsentReason` | CodeableConcept | 0..1 | A reason must be given if `valueQuantity` is not set. | 
| Reference to the device configuration (DeviceMetric) | `device` | Reference | 0..1 | Reference to [DeviceMetric](StructureDefinition-DeviceMetric-Personal-Health-Device.html) to keep track of the sensor's calibration status.  |
| Measurement time or period | `effective[x]` | dateTime / Period | 1..1 |  |
| Measurement method | `method` | CodeableConcept | 0..1 | e.g. code for test strip, sensor. Element is flagged as **must support** |


---

### Profile

The full profile definition can be found at the following places:

- In this specification under Artifacts -> [StructureDefinition/Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html)
- **ToDo**: Verlinkung https://gematik.de/fhir/hdc/StructureDefinition/Observation-Blood-Glucose


### Search parameters

The following search parameters **MUST** be supported by the medical aid manufacturer. Examples can be found in the [FHIR API specification](himi-diga-api.html).

| Search parameter | Description |
| --- | -- | 
|`code` | Request Observations of a particular type, e.g. list all Observations that measure blood glucose in mg/dL  from a blood sample | 
|`date` | Request Observations for a particular time range, e.g in the last 14 days. |
| `_include` | An addition to the search query, allowing to also request the full DeviceMetric resource, referenced in `device`. |
