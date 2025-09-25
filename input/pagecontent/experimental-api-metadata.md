# Experimental API: Metadata (CapabilityStatement)

### Introduction

This document describes the `/metadata` endpoint for retrieving the FHIR CapabilityStatement of the server. The CapabilityStatement provides information about supported FHIR version, resource types, profiles, interactions, search parameters, and operations. This endpoint is public and does not require authentication.

---

### Endpoint

| | |
|-|-|
| **Endpoint** | `/metadata` |
| **HTTP Method** | GET |
| **Description** | Provides a FHIR CapabilityStatement with information about supported FHIR version, resources, operations, search parameters, and profiles. |
| **Authentication** | None (public endpoint) |
| **Returned Objects** | FHIR CapabilityStatement |
| **Specifications** | • FHIR version MUST be R4.<br> • Must declare supported FHIR version, resources, operations, search parameters, and profiles.<br> • Supported FHIR Resource types: Device, DeviceMetric, Observation, Bundle.<br> • Supported interactions: read, search-type.<br> • Supported operations: `$cgm-summary-data-report` (on Observation). |
| **Error codes** | `500` (Internal Server Error) |

---

### Example

**Request:** GET `/metadata`

**Response:**
```json
{
  "resourceType": "CapabilityStatement",
  "status": "active",
  "fhirVersion": "4.0.1",
  "format": [
    "json",
    "xml"
  ],
  "rest": [
    {
      "mode": "server",
      "resource": [
        {
          "type": "Device",
          "profile": "Device-Personal-Health-Device",
          "interaction": [
            { "code": "read" },
            { "code": "search-type" }
          ]
        },
        {
          "type": "DeviceMetric",
          "profile": "DeviceMetric-Sensor-Type-and-Calibration-Status",
          "interaction": [
            { "code": "read" },
            { "code": "search-type" }
          ]
        },
        {
          "type": "Observation",
          "profile": "Observation-Blood-Glucose",
          "interaction": [
            { "code": "read" },
            { "code": "search-type" }
          ]
        },
        {
          "type": "Observation",
          "profile": "Observation-CGM-Measurement-Series",
          "interaction": [
            { "code": "read" },
            { "code": "search-type" }
          ],
          "operation": [
            {
              "name": "$cgm-summary-data-report",
              "definition": "Operation to request a summary of CGM values for a specified time range."
            }
          ]
        },
        {
          "type": "Bundle",
          "profile": "Bundle-Search-Summary-Data-Measurements",
          "interaction": [
            { "code": "read" },
            { "code": "search-type" }
          ]
        }
      ]
    }
  ]
}
```