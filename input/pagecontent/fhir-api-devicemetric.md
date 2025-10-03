This document describes the syntax and semantics of querying FHIR DeviceMetric resources via the standard FHIR RESTful API. A DeviceMetric resource represents a status instance of a medical aid or implant, and MAY be referenced by a measurement. In the context of HDDT, a DeviceMetric represents the [calibration status](retrieving-data.html#device-status-and-device-configuration) of a medical aid or implant.

To be compliant with § 374a SGB V, a Device Data Recorder MUST implement interactions for reading and searching DeviceMetric-resources:
- [reading](#devicemetric---read) individual DeviceMetric resources that are referenced by Observations
- [version specific reading](#devicemetric---vread) individual DeviceMetric resources that are referenced by Observations. This interaction MAY be omitted by a Device Data Recorder if it does not support versioning of DeviceMetrc resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of the calibration state of a sensor). 
- [searching](#devicemetric---search) for DeviceMetric resources linked with the current patient and an authorised MIV

Returned resources MUST conform to the [_HDDT Sensor Type and Calibration Status_](#profile---hddt-sensor-type-and-calibration-status]) DeviceMetric profile.


---

### Endpoints

#### DeviceMetric - READ

| | |
|-|-|
| **Endpoint** | `[base]/DeviceMetric/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single DeviceMetric resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned DeviceMetric MUST conform to the _HDDT Sensor Type and Calibration Status_ profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/http.html#read) apply. |
| **Request Parameters** | `id` - logical ID of the DeviceMetric. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return a DeviceMetric resource that can be linked to the patient who is associated with the token. Provided Device Metric resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | HDDT Sensor Type and Calibration Status resource. If no matching resource exists or if the matching resource cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id of a DeviceMetric resource are an `Observation.device` reference, or a 'search' interaction for DeviceMetric resources of the given patient.<br>A DiGA SHOULD read a DeviceMetric resource in order to validate the calibration status of a medical aid or implant. The calibration status is required for correct interpretation of measurements. DeviceMetric MUST reference the Device instance via `DeviceMetric.source`. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### DeviceMetric - VREAD

__Remark:__ A Device Data Recorder MAY omit the version specific read interaction if it does not support versioning of DeviceMetric resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of the calibration state of a sensor).

| | |
|-|-|
| **Endpoint** | `[base]/DeviceMetric/<id>/_history/<versionId>` |
| **HTTP Method** | GET |
| **Interaction** | VREAD |
| **Description** | Retrieve a single DeviceMetric resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id) and [versionId](https://hl7.org/fhir/R4/resource.html#metadata). The returned DeviceMetric MUST conform to the _HDDT Sensor Type and Calibration Status_ profile. All constraints and obligations of the standard [FHIR `vread` interaction](https://hl7.org/fhir/R4/http.html#vread) apply. |
| **Request Parameters** | `id` - logical ID of the DeviceMetric <br>`versionId` - version identifier of the DeviceMetric |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return versions of DeviceMetric resources that can be linked to the patient who is associated with the token. Provided Device Metric resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | HDDT Sensor Type and Calibration Status resource. If no matching resource or version exists or if the matching resource or version cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id and the versionId of a DeviceMetric resource are an `Observation.device` reference, or a 'search' interaction for DeviceMetric resources of the given patient. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### DeviceMetric - SEARCH

__Remark:__ The FHIR specification allows searching for resources by various parameters. However, in the context of HDDT, the only relevant search parameter is the patient who is associated with the access token. Therefore, the search interaction is restricted to this parameter only.

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for DeviceMetric resources by certain properties. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return DeviceMetric resources that can be linked to the patient who is associated with the token. Provided DeviceMetric resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Search Parameters** | The resource server MAY support any standard FHIR DeviceMetric search parameters. A DiGA MAY e.g. use the `source` parameter to discover all DeviceMetric resources that belong to a given Personal Health Device instance.  |
| **Returned Objects** | Bundle containing DeviceMetric entries that match the query. Optionally, Device entries when using `_include`. If no matching DeviceMetric resources are found, an empty Bundle MUST be returned. |
| **Specifications** | All constraints and obligations of the standard [FHIR `search` interaction](https://hl7.org/fhir/R4/http.html#search) apply. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

### Profile - HDDT Sensor Type and Calibration Status

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-sensor-type-and-calibration-status'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-sensor-type-and-calibration-status'].basepath}}">
        {{site.data.structuredefinitions['hddt-sensor-type-and-calibration-status'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-sensor-type-and-calibration-status-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

---

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {% include StructureDefinition-hddt-sensor-type-and-calibration-status-dict-diff.xhtml %}
    </div>
</div>

### Example: Glucometer DeviceMetric

In this example the patient uses a glucometer that is connected to the Device Data Recorder via Bluetooth. The glucometer is used to perform blood glucose measurements that are stored as Observation resources in the Device Data Recorder. Each Observation references the DeviceMetric resource that holds the calibration state of the glucometer.

In the given example the device measures the glucose concentration from capillary blood by using test strips. The patient’s preferred unit is mg/dl which is used by the device for displaying measured values. The glucometer needs to be calibrated by the patient using control strips. The last calibration was performed in Septemer 2025 and the glucometer is still calibrated.

Remarks:
- The `text` element is omitted in this example to keep the example small. Nevertheless, as all HDDT resources are intended for sole machine processing, the `text` element MAY be omitted.


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
        "system": "urn:iso:std:iso:11073:10101",
        "code": "29112",
        "display": "MDC_CONC_GLU_CAPILLARY_WHOLEBLOOD"
      }
    ]
  },
  "unit" : {
    "coding" : [
      {
        "system" : "http://unitsofmeasure.org",
        "code" : "mg/dL",
        "display" : "milligram per deciliter"
      }
    ]
  },
  "source": {
    "reference": "Device/dev-123"
  },
  "operationalStatus" : "on",
  "category" : "measurement",  
  "calibration": {
    "type": "gain",
    "state": "calibrated",
    "time" : "2025-09-01T09:08:04+02:00"
  }
}
```

#### DeviceMetric - SEARCH

**Request:** GET `/DeviceMetric`

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
              "system": "urn:iso:std:iso:11073:10101",
              "code": "29112",
              "display": "MDC_CONC_GLU_CAPILLARY_WHOLEBLOOD"
            }
          ]
        },
        "unit" : {
          "coding" : [
            {
              "system" : "http://unitsofmeasure.org",
              "code" : "mg/dL",
              "display" : "milligram per deciliter"
            }
          ]
        },
        "source": {
          "reference": "Device/dev-123"
        },
        "operationalStatus" : "on",
        "category" : "measurement",  
        "calibration": {
          "type": "gain",
          "state": "calibrated",
          "time" : "2025-09-01T09:08:04+02:00"
        }
      }
    }
  ]
}
```

### Example: rtCGM DeviceMetric

In this example the patient uses a real-time continuous glucose monitor (rtCGM) that is connected to the Device Data Recorder via Bluetooth. The rtCGM is used to perform continuous blood glucose measurements that are stored as Observation resources in the Device Data Recorder. Each Observation references the DeviceMetric resource that holds the calibration state of the rtCGM.

The example device measures the glucose concentration from interstitial fluid with a frequency of one measurement every three minutes. The patient’s preferred unit is mg/dl. The device is calibrated by the manufacturer and does not require user calibration.

#### Instance of the HDDT Sensor Type and Calibration Status profile

```json
{
  "resourceType" : "DeviceMetric",
  "id" : "example-devicemetric-cgm",
  "type" : {
    "coding" : [
      {
        "system" : "urn:iso:std:iso:11073:10101",
        "code" : "29140",
        "display" : "MDC_CONC_GLU_ISF"
      }
    ]
  },
  "unit" : {
    "coding" : [
      {
        "system" : "http://unitsofmeasure.org",
        "code" : "mg/dL",
        "display" : "milligram per deciliter"
      }
    ]
  },
  "source" : {
    🔗 "reference" : "Device/example-device-cgm"
  },
  "operationalStatus" : "on",
  "category" : "measurement",
  "measurementPeriod" : {
    "repeat" : {
      "frequency" : 1,
      "period" : 1,
      "periodUnit" : "min"
    }
  },
  "calibration" : [
    {
      "type" : "unspecified",
      "state" : "calibrated"
    }
  ]
}
```