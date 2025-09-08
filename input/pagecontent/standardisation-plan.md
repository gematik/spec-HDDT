# Status: Draft
* Verantwortlich: @Andrea
* ToDo:
    * Titel ändern? (vielleicht besser "Roadmap and Milestones" oder so), Anm Andrea: ggf. "Status and roadmap"?
    * ergänzen: Was ist spezifiziert (Pairing, Datenaustausch)? Was ist dem HiMi-Hersteller überlassen (AuthN, Consent, generelle Einstellungen)? Was ist dem DiGA-Hersteller überlassen (AuthN, Abfragemodus)? ==> ggf. auch in einem anderen Kapitel unterbringen
    * Component Overview und Foundations kommen eigentlich erst in späteren Abschnitten. Das sollte daher hier eingekürzt werden. @jcaumann gerne kürzen, wenn Inhalte woanders zu finden sind oder Link einfügen
    * Abschnitt hinzufügen, was zunächst out-of-scope ist (z.B. Bereitstellung Konfiguration (@jcaumann))
    * sofern bekannt: Fristen ergänzen Anm @AndreaSchminck: wird ergänzt (alles was kursiv ist ist noch in Arbeit)

# Initial Expansion Stage
The standardisation of data to be transmitted from medical aids and implants will be carried out step by step based on selected use cases. In an initial expansion stage 1, a first set of data that must be made available — referencing the selected use cases — will be defined, specified, and published. The selection of use cases, from which the data to be provided and the affected devices are derived, is guided by various criteria, such as the availability of digital measurement data, the frequency of prescriptions, and the need and added value for patient care through DiGAs. 

The first expansion stage will include the domains 
* Self-management of diabetes
* Respiratory monitoring
* Blood pressure management

Mandatory Interoperable Values (MIVs) will be declared for each domain to be provided by medical aids and implants processing this data. Systems that comply to [certification relevant systems](certification-relevant-systems.md) and process data which is part of the [Mandatory Interoperable Values (MIVs)](mivs.md) are therefore called for implementation according to release version 1 of this specification.

The current version of this specification (draft) addresses the domain of diabetes self-management to demonstrate the envisioned workflows and requirements. *After a validation phase of ...., the release version 1 containing all above mentioned domains will be published until 31.03.2026.*

### Component Overview
For the implementation of the interface, it is necessary to initially pair the backends of medical aids and implants with DiGA (digital health applications) via frontends in order to obtain the consent of a patient for the retrieval of its personal health data based on a pseudonym, identify suitable and authorized pairing partners, and ensure their authenticity. On the other hand, a syntactically and semantically interoperable interface must be designed for the continuous data transfer from personal health devices to DiGAs.

In addition to gematik, the Bundesinstitut für Arzneimittel und Medizinprodukte (BfArM) is legally tasked with establishing and publishing a device registry for interoperable interfaces of aids and implants, which will provide the necessary technical information on medical aids and implants for the technical workflow.

### Technical and conceptual foundations
The specification enables a DiGA to retrieve standardised health data from medical aids or implants for the same patient, following the patient's explicit consent in the form of an authorisation – without the need to establish bilateral contractual relationships between manufacturers. The system is based on a four-pillar architectural approach:

#### Data Model
FHIR-based transmission of health data as Mandatory Interoperable Values (MIVs) to be provided in the form of FHIR Observation resources for vital signs e(e.g. glucose level in capillary blood). 

#### Components
Five main systems orchestrate the legally compliant exchange of data: the BfArM DiGA and device registry, the National Terminology Server (ZTS), and the backend/frontend systems of DiGAs and medical aids/implants.

#### Interfaces
OAuth 2.0 is used for secure authorisation combined with RESTful FHIR APIs for interoperable data transmission.

#### Processes
Divided into three main processes:
* Pairing of systems with user consent,
* Continuous data transfer,
* Regular verification of permissions for data transfer

### Release Management

The specification will be updated in stages, amended and issued as part of release management to steer implementation. Dates for the mandatory provision of data based on new versions of the specification will be set in time to allow manufacturers sufficient time to technically implement the requirements.

### Certification process
Manufacturers must notify the BfArM of the implementation of the interface, which will result in the listing of the medical aid or implamt in a new device registry to be established by the BfArM (BfArM device registry). Requirements for the registration in the BfArM device registry will be announced by the BfArM and will include the attestation of the implementation's conformity with the specification.

### Reference implementation
As a support measure for manufacturers, gematik will provide a reference implementation that precisely realises the technical specificaton. The reference implementation is intended to be used for demonstration and testing purposes as well as a benchmark for assessing conformity. 

### Rollout actions
#### Medical aid and implant manufacturers
After development and successful testing of the implemented interface by the medical aid and implant manufacturers, a certification process must be completed to demonstrate conformity with the specification. In addition, manufacturers should assess on a case-by-case basis whether re-certification of the product is required under the MDR (EU Medical Device Regulation).

#### DiGA manufacturers
As part of their own application process for BfArM DiGA registry, DiGA manufacturers report to BfArM the data required for their use cases for intended use and, upon confirmation, receive authorisation to retrieve data from medical aids and implants that, according to the BfArM device registry, make these data available. *If the interface is implemented for a DiGA that is already listed in the DiGA directory, a change notification with a substantiated request for data use must be submitted to BfArM.*