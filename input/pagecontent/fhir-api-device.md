### Introduction

This document describes the semantics of querying FHIR Device resources via a RESTful API. Device resources represent individual medical devices or personal health devices, such as glucometers or CGM sensors. The API supports retrieving individual Device resources and searching for Devices matching specific criteria (e.g., by manufacturer, type, or serial number). Returned resources must conform to the relevant FHIR profiles.

---

### Endpoints

#### Device - READ

| | |
|-|-|
| **Endpoint** | `/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Device resource by its internal server ID. The returned Device MUST conform to the Personal Health Device profile. |
| **Request Parameters** | `id` - Internal server ID of the Device. |
| **Authentication** | OAuth2 Bearer token required |
| **Returned Objects** | • FHIR Device |
| **Specifications** | • Returned resources must conform to the Personal Health Device profile.<br> • Device instance should provide manufacturer, serial number, device type, and configuration.<br> • Device ID is usually obtained from Observation.device or DeviceMetric.source. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Device - SEARCH

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Device resources using parameters such as `deviceName`, `manufacturer`, or type. |
| **Authentication** | OAuth2 Bearer token required |
| **Search Parameters** | Commonly used: `deviceName`, `manufacturer`, `_include`. Server MAY support standard FHIR Device search parameters. |
| **Returned Objects** | • Bundle containing Device entries |
| **Specifications** | • Returned resources must conform to the Personal Health Device profile.<br> • May include registry number as an identifier.<br> • Referenced by Observation.device or DeviceMetric.source. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

### Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-personal-health-device'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-personal-health-device'].basepath}}">
        {{site.data.structuredefinitions['hddt-personal-health-device'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-personal-health-device-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

---

### Examples

#### Device - READ

**Request:** GET `/Device/dev-123`

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

#### Device - SEARCH

**Request:** GET `/Device?manufacturer=Acme Health`

**Response:**
```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "entry": [
    {
      "fullUrl": "https://example.com/fhir/Device/dev-123",
      "resource": {
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
        "manufacturer": "Acme Health"
      }
    }
  ]
}
```