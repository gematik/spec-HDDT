**ToDo**
* klären, was mit dem 3. vibW ist (Diabetesprofil) (Projekt)
* finale Definition Endpunkte (Jie, Emil)
* Beschreibung Endpunkte (Jie, Emil)
* Protokollierung (Jie, Emil)
* Fehlerbehandlung (Jie, Emil)
* openAPI (Jie, Emil, Sergej)
* Beispiele (Jie, Emil)
* Text bei API-Aufrufe ergänzen (Jörg)
* Fehlercodes grob Erwähnen (Emil)
* Suchparameter kurz auflisten (Emil)
* Example for content-types. Write a sentence about possible hearders. (Emil)
* Add some infos about the Operation (Emil)

**Description**  
Standardized access to medical device/implant data as FHIR resources for authorized DiGA.  

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |

---

### Endpoints

**ToDo: Search Parameters** - only an overview of parameters that:
* deviate from the HL7 FHIR specification. E.g. no sample-data search for some Observarions
* MUST be supported by the server
* anything else goes in the CapabilityStatement

or we use only Capability Statements?


| Endpoint | Use Cases | Specifications | Data Objects | Examples |
|----------|-----------|----------------|--------------|----------|
| `/metadata` | - Information on supported FHIR version & profiles for DiGA vendor<br> - Supported resources & operations<br>- Supported search parameters & filters | No Mutual-TLS Client Authentication (public endpoint)<br>**FHIR R4** (from context)<br>Endpoint **must** be available to declare: supported FHIR version, resources, operations, search parameters, profiles | **FHIR CapabilityStatement**<br>Supported Profiles: `Device`, `Observation`<br>Resource Interactions:<br>- Device: read, search<br> - Observation: read, search<br>**Search Parameters:**<br>- Observation: `patient`, `code`, `date`, `value-quantity`, `_id` | – |
| `/Observation` | - Query most recent measurement (single values)<br>- Query time series data for a patient<br>- Query values incl. threshold comparison (e.g. “lo” and “high”)<br>- Possibly derived metrics | Data **must** conform to defined FHIR Profiles (e.g. `SD_vibW_Blutzucker`)<br>Single values: `Observation.valueQuantity`<br>Time series: `Observation.valueSampledData`<br>Reference to DeviceMetric **required**<br>Values must be fully normalized (`unit/system/code`)<br>Optional threshold comparison via `valueQuantity.comparator` | **FHIR Observation**<br>Single value: `Observation.valueQuantity`<br>Time series: `Observation.valueSampledData`<br>**FHIR DeviceMetric** (via `Observation.device`) | **GET** `/Observation`<br>Search parameters:<br>- `_id`: `/Observation/<internal_id>`<br>- `identifier`: `?identifier=<identifier>`<br>- `code`: `?code=http://loinc.org|15074-8`<br>- `date`: `?_sort=-date&_count=1`<br>- `date`: `?date=ge2025-07-23`<br>- `method`: `?method=http://snomed.info/sct|736996008`<br>- `value-quantity`: `?value-quantity=gt140`<br>- `_include`: `?_include=Observation:device` |
| `/DeviceMetric`| - Query information about the device configuration (unit, calibration, operational status)<br>- Link to the specific device instance |  Only queries using the DeviceMetric ID retrieved from `/Observations` are allowed. DiGAs should only be able to retrieve the authorized device configuration supported by this vibW (from the scope), i.e., only the DeviceMetric that is referenced in the Observation, for data protection reasons. | Device configuration | GET `/eviceMetric`<br>Search parameters:<br> -`_id`: `/DeviceMetric/<internal_id>` |
| `/Device` | - Query device properties<br>- Query device instance (serial number, type, manufacturer)<br>Optional endpoint for device-level information | Device instances (e.g. glucometers)<br>Identifier may include device registry number<br>Referenced by `DeviceMetric.source` (required)<br>Serial number required for validation | **FHIR Device** | **GET** `/Device`<br>Search parameters:<br>- `_id`: `/Device/<internal_id>` |

---

### Special Note on DeviceMetric

- No dedicated **DeviceMetric endpoint** is exposed.  
- DeviceMetric resources are only retrievable via `_include` when querying Observations.  
- Rationale: a DiGA must not retrieve DeviceMetrics for vibW values it is not authorized for.  
- If needed for OAuth scope granularity (e.g. `DeviceMetric.type` authorization), a dedicated DeviceMetric endpoint may be added analogously to `/Device`.  


### OpenAPI Description
{% include openapi.html openapiurl="/files/openapi_himi_diga_api.yaml"%}