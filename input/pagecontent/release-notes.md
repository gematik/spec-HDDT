As part of the HDDT releases, [Semantic Versioning](https://semver.org/) is used.

The first digit X indicates a major release and specification increment and determines the validity of releases. The third digit Y (release x.0.y) denotes a technical correction and versions minor changes (packages) within a validity period, e.g. 1.0.1.

The tags are used as follows:

* `documentation`: used to indicate that only documentation has been changed or added, with no impact on normative aspects.

* `feature`: used to introduce new content, in particular new FHIR profiles and examples.

* `improve`: used to adapt, refine, or extend existing normative content (including via Technical Corrections) without fixing errors.

* `fix`: should only be used for fixing **errors** in the (potentially) normative content of the specification (requirements + profiles + examples); typo fixes are not included in the release notes.

### Version 1.0.0

---

Date: 30.01.2026

All extensions and changes to the specification are either based on the regular project plan (e.g. adding further domains) or on feedback received during the ballot period of version 0.1.0-ballot.

* `feature` added new MIVs, profiles, operations descriptions, and examples for domain _Lung Function Testing_.
* `feature` added new MIVs, profiles, operations descriptions, and examples for domain _Blood Pressure Monitoring_.

* `fix` Consent validity may be longer than the prescription period of the DiGA, therefore the DiGA must check both. Sequence diagram for request authorization were corrected respectively.
* `fix` updated links to the current version (1.0.0 - STU 1) of the HL7 CGM profiles.
* `fix` corrected the requirments on log donwloads (esp. _TLS_ instead of _mTLS_)
* `fix` some examples had been hard coded to the documentation and therefore were not validated by IG pubisher. All examples are now provided as the FSH and are validated during the build process.
* `fix` _Must Support_ was further relaxed to cover situations were requested data elements are managed by a third party system and therefore may not be available to a Device Data Recorder.
* `fix`  A requests for aggregated data that would result in an empty bundle, MUST give an OperationOutcome with an error or warning message as its response. In the original text it was incorrectly stated that an empty bundle should be returned.
* `fix` If a search for _Observations_ goes too far back in the past, it does not return a 404, but rather a 200 with a bundle containing an OperationOutcome with the error message.
* `fix` attributes of the Device Data Recorder (e.g. _delay-from-real-time_) are defined per MIV. The original text incorrectly suggested that these attributes are globally defined for all MIV that are supported by a Device Data Recorder.
* `fix` It is suggested that the attributes (_Grace-Period_, etc.) can be queried via an API. This is incorrect. According to the now available _HIIS-VZ_ specification, the attributes are part of the resource (via extension).

* `improve` cardinality of _Device.definition_ changed from 1..1 to 0..1 to further align with existing FHIR profiles for medical devices.
* `improve` attribute _chunk-time-span_ was changed from externally visible configuration item to a sole internal value at the Device Data Recorder because DiGA can also derive this value from the sampled _Observation_ data
* `improve` CT validation skipped for DiGA because only Device Data Recorders need validated CT for secure mTLS.
* `improve` added recommendations for caching times in test environments
* `improve` end of 2026 BfArM published the _HIIS-VZ_ specification including the _DeviceDefinition_ profiles. Refernces to these profiles were added to the HDDT specification. Statements about the attributes of these profiles were specified to match the _HIIS-VZ_ information model (e.g. making clear that some of these attributes are only accessible through extensions to the _DeviceDefinition_ resource type). 
* `improve` strict requirements about response times have been removed. Vendors should go for best effort instead.

* `documentation` added a dedicated page about error handling including a condensed list of all error codes
* `documentation` section about Device Data Recorder attributes was moved to the Information Model and rewritten for better clarity. 
* `documentation` Deleted chapter 3.3 (Reference implementation) and added information about test support to chapter 3.2
* `documentation` clarification for building rules for the pairingID (MUST be specific for the user account of the Device Data Recorder)
* `documentation` clarified why the version 1.0.0 of the HDDT specification only supports a subset of the contents mentioned in § 374a SGB V (e.g. only rudimentary configuration data)
* `documentation` minor clarifications regarding aggregated data with a clearer focus on clinical metrics from continuous measurements
* `documentation` The term _metric_ was used for both clinical metrics and device metrics. More clear wording is used now.
* `documentation` clarification about the origin and use of _DiGA-ID_ added
* `documentation` clarified that the strict rules about service times do not hold for unscheduled, security-related hot fixes 
* `documentation` added examples for various ways to include _code_ arguments with a query for _Observation_ resources
* `documentation` clarified that Observation.device SHOULD NOT refer to a DeviceMetric resource for devices that do not require calibration
* `documentation` Clarified that a DiGA may request access to resources of multiple MIVs and that the Pairing-ID has to stay stable in such cases.
* `documentation` The description _interoperable value_ in the information model could be read as if these are atomic isolated items. This is wrong. _interoperable values_ may hold multiple data points (e.g. systolic and diastolic blood pressure) and may as well contain references to other _interoperable values_. This is clarified now.
* `documentation` minor corrections and extensions to the glossary
* `documentation` correction of typographical errors and formatting issues throughout the specification

### Version 0.1.0-ballot

---

Date: 29.10.2025

First ballot version of the technical concept and specificatory aspects for validation with stakeholders. This version includes all generic specification parts together with [MIV-specific APIs](mivs.html) and profiles for the _MIVs_:
- Blood Glucose Measurement
- Continuous Glucose Measurement
