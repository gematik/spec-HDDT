**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

### Introduction

This document provides implementation guidance for manufacturers integrating data from continuous glucose measurement (CGM) devices, using a RESTful FHIR API. It builds on the [Generic FHIR API](himi-diga-api.html) and describes the specific requirements for exposing interstitial fluid glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html), including any required FHIR operations.
- The relevant FHIR profiles for interstitial fluid glucose measurement and how they should be returned by the API.
- Conventions for using FHIR resources to ensure compliance with the [Information model](information-model.html).
- Example requests and responses to support implementation.

### FHIR API

The server MUST support the following endpoints.

**FHIR Interactions**: The specified FHIR interactions are the same as in [Generic HiMi FHIR API](himi-diga-api.html).

**Authentication**: The authentication and authorization requirements for these endpoints are the same as the [Generic HiMi FHIR API](himi-diga-api.html).

### Endpoint - Metadata

| | |
|-|-|
| **Endpoint** | `/metadata` |
|**Description** | Provide a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) that contains information about the supported endpoints, resource interactions, and search parameters. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

### Endpoint - Observation

#### Observation - READ

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single interstitial fluid glucose Observation by its internal server ID. Such scenario is unlikely to occur, but MUST be supported. <br> The returned Observation MUST conform to the HDDT hddt-continuous-glucose-measurement profile. Subsequent request can be made on the `/Device` or `/DeviceMetric` endpoints, to resolve the reference in `Observation.device`, and obtain the device calibration status or configuration. |
| **Request Parameters** | `id` - Referring to the internal server ID of the Observation. |
| **Returned Objects** | • [hddt-continuous-glucose-measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

---

#### Observation - SEARCH

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for interstitial fluid glucose Observations. Common use cases include retrieving the latest observation, retrieving only observations that measure interstitial fluid glucose in mg/dL, and retrieving all measurements across a certain date range. <br>Requests with the search parameter `_include=Observation:device` can be used to return DeviceMetric and Device resources referenced by `Observation.device` in the same Bundle. |
| **Search Parameters** | Parameters that MUST be supported are:<br> • `code` - Search for Observations of a specific type<br> • `date` - Specify a date range <br> • `_include` - Optionally include DeviceMetric and Device resources, referenced by `Observation.device`. <br><br> The server MAY support other search parameters; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • Bundle containing [hddt-continuous-glucose-measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) entries and optionally [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) and [hddt-personal-health-device](StructureDefinition-hddt-personal-health-device.html) when requested via `_include`. |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

#### Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-continuous-glucose-measurement'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-continuous-glucose-measurement'].basepath}}">
        {{site.data.structuredefinitions['hddt-continuous-glucose-measurement'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-continuous-glucose-measurement-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>


#### Examples - FHIR Search GET

**Request**: GET `/Observation?date=ge2025-08-01`

**Description**: Request all CGM measurements, since the 1st of August. Return a Bundle. This one contains only a single observation.

**Response:**

```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://hdc-hapi-fhir.azurewebsites.net/fhir/Observation/65",
            "resource": {
                "resourceType": "Observation",
                "id": "obs-cgm-series-001",
                "status": "preliminary",
                "code": {
                    "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "105272-9",
                        "display": "Glucose [Moles/volume] in Interstitial fluid"
                    }
                    ]
                },
                "effectivePeriod": {
                    "start": "2025-08-28T08:00:00Z",
                    "end": "2025-08-28T10:00:00Z"
                },
                "valueSampledData": {
                    "origin": {
                    "value": 0,
                    "unit": "mmol/L"
                    },
                    "period": 300,
                    "data": "5.6 5.8 6.0 5.9 5.7"
                }
        }
    ]
}

```

#### Examples - FHIR Search POST

**Request**: POST `/Observation/_search`

**Headers:**

- `Content-Type: application/json`
- `Accept: application/json`

**Body:**

```json
{
    "code": "99504-3"
}
```

**Description:** Use a POST requests, with the search parameters in the request body, to query all Observations that measure interstitial fluid glucose in mg/dL. Response is a Bundle.

**Response:**

```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://hdc-hapi-fhir.azurewebsites.net/fhir/Observation/65",
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
            "fullUrl": "https://hdc-hapi-fhir.azurewebsites.net/fhir/Observation/68",
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


### Endpoint - DeviceMetric

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
| **Returned Objects** | • Bundle containing [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) entries. Optionally, additional [hddt-personal-health-device](StructureDefinition-hddt-personal-health-device.html) entries when using `_include`. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Profile

No deviation from the [Generic FHIR API](himi-diga-api.html).


#### Examples

No deviation from the [Generic FHIR API](himi-diga-api.html).



### Endpoint - Device

#### Device - READ

| | |
|-|-|
| **Endpoint** | `/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Device instance by its internal ID. Use this to obtain configuration and properties of the device instance (e.g., serial number, manufacturer, device type) needed for device validation. Device ID is usually obtained from previous requests, either via `Observation.device`, or `DeviceMetric.source`. |
| **Request Parameters** | `/Device/<id>` - Referring to the internal server ID of the Device. |
| **Returned Objects** | • [hddt-personal-health-device](StructureDefinition-hddt-personal-health-device.html) |
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
| **Returned Objects** | • Bundle containing [hddt-personal-health-device](StructureDefinition-hddt-personal-health-device.html) entries |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Profile

No deviation from the [Generic FHIR API](himi-diga-api.html).


#### Examples

No deviation from the [Generic FHIR API](himi-diga-api.html).


### FHIR Operation

| | |
|-|-|
| **Resource** | Observation |
| **Operation name** | `$hddt-cgm-summary` |
|**Purpose** |  Request a summary of desired CGM values (e.g tissue glucose values below lower threshold) for a certain range of time. |
|**Parameters** |  See section "[OpenAPI Description](#openapi-description) for parameter definitions and examples.<br> • `effectivePeriodStart (dateTime)` (optional) <br> • `effectivePeriodEnd (dateTime)` (optional) - End of the effective time period <br> •  `related (boolean)` (optional)|
| **Specifications** | • Summary is calculated at run-time and results are not stored persistently. <br> •  MUST support all profiles listed in `hddt-cgm-summary` bundle. <br> • MUST support all listed parameters.<br> •  If no period is specified, the server selects a time range starting from the current date, which MUST cover at least 14 days.<br> •  The Summary-Operation MUST support a minimal duration of 7 days for the effective period, and an error must be returned if the client requests a shorter time period. |

#### Profiles



<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-cgm-summary'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-cgm-summary'].basepath}}">
        {{site.data.structuredefinitions['hddt-cgm-summary'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-cgm-summary-diff-all.xhtml %}
    </div>
  </div>
</div>

---
---

The Observation profile for the CGM summary report is defined by HL7: [StructureDefinition-cgm-summary](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)


#### Example

**Request:** POST `/Observation$hddt-cgm-summary`

**Request Body:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "effectivePeriodStart",
      "valueDateTime": "2025-08-01T00:00:00Z"
    },
    {
      "name": "effectivePeriodEnd",
      "valueDateTime": "2025-08-31T23:59:59Z"
    },
    {
      "name": "related",
      "valueBoolean": true
    }
  ]
}
```

**Description:**

Perform the FHIR Operation to request a summary of aggregated values over the specified time range. The Bundle should also include all Device and DeviceMetric resource instances, that were needed to calculate the data summary.

**Response:**

```json
{
  "resourceType": "Bundle",
  "type": "collection",
  "entry": [
    {
      "resource": {
        "resourceType": "Observation",
        "id": "cgmSummaryExample",
        "status": "final",
        "category": [
          {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                "code": "laboratory"
              }
            ]
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://hl7.org/fhir/uv/cgm/CodeSystem/cgm-summary-codes-temporary",
              "code": "cgm-summary"
            }
          ]
        },
        "subject": {
          "reference": "Patient/patientExample"
        },
        "effectivePeriod": {
          "start": "2025-08-01",
          "end": "2025-08-31"
        },
        "hasMember": [
          {
            "reference": "Observation/cgmSummaryMeanGlucoseMassPerVolumeExample"
          },
          {
            "reference": "Observation/cgmSummaryTimesInRangesExample"
          },
          {
            "reference": "Observation/cgmSummaryGMIExample"
          },
          {
            "reference": "Observation/cgmSummaryCoefficientOfVariationExample"
          },
          {
            "reference": "Observation/cgmSummaryDaysOfWearExample"
          },
          {
            "reference": "Observation/cgmSummarySensorActivePercentageExample"
          }
        ]
      }
    }
  ]
}
```

### Conventions and Best Practice

- Always use the latest version of the Observation profile.
- Only `valueSampledData` is permitted as the result of the Observation for tissue glucose time-series (CGM) measurements.
- The `code` element MUST be selected from the [ValueSet – Continuous Glucose Measurement](ValueSet-hddt-miv-continuous-glucose-measurement.html) and be consistent with the units supported by the device.
- The unit in the LOINC code’s display MUST match `valueSampledData.unit` or `valueSampledData.code`.
- When calibration status is relevant, `Observation.device` MUST reference a `DeviceMetric` resource that records sensor type and calibration details.
- If calibration is not relevant for the device, `Observation.device` MUST reference a `Device` resource.
- If `valueSampledData` is missing, a `dataAbsentReason` MUST be provided.
- Set `status` to reflect whether the Observation is complete (i.e., no more `valueSampledData.data` can be added); see [Retrieving Data](retrieving-data.html) for additional considerations.
- Ensure referenced Device/DeviceMetric resources are available (use `_include=Observation:device` in searches when appropriate).


### Conventions for DeviceMetric and Device Resources

- The Observation MUST reference a DeviceMetric resource if the calibration status of the device changes.
- Refer to [himi-diga-api.md](himi-diga-api.html) for generic implementation details.
- DeviceMetric should capture calibration and configuration status.
- Device should provide manufacturer, serial number, and device type.