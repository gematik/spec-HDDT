
### Use of Keywords
Requirements, as an expression of normative specifications, are indicated by the keywords "MUST", "SHOULD", "MAY", "SHOULD NOT", "MUST NOT", "REQUIRED", "RECOMMENDED" and "OPTIONAL" as defined in [RFC 2119](https://tools.ietf.org/html/rfc2119 "RFC 2119"). "SHALL" is used synonymous to "MUST". 

### Formatting Conventions

| Subject                     | Emphasis       | Example                  |
|-----------------------------|----------------|--------------------------|
| FHIR ResourceDefinition     | Hyperlink      | [Observation](https://hl7.org/fhir/R4/observation.html) |
| FHIR resource element       | Code           | `valueSampledData`       |
| HDDT building block (class) | Uppercase      | Device Data Recorder     |
| HDDT class attribute        | Code           | `calibrationStatus`      |
| HDDT object properties      | Code           | `Store-Capacity-Count`   |
| Example value (element, attribute) | Italics | _calibrated_             |
| Proper Nouns                | Italics        | _BfArM_                  |


Whenever a HDDT building block or HDDT class is introduced and defined for the first time, the name of the building block or class is emphasized in bold letters (example: __Device Data Recorder__). 

### Regulatory vs. Technical Wording

The HDDT requirements are based on § 374a SGB V and related regulations (e.g., § 139e SGB V for the _DiGA VZ_). However, the wording used in legal texts is not always suitable for technical specifications, particularly when concepts are described abstractly. A prominent example is the term "medical aids and implants" (_Hilfsmittel und Implantate_), which the law uses from a reimbursement eligibility perspective. For a technical specification, this term must be differentiated to distinguish between sensor devices and backend systems. 

Therefore, this specification uses "medical aids and implants" only when directly referencing legal texts and their derived requirements. In all other contexts, more precise technical terms are used, such as "Personal Health Device" and "Device Data Recorder" (see section [Building Blocks](certification-relevant-systems.html#building-blocks) for an overview of key technical terms).

### German Proper Nouns

The following German proper nouns are not translated in this specification:

* Digitale Gesundheitsanwendung (_DiGA: Digital Health Application acc. § 33a SGB V_)
* Bundesinstitut für Arzneimittel und Medizinprodukte (_BfArM: The Federal Institute for Drugs and Medical Devices_)
* Gesellschaft für Telematikanwendungen der Gesundheitskarte mbH (_gematik: National Digital Health Agency_)
* Bundesministerium für Gesundheit (_BMG: Federal Ministry of Health_)
* Verzeichnis der Hilfsmittel- und Implantat-Schnittstellen (_HIIS-VZ: BfArM Registry of devices and implants_) 
* DiGA-Verzeichnis (_DiGA VZ: BfArM DiGA Registry_)
* Zentraler Terminologieserver (_ZTS: German Central Terminology Server_)

