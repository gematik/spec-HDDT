### Specification – Device 2 DiGA

This specification describes the technical and semantic approach for providing vital signs (vibW) using **blood glucose** and **tissue glucose** as an example, according to §374a SGB V.

#### Goals
- Standardized profiles and value sets for interoperability between medical aids (HiMi) and digital health applications (DiGA).
- Mandatory codes (LOINC, UCUM) for measurement values and units.
- Complete traceability between measurement value, device configuration, and device.

#### Architecture
Blood glucose values are provided via the FHIR resource **Observation**.  
This contains references to **DeviceMetric** (device configuration) and **Device** (device instance).  
Additionally, **ValueSets** are defined to specify:
- Which measurement values (LOINC) are valid.
- Which units (UCUM) are permitted.
