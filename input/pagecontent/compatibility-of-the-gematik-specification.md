### Status: Offen
* Verantwortlich: @jcaumann
* ToDo:
    * Bezug zu ISO 11073 (Jörg)
    * Bezug zu bestehenden FHIR Profilen (Jörg)
    * Bezug zu Security Standards in der TI (Jörg)

<hr>

### Standards Used

In this technical specification, the following standards have been used:

| Standard | Use with HDDT |
|----------|---------------|
| HL7 FHIR | The logical model of HDDT is fully mapped on a FHIR compliant [information model](information-model.md). The API for requesting device data is implemented through FHIR `get` and `search`RESTful API. The data shared with this API conforms to HL7 FHIR R4. Great effort has been taken to be fully compliant with the FHIR base specification (see [Use of HL7 FHIR](use_of_hl7_fhir.md)). |
| ISO/IEEE 11073 | ??? |
| OAuth2         | The [pairing flow](pairing.md) for authorizing a DiGA to access device data is an implementation of the OAuth2 Code flow with PKCE. |
| SMART on FHIR | The discovery of the OAuth endpoints from a FHIR server is based on the SMART on FHIR _SMART Capability_ mechanism. DiGA authorizations are encoded as SMART Scopes (v2). |
| SNOMED CT | ???  |
| LOINC     | HDDT [Mandatory Interoperable Values](methodology.md)(MIVs) are mapped onto sets of LOINC codes. |


### Compatibility of the HDDT FHIR Profiles

| HDDT FHIR profile | international profile  | compliance statement |
|-------------------|-----------------|---------|
| glucose in capillary blood ([Observation](https://hl7.org/fhir/R4/observation.html)) | [UK Core Observation Blood Glucose](https://simplifier.net/hl7fhirukcorer4/ukcore-observation-bloodglucose) | UK Core allows only SNOMED CT for the `code` element while HDDT only allows LOINC <br>`device` is optional for UK Core |
| | [US Core R4 Observation](https://hl7.org/fhir/us/core/STU4/Observation-blood-glucose.json.html) | fully compliant except that `device` is mandatory with HDDT |
| | [Clinivault Observation](https://simplifier.net/clinivault/example-10) (India) | fully compliant except that `device` is mandatory with HDDT |
| | [KBV Basisprofile](https://simplifier.net/base1x0/kbv_pr_base_observation_glucose_concentration) (Germany) | `device` is mandatory with HDDT<br>HDDT only allows for a single `code` while KBV requests two |
| | [Finnish PHR Blood Glucose Profile](https://simplifier.net/digious-fi/fiphrsdbloodglucose) | Finnish PHR allows for LOINC Codes which are not part  of the HDDT MIV <br>Finnish PHR disallows `device` which is mandatory for HDDT  |

