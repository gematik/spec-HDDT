**ToDo: @Andrea: Umsetzungsplan** 

The standardisation of data to be transmitted from medical aids and implants will be carried out step by step based on selected use cases. In an initial expansion stage 1, a first set of data that must be made available — referencing the selected use cases — will be defined, specified, and published. The selection of use cases, from which the data to be provided and the affected devices are derived, is guided by various criteria, such as the availability of digital measurement data, the frequency of prescriptions, and the need and added value for patient care through DiGAs. 

The first expansion stage will include the domains 
* Self-management of diabetes
* Respiratory monitoring
* Blood pressure management

*Systems that comply to certification relevant systems and process data included in the vibW are called for implementation according to version 1.*

The first version of this specification (draft) addresses the domain of diabetes self-management to demonstrate the envisioned workflows and requirements. *After a validation phase of ...., the first version will be released until 31.03.2026.*

### Release Management

The specification will be updated in stages, amended and issued as part of release management to steer implementation. Dates for the mandatory provision of data based on new versions of the specification will be set in time to allow manufacturers sufficient time to technically implement the requirements.

### Certification process
Manufacturers must notify the BfArM of the implementation of the interface, which will result in the listing of the medical aid or implamt in a new device registry (HiMi-SST-VZ) to be established by the BfArM. Requirements for the registration in the HiMi-SST-VZ will be announced by the BfArM and will include the attestation of the implementation's conformity with the specification.

### Reference implementation
As a support measure for manufacturers, gematik will provide a reference implementation that precisely realises the technical specificaton. The reference implementation is intended to be used for demonstration and testing purposes as well as a benchmark for assessing conformity. 

### Rollout actions
#### Medical aid and implant manufacturers
After development and successful testing of the implemented interface by the medical aid and implant manufacturers, a certification process must be completed to demonstrate conformity with the specification. In addition, manufacturers should assess on a case-by-case basis whether re-certification of the product is required under the MDR (EU Medical Device Regulation).

#### DiGA manufacturers
As part of their own application process for DiGA registry, DiGA manufacturers report to BfArM the data required for their use cases for intended use and, upon confirmation, receive authorisation to retrieve data from medical aids and implants that, according to the HiMi-SST-VZ, make these data available. *A one-off initiation of the connection between the DiGA and the HiMi manufacturer may be necessary*. *If the interface is implemented for a DiGA that is already listed in the DiGA directory, a change notification with a substantiated request for data use must be submitted to BfArM.*