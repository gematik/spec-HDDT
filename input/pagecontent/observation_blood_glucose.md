## Observation_vibW_Measurement

**FHIR resource type**: Observation

| Description | FHIR Attribute | FHIR Data Type | Cardinality | Note |
|------------|----------------|----------------|------------|------|
| Unit of individual measurement | valueQuantity.unit | string | 1..1 | Unit, e.g., "mg/dL" |
| Code system of the measurement unit | valueQuantity.system | uri | 1..1 | UCUM: http://unitsofmeasure.org |
| Code of the measurement unit from the specified code system | valueQuantity.code | code | 1..1 | e.g., "mg/dL" |
| Coding of this measurement (type of measurement) | code | CodeableConcept | 1..1 | e.g., "2339-0" (blood glucose) from ValueSet VS_HiMi_BloodGlucose |
| Reference to the affected patient | subject | Reference | 0..1 |  |
| Reference to the device configuration (DeviceMetric) | device | Reference | 0..1 |  |
| Timestamp recorded in the system | issued | instant | 0..1 | e.g., 2025-07-08T13:37:53.267843700Z |
| Measurement time or period | effective[x] | dateTime / Period | 1..1 |  |
| Reference range: lower limit | referenceRange.low | Quantity | 0..1 |  |
| Reference range: upper limit | referenceRange.high | Quantity | 0..1 |  |
| Measurement method | method | CodeableConcept | 0..1 | e.g., test strip, sensor |
| Note or annotation | note | Annotation | 0..1* |  |

---