
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


Whenever a HDDT building block or HDDT class is introduced for the first time or defined the name of the building block or class is emphasized in bold letters (example: __Device Data Recorder__). 

### Regulatory vs. Technical Wording

Baseline for the HDDT requirements is § 374a SGB V together with related regulations (e.g. § 139e SGB V for the _DiGA VZ_). However, the wording in the legal texts is not always suitable for technical specifications, escecially in cases where things are described in a very abstract way in the law. The most prominent example is the term "medical aids and implants" (_Hilfsmittel und Implantate_) which is used in the law from the viewpoint of reimbursement eligibility. For the technical specification this term is rather confusing because it does not differentiate between the sensor device and the backend services. Therefore, in this specification the term "medical aids and implants" is only used when referring to the legal text and its derived requirements for the HDDT specification. In all other cases, more precise technical terms are used, e.g. "Personal Health Device" and "Device Data Recorder" (see section [Building Blocks](certification-relevant-systems.html#building-blocks) for an overview of the most relevant technical terms).

### German Proper Nouns

The following German proper nouns are not translated in this specification:

* Digitale Gesundheitsanwendung (_DiGA: Digital Health Application acc. § 33a SGB V_)
* Bundesinstitut für Arzneimittel und Medizinprodukte (_BfArM: The Federal Institute for Drugs and Medical Devices_)
* Gesellschaft für Telematikanwendungen der Gesundheitskarte mbH (_gematik: National Digital Health Agency_)
* Bundesministerium für Gesundheit (_BMG: Federal Ministry of Health_)
* Verzeichnis der Hilfsmittel- und Implantat-Schnittstellen (_HIIS-VZ: BfArM Registry of devices and implants_) 
* DiGA-Verzeichnis (_DiGA VZ: BfArM DiGA Registry_)
* Zentraler Terminologieserver (_ZTS: German Central Terminology Server_)

