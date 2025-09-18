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


### Description 
Standardized access to medical device/implant data as FHIR resources for authorized DiGA.  

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |
---

### Read Interactions

Endpoints that are required to support the REST interaction "READ", **MUST** be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions, **MUST** conform to the HDDT FHIR Profiles.

### Search Interactions

Endpoints that are required to support the "SEARCH" interactions, **MUST** allow searching via HTTP GET. Endpoints **MAY** choose to support search request via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).


### Endpoints

| Endpoint | Use Cases | Specifications | Data Objects |
|----------|-----------|----------------|--------------|
| `/metadata` | • Information on supported FHIR version & profiles for DiGA vendor<br> • Supported resources & operations<br>- Supported search parameters & filters | • No Mutual-TLS Client Authentication (public endpoint)<br>• **FHIR R4** (from context)<br>• Endpoint **MUST** be available to declare: supported FHIR version, resources, operations, search parameters, profiles | **FHIR CapabilityStatement**<br>Supported Profiles: <br> • Device, DeviceMetric, Observation<br><br>Resource Interactions:<br>• Device: read <br>• DeviceMetric: read <br> • Observation: read, search<br>
| `/Observation` |  • Query most recent measurement (single values)<br>• Query time series data for a patient<br> | • Allowed interactions: READ, SEARCH <br> • Data **MUST** conform to defined FHIR Profiles (e.g. [SD-Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html))<br>• Single values: `valueQuantity`<br>• Time series: `valueSampledData`<br>• Reference to either Device or DeviceMetric **REQUIRED**<br>• Values must be fully normalized (`unit/system/code`)| **FHIR Observation**<br>Single value: `valueQuantity`<br>Time series: `valueSampledData`<br>**FHIR DeviceMetric** (via `device`)<br>**FHIR Device** (via `device`) | 
| `/Device` |• Query the configuration and properties of the device instance based on the last measurement or last measurement series.<br> • Query information about the stored device instance for device validation (e.g., serial number, type, manufacturer). <br> • Complements the query of Observation/DeviceMetric, since information about the underlying device is not always delivered directly with the measurement. | • Only allows FHIR READ interaction using the Device ID, retrieved from an Observation or DeviceMetric.<br>• Returns Device instances (e.g. glucometers)<br>• Identifier may include device registry number<br>• Referenced by either `DeviceMetric.source` or `Observation.device` (**REQUIRED**)<br>• Serial number required for validation<br>• Does **not** support `_include` or `?_id=`; use `/Device/{id}` to obtain a single resource. | **FHIR Device** <br> `Device.status` - is the device active <br> `Device.expirationDate` <br><br> The following properties are used for user verification and consent: <br> `Device.deviceName` <br> `Device.manufacturer` <br> `Device.serialNumber` | 
| `/DeviceMetric`| • Query the calibration status of the device for the last measurement or last measurement series. <br> • Reference to the specific device instance to maintain the link between measurement data and the physical sensor. | • Only allows FHIR READ interaction using the DeviceMetric ID retrieved from `/Observations`.<br>• Returns only the DeviceMetric referenced in the Observation, for data protection reasons.<br>• Does **not** support `_include` or `?_id=`; use `/DeviceMetric/{id}` to obtain a single resource. | **FHIR DeviceMetric**<br> <br> `calibration` - relevant for some devices (e.g. glucometer), where calibrating the device is needed <br> **FHIR Device** (via `source`)|
 

---

### FHIR Operations

This specification also includes a [FHIR opeartion](https://hl7.org/fhir/R4/operations.html) that **MUST** be supported by the API.


| | |
|-|-|
| **Resource** | Observation |
| **Operation name** | `$search-summary-data-measurement` |
|**Purpose** |  Request a summary of desired CGM values (e.g tissue glucose values below lower threshold) for a certain range of time. |
|**Parameters** |  See section "[OpenAPI Description](#openapi-description) for parameter definitions and examples.<br> • `effectivePeriodStart (dateTime)` (optional) <br> • `effectivePeriodEnd (dateTime)` (optional) - End of the effective time period <br> •  `related (boolean)` (optional)|
| **Specifications** | • Summary is calculated at run-time and results are not stored persistently. <br> •  **MUST** support all profiles listed in `Bundle-Search-Summary-Data-Measurements`. <br> • **MUST** support all listed parameters.<br> •  If no period is specified, the server selects a time range starting from the current date, which **MUST** cover at least 14 days.<br> •  The Summary-Operation **MUST** support a minimal duration of 7 days for the effective period, and an error must be returned if the client requests a shorter time period. |

---

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to only request resources, matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code.

The FHIR Search functionality is defined by HL7 [here.](https://www.hl7.org/fhir/R4/search.html)

Detailed definition of all supported search parameters can be found on the following pages. The listed search parameters **MUST** be supported by the FHIR server:
- in the documents, defining the MIVs:
    - [Measurement: Blood Glucose](measurement-blood-glucose.html)
    - [Measurement: Tissue Glucose](measurement-tissue-glucose.html)
- in the [OpenAPI description](#openapi-description) on this page.

#### Search Examples

Please note, that the examples below do not encompass all of the expected search functionality.

| Request | Explanation |
|---------|-------------|
| **GET** `/Observation?_id=1234` | Request a specific Observation resource, based on the its internal id. Result is a Bundle containing a single Observation. |
| **GET** `/Observation/1234` | Returns a single Observation resource, based on its internal id. |
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23th of July that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources, referenced by the observations.  |
| **GET** `/Observation?_sort=-date&_count=1` | Get the latest observation. |
| **GET** `/DeviceMetric/123` | Request a specific DeviceMetric resource, based on its internal id. This is FHIR read interaction, and does not allow parameters such as  `_include`. |

---

### Profiles

This section provides an overview of the FHIR profiles that the resources returned by this API must conform to. The overview is intentionally high-level and does not represent the full specification of each profile. Element usage may vary across different FHIR profiles.

For the complete definitions, refer to the [Artifacts](artifacts.html) page. For detailed guidance on how to populate FHIR elements based on specific use cases, see the corresponding Use Case chapters (e.g. [Measurement: Blood Glucose](measurement-blood-glucose.html), [Measurement: Tissue Glucose](measurement-tissue-glucose.html)).

**FHIR resource type**: Observation

|FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|---------------|------------|------------|----------------|------|
|  `status` | Status | 1..1 | code | Required by the FHIR specification. For time-series Observations, should only be set to "final", if the `valueSampledData` is completely filled (TODO: reference where the information is) |
| `code` | Type of Observation | 1..1 | CodeableConcept | Uses a code from the MIV value sets. |
| `effective` | Time or period of Obsevation | 1..1 | DateTime / Period | Observations with a single value use `effectiveDateTime`, while time-series Observations use `effectivePeriod` |
| `value` | Actual result | 1..1 | Quantity / SampledData | Observations with single value use `valueQuantity`| while time-series Observations use `valueSampledData` |
| `device` | Measuring device | 1..1 | Reference(Device / DeviceMetric) | In cases, where the sensor requires a calibration, `device` should reference a DeviceMetric. In all other cases, the reference should be to a Device. |
| `method` | Measurement method | 0..1 | CodeableConcept | Field is flagged as **must support** (see chapter [Use of HL7 FHIR](use_of_hl7_fhir.html)) |
| `dataAbsentReason` | Why is data missing | 0..1 | CodeableConcept | Use for time-seires data to indicate the reason for missing data. |

---
<br><br>

**FHIR resource type**: Device

| FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
| ---------------|------------|------------|----------------|------|
| `type` | Device Type | 1..1 | CodeableConcept |  |
| `deviceName` | Product name | 1..1 | string | e.g., "Accu-Chek Mobile". Display during OAuth consent. |
| `serialNumber` | Serial number | 1..1 | string | User verification (patient safety) |
| `manufacturer` | Manufacturer | 0..1 | string | Sensor manufacturer. Display during OAuth consent.  |
| `definition` | Device definition | 1..1 | Reference(DeviceDefinition) | Link to description of the Personal Health Device Definition, stored in the BfArM registry (See ch. [Information Mode](information-model.html#BfArM-Registries))  |
| `expirationDate` | End-of-life date | 0..1 | DateTime | |
| `property` | Other properties | 0..* | BackboneElement | Use for device configuration in the future. |

---
<br><br>


**Resource Type**: DeviceMetric

| FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
|----------------|------------|------------|----------------|------|
| `type` | Type of metric | 1..1 | CodeableConept | Important for access control |
| `calibration.state` | Calibration status | 1..1 | code | e.g., "calibrated" |
| `source` | Device | 1..1 | Reference(Device) | Reference to the specific device instance |

---
<br><br>

### Error Handling

The [OpenAPI section](#openapi-description) lists the expected HTTP error codes, the type of error, and likely reasons for the occurance of the error.

**Considerations:**

- The server **MUST** return the defined HTTP error codes, when the listed reason occurs.
- The server **MUST** return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource, if `[OperationOutcome]` is specified as the error type by the OpenAPI description.
- The server **SHOULD** provide a reason for the error, but the concrete contents of the [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) are not specified. The server can choose to use a code in `ObservationOutcome.issue.details`, or use the free text input in `ObservationOutcome.issue.diagonstics`. This means that using the default error messages of your FHIR server implementations is likely supported.

### Auditing

The server should create and store audit logs, as defined by chapter [Security and Privacy](security-and-privacy.html).





### OpenAPI Description
{% include openapi.html openapiurl="/files/openapi_himi_diga_api.yaml"%}