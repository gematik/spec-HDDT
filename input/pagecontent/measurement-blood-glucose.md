
This chapter provides obligations and hints for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Blood Glucose Measurement_.  

This chapter builds on the [HDDT Information Model](information-model-html), the [HDDT Generic FHIR API](himi-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constraints these guidelines with respect to the specific requirements for exposing blood glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html)
- The relevant FHIR profile for blood glucose measurement and how it constraints and extends the [HDDT Information Model](information-model-html)
- Conventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Blood Glucose Measurement_ 
- MUST implement and operate a FHIR Resource Server as defined in this chapter, 
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HiMi-SST-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server
The Device Data Recorder's FHIR Resource Server gives DiGA access to measured data and related information about metrics and devices. A Device Data Recorder's FHIR Resource Server that serves the MIV _Blood Glucose Measurement_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Server's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](use_of_hl7_fhir.html#metadata-endpoint).
* HDDT common RESTful interactions on a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) endpoint that implements the [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](himi-diga-api.html#devicemetric).
* HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](himi-diga-api.html#device).
* MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile. These interactions and the underlying profile are specific for implementing the MIV _Blood Glucose Measurement_. The full specifications are given below.

The figure below shows the adaption of the [HDDT Information Model](information-model-html) for the MIV _Blood Glucose Measurement_. Elements denoted as _[1..1]_ are mandatory oder MS for the MIV _Blood Glucose Measurement_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)).  

<div style="width: 80%;">
  <img src="assets/images/HDDT_Informationsmodell_MIV_Blood_Glucose.svg" style="width: 100%;" />
</div>

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.md) for details). The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html). For the MIV _Blood Glucose Measurement_ only the following scopes MUST be set:
```
patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-blood-glucose-measurement
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profile _HDDT Blood Glucose Measurement_
This section discusses the _HDDT Blood Glucose Measurement_ profile, which constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource for representing blood glucose measurements. For the full normative specifiction of this profile see the respective [StructureDefinition](StructureDefinition-hddt-blood-glucose-measurement.html).

#### Snapshot and Differential View of the Profile

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

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-blood-glucose-measurement-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-blood-glucose-measurement.html) for this profile.

#### Conventions and Best Practice

##### Lo and Hi Values
Glucometers usually have lower and upper limits for valid measurements. If a measurement is below or above these limits, the glucometer usually indicates this with a special value (e.g. "LO" or "HI"). These values MUST be recorded at the Device Data Recorder, and a query for device data MUST return such values as valid Observations. To indicate that the actual value is below or above the measurable range, the `valueQuantity.value` element MUST be set to the respective limit value and a 'valueQuantity.comparator' element MUST be added with the value `"<"` for "LO" and `">"` for "HI".

Example for a blood glucose measurement below the measurable range (30 mg/dl) of the glucometer:
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
    "value": 30,
    "comparator": "<",
    "unit": "mg/dl",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  },
  "effectiveDateTime": "2025-09-18T08:30:00+01:00",
  "device": {
    "reference": "DeviceMetric/12345"
  }
}
```

##### Quality of Data and Missing Values
This specification makes no assumption, on how the manufacturers of the Personal Health Device and the Device Data Recorder handle failed measurements (e.g. too few capillary blood for a measurement). If such attempts are recorded at the Device Data Recorder, a query for device data must not result in an Observation resource with an invalid or misleading value. Instead, the Observation resource must either be omitted or must indicate the absence of a valid value using the `dataAbsentReason` element. In the second case a `value` MUST NOT be present.

A receiving DiGA SHOULD validate, that the unit defined in `valueQuantity.code` matches the UCUM unit of the LOINC code in the `code` element. If the unit does not match, the DiGA MUST NOT use the value for any calculations or display.

This specification makes no assumption, on how the manufacturers of the Personal Health Device and the Device Data Recorder handle data from uncalibrated devices. If such data is provided by the Device Data Recorder, the `device` element MUST reference a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource that indicates the calibration status of the sensor. If the `device` element does not reference a DeviceMetric resource, the DiGA MUST assume that the provided data originates from a calibrated sensor.  

#### Examples

The following object diagram the relationships between the FHIR resources involved in representing blood glucose measurements according to the [HDDT Information Model](information-model-html) and the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile for two concrete instances of a blood glucose measurement. For readability reasons, some external references are only shown for the first measurement. Elements that are not mandatory oder MS for the MIV _Blood Glucose Measurement_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)) have been omitted.

<div style="width: 75%;">
  <img src="assets/images/HDDT_Objektmodell_BZ_Complete.svg" style="width: 100%;" />
</div>

The following code example shows the concrete JSON representation of the _HDDT Blood Glucose Measurement 1_ resource shown in the object diagram.

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
    "value": 120,
    "unit": "mg/dL",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dl"
  },
  "effectiveDateTime": "20250926T:16:30+02:00"
  "device": {
    "reference": "DeviceMetric/12345"
  }
}
```

### MIV-specific Endpoints and Interactions
#### Observation - READ
Manufactures of Device Data Recorders that support the MIV _Blood Glucose Measurement_ MUST implement a _read_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). Observations shared through the _read_ interaction MUST comply with the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile.

#### Observation - SEARCH
Manufactures of Device Data Recorders that support the MIV _Blood Glucose Measurement_ MUST implement a _search_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). Observations shared through the _serach_ interaction MUST comply with the [HDDT Blood Glucose Measurement](StructureDefinition-hddt-blood-glucose-measurement.html) profile. 



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
    },
    "device": {
        "reference": "DeviceMetric/67"
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
