### Introduction

This document describes the syntax and semantics of querying FHIR Device resources via the standard FHIR RESTful API. Device resources represent individual Personal Health Devices (medical aids and implants) of a patient, such as glucometers, CGM sensors, and pace makers. The API supports 
- [reading](#device---read) individual Device resources that are referenced by Observations or DeviceMetrics, and
- [searching](#device---search) for Device resources linked with the current patient and an authorised MIV. 
Returned resources MUST conform to the _HDDT Personal Health Device_ [FHIR profile](#profile---hddt-personal-health-device]).

To be compliant with § 374a SGB V, a Device Data Recorder MUST implement these API endpoints for all supported kinds of Personal Health Devices as specified below.

### Endpoints

#### Device - READ

| | |
|-|-|
| **Endpoint** | `[base]/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Device resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned Device MUST conform to the _HDDT Personal Health Device_ profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/resource.html#id) apply. |
| **Request Parameters** | `id` - logical ID of the Device. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return a Device resources that is linked to the patient in the token and that is accessible by the requestor according to its scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Returned Objects** | HDDT Personal Health Device resource. If no matching resource exists or if the matching resource cannot be returend, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id of a Device resource are an `Observation.device' reference, a `DeviceMetric.source` reference or a 'search' interaction for Personal Health Devices of the given patient. <br>A DIGA MAY read a Device resource in order to validate the `status` of a Personal Health Device. E.g. a `status` value _unknown_ indicates that the Device Data Recorder has no connection to the device hardware, e.g. due to interrupted communication. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Device - SEARCH

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Device resources.  |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return Device resources that are linked to the patient in the token and that are accessible by the requestor according to its scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).<br>  |
| **Search Parameters** | The resource server MUST be able to discover the patient identifier from the Access Token. This identifier MUST implicitly be considered as the `subject` argument with every query _search_ request. If a DiGA explicitly provides a `subject` argument with a query, the resource server MUST ignore this argument and SHOULD respond with an `400 Bad Request` error.<br>The resource server MAY support additional standard FHIR Device search parameters. |
| **Returned Objects** | Bundle containing Device entries that match the query. <br>If no matching Device resources are found, an empty Bundle MUST be returned.  |
| **Specifications** | After successful [pairing](pairing.html) with a Device Data Recorder a DiGA SHOULD discover the Personal Health Devices of the patient by searching for Device resources. The DiGA MAY use search parameters to filter the results, e.g. by `manufacturer` or `deviceName`. The DiGA SHOULD persent the discovered `Device.serialNumber` to the patient to allow him to verify the result of the pairing process.<br>The resource server MAY support the `_include:definition` parameter to allow including referenced DeviceDefinition resources in the response bundle. <br> All constraints and obligations of the standard [FHIR `search` interaction](https://hl7.org/fhir/R4/http.html#search) apply.
 |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

### Profile - HDDT Personal Health Device

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

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-personal-health-device-dict-diff.xhtml%}
    </div>
</div>


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