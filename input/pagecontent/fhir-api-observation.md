
DiGA query the resource server of a Device Data Recorder via standard RESTful APIs. All device data that is measured by a Personal Health Device is represented as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources at the resource server. 

HDDT defines specific profiles for Observation resources for each Mandarory Interoperable Value (MIV). This allows for considering specific requirements of typical DiGA use cases and fosters the adoption of already existing profiles. In addition, derived and aggregated values for a specific MIV can be made available as condensed reports via HDDT-defined [FHIR Operations](https://hl7.org/fhir/R4/operations.html). See 
* [MIV-specific APIs](mivs.html) for a list of all MIV-specific Observation profiles and operations,
* [Information Model](information-model.html) for a detailed description of elements and codings which are common to all MIV-specific Observation profiles.
* [Retrieving Data](retrieving-data.html) for a detailed description of the overall data flow and how relationships between Observation, DeviceMetric and Device resources are affected by the calibration of a sensor or the exchange of a sensor.

Nevertheless all Observation profiles share common characteristics and the same basic API interactions. This chapter describes these generic interactions in detail. For a better understanding of the overall data flow and the difference between dedicated and continuous measurements, refer to chapter [Retrieving Data](retrieving-data.html).

To comply with § 374a SGB V, every Device Data Recorder MUST implement an Observation endpoint that allows for: 
- [reading](#device---read) individual Observation resources.
- [searching](#device---search) for Observation resources associated with the current patient and an authorised MIV. 


### Endpoints

#### Observation - READ
Per HL7 FHIR a _resource_ is a a definable, identifiable, addressable collection of data elements that represents a concept or entity in health care. By this each [Observation](https://hl7.org/fhir/R4/observation.html) resource a Device Data Recorder transmits to a DiGA MUST be identifiable and addressable through a logical `id`. A Device Data Recorder MUST allow a DiGA to request a known Observation by using a FHIR [_read_ interaction](https://hl7.org/fhir/R4/http.html#read)

| | |
|-|-|
| **Endpoint** | `/Observation/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single Observation resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned Observation MUST conform to the MIV-specific Observation profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/resource.html#id) apply. |
| **Request Parameters** | `id` - logical ID of the Observation. |
| **Authorization** | OAuth2 Bearer token required. The resource server MUST only return a Observation resource that is linked to the patient who is associated with the token. Provided Device resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html)).  |
| **Returned Objects** | MIV-specific HDDT Observation resource. |
| **Specifications** | The only ways for a DiGA to obtain the logical `id` of an Observation resource is a 'search' interaction for device data of the given patient (see [searching](#device---search) below). <br>A Device Data Recorder MAY limit access to historical data (e.g. only up to 30 days into the past). In case a DiGA requests such a historic resource by its `id` after the availability period ended, the Device Data Recorder MUST respond with a _404 Not Found_ error. A DiGA can discover the length of this period through the `Historic-Data-Period` property of definition of the associated Device resource. <br>If a requesting DiGA can only process high quality device data, it SHOULD assess the calibration status of the device that can be obtained through the [DeviceMetric)](fhir-api-devicemetric.html) resource which is accessible through the `Observation.device` reference. If the `Observation.device` reference links to a Device Resource instead of a DeviceMetric resource, the DiGA MUST consider the device to be calibrated without any need for re-calibration. |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>•`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>•`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

---

#### Observation - SEARCH 

##### Implicit Arguments

DiGA request device data from a Device Data Recorder using a standard FHIR [search interaction](https://hl7.org/fhir/R4/http.html#search) on the [Observation](https://hl7.org/fhir/R4/observation.html) resource type. 
The Device Data Recorder MUST respond to a [search](https://hl7.org/fhir/R4/http.html#search) request with a collection of [Observation](https://hl7.org/fhir/R4/observation.html) resources or with an error.

The request header MUST contain an Access Token acc. to the HDDT [OAuth2 profile](pairing.html#access-tokens). This access token was issued by the [Authorization Server](authorization-server.html) of the Device Data Recorder and MUST be taken as opaque by the DiGA. 
 
The Device Data Recorder MUST be able to discover the internal patient identifier from the access token. This identifier MUST implicitly be considered as the `subject` argument with every query for device data. The Device Data Recorder MUST be able to discover the SMART Scope from the access token, which were accepted by the Device Data Recorder during pairing with the requesting DiGA (see section [Pairing](pairing.md)). The SMART Scope MUST implicitly be considered as the `code` argument with every query for device data. If the Scope resolves to multiple LOINC codes, these must all be considered to be query arguments (OR-semantics). A DiGA MAY further constrain the scope of the search by providing an explicit `code` argument with a query.

For more information about implicit arguments and guidance for exceptional cases, see the chapter [Retrieving Data](retrieving-data.html#searching-observations-using-fhir-search-interactions).

##### Generic HDDT Search Interaction

| | |
|-|-|
| **Endpoint** | `/Observation` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for Observation resources. |
| **Authorization** | OAuth2 Bearer token required. The Device Data Recorder acting as the resource server MUST only return Observation resources that are linked to the patient in the token and that is accessible by the requestor according to its scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Search Parameters** | The Device Data Recorder MUST be able to discover the patient identifier from the Access Token. This identifier MUST implicitly be considered the `subject` parameter for every search request. If a DiGA explicitly provides a `subject` parameter with a query, the Device Data Recorder MUST ignore this parameter and SHOULD respond with a `400 Bad Request` error.<br>The Device Data Recorder MUST support search parameters `code` and `date`. If a `code` argument is provided with the request, the search is narrowed to the provided codes. If one or many of the provided `code` values are not included with the MIV's ValueSet, the Device Data Recorder MUST respond with a `400 Bad Request` error.<br>The Device Data Recorder MAY support additional standard FHIR Observation search parameters. <br>A Device Data Recorder MAY limit access to historical data (e.g. only up to 30days into the past). In case the `date` argument results in a search that only covers deleted historic data, the Device Data Recorder MUST respond with a _404 Not Found_ error in order to signal the DiGA that there may have been data which is no longer available. |
| **Returned Objects** | Bundle containing Observation entries that match the query. Optionally, Device or DeviceMetric resources can be included in the Bundle, if requested via an `_include=Observation:device` search parameter.<br> If no matching Observation resources are found, an empty Bundle MUST be returned. |
| **Specifications** | The Device Data Recorder SHOULD support [_Paging_](https://hl7.org/fhir/R4/http.html#paging).<br> The Device Data Recorder MUST consider the delay from real time of the specific device and Device Data Recorder. This device-specific value can be obtained as the `Delay-from-real-Time` property of definition of the associated Device resource. <br> Data may be missing due to broken connectivity (e.g. the sensor is out of range of its mobile app). A DiGA can discover such situations by checking the `status` of the associated device.<br> Device Data Recorders MUST support `include=Observation:device` and `_include:iterate=DeviceMetric:source` as query arguments. <br> For additional information on the constraints and obligations listed above refer to chapter [Retrieving Data](retrieving-data.html). |
| **Error codes** |•`400 Bad Request` **OperationOutcome** (Invalid query parameters / Invalid search parameters)<br>•`401 Unauthorized` **plaintext** (Invalid or expired JWT)<br>•`403 Forbidden` **OperationOutcome** (Empty Authorization header, or client has no permission for this resource.)<br>•`404 Not Found` **OperationOutcome** (No resource exists or is accessible with this ID.)<br>•`500` (Internal Server Error—may be either an OperationOutcome or plain text) |

#### Searching for Dedicated Measurements

Dedicated measurements are scheduled by a defined care plan or triggered by an unscheduled event (e.g. a patient feeling sick). A dedicated measurement occurs at a dedicated points in time and records single values for one or more data items (e.g. systolic and dystolic blood pressure). Typical examples of devices which are used ad hoc or based on a care plan are blood glucose meters, smart insulin pens, blood pressure cuffs and peak flow meters.

For HDDT Observations Profiles that cover dediated measurements there are no deviations from the generic search interaction defined above. 

#### Searching for Continuous Measurements

With continuous measurements the patient is connected to a sensor (almost) all the time and the sensor continuously measures and records data. Typical examples of devices that perform continuous measurements are rtCGM, insulin pumps and pace makers. In addition, there are devices and scenarios, which performcontinuous measurements over didicated periods, e.g. a personal ECG recorders for recording short, single-channel ECGs or a pulse oximeter that monitors SPO2 during sleep time. With respect to the flavor of the _search_ interaction, such scenarios are usually considered as continuous measurements, too, because this _search_ flavor is much more efficient in transfering sampled data.

For HDDT Observation Profiles that cover continuous measurements there are some constraints and obligation with respect to the generic search interaction defined above:

- Values from continuous measurements MUST be provided as chunks of [sampledData](/https://hl7.org/fhir/R4/datatypes.html#SampledData), where each chunk of data is represented as an [Observation](https://hl7.org/fhir/R4/observation.html). Chunks are of fixed size with respect to the `effectivePeriod`. E.g. a chuck with a fixed size of one hour can hold up to 60 values with a sampling frequency of one value per minute. The size of a chunk MUST be registered with the BfArM Device Registry and can be obtained from there through the definition of the device. 
- In a query for continuously measured data results in multiple chunks, each chunk's `Observation.effectivePeriod` MUST be of the defined fixed size. The last chunk MAY hold less data than fits to the chunk. In this case the `Observation.status` of the chunk MUST be set to _preliminary_ (see [Retrieving Data](retrieving-data.html#continuous-measurements) for details). A DiGA MAY use the logical `id` of the last chunk to request this chunk again later in order to obtain the missing data.
- The only exceptions to the fixed chunk size are changes to the `calibration.state` or a change of the personal health device. In these cases a chunk's `Observation.effectivePeriod` can be shorter than the fixed chunk size (see [Retrieving Data](retrieving-data.html#change-of-calibrationstatus) for details). The status of the chunk MUST be set to _final_ in this case.

### Examples

#### Example Search Queries

Most commonly, a GET or POST request will be performed to get multiple Observations. Additional search parameters may be specified in order to constrain what Observations should be returned. Common use cases include:


| Request | Explanation |
|---------|-------------|
|**GET** `/Observation`| Request all Observations available for the current patient and the authorized MIV (Information about patient and MIV are associated with the Access Token). |
|**GET** `/Observation?date=ge2025-07-23&`| Request all Observations since the 23rd of July for the current patient and the authorized MIV.
|**GET** `/Observation?code=http://loinc.org\|2339-0&date=ge2025-07-23&`| Request all Observations since the 23rd of July for the current patient and the authorized MIV that hold blood sugar values of unit mg/dl. If the LOINC code 2339-0 is not included with the MIV, the Device Data Recorder will return a `400 Bad Request` error.|
|**GET** `/Observation?_include=Observation:device`| see example-1. The resulting _searchset_ Bundle also includes the instances of the `DeviceMetric` resources referenced by the observations.  |
|**GET** `/Observation?_include=Observation:device&_include:iterate=DeviceMetric:source`| see example-1. The resulting Bundle includes all DeviceMetric and Device resources directly or indirecly linked wth the contained observations.  |
| **GET** `/Observation?_sort=-date&_count=1` | Get the latest observation (in case of a continuous measurement the current chunk) for the current patient and the authorized MIV. |

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
