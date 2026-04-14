
This chapter provides obligations and hints for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Blood Pressure Monitoring_. For an overview of this MIV including typical use cases and key values, see the [Blood Pressure Monitoring domain](mivs.html#domain-blood-pressure-monitoring) chapter.

This chapter builds on the [HDDT Information Model](information-model.html), the [HDDT Generic FHIR API](ddr-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constrains these guidelines with respect to the specific requirements for exposing blood pressure monitoring to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](ddr-diga-api.html)
- The relevant FHIR profile for blood pressure monitoring and how it constrains and extends the [HDDT Information Model](information-model.html)
- Conventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Blood Pressure Monitoring_

- MUST implement all requirements expressed through the RFC 2119 keywords defined in [Conventions - Use of Keywords](conventions.html#use-of-keywords). These keywords (MUST, SHOULD, MAY, etc.) are used throughout the entire specification to indicate normative requirements.
- MUST implement and operate a FHIR Resource Server as defined in this chapter, 
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HIIS-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server
The Device Data Recorder's FHIR Resource Server gives DiGA access to measured data and related information about devices and device metrics. A Device Data Recorder's FHIR Resource Server that serves the MIV _Blood Pressure Monitoring_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Server's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](fhir-api-metadata.html).
* HDDT common RESTful interactions on a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) endpoint that implements the [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-devicemetric.html).
* HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-device.html).
* MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Blood Pressure Value](StructureDefinition-hddt-blood-pressure-value.html) profile. These interactions and the underlying profile are specific for implementing the MIV _Blood Pressure Monitoring_. The full specifications are given below.

The figure below shows the adaption of the [HDDT Information Model](information-model.html) for the MIV _Blood Pressure Monitoring_. Elements denoted as _[1..1]_ are mandatory or MS for the MIV _Blood Pressure Monitoring_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)). 

<figure>
<div class="gem-ig-svg-container" style="width: 100%;">
  {% include HDDT_Informationsmodell_MIV_Blood_Pressure.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Profiling of the HDDT Information Model for the MIV Blood Pressure Monitoring</em></figcaption>
</figure>

<br clear="all">

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.html) for details). The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html). For the MIV _Blood Pressure Monitoring_ only the following scopes MUST be set:
```
patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-pressure-value
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profile _HDDT Blood Pressure Monitoring_
This section discusses the _HDDT Blood Pressure Monitoring_ profile, which constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource for representing blood pressure monitoring. For the full normative specification of this profile see the respective [StructureDefinition](StructureDefinition-hddt-blood-pressure-value.html).

#### Snapshot View of the Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-blood-pressure-value'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-blood-pressure-value'].basepath}}">
        {{site.data.structuredefinitions['hddt-blood-pressure-value'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-blood-pressure-value-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {% include StructureDefinition-hddt-blood-pressure-value-dict-diff.xhtml %}
    </div>
</div> 

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-blood-pressure-value.html) for this profile.

#### Conventions and Best Practice

Blood pressure measurements MUST be represented using the LOINC panel code 85354-9 "Blood pressure panel with all children optional" as the main observation code. The actual measurement values (systolic, diastolic, and mean blood pressure) are captured as three mandatory components within the Observation resource. Each component MUST include a value in mmHg (millimeters of mercury) using the UCUM code `mm[Hg]`.

##### Patient Reference and Privacy
For privacy and data protection, the `subject` reference MUST only use pseudonymized or anonymized identifiers. Direct patient identification is not permitted. The patient MUST NOT be identified directly through personally identifiable information such as name, insurance number, or other identifying attributes.

##### Device Reference

Blood pressure devices typically do not require calibration, in which case the device element MUST point to a [Personal Health Device](StructureDefinition-hddt-personal-health-device.html) resource.
For other cases, the specification makes no assumption, on how the manufacturers of the Personal Health Device and the Device Data Recorder handle data from uncalibrated devices. If such data is provided by the Device Data Recorder, the `device` element MUST reference a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource that indicates the calibration status of the sensor. If the `device` element does not reference a DeviceMetric resource, the DiGA MUST assume that the provided data originates from a calibrated sensor.  

#### Examples

The following object diagram the relationships between the FHIR resources involved in representing Blood Pressure Monitorings according to the [HDDT Information Model](information-model.html) and the [HDDT Blood Pressure Value](StructureDefinition-hddt-blood-pressure-value.html) profile instances of a blood pressure measurement. For readability reasons, some external references are only shown for the first measurement. Elements that are not mandatory or MS for the MIV _Blood Pressure Monitoring_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)) have been omitted.

<figure>
<div class="gem-ig-svg-container" style="width: 100%;">
  {% include HDDT_Objektmodell_BPM_Complete.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT Object Model Example (Blood Pressure Monitoring)</em></figcaption>
</figure>

<br clear="all"/>

The following code example shows the concrete JSON representation of the _HDDT Blood Pressure Value_ resource shown in the object diagram.

{% include Observation-example-blood-pressure-value-json-html.xhtml %}


### MIV-specific Endpoints and Interactions
#### Observation - READ
Manufacturers of Device Data Recorders that support the MIV _Blood Pressure Monitoring_ MUST implement a _read_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). Observations shared through the _read_ interaction MUST comply with the [HDDT Blood Pressure Value](StructureDefinition-hddt-blood-pressure-value.html) profile.

#### Observation - SEARCH
Manufacturers of Device Data Recorders that support the MIV _Blood Pressure Monitoring_ MUST implement a _search_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html), and implement the **search parameters** listed on page [FHIR Resource Server - Search Parameters](ddr-diga-api.html#search-parameters). Observations shared through the _search_ interaction MUST comply with the [HDDT Blood Pressure Value](StructureDefinition-hddt-blood-pressure-value.html) profile.
Blood pressure measurements use a panel code 85354-9 _Blood pressure panel with all children optional_ as the main `Observation.code`, while the actual measurement values (8480-6 _Systolic blood pressure_, 8462-4 _Diastolic blood pressure_, 8478-0 _Mean blood pressure_) are captured in `Observation.component` elements. To search for specific component types (e.g., systolic blood pressure with LOINC code 8480-6), use the `component-code` search parameter. See the example below for details. 



#### Example: FHIR-READ

**Request:** GET `/Observation/example-blood-pressure-value`

**Description:** With FHIR-read interactions, a client can access a single resource instance by querying its internal ID. Restrictions by the OAuth scopes apply—if the client is not allowed to read this resource, a 404 error will be returned.

**Response**: Returned object is a single Observation resource.

{% include Observation-example-blood-pressure-value-json-html.xhtml %}


### Example: FHIR-Search for specific LOINC code

**Request**: GET `/Observation?component-code=8480-6`

**Description**: Obtain all Observations that contain a component with the LOINC code `8480-6` for `Systolic blood pressure`. OAuth scopes apply, and only Observations are returned that the client is allowed to access.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria.

```json
{
    "resourceType": "Bundle",
    "id": "7483defc-9e6c-5bca-bf7c-76ecc4941293",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-blood-pressure-value",
            "resource": {
                "resourceType": "Observation",
                "id": "example-blood-pressure-value",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-pressure-value"
                    ]
                },
                "status": "final",
                "category": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                "code": "vital-signs"
                            }
                        ]
                    }
                ],
                "code": {
                    "coding": [
                        {
                            "code": "85354-9",
                            "system": "http://loinc.org",
                            "display": "Blood pressure panel with all children optional"
                        }
                    ]
                },
                "subject": {
                    "reference": "Patient/patientExample"
                },
                "effectiveDateTime": "2025-10-23T09:15:00+02:00",
                "device": {
                    "reference": "Device/example-device-blood-pressure-cuff"
                },
                "interpretation": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                                "code": "N",
                                "display": "Normal"
                            }
                        ]
                    }
                ],
                "component": [
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8480-6",
                                    "display": "Systolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 120,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8462-4",
                                    "display": "Diastolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 80,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8478-0",
                                    "display": "Mean blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 93,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
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

### Example: FHIR-Search for Component Code and Value

**Request**: GET `/Observation?component-code=8480-6&component-value-quantity=gt130`

**Description**: Search for all blood pressure observations where the systolic blood pressure component (LOINC code 8480-6) AND any component value (_which does not necessarily have to be systolic blood pressure_) is greater than 130 mmHg. 

***Note***: This query searches for observations that contain a component with the code for systolic blood pressure AND any component value greater than 130. However, these conditions are evaluated independently - the component with value >130 does not need to be the systolic blood pressure component. To search for observations where specifically the systolic blood pressure component has a value greater than 130, use the combined parameter: `/Observation?component-code-value-quantity=http://loinc.org|8480-6$gt130`

OAuth scopes apply, and only Observations are returned that the client is allowed to access.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria.

```json
{
    "resourceType": "Bundle",
    "id": "a8f3c21d-4b9e-5fda-ab2c-98ecc5043487",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-blood-pressure-value-1",
            "resource": {
                "resourceType": "Observation",
                "id": "example-blood-pressure-value-1",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-pressure-value"
                    ]
                },
                "status": "final",
                "category": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                "code": "vital-signs"
                            }
                        ]
                    }
                ],
                "code": {
                    "coding": [
                        {
                            "code": "85354-9",
                            "system": "http://loinc.org",
                            "display": "Blood pressure panel with all children optional"
                        }
                    ]
                },
                "subject": {
                    "reference": "Patient/patientExample"
                },
                "effectiveDateTime": "2025-10-24T14:30:00+02:00",
                "device": {
                    "reference": "Device/example-device-blood-pressure-cuff"
                },
                "interpretation": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                                "code": "H",
                                "display": "High"
                            }
                        ]
                    }
                ],
                "component": [
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8480-6",
                                    "display": "Systolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 145,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8462-4",
                                    "display": "Diastolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 92,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8478-0",
                                    "display": "Mean blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 109,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    }
                ]
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-blood-pressure-value-2",
            "resource": {
                "resourceType": "Observation",
                "id": "example-blood-pressure-value-2",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-pressure-value"
                    ]
                },
                "status": "final",
                "category": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                "code": "vital-signs"
                            }
                        ]
                    }
                ],
                "code": {
                    "coding": [
                        {
                            "code": "85354-9",
                            "system": "http://loinc.org",
                            "display": "Blood pressure panel with all children optional"
                        }
                    ]
                },
                "subject": {
                    "reference": "Patient/patientExample"
                },
                "effectiveDateTime": "2025-10-25T08:45:00+02:00",
                "device": {
                    "reference": "Device/example-device-blood-pressure-cuff"
                },
                "interpretation": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                                "code": "H",
                                "display": "High"
                            }
                        ]
                    }
                ],
                "component": [
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8480-6",
                                    "display": "Systolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 138,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8462-4",
                                    "display": "Diastolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 88,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8478-0",
                                    "display": "Mean blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 105,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
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

### Example: FHIR-Search include Device


**Request**: GET `/Observation?date=ge2025-10-22&_include=Observation:device`

**Description**: This query asks the server for all Observations since `2025-10-22`, and also requests that the server include resource instances referenced by `Observation.device`.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria, and all referenced Device resources.

```json
{
    "resourceType": "Bundle",
    "id": "87dbf79c-fb81-5cda-ce8e-87fdd5052395",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-blood-pressure-value",
            "resource": {
                "resourceType": "Observation",
                "id": "example-blood-pressure-value",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-pressure-value"
                    ]
                },
                "status": "final",
                "category": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                                "code": "vital-signs"
                            }
                        ]
                    }
                ],
                "code": {
                    "coding": [
                        {
                            "code": "85354-9",
                            "system": "http://loinc.org",
                            "display": "Blood pressure panel with all children optional"
                        }
                    ]
                },
                "subject": {
                    "reference": "Patient/patientExample"
                },
                "effectiveDateTime": "2025-10-23T09:15:00+02:00",
                "device": {
                    "reference": "Device/example-device-blood-pressure-cuff"
                },
                "interpretation": [
                    {
                        "coding": [
                            {
                                "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                                "code": "N",
                                "display": "Normal"
                            }
                        ]
                    }
                ],
                "component": [
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8480-6",
                                    "display": "Systolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 120,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8462-4",
                                    "display": "Diastolic blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 80,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    },
                    {
                        "code": {
                            "coding": [
                                {
                                    "system": "http://loinc.org",
                                    "code": "8478-0",
                                    "display": "Mean blood pressure"
                                }
                            ]
                        },
                        "valueQuantity": {
                            "value": 93,
                            "unit": "mm[Hg]",
                            "system": "http://unitsofmeasure.org",
                            "code": "mm[Hg]"
                        }
                    }
                ]
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Device/example-device-blood-pressure-cuff",
            "resource": {
                "resourceType": "Device",
                "id": "example-device-blood-pressure-cuff",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
                    ]
                },
                "status": "active",
                "type": {
                    "coding": [
                        {
                            "code": "70665002",
                            "system": "http://snomed.info/sct",
                            "version": "http://snomed.info/sct/11000274103/version/20251115",
                            "display": "Blood pressure cuff, device (physical object)"
                        }
                    ]
                },
                "definition": {
                    "reference": "DeviceDefinition/device-definition-blood-pressure-cuff-001"
                },
                "deviceName": [
                    {
                        "name": "BP Cuff Pro",
                        "type": "user-friendly-name"
                    }
                ],
                "modelNumber": "Digital BT 2",
                "manufacturer": "HealthTech GmbH",
                "serialNumber": "BPC0011223345",
                "expirationDate": "2027-12-15"
            },
            "search": {
                "mode": "include"
            }
        }
    ]
}
```