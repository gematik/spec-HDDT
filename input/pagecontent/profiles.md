### Profiles

#### Observation-Blood Glucose
- **Description:** Profile for documenting blood glucose measurements using the FHIR Observation resource.
- **Binding:** `Observation.code` → `VS_Blood_Glucose`
- **Binding:** `Observation.valueQuantity.unit` → `VS_Blood_Glucose_Units`

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

#### Observation-Tissue Glucose CGM
- **Description:** Profile for recording continuous tissue glucose measurements from CGM (Continuous Glucose Monitoring) devices using the FHIR Observation resource.
- **Binding:** `Observation.code` → `VS_Tissue_Glucose_CGM`
- **Binding:** `Observation.valueSampledData.unit` → `VS_Blood_Glucose_Units`

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

#### DeviceMetric-HiMi
- **Description:** Profile for representing device metrics related to blood glucose measurement, such as measurement type and configuration.
- **Binding:** `DeviceMetric.type` → `VS_Blood_Glucose`

**Resource Type**: DeviceMetric
 FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|----------------|------------|------------|----------------|------|
| unit | Measurement unit | 1..1 | CodeableConcept | e.g., UCUM: mg/dL |
| calibration/state | Calibration status | 0..1 | code | e.g., "calibrated" |
| operationalStatus | Operational status | 0..1 | code | Optional |
| source | Device | 1..1 | Reference(Device) | Reference to the specific device instance |

#### Device-HiMi
- **Description:** Profile for describing the physical device used for blood glucose measurement, including device identification and relevant attributes.

**Resource Type**: Device
FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| serialNumber | Serial number | 1..1 | string | User verification (patient safety) |
| deviceName | Product name | 1..1 | string | e.g., "Accu-Chek Mobile" |
| manufacturer | Manufacturer | 0..1 | string | Sensor manufacturer |
| definition | Device definition | 1..1 | Reference(DeviceDefinition) | Link to device description |

---
