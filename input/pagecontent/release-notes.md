As part of the HDDT releases, [Semantic Versioning](https://semver.org/) is used.

The first digit X indicates a major release and specification increment and determines the validity of releases. The third digit Y (release x.0.y) denotes a technical correction and versions minor changes (packages) within a validity period, e.g. 1.0.1.

The tags are used as follows:

* **`documentation`**: used to indicate that only documentation has been changed or added, with no impact on normative aspects.

* **`feature`**: used to introduce new content, in particular new FHIR profiles and examples.

* **`improve`**: used to adapt, refine, or extend existing normative content (including via Technical Corrections) without fixing errors.

* **`fix`**: should only be used for fixing **errors** in the (potentially) normative content of the specification (requirements + profiles + examples); typo fixes are not included in the release notes.

### Version 1.0.0

---

Date: xx.xx.xxxx

* `fix` Corrected links to the current version (1.0.0 - STU 1) of the HL7 CGM profiles.

### Version 0.1.0-ballot

---

Date: 29.10.2025

First ballot version of the technical concept and specificatory aspects for validation with stakeholders. This version includes all generic specification parts together with [MIV-specific APIs](mivs.html) and profiles for the _MIVs_:
- Blood Glucose Measurement
- Continuous Glucose Measurement