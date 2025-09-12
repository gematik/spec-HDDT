### Status: Draft
* Verantwortlich: @jcaumann
* ToDo:
    * kontinuierliche Daten mit ihren Sonderfällen
    * aggregierte Daten
    * Durchsprache im Team
    * QS (insb. Sprache)

<hr>

The legal requirements of § 374a SGB V specify that a medical aid or implant must be able to provide the following types of data to DiGA via the HDDT interfaces:

* measurement data collected by the personal health device,
* derived or aggregated data,
* therapy plans and configurations stored in the device.

For the first implementation stage of HDDT, only measurement data collected by medical aids and the related calculated metrics will be taken into account.

___Note__: During the analysis of HDDT use cases, possible options were discussed for making therapy settings stored as configurations in devices such as insulin pumps or respiratory devices accessible to DiGA. However, due to the heterogeneity and diversity of possible settings, and the difficulty of mapping them in a coded and standardized way to efficiently processable FHIR resources, gematik and the Federal Ministry of Health decided to initially exclude this topic from HDDT. Therefore, configuration data for the analyzed medical aids are only considered if they are directly linked to the provision of measurement data and can be represented as simple attribute–value pairs._

This section describes the fundamental mechanisms for exchanging measurement data and metrics. For measurement data, both single measurements and continuously collected time series are included.

### Querying for Device Data

In general, data can be measured in two different scenarios by personal health devices:
* dedicated measurements: scheduled by a defined care plan or triggered by an unscheduled event, the patient performs a measurement using a medical aid. The measurement takes a defined period of time and records single values for one or more data items (e.g. pulse and blood pressure). Typical examples of devices, which are used ad hoc or based on a care plan are blood glucose meters, smart insulin pens, blood pressure cuffs and peak flow meters.
* continuous measurements: The patient is connected to a sensor (almost) all the time and the sensor continuously measures and records data. Typical examples of devices that perform continuous measurements are rtCGM, insulin pumps and pace makers.

In addition, there are also devices and scenarios, which combine both paradigms, e.g.
* personal ECG recorders for recording short, single-channel ECGs based on a plan (e.g. patient is asked to perform a measurement after physical activity)
* pulse oximeters which are used ad hoc, but record data continuously for a certain period of time (e.g. monitoring SPO2 during sleep time of a person suffering from sleep apnea)

The HDDT FHIR API handles dedicated and continuous measurements in different ways. Which flavor of the API is to be used, is part of the FHIR implementation guide of a [MIV](methodology.md). For combined scenarios usually the API flavor for continuous measurements is used, because it is much more efficient in transfering sampled data.

#### General Requirements
The specification of the techncal interfaces for retrieving device data considers the following determinations and requirements:
* A DiGA pulls data from the device data recorder by stating a request for data. This may either be a FHIR RESTful interaction or a FHIR operation (for details see below). The device data recorder MUST validate the request and upon acceptance MUST respond with a set of FHIR resources that match the request.
* For all data transmitted to a DiGA by a device data recorder it MUST be clear to the DiGA, if the device that collected the data was in a calibrated state or not. 
* Usually a set of device data provided by a device data recorder covers a period of time that was given with the request (e.g. all measurements for the last 4 hours). For each response of a device data recorder it MUST be clear to the DiGA if the provided set of data is complete or not. E.g. a set of data may be inclomplete, if the connection between the aggregation manager and the health record was broken during the requested period and the missing data may be transmitted to the health record after the connection is re-established. 

#### Searching Observations Using FHIR _search_ Interactions

DiGA request device data from a device data recorder (see [information model](information-model.md])) using a standard FHIR [search interaction](https://hl7.org/fhir/R4/http.html#search) on the [Observation](https://hl7.org/fhir/R4/observation.html) resource type. 
The device data recorder MUST respond to a [search](https://hl7.org/fhir/R4/http.html#search) request with a collection of [Observation](https://hl7.org/fhir/R4/observation.html) resources or with an error.

The request header MUST contain an Access Token acc. to the HDDT [OAuth2 profile](oauth-api.md). This access token was issued by the Authorization Server of the device data recorder and MUST be taken as opaque by the DiGA. 
 
The device data recorder MUST be able to discover the internal patient identifier from the access token. This identifier MUST implicitly be considered as the `subject` argument with every query to the device date recorder's FHIR API. If a DiGA explicitly provides a `subject`argument with a query, the device data recorder MUST ignore this argument and SHOULD respond with an _Invalid Request_ error (see [OpenAPI definition](himi-diga-api.md#openapi-description)).

The device data recorder MUST be able to discover the SMART Scope from the access token, which were accepted by the device data recorder during pairing with the requesting DiGA (see section [Pairing](pairing.md)). The SMART Scope MUST implicitly be considered as the `code` argument with every query to the device date recorder's FHIR search API. If the Scope resolves to multiple LOINC codes, these must all be considered to be query argumnets (OR-semantics). A DiGA MAY explicitly further constrain the scope of the search by providing a `code` argument with a query (see below).

With every FHIR search interaction the requesting DiGA SHOULD provide a `date` argument to set the lower and/or upper bound of the time period for which data is requested. If no `date` is provided with the query, the device data recorder will respond with all data that matches the other (implicit and explicit) query arguments.  

<hr>

__Example__: 

```
GET [base]/Observation/?date=gt20250912
```
The HTTP header holds an Access Token, from which the device data recorder can obtain the internal patient identifer _123_ and a SMART scope that resolves to the [ValueSet](https://hl7.org/fhir/R4/valueset.html) _https://terminologien.bfarm.de/fhir/ValueSet/VS-Tissue-Glucose-CGM_ which contains the LOINC codes [105272-9](https://loinc.org/105272-9/) and [99504-3](https://loinc.org/99504-3). The "real" query sent to the health record in this example is 
```
GET [base]/Observation/?date=gt20250912&subject=Patient/123&code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS-Tissue-Glucose-CGM
```
<hr>

A DiGA MAY further constrain the kind of requested values by providing one or more `code` arguments with the search request. In this case only [Observation](https://hl7.org/fhir/R4/observation.html) resources are returned, were the contained data exactly match the given codes.

Example: If no `code` argument is given, the data recorder of a blood glucose meter will respond to a query for blood glucose data with all glucose values regardless of the unit (e.g. _mg/dl_ and _mmol/l_). If the LOINC code _2339-0_ is given as a `code` argument, the device recorder will only respond with values that were measured in blood and which are available as _mg/dl_.

All `code` values provided as explicit query arguments MUST be part of the [ValueSet](https://hl7.org/fhir/R4/valueset.html) that is referenced in the SMART scope that is linked with the Access Token. If a DiGA requests for a code which is not contained with this value set, the device data recorder MUST respond with an 'Invalid Request` error.

`date` and `code` are the only search parameters that each DiGA and device data recorder MUST support for all MIVs. A MIV-specific implementation guide MAY request for supporting further search arguments and MAY constrain the use and semantics of these arguments. A device data recorder MAY support even more search parameters in accordance to the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition. In this case these arguments MUST be published through the device data recorders [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html). 

#### Fetching Single Observations using FHIR _read_ Interactions
Per HL7 FHIR a _resource_ is a a definable, identifiable, addressable collection of data elements that represents a concept or entity in health care. By this each [Observation](https://hl7.org/fhir/R4/observation.html) resource a device data recorder transmits to a DiGA MUST be identifiable and addressable through an `id`. Device data recorder MUST allow a DiGA to request a known Observation by using a FHIR [_read_ interaction](https://hl7.org/fhir/R4/http.html#read):
```
GET [base]/Observation/[id]
```
___Remark__: As stated in [General Considerations](general-considerations.md), device data recordes MAY limit access to historical data to 30 days, unless the [MIV](methodology.md)-specific specification requests for a longer period. In case a DiGA requests such a historic resource by its `id` after the availability period ended, the device data recorder MUST respond with a _404 Not Found_ error (see https://hl7.org/fhir/R4/http.html#read for details on handling deleted resources). 

#### Paging

In accordance with the [HL7 FHIR specification](https://hl7.org/fhir/R4/http.html#paging), supporting _paging_ is recommended but optional for device data recorders. DiGA manufacturers MUST consider, that a specific device data recorder may only be able to respond with a limited number of [Observation](https://hl7.org/fhir/R4/observation.html) resources in response to a query. 

#### Device Status and Device Configuration

Each [Observation](https://hl7.org/fhir/R4/observation.html) resource returend by a device data recorder MUST contain a `device` element that either referes to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or a [Device](https://hl7.org/fhir/R4/device.html) resource. 

A device data recorder MUST provide a `device` reference to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) with the [Observation](https://hl7.org/fhir/R4/observation.html) resources, if the sensor needs to be calibrated before or during use. The [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource MUST reflect the status of the sensor that was used to measure the obervation. It MUST at least 
* provide the `calibration.state` of the sensor and 
* a `source` reference to the [Device](https://hl7.org/fhir/R4/device.html) resource that represents the configuration of the personal health device at the time the measurement was performed.

If the device data recorder does not provide a `device` reference to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource, it MUST provide a `device` reference to a [Device](https://hl7.org/fhir/R4/device.html) resource. 

The [Device](https://hl7.org/fhir/R4/device.html) resource MUST contain a `definition` reference to the device's product definition as registered with the BfArM device registry. The reference MUST be given as the canonical url of the [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource that can be obtained from the BfARM device registry. The reference MAY contain a _version_ value.

#### Dedicated Measurements

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

#### Continuous Measurements

Values from continuous measurements MUST be provided as Chunks of [sampledData](/https://hl7.org/fhir/R4/datatypes.html#SampledData), where each chunk of data is represented as an [Observation](https://hl7.org/fhir/R4/observation.html). As with single data points, the [Observation](https://hl7.org/fhir/R4/observation.html) holding the sampled Data MUST contain a `device` element that either referes to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or a [Device](https://hl7.org/fhir/R4/device.html) resource.
  
The owner of the device data recorder MUST define the _chunk-time-span_ of measurements that can be covered by a chunk. E.g. if the owner of the device data recorder defines a _chunk-time-span_ of 24 hours for a chunk, each chunk can hold up to 1440 data points for a personal health device that measures data every minute. A chunk MAY cover a shorter period of time than the _chunk-time-span_ (e.g. when the calibration status of the device changed during measurments), but it MUST NOT exceed that value. The _chunk-time-span_ is part of the device definition and can be requested by DiGA trough a defined `property` of the __Device Data Recorder Definition__ resource.

In a query for continuously measured data results in multiple chunks ([Observation](https://hl7.org/fhir/R4/observation.html)s), each chunk's `effectivePeriod`MUST have the length of the _chunk-time-span_. The only exceptions are changes to the `calibration.state` or a change of the personal health device (see below). In these cases a chunk's èffectivePeriod` can be shorter than the _chunk-time-span_.

A chunk MAY be in a _preliminary_ `state`. This is the case if the chunk is not filled with values up to the _chunk-time-span_ and the device data recorder expects more data to come until the end of the time period covered by the chunk. The figure below shows an example of a _preliminary_ chunk for a device data recorder with a _chunk-time-span_ of 24 hours and a persona health device with a sample rate of one data point per minute. The `search` query stated by an authorized DiGA requests for all data from May 4th until now. The newest data available to the decvice data recorder is from May, 6th 10:00 am. 

<div><img src="/HDDT measurement sampled data example 1.png" alt="searching for values from a continuous measurement" width="45%"></div>
<br clear="all"/>

If the DiGA states the same `search` query again one hour later, the newest data being available at the device data recorder is now from May, 6th 11:00 am. Therefore now the _premiminary_ chunks contains 60 additional values.

<div><img src="/HDDT measurement sampled data example 1b.png" alt="searching for values from a continuous measurement" width="45%"></div>
<br clear="all"/>

__Remark__: In the given example the DiGA coould as well have used a `read` interaction to just obtain an updated version of the _preliminary_ chunk:
```
GET baseurl/Observation/3
```

##### Change of calibration.status
Some sensors for continuous measurements require initial or regular calibration. If this leads to a changed value for `calibration.state` in the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) observation that is bound to a chunk, the device data recorder MUST finish the current chunk and start a new chunk. The same holds for any other change in `calibration.state`, e.g. a sensor that switches from a calibrated to an unknown state  after a certain time (see figure below.)

<div><img src="/HDDT measurement sampled data example 2.png" alt="searching for values from a continuous measurement" width="45%"></div>
<br clear="all"/>

As can be seen with the example, the last chunk before calibration is set to a _final_ status and the èffectivePeriod` is adapted to the end time the calibration state changed. The new chunk is initialized with a _preliminary_ status and the fixed _chunk-time-span_. 

##### Changing Devices



##### Missing Values


### Querying for Aggregated or Calculated Data

* keine einzelnen Kennzahlen, sondern nur standardisierte Berichte auf Kennzahlen

