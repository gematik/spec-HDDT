
### Status: Draft
* Verantwortlich: Andrea und Jörg
* ToDo:
    * Ziele mit Blick auf die Validierung ausformulieren
    * Darlegen, was für alle HiMi gilt (Pairing, etc.) und was exemplarisch für die Diabetes-UseCases ist
    @jcaumann: ich habe ergänzt, bitte technical goals und MIVS überprüfen. Auch bei den Keywords können wir schauen, ob wir überhaupt alle nutzen und ggf. die anderen streichen
    * Hinweis auf Lizenz notwendig?
     * ggf. Hinweis ergänzen, dass die Gewähr für irgendwas (Richtigkeit, Umsetzbarkeit, etc.) übernimmt

<hr>
This implementation guide specifies the interface between medical aids and implants with DiGA for health data transfer according to § 374a SGB V.

### About the current version
The current _Draft version_ is aimed for a validation of the technical concept and specificatory aspects with affected medical aid, implant and DiGA manufacturers as well as other stakeholders. The parts describing the pairing mechanism between DiGA and medical aid or implant for authentication, authorization and logging are general requirements across all product groups and domains. The interoperable values however will be defined per domain. For this Draft version, the domain of __Diabetes Self-Monitoring__ was defined as a first domain to specify data interoperability (see section (Methodology)[methodology.md]). For further information on the status and roadmap of specification, see [Release notes](release-notes.md) and [Roadmap](Roadmap.md).

### Technical goals
- Standardized profiles and value sets for interoperability between medical aids/implants and digital health applications (DiGA).
- Mandatory codes (LOINC, UCUM) for measurement values and units.
- Complete traceability between measurement value, device configuration, and device.

### MIVs for the Domain "Diabetes Self-Management"
Blood glucose values are provided via the FHIR resource **Observation**.  
This contains references to **DeviceMetric** (device configuration) and **Device** (device instance).  
Additionally, **ValueSets** are defined to specify:
- Which measurement values (LOINC) are valid.
- Which units (UCUM) are permitted.

### Use of Keywords
Requirements, as an expression of normative specifications, are indicated by the keywords "MUST", "SHOULD", "MAY", "SHOULD NOT", "MUST NOT", "REQUIRED", "RECOMMENDED" and "OPTIONAL" as defined in [RFC 2119](https://tools.ietf.org/html/rfc2119 "RFC 2119"). "SHALL" is used synonymous to "MUST". 

### Contact and feedback
Please submit general questions and comments via our request portal: *Requests ...*

If you do not have access to the request portal and would like to use it, please send us a message to *hddt [at] gematik.de* with the subject “Portal access”.

