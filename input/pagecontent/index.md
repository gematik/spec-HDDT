
This implementation guide specifies the interface between medical aids and implants with DiGA for health data transfer according to § 374a SGB V.

### Content
The implementation guide includes requirements for: 
* Patient-initiated authorisation of the DiGA to retrieve health data from the utilised medical aid/implant (consent)
* Management of authorisation by the patient (modifying and revoking consent)
* Retrieval of information necessary for a DiGA to use the interfaces
* Retrieval of information necessary for a medical aid/implant to use the interfaces
* Confidential transmission of health data from the medical aid/implant to a DiGA based on a user's pseudonym
* Verifiability of the authenticity of DiGA and medical aid/implants
* Ensuring data interoperability between DiGA and medical aids/implants
* Evidence and traceability of the operational functionality of the interface

Out-of-Scope for this implementation guide are:
* Identification and authentication of the patient vis-à-vis a DiGA or a medical aid/implant (manufacturer-specific)
* Definition of a DiGA/medical aid API for front-ends (manufacturer-specific)
* Protection of health data storage or health data processing within a DiGA or a medical device (manufacturer-specific)

### About the current version
The current __Draft version__ aims for the validation of the technical concept and specificatory aspects with affected medical aid, implant and DiGA manufacturers as well as other stakeholders. The parts describing the pairing mechanism between DiGA and medical aid or implant for authentication, authorization and logging are general requirements across all product groups and domains. The interoperable values however will be defined per domain. For this Draft version, the domain of __Diabetes Self-Management__ was defined as a first domain to specify data interoperability (see section [Methodology](methodology.md)). For further information on the status and roadmap for the specification, see [Release notes](release-notes.md) and [Roadmap](Roadmap.md).

### Contact and feedback
Please submit questions and comments via our [request portal](https://service.gematik.de/servicedesk/customer/portal/16) until 30.11.2025.

If you do not have access to the request portal and would like to use it, please send us a message to hddt [at] gematik.de with the subject “Portal access”.

### Use of Keywords
Requirements, as an expression of normative specifications, are indicated by the keywords "MUST", "SHOULD", "MAY", "SHOULD NOT", "MUST NOT", "REQUIRED", "RECOMMENDED" and "OPTIONAL" as defined in [RFC 2119](https://tools.ietf.org/html/rfc2119 "RFC 2119"). "SHALL" is used synonymous to "MUST". 

### License Information
This implementation guide is published unter the __XXXXX__ license. 


<!--
## Technical goals
- Standardized profiles and value sets for interoperability between medical aids/implants and digital health applications (DiGA).
- Mandatory codes (LOINC, UCUM) for measurement values and units.
- Complete traceability between measurement value, device configuration, and device.

## MIVs for the Domain "Diabetes Self-Management"
Blood glucose values are provided via the FHIR resource **Observation**.  
This contains references to **DeviceMetric** (device configuration) and **Device** (device instance).  
Additionally, **ValueSets** are defined to specify:
- Which measurement values (LOINC) are valid.
- Which units (UCUM) are permitted.-->





