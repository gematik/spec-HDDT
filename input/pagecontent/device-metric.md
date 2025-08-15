## DeviceMetric

**Resource Type**: DeviceMetric
 FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|----------------|------------|------------|----------------|------|
| unit | Measurement unit | 1..1 | CodeableConcept | e.g., UCUM: mg/dL |
| calibration/state | Calibration status | 0..1 | code | e.g., "calibrated" |
| operationalStatus | Operational status | 0..1 | code | Optional |
| source | Device | 1..1 | Reference(Device) | Reference to the specific device instance |