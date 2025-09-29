### Introduction

This document describes the `/metadata` endpoint for retrieving the FHIR CapabilityStatement of the server. The CapabilityStatement provides information about supported FHIR version, resource types, profiles, interactions, search parameters, and operations. This endpoint is public and does not require authentication.

---

### Endpoint

|                      |                                                                                                                                                                                                                                                                                                                                  |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Endpoint**         | `/metadata`                                                                                                                                                                                                                                                                                                                      |
| **HTTP Method**      | GET                                                                                                                                                                                                                                                                                                                              |
| **Description**      | Provides a FHIR CapabilityStatement with information about supported FHIR version, resources, operations, search parameters, and profiles.                                                                                                                                                                                       |
| **Authentication**   | None (public endpoint)                                                                                                                                                                                                                                                                                                           |
| **Returned Objects** | FHIR CapabilityStatement                                                                                                                                                                                                                                                                                                         |
| **Specifications**   | • FHIR version MUST be R4.<br> • Must declare supported FHIR version, resources, operations, search parameters, and profiles.<br> • Supported FHIR Resource types: Device, DeviceMetric, Observation, Bundle.<br> • Supported interactions: read, search-type.<br> • Supported operations: `$hddt-cgm-summary` (on Observation). |
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
      ]
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
       "interaction": [{ "code": "read" }, { "code": "search-type" }]
    },
    {
      "type": "DeviceMetric",
      "supportedProfile": [
        "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
      ],
       "interaction": [{ "code": "read" }, { "code": "search-type" }]
    }
  ]
}
```
