**ToDo Jie, Emil, Sergej**
* Also examples of data requests and of the answers


### Observation – Blood Glucose Value
Example of a measured blood glucose value (`92 mg/dL`) with reference to device configuration. The observation includes details such as the measurement time, and links to the device used for measurement.

```
{
  "resourceType": "Observation",
  "id": "345720845ad235ee32",
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
  "effectiveDateTime": "2025-09-02T09:30:00+01:00",
  "valueQuantity": {
    "value": 92,
    "unit": "mg/dl",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  },
  "device": {
    "reference": "DeviceMetric/dm234788148233190"
  },
}
```

### DeviceMetric – Device Configuration
Contains calibration status and measurement unit. This resource provides information about the current configuration of the device, including calibration details, measurement frequency, and unit of measurement.

### Device – Device Instance
Describes manufacturer, model name, and serial number. The device resource documents the physical device used for the measurement, including its unique identifiers, manufacturer information, and model specifications.

These examples illustrate how FHIR resources can be used to represent clinical measurements, device information, and patient data in a standardized way.
