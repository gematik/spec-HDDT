The Health Device Data Transfer (HDDT) interface in backend systems of medical aids and implants is intended to form part of the progressive integration of DiGAs with other digital applications and services, as well as analogue services, into overarching hybrid and/or fully digital care processes. This could, for example, enable the design of digital Disease Management Programs (dDMP) in which DiGA, medical aids or implants, and health care providers’ analogue services work together to improve diabetes care.

This interplay is currently not possible in this form, as DiGAs are not enabled to access data from medical aids or implants in a standardised way and are largely used in isolation. Patient-generated health data often have to be entered manually into the application by the patient or is transferred paper-based towards the healthcare professionals which increases efforts and susceptibility to errors. As a general result, innovative data-driven therapeutic or healthcare monitoring approaches cannot widely be offered. 

### Health Device Data Transfer (HDDT)
The _Kompetenzzentrum für Interoperabilität im Gesundheitswesen (KIG: Competence Centre for Interoperability in Healthcare)_ at _gematik_ has the statutory mandate to make technical determinations for the implementation of open and standardised interfaces in medical aids and implants eligible for reimbursement by the _Gesetzliche Krankenversicherungen (GKV, statutory health insurance)_ pursuant to § 374a SGB V.

This interface is part of a broader ecosystem of regulated responsibilities, interoperable services and standardized process (e.g. for registering affected medical aids and implants). The figure below sketches the overall context of the HDDT interface (red).

<div><img src="/Zusammenhaenge.png" alt="HDDT Ecosystem (aus dem Konzept)" width="60%"></div>
<br clear="all"/>
___Anmerkung__. Grafik wird noch übersetzt_

The present specification "Health Device Data Transfer" (HDDT) describes the functional and technical workflows as well as the requirements that must be implemented by the systems concerned (see [Certification relevant systems](certification-relevant-systems.md))*. It is supplemented by 
- specifications for the interfaces of the BfArM registries for DiGA, medical aids and implants (see [BfArM Registries](registries-and-zts.md) for further information) 
- FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) for defining the semantics of the data to be transferred (see [MIVs](mivs.md)) which are available through the [ZTS](registries-and-zts.html#zentraler-terminologieserver) (Central Terminology Service)
- processes for the registration of the interfaces and trust anchors of medical aids and implants as well as DiGAs with the BfArM.

For further information about responsibilities for these artefacts and processes as well as statutory periods, see [§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html).

### Expected Benefits and Impacts on Healthcare
The HDDT specification aims to achieve the following overall benefits on the health care sector:
* to strengthen DiGA and lay the foundation for the creation of new structured care programs such as digital disease management programs (dDMPs)
* to enable DiGAs to innovate care offerings by tapping into new data sources and facilitating the simpler, standardized integration of medical aids and implants
* to enable patients to get effective digital care services that are tailored as closely as possible to their current state of health by automatically and privacy‑compliantly transferring data from medical devices and implants into DiGAs
* to empower healthcare professionals, via new DiGA solutions, e.g. to assess therapy outcomes by objective patient's measurements and intervene at an earlier stage when necessary

### User Stories Related to HDDT
The following user stories illustrate the intended use of the HDDT interface from different perspectives. 

#### Patients
Patients participate in HDDT as users of DiGAs and medical aids or implants. They benefit from the automatic and seamless data transfer from their medical devices to their DiGA, which can improve their care and therapy outcomes. 

User Stories from the patient's perspective include:
* As a DiGA user and patient, I can pair the DiGA with an medical aid or implant prescribed to me in order to make health data collected by the aid available to the DiGA and thus enable or support the care offered to me by the DiGA in a data-centered way.
* As a DiGA user and patient, I can benefit from Health Device Data Tranfer regardless if the DiGA has a web frontend or is a native app.
* As a DiGA user and patient, I would like to be informed if a newly initiated or an existing pairing between my medical aid or implant and the DiGA fails, e.g. because a consent becomes invalid due to a change in the system. In addition, I would like support that helps me to eliminate errors or explains the reasons for the failure (e.g. change in the data authorizations of the DiGA).
* As a patient and user of a DiGA and a medical aid or implant, I can be sure that the DiGA can only retriev data for its eligible purposes. 
* As a patient and user of a DiGA and a medical aid or implant, I can be sure that the data transfer between my medical aid or implant and the DiGA is secure and complies with data protection regulations.
* As a patient and user of a DiGA and a medical aid or implant, I can exchange my medical aid or implant for a device of the same type (e.g. putting on a new insulin pump) without having to perform the pairing process gain.

#### DiGA Manufacturer
A DiGA (Digital Health Application acc. §33a SGB V) is a medical product based on digital technologies that is used by patients independently or with the support of doctors or psychotherapists. DiGAs are primarily apps or web-based applications that help detect, monitor, treat, alleviate or prevent disease progression. The legal basis is §§ 33a and § 139e SGB V and the Digital Health Applications Ordinance (DiGAV).

User Stories from the perspective of DiGA manufacturers include:
* As a DiGA manufacturer, I would like to request ad receive health device data from the medical aids and implants used by my users in order to individualize and improve existing therapy offers for my users.
* As a DiGA manufacturer, I would like to be able to access the data from aids and implants that are required for the intended use of the DiGA as early as clinical studies.
* As a DiGA manufacturer, I would like to have as little effort as possible in the development, operation and testing of the interface connection to the device data sources.
* As a DiGA manufacturer, I would like to have no need to conclude bilateral contracts with manufacturers of medical aids, implants and these devices' backend systems to request and receive the data.
* As a DiGA manufacturer, I would like to continue to be able to certify and market my product as a medical device even with the implementation of the HDDT interface.
* As a DiGA manufacturer, I would like to be able to retrieve sufficient granular data in the form of individual measured values from medical aids and implants.
* As a DiGA manufacturer, I would like to receive contextual data in order to be flexible in the design of the use cases and to be able to make my own deductions on the received data.
* As a DiGA manufacturer, I want to be able to retrieve all the data I need for my use cases and be able to claim and implement changes to the required data as my use cases are further developed.
* As a DiGA manufacturer, I would like to be able to ask the user to pair with a medical aid or implant, if the data from these devices is required for my use cases for intended use.
* As a DiGA manufacturer, I need the HDDT interface to be sufficiently available and performant to be able to guarantee the functionality of my use cases.

#### Manufacturer of Medical Aids and Implants
Medical aids and implants are material means or technical products that are individually manufactured or supplied by their manufacturers in accordance with § 126 SGB V as mass-produced goods in an unchanged condition or as a basic product with appropriate handcrafted preparation, addition or modification. Due to their design and construction, medical aids and implants are primarily designed for personal use by the patient and are used in their general area of life or in the home environment.

Many medical aids are medical devices because they are used for medical purposes and fall under the EU Medical Device Regulation (MDR) (e.g. prostheses, hearing aids). Some medical aids are not medical devices because they do not fulfil a medical function or were not primarily developed for this purpose but rather serve to support everyday life or care (e.g. stairlifts). Even if a medical aid is a medical device, parts of the accessory such as a controlling app or a data recording backend can also be exempt from medical device certification. 

Medical implants are artificial materials that are inserted into the body permanently or long-term and have the task of measuring, supporting or replacing bodily functions. Medical implants are medical devices because they fall under the EU Medical Device Regulation (MDR). They are classified in the highest risk classes IIb and III, as they can have potentially serious effects on health.

User Stories from the perspective of manufacturers of medical aids and implants include:
* As a manufacturer of a medical aid or implant, I would like to have as little effort as possible in the development, operation and testing of the HDDT interface connection to DiGAs.
* As a manufacturer of a medical aid or implant, I would like to have as little effort as possible in the preparation and transformation of the data into the format (syntax and semantics) requested by the HDDT specification.
* As a manufacturer of a medical aid or implant, I must be sure that my medical aid or implant is still financed by the _GKV_ and, in the case of a medical device, can continue to be certified and marketed it as such.
* As a manufacturer of a medical aid or implant, I must be able to check whether the requesting DiGA is authorized to retrieve data with regard to the requested content and scope.