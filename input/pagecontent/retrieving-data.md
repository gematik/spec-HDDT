**ToDo**
* **hauptsächlich Jörg** - Beschreibt die verschiedene Arten Daten abzufragen
* Motivation und Anforderungen (Jie, Emil)
* grobe Ablaufbeschreibung (Jie, Emil)
* Sequenzdiagramme (Jie, Emil)

# Querying for Device Data

In general, data can be measured in two different scenarios by personal health devices:
* dedicated measurements: scheduled by a defined care plan or triggered by an unscheduled event, the patient performs a measurement using a medical aid. The measurement takes a defined period of time and records single values for one or more data item (e.g. pulse and blood pressure). Typical examples of devices, which are used ad hoc or based on a care plan are blood glucose meters, smart insulin pens, blood pressure cuffs and peak flow meters.
* continuous measurements: The patient is connected to a sensor (almost) all the time and the sensor continuously measures and records data. Typical examples of devices that perform continuous measurements are rtCGM, insulin pumps and pace makers.

In addition, there are also devices and scenarios, which combine both paradigms, e.g.
* personal ECG recorders for recording short, single-channel ECGs based on a plan (e.g. patient is asked to perform a measurement after physical activity)
* pulse oximeters which are used ad hoc, but record data continuously for a certain period of time (e.g. monitoring SPO2 during sleep time of a person suffering from sleep apnea)

The HDDT FHIR API handles dedicated and continuous measurements in different ways. Which flavor of the API is to be used, is part of the FHIR implementation guide of a MIV. For combined scenarios usually the API flavor for continuous measurements is used, because it is much more efficient in transfering sampled data.

## Searching using FHIR search interaction

DiGA request device data from a device data recorder (see [information model](information-model.md])) using a standard FHIR [search interaction](https://hl7.org/fhir/R4/http.html#search) on the [Observation](https://hl7.org/fhir/R4/observation.html) resource type. 
The device data recorder MUST respond to a [search](https://hl7.org/fhir/R4/http.html#search) request with a collection of [Observation](https://hl7.org/fhir/R4/observation.html) resources or with an error.

The request header MUST contain an Access Token acc. to the HDDT [OAuth2 profile](oauth-api.md). This access token was issued by the Authorization Server of the device data recorder and MUST be taken as opaque by the DiGA. 
 
The device data recorder MUST be able to discover the internal patient identifier from the access token. This identifier MUST implicitly be considered as the `subject` argument with every query to the device date recorder's FHIR API. If a DiGA explicitly provides a `subject`argument with a query, the device data recorder MUST ignore this argument and SHOULD respond with an _Invalid Request_ error (see [OpenAPI definition](himi-diga-api.md#openapi-description)).

The device data recorder MUST be able to discover the SMART Scope from tha access token, which were accepted by the device data recorder during pairing with the requesting DiGA (see section [Pairing](pairing.md)). The SMART Scope MUST implicitly be considered as the `code` argument with every query to the device date recorder's FHIR search API. A DiGA MAY explicitly further constrain the scope by providing a `code`argument with a query (see below).

With every FHIR search interaction the requesting DiGA SHOULD provide a `date` argument to set the lower and/or upper bound of the time period for which data is requested. If no `date` is provided with the query, the device data recorder will respond with all data that matches the other (implicit and explicit) query arguments.  

A DiGA MAY further constrain the kind of requested values by providing a `code` argument with the search request. All provided `code`arguments MUST be part of the [ValueSet](https://hl7.org/fhir/R4/valueset.html) that is referenced in the SMART scope that is linked with the Access Token. If a DiGA requests for a code which is not contained with this value set, the device data recorder MUST respond with an 'Invalid Request` error.

`date` and `code` are the only search parameters that DiGA and device data recorders MUST support for all MIVs. A MIV-specific implementation guide MAY request for supporting further search arguments and MAY constrain the use and semantics of these arguments. A device data recorder MAY support even more search parameters in accordance to the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition. In this case these arguments MUST be published through the device data recorders [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html). 

### Paging

In accordance with the [HL7 FHIR specification](https://hl7.org/fhir/R4/http.html#paging), supporting _paging_ is recommended but optional for device data recorders. DiGA manufacturers MUST consider, that a specific device data recorder may only be able to respond with a limited number of [Observation](https://hl7.org/fhir/R4/observation.html) resources in response to a query. 

### Device Status and Device Configuration

Each [Observation](https://hl7.org/fhir/R4/observation.html) resource returend by a device data recorder MUST contain a `device` element that referes to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource. This resource reflects the status of the sensor that was used to measure the obervation. The provided [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) MUST at least 
* provide information about the calibration status of the sensor and 
* refer to the [Device](https://hl7.org/fhir/R4/device.html resource that represents the configuration of the personal health device at the time the measurement was performed.

A device data recorder MAY omit the `device` reference to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) if and only if the sensor is always considered to be calibrated and if there is no way for the patient to validate the calibration status of the sensor or to re-calibrate the sensor. In this case the `device` reference MUST point to a [Device](https://hl7.org/fhir/R4/device.html) resource that represents the configuration of the personal health device at the time the measurement was performed.

If a request from a DiGA searches for historic device data and if the device data recorder does not keep a history of configurations, the respective elements within the provided [Device](https://hl7.org/fhir/R4/device.html) resource MUST be omitted or set to _null_ values. In cases where a search request only sety a lower date and/or time boundary for the requested device data or defines an upper boundary with a point in time in the future, the [Device](https://hl7.org/fhir/R4/device.html) resource MUST provide the current configuration. 

The [Device](https://hl7.org/fhir/R4/device.html) resource MUST contain a `definition` reference to the device's product definition as registered with the BfArM device registry. The reference MUST be given as the canonical url of the [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource that can be obtained from the BfARM device registry. The reference MAY contain a _version_ value.

## Dedicated Measurements

In general HDDT only requests a minimum of data elements to be mandatory with an [Observation](https://hl7.org/fhir/R4/observation.html) resource that reflects a single measurement. The example below is based on the HDDT FHIR impementation guideline for _glucose in capillary blood_. 

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
    "value": 132,
    "unit": "mg/dl",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  },
  "device": {
    "reference": "DeviceMetric/dm234788148233190"
  },
}
```
As the information on the time and result of the measurement is a rather straight-forward adoption of the FHIR standard, some HDDT-specific conventions have to be considered with the `device` reference (see above). The figure blow shows a simple interplay of measured data ([Observation](https://hl7.org/fhir/R4/observation.html)), sensor status ([DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)), and device configuration ([Device](https://hl7.org/fhir/R4/device.html)), e.g. in response for a query for all blood glucose data that was measured for a given patient on May 7th.

<div><img src="/HDDT measurement ad hoc example 1.png" alt="Blood glucose values for a day" width="45%"></div>
<br clear="all"/>

This gets more complex, if the status of the sensor changes. The figure below is based on the previous example, but now data is reqested for a longer period (May 7th and 8th) with the patient calibrating the device within this period.

<div><img src="/HDDT measurement ad hoc example 2.png" alt="Blood glucose values including sensor calibration" width="60%"></div>
<br clear="all"/>

As shown with the example, a calibration of a sensor leads to an update to the sensor's `DeviceMetric` resource. The device data recorder MUST make changes to the calibration status of a sensor make visible to the device data consumer. 

## Continuous Measurements

* Blöcke fester Größe
* letzter Block wird dynamisch aufgefüllt

# Querying for Aggregated or Calculated Data

* keine einzelnen Kennzahlen, sondern nur standardisierte Berichte auf Kennzahlen

# Querying for Configuration Data

* wird erst einmal nicht umgesetzt => BEGRÜNDUNG