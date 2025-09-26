§ 374a SGB V requests vendors of medical aids and implants to provide medical device data for authorized digital health applications (DiGA) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT) implementation guide, which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

### Content
The HDDT implementation guide includes requirements for: 
* Patient-initiated authorisation of the DiGA to retrieve health data from the utilised medical aid/implant (consent)
* Management of authorisation by the patient (modifying and revoking consent)
* Retrieval of information necessary for a DiGA to use the interfaces
* Retrieval of information necessary for a medical aid/implant to use the interfaces
* Confidential transmission of health data from the medical aid/implant to a DiGA based on a user's pseudonym
* Verifiability of the authenticity of DiGA and medical aid/implants
* Ensuring data interoperability between DiGA and medical aids/implants
* Evidence and traceability of the operational functionality of the interface

Out-of-Scope for the HDDT implementation guide are:
* Identification and authentication of the patient vis-à-vis a DiGA or a medical aid/implant (manufacturer-specific)
* Definition of a DiGA/medical aid API for front-ends (manufacturer-specific)
* Protection of health data storage or health data processing within a DiGA or a medical device (manufacturer-specific)

### About the current version
The current __Draft version__ aims for the validation of the technical concept and specificatory aspects with affected medical aid, implant and DiGA manufacturers as well as other stakeholders. The parts describing the pairing mechanism between DiGA and medical aid or implant for authentication, authorization and logging are general requirements across all product groups and domains. The interoperable values however will be defined per domain. For this Draft version, the domain of __Diabetes Self-Management__ was defined as a first domain to specify data interoperability (see section [Methodology](methodology.md)). For further information on the status and roadmap for the specification, see [Release notes](release-notes.md) and [Roadmap](Roadmap.md).

### Contact and feedback
Please submit questions and comments via our [request portal](https://service.gematik.de/servicedesk/customer/portal/16) until 30.11.2025.

If you do not have access to the request portal and would like to use it, please send us a message to hddt [at] gematik.de with the subject “Portal access”.

### License Information
This implementation guide is published unter the __XXXXX__ license. 







