# Experimental API: DeviceMetric Resource Access

### Introduction

This document describes the semantics of querying FHIR DeviceMetric resources via a RESTful API. DeviceMetric resources represent sensor type and calibration status for medical devices. The API supports retrieving individual DeviceMetric resources and searching for DeviceMetrics matching specific criteria (e.g., by type, source device, or calibration status). Returned resources must conform to the relevant FHIR profiles.

---

### Endpoints

#### DeviceMetric - READ

| | |
|-|-|
| **Endpoint** | `/DeviceMetric/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single DeviceMetric resource by its internal server ID. The returned DeviceMetric MUST conform to the Sensor Type and Calibration Status profile. |
| **Request Parameters** | `id` - Internal server ID of the DeviceMetric. |
| **Authentication** | OAuth2 Bearer token required |
| **Returned Objects** | • FHIR DeviceMetric |
| **Specifications** | • Returned resources must conform to the Sensor Type and Calibration Status profile.<br> • DeviceMetric should reference the Device instance via `source`.<br> • Calibration status is required for correct interpretation of measurements. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### DeviceMetric - SEARCH

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for DeviceMetric resources using parameters such as `type`, `source`, or calibration status. |
| **Authentication** | OAuth2 Bearer token required |
| **Search Parameters** | Commonly used: `type`, `source`, `_include`. Server MAY support standard FHIR DeviceMetric search parameters. |
| **Returned Objects** | • Bundle containing DeviceMetric entries. Optionally, Device entries when using `_include`. |
| **Specifications** | • Returned resources must conform to the Sensor Type and Calibration Status profile.<br> • DeviceMetric should reference Device via `source`. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

### Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basepath}}">
        {{site.data.structuredefinitions['DeviceMetric-Sensor-Type-and-Calibration-Status'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

---

### Examples

#### DeviceMetric - READ

**Request:** GET `/DeviceMetric/dm-123`

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

#### DeviceMetric - SEARCH

**Request:** GET `/DeviceMetric?type=15074-8`

**Response:**
```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "entry": [
    {
      "fullUrl": "https://example.com/fhir/DeviceMetric/dm-123",
      "resource": {
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
    }
  ]
}
```