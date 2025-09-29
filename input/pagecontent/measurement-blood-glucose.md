
This document provides implementation guidance for manufacturers integrating glucometer data using a RESTful FHIR API. It builds on the [Generic FHIR API](himi-diga-api.html) and describes the specific requirements for exposing blood glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html), including any required FHIR operations.
- The relevant FHIR profiles for blood glucose measurement and how they should be returned by the API.
- Conventions for using FHIR resources to ensure compliance with the [Information model](information-model.html).
- Example requests and responses to support implementation.

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders MUST register their product with BfARM. For a successful registration they MUST implement an OAuth2 Authorization Server and an FHIR Resource Server acc. to this specification. For both services they MUST consider the requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

#### OAuth2 Authorization Server

to do: Hinweise auf die einschlägigen Stellen in der Spezifikation

#### FHIR Resource Server
The FHIR Resource Server gives DiGA access to measured data and related information about metrics and devices. A Device Data Recorder's FHIR Resource Server that serves the MIV _Blood Glucose Measurement_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Server's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](use_of_hl7_fhir.html#metadata-endpoint).
* _read_ and _search_ interactions on a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) endpoint that implements the [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. These interactions are common for all MIVs. The full specification of the interaction can be found [here](himi-diga-api.html#devicemetric).
* _read_ and _search_ interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interaction can be found [here](himi-diga-api.html#device).
* _read_ and _search_ interactions on an [Observation](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile. These interactions and the underlying profile are specific for implementing the MIV _Blood Glucose Measurement_. The full specifications are given below.

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server. The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html).

### MIV-specific Endpoints and Interactions
#### Observation - READ

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single blood glucose Observation by its internal server ID<br> The returned Observation MUST conform to the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile. The reference given in `Observation.device` can be resolved by requests on the `/Device` or `/DeviceMetric` endpoints.|
| **Request Parameters** | `id` - Referring to the internal server ID of the Observation. |
| **Returned Objects** | [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

---

#### Observation - SEARCH

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET |
| **Interaction** | SEARCH |
| **Description** | Search for blood glucose Observations. Common use cases include retrieving the latest observation, retrieving only observations that measure blood glucose in a certain unit (e.g. mg/dL), and retrieving all measurements across a certain date range. <br>Requests with the search parameter `_include=Observation:device` can be used to return DeviceMetric and Device resources referenced by `Observation.device` in the same Bundle. |
| **Search Parameters** | Parameters that MUST be supported are:<br> • `code` - Search for Observations of a specific type<br> • `date` - Specify a date range <br> • `_include` - Optionally include DeviceMetric and Device resources, referenced by `Observation.device`. <br><br> The server MAY support other search parameters; see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • Bundle containing [hddt-blood-glucose-measurement](StructureDefinition-hddt-blood-glucose-measurement.html) entries and optionally [hddt-sensor-type-and-calibration-status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) and [Device - Personal Health Device](StructureDefinition-hddt-personal-health-device.html) when requested via `_include`. |
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html) for a list of the expected HTTP status codes |

-->

### MIV-Specific Observation Profile

#### Instantiation of the HDDT Information Model

<div style="width: 75%;">
  <img src="assets/images/HDDT_Objektmodell_BZ_Complete.svg" style="width: 100%;" />
</div>

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

<span style="color:red">**@Jörg: Beispiel-Ansicht hier**</span>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-blood-glucose-measurement-dict-diff.xhtml%}
    </div>
</div>
<!--
<div>
    <p><strong>Option 2: Detailed description of key elements</strong></p>
    <a name="tabs-key"> </a>
    <div id="tabs-key">
      {%include StructureDefinition-hddt-blood-glucose-measurement-dict-key.xhtml%}
    </div>
</div>
-->
<!--
<div>
    <p><strong>Option 3: Detailed description of snapshot elements</strong></p>
    <a name="tabs-snap"> </a>
    <div id="tabs-snap">
      {%include StructureDefinition-hddt-blood-glucose-measurement-dict.xhtml%}
    </div>
</div>   
-->

Constraints and terminology bindings view removed. Refer to the canonical StructureDefinition for full snapshot, constraints and terminology bindings.

#### Conventions and Best Practice

- Always use the latest version of the Observation profile.
- Only `valueQuantity` is permitted as the result of the Observation for blood glucose measurements.
- The `code` element must be selected from the [Blood Glucose ValueSet](ValueSet-hddt-miv-blood-glucose-measurement.html), reflecting both the measurement method and the units supported by the device.
- The unit defined in the LOINC code’s display must align with both `valueQuantity.unit` and `valueQuantity.code`.
- Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource via the `device` element is required to capture the calibration status of the sensor, in order to ensure the proper interpretation of the data.
- If `valueQuantity` is missing, a `dataAbsentReason` must be specified, giving the reason for missing data.
- Set `status` to "final" for completed measurements.

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
