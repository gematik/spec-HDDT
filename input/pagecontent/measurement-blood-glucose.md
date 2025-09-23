**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

### Introduction

This document provides implementation guidance for manufacturers integrating glucometer data using a RESTful FHIR API. It builds on the [Generic FHIR API](himi-diga-api.html) and describes the specific requirements for exposing blood glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html), including any required FHIR operations.
- The relevant FHIR profiles for blood glucose measurement and how they should be returned by the API.
- Conventions for using FHIR resources to ensure compliance with the [Information model](information-model.html).
- Example requests and responses to support implementation.

### FHIR RESTful Interactions

The server **MUST** support the following FHIR interactions. Section [Endpoints](#endpoints) specifies which endpoint should support which interactions. Section [Examples](#examples) provides request and response examples for each interaction.

#### READ

Endpoints that are required to support the REST interaction "READ" **MUST** be available under `[BASE_URL]/[resourceType]/[ID]`, [as specified by FHIR](https://www.hl7.org/fhir/R4/http.html#read).

Resource instances returned by the READ interactions **MUST** conform to the HDDT FHIR Profiles.

#### SEARCH

Endpoints that are required to support the "SEARCH" interactions **MUST** allow searching via HTTP GET. Endpoints **MAY** choose to support search requests via HTTP POST. See [FHIR RESTful Search - Introduction](https://www.hl7.org/fhir/R4/search.html#Introduction).




### Endpoints

The server **MUST** support the following endpoints.

**Authentication**: The authentication and authorization requirements for these endpoints are the same as the [Generic HiMi FHIR API](himi-diga-api.html).

#### Metadata

| | |
|-|-|
| **Endpoint** | `/metadata` |
|**Description** | Provide a FHIR [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) that contains information about the supported endpoints, resource interactions, and search parameters. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---


#### Observation

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET |
| **Interactions**| READ, SEARCH |
| **Description** | A DiGA must be able to retrieve blood glucose measurements from this endpoint. Common use cases include retrieving the latest observation, retrieving only observations that measure blood glucose in mg/dL, and retrieving all measurements across a certain date range. <br><br> On request, the endpoint should also provide the calibration status (via DeviceMetric), as it is required for the correct interpretation of the measured values. On request, the endpoint should also provide the device instance data (via Device). | 
| **Request Parameters** | `/Observation/<id>` - Referring to the internal server ID of the Observation.
| **Search Parameters** | Parameters that MUST be supported are:<br> • `code` - Search for Observations of a specific type<br> • `date` - Specify a date range <br> • `_include` - Optionally include Device and DeviceMetric resources, referenced by `Observation.device`. <br><br> The server MAY support other search parameters; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • [Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html) <br> • [DeviceMetric-Sensor-Type-and-Calibration-Status](StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status.html) <br> • [Device-Personal-Health-Device](StructureDefinition-Device-Personal-Health-Device.html)
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

---

#### DeviceMetric

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET |
| **Interactions**| READ, SEARCH |
| **Description** |  Query the calibration status of the device for the last measurement or measurement series. Calibration status is required for the correct interpretation of the measurements. Reference the specific device instance to maintain the link between measurement data and the physical sensor. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Device

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET |
| **Interactions**| READ, SEARCH |
| **Description** | Query the configuration and properties of the device instance, based on the last measurement or last measurement series. Query information about the stored device instance for device validation (e.g., serial number, type, manufacturer). Complements the query of Observation -> DeviceMetric, since information about the underlying device is not always delivered directly with the measurement. | 
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

### MIV-Specific Observation Profile

<div id="tabs-snap">
  <div id="tbl-snap">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['Observation-Blood-Glucose'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['Observation-Blood-Glucose'].basepath}}">
        {{site.data.structuredefinitions['Observation-Blood-Glucose'].basename}}
      </a>
    </p>
    <div id="tbl-snap-inner">
      {% include StructureDefinition-Observation-Blood-Glucose-snapshot.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-Observation-Blood-Glucose-tx.xhtml %}

      {% capture invariantssnap %}
        {% include StructureDefinition-Observation-Blood-Glucose-inv.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantssnap.size <= 218 %}
        <a name="inv-snap"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-Observation-Blood-Glucose-inv.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>

#### Conventions and Best Practice

- Always use the latest version of the Observation profile.
- Only `valueQuantity` is permitted as the result of the Observation for blood glucose measurements.
- The `code` element must be selected from the [Blood Glucose ValueSet](ValueSet-vs-blood-glucose.html), reflecting both the measurement method and the units supported by the device.
- The unit defined in the LOINC code’s display must align with both `valueQuantity.unit` and `valueQuantity.code`.
- Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status.html) resource via the `device` element is required to capture the calibration status of the sensor, in order to ensure the proper interpretation of the data.
- If `valueQuantity` is missing, a `dataAbsentReason` must be specified, giving the reason for missing data.
- Set `status` to "final" for completed measurements.


### Conventions for DeviceMetric and Device Resources

- The Observation **MUST** reference a DeviceMetric resource if the calibration status of the device changes.
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
            "fullUrl": "https://hdc-hapi-fhir.azurewebsites.net/fhir/Observation/65",
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
            "fullUrl": "https://hdc-hapi-fhir.azurewebsites.net/fhir/DeviceMetric/67",
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