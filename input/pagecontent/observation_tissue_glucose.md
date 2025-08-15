## Observation_vibW_Series

**FHIR resource type**: Observation

| Description | FHIR Attribute | FHIR Data Type | Cardinality | Note |
|------------|----------------|----------------|------------|------|
| Values of the measurement series | valueSampledData.data | string | 1..1 |  |
| Unit of the measurement series | valueSampledData.origin.unit | string | 1..1 |  |
| Code system of the unit | valueSampledData.origin.system | uri | 1..1 |  |
| Code of the unit from the specified code system | valueSampledData.origin.code | code | 1..1 |  |
| Coding of this measurement (type of measurement) | code | CodeableConcept | 1..1 | e.g., "2339-0" (blood glucose) from ValueSet VS_HiMi_BloodGlucose |
| Reference to the affected patient | subject | Reference | 1..1 |  |
| Reference to the device configuration (DeviceMetric) | device | Reference | 0..1 |  |
| Reference to the person who performed the measurement | performer | Reference | 0..1 | Optional: who measured |
| Timestamp recorded in the system | issued | instant | 0..1 | e.g., 2025-07-08T13:37:53.267843700Z |
| Measurement time or period | effective[x] | dateTime / Period | 1..1 |  |
| Reference range: lower limit | referenceRange.low | Quantity | 0..1 |  |
| Reference range: upper limit | referenceRange.high | Quantity | 0..1 |  |
| Measurement method | method | CodeableConcept | 0..1 | e.g., test strip, sensor |
| Note or annotation | note | Annotation | 0..1* |  |

---