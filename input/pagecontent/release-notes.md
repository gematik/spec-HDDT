As part of the HDDT releases, [Semantic Versioning](https://semver.org/) is used.

The first digit X indicates a major release and specification increment and determines the validity of releases. The third digit Y (release x.0.y) denotes a technical correction and versions minor changes (packages) within a validity period, e.g. 1.0.1.

The tags are used as follows:

* `documentation`: used to indicate that only documentation has been changed or added, with no impact on normative aspects.

* `feature`: used to introduce new content, in particular new FHIR profiles and examples.

* `improve`: used to adapt, refine, or extend existing normative content (including via Technical Corrections) without fixing errors.

* `fix`: should only be used for fixing **errors** in the (potentially) normative content of the specification (requirements + profiles + examples); typo fixes are not included in the release notes.

### Version 1.0.0-rc

---

Date: 29.01.2026

All extensions and changes to the specification are either based on the regular project plan (e.g. adding further domains) or on feedback received during the ballot period of version 0.1.0-ballot.

* `feature` [Lung Function Testing](measurement-lung-function.html): Added new MIVs, profiles, operations descriptions, and examples for domain _Lung Function Testing_.
* `feature` [Blood Pressure Monitoring](measurement-blood-pressure.html): Added new MIVs, profiles, operations descriptions, and examples for domain _Blood Pressure Monitoring_.


* `fix` [Pairing](pairing.html): Consent validity may be longer than the prescription period of the DiGA; therefore, the DiGA must check both. Sequence diagrams for request authorization were corrected accordingly.
* `fix` [Continuous Glucose Measurement](measurement-cgm.html): Updated links to the current version (1.0.0 – STU 1) of the HL7 CGM profiles.
* `fix` [Security and Privacy](security-and-privacy.html): Corrected the requirements on log downloads (esp. _TLS_ instead of _mTLS_).
* `fix` [Use of HL7 FHIR](use_of_hl7_fhir.html): Some examples had been hard coded into the documentation and therefore were not validated by the IG Publisher. All examples are now provided as FSH and are validated during the build process.
* `fix` [Use of HL7 FHIR](use_of_hl7_fhir.html): _Must Support_ was further relaxed to cover situations where requested data elements are managed by a third-party system and therefore may not be available to a Device Data Recorder.
* `fix` [Retrieving Data](retrieving-data.html): A request for aggregated data that would result in an empty bundle MUST return an OperationOutcome with an error or warning message. The original text incorrectly stated that an empty bundle should be returned.
* `fix` [Retrieving Data](retrieving-data.html): If a search for _Observations_ goes too far back in the past, it does not return a 404 but instead returns a 200 with a bundle containing an OperationOutcome with an error message.
* `fix` [Information Model](information-model.html): Attributes of the Device Data Recorder (e.g. _delay-from-real-time_) are defined per MIV. The original text incorrectly suggested that these attributes are globally defined for all MIVs supported by a Device Data Recorder.
* `fix` [Information Model](information-model.html): It was previously suggested that the attributes (_Grace-Period_, etc.) could be queried via an API. This is incorrect. According to the _HIIS-VZ_ specification, the attributes are part of the resource (via extension).


* `improve` [Pairing](pairing.html): Clarified that the DiGA backend must check on a daily basis whether the consent or prescription period associated with a Pairing ID is still valid.
* `improve` [Pairing](pairing.html): Removed the requirement for a Pairing ID to be "random", keeping only the requirement that it be "sufficiently long and unpredictable".
* `improve` [Security and Privacy](security-and-privacy.html): Rephrased the authorization requirements in the "Authorization of the DiGA" section for better clarity and consistency. The conditions for granting access are now presented as conjunctive requirements that must all be fulfilled.
* `improve` [Certification Relevant Systems](certification-relevant-systems.html): Improved clarity by explicitly mentioning that the figure illustrates the data-flow in the personal health device ecosystem. Updated figure caption and cross-references for consistency.
* `improve` [Information Model](information-model.html), [Retrieving Data](retrieving-data.html): Cardinality of _Device.definition_ changed from 1..1 to 0..1 to further align with existing FHIR profiles for medical devices.
* `improve` [Retrieving Data](retrieving-data.html): Attribute _chunk-time-span_ was changed from an externally visible configuration item to a solely internal value at the Device Data Recorder because the DiGA can derive this value from the sampled _Observation_ data.
* `improve` [Security and Privacy](security-and-privacy.html): CT validation was skipped for DiGA because only Device Data Recorders need validated CTs for secure mTLS.
* `improve` [Security and Privacy](security-and-privacy.html): Added recommendations for caching times in test environments.
* `improve` [Security and Privacy](security-and-privacy.html): Clarified that audit logs must be restricted to information necessary for audit and security purposes, and MUST NOT include personal data identifying the patient.
* `improve` [Information Model](information-model.html): At the end of 2025, BfArM published the _HIIS-VZ_ specification including the _DeviceDefinition_ profiles. References to these profiles were added to the HDDT specification, and statements about the attributes were aligned with the _HIIS-VZ_ information model.
* `improve` [Operational Requirements](operational-requirements.html): Strict requirements about response times were removed. Vendors should apply a best-effort approach.


* `documentation` [Pairing](pairing.html): Added clearly defined scenarios and conditions under which the DiGA and a Device Data Recorder must be unpaired.
* `documentation` [Certification Relevant Systems](certification-relevant-systems.html): Updated Example 5 to clarify that manufacturers must make rtCGM data from their own devices and from third-party vendors available to other DiGA via the HDDT interface.
* `documentation` [Error Codes](error-codes.html): Added a dedicated page about error handling, including a condensed list of all error codes.
* `documentation` [HIMI DiGA API](ddr-diga-api.html): Added a dedicated section about search parameters that MUST be supported by FHIR Resource Server implementations.
* `documentation` [Information Model](information-model.html): The section about Device Data Recorder attributes was moved to the Information Model and rewritten for better clarity.
* `documentation` [Operational Requirements](operational-requirements.html): Deleted chapter 3.3 (Reference implementation) and added information about test support to chapter 3.2.
* `documentation` [Pairing](pairing.html): Clarified the building rules for the pairingID (MUST be specific to the user account of the Device Data Recorder).
* `documentation` [General Considerations](general-considerations.html): Clarified why version 1.0.0 of the HDDT specification only supports a subset of the contents mentioned in § 374a SGB V.
* `documentation` [Retrieving Data](retrieving-data.html): Added minor clarifications regarding aggregated data with a clearer focus on clinical metrics from continuous measurements.
* `documentation` [Methodology](methodology.html): Clarified the use of the term _metric_ to distinguish between clinical metrics and device metrics.
* `documentation` [General Considerations](general-considerations.html): Added clarification about the origin and use of the _DiGA-ID_.
* `documentation` [Operational Requirements](operational-requirements.html): Clarified that strict rules about service times do not apply to unscheduled, security-related hot fixes.
* `documentation` [Retrieving Data](retrieving-data.html): Added examples for various ways to include _code_ arguments in queries for _Observation_ resources.
* `documentation` [Use of HL7 FHIR](use_of_hl7_fhir.html): Clarified that Observation.device SHOULD NOT refer to a DeviceMetric resource for devices that do not require calibration.
* `documentation` [Pairing](pairing.html): Clarified that a DiGA may request access to resources of multiple MIVs and that the Pairing-ID must remain stable in such cases.
* `documentation` [Information Model](information-model.html): Clarified that the term _interoperable value_ may represent multiple data points and may reference other interoperable values.
* `documentation` [Glossary](glossary.html): Added minor corrections and extensions to the glossary.
* `documentation` General: Corrected typographical errors and formatting issues throughout the specification.

### Version 0.1.0-ballot

---

Date: 29.10.2025

First ballot version of the technical concept and specificatory aspects for validation with stakeholders. This version includes all generic specification parts together with [MIV-specific APIs](mivs.html) and profiles for the _MIVs_:
- Blood Glucose Measurement
- Continuous Glucose Measurement
