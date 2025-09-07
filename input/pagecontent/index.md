
# Status: Draft
* Verantwortlich: Andrea und Jörg
* ToDo:
    * Ziele mit Blick auf die Validierung ausformulieren
    * Darlegen, was für alle HiMi gilt (Pairing, etc.) und was exemplarisch für die Diabetes-UseCases ist

# Health Device Data Transfer (HDDT) 
This specification describes the technical and semantic approach for giving registrered DIGA access to data from medical aids and implants, according to § 374a SGB V.

This specification is aimed for a validation with affected health device manufacturers and DiGA manufacturers. For this validation gematik and MoH agreed on __Diabetes Self-Monitoring__ as the first domain for which relevant use cases, medcial aids and interoperable values have been assessed (see section (Methodology)[methodology.md]). 

## Goals
- Standardized profiles and value sets for interoperability between medical aids (HiMi) and digital health applications (DiGA).
- Mandatory codes (LOINC, UCUM) for measurement values and units.
- Complete traceability between measurement value, device configuration, and device.

## MIVs for the Domain "Diabetes Self-Management"
Blood glucose values are provided via the FHIR resource **Observation**.  
This contains references to **DeviceMetric** (device configuration) and **Device** (device instance).  
Additionally, **ValueSets** are defined to specify:
- Which measurement values (LOINC) are valid.
- Which units (UCUM) are permitted.

## Use of Keywords
Requirements, as an expression of normative specifications, are indicated by the keywords "MUST", "SHOULD", "MAY", "SHOULD NOT", "MUST NOT", "REQUIRED", "RECOMMENDED" and "OPTIONAL" as defined in [RFC 2119](https://tools.ietf.org/html/rfc2119 "RFC 2119"). "SHALL" is used synonymous to "MUST". 

