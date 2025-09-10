# Status: Offen
* Verantwortlich: @jcaumann
* ToDo:
    * Bezug zu ISO 11073 (Jörg)
    * Bezug zu bestehenden FHIR Profilen (Jörg)
    * Bezug zu Security Standards in der TI (Jörg)

# Standards Used

# Compatibility

| HDDT FHIR profile | international profile  | compliance statement |
|-------------------|-----------------|---------|
| glucose in capillary blood ([Observation](https://hl7.org/fhir/R4/observation.html)) | [UK Core Observation Blood Glucose](https://simplifier.net/hl7fhirukcorer4/ukcore-observation-bloodglucose) | UK Core allows only SNOMED CT for the `code` element while HDDT only allows LOINC <br>`device` is optional for UK Core |
| | [US Core R4 Observation](https://hl7.org/fhir/us/core/STU4/Observation-blood-glucose.json.html) | fully compliant except that `device` is mandatory with HDDT |
| | [Clinivault Observation](https://simplifier.net/clinivault/example-10) (India) | fully compliant except that `device` is mandatory with HDDT |
| | [KBV Basisprofile](https://simplifier.net/base1x0/kbv_pr_base_observation_glucose_concentration) (Germany) | `device` is mandatory with HDDT<br>HDDT only allows for a single `code` while KBV requests two |
| | [Finnish PHR Blood Glucose Profile](https://simplifier.net/digious-fi/fiphrsdbloodglucose) | Finnish PHR allows for LOINC Codes which are not part  of the HDDT MIV <br>Finnish PHR disallows `device` which is mandatory for HDDT  |




