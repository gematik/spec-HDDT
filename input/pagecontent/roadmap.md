### Specification Roadmap
The standardisation of data to be transmitted from medical aids and implants will be carried out using an incremental approach by domains representing an area of use or a care environment. In an initial specification version 1 (MVP), a first set of data that MUST be made available — referencing the selected domains — will be defined, specified, and published. The selection of domains and use cases, from which the data to be provided and the affected devices are derived, is guided by various criteria, such as the frequency of prescriptions and the added value for patient care through DiGAs (see [Methodology](methodology.md)). 

Mandatory Interoperable Values (MIVs) will be declared for each domain to be provided by medical aids and implants processing this data. Systems that comply to [certification relevant systems](certification-relevant-systems.md) and process data which is part of the [Mandatory Interoperable Values (MIVs)](mivs.md) MUST therefore implement according to the MVP.

The first specification version 1 (MVP) will specify selected [Mandatory Interoperable Values (MIVs)](mivs.md) from the domains 
* Diabetes Self-Management
* Respiratory Monitoring
* Simple Cardiac Monitoring

__Note:__ The current version of this specification (ballot) addresses only the domain of Diabetes Self-Management to demonstrate the envisioned workflows and requirements. After a validation phase, the specification version 1 containing all above mentioned domains will be presumably published until 31.03.2026.

Underlying statutory deadlines can be found in [§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html).

<!--
#### Component Overview
For the implementation of the interface, it is necessary to initially pair the backends of medical aids and implants with DiGA (digital health applications) via frontends in order to obtain the consent of a patient for the retrieval of its personal health data based on a pseudonym, identify suitable and authorized pairing partners, and ensure their authenticity. On the other hand, a syntactically and semantically interoperable interface must be designed for the continuous data transfer from personal health devices to DiGAs.

In addition to gematik, the Bundesinstitut für Arzneimittel und Medizinprodukte (BfArM) is legally tasked with establishing and publishing a device registry for interoperable interfaces of aids and implants, which will provide the necessary technical information on medical aids and implants for the technical workflow.

#### Technical and conceptual foundations
The specification enables a DiGA to retrieve standardised health data from medical aids or implants for the same patient, following the patient's explicit consent in the form of an authorisation – without the need to establish bilateral contractual relationships between manufacturers. The system is based on a four-pillar architectural approach:

##### Data Model
FHIR-based transmission of health data as Mandatory Interoperable Values (MIVs) to be provided in the form of FHIR Observation resources for vital signs e(e.g. glucose level in capillary blood). 

##### Components
Five main systems orchestrate the legally compliant exchange of data: the BfArM DiGA and device registry, the Central Terminology Server (ZTS), and the backend/frontend systems of DiGAs and medical aids/implants.

##### Interfaces
OAuth 2.0 is used for secure authorisation combined with RESTful FHIR APIs for interoperable data transmission.

##### Processes
Divided into three main processes:
* Pairing of systems with user consent,
* Continuous data transfer,
* Regular verification of permissions for data transfer
-->

### Test and Registration Process
In order to certify the conformity of the implementation with the specification, it is foreseen to provide an assessment procedure which will enable the manufacturers to easily prove the conformity of their implementation using a locally executable testsuite. The assessment procedure leads - if passed successfully - to a _gematik_ certification of the medical aid's implementation. 

Manufacturers of medical aids and implants MUST notify the _BfArM_ about the implementation of the interface, which will result in the listing of the medical aid or implant in a new device registry to be established by the _BfArM_ (_HIIS-VZ_). Requirements for the registration in the _HIIS-VZ_ will be announced by the _BfArM_.

DiGA manufacturers report to the _BfArM_ the data required for their use cases for intended use and, upon confirmation, receive authorisation to retrieve data from medical aids and implants that, according to the _HIIS-VZ_ (BfARM Device Registry), make these data available. If the interface is implemented for a DiGA that is already listed in the _DiGA directory_, a change notification with a substantiated request for data use has to be submitted to the _BfArM_.

### Reference Implementation
As a support measure for manufacturers, gematik plans to provide a reference implementation that precisely realises the technical specification. The reference implementation is intended to be used for demonstration and testing purposes as well as a benchmark for assessing conformity. 