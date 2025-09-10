**ToDo**
* klären, was mit dem 3. vibW ist (Diabetesprofil) (Projekt)
* finale Definition Endpunkte (Jie, Emil)
* Beschreibung Endpunkte (Jie, Emil)
* Protokollierung (Jie, Emil)
* Fehlerbehandlung (Jie, Emil)
* openAPI (Jie, Emil, Sergej)
* Beispiele (Jie, Emil)
* Text bei API-Aufrufe ergänzen (Emil)
* Fehlercodes grob Erwähnen (Emil)


**Description**  
Standardized access to medical device/implant data as FHIR resources for authorized DiGA.  

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |

---

### Endpoints

| Endpoint | Use Cases | Specifications | Data Objects |
|----------|-----------|----------------|--------------|
| `/metadata` | • Information on supported FHIR version & profiles for DiGA vendor<br> • Supported resources & operations<br>- Supported search parameters & filters | • No Mutual-TLS Client Authentication (public endpoint)<br>• **FHIR R4** (from context)<br>• Endpoint **MUST** be available to declare: supported FHIR version, resources, operations, search parameters, profiles | **FHIR CapabilityStatement**<br>Supported Profiles: `Device`, `Observation`<br>Resource Interactions:<br>• Device: read, search<br> • Observation: read, search<br>
| `/Observation` | • Query most recent measurement (single values)<br>• Query time series data for a patient<br>• Query values incl. threshold comparison (e.g. “lo” and “high”)<br>- Possibly derived metrics | • Data **MUST** conform to defined FHIR Profiles (e.g. `SD_vibW_Blutzucker`)<br>• Single values: `Observation.valueQuantity`<br>• Time series: `Observation.valueSampledData`<br>• Reference to DeviceMetric **REQUIRED**<br>• Values must be fully normalized (`unit/system/code`)| **FHIR Observation**<br>Single value: `Observation.valueQuantity`<br>Time series: `Observation.valueSampledData`<br>**FHIR DeviceMetric** (via `Observation.device`) | 
| `/DeviceMetric`| • Query information about the device configuration (unit, calibration, operational status)<br>• Link to the specific device instance | • Only queries using the DeviceMetric ID retrieved from `/Observations` are allowed. DiGAs should only be able to retrieve the authorized device configuration supported by this vibW (from the scope), i.e., only the DeviceMetric that is referenced in the Observation, for data protection reasons. | **FHIR DeviceMetric**<br>`DeviceMetric.type` - LOINC code of the measured value <br>`DeviceMetric.unit` <br> `DeviceMetric.source` - The device which is taking these measurements <br> `DeviceMetric.calibration` - relevant for some devices (e.g. glucometer), where calibrating the device is needed |
| `/Device` | • Query device properties<br>• Query device instance (serial number, type, manufacturer) for validation with the user<br>• Optional endpoint for device-level information | • Only allows queries using the Device ID, retreived from an Observation or from a DeviceMetric.<br>• returns Device instances (e.g. glucometers)<br>• Identifier may include device registry number<br>• Referenced by either `DeviceMetric.source` or `Observation.device` (**REQUIRED**)<br>• Serial number required for validation | **FHIR Device** <br> `Device.status` - is the device active <br> `Device.expirationDate` <br><br> The following properties are used for user verification and consent: <br> `Device.deviceName` <br> `Device.manufacturer` <br> `Device.serialNumber` | 

---

### FHIR Operations

This specification also includes a [FHIR opeartion](https://hl7.org/fhir/R4/operations.html) that **MUST** be supported by the API.


| | |
|-|-|
| **Resource** | Observation |
| **Operation name** | `$search-summary-data-measurement` |
|**Purpose** |  Request a summary of desired values (e.g blood sugar values below lower threshold) for a certain range of time. |
|**Parameters** |  See section "[OpenAPI Description](#openapi-description) for parameter definitions and examples.<br> • `effectivePeriodStart (dateTime)` (optional) <br> • `effectivePeriodEnd (dateTime)` (optional) - End of the effective time period <br> •  `related (boolean)` (optional)|
|**Specifications** | •  **MUST** support all profiles listed in `Bundle-Search-Summary-Data-Measurements`. <br> • **MUST** support all listed parameters.<br> •  If no period is specified, the server selects a time range starting from the current date, which **MUST** cover at least 14 days.|

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
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23th of July that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources, referenced by the observations.  |
| **GET** `Observation?_sort=-date&_count=1` | Get the latest observation. |
| **GET** `DeviceMetric/123` | Request a specific DeviceMetric resource, based on its internal id. This notation does not allow an `_include` parameter. |
| **GET** `DeviceMetric?_id=123&_include=DeviceMetric:source` | Request a specific resource via its internal id, and return a Bundle, also containing the referenced Device resource.  |

---

**ToDo: Jie,  Emil**
<p style="color:red">
• Expand! Add general information about our changes from the FHIR standard (e.g. stricter cardinality) and semantic of the parameters. Refer to the Information Model and the specific Use Cases for more concrete information.
</p>

### Profiles

This section provides an overview of the FHIR 

**FHIR resource type**: Observation

FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| status | Status | 1..1 | code | Use for time-series CGM results, to track whether the `sample-data` field is complete, or there are going to be further changes. |

---
<br><br>

**FHIR resource type**: Device

FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| serialNumber | Serial number | 1..1 | string | User verification (patient safety) |
| deviceName | Product name | 1..1 | string | e.g., "Accu-Chek Mobile" |
| manufacturer | Manufacturer | 0..1 | string | Sensor manufacturer |
| definition | Device definition | 1..1 | Reference(DeviceDefinition) | Link to device description |

---
<br><br>


**Resource Type**: DeviceMetric

 FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|----------------|------------|------------|----------------|------|
| unit | Measurement unit | 1..1 | CodeableConcept | e.g., UCUM: mg/dL |
| calibration/state | Calibration status | 0..1 | code | e.g., "calibrated" |
| operationalStatus | Operational status | 0..1 | code | Optional |
| source | Device | 1..1 | Reference(Device) | Reference to the specific device instance |

---
<br><br>



### OpenAPI Description
{% include openapi.html openapiurl="/files/openapi_himi_diga_api.yaml"%}