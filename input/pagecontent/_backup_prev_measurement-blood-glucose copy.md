**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

### Introduction

This document provides implementation guidance for manufacturers integrating glucometer data using a RESTful FHIR API. It builds on the [Generic FHIR API](himi-diga-api.html) and describes the specific requirements for exposing blood glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html), including any required FHIR operations.
- The relevant FHIR profiles for blood glucose measurement and how they should be returned by the API.
- Conventions for using FHIR resources to ensure compliance with the [Information model](information-model.html).
- Example requests and responses to support implementation.

### Endpoints

The server MUST support the following endpoints.

**FHIR Interactions**: The specified FHIR interactions are the same as in [Generic HiMi FHIR API](himi-diga-api.html).

**Authentication**: The authentication and authorization requirements for these endpoints are the same as the [Generic HiMi FHIR API](himi-diga-api.html).

#### Metadata

| | |
|-|-|
| **Endpoint** | `/metadata` |
|**Description** | Provide a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) that contains information about the supported endpoints, resource interactions, and search parameters. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---


#### Observation - READ

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single blood glucose Observation by its internal server ID. Such scenario is unlikely to occur, but MUST be supported. <br> The returned Observation MUST conform to the hddt-blood-glucose-measurement profile. Subsequent request can be made on the `/Device` or `/DeviceMetric` endpoints, to resolve the reference in `Observation.device`, and obtain the device calibration status or configuration. |
| **Request Parameters** | `id` - Referring to the internal server ID of the Observation. |
| **Returned Objects** | • [hddt-blood-glucose-measurement](StructureDefinition-hddt-blood-glucose-measurement.html) |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

---

#### Observation - SEARCH

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET |
| **Interaction** | SEARCH |
| **Description** | Search for blood glucose Observations. Common use cases include retrieving the latest observation, retrieving only observations that measure blood glucose in mg/dL, and retrieving all measurements across a certain date range. <br>Requests with the search parameter `_include=Observation:device` can be used to return DeviceMetric and Device resources referenced by `Observation.device` in the same Bundle. |
| **Search Parameters** | Parameters that MUST be supported are:<br> • `code` - Search for Observations of a specific type<br> • `date` - Specify a date range <br> • `_include` - Optionally include DeviceMetric and Device resources, referenced by `Observation.device`. <br><br> The server MAY support other search parameters; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • Bundle containing [hddt-blood-glucose-measurement](StructureDefinition-hddt-blood-glucose-measurement.html) entries and optionally [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) and [Device - Personal Health Device](StructureDefinition-hddt-personal-health-device.html) when requested via `_include`. |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

---

#### DeviceMetric - READ

| | |
|-|-|
| **Endpoint** | `/DeviceMetric/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single DeviceMetric instance (sensor type and calibration status) by its internal ID. Use this endpoint to obtain the calibration state required for correct interpretation of measurement values. The ID can be obtained via `Observation.device` from previous requests on the `/Observation` endpoint. |
| **Request Parameters** | `/DeviceMetric/<id>` - Referring to the internal server ID of the DeviceMetric. |
| **Returned Objects** | • [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### DeviceMetric - SEARCH

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET |
| **Interaction** | SEARCH |
| **Description** | Search for DeviceMetric resources, for example to query calibration status across devices or time ranges. Returned DeviceMetric resources should reference the Device instance via `source` to maintain the link between the measurement data and the physical sensor. |
| **Search Parameters** | Commonly used search parameters are `type`, `source`, and `_include`. <br> The server MAY support standard DeviceMetric search parameters. See [FHIR DeviceMetric - Search Parameters](https://hl7.org/fhir/R4/devicemetric.html#search) for details. |
| **Returned Objects** | • Bundle containing [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) entries. Optionally, additional [Device - Personal Health Device](StructureDefinition-hddt-personal-health-device.html) entries when using `_include`. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Device - READ

| | |
|-|-|
| **Endpoint** | `/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Device instance by its internal ID. Use this to obtain configuration and properties of the device instance (e.g., serial number, manufacturer, device type) needed for device validation. Device ID is usually obtained from previous requests, either via `Observation.device`, or `DeviceMetric.source`. |
| **Request Parameters** | `/Device/<id>` - Referring to the internal server ID of the Device. |
| **Returned Objects** | • [Device - Personal Health Device](StructureDefinition-hddt-personal-health-device.html) |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Device - SEARCH

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET |
| **Interaction** | SEARCH |
| **Description** | Search for Device instances, for example to list devices by manufacturer, type, or serial number.  |
| **Search Parameters** | Commonly used search parameters are `deviceName`, `manufacturer`, and `_include`. <br> The server MAY support standard Device search parameters. See [FHIR Device - Search Parameters](https://hl7.org/fhir/R4/device.html#search) for details. |
| **Returned Objects** | • Bundle containing [Devic - Personal Health Device](StructureDefinition-hddt-personal-health-device.html) entries |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

### MIV-Specific Observation Profile

#### Instantiation of the HDDT Information Model

<figure>
<div class="gem-ig-svg-container" style="width: 60%;">
  {% include HDDT_Objektmodell_BZ_Complete.svg %}
  <figcaption>HDDT Object Model Example (Blood Glucose Measurement)</figcaption>
  </div>
</figure>



#### Structure Definition

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-blood-glucose-measurement'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-blood-glucose-measurement'].basepath}}">
        {{site.data.structuredefinitions['hddt-blood-glucose-measurement'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-blood-glucose-measurement-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<!-- Constraints and terminology bindings view removed. Refer to the canonical StructureDefinition for full snapshot, constraints and terminology bindings. -->

#### Conventions and Best Practice

- Always use the latest version of the Observation profile.
- Only `valueQuantity` is permitted as the result of the Observation for blood glucose measurements.
- The `code` element must be selected from the [Blood Glucose ValueSet](ValueSet-hddt-miv-blood-glucose-measurement.html), reflecting both the measurement method and the units supported by the device.
- The unit defined in the LOINC code’s display must align with both `valueQuantity.unit` and `valueQuantity.code`.
- Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource via the `device` element is required to capture the calibration status of the sensor, in order to ensure the proper interpretation of the data.
- If `valueQuantity` is missing, a `dataAbsentReason` must be specified, giving the reason for missing data.
- Set `status` to "final" for completed measurements.


### Conventions for DeviceMetric and Device Resources

- The Observation MUST reference a DeviceMetric resource if the calibration status of the device changes.
- Refer to [himi-diga-api.md](himi-diga-api.html) for generic implementation details.
- DeviceMetric should capture calibration and configuration status.
- Device should provide manufacturer, serial number, and device type.

### Examples

#### Example: Blood Glucose Observation Resource

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "2339-0",
        "display": "Glucose [Mass/volume] in Blood"
      }
    ]
  },
  "valueQuantity": {
    "value": 95,
    "unit": "mg/dL",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dl"
  },
  "effectiveDateTime": "2025-09-18T08:30:00+01:00",
  "device": {
    "reference": "DeviceMetric/12345"
  }
}
```

#### Example: FHIR-READ

**Request:** GET `/Observation/obs-blood-glucose-001`

**Description:** With FHIR-read interactions, a client can access a single resource instance by querying its internal ID. Restrictions by the OAuth scopes apply—if the client is not allowed to read this resource, a 404 error will be returned.

**Response**: Returned object is a single Observation resource.

```json
{
  "resourceType": "Observation",
  "id": "obs-blood-glucose-001",
  "status": "final",
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "2339-0",
        "display": "Glucose [Mass/volume] in Blood"
      }
    ]
  },
  "effectiveDateTime": "2025-08-28T10:00:00Z",
  "valueQuantity": {
    "value": 120,
    "unit": "mg/dL",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  }
}
```

### Example: FHIR-Search for specific LOINC code

**Request**: GET `/Observation?code=2339-0`

**Description**: Obtain all of the Observations where `code` is the LOINC code for blood sugar measurements (in mass/volume). OAuth scopes apply, and only Observations are returned that the client is allowed to access.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria.

```json
{
    "resourceType": "Bundle",
    "id": "6372cdfc-8d5b-49a2-af6b-65dcc3831192",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://[BASE-URL]/fhir/Observation/65",
            "resource": {
                "resourceType": "Observation",
                "id": "65",
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "2339-0",
                            "display": "Glucose [Mass/volume] in Blood"
                        }
                    ]
                },
                "effectiveDateTime": "2025-08-20T07:05:02.165Z",
                "valueQuantity": {
                    "value": 301,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                },
                "device": {
                    "reference": "DeviceMetric/67"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://[BASE-URL]/fhir/Observation/68",
            "resource": {
                "resourceType": "Observation",
                "id": "68",
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "2339-0",
                            "display": "Glucose [Mass/volume] in Blood"
                        }
                    ]
                },
                "effectiveDateTime": "2025-08-20T07:05:03.664Z",
                "valueQuantity": {
                    "value": 125,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                },
                "device": {
                    "reference": "DeviceMetric/67"
                }
            },
            "search": {
                "mode": "match"
            }
        }
    ]
}
```

### Example: FHIR-Search include DeviceMetric


**Request**: GET `/Observation?date=ge2025-08-15&_include=Observation:device`

**Description**: This query asks the server for all Observations since `2025-08-15`, and also requests that the server include resource instances referenced by `Observation.device`.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria, and all referenced DeviceMetric resources.

```json
{
    "resourceType": "Bundle",
    "id": "76cfc68b-ea70-486a-aaa5-4411964ab78d",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://[BASE-URL]/fhir/Observation/65",
            "resource": {
                "resourceType": "Observation",
                "id": "65",
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "2339-0",
                            "display": "Glucose [Mass/volume] in Blood"
                        }
                    ]
                },
                "effectiveDateTime": "2025-08-20T07:05:02.165Z",
                "valueQuantity": {
                    "value": 301,
                    "unit": "mg/dL",
                    "system": "http://unitsofmeasure.org",
                    "code": "mg/dL"
                },
                "device": {
                    "reference": "DeviceMetric/67"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://[BASE-URL]/fhir/DeviceMetric/67",
            "resource": {
                "resourceType": "DeviceMetric",
                "id": "67",
                "type": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "2339-0",
                            "display": "Glucose [Mass/volume] in Blood"
                        }
                    ]
                },
                "unit": {
                    "coding": [
                        {
                            "system": "http://unitsofmeasure.org",
                            "code": "mg/dL",
                            "display": "milligram per deciliter"
                        }
                    ]
                },
                "source": {
                    "reference": "Device/66"
                },
                "category": "measurement",
                "calibration": [
                    {
                        "state": "calibrated"
                    }
                ]
            },
            "search": {
                "mode": "include"
            }
        }
    ]
}
```