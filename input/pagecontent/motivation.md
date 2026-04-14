The Health Device Data Transfer (HDDT) interface in backend systems of medical aids and implants is intended to form part of the progressive integration of DiGAs with other digital applications and services, as well as analogue services, into overarching hybrid and/or fully digital care processes. This could, for example, enable the design of digital Disease Management Programs (dDMP) in which DiGA, medical aids or implants, and health care providers’ analogue services work together to improve diabetes care.

This interplay is currently not possible in this form, as DiGAs are not enabled to access data from medical aids or implants in a standardised way and are largely used in isolation. Patient-generated health data often has to be entered manually into the application by the patient or is transferred on paper to healthcare professionals, which increases efforts and susceptibility to errors. As a general result, this limits the widespread adoption of innovative data-driven therapeutic or healthcare monitoring approaches. 

### Health Device Data Transfer (HDDT)
The _Kompetenzzentrum für Interoperabilität im Gesundheitswesen (KIG: Competence Centre for Interoperability in Healthcare)_ at _gematik_ has the statutory mandate to make technical specifications for the implementation of open and standardised interfaces in medical aids and implants eligible for reimbursement by the _Gesetzliche Krankenversicherungen (GKV, statutory health insurance)_ pursuant to § 374a SGB V.

This interface is part of an ecosystem of regulated responsibilities, interoperable services and standardized processes (e.g. for registering affected medical aids and implants).

The present specification "Health Device Data Transfer" (HDDT) describes this ecosystem and its functional and technical workflows as well as the requirements that must be implemented by the systems concerned (see [Certification relevant systems](certification-relevant-systems.html)). It is supplemented by 
- specifications for the interfaces of the BfArM registries for DiGA, medical aids and implants (see [BfArM Registries](registries-and-zts.html) for further information) 
- FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) for defining the semantics of the data to be transferred (see [MIVs](mivs.html)) which will be made available through the [ZTS](registries-and-zts.html#zentraler-terminologieserver) (German Central Terminology Server)
- processes for the registration of the interfaces and trust anchors of medical aids and implants as well as DiGAs with the BfArM (see [BfArM Website](https://www.bfarm.de/DE/Medizinprodukte/Aufgaben/DiGA-und-DiPA/DiGA/HIIS/_node.html)).

For further information about responsibilities for these artefacts and processes as well as statutory periods, see [§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html).

### Expected Benefits and Impacts on Healthcare
The HDDT specification aims to achieve the following overall benefits on the health care sector:
* to enable DiGAs to innovate care offerings by tapping into new data sources and facilitating the simpler, standardized integration of medical aids and implants
* to lay a foundation for the creation of new structured care programs such as digital disease management programs (dDMPs)
* to enable patients to get effective digital care services that are tailored as closely as possible to their current state of health by automatically and privacy‑compliantly transferring data from medical aids and implants into DiGAs
* to empower healthcare professionals, via new DiGA solutions, e.g. to assess therapy outcomes by objective patient measurements and intervene at an earlier stage when necessary