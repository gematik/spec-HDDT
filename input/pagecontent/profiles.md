# Profiles

## Observation-Blood Glucose
- **Description:** Profile for documenting blood glucose measurements using the FHIR Observation resource.
- **Binding:** `Observation.code` → `VS_Blood_Glucose`
- **Binding:** `Observation.valueQuantity.unit` → `VS_Blood_Glucose_Units`

## Observation-Tissue Glucose CGM
- **Description:** Profile for recording continuous tissue glucose measurements from CGM (Continuous Glucose Monitoring) devices using the FHIR Observation resource.
- **Binding:** `Observation.code` → `VS_Tissue_Glucose_CGM`
- **Binding:** `Observation.valueSampledData.unit` → `VS_Blood_Glucose_Units`

## DeviceMetric-HiMi
- **Description:** Profile for representing device metrics related to blood glucose measurement, such as measurement type and configuration.
- **Binding:** `DeviceMetric.type` → `VS_Blood_Glucose`

## Device-HiMi
- **Description:** Profile for describing the physical device used for blood glucose measurement, including device identification and relevant attributes.

