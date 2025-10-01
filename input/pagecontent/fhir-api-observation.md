### Introduction

This document describes the syntax and semantics of querying FHIR Observation resources via the standard RESTful API. Observation resources represent measurements or assertions made about a patient, such as blood glucose or interstitial fluid glucose values. The API supports 
- [reading](#device---read) individual Observation resources.
- [searching](#device---search) for Observation resources linked with the current patient and an authorised MIV. 

This document provides a generic API description for accessing measurement data via FHIR Observation resources. To comply with § 374a SGB V, a Device Data Recorder must implement the Observation endpoint according to the requirements of each specific use case or [Mandatory Interoperable Value (MIV)](mivs.html). For details and additional specifications relevant to individual use cases, see the **MIV-specific APIs** menu point. For example:

- [MIV - Blood Glucose Measurement](measurement-blood-glucose.html)
- [MIV - Continuous Glucose Measurement](measurement-tissue-glucose.html)


### Endpoints

#### Observation - READ

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Observation resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned Observation MUST conform to the MIV-specific Observation profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/resource.html#id) apply. |
| **Request Parameters** | `id` - logical ID of the Observation. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return an Observation resource that is linked to the patient in the token and that is accessible by the requestor according to its scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Returned Objects** | MIV-specific HDDT Observation resource. |
| **Specifications** | • Returned resources must conform to the relevant FHIR profiles for the use case (e.g., [Observation – Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html)).<br> • Values must be normalized (`unit/system/code`).<br> • For single measurements use `valueQuantity`; for time series use `valueSampledData`.<br> • A reference via `device` is required for the correct interpretation of data or for accessing the configuration of the device instance. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>•`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>•`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Observation - SEARCH

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Observation resources. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return Observation resources that is linked to the patient in the token and that is accessible by the requestor according to its scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Search Parameters** | The resource server MUST be able to discover the patient identifier from the Access Token. This identifier MUST implicitly be considered the `subject` parameter for every search request. If a DiGA explicitly provides a `subject` parameter with a query, the resource server MUST ignore this parameter and SHOULD respond with a `400 Bad Request` error.<br>The resource server MUST support search parameters `code` and `date`.<br>The resource server MAY support additional standard FHIR Observation search parameters. |
| **Returned Objects** | Bundle containing Observation entries that match the query. Optionally, Device or DeviceMetric resources can be included in the Bundle, if requested via an `_include` search parameter.<br> If no matching Observation resources are found, an empty Bundle MUST be returned. |
| **Specifications** | After successful [pairing](pairing.html) with a Device Data Recorder, a DiGA will start querying measurements for the patient. The DiGA MAY use search parameters to limit the types or date range of measurements returned. For additional considerations, such as minimum time ranges, handling of missing data, and common scenarios, refer to chapter [Retrieving Data](retrieving-data.html). |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>•`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>•`500` (Internal Server Error—may be either an OperationOutcome or plain text) |


---

### FHIR Operations

Additional ways to retrieve measurement data might be defined with custom [FHIR Operations](https://hl7.org/fhir/R4/operations.html). These operations rely on MIV-specific functionality; implementation details are defined under the menu **MIV-specific APIs**. More information about the need for FHIR operations in the scope of HDDT, see chapter [Retrieving Data](retrieving-data.html#querying-for-aggregated-or-calculated-data). The following table lists all operations defined in the scope of this project and the pages where they can be found:

| Operation | Location |
| - | - |
| `hddt-cgm-summary` | [MIV - Continuous Glucose Measurement](measurement-tissue-glucose.html) |

---



### Examples

#### Example Search Queries

Most commonly, a GET or POST request will be performed to get multiple Observations. Additional search parameters may be specified in order to constrain what Observations should be returned. Common use cases include:


| Request | Explanation |
|---------|-------------|
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23rd of July that measure blood sugar with the specific code, and have the specified patient as subject. |
|**GET** `/Observation?_include=Observation:device`| In the resulting Bundle also include the instances of the `DeviceMetric` resources referenced by the observations.  |
|**GET** `/Observation?_include=Observation:device&_include:iterate=DeviceMetric:source`| In the resulting Bundle include both DeviceMetric and Device, even if the Device has been referenced only via `DeviceMetric.source`.  |
| **GET** `/Observation?_sort=-date&_count=1` | Get the latest observation. |

---


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

#### OperationOutcome - Bad Syntax

**Description:** Occurs alongside a `400` HTTP status code, denoting that the server is unable to process the request due to a client error — malformed request syntax, too large request size, etc.

{% include OperationOutcome-HddtCgmSummaryOutcomeBadSyntax-json-html.xhtml %}
