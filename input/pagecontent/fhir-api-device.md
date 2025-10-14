This document describes the syntax and semantics of querying FHIR Device resources via the standard FHIR RESTful API. Device resources represent individual Personal Health Devices (medical aids and implants) of a patient, such as glucometers, CGM sensors, and pace makers. 

To be compliant with § 374a SGB V, a Device Data Recorder MUST implement interactions for reading and searching Device resources:
- [reading](#device---read) individual Device resources that are referenced by Observation or DeviceMetric resources,
- [version specific reading](#device---vread) individual Device resources that are referenced by Observation or DeviceMetric resources. This interaction MAY be omitted by a Device Data Recorder if it does not support versioning of Device resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to implement versioning of Device resources). 
- [searching](#device---search) for Device resources linked with the current patient and an authorised MIV

Returned resources MUST conform to the [_HDDT Personal Health Device_](#profile---hddt-personal-health-device) Device profile.

### Endpoints

#### Device - READ

| | |
|-|-|
| **Endpoint** | `[base]/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Device resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned Device MUST conform to the _HDDT Personal Health Device_ profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/resource.html#id) apply. |
| **Request Parameters** | `id` - logical ID of the Device. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return a Device resource that is linked to the patient who is associated with the token. Provided Device resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Returned Objects** | HDDT Personal Health Device resource. If no matching resource exists or if the matching resource cannot be returend, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical `id` of a Device resource are an `Observation.device` reference, a `DeviceMetric.source` reference or a _search_ interaction for Personal Health Devices of the given patient. <br>A DIGA MAY read a Device resource in order to validate the `status` of a Personal Health Device. E.g. a `status` value _unknown_ indicates that the Device Data Recorder has no connection to the device hardware, e.g. due to interrupted communication. <br>A Device Data Recorder MUST NOT disclose information to a DiGA that allows the DiGA to identify the patient as a natural person. Respective guidance on the use of the `Device.patient` element is given in the [Security and Privacy](security-and-privacy.html#identification-and-authentication-of-the-patient) chaper of this specification. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Device - VREAD

__Remark:__ A Device Data Recorder MAY omit the version specific read interaction if it does not support versioning of Device resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of device properties).

| | |
|-|-|
| **Endpoint** | `[base]/Device/<id>/_history/<versionId>` |
| **HTTP Method** | GET |
| **Interaction** | VREAD |
| **Description** | Retrieve a single Device resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id) and [versionId](https://hl7.org/fhir/R4/resource.html#metadata). The returned Device resource MUST conform to the _HDDT Personal Health Device_ profile. All constraints and obligations of the standard [FHIR `vread` interaction](https://hl7.org/fhir/R4/http.html#vread) apply. |
| **Request Parameters** | `id` - logical ID of the Device resource <br>`versionId` - version identifier of the Device resource |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return versions of Device resources that can be linked to the patient who is associated with the token. Provided Device resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | _HDDT Personal Health Device_ resource. If no matching resource or version exists or if the matching resource or version cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id and the versionId of a Device resource are an `Observation.device` reference, a `DeviceMetric.source` reference, or a 'search' interaction for Device resources of the given patient. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Device - SEARCH

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Device resources.  |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return Device resources that are linked to the patient who is associated with the token. Provided Device resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).<br>  |
| **Search Parameters** | The resource server MUST be able to discover the patient identifier from the Access Token. This identifier MUST implicitly be considered as the `patient` argument with every _search_ request for Device resources. If a DiGA explicitly provides a `patient` argument with a query, the resource server MUST ignore this argument and SHOULD respond with an `400 Bad Request` error.<br>The resource server MAY support any standard FHIR Device search parameters. |
| **Returned Objects** | Bundle containing Device entries that match the query. <br>If no matching Device resources are found, an empty Bundle MUST be returned.  |
| **Specifications** | After successful [pairing](pairing.html) with a Device Data Recorder a DiGA SHOULD discover the Personal Health Devices of the patient by searching for Device resources. The DiGA MAY use search parameters to filter the results, e.g. by `device-name` or `type`. The DiGA SHOULD present the discovered `Device.serialNumber` to the patient to allow him to verify the result of the pairing process.<br>The resource server MAY support the `_include:definition` parameter to allow including referenced DeviceDefinition resources in the response bundle. <br> All constraints and obligations of the standard [FHIR `search` interaction](https://hl7.org/fhir/R4/http.html#search) apply.
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


### Example: Glucometer 

In this example the patient uses a glucometer that is connected to the Device Data Recorder via Bluetooth. The glucometer is used to perform blood glucose measurements that are stored as Observation resources in the Device Data Recorder. Each Observation references the Device resource that represents the glucometer (either directly or through a DeviceMetric resource).

The glucometer used in this example is the product _GlukkCheck plus mg/dl_ from _Glukko Inc._. The glucometer performs “bloody” measurements from capillary blood. The vendor-defined model number of this typeof devices is CGPA987654 and the serial number of the patient’s individual device is SN123456. Both identifiers are printed on the back of the device and allow the patient to validate the authenticity of this Personal Health Device resource.

Remarks:
- As glucometers do not expire (that is just the case for the test stripes), the `expirationDate` is not set, even though this element is set to _Must Support_ in the profile.
- The `text` element is omitted in this example to keep the example small. Nevertheless, as all HDDT resources are intended for sole machine processing, the `text` element MAY be omitted.

#### Device - READ

**Request:** GET `/Device/dev-123`

**Response:**
```json
{
  "resourceType" : "Device",
  "id" : "dev-123",
  "definition" : {
    "reference" : "devdef-456"
  },
  "status" : "active",
  "manufacturer" : "Glukko Inc.",
  "serialNumber" : "SN123456",
  "deviceName" : [
    {
      "name" : "GlukkoCheck plus mg/dl",
      "type" : "user-friendly-name"
    }
  ],
  "modelNumber" : "CGPA987654",
  "type" : {
    "coding" : [
      {
        "system" : "urn:iso:std:iso:11073:10101",
        "code" : "528401",
        "display" : "Glucose Monitor"
      }
    ]
  }
}
```

#### Device - SEARCH

**Request:** GET `/Device`

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
        "definition": {
          "reference": "devdef-456"
        },
        "status": "active",
        "manufacturer" : "Glukko Inc.",
        "serialNumber" : "SN123456",
        "deviceName" : [
          {
            "name" : "GlukkoCheck plus mg/dl",
            "type" : "user-friendly-name"
          }
        ],
        "modelNumber" : "CGPA987654",
        "type" : {
          "coding" : [
            {
              "system" : "urn:iso:std:iso:11073:10101",
              "code" : "528401",
              "display" : "Glucose Monitor"
            }
          ]
        }
      }
    }
  ]
}
```

### Example: rtCGM Sensor

This example describes a real-time Continuous Glucose Monitoring sensor (rtCGM) as a personal health device.

The example sensor is the product _GlukkoCGM 18_ from _Glukko Inc._ that performs continuous glucose measurements from interstitial fluid. The sensor in the example will stop transmitting data on September 10, 2025, and must be replaced by the patient at that date. The vendor-defined model number of this type of devices is _GCGMA98765_ and the serial number of the patient's  individual device is _CGM1234567890_. Both identifiers are printed on the package of the device and allow the patient to validate the authenticity of this Personal Health Device resource.

Remarks:
- The `text` element is omitted in this example to keep the example small. Nevertheless, as all HDDT resources are intended for sole machine processing, the `text` element MAY be omitted.

#### Instance of the HDDT Personal Health Device profile

```json
{
  "resourceType" : "Device",
  "id" : "example-device-cgm",
  "definition" : {
    "reference" : "DeviceDefinition/device-definition-cgm-001"
  },
  "status" : "active",
  "manufacturer" : "Glukko Inc.",
  "expirationDate" : "2025-09-10",
  "serialNumber" : "CGM1234567890",
  "deviceName" : [
    {
      "name" : "GlukkoCGM 18",
      "type" : "user-friendly-name"
    }
  ],
  "modelNumber" : "GCGMA98765",
  "type" : {
    "coding" : [
      {
        "system" : "urn:iso:std:iso:11073:10101",
        "code" : "528409",
        "display" : "Continuous Glucose Monitor"
      }
    ]
  }
}
```

