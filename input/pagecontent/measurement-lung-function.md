[comment]: # (List of profile names below for easier replacing. Select -> Change All Occurances)
[comment]: # (HDDT Lung Function Testing --- StructureDefinition-hddt-lung-function-testing.html)
[comment]: # (HDDT Lung Function Reference Value --- StructureDefinition-hddt-lung-reference-value.html)
[comment]: # (HDDT Complete Lung Function Testing --- StructureDefinition-hddt-lung-function-testing-complete.html)

This chapter provides obligations and guidelines for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Lung Function Testing_.

This chapter builds on the [HDDT Information Model](information-model.html), the [HDDT Generic FHIR API](himi-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constraints these guidelines with respect to the specific requirements for exposing lung function testings to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html)
- The relevant FHIR profiles for lung function testing and how they constrain and extend the [HDDT Information Model](information-model.html)
- Conventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Lung Function Testing_:
- MUST implement and operate a FHIR Resource Server as defined in this chapter, 
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HIIS-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server
The Device Data Recorder's FHIR Resource Server gives DiGA access to measured data and related information about devices. A Device Data Recorder's FHIR Resource Server that serves the MIV _Lung Function Testing_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Servers's [Capability Statement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](fhir-api-metadata.html).
* HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-device.html).
* MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/observation.html) endpoint that implements all observation profiles relevant for the MIV _Lung Function Testing_. These interactions and underlying profiles are specific for implementing the MIV. The full specifications are given below.
    - [HDDT Lung Function Testing](StructureDefinition-hddt-lung-function-testing.html)
    - [HDDT Lung Function Reference Value](StructureDefinition-hddt-lung-reference-value.html)
    - [HDDT Complete Lung Function Testing](StructureDefinition-hddt-lung-function-testing-complete.html)

The figure below shows the adaption of the [HDDT Information Model](information-model.html) for the MIV _Lung Function Testing_. Elements denoted as _[1..1]_ or _MS_ are mandatory for the MIV _Lung Function Testing_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)).

<figure>
<div class="gem-ig-svg-container" style="width: 80%;">
  {% include HDDT_Informationsmodell_MIV_Lung_Function.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Profiling of the HDDT Information Model for the MIV Lung Function Testing</em></figcaption>
</figure>

<br clear="all"/>

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.html) for details). The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html). For the MIV _Lung Function Testing_ only the following scopes MUST be set:

```
patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-lung-function-testing
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profiles 
This section discusses the three Lung Function Testing profiles, which constrain the [Observation](https://hl7.org/fhir/R4/observation.html) resource for representing lung function testings, and all necessary supplementary information required for properly presenting and interpreting the results of lung function testings.

#### Observation Profile _HDDT Lung Function Testing_

The [Observation](https://hl7.org/fhir/R4/observation.html) profile _HDDT Lung Function Testing_ represents a single measurement taken with a hand-held peak flow meter or spirometer. It records the raw measured value, either in liters (_L_) or liters per minute (_L/min_), depending whether the measured metric is the Peak Expiratory Flow (PEF) or the Forced Expiratory Volume in one second (FEV1).

For the full normative specification of this profile, see the respective [StructureDefinition](StructureDefinition-hddt-lung-function-testing.html).

##### Snapshot View of the Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-function-testing'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-function-testing'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-function-testing'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-function-testing-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-function-testing-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-function-testing.html) for this profile.

#### Observation Profile _HDDT Lung Function Reference Value_
The [Observation](https://hl7.org/fhir/R4/observation.html) profile _HDDT Lung Function Reference Value_ represents a value, used as a baseline when interpreting individual lung function testings of a patient (see section [Reference Value](#reference-value)).

For the full normative specification of this profile, see the respective [StructureDefinition](StructureDefinition-hddt-lung-function-testing.html) for this profile.

##### Snapshot View of the Profile
<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-reference-value'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-reference-value'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-reference-value'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-reference-value-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-reference-value-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-reference-value.html) for this profile.

#### Observation Profile _HDDT Complete Lung Function Testing_

The [Observation](https://hl7.org/fhir/R4/observation.html) profile _HDDT Complete Lung Function Testing_ represents a percentage-based value, calculated by dividing the individual lung function testing by the reference value.

For the full normative specification of this profile, see the respective [StructureDefinition](StructureDefinition-hddt-lung-function-testing-complete.html) for this profile.

##### Snapshot View of the Profile
<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-function-testing-complete'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-function-testing-complete'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-function-testing-complete'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-function-testing-complete-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-function-testing-complete-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-function-testing-complete.html) for this profile.



#### Conventions and Best Practice

##### Reference Value
The HDDT specification models the reference value as an [Observation](https://hl7.org/fhir/R4/Observation.html), because the PEF reference value is a "personal best", and is thus a measurement that can change periodically. In certain contexts, a FEV1 reference value, measured as a "personal best" may also be applicable.

Typically, the FEV1 reference value is calculated based on the patient's demographical data, but the estimation approach varies. For example, the Global Lung Function Initiative (GLI) guidelines from 2012 state, that a patient's race should be taken into account for the reference value calculation, while the more recent guidelines (GLI 2022) provide a race-neutral formula for the calculation.

For the correct interpretation of the patient's lung function measurement values, it is crucial for physicians to know how exactly the reference value was calculated. In the _HDDT Lung Function Reference Value_ [Observation](https://hl7.org/fhir/R4/Observation.html) profile, the manufacturer of the Device Data Recorder MUST specify a `method`, of how the reference value was created. The manufacturer SHOULD use a code from the _HDDT Lung Function Reference Value Method Codes_ [CodeSystem](https://hl7.org/fhir/R4/CodeSystem.html). Alternatively, the manufacturer MAY provide a plain text description of the method for calculating the reference value.

##### Derived From Element
The FHIR specification for the _MIV Lung Function Testing consists of three separate FHIR profiles. The profile _HDDT Complete Lung Function Testing_ depends on the other two (_HDDT Lung Function Testing_, and _HDDT Lung Function Reference Value_), as it is a calculation, displayed as a percentage, of an individual measurement, divided by the reference value.

In order to properly model this information in the _HDDT Complete Lung Function Testing_ FHIR profile, and provide it to the DiGA, the manufacturer of the Device Data Recorder MUST use the `derivedFrom` element to reference one of each _HDDT Lung Function Testing_ and _HDDT Lung Function Reference Value_ resource instances.

Since the reference value is either a normal value for a population group and is calculated only once, or if it is a "personal best" it changes once every few weeks, multiple complete lung function testings SHOULD reference the same instance of the _HDDT Lung Function Reference Value_ resource. (TODO: Create an example for this)

###  Examples

#### Full example

The following object diagram shows the relationships between the FHIR resources involved in representing the lung function testings according to the [HDDT Information Model](information-model.html). Presented here is an instance of each HDDT [Observation](https://hl7.org/fhir/R4/Observation.html) profile, representing an individual lung function testing. For readability reasons, the relationship between profiles and resource instances, some connections to the Personal Health Device, and elements that are not mandatory or MS for the _MIV Lung Function Testing_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)) have been omitted.

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Objektmodell_LF_Complete.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT Object Model Example (Lung Function Testing)</em></figcaption>
</figure>

<br clear="all"/>

The following code example shows the concrete JSON representation of the _HDDT Lung Function Testing_ resource (FEV1) shown in the object diagram.

{% include Observation-example-fev1-single-measurement-json-html.xhtml %}

The following code example shows the concrete JSON representation of the _HDDT Lung Function Reference Value_ resource shown in the object diagram.

{% include Observation-example-fev1-reference-value-json-html.xhtml %}

The following code example shows the concrete JSON representation of the _HDDT Complete Lung Function Testing_ resource shown in the object diagram.

{% include Observation-example-fev1-relative-value-json-html.xhtml %}

#### Minimal Example

The following object diagram shows a minimal representation of a lung function testing, according to the [HDDT Information Model](information-model.html) taken with a peak flow meter. For readability reasons, the relationship between profiles and resource instances, some connections to the Personal Health Device, and elements that are not mandatory or MS for the _MIV Lung Function Testing_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)) have been omitted.

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Objektmodell_LF_Minimal.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT Object Model Minimal Example (Lung Function Testing)</em></figcaption>
</figure>

<br clear="all"/>

The following code example shows the concrete JSON representation of the _HDDT Lung Function Testing_ resource (PEF) shown in the diagram.

{% include Observation-example-peak-flow-simple-json-html.xhtml %}


### MIV-specific Endpoints and Interactions
#### Observation - READ

Manufacturers of Device Data Recorders that support the MIV _Lung Function Testing_ MUST implement a _read_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). [Observation](https://hl7.org/fhir/R4/observation.html) resources shared through the _read_ interaction MUST comply with the FHIR profiles listed in section [FHIR Resource Server](#fhir-resource-server) of this chapter.

#### Observation - SEARCH

Manufacturers of Device Data Recorders that support the MIV _Lung Function Testing_ MUST implement a _search_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html), and implement the search parameters listed on page [FHIR Resource Server](himi-diga-api.html#search-parameters). [Observation](https://hl7.org/fhir/R4/observation.html) resources shared through the _search_ interaction MUST comply with the FHIR profiles listed in section [FHIR Resource Server](#fhir-resource-server) of this chapter.

#### Example: FHIR-Search for relative values LOINC code

#### Example: FHIR-READ

**Request:** GET `/Observation/example-fev1-reference-value`

**Description:** With FHIR-read interactions, a client can access a single resource instance by querying its internal ID. In this case it is suitable for obtaining the reference value of a FEV1 measurement, by querying the ID, in the `derivedFrom` of a complete Lung Function Testing. Restrictions by the OAuth scopes apply—if the client is not allowed to read this resource, a 404 error will be returned.

**Response:** Returned object is a single Observation resource.

{% include Observation-example-fev1-reference-value-json-html.xhtml %}


#### Example: FHIR-Search minimal

**Request**: GET `/Observation?code=19935-6&date=2025-12-15`

**Description**: Obtain all of the Observations where `code` is the LOINC code for peak expiratory flow measurements (PEF) on a specific date. OAuth scopes apply, and only Observations are returned that the client is allowed to access.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria.

```json
{
    "resourceType": "Bundle",
    "id": "8f3a5c2d-9b1e-4a7f-8c3d-2e6f9a1b4c5d",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-peak-flow-measurement-1",
            "resource": {
                "resourceType": "Observation",
                "id": "example-peak-flow-measurement-1",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-lung-function-testing"
                    ]
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "19935-6",
                            "system": "http://loinc.org",
                            "display": "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
                        }
                    ]
                },
                "effectiveDateTime": "2025-12-15T08:00:00+01:00",
                "valueQuantity": {
                    "system": "http://unitsofmeasure.org",
                    "value": 580,
                    "code": "L/min",
                    "unit": "L/min"
                },
                "device": {
                    "reference": "Device/example-device-peak-flow-meter"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-peak-flow-measurement-2",
            "resource": {
                "resourceType": "Observation",
                "id": "example-peak-flow-measurement-2",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-lung-function-testing"
                    ]
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "19935-6",
                            "system": "http://loinc.org",
                            "display": "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
                        }
                    ]
                },
                "effectiveDateTime": "2025-12-15T20:30:00+01:00",
                "valueQuantity": {
                    "system": "http://unitsofmeasure.org",
                    "value": 595,
                    "code": "L/min",
                    "unit": "L/min"
                },
                "device": {
                    "reference": "Device/example-device-peak-flow-meter"
                }
            },
            "search": {
                "mode": "match"
            }
        }
    ]
}
```



#### Example: FHIR-Search maximal

**Request**: GET `/Observation?date=2025-12-15&_include=Observation:device`

**Description**: Obtain all of the Observations made on a certain date (the `code` from the _MIV Lung Function Testing_ is implicitely included). OAuth scopes apply, and only Observations are returned that the client is allowed to access.

**Response:** Returned object is a Bundle containing all Observation resource instances matching the search criteria.

```json
{
    "resourceType": "Bundle",
    "id": "a7e4b9c2-3f1d-4e8a-9b2c-5d6f8a1e3c4b",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-fev1-single-measurement",
            "resource": {
                "resourceType": "Observation",
                "id": "example-fev1-single-measurement",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-lung-function-testing"
                    ]
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "20150-9",
                            "system": "http://loinc.org",
                            "display": "FEV1"
                        }
                    ]
                },
                "effectiveDateTime": "2025-12-28T08:00:00Z",
                "valueQuantity": {
                    "system": "http://unitsofmeasure.org",
                    "value": 3.4,
                    "code": "L",
                    "unit": "L"
                },
                "device": {
                    "reference": "Device/example-device-peak-flow-meter"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-fev1-reference-value",
            "resource": {
                "resourceType": "Observation",
                "id": "example-fev1-reference-value",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-lung-reference-value"
                    ]
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "20149-1",
                            "system": "http://loinc.org",
                            "display": "FEV1 predicted"
                        }
                    ]
                },
                "effectivePeriod": {
                    "start": "2025-05-01"
                },
                "valueQuantity": {
                    "system": "http://unitsofmeasure.org",
                    "value": 4.5,
                    "code": "L",
                    "unit": "L"
                },
                "method": {
                    "coding": [
                        {
                            "code": "GLI-2022",
                            "system": "https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-reference-value-method-codes"
                        }
                    ]
                },
                "device": {
                    "reference": "Device/example-device-peak-flow-meter"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-fev1-relative-value",
            "resource": {
                "resourceType": "Observation",
                "id": "example-fev1-relative-value",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-lung-function-testing-complete"
                    ]
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "20152-5",
                            "system": "http://loinc.org",
                            "display": "FEV1 measured/predicted"
                        }
                    ]
                },
                "effectiveDateTime": "2025-12-28T08:00:00Z",
                "valueQuantity": {
                    "system": "http://unitsofmeasure.org",
                    "value": 75.5,
                    "code": "%",
                    "unit": "%"
                },
                "derivedFrom": [
                    {
                        "reference": "Observation/example-fev1-single-measurement"
                    },
                    {
                        "reference": "Observation/example-fev1-reference-value"
                    }
                ],
                "device": {
                    "reference": "Device/example-device-peak-flow-meter"
                }
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Device/example-device-peak-flow-meter",
            "resource": {
                "resourceType": "Device",
                "id": "example-device-peak-flow-meter",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
                    ]
                },
                "status": "active",
                "type": {
                    "coding": [
                        {
                            "code": "528405",
                            "system": "urn:iso:std:iso:11073:10101",
                            "display": "MDC_DEV_SPEC_PROFILE_PEFM"
                        }
                    ]
                },
                "definition": {
                    "reference": "DeviceDefinition/device-definition-peak-flow-001"
                },
                "deviceName": [
                    {
                        "name": "Peak Flow Pro",
                        "type": "user-friendly-name"
                    }
                ],
                "modelNumber": "Smart 2",
                "manufacturer": "HealthTech GmbH",
                "serialNumber": "PFM0011223344",
                "expirationDate": "2027-12-15"
            },
            "search": {
                "mode": "include"
            }
        }
    ]
}
```