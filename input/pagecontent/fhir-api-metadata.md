This document describes the `/metadata` endpoint for retrieving the FHIR CapabilityStatement of the Device Data Recorder. The CapabilityStatement provides information about supported FHIR version, resource types, profiles, interactions, search parameters, and operations. This endpoint is public and does not require authentication.

---

### Endpoint

|                      |                                                                                                                                                                                                                                                                                                                                  |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Endpoint**         | `/metadata`                                                                                                                                                                                                                                                                                                                      |
| **HTTP Method**      | GET                                                                                                                                                                                                                                                                                                                              |
| **Description**      | Provides a FHIR CapabilityStatement with information about supported FHIR version, resources, operations, search parameters, and profiles.                                                                                                                                                                                       |
| **Authentication**   | None (public endpoint)                                                                                                                                                                                                                                                                                                           |
| **Returned Objects** | FHIR CapabilityStatement                                                                                                                                                                                                                                                                                                         |
| **Specifications**   | The CapabilityStatement MUST declare the supported FHIR version. This MUST be R4. <br>&nbsp;<br>The CapabilityStatement MUST declare the supported FHIR resources. These MUST at least be Observation, Device and DeviceMetric. <br>&nbsp;<br>The CapabilityStatement MUST declare the supported [MIV-specific](mivs.html) interactions, operations, search parameters, and profiles.  |
| **Error codes**      | `500` (Internal Server Error)                                                                                                                                                                                                                                                                                                    |

---

### Example

**Request:** GET `/metadata`

**Response:**

```json
{
  "resourceType": "CapabilityStatement",
  "status": "active",
  "fhirVersion": "4.0.1",
  "format": ["json", "xml"],
  "resource": [
    {
      "type": "Observation",
      "supportedProfile": [
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement",
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
      ],
      "interaction": [{ "code": "read" }, { "code": "search-type" }],
      "operation": [
        {
          "name": "hddt-cgm-summary",
          "definition": "https://gematik.de/fhir/hddt/OperationDefinition/hddt-cgm-summary-operation"
        }
      ],
      "searchParam": [{"name": "date", ...}, {"name": "code", ...}]
    },
    {
      "type": "Bundle",
      "supportedProfile": [
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-cgm-summary"
      ]
    },
    {
      "type": "Device",
      "supportedProfile": [
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
      ],
       "interaction": [{ "code": "read" }, { "code": "search-type" }],
      "searchParam": [{"name": "type", ...}]
    },
    {
      "type": "DeviceMetric",
      "supportedProfile": [
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
      ],
       "interaction": [{ "code": "read" }, { "code": "search-type" }],
      "searchParam": [{"name": "source", ...}]
    }
  ]
}
```
