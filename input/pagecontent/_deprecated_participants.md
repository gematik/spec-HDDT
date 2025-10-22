


### Responsibilities
§ 374a SGB V as the legal foundation of the HDDT specification names several actors that take certain roles in the definition and the operation of the HDDT ecosystem:
* __gematik__ is responsible for providing the technical and semantical HDDT specifications for all aspects related to security and health data transfer. gematik may define further non-functional requirements that manufacturers of medical aids, implants and/or DiGA have to consider (e.g. service levels). gematik may define rules and procedures for approval of conformance with the HDDT specification.
* __BfArM__ is responsible or setting up and operating registers for DiGA and devices affected by § 374a SGB V (see [certification relevant systems](certification-relevant-systems.html)). BfArM is responsible for setting up processes for DiGA manufacturers and manufacturers of medical aid and implant to register with these registries. 
* __manufacturers of medical aids and implants__ MUST implement and provide the HDDT API if they fulfill the criteria listed for [certification relevant systems](certification-relevant-systems.html). They MUST actively register details about their implementation with the _BfArM Device Registry_ As further detailled below, this affects manufacturs of the device hardware as well as entieties who are operating backend systems where data from these devices is persisted.

__Manufacturers of DiGA__ MAY implement the requestor (client) part of the HDDT API. If they do so, they MUST provide relevant information to BfArM for registration with the _BfArM DiGA registry_ and appyl for conformance approval by gematik (if requested by gematik).

### Logical Decomposition

The HDDT ecosystem can be divided into sereral logical building blocks that are operated by the listed actors. For the components operated by the manufacturers of the medical aids' and implants' devices, frontends and backend systems, the HDDT specification follows the logical decomposition defined by the [Continua Health Alliance](https://www.slideserve.com/kanoa/continua-health-alliance):
* The __Personal Device__ is the hardware of the medical aid or implant and realizes the sensory recording of data on, at or inside the patient. 
* The data is transmitted via a local point-to-point connection to an __Personal Health Gateway__, which validates the data, prepares it and, if necessary, merges it with other data. For most devices, the Personal Health Gateway will be a mobile application on a smartphone or tablet, but it is not uncommon to have dedicated mobile controllers (e.g. in some insulin pumps), desktop systems or web portals (e.g. for wired data import) or set-top boxes (e.g. in implants). 
* The data is transmitted to a background system via an internet connection and persisted there in a __Health Record__. 

Every Personal Device that falls under the regulation of § 374a SGB V is registered with the __BfArM Device Registry__. Every data recording platform (Personal Health Gateway together with its connected Health Record) that is a [HDDT certification relevant system](certification-relevant-system.html) is registered with the BfArM Device Registry, too.  

DiGA can access device data only through the Health Record. Access is restricted to authorized DiGA which are listed with the __BfArM DiGA Registry__. DiGA can proof authorization to the Health Record through an OAuth Access Token. This token is issued by an __Authorization Server__ which is operated by the owner of the Health Record. The Authorization Server not only consideres a DiGA's permissions as recodred in the BfArM DiGA Registry but as well takes care, that the patient has given a valid consent for sharing his health data with authorized DiGA.

Manufacturers of certification relevant device data recording platforms MUST implement the HDDT API which consists of:
* the FHIR based API of the Health Record for reading and searching data from medical aids and implants
* the OAuth2 compliant API of the Authorization Server for requesting and managing authorization tokens. 

Manufacturers of certification relevant device data recording platforms MUST be able to access APIs of the central service of the HDDT ecosystem. In particular they must be able to
* gather information about connecting DiGA from the BfArM DiGA Registy,
* update their own entries with the BfArM Device Registry, and
* to retrieve identified FHIR ValueSet resources from the __German Central Terminology Server__ (ZTS).

The figure below shows how these logical building blocks interact with each other.

<div><img src="HDDT building blocks.png" alt="building blocks of the HDDT ecosystem" width="65%"></div>
<br clear="all"/>

