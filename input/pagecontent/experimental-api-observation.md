# Experimental API: Observation Resource Access

### Introduction

This document describes the semantics of querying FHIR Observation resources via a RESTful API. Observation resources represent measurements or assertions made about a patient, such as blood glucose or interstitial fluid glucose values. The API supports both retrieving individual Observation resources and searching for Observations matching specific criteria (e.g., by code, date range, or device). Returned resources must conform to the relevant FHIR profiles for the use case.

#### Requests

Most commonly, a GET or POST request will be performed to get multiple Observations. Additional search parameters may be specify in order to constrain what Observations should be returned. Common use cases include:


| Request | Explanation |
|---------|-------------|
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23rd of July that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources referenced by the observations.  |
|**GET** `/Observation?_include=Observation:device&_include:iterate=DeviceMetric:source`| In the resulting Bundle include both DeviceMetric and Device, even if the Device has been referenced only via `DeviceMetric.source`.  |
| **GET** `/Observation?_sort=-date&_count=1` | Get the latest observation. |

---

### Endpoints

#### Observation - READ

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Observation resource by its internal server ID. The returned Observation MUST conform to the relevant profile for the use case (see below). |
| **Request Parameters** | `id` - Internal server ID of the Observation. |
| **Authentication** | OAuth2 Bearer token required |
| **Returned Objects** | • FHIR Observation<br><br>Optionally (via search interaction `_include`):<br> •DeviceMetric (via `device`)<br> •Device (via `device`) |
| **Specifications** | • Returned resources must conform to the relevant FHIR profiles for the use case (e.g., [Observation – Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html)).<br> • Values must be normalized (`unit/system/code`).<br> • For single measurements use `valueQuantity`; for time series use `valueSampledData`.<br> • Reference via `device` is required for the correct interpretation of data or for accessing the configuration of the device instance. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Observation - SEARCH

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Observation resources using parameters such as `code`, `date`, and `_include`. Returned Observations MUST conform to the relevant profile for the use case. |
| **Authentication** | OAuth2 Bearer token required |
| **Search Parameters** | Search parameters are MIV-specific. Commonly used ones are `code`, `date`, `_include`. See individual use cases for specific search parameters. <br><br> The server MAY support search parameters defined by the FHIR standard; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • FHIR Observation<br><br>Optionally (via search interaction `_include`):<br> •DeviceMetric (via `device`)<br> •Device (via `device`) |
| **Specifications** | • Returned resources must conform to the relevant FHIR profiles for the use case (e.g., [Observation – Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html)).<br> • Values must be normalized (`unit/system/code`).<br> • For single measurements use `valueQuantity`; for time series use `valueSampledData`.<br> • Reference via `device` is required for the correct interpretation of data or for accessing the configuration of the device instance. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br> •`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br> •`500` (Internal Server Error—may be either an OperationOutcome or plain text) |


---

### Use-Case: Blood Sugar

This section describes additional requirements, when implementing the FHIR API for providing access to blood glucose data. Common use cases include retrieving the latest observation, retrieving only observations that measure blood glucose in mg/dL, and retrieving all measurements across a certain date range.

Observations representing blood glucose measurements MUST conform to the [Observation - Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html).

#### Conventions

- Always use the latest version of the Observation profile.
- Only `valueQuantity` is permitted as the result of the Observation for blood glucose measurements.
- The `code` element must be selected from the [ValueSet Blood Glucose Measurement](ValueSet-hddt-miv-blood-glucose-measurement.html), reflecting both the measurement method and the units supported by the device.
- The unit defined in the LOINC code’s display must align with both `valueQuantity.unit` and `valueQuantity.code`.
- Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource via the `device` element is required to capture the calibration status of the sensor, in order to ensure the proper interpretation of the data.
- If `valueQuantity` is missing, a `dataAbsentReason` must be specified, giving the reason for missing data.
- Set `status` to "final" for completed measurements.


#### Embedded Profile

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

#### Example: FHIR-Search for specific LOINC code

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

#### Example: FHIR-Search include DeviceMetric


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

---

### Use-Case: Interstitial Fluid Glucose (ISF Glucose)

This section describes additional requirements, when implementing the FHIR API for providing access to interstitial fluid glucose data. Common use cases include retrieving the latest observation, retrieving only observations that measure interstitial fluid glucose in mg/dL, and retrieving all measurements across a certain date range.

Observations representing interstitial fluid glucose measurements MUST conform to the [Observation – Continuous Glucose Measurement profile](StructureDefinition-ddt-continuous-glucose-measurement.html).

#### Conventions and Best Practice

- Always use the latest version of the Observation profile.
- Only `valueSampledData` is permitted as the result of the Observation for tissue glucose time-series (CGM) measurements.
- The `code` element MUST be selected from the [ValueSet – Continuous Glucose Measurement](ValueSet-hddt-miv-continuous-glucose-measurement.html) and be consistent with the units supported by the device.
- The unit in the LOINC code’s display MUST match `valueSampledData.unit` or `valueSampledData.code`.
- When calibration status is relevant, `Observation.device` MUST reference a `DeviceMetric` resource that records sensor type and calibration details.
- If calibration is not relevant for the device, `Observation.device` MUST reference a `Device` resource.
- If `valueSampledData` is missing, a `dataAbsentReason` MUST be provided.
- Set `status` to reflect whether the Observation is complete (i.e., no more `valueSampledData.data` can be added); see [Retrieving Data](retrieving-data.html) for additional considerations.
- Ensure referenced Device/DeviceMetric resources are available (use `_include=Observation:device` in searches when appropriate).

#### FHIR Operation

Manufacturers of CGM devices MUST also implement the following FHIR Operation, providing access to summary data such as "Times in Range", "Time Out Of Range", "Mean Glucose", etc.

| | |
|-|-|
| **Resource** | Observation |
| **Operation name** | `$hddt-cgm-summary` |
| **Purpose** | Request a summary of CGM values (e.g., tissue glucose values below threshold) for a specified time range. |
| **Parameters** | `effectivePeriodStart (dateTime)`, `effectivePeriodEnd (dateTime)`, `related (boolean)` |
| **Returned Objects** | Bundle containing summary Observation(s), DeviceMetric, and Device resources. |
| **Specifications** | Summary calculated at run-time, not stored persistently. Must support all listed parameters and profiles. |

#### Embedded Profiles

**CGM Measurement Series**

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

**CGM Summary**

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> [HL7 CGM Summary](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)</p>
  </div>
</div>

**Bundle - Summary Data Measurements**

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