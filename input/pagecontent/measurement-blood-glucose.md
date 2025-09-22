**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

### Introduction

This document provides implementation guidance for manufacturers integrating glucometer data using a RESTful FHIR API. It builds on the [Generic FHIR API](himi-diga-api.html) and describes the specific requirements for exposing blood glucose measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html), including any required FHIR operations.
- The relevant FHIR profiles for blood glucose measurement and how they should be returned by the API.
- Conventions for using FHIR resources to ensure compliance with the [Information model](information-model.html).
- Example requests and responses to support implementation.


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
| **Description** | A DiGA must be able to retrieve blood glucose measurements from this endpoint. Common use cases include retrieving the latest observation, retrieving only observations that measure blood glucose in mg/dL, retrive all measurements accross a certain date range. <br><br> On request, the endpoint should also provide the calibration status (via DeviceMetric), as it is required for the correct interpretation of the measured values. On request the endpoint should also provide the device instance data (via Device). | 
| **Request Parameters** | `/Observation/<id>` - Referring to the internal server id of the Observation.
| **Search Parameters** | Parameters that MUST be supported are:<br> • `code` - Search for Observations of a specific type<br> • `date` - specify a date range <br> • `_include` - optionally include Device and DeviceMetric resources, referenced by `Observation.device`. <br><br> The server MAY support other search parameters, see [FHIR Observation - Search Parameters](https://hl7.org/fhir/R4/observation.html#search) for an overview of all HL7-defined search parameters on Observation resources. |
| **Returned Objects** | • [Observation-Blood-Glucose](StructureDefinition-Observation-Blood-Glucose.html) <br> • [DeviceMetric-Sensor-Type-and-Calibration-Status](StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status.html) <br> • [Device-Personal-Health-Device](StructureDefinition-Device-Personal-Health-Device.html)
| **Error codes** | See [Generic HiMi FHIR API](himi-diga-api.html), for a list of the expected HTTP status codes |

---

#### DeviceMetric

| | |
|-|-|
| **Endpoint** | `/DeviceMetric` |
| **HTTP Method** | GET |
| **Description** | Access device configuration and calibration status. |
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

#### Device

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET |
| **Description** | Retrieve information about the device-instasnce, e.g. glucometer serial number, manufacturer, model name. | 
|**Specifications** | This endpoint has no deviations from the [Generic FHIR API specifications.](himi-diga-api.html) |

---

### MIV-Specific Observation Profile

<div id="tabs-diff">
  <div id="tbl-diff">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['Observation-Blood-Glucose'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['Observation-Blood-Glucose'].basepath}}">
        {{site.data.structuredefinitions['Observation-Blood-Glucose'].basename}}
      </a>
    </p>
    <div id="tbl-diff-inner">
      {% include StructureDefinition-Observation-Blood-Glucose-diff.xhtml %}
      <a name="tx"></a>
      <!-- Terminology Bindings heading in the fragment -->
      {% include StructureDefinition-Observation-Blood-Glucose-tx-diff.xhtml %}

      {% capture invariantsdiff %}
        {% include StructureDefinition-Observation-Blood-Glucose-inv-diff.xhtml %}
      {% endcapture %}
      <!-- 218 is size of empty table -->
      {% unless invariantsdiff.size <= 218 %}
        <a name="inv-diff"></a>
        <!-- Constraints heading in the fragment -->
        {% include StructureDefinition-Observation-Blood-Glucose-inv-diff.xhtml %}
      {% endunless %}
    </div>
  </div>
</div>

#### Conventions and Best-Practice

- Always use the latest version of the Observation profile.
- Only `valueQuantity` is permitted as the result of the Observation for blood glucose measurements.
- The `code` element must be selected from the [Blood Glucose ValueSet](ValueSet-vs-blood-glucose.html), reflecting both the measurement method and the units supported by the device.
- The unit defined in the LOINC code’s display must align with both `valueQuantity.unit` and `valueQuantity.code`.
- Because glucometers can generate and transmit readings even when uncalibrated, a reference to a [DeviceMetric](StructureDefinition-DeviceMetric-Sensor-Type-and-Calibration-Status.html) resource via the `device` element is required to capture the calibration status of the sensor, in order to ensure the proper interpretation of the data.
- If `valueQuantity` is missing, a `dataAbsentReason` must be specified, giving the reason for missing data.
- Set `status` to "final" for completed measurements.


#### Examples

**Example: Blood Glucose Observation Resource**

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

### FHIR RESTful Interactions

Manufacturers MUST support the following interactions for the Observation resource:

#### READ

Retrieve a single Observation by its resource ID.

**Example:**  
`GET /Observation/{id}`

#### SEARCH

Search for Observations using supported parameters.

**Example:**  
`GET /Observation?code=2339-0&date=ge2025-09-01`

Supported search parameters: `code`, `date`, `_include` (for DeviceMetric).

### Conventions for DeviceMetric and Device Resources

- `/DeviceMetric` and `/Device` endpoints only support read by resource ID.
- Do not support `_include` or `?_id=` queries.
- Refer to [himi-diga-api.md](himi-diga-api.html) for generic implementation details.
- DeviceMetric should capture calibration and configuration status.
- Device should provide manufacturer, serial number, and device type.