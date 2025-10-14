

### Standards Used

In this technical specification, the following standards have been used:

| Standard | Use with HDDT |
|----------|---------------|
| HL7 FHIR | The logical model of HDDT is fully mapped on a FHIR compliant [information model](information-model.md). The API for requesting device data is implemented through FHIR `get` and `search`RESTful API. The data shared with this API conforms to HL7 FHIR R4. Great effort has been taken to be fully compliant with the FHIR base specification (see [Use of HL7 FHIR](use_of_hl7_fhir.md)). |
| ISO/IEEE 11073 | Properties and configuration settings of personal health devices are preferable encoded using ISO/IEEE 11073 nomenclature |
| OAuth2         | The [pairing flow](pairing.md) for authorizing a DiGA to access device data is an implementation of the OAuth2 Code flow with PKCE. |
| SMART on FHIR | DiGA authorizations are encoded as [SMART Scopes](smart-scopes.html). |
| LOINC     | HDDT [Mandatory Interoperable Values](methodology.md)(MIVs) are mapped onto sets of LOINC codes. |
| UCUM | units of measures are consistently encoded in UCUM. |


### Compatibility of the HDDT FHIR Profiles

While deriving FHIR profiles from the assessed use cases (see [methodology](methodology.html)), existing profiles from other countries and organizations have been considered in order to be as compliant as possible with existing solutions. 

| HDDT FHIR profile | international profile  | HDDT compliance statement |
|-------------------|-----------------|---------|
| blood glucose measurement ([Observation](https://hl7.org/fhir/R4/observation.html)) | [UK Core Observation Blood Glucose](https://simplifier.net/hl7fhirukcorer4/ukcore-observation-bloodglucose) | UK Core allows only SNOMED CT for the `Observation.code` element while HDDT only allows LOINC. <br>`Observation.device` is optional for UK Core. |
| | [US Core R4 Observation](https://hl7.org/fhir/us/core/STU4/Observation-blood-glucose.json.html) | fully compliant except that `Observation.device` is mandatory with HDDT. |
| | [International Patient Summary: Observation Results](https://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition-Observation-results-uv-ips.html) | `Observation.device` is optional for IPS. Other derivations are minor issues that do not affect the compatibility with HDDT blood sugar measurements: IPS only allows for _final_ as an observation's `status`. IPS allows for explicitly missing effective[x] elements using an extension. |
| | [Clinivault Observation](https://simplifier.net/clinivault/example-10) (India) | fully compliant except that `Observation.device` is mandatory with HDDT. |
| | [KBV Basisprofile](https://simplifier.net/base1x0/kbv_pr_base_observation_glucose_concentration) (Germany) | `Observation.device` is mandatory with HDDT. HDDT only allows for a single `Observation.code` while KBV requests two (LOINC and SCT). |
| | [ISiKLebensZustand](https://simplifier.net/guide/isik-basis-stufe-5/Einfuehrung/Artefakte/Datenobjekte_Lebenszustand?version=5.0.0) (Germany) | `Observation.device` is mandatory with HDDT. HDDT only allows for a single LOINC `code` while ISiK allows for an additional SCT code. ISiK sets `Observation.value[x]`to [1..1], while HDDT allows for values to be absent. |
| | [Finnish PHR Blood Glucose Profile](https://simplifier.net/digious-fi/fiphrsdbloodglucose) | Finnish PHR allows for LOINC Codes which are not part of the HDDT MIVs. Finnish PHR disallows `Observation.device` which is mandatory for HDDT.  |
| CGM summary report ([Bundle](https://hl7.org/fhir/R4/bundle.html)) | [HL7 CGM IG](https://github.com/HL7/cgm) | The HDDT _cgm summary report_ capsuled with the FHIR bundle is fully compliant with the machine readable part of the HL7 CGM IG (_CGMSummaryObservation_ profile). |
| ISF glucose measurement ([Observation](https://hl7.org/fhir/R4/observation.html)) || _Recently there seem to be no dedicated profiles available for capturing continuous glucose monitoring (CGM) raw data as FHIR SampledData. Available CGM profile either only cover key values (see [HL7 CGM IG](https://github.com/HL7/cgm)) or provide one Observation resource per data point. The later approach was discarded due to severe efficiency problems with modern CGM with sample rates of up to one value per minute._ |

As can bee seen in the table, the only derivation from existing profiles is that HDDT makes the `Observation.device` element mandatory with raw glucose measurement data. The reason for this is to address specific patient safety issues which arise from the specific HDDT use cases:
* neither DiGA nor the medical aids' backend systems do securely identify the patient. They just match authenticated patient accounts. Therefore the `Device.serialNumber` as provided with a [Device](https://hl7.org/fhir/R4/device.html) resource is the only identifier that allows the patient to verify that data originated from his personal health device.
* DiGA can be medical devices of MDR class IIa or even MDR class IIb that process medical data for therapeutic purposes, e.g. including the adaptation of insulin correction factors. For this a DiGA MUST be able to verify that data comes from a calibrated system. The respective information is only available through the [DeviceMetric](https://hl7.org/fhir/R4/observation.html) resource.

