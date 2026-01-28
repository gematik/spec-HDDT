This document describes the syntax and semantics of querying FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources via the standard FHIR RESTful API. A [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource represents a status instance of a medical aid or implant and MAY be referenced by a measurement. In the context of HDDT, a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) represents the [calibration status](retrieving-data.html#device-status-and-device-definition) of a medical aid or implant.

To be compliant with § 374a SGB V, a Device Data Recorder MUST implement the following interactions for reading and searching DeviceMetric resources:
- [reading](#devicemetric---read) individual [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources that are referenced by [Observation](mivs.html) resources.
- [version specific reading](#devicemetric---vread) individual [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources that are referenced by [Observation](mivs.html) resources. A Device Data Recorder MAY omit this interaction if it does not support versioning of [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of the calibration state of a sensor). 
- [searching](#devicemetric---search) for [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources linked with the current patient and an authorized MIV.

Returned resources MUST conform to the [_HDDT Sensor Type and Calibration Status_](#profile---hddt-sensor-type-and-calibration-status) DeviceMetric profile.

---

### Endpoints

#### DeviceMetric - READ

| | |
|-|-|
| **Endpoint** | `[base]/DeviceMetric/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned DeviceMetric MUST conform to the [_HDDT Sensor Type and Calibration Status_](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/http.html#read) apply. |
| **Request Parameters** | `id` - logical ID of the [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html). |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource that can be linked to the patient who is associated with the token. Provided [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource. If no matching resource exists or if the matching resource cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id of a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource are an `Observation.device` reference or a 'search' interaction for [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources of the given patient.<br>A DiGA SHOULD read a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource to validate the calibration status of a medical aid or implant. The calibration status is REQUIRED for correct interpretation of measurements. [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) MUST reference the [Device](StructureDefinition-hddt-personal-health-device.html) instance via `DeviceMetric.source`. |
| **Error codes** | • `400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>• `401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>• `403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>• `404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>• `500` (Internal Server Error—MAY be either an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) or plain text) |

---

#### DeviceMetric - VREAD

**Remark:** A Device Data Recorder MAY omit the version-specific read interaction if it does not support versioning of DeviceMetric resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of the calibration state of a sensor).

| | |
|-|-|
| **Endpoint** | `[base]/DeviceMetric/<id>/_history/<versionId>` |
| **HTTP Method** | GET |
| **Interaction** | VREAD |
| **Description** | Retrieve a single [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id) and [versionId](https://hl7.org/fhir/R4/resource.html#metadata). The returned DeviceMetric MUST conform to the [_HDDT Sensor Type and Calibration Status_](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. All constraints and obligations of the standard [FHIR `vread` interaction](https://hl7.org/fhir/R4/http.html#vread) apply. |
| **Request Parameters** | `id` - logical ID of the [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) <br>`versionId` - version identifier of the [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return versions of [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources that can be linked to the patient who is associated with the token. Provided [Device](StructureDefinition-hddt-personal-health-device.html) Metric resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource. If no matching resource or version exists or if the matching resource or version cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id and the versionId of a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource are an `Observation.device` reference or a 'search' interaction for [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources of the given patient. |
| **Error codes** | • `400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>• `401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>• `403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>• `404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>• `500` (Internal Server Error—MAY be either an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) or plain text) |

---

#### DeviceMetric - SEARCH

**Remark:** The FHIR specification allows searching for resources by various parameters. However, in the context of HDDT, the only relevant search parameter is the patient who is associated with the access token. Therefore, the search interaction is restricted to this parameter only.

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources by certain properties. |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources that can be linked to the patient who is associated with the token. Provided [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Search Parameters** | A full list of the search parameters that this endpoint MUST support can be found on page [FHIR Resource Server](himi-diga-api.html#search-parameters).<br>The resource server MAY support any additional standard FHIR DeviceMetric search parameters. A DiGA MAY, for example, use the `source` parameter to discover all DeviceMetric resources that belong to a given Personal Health Device instance. |
| **Returned Objects** | [Bundle](https://hl7.org/fhir/R4/bundle.html) containing [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) entries that match the query. Optionally, [Device](StructureDefinition-hddt-personal-health-device.html) entries when using `_include`. If no matching [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources are found, an empty [Bundle](https://hl7.org/fhir/R4/bundle.html) MUST be returned. |
| **Specifications** | All constraints and obligations of the standard [FHIR `search` interaction](https://hl7.org/fhir/R4/http.html#search) apply. |
| **Error codes** | • `400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>• `401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>• `403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>• `500` (Internal Server Error—MAY be either an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) or plain text) |

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

In this example, the patient uses a glucometer that is connected to the Device Data Recorder via Bluetooth. The glucometer performs blood glucose measurements that are stored as [Observation](mivs.html) resources in the Device Data Recorder. Each Observation references the [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource that holds the calibration state of the glucometer.

In the given example, the device measures the glucose concentration from capillary blood using test strips. The patient's preferred unit is mg/dl, which is used by the device for displaying measured values. The glucometer needs to be calibrated by the patient using control strips. The last calibration was performed in September 2025, and the glucometer is still calibrated.

**Remarks:**
- The `text` element is omitted in this example to keep it small. As all HDDT resources are intended for machine processing, the `text` element MAY be omitted.

#### DeviceMetric - READ

**Request:** GET `/DeviceMetric/example-glucometer-metric`

**Response:**
{% include DeviceMetric-example-glucometer-metric-json-html.xhtml %}

#### DeviceMetric - SEARCH

**Request:** GET `/DeviceMetric`

**Response:**
```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://example.com/fhir/DeviceMetric/example-glucometer-metric",
            "resource": {
                "resourceType": "DeviceMetric",
                "id": "example-glucometer-metric",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
                    ]
                },
                "type": {
                    "coding": [
                        {
                            "code": "160184",
                            "system": "urn:iso:std:iso:11073:10101",
                            "version": "20250520",
                            "display": "MDC_CONC_GLU_CAPILLARY_WHOLEBLOOD"
                        }
                    ]
                },
                "unit": {
                    "coding": [
                        {
                            "code": "mg/dL",
                            "system": "http://unitsofmeasure.org",
                            "display": "mg/dL"
                        }
                    ]
                },
                "source": {
                    "reference": "Device/example-glucometer"
                },
                "operationalStatus": "on",
                "category": "measurement",
                "calibration": [
                    {
                        "type": "gain",
                        "state": "calibrated",
                        "time": "2025-09-01T09:08:04+02:00"
                    }
                ]
            },
            "search": {
                "mode": "match"
            }
        }
    ]
}
```

### Example: rtCGM DeviceMetric

In this example, the patient uses a real-time continuous glucose monitor (rtCGM) that is connected to the Device Data Recorder via Bluetooth. The rtCGM continuously measures the glucose concentration in interstitial fluid, and the resulting data are stored as [Observation](mivs.html) resources in the Device Data Recorder. Each Observation references a DeviceMetric resource that represents the calibration status of the rtCGM.

The example device measures the glucose concentration from interstitial fluid with a frequency of one measurement every three minutes. The patient’s preferred unit is mg/dl. The device is calibrated by the manufacturer and does not require user calibration.

#### Instance of the HDDT Sensor Type and Calibration Status profile

```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://example.com/fhir/DeviceMetric/example-devicemetric-cgm",
            "resource": {
                "resourceType": "DeviceMetric",
                "id": "example-devicemetric-cgm",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
                    ]
                },
                "type": {
                    "coding": [
                        {
                            "code": "160212",
                            "system": "urn:iso:std:iso:11073:10101",
                            "version": "20250520",
                            "display": "MDC_CONC_GLU_ISF"
                        }
                    ]
                },
                "unit": {
                    "coding": [
                        {
                            "code": "mg/dL",
                            "system": "http://unitsofmeasure.org",
                            "display": "mg/dL"
                        }
                    ]
                },
                "source": {
                    "reference": "Device/example-device-cgm"
                },
                "operationalStatus": "on",
                "category": "measurement",
                "measurementPeriod": {
                    "repeat": {
                        "frequency": 1,
                        "period": 3,
                        "periodUnit": "min"
                    }
                },
                "calibration": [
                    {
                        "type": "unspecified",
                        "state": "calibrated"
                    }
                ]
            },
            "search": {
                "mode": "match"
            }
        }
    ]
}
```