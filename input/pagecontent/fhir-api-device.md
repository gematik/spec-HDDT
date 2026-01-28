This document describes the syntax and semantics of querying FHIR [Device](https://hl7.org/fhir/R4/device.html) resources via the standard FHIR RESTful API. A [Device](https://hl7.org/fhir/R4/device.html) resource represents individual Personal Health Devices (medical aids and implants) of a patient, such as glucometers, CGM sensors, and pacemakers. 

To be compliant with § 374a SGB V, a Device Data Recorder MUST implement interactions for reading and searching Device resources:
- [reading](#device---read) individual [Device](StructureDefinition-hddt-personal-health-device.html) resources that are referenced by [Observation](mivs.html) or [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources,
- [version specific reading](#device---vread) individual Device resources that are referenced by [Observation](mivs.html) or [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resources. This interaction MAY be omitted by a Device Data Recorder if it does not support versioning of [Device](StructureDefinition-hddt-personal-health-device.html) resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to implement versioning of [Device](StructureDefinition-hddt-personal-health-device.html) resources). 
- [searching](#device---search) for [Device](StructureDefinition-hddt-personal-health-device.html) resources linked with the current patient and an authorised MIV

Returned resources MUST conform to the [_HDDT Personal Health Device_](#profile---hddt-personal-health-device) Device profile.

### Endpoints

#### Device - READ

| | |
|-|-|
| **Endpoint** | `[base]/Device/<id>` |
| **HTTP Method** | GET |
| **Interaction** | READ |
| **Description** | Retrieve a single [Device](StructureDefinition-hddt-personal-health-device.html) resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id). The returned Device MUST conform to the [_HDDT Personal Health Device_](StructureDefinition-hddt-personal-health-device.html) profile. All constraints and obligations of the standard [FHIR `read` interaction](https://hl7.org/fhir/R4/resource.html#id) apply. |
| **Request Parameters** | `id` - logical ID of the [Device](StructureDefinition-hddt-personal-health-device.html). |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return a [Device](StructureDefinition-hddt-personal-health-device.html) resource that is linked to the patient who is associated with the token. Provided [Device](StructureDefinition-hddt-personal-health-device.html) resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).  |
| **Returned Objects** | HDDT Personal Health Device resource. If no matching resource exists or if the matching resource cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical `id` of a Device resource are an `Observation.device` reference, a `DeviceMetric.source` reference or a _search_ interaction for Personal Health Devices of the given patient. <br>A DiGA MAY read a Device resource in order to validate the `status` of a Personal Health Device. E.g. a `status` value _unknown_  is interpreted within HDDT to indicate that the Device Data Recorder currently has no connection to the device hardware, e.g. due to interrupted communication. <br>A Device Data Recorder MUST NOT disclose information to a DiGA that allows the DiGA to identify the patient as a natural person. Respective guidance on the use of the `Device.patient` element is given in the [Security and Privacy](security-and-privacy.html#identification-and-authentication-of-the-patient) chapter of this specification. |
| **Error codes** | `400` (Bad Request), `401` (Unauthorized), `404` (Not Found), `500` (Internal Server Error)<br><br>See [Error Codes](error-codes.html#resource-server-errors) for complete error response formats, headers, and detailed scenarios. |

---

#### Device - VREAD

__Remark:__ A Device Data Recorder MAY omit the version specific read interaction if it does not support versioning of Device resources (see [Retrieving Data](retrieving-data.html#versioning-of-device-and-devicemetric-resources) for a discussion on how to express changes of device properties).

| | |
|-|-|
| **Endpoint** | `[base]/Device/<id>/_history/<versionId>` |
| **HTTP Method** | GET |
| **Interaction** | VREAD |
| **Description** | Retrieve a single Device resource by its [logical id](https://hl7.org/fhir/R4/resource.html#id) and [versionId](https://hl7.org/fhir/R4/resource.html#metadata). The returned Device resource MUST conform to the _HDDT Personal Health Device_ profile. All constraints and obligations of the standard [FHIR `vread` interaction](https://hl7.org/fhir/R4/http.html#vread) apply. |
| **Request Parameters** | `id` - logical ID of the [Device](StructureDefinition-hddt-personal-health-device.html) resource <br>`versionId` - version identifier of the [Device](StructureDefinition-hddt-personal-health-device.html) resource |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return versions of [Device](StructureDefinition-hddt-personal-health-device.html) resources that can be linked to the patient who is associated with the token. Provided [Device](StructureDefinition-hddt-personal-health-device.html) resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor). |
| **Returned Objects** | _HDDT Personal Health Device_ resource. If no matching resource or version exists or if the matching resource or version cannot be returned, an error response MUST be sent (see below). |
| **Specifications** | The only ways for a DiGA to obtain the logical id and the versionId of a [Device](StructureDefinition-hddt-personal-health-device.html) resource are an `Observation.device` reference, a `DeviceMetric.source` reference, or a 'search' interaction for [Device](StructureDefinition-hddt-personal-health-device.html) resources of the given patient. |
| **Error codes** | `400` (Bad Request), `401` (Unauthorized), `404` (Not Found), `500` (Internal Server Error)<br><br>See [Error Codes](error-codes.html#resource-server-errors) for complete error response formats, headers, and detailed scenarios. |

---

#### Device - SEARCH

| | |
|-|-|
| **Endpoint** | `/Device` |
| **HTTP Method** | GET / POST |
| **Interaction** | SEARCH |
| **Description** | Search for [Device](StructureDefinition-hddt-personal-health-device.html) resources.  |
| **Authorization** | OAuth2 Bearer token REQUIRED. The resource server MUST only return [Device](StructureDefinition-hddt-personal-health-device.html) resources that are linked to the patient who is associated with the token. Provided [Device](StructureDefinition-hddt-personal-health-device.html) resources MUST match the requestor's granted scopes (see [Smart Scopes](smart-scopes.html) for the compartment semantics that MUST be used for validating the authorization of the requestor).<br>  |
| **Search Parameters** | A full list of the search parameters that this endpoint MUST support, can be found on page [FHIR Resource Server](himi-diga-api.html#search-parameters).<br>The resource server MUST be able to discover the patient identifier from the Access Token. This identifier MUST implicitly be considered as the `patient` argument with every _search_ request for [Device](StructureDefinition-hddt-personal-health-device.html) resources. If a DiGA explicitly provides a `patient` argument with a query, the resource server MUST ignore this argument and SHOULD respond with a `400 Bad Request` error.<br>The resource server MAY support any standard FHIR Device search parameters. |
| **Returned Objects** | [Bundle](https://hl7.org/fhir/R4/bundle.html) containing [Device](StructureDefinition-hddt-personal-health-device.html) entries that match the query. <br>If no matching [Device](StructureDefinition-hddt-personal-health-device.html) resources are found, an empty [Bundle](https://hl7.org/fhir/R4/bundle.html) MUST be returned.  |
| **Specifications** | After successful [pairing](pairing.html) with a Device Data Recorder a DiGA SHOULD discover the Personal Health Devices of the patient by searching for Device resources. The DiGA MAY use search parameters to filter the results, e.g. by `device-name` or `type`. The DiGA SHOULD present the discovered `Device.serialNumber` to the patient to allow him to verify the result of the pairing process.<br>The resource server MAY support the `_include:definition` parameter to allow including referenced DeviceDefinition resources in the response bundle. <br> All constraints and obligations of the standard [FHIR `search` interaction](https://hl7.org/fhir/R4/http.html#search) apply.
 |
| **Error codes** | `400` (Bad Request), `401` (Unauthorized), `500` (Internal Server Error)<br><br>See [Error Codes](error-codes.html#resource-server-errors) for complete error response formats, headers, and detailed scenarios. |

---

### Profile - HDDT Personal Health Device

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-personal-health-device'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-personal-health-device'].basepath}}">
        {{site.data.structuredefinitions['hddt-personal-health-device'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-personal-health-device-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

---

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-personal-health-device-dict-diff.xhtml%}
    </div>
</div>


### Example: Glucometer 

In this example the patient uses a glucometer that is connected to the Device Data Recorder via Bluetooth. The glucometer is used to perform blood glucose measurements that are stored as [Observation](mivs.html) resources in the Device Data Recorder. Each Observation references the [Device](StructureDefinition-hddt-personal-health-device.html) resource that represents the glucometer (either directly or through a [DeviceMetric](StructureDefinition-hddt-sensor-type-and-calibration-status.html) resource).

The glucometer used in this example is the product _GlukkCheck plus mg/dl_ from _Glukko Inc._. The glucometer performs measurements from capillary blood. The vendor-defined model number of this type of devices is CGPA987654 and the serial number of the patient's individual device is SN123456. Both identifiers are printed on the back of the device and allow the patient to validate the authenticity of this Personal Health Device resource.

Remarks:
- As glucometers do not expire (that is just the case for the test strips), the `expirationDate` is not set, even though this element is set to _Must Support_ in the profile.
- The `text` element is omitted in this example to keep the example small. Nevertheless, as all HDDT resources are intended for sole machine processing, the `text` element MAY be omitted.

#### Device - READ

**Request:** GET `/Device/example-glucometer`

**Response:**

{% include Device-example-glucometer-json-html.xhtml %}

#### Device - SEARCH

**Request:** GET `/Device`

**Response:**
```json
{
    "resourceType": "Bundle",
    "type": "searchset",
    "entry": [
        {
            "fullUrl": "https://example.com/fhir/Device/example-glucometer",
            "resource": {
                "resourceType": "Device",
                "id": "example-glucometer",
                "meta": {
                    "profile": [
                        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
                    ]
                },
                "type": {
                    "coding": [
                        {
                            "code": "528401",
                            "system": "urn:iso:std:iso:11073:10101",
                            "version": "20250520",
                            "display": "Glucose Monitor"
                        }
                    ]
                },
                "status": "active",
                "deviceName": [
                    {
                        "name": "GlukkoCheck plus mg/dL",
                        "type": "user-friendly-name"
                    }
                ],
                "manufacturer": "Glukko Inc.",
                "serialNumber": "SN123456",
                "modelNumber": "CGPA987654",
                "definition": {
                    "reference": "DeviceDefinition/example-glucometer-def"
                }
            },
            "search": {
                "mode": "match"
            }
        }
    ]
}
```

### Example: rtCGM Sensor

This example describes a real-time Continuous Glucose Monitoring sensor (rtCGM) as a personal health device.

The example sensor is the product _GlukkoCGM 18_ from _Glukko Inc._ that performs continuous glucose measurements from interstitial fluid. The sensor in the example will stop transmitting data on September 10, 2025, and MUST be replaced by the patient at that date. The vendor-defined model number of this type of devices is _GCGMA98765_ and the serial number of the patient's  individual device is _CGM1234567890_. Both identifiers are printed on the package of the device and allow the patient to validate the authenticity of this Personal Health Device resource.

Remarks:
- The `text` element is omitted in this example to keep the example small. Nevertheless, as all HDDT resources are intended for sole machine processing, the `text` element MAY be omitted.

#### Instance of the HDDT Personal Health Device profile

{% include Device-example-device-cgm-json-html.xhtml %}

