### Introduction
This document describes the generic FHIR API for standardized access to medical device/implant data as FHIR resources for authorized DiGA. The endpoints for the medical aid API have both generic and use-case-specific components.

The linked documents define the generic API definition—the API specification that is shared among different types of medical aid backends. The use-case-specific specification can be found under the menu **MIV-Specific APIs**.

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| RESTful FHIR R4 API | rfc8705 | **No** certificate-bound access tokens<br>Manufacturer-specific access tokens | Security: Mutual-TLS Client Authentication |

### Endpoints
A HiMi manufacturer MUST implement the following endpoints, for the purpose of allowing DiGA to access data from personal health devices and medical aids.

- [API: CapabilityStatement (Metadata)](fhir-api-metadata.html)
- [API: Observation (Measurement data)](fhir-api-observation.html)
- [API: DeviceMetric (Device calibration)](fhir-api-devicemetric.html)
- [API: Device (Device instance and configuration)](fhir-api-device.html)

