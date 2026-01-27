[§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html) requests vendors of _medical aids_ and _implants_ (see [Glossary](glossary.html)) to provide medical device data for _Digitale Gesundheitsanwendungen_ (DiGA: authorized digital health applications) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT) implementation guide, which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

### Content
The HDDT implementation guide includes requirements for: 
* Ensuring data interoperability between _DiGA_ and _medical aids/implants_ through interfaces and profiles based on HL7 _FHIR_
* Patient-initiated authorisation of the _DiGA_ to retrieve health data from the utilised _medical aid/implant_
* Management of authorisation by the patient
* Retrieval of information necessary for a _DiGA_ to use the interfaces
* Retrieval of information necessary for a _medical aid/implant_ to provide the interfaces
* Confidential transmission of health data from the _medical aid/implant_ to a _DiGA_ based on a user's pseudonym
* Verifiability of the authenticity of _DiGA_ and _medical aid/implants_
* Evidence and traceability of the operational functionality of the interface

Out-of-Scope for the HDDT implementation guide are:
* Identification and authentication of the patient vis-à-vis a _DiGA_ or a _medical aid/implant_ (manufacturer-specific)
* Definition of a _DiGA/medical aid/implant API_ for front-ends (manufacturer-specific)
* Protection of health data storage or health data processing within a _DiGA_ or a _medical device/implant_ (manufacturer-specific)

### About the current version
The version 1.0.0-rc is the release candidate version with results of the commenting process of the former version 0.1.0-ballot. It contains specification of the pairing mechanism between _DiGA_ and _medical aid_ or _implant_ for authorization and logging as well as the definition of interoperable values to be provisioned per domain (for information about included domains, see [roadmap](roadmap.html)). For information on changes, see [release notes](release-notes.html).  

FHIR packages that hold the current versions of all HDDT resource definitions are available at [https://simplifier.net/hddt-workflow](https://simplifier.net/hddt-workflow).

### Intended Audience
The primary audience for this implementation guide are product managers, developers, and architects of manufacturers of medical aids, implants and DiGA. 

For developers and architects the following sections of this specification are of particular interest:
* The [Logical Viewpoints](logical-viewpoints.html) provide a high-level overview of the system architecture and main components.
* Section [Security and Privacy](security-and-privacy.html) sketches the security services and mechanisms to be implemented. Further details on specific aspects are give in the sections [Pairing](pairing.html) and [Smart Scopes](smart-scopes.html) while the technical specifications are provided in section [Authorization Server](authorization-server.html).
* The sections [Information Model](information-model.html) and [Retrieving Data](retrieving-data.html) provide logical descriptions of the FHIR-based data model and the RESTful interactions. Technical specifications for these interactions are provided in the section [FHIR Resource Server](himi-diga-api.html). 
* The implementation of the data model is through dedicated FHIR profiles and value sets per _Mandatory Interoperable Values_. The section [MIVs](mivs.html) lists the Mandatory Interoperable Values defined so far and provides links to the respective FHIR profiles and value sets. An overview of all FHIR profiles and value sets defined in this implementation guide is given in section [FHIR Artifacts Summary](artifacts.html), where you find examples, too.

Readers who are responsible for project management, product management, or regulatory affairs may find the following sections useful:
* The [Roadmap](roadmap.html) describes how the technical specifications will be extended in the future to cover further domains. In addition this sections gives first hints on the regulatory approval process and procedures for product registration.
* [Certification Relevant Systems](certification-relevant-systems.html) describes which products and components are affected by § 374a SGB V and MUST implement the services as defined in this specification.
* Section [Security and Privacy](security-and-privacy.html) defines trust anchors and security objects that MUST be provided by the manufacturers of medical aids, implants, and DiGA.
* [Operational Requirements](operational-requirements.html) describe the operational procedures and service levels that MUST be provided by manufacturers of certification relevant systems.

### Contact and feedback
Please submit questions and comments about this implementation guide via our [request portal](https://service.gematik.de/servicedesk/customer/portal/16).

If you do not have access to the request portal and would like to use it, please send us a message to hddt [at] gematik.de with the subject “Portal access”.

### Copyrights
This IG is created and maintained by [gematik GmbH](https://www.gematik.de).

It includes IP covered under the following statements:

* The UCUM codes, UCUM table (regardless of format), and UCUM Specification are copyright 1999-2009, Regenstrief Institute, Inc. and the Unified Codes for Units of Measures (UCUM) Organization. All rights reserved. https://ucum.org/trac/wiki/TermsOfUse
* Mandatory Interoperable Values are expressed through content from LOINC. LOINC is copyright © 1995-2020, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license provided at http://loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc.
* The HDDT Implementation Guide derives from HL7 Resource Definitions, Implementation Guides (e.g. [CGM Summary Profile](https://hl7.org/fhir/uv/cgm/)) and the HL7 Terminology (THO). THO is copyright ©1989+ Health Level Seven International and is made available under the CC0 designation. For more licensing information see: https://terminology.hl7.org/license.html
* The HDDT Implementation Guide makes reference to codes from the _ISO/IEEE 11073-10101 Health informatics — Point-of-care medical device communication — Nomenclature standard_. Codes and display texts are adapted and reprinted with permission from IEEE for the sole purpose of producing this specification. Copyright IEEE 2020. All rights reserved.


