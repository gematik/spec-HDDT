**To-Do**

### Introduction
This document describes the generic FHIR API for standardized access to medical device/implant data as FHIR resources for authorized DiGA. The endpoints for the medical aid API have both generic and use-case-specific components.

This document defines the generic API definition—the API specification that is shared among different types of medical aid backends. The use-case-specific specification can be found under the menu **MIV-Specific APIs**.

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |

---

### Read Interactions

Endpoints that are required to support the REST interaction "READ" **MUST** be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions **MUST** conform to the HDDT FHIR Profiles.

### Search Interactions

Endpoints that are required to support the "SEARCH" interactions **MUST** allow searching via HTTP GET. Endpoints **MAY** choose to support search requests via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).

### Authentication

The authentication mechanism is described in chapter [Pairing - Tokens and Token Response](pairing.html#tokens-and-the-token-response).

### Error Handling

The [Endpoints](#endpoints) section lists the expected HTTP error codes, the type of error, and likely reasons for the occurrence of the error.

**Considerations:**

- The server **MUST** return the defined HTTP error codes when the listed reason occurs.
- The server **MUST** return a FHIR-[OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) resource if `[OperationOutcome]` is specified as the error type by the OpenAPI description.
- The server **SHOULD** provide a reason for the error, but the concrete contents of the [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) are not specified. The server can choose to use a code in `ObservationOutcome.issue.details`, or use the free text input in `ObservationOutcome.issue.diagnostics`. This means that using the default error messages of your FHIR server implementations is likely supported.

### Auditing

The server should create and store audit logs, as defined by chapter [Security and Privacy](security-and-privacy.html).

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to request only resources matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code.

The endpoint specification lists the most important search parameters for the generic API and for individual MIV-Specific APIs.

For each resource type, all standard FHIR search parameters MAY be supported. See [FHIR Search](https://www.hl7.org/fhir/R4/search.html).

### Content-type
  - The server **MUST** support headers `Content-type` and `Accept`.
  - The server **MUST** support interpreting content types `application/fhir+json` and `application/fhir+xml`.
  - The server **MUST** return the response in the format that was requested (via the `Accept` header) from the client application.

### Endpoints

| | |
|-|-|
| **Endpoint** | `/metadata` |
| **HTTP Method** | GET |
| **Description** | Provides a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) with information about supported FHIR version, resource types, profiles, interactions, search parameters, and filters. |
| **Authentication** | None (public endpoint, no mTLS client authentication) |
| **Returned Objects** | FHIR CapabilityStatement |
| **Specifications** | • FHIR version **MUST** be R4 <br>• Must declare supported FHIR version, resources, operations, search parameters, and profiles. <br> • Supported FHIR Resource types: Device, DeviceMetric, Observation. |
| **Error codes** | `500` (Internal Server Error) |

---

#### Observation

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET |
| **Interactions** | READ, SEARCH |
| **Description** | • Query measurement data from the HiMi FHIR server, such as the most recent measurement, measurements within a certain time range, measurements of a certain type / LOINC code. <br> • **The description of this endpoint is MIV-specific and varies between use cases.** |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `/Observation/<id>` (resource ID) |
| **Search Parameters** | Search parameters are MIV-specific. Commonly used ones are `code`, `date`, `_include`. See individual use cases for specific search parameters. <br><br> The server MAY support search parameters defined by the FHIR standard; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • FHIR Observation<br><br>Optionally (via search interaction `_include`):<br> •DeviceMetric (via `device`)<br> •Device (via `device`) |
| **Specifications** | • Returned resources must conform to the relevant FHIR profiles for the use case (e.g., [SD-Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html)).<br> • Values must be normalized (`unit/system/code`).<br> • For single measurements use `valueQuantity`; for time series use `valueSampledData`.<br> • Reference via `device` is required for the correct interpretation of data or for accessing the configuration of the device instance. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### DeviceMetric

| | |
|-|-|
| **Endpoint** | `/DeviceMetric/{id}` |
| **HTTP Method** | GET |
| **Interactions** | READ, SEARCH |
| **Description** | Query the calibration status of the device for the last measurement or measurement series. Calibration status is required for the correct interpretation of the measurements. Reference the specific device instance to maintain the link between measurement data and the physical sensor. Only returns the DeviceMetric referenced by the Observation, for data protection reasons. |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `id` (DeviceMetric resource identifier) |
| **Search Parameters** | Commonly used search parameters are `type`, `source`, `_include`. <br><br> The server MAY support search parameters defined by the FHIR standard; see [FHIR DeviceMetric - Search Parameters](https://hl7.org/fhir/R4/devicemetric.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | FHIR DeviceMetric (e.g., calibration status), Device (via `source`) |
| **Specifications** | • Returned DeviceMetric resources must conform to the [Sensor Type and Calibration Status](StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status.html) FHIR profile. <br> • Referenced by `Observation.device` in some use-case-specific contexts. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Device

| | |
|-|-|
| **Endpoint** | `/Device/{id}` |
| **HTTP Method** | GET |
| **Interactions** | READ, SEARCH |
| **Description** | • Request and display the serial number to enable the insured person to verify that the measuring device collecting health data is correctly paired (patient security). <br> • Query the configuration and properties of the device instance, based on the last measurement or last measurement series. <br> • Complements the query of Observation -> DeviceMetric, since information about the underlying device is not always delivered directly with the measurement. |
| **Authentication** | OAuth2 Bearer token required |
| **Request Parameters** | `id` (Device resource identifier) |
| **Search Parameters** | Commonly used search parameters are `device-name`, `type`,  `manufacturer`. <br><br> The server MAY support search parameters defined by the FHIR standard; see [FHIR Device - Search Parameters](https://hl7.org/fhir/R4/device.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | FHIR Device |
| **Specifications** | • Returned resources must conform to the [Personal Health Device](StructureDefinition-Device-Personal-Health-Device.html) FHIR profiles. <br> • May include the registry number from the Medical Aid Registry as an `identifier`. <br> • Referenced by either `Observation.device` or `DeviceMetric.source`. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

### FHIR Operations

Obtaining data for some MIVs requires custom [FHIR operations](https://hl7.org/fhir/R4/operations.html) that **MUST** be supported by the API. They are defined in the individual **MIV-specific APIs**.

| MIV | Operation |
| - | - |
| [MIV: Interstitial Fluid Glucose](measurement-tissue-glucose.html) | `$cgm-summary-data-report` |

---

### Profiles

This section provides an overview of the FHIR profiles that the resources returned by this API must conform to. Listed are only profiles that are relevant to the Generic API (Device, DeviceMetric). Observation profiles are listed in the individual **MIV-Specific APIs**.

For the complete definitions, refer to the [Artifacts](artifacts.html) page. 

#### Device
---

<div id="tabs-snap">
  <div id="tbl-snap">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['Device-Personal-Health-Device'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['Device-Personal-Health-Device'].basepath}}">
        {{site.data.structuredefinitions['Device-Personal-Health-Device'].basename}}
      </a>
    </p>
    <div id="tbl-snap-inner">
      {% include StructureDefinition-Device-Personal-Health-Device-snapshot.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-Device-Personal-Health-Device-tx.xhtml %}

      {% capture invariantssnap %}
        {% include StructureDefinition-Device-Personal-Health-Device-inv.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantssnap.size <= 218 %}
        <a name="inv-snap"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-Device-Personal-Health-Device-inv.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>

#### DeviceMetric
---

<div id="tabs-snap">
  <div id="tbl-snap">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basepath}}">
        {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basename}}
      </a>
    </p>
    <div id="tbl-snap-inner">
      {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-snapshot.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-tx.xhtml %}

      {% capture invariantssnap %}
        {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-inv.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantssnap.size <= 218 %}
        <a name="inv-snap"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-inv.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>

### Examples

#### Search Examples

Please note that the examples below do not encompass all of the expected search functionality.

| Request | Explanation |
|---------|-------------|
| **GET** `/Observation?_id=1234` | Request a specific Observation resource, based on its internal id. Result is a Bundle containing a single Observation. |
| **GET** `/Observation/1234` | Returns a single Observation resource, based on its internal id. |
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23rd of July that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources referenced by the observations.  |
|**GET** `/Observation?_include=Observation:device&_include:iterate=DeviceMetric:source`| In the resulting Bundle include both DeviceMetric and Device, even if the Device has been referenced only via `DeviceMetric.source`.  |
| **GET** `/Observation?_sort=-date&_count=1` | Get the latest observation. |
| **GET** `/DeviceMetric/123` | Request a specific DeviceMetric resource, based on its internal id. This is a FHIR read interaction and does not allow parameters such as `_include`. |

---

#### Request Capability Statement

**Request:** `GET /metadata`

**Description:** Request the CapabilityStatement of the server, which provides information about the supported functionality of the server.

**Response:**

```json
{
  "resourceType": "CapabilityStatement",
  "status": "active",
  "fhirVersion": "4.0.1",
  "format": [
    "json",
    "xml"
  ],
  "rest": [
    {
      "mode": "server",
      "resource": [
        {
          "type": "Device",
          "profile": "Device_Medical_Aid",
          "interaction": [
            {
              "code": "read"
            },
            {
              "code": "search-type"
            }
          ]
        },
        {
          "type": "Observation",
          "profile": "Observation_Blood_Glucose",
          "interaction": [
            {
              "code": "read"
            },
            {
              "code": "search-type"
            }
          ]
        },
        {
          "type": "Observation",
          "profile": "Observation_CGM_Measurement_Series",
          "interaction": [
            {
              "code": "read"
            },
            {
              "code": "search-type"
            }
          ]
        },
        {
          "type": "Bundle",
          "profile": "BundleSearchSummaryDataMeasurements",
          "interaction": [
            {
              "code": "read"
            },
            {
              "code": "search-type"
            }
          ]
        }
      ]
    }
  ]
}
```

### Request DeviceMetric

**Request:** `GET /DeviceMetric/dm-123`

**Description:** Perform a FHIR-read interaction, requesting a specific DeviceMetric resource. The request parameter is the internal server ID of the DeviceMetric. The ID can be obtained from an Observation resource (via `Observation.device`).

**Response:** 

```json
{
  "resourceType": "DeviceMetric",
  "id": "dm-123",
  "type": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "15074-8",
        "display": "Blood glucose measurement"
      }
    ]
  },
  "calibration": {
    "state": "calibrated"
  },
  "source": {
    "reference": "Device/dev-123"
  }
}
```

### Request Device

**Request:** `GET /Device/dev-123`

**Description:** Perform a FHIR read interaction, requesting a specific Device resource instance, using its internal server ID. The ID can be obtained from a DeviceMetric resource (via `DeviceMetric.source`), or from an Observation resource (via `Observation.device`).

**Response:**

```json
{
  "resourceType": "Device",
  "id": "dev-123",
  "serialNumber": "SN123456",
  "type": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "46702002",
        "display": "Glucometer"
      }
    ]
  },
  "deviceName": [
    {
      "name": "Accu-Chek Mobile",
      "type": "user-friendly-name"
    }
  ],
  "manufacturer": "Acme Health",
  "definition": {
    "reference": "DeviceDefinition/example-glucometer-def"
  }
}
```

### Error 404 - OperationOutcome

**Request:** `GET /Device/777`

**Description:** When requesting a resource that does not exist (or the client does not have access to view it), the server returns status code `404` and a FHIR OperationOutcome. The example is the default OperationOutcome for `404 NOT FOUND` errors from a HAPI FHIR server.

**Response:**

`404 NOT FOUND`

```json
{
    "resourceType": "OperationOutcome",
    "issue": [
        {
            "severity": "error",
            "code": "processing",
            "diagnostics": "HAPI-2001: Resource Device/777 is not known"
        }
    ]
}
```