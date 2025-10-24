This chapter provides obligations and hints for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Continuous Glucose Measurement_.

This chapter builds on the [HDDT Information Model](information-model.html), the [HDDT Generic FHIR API](himi-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constraints these guidelines with respect to the specific requirements for exposing continuous glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html)
- The relevant FHIR profile for continuous glucose measurement and how it constraints and extends the [HDDT Information Model](information-model.html)
- Conventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Continuous Glucose Measurement_

- MUST implement and operate a FHIR Resource Server as defined in this chapter,
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HIIS-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server

The Device Data Recorder's FHIR Resource Server gives DiGA access to continuoulsy measured data and related information about metrics and devices. A Device Data Recorder's FHIR Resource Server that serves the MIV _Continuous Glucose Measurement_ MUST implement the following endpoints and profiles:

- retrieval of the Resource Server's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](fhir-api-metadata.html).
- HDDT common RESTful interactions on a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) endpoint that implements the [HDDT Sensor Type and Calibration Status](StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-devicemetric.html).
- HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-device.html).
- MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Continuous Glucose Measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) profile. These interactions and the underlying profile are specific for implementing the MIV _Continuous Glucose Measurement_. The full specifications are given below.

The figure below shows the adaption of the [HDDT Information Model](information-model.html) for the MIV _Continuous Glucose Measurement_. Elements denoted as _[1..1]_ are mandatory oder MS for the MIV _Continuous Glucose Measurement_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)).

<figure>
<div class="gem-ig-svg-container" style="width: 80%;">
  {% include HDDT_Informationsmodell_MIV_Cont_Glucose.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Profiling of the HDDT Information Model for the MIV Continuous Glucose Measurement</em></figcaption>
</figure>

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.html) for details). The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html). For the MIV _Continuous Glucose Measurement_ only the following scopes MUST be set:

```
patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profile _HDDT Continuous Glucose Measurement_

This section discusses the _HDDT Continuous Glucose Measurement_ profile, which constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource for representing continuous glucose measurements. For the full normative specifiction of this profile see the respective [StructureDefinition](StructureDefinition-hddt-continuous-glucose-measurement.html).

#### Snapshot View of the Profile

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

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-continuous-glucose-measurement-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-continuous-glucose-measurement.html) for this profile.

#### Conventions and Best Practice

##### Lo and Hi Values

Real-Time Continuous Glucose Monitoring devices (rtCGM) usually have lower and upper limits for valid measurements. If a measurement is below or above these limits, the rtCGM usually indicates this with a special value (e.g. "LO" or "HI"). These values MUST be recorded at the Device Data Recorder, and a query for device data MUST return such values as valid Observations. To indicate that the actual value is below or above the measurable range, a respective indicater ("L" for value below the lower limit and "U" for values above the upper limit) MUST be placed in the data list in `valueSampledData.data`. If `valueSampledData.data` contains "L" or "U" values, the Device Data Recorder SHOULD fill the `valueSampledData.lowerLimit` and `valueSampledData.upperLimit` element with the values of the lower and upper limits for valid measurements.

Example for a blood glucose measurement below the measurable range (35 mg/dl) of the rtCGM:

{% include Observation-example-cgm-series-json-html.xhtml %}

**\_Remark**: All examples provided on this page use the German language designations for UCUM-coded `unit` elements. See [German translations of UCUM codes](https://terminologien.bfarm.de/fhir/CodeSystem/ucum-common-units-translation-de-de) for the full list of German translations. For LOINC codes the original English display text is used.\_

##### Quality of Data and Missing Values

The manufacturers of the Device Data Recorder MUST handle missing measurements which occured due to interrupted communication to/from the sensor.

If temporarely no data is available for the full period that is requested by the DiGA, a `valueSampledData` MUST NOT be provided. Instead, the `dataAbsentReason` element MUST be provided with the code `temp-unknown`. The `status` MUST be set to be `preliminary` in this case.

If temporarely no data is available for the full period covered by a chunk, a `valueSampledData` MUST NOT be provided for this chunk. Instead, the `dataAbsentReason` element MUST be provided with the code `temp-unknown` for this chunk. The `status` of this chunk MUST be set to be `preliminary` in this case. Other chunks are filled as usual with a status set to `final`.

If temporarely missing data affects only the last chunk in a response, the available data MUST be provided in `valueSampledData.data` and the `effectivePeriod` MUST cover the full period of the chunk. The `status` MUST be set to be `preliminary`. This signals to the DiGA that the data is incomplete. The `dataAbsentReason` element MUST NOT be used in this case.

The following example shows a chunk of data where onlythe first 20 minutes of the chunk period are filled with data. The remaining 40 minutes of the chunk period are missing.

{% include Observation-example-cgm-series-incomplete-json-html.xhtml %}

A DiGA that receives such a chunk MAY use the logical `id` with consecutive _read_ interactions to just obtain the temporarely missig data.

A receiving DiGA SHOULD validate, that the unit defined in `valueSampledData.origin.code` matches the UCUM unit of the LOINC code in the `code` element. If the unit does not match, the DiGA MUST NOT use the value for any calculations or display.

The following additional example illustrates a case where no data is available for the requested period. In this case, `valueSampledData` is omitted and the Observation explicitly indicates the reason for missing data using `dataAbsentReason = temp-unknown` and sets `status = preliminary`.

{% include Observation-example-cgm-series-data-unavailable-json-html.xhtml %}

This specification makes no assumption, on how the manufacturers of the Personal Health Device and the Device Data Recorder handle data from uncalibrated devices. If such data is provided by the Device Data Recorder, the `device` element MUST reference a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource that indicates the calibration status of the sensor. If the `device` element does not reference a DeviceMetric resource, the DiGA MUST assume that the provided data originates from a calibrated sensor.

#### Examples

The following object diagram the relationships between the FHIR resources involved in representing continuous glucose measurements according to the [HDDT Information Model](information-model.html) and the [HDDT Continuous Glucose Measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) profile for two chunks of a continuous glucose measurement. The fixed chunk size is 1 hour, and the measurement interval is 5 minutes. Thus, each chunk contains 12 measurements. The later chunk is incomplete because measurements for the last 40 minutes are pending.
Elements that are not mandatory oder MS for the MIV _Contiuous Glucose Measurement_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)) have been omitted.

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Objektmodell_CGM_Complete.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT Object Model Example (Continuous Glucose Measurement)</em></figcaption>
</figure>
The following code example shows the concrete JSON representation of the _HDDT Continuous Glucose Measurement 1_ resource shown in the object diagram.

{% include Observation-example-cgm-series-1-json-html.xhtml %}

### MIV-specific Endpoints and Interactions

#### Observation - READ

Manufactures of Device Data Recorders that support the MIV _Continuous Glucose Measurement_ MUST implement a _read_ interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). [Observation](https://hl7.org/fhir/R4/observation.html) resources shared through the _read_ interaction MUST comply with the [HDDT Continuous Glucose Measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) profile.

#### Observation - SEARCH

Manufactures of Device Data Recorders that support the MIV Continuous Glucose Measurement* MUST implement a \_search* interaction on the `/Observation` endpoint of the FHIR Resource Server. The implementation MUST conform to the [HDDT Generic FHIR API](fhir-api-observation.html). [Observation](https://hl7.org/fhir/R4/observation.html) resources shared through the _serach_ interaction MUST comply with the [HDDT Continuous Glucose Measurement](StructureDefinition-hddt-continuous-glucose-measurement.html) profile.

#### Examples - FHIR Search GET

**Request**: GET `/Observation?date=ge2025-09-26`

**Description**: Request all CGM measurements, since the 26st of September. Return a Bundle. This one contains only a single [Observation](https://hl7.org/fhir/R4/observation.html).

**Response:**

```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-cgm-series-1",
            {
                "resourceType": "Observation",
                "id": "example-cgm-series-1",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
                    ]
                },
                "valueSampledData": {
                    "origin": {
                        "system": "http://unitsofmeasure.org",
                        "value": 0,
                        "unit": "mg/dl",
                        "code": "mg/dL"
                    },
                    "period": 300000,
                    "dimensions": 1,
                    "data": "123 122 126 134 129 128 130 131 129 127 127 133"
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "99504-3",
                            "system": "http://loinc.org",
                            "display": "Glucose [Mass/volume] in Interstitial fluid"
                        }
                    ]
                },
                "effectivePeriod": {
                    "start": "2025-09-26T16:00:00Z",
                    "end": "2025-09-26T16:59:59Z"
                },
                "device": {
                    "reference": "DeviceMetric/example-devicemetric-cgm"
                },
                "method": {
                    "coding": [
                        {
                            "code": "463729000",
                            "system": "http://snomed.info/sct",
                            "display": "Point-of-care blood glucose continuous monitoring system (physical object)"
                        }
                    ]
                },
                "note": [
                    {
                        "text": "Example CGM data series with 5-minute intervals over 1 hour (12 samples)."
                    }
                ]
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

**Description:** Use a POST requests, with the search parameters in the request body, to query all [Observation](https://hl7.org/fhir/R4/observation.html) resources that measure interstitial fluid glucose in mg/dL. Response is a Bundle.

**Response:**

```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-cgm-series-1",
            "resource": {
                "resourceType": "Observation",
                "id": "example-cgm-series-1",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
                    ]
                },
                "valueSampledData": {
                    "origin": {
                        "system": "http://unitsofmeasure.org",
                        "value": 0,
                        "unit": "mg/dl",
                        "code": "mg/dL"
                    },
                    "period": 300000,
                    "dimensions": 1,
                    "data": "123 122 126 134 129 128 130 131 129 127 127 133"
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "99504-3",
                            "system": "http://loinc.org",
                            "display": "Glucose [Mass/volume] in Interstitial fluid"
                        }
                    ]
                },
                "effectivePeriod": {
                    "start": "2025-09-26T16:00:00Z",
                    "end": "2025-09-26T16:59:59Z"
                },
                "device": {
                    "reference": "DeviceMetric/example-devicemetric-cgm"
                },
                "method": {
                    "coding": [
                        {
                            "code": "463729000",
                            "system": "http://snomed.info/sct",
                            "display": "Point-of-care blood glucose continuous monitoring system (physical object)"
                        }
                    ]
                },
                "note": [
                    {
                        "text": "Example CGM data series with 5-minute intervals over 1 hour (12 samples)."
                    }
                ]
            },
            "search": {
                "mode": "match"
            }
        },
        {
            "fullUrl": "https://himi.example.com/fhir/Observation/example-cgm-series",
            "resource": {
                "resourceType": "Observation",
                "id": "example-cgm-series",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
                    ]
                },
                "valueSampledData": {
                    "origin": {
                        "system": "http://unitsofmeasure.org",
                        "value": 0,
                        "unit": "mg/dl",
                        "code": "mg/dL"
                    },
                    "period": 300000,
                    "dimensions": 1,
                    "data": "110 111 112 113 114 115 116 117 118 119 120 90"
                },
                "status": "final",
                "code": {
                    "coding": [
                        {
                            "code": "99504-3",
                            "system": "http://loinc.org",
                            "display": "Glucose [Mass/volume] in Interstitial fluid"
                        }
                    ]
                },
                "effectivePeriod": {
                    "start": "2025-09-26T17:00:00Z",
                    "end": "2025-09-26T17:59:59Z"
                },
                "device": {
                    "reference": "DeviceMetric/example-devicemetric-cgm"
                },
                "method": {
                    "coding": [
                        {
                            "code": "463729000",
                            "system": "http://snomed.info/sct",
                            "display": "Point-of-care blood glucose continuous monitoring system (physical object)"
                        }
                    ]
                },
                "note": [
                    {
                        "text": "Example CGM data series with 5-minute intervals over 1 hour (12 samples)."
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

### FHIR Operation : HDDT CGM Summary

This operation and the related profiles define the exchange of aggregated measurement data for the Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". The operation provides a patient's glucose profile for a defined period.

#### Profile

The _HDDT CGM Summary_ profile constrains the FHIR [Bundle](https://hl7.org/fhir/R4/bundle.html) resource for a glucose profile that is calculated from continuous glucose measurement data (e.g. from a CGM sensor). The profile covers the machine-readable parts of the [_HL7 CGM summary profile_](https://build.fhir.org/ig/HL7/cgm/).

The Bundle is of type _collection_ and MUST contain only resources of the following types:

- Observations conforming to [HL7 CGM profiles](https://build.fhir.org/ig/HL7/cgm/):
  - [CGM Summary Observation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)
  - [Mean Glucose (Mass)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
  - [Mean Glucose (Moles)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
  - [Times in Ranges](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-times-in-ranges.html)
  - [Glycemic Variability Index (GMI)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-gmi.html)
  - [Coefficient of Variation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-coefficient-of-variation.html)
  - [Days of Wear](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-days-of-wear.html)!
  - [Sensor Active Percentage](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-sensor-active-percentage.html)
- Device resources conforming to [HddtPersonalHealthDevice](StructureDefinition-hddt-personal-health-device.html) to provide context about the sensors that contributed to the summary data.

The purpose of this [Bundle profile](StructureDefinition-hddt-cgm-summary.html) is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic. It ensures interoperability across different implementations by defining a predictable response format. This supports use cases such as:

- Retrieval of CGM summary metrics over a given time interval in support for the upcoming digital disease management program (dDMP) on Diabetes, e.g. for
  - continuous therapy monitoring and adjustment
  - forwarding key data to treating physicians, e.g. for clinical decision support
  - supporting asynchonous telemonitoring by ad hoc provisioning of condensed status information
- Combining aggregated measurement data and device metadata for downstream applications such as visualization or compliance monitoring

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

The Observation profile for the CGM summary report is defined by HL7: [StructureDefinition-cgm-summary](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)

#### Operation `$hddt-cgm-summary`

|                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Resource**       | Observation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Operation name** | `$hddt-cgm-summary`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Purpose**        | Request a CGM Summary Report containing CGM key values for a defined range of time.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Parameters**     | See below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Result**         | A Bundle containing one Observation resource conforming to the [HDDT CGM Summary](StructureDefinition-hddt-cgm-summary.html) profile. If the `related` parameter is set to true, the Bundle also contains all [Device](StructureDefinition-hddt-personal-health-device.html) resources for the sensors that contributed to the report.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| **Specifications** | The CGM summary report is calculated at request-time. From the Device Data Recorder's perspective, the report is a snapshot solely assembled for a volatile request. Therefore the Device Fata Recorder MAY not persist the report. The Device Data Recorder MAY assign a logical `id` to the report that is not addressable or MAY even omit the logical is (see last paragraph in https://hl7.org/fhir/R4/resource.html#id). As a consequence a _read_ interaction for a given `id` MAY result in an _404 Not Found_ error. <br> The Device Data Recorder MUST support all Observation profiles listed in the [hddt-cgm-summary bundle](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-hddt-cgm-summary.html). If the Device Data Recorder does not support some of these observations it MUST for these observations provide Observation Resources with no `value[x]` and `dataAbsentReason` set to _unknown_. |

##### Request Parameters

All parameters are provided in the request body as JSON, following the [FHIR Parameters](https://hl7.org/fhir/R4/parameters.html) resource pattern.

| Parameter              | Type     | Required | Description                                                                                                     |
| ---------------------- | -------- | -------- | --------------------------------------------------------------------------------------------------------------- |
| `effectivePeriodStart` | dateTime | Optional | Start of the effective time period that is to be covered by the requested report.                               |
| `effectivePeriodEnd`   | dateTime | Optional | End of the effective time period that is to be covered by the requested report                                  |
| `related`              | boolean  | optional | When set to true, the result bundle includes Device resources for the sensors from which the data was measured. |

A Device Data Recorder MUST support all listed parameters.

If no start for the effective period is specified, the Device Data Recorder selects a time range starting from the current date, which MUST cover at least 7 days into the past. If there is no data available for the full period, the Device Data Recorder MAY return an error.

If no end for the effective period is specified, the end date is assumed to be the current date. If the period is shorter than 7 days, the Device Data Recorder MAY return an error.

If neither a start time nor an end time is give, the Device Data Recorder selects a time range starting from the current date, which MUST cover at least 7 days into the past. If there is no data available for the full period, the Device Data Recorder MAY return an error.

The Summary-Operation MUST support a minimal duration of 7 days for the effective period, and an error MAY be returned if the client requests a shorter time period.

#### Examples

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

Perform the FHIR [Operation](https://hl7.org/fhir/R4/operationdefinition.html) to request a summary of aggregated values over the specified time range. The [Bundle](StructureDefinition-hddt-cgm-summary.html) should also include all [Device](StructureDefinition-hddt-personal-health-device.html) resource instances, that were needed to calculate the data summary.

**Response:**

{% include Bundle-example-cgm-summary-bundle-json-html.xhtml%}

#### Example OperationOutcome - Unknown Parameter

**Description:** Occurs a parameter that is not supported by the operation is sent in the request body.

{% include OperationOutcome-HddtCgmSummaryOutcomeUnknownParam-json-html.xhtml %}

#### Example OperationOutcome - No Matches

**Description:** While a FHIR search interaction that finds no matches returns an empty [Bundle](https://hl7.org/fhir/R4/bundle.html), this Operation returns an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html).

{% include OperationOutcome-HddtCgmSummaryOutcomeNoResults-json-html.xhtml %}

#### Example OperationOutcome - Invalid Format

**Description:** Parameters `effectivePeriodStart` and `effectivePeriodEnd` are defined to take in `date` as parameter type. If the requested date cannot be parsed by the server, the following [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) is returned.

{% include OperationOutcome-HddtCgmSummaryOutcomeInvalid-json-html.xhtml %}

#### Example OperationOutcome - Bad Syntax

**Description:** Appears when a request is malformed or invalid according to the FHIR specification, for example, the request body is not valid JSON or XML or required elements are missing or incorrectly formatted.

{% include OperationOutcome-HddtCgmSummaryOutcomeBadSyntax-json-html.xhtml %}