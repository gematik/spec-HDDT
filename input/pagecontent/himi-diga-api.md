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


| Endpoint | Use Cases | Specifications | Data Objects |
|----------|-----------|----------------|--------------|
| `/metadata` | - Information on supported FHIR version & profiles for DiGA vendor<br> - Supported resources & operations<br>- Supported search parameters & filters | No Mutual-TLS Client Authentication (public endpoint)<br>**FHIR R4** (from context)<br>Endpoint **must** be available to declare: supported FHIR version, resources, operations, search parameters, profiles | **FHIR CapabilityStatement**<br>Supported Profiles: `Device`, `Observation`<br>Resource Interactions:<br>- Device: read, search<br> - Observation: read, search<br>
| `/Observation` | - Query most recent measurement (single values)<br>- Query time series data for a patient<br>- Query values incl. threshold comparison (e.g. “lo” and “high”)<br>- Possibly derived metrics | Data **must** conform to defined FHIR Profiles (e.g. `SD_vibW_Blutzucker`)<br>Single values: `Observation.valueQuantity`<br>Time series: `Observation.valueSampledData`<br>Reference to DeviceMetric **required**<br>Values must be fully normalized (`unit/system/code`)<br>Optional threshold comparison via `valueQuantity.comparator` | **FHIR Observation**<br>Single value: `Observation.valueQuantity`<br>Time series: `Observation.valueSampledData`<br>**FHIR DeviceMetric** (via `Observation.device`) | 
| `/DeviceMetric`| - Query information about the device configuration (unit, calibration, operational status)<br>- Link to the specific device instance |  Only queries using the DeviceMetric ID retrieved from `/Observations` are allowed. DiGAs should only be able to retrieve the authorized device configuration supported by this vibW (from the scope), i.e., only the DeviceMetric that is referenced in the Observation, for data protection reasons. | **FHIR DeviceMetric**<br>`DeviceMetric.type` - LOINC code of the measured value <br>`DeviceMetric.unit` <br> `DeviceMetric.source` - The device which is taking these measurements <br> `DeviceMetric.calibration` - relevant for some devices (e.g. glucometer), where calibrating the device is needed |
| `/Device` | - Query device properties<br>- Query device instance (serial number, type, manufacturer)<br>Optional endpoint for device-level information <br> - show the user which device they are pairing with | Device instances (e.g. glucometers)<br>Identifier may include device registry number<br>Referenced by `DeviceMetric.source` (required)<br>Serial number required for validation | **FHIR Device** <br> `Device.status` - is the device active <br> `Device.expirationDate` <br><br> The following properties are used for user verification and consent: <br> `Device.deviceName` <br> `Device.manufacturer` <br> `Device.serialNumber` | 

---

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to only request resources, matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code.

The FHIR Search functionality is defined by HL7 [here.](https://www.hl7.org/fhir/R4/search.html)

Detailed definition of all supported search parameters can be found on the following pages. The listed search parameters **MUST** be supported by the FHIR server:
- in the Capability Statement under the "Artifacts" menu heading.
- in the [OpenAPI description](#openapi-description) on this page.

#### Search Examples

Please note, that the examples below do not encompass all of the expected search functionality.

| Request | Explanation |
|---------|-------------|
| **GET** `/Observation?_id=1234` | Request a specific Observation resource, based on the its internal id. |
| **GET** `/Observation/1234` | Has the same effect as the request above. |
|**GET** `/Observation?code=http://loinc.org\|2339-0&patient=patient123`| Request all Observations that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?date=ge2025-07-23&` | Request all observations since the 23th of July. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources, referenced by the observations.  |
| **GET** `Observation?_sort=-date&_count=1` | Get the latest observation. |

---

**ToDo: Jie, Sergej, Emil**
- Add a section about Observation. Maybe put into a different section.

### Profiles

**FHIR resource type**: Observation

FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| status | Status | 1..1 | code | Use for time-series CGM results, to track whether the `sample-data` field is complete, or there are going to be further changes. |

---
**ToDo: Jie, Sergej, Emil**

**FHIR resource type**: Device

FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| serialNumber | Serial number | 1..1 | string | User verification (patient safety) |
| deviceName | Product name | 1..1 | string | e.g., "Accu-Chek Mobile" |
| manufacturer | Manufacturer | 0..1 | string | Sensor manufacturer |
| definition | Device definition | 1..1 | Reference(DeviceDefinition) | Link to device description |


---

**ToDo: Jie, Sergej, Emil**

**Resource Type**: DeviceMetric

 FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|----------------|------------|------------|----------------|------|
| unit | Measurement unit | 1..1 | CodeableConcept | e.g., UCUM: mg/dL |
| calibration/state | Calibration status | 0..1 | code | e.g., "calibrated" |
| operationalStatus | Operational status | 0..1 | code | Optional |
| source | Device | 1..1 | Reference(Device) | Reference to the specific device instance |


---



### OpenAPI Description
{% include openapi.html openapiurl="/files/openapi_himi_diga_api.yaml"%}