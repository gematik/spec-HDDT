[§ 374a SGB V](https://www.gesetze-im-internet.de/sgb_5/__374a.html) requests vendors of medical aids and implants to provide medical device data for Digitale Gesundheitsanwendungen (DiGA: authorized digital health applications) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT) implementation guide, which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

### Content
The HDDT implementation guide includes requirements for: 
* Ensuring data interoperability between DiGA and medical aids/implants through interfaces and profiles based on HL7 FHIR
* Patient-initiated authorisation of the DiGA to retrieve health data from the utilised medical aid/implant
* Management of authorisation by the patient
* Retrieval of information necessary for a DiGA to use the interfaces
* Retrieval of information necessary for a medical aid/implant to use the interfaces
* Confidential transmission of health data from the medical aid/implant to a DiGA based on a user's pseudonym
* Verifiability of the authenticity of DiGA and medical aid/implants
* Evidence and traceability of the operational functionality of the interface

Out-of-Scope for the HDDT implementation guide are:
* Identification and authentication of the patient vis-à-vis a DiGA or a medical aid/implant (manufacturer-specific)
* Process for identification of API endpoints
* Definition of a DiGA/medical aid API for front-ends (manufacturer-specific)
* Protection of health data storage or health data processing within a DiGA or a medical device (manufacturer-specific)

### About the current version
The current __ballot version__ aims for the validation of the technical concept and specificatory aspects with affected medical aid, implant and DiGA manufacturers as well as other stakeholders. The parts describing the pairing mechanism between DiGA and medical aid or implant for authorization and logging are general requirements across all product groups and domains. The interoperable values to be provisioned, however, will be defined per domain. For this Draft version, the domain of __Diabetes Self-Management__ was defined as a first domain to specify data interoperability (see section [Methodology](methodology.html)). For further information on the status and roadmap for the specification, see [Release notes](release-notes.html) and [Roadmap](Roadmap.html).

### Contact and feedback
Please submit questions and comments via our [request portal](https://service.gematik.de/servicedesk/customer/portal/16) until 30.11.2025.

If you do not have access to the request portal and would like to use it, please send us a message to hddt [at] gematik.de with the subject “Portal access”.

### License Information
This implementation guide is published under the __XXXXX__ license. 

### Copyrights
The HDDT Implementation Guide includes IP covered under the following statements.

* The UCUM codes, UCUM table (regardless of format), and UCUM Specification are copyright 1999-2009, Regenstrief Institute, Inc. and the Unified Codes for Units of Measures (UCUM) Organization. All rights reserved. https://ucum.org/trac/wiki/TermsOfUse
* Mandatory Interoperable Values are expressed through content from LOINC. LOINC is copyright © 1995-2020, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license provided at http://loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc.
* The HDDT Implementation Guide derives from HL7 Resource Definitions, Implementation Guides (e.g. [CGM Summary Profile](https://build.fhir.org/ig/HL7/cgm/)) and the HL7 Terminology (THO). THO is copyright ©1989+ Health Level Seven International and is made available under the CC0 designation. For more licensing information see: https://terminology.hl7.org/license.html
* The HDDT Implementation Guide makes reference to codes from the _ISO/IEEE 11073-10101 Health informatics — Point-of-care medical device communication — Nomenclature standard_. These codes are included under the terms of HL7 International’s licensing agreement with the IEEE. Users of this specification may reference individual codes as part of HL7 FHIR-based implementations. However, the full ISO/IEEE 11073 code system and its contents remain copyrighted by ISO and IEEE.

<!--### Acknowledgments
This Implementation Guide was developed by the _German Competence Center for Interoperability in Healthcare_ (Kompetenzzentrum für Interoperabilität im Gesundheitswesen, KIG) in fulfillment of § 374a (4) SGB V.

__Primary Editors__:
* Andrea Schminck (gematik)
* Dr. Jörg Caumanns (_fbeta GmbH)

__Key Contributors:__

* Thomas Kerner (gematik)
* Jie Wu (_fbeta GmbH)
* Sergej Reiser (_fbeta GmbH)
* Emil Milanov (_fbeta GmbH)
* Sophia Lückhoff (KIG)

This guide benefited from contributions from rtCGM device vendors, DiGA vendors, and clinicians. Their collective insights were invaluable in shaping the requirements and use cases that were the foundation for the solution specified in this implementation guide.-->


