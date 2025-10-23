### Specification Roadmap
The standardisation of data to be transmitted from medical aids and implants will be carried out using an incremental approach by domains representing an area of use or a care environment. In an initial specification version 1 (MVP), a first set of data that MUST be made available — referencing the selected domains — will be defined, specified, and published. The selection of domains and use cases, from which the data to be provided and the affected devices are derived, is guided by various criteria, such as the frequency of prescriptions and the added value for patient care through DiGAs (see [Methodology](methodology.html)). 

Mandatory Interoperable Values (MIVs) will be declared for each domain to be provided by medical aids and implants processing this data. Systems that comply to [certification relevant systems](certification-relevant-systems.html) and process data which is part of the [Mandatory Interoperable Values (MIVs)](mivs.html) MUST therefore implement according to the MVP.

The first specification version 1 (MVP) will specify selected [Mandatory Interoperable Values (MIVs)](mivs.html) from the domains 
* Diabetes Self-Management
* Respiratory Monitoring
* Simple Cardiac Monitoring

__Note:__ The current version of this specification (ballot) addresses only the domain of Diabetes Self-Management to demonstrate the envisioned workflows and requirements. After a validation phase, the specification version 1 containing all above mentioned domains will be presumably published until 31.03.2026.

Underlying statutory deadlines can be found in [§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html).

### Conformity assessment and registration Process
In order to certify the conformity of the implementation with the specification, it is foreseen to provide an assessment procedure which will enable the manufacturers to easily prove the conformity of their implementation using a locally executable testsuite. The assessment procedure leads - if passed successfully - to a _gematik_ certification of the medical aid's implementation. 

Manufacturers of medical aids and implants MUST notify the _BfArM_ about the implementation of the interface, which will result in the listing of the medical aid or implant in the new _Verzeichnis der Hilfsmittel- und Implantat-Schnittstellen_ (_HIIS-VZ_) to be established by the _BfArM_. Requirements for the registration in the _HIIS-VZ_ will be announced by the _BfArM_.

DiGA manufacturers report to the _BfArM_ the data required for their use cases for intended use and, upon confirmation, receive authorisation to retrieve data from medical aids and implants that, according to the _HIIS-VZ_ (BfARM Device Registry), make these data available. If the interface is implemented for a DiGA that is already listed in the _DiGA directory_, a change notification with a substantiated request for data use has to be submitted to the _BfArM_.

### Reference Implementation
As a support measure for manufacturers, gematik plans to provide a reference implementation that precisely realises the technical specification. The reference implementation is intended to be used for demonstration and testing purposes as well as a benchmark for assessing conformity. 