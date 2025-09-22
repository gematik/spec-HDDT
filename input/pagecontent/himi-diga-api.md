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


### Introduction
This document describes the generic FHIR API for standardized access to medical device/implant data as FHIR resources for authorized DiGA. The endpoints for the medical aid API have a generic and use-case-specific components.

This document defines the generic API definition - the API specification that is shared among different types of medical aid backends. The use-case-specific specification can be found under the Menu **MIV-Specific APIs**.

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |
---

### Read Interactions

Endpoints that are required to support the REST interaction "READ", **MUST** be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions, **MUST** conform to the HDDT FHIR Profiles.

### Search Interactions

Endpoints that are required to support the "SEARCH" interactions, **MUST** allow searching via HTTP GET. Endpoints **MAY** choose to support search request via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).

### Authentication

The authentication mechanism is described in chapter [Pairing - Tokens and Token Response](pairing.html#tokens-and-the-token-response).

### Error Handling

The [Endpoints](#endpoints) section lists the expected HTTP error codes, the type of error, and likely reasons for the occurance of the error.

**Considerations:**

- The server **MUST** return the defined HTTP error codes, when the listed reason occurs.
- The server **MUST** return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource, if `[OperationOutcome]` is specified as the error type by the OpenAPI description.
- The server **SHOULD** provide a reason for the error, but the concrete contents of the [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) are not specified. The server can choose to use a code in `ObservationOutcome.issue.details`, or use the free text input in `ObservationOutcome.issue.diagonstics`. This means that using the default error messages of your FHIR server implementations is likely supported.

### Auditing

The server should create and store audit logs, as defined by chapter [Security and Privacy](security-and-privacy.html).


### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to only request resources, matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code.

The Endpoint specification lists the most important search parameters for the generic API, and for individual MIV-Specific API. 

For each resource type, all standard FHIR search parameters MAY be supported. See [FHIR Search](https://www.hl7.org/fhir/R4/search.html).


### Endpoints

| Endpoint | Use Cases | Specifications | Data Objects |
|----------|-----------|----------------|--------------|
| `/metadata` | • Information on supported FHIR version & profiles for DiGA vendor<br> • Supported resources & operations<br>- Supported search parameters & filters | • No Mutual-TLS Client Authentication (public endpoint)<br>• **FHIR R4** (from context)<br>• Endpoint **MUST** be available to declare: supported FHIR version, resources, operations, search parameters, profiles | **FHIR CapabilityStatement**<br>Supported Profiles: <br> • Device, DeviceMetric, Observation<br><br>Resource Interactions:<br>• Device: read <br>• DeviceMetric: read <br> • Observation: read, search<br>
| `/Observation` |  • Query most recent measurement (single values)<br>• Query time series data for a patient<br> | • Allowed interactions: READ, SEARCH <br> • Data **MUST** conform to defined FHIR Profiles (e.g. [StructureDefinition-Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html))<br>• Single values: `valueQuantity`<br>• Time series: `valueSampledData`<br>• Reference to either Device or DeviceMetric **REQUIRED**<br>• Values must be fully normalized (`unit/system/code`)| **FHIR Observation**<br>Single value: `valueQuantity`<br>Time series: `valueSampledData`<br>**FHIR DeviceMetric** (via `device`)<br>**FHIR Device** (via `device`) | 
| `/Device` |• Query the configuration and properties of the device instance based on the last measurement or last measurement series.<br> • Query information about the stored device instance for device validation (e.g., serial number, type, manufacturer). <br> • Complements the query of Observation/DeviceMetric, since information about the underlying device is not always delivered directly with the measurement. | • Only allows FHIR READ interaction using the Device ID, retrieved from an Observation or DeviceMetric.<br>• Returns Device instances (e.g. glucometers)<br>• Identifier may include device registry number<br>• Referenced by either `DeviceMetric.source` or `Observation.device` (**REQUIRED**)<br>• Serial number required for validation<br>• Does **not** support `_include` or `?_id=`; use `/Device/{id}` to obtain a single resource. | **FHIR Device** <br> `Device.status` - is the device active <br> `Device.expirationDate` <br><br> The following properties are used for user verification and consent: <br> `Device.deviceName` <br> `Device.manufacturer` <br> `Device.serialNumber` | 
| `/DeviceMetric`| • Query the sensor type and the calibration status of the device for the last measurement or last measurement series. <br> • Reference to the specific device instance to maintain the link between measurement data and the physical sensor. | • Only allows FHIR READ interaction using the DeviceMetric ID retrieved from `/Observations`.<br>• Returns only the DeviceMetric referenced in the Observation, for data protection reasons.<br>• Does **not** support `_include` or `?_id=`; use `/DeviceMetric/{id}` to obtain a single resource. | **FHIR DeviceMetric**<br> <br> `calibration` - relevant for some devices (e.g. glucometer), where calibrating the device is needed <br> **FHIR Device** (via `source`)|

---

### Endpoints New

| | |
|-|-|
| **Endpoint** | `/metadata` |
| **HTTP Method** | GET |
| **Description** | Provides a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) with information about supported FHIR version, resource types, profiles, interactions, and search parameters. |
| **Authentication** | None (public endpoint) |
| **Returned Objects** | FHIR CapabilityStatement |
| **Specifications** | Must declare supported FHIR version, resources, operations, search parameters, and profiles. |
| **Error codes** | `500` (Internal Server Error) |

---

#### Observation

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET |
| **Interactions** | READ, SEARCH |
| **Description** | Query measurement data from the HiMi FHIR server **The description of this endpoint is MIV-specific, and varies between use cases.**.**The description of this endpoint is MIV-specific, and varies between use cases.**. |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `/Observation/<id>` (resource ID) |
| **Search Parameters** | Search parameters are MIV-specific. <br><br> The server MAY support search parameters, defined by the FHIR standard, see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • FHIR Observation<br><br>Optionally (via search interaction `_include`):<br> •DeviceMetric (via `device`)<br> •Device (via `device`) |
| **Specifications** | Returned resources must conform to the relevant FHIR profiles for the use-case. Values must be normalized (`unit/system/code`). |
| **Error codes** |•`400` OperationOutcome (Invalid query parameters / Invalid search parameters)<br>•`401` (Unauthorized)<br> •`403` OperationOutcome (Forbidden)<br>•`404` OperationOutcome (Not found)<br> •`500` (Internal Server Error) |

---

#### DeviceMetric

| | |
|-|-|
| **Endpoint** | `/DeviceMetric/{id}` |
| **HTTP Method** | GET |
| **Interactions** | READ|
| **Description** | Query the calibration status of the device for the last measurement or measurement series. Calibration status is required for the correct interpretation of the measurements. Reference the specific device instance, to maintain the link between measurement data and the physical sensor. Only returns the DeviceMetric, referenced by the Observation, for data protection reasons. |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `id` (DeviceMetric resource identifier) |
| **Returned Objects** | FHIR DeviceMetric (e.g., calibration status), Device (via `source`) |
| **Specifications** | Only supports read by resource ID. No search parameters. Returned resources must conform to the relevant FHIR profiles. |
| **Error codes** |•`400` OperationOutcome (Invalid query parameters / Invalid search parameters)<br>•`401` (Unauthorized)<br> •`403` OperationOutcome (Forbidden)<br>•`404` OperationOutcome (Not found)<br> •`500` (Internal Server Error) |

---

#### Device

| | |
|-|-|
| **Endpoint** | `/Device/{id}` |
| **HTTP Method** | GET |
| **Interactions** | READ|
| **Description** | Query the configuration and properties of the device instance, based on the last measurement or last measurement series. Query information about the stored device instance for device validation (e.g. serial number, type, manufacturer). Complements the query of Observation -> DeviceMetric, since information about the underlying device is not always delivered directly with the measurement. |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `id` (Device resource identifier) |
| **Returned Objects** | FHIR Device |
| **Specifications** | Only supports read by resource ID. No search parameters. Returned resources must conform to the relevant FHIR profiles. |
| **Error codes** |•`400` OperationOutcome (Invalid query parameters / Invalid search parameters)<br>•`401` (Unauthorized)<br> •`403` OperationOutcome (Forbidden)<br>•`404` OperationOutcome (Not found)<br> •`500` (Internal Server Error) |

---



### FHIR Operations

Obtaining data for some MIVs requires custom [FHIR opeartions](https://hl7.org/fhir/R4/operations.html) that **MUST** be supported by the API. They are definede in the individual **MIV-specific APIs**.

| MIV | Operation |
| - | - |
| [MIV: Interstitial Fluid Glucose](measurement-tissue-glucose.html) | `$cgm-summary-data-report` |


---


#### Examples

**Search Examples**

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

This section provides an overview of the FHIR profiles that the resources returned by this API must conform to. Listed are only profiles, that are relevant to the Generic API (Device, DeviceMetric). Observation profiles are listed in the individual **MIV-Specific APIs**.

For the complete definitions, refer to the [Artifacts](artifacts.html) page. 

#### Device
---

<div id="tabs-diff">
  <div id="tbl-diff">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['Device-Personal-Health-Device'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['Device-Personal-Health-Device'].basepath}}">
        {{site.data.structuredefinitions['Device-Personal-Health-Device'].basename}}
      </a>
    </p>
    <div id="tbl-diff-inner">
      {% include StructureDefinition-Device-Personal-Health-Device-diff.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-Device-Personal-Health-Device-tx-diff.xhtml %}

      {% capture invariantsdiff %}
        {% include StructureDefinition-Device-Personal-Health-Device-inv-diff.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantsdiff.size <= 218 %}
        <a name="inv-diff"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-Device-Personal-Health-Device-inv-diff.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>

#### DeviceMetric
---

<div id="tabs-diff">
  <div id="tbl-diff">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basepath}}">
        {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basename}}
      </a>
    </p>
    <div id="tbl-diff-inner">
      {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-diff.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-tx-diff.xhtml %}

      {% capture invariantsdiff %}
        {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-inv-diff.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantsdiff.size <= 218 %}
        <a name="inv-diff"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-inv-diff.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>