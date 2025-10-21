In order to [authenticate with each other](security-and-privacy.html) and to share device data after successful [authorization](pairing.html) for the processing of defined [Mandatory Interoperable Values](methodology.html#from-use-cases-to-mivs) (MIVs), a DiGA and a Device Data Recorder 
- need to discover relevant information about each other, including the MIVs the other party is eligible to process
- must obtain information about the other party's X.509 certificates from a trusted third party
- must be able to expand MIV-defining FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) and other ValueSets used by the HDDT-specific resource definitions

These services are usable through the BfArM DiGA Registry and BfArM Device Registry (_DIGA Verzeichnis_ and _Verzeichnis der Hilfsmittel- und Implantat-Schnittstellen (HIIS-VZ)_) and the German Central Terminology Service (_Zentraler Terminologieserver_, ZTS). The following class diagram shows the section of the [HDDT information model](information-model.html) that displays the BfArM registries and the ZTS along with their mutual cross-references. 

<div style="width: 75%;">
  <img src="assets/images/HDDT_Informationsmodell_Generisch_BfArM.svg" style="width: 100%;" />
</div>

For further information about the displayed classes and attributes and their mappings to FHIR resource definitions see the detailed explanation at the [HDDT information model](information-model.html#BfArM-registries).

### HIIS-VZ
The _HIIS-VZ_ (BfArM Device Registry) is operated by BfArM and provides access to definitions of registered Personal Health Devices and Device Data Recorders. For HDDT the _HIIS-VZ_ provides the following functions:
- providing information about Personal Health Devices (medical aids and implants) that are registered as HDDT [certification relevant systems](certification-relevant-systems.html), e.g. 
   - device information (name, version, etc.)
   - manufacturer and contact data 
   - static properties (e.g. amount of measured data that can temporarely be stored on the device)
- providing information about Device Data Recorders that successfully implemented § 374a SGB V HDDT interfaces
   - product information (name, version, etc.)
   - manufacturer and contact data
   - supported Personal Health Devices
   - endpoint addresses of the provided FHIR Resource Server and OAuth2 Authorization Server
   - information for verifying the authenticity of the Device Data Recorder in electronic communications
   - versioning of information about registered Device Data Recorders 
- searching and/or browsing for MIVs that are supported by certain Personal Health Devices and Device Data Recorders
- searching and/or browsing for Personal Health Devices and Device Data Recorders that support a certain MIV
-providing feeds for monitoring changes in the _HIIS-VZ_ (e.g. new device registrations, changes in supported MIVs, changes in certificate status, etc.)

The _HIIS-VZ_ and the processes for registering Personal Health Devices and Device Data Recorders are recently being build up by BfArM. A first draft of the APIs that provide the above listed functions will be published by end of October 2025. 

### DiGA Verzeichnis
The BfArM DiGA Registry (_DiGA Verzeichnis_) is operated by BfArM and provides access to definitions of registered DiGA (Digital Health Applications acc. § 33a SGB V). For HDDT the _DiGA Verzeichnis_ provides the following functions:
- providing information about registered DiGA
   - product information (name, version, etc.)
   - manufacturer and contact data
   - information for verifying the authenticity of the DiGA in electronic communications
- listing the MIVs a defined DiGA is eligible to process
- listing all DiGA that are eligible to process a defined MIV
- providing feeds for monitoring changes in the _DiGA Verzeichnis_ (e.g. new DiGA registrations, changes in eligible MIVs, changes in certificate status, etc.)

The _DiGA Verzeichnis_ can be reached at the URL [https://diga.bfarm.de/de/verzeichnis](https://diga.bfarm.de/de/verzeichnis), an API is avalable at [https://diga.api.bund.dev/](https://diga.api.bund.dev/). 

The _DiGA Verzeichnis_ is currently being expanded to include the data, registration processes, and interfaces needed for the implementation of § 374a SGB V.

A first draft of the APIs that provide the above listed functions will be published by end of October 2025. 

### Zentraler Terminologieserver

The **Zentraler Terminologieserver** (_Central Terminology Server_, ZTS) operated by _BfArM_ provides access to medical terminologies and classification systems in FHIR package format.
These packages include CodeSystems, ValueSets, and ConceptMaps and serve as the foundation for semantic interoperability in the German healthcare ecosystem.

In the ZTS, all terminology artifacts relevant to a specific domain or application (e.g., active ingredients of drugs or dosages, classification of diseases and - in the future - HDDT MIV definitions) are bundled and provided as FHIR packages.
This ensures that implementers always receive a complete set of logically related ValueSets, CodeSystems, and ConceptMaps in one package – simplifying integration and guaranteeing consistency.

The _ZTS_ can be reached at the URL [https://terminologien.bfarm.de](https://terminologien.bfarm.de). This site allows to navigate through the provided FHIR CodeSystems and ValueSets and to manually download these as FHIR packages.

For HDDT the ZTS will provide the following functions: 
- Provision of binding MIV definitions as FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html)
- Versioning of MIV definitions and signaling changes to MIV definitions
- Provisioning of FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) for device types
- Provisioning of [German translations of LOINC codes](https://terminologien.bfarm.de/fhir/CodeSystem/loinc-linguistic-variant-de-de) 
- Provisioning of [German translations of UCUM codes](https://terminologien.bfarm.de/fhir/CodeSystem/ucum-common-units-translation-de-de)

In addition to the GUI the ZTS provides several APIs which are designed for automation and integration into IT systems:
- Packages API: Search and retrieve FHIR Packages ([openAPi](https://terminologien.bfarm.de/api-docs/packages.json))
- Feeds API: Stay informed about new or updated releases ([openAPI](https://terminologien.bfarm.de/api-docs/feeds.json))
- Redirector API: Resolve canonical URLs to the correct version of a resource [openAPI](https://terminologien.bfarm.de/api-docs/redirect.json)
- Token API: Access protected packages via token-based authentication

A short description of these APIs is provided below. More detailed descriptions are available as part of the [ZTS documentation](https://terminologien.bfarm.de/fhirpackages.html) (German only).

__Remark__: The FHIR ValueSets for MIV definitions will be made available on ZTS after the end of the public review of the HDDT specification. Until then, all FHIR ValueSets for MIV definitions can be found in the [ValueSets section of the Artifact Summary](artifacts.html#terminology-value-sets).

