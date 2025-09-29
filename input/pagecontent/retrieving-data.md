
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
 
The device data recorder MUST be able to discover the internal patient identifier from the access token. This identifier MUST implicitly be considered as the `subject` argument with every query to the device date recorder's FHIR API. If a DiGA explicitly provides a `subject`argument with a query, the device data recorder MUST ignore this argument and SHOULD respond with an _Bad Request_ error.

The device data recorder MUST be able to discover the SMART Scope from the access token, which were accepted by the device data recorder during pairing with the requesting DiGA (see section [Pairing](pairing.md)). The SMART Scope MUST implicitly be considered as the `code` argument with every query to the device date recorder's FHIR search API. If the Scope resolves to multiple LOINC codes, these must all be considered to be query argumnets (OR-semantics). A DiGA MAY explicitly further constrain the scope of the search by providing a `code` argument with a query (see below).

With every FHIR search interaction the requesting DiGA SHOULD provide a `date` argument to set the lower and/or upper bound of the time period for which data is requested. If no `date` is provided with the query, the device data recorder will respond with all data that matches the other (implicit and explicit) query arguments.  

<hr>

__Example__: 

```
GET [base]/Observation/?date=gt20250912
```
The HTTP header holds an Access Token, from which the device data recorder can obtain the internal patient identifer _123_ and a SMART scope that resolves to the [ValueSet](https://hl7.org/fhir/R4/valueset.html) _https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-continuous-glucose-measurement_ which contains the LOINC codes [105272-9](https://loinc.org/105272-9/) and [99504-3](https://loinc.org/99504-3). The "real" query sent to the health record in this example is 
```
GET [base]/Observation/?date=gt20250912&subject=Patient/123&code:in=https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-continuous-glucose-measurement
```
<hr>

A DiGA MAY further constrain the kind of requested values by providing one or more `code` arguments with the search request. In this case only [Observation](https://hl7.org/fhir/R4/observation.html) resources are returned, were the contained data exactly match the given codes.

Example: If no `code` argument is given, the data recorder of a blood glucose meter will respond to a query for blood glucose data with all glucose values regardless of the unit (e.g. _mg/dl_ and _mmol/l_). If the LOINC code `2339-0` (_Glucose [Mass/volume] in Blood_) is given as a `code` argument, the device recorder will only respond with values that were measured in blood and which are available as _mg/dl_.

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

A DiGA MAY store the `id` of a [Device](https://hl7.org/fhir/R4/device.html) resource, it received through a `Observation.device` or `DeviceMetric.source` reference or from a _search_ interaction. The DiGA MAY use this `id` to request the [Device](https://hl7.org/fhir/R4/device.html) resource - and by this the device's current status - through a FHIR _read_ interaction. This information can be helpful for detecting missing data (see section _Missing Data_ below). 

The [Device](https://hl7.org/fhir/R4/device.html) resource MUST contain a `definition` reference to the device's product definition as registered with the BfArM device registry. The reference MUST be given as the canonical url of the [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource that can be obtained from the BfARM device registry. The reference MAY contain a _version_ value.

Every device data recorder holds information about its static properties as part of its definition. These properties can be obtained as key-value-pairs from the BfArM Device Directory. The table below lists the keys defined so far.

| key                  | value | obligation | comments |
|----------------------|-------|------------|----------|
| Store-Capacity-Count | number of measured values that can be stored locally with the sensor | MUST | In cases where the sensor cannot synchronize with the aggregation manager (e.g. due to connection failures) data gets lost if the amount of measured data since the last synchronization exceeds _Store-Capacity-Count_ |
| Historic-Data-Period | minimum number of days historic data is available at the device data recorder | MUST | If a DiGA queries for data that is older than _Historic-Data -Period_ the device data recorder, the device data recorder MAY respond with an error. _Historic-Data-Period_ MUST NOT be shorter than the minimum historic data period defined for the affected MIV. |
| Delay-From-Real-Time | minimum delay in seconds of the end-to-end synchronization from the Personal Health Device to the Health Record. | MUST | if a DiGA polls for new device data in fixed intervals, the `Delay-From-Real-Time' denotes the overlap of two consecutive intervals in order to catch all measured data. | 
| Grace-Period | Time span a DiGA must wait between two requests for the same patient's data. | MUST | A device data recorder MAY reject a new request that is issued before the end of this time span. | 
| Chunk-Time-Span      | size of a chunk for sharing sampled data (see below) | MUST if applicable | This property is only applicable for device data recorders that provide MIVs as sampled data |  

When a DiGA requests for the device definition through a FHIR _read_ interaction, the device data recorder MUST provide these properties as `property` elements of the [Device](https://hl7.org/fhir/R4/device.html) resource that is returned to the DiGA. 

#### Use of _include
The Device Data Recorder must respond a _search_ request with a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request. A DiGA MAY add the search parameter `_include=Observation:device` with the request. In this case the Device Data Recorder MUST include the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced by the `device` element of the [Observation](https://hl7.org/fhir/R4/observation.html) in the same Bundle (see https://hl7.org/fhir/R4/search.html#revinclude for details).

Example:
```
GET [base]/Observation/?date=gt20250912&_include=Observation:device 
```
will return a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request and for each [Observation](https://hl7.org/fhir/R4/observation.html) the referenced [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource.

Example:
```
GET [base]/Observation/?date=gt20250912&_include=Observation:device&_include:iterate=DeviceMetric:source
```
will return a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request and for each [Observation](https://hl7.org/fhir/R4/observation.html) the referenced [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource. If a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource is referenced, the Bundle will also contain the [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced by the `source` element of the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html).

#### Dedicated Measurements

In general HDDT only requests a minimum of data elements to be mandatory with an [Observation](https://hl7.org/fhir/R4/observation.html) resource that reflects a single measurement. The example below is based on the HDDT FHIR impementation guideline for the Miv _Blood Glucose Measurement_. 

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
As the information on the time and result of the measurement is a rather straight-forward adoption of the FHIR standard, some HDDT-specific conventions have to be considered with the `device` reference (see above). The figure below shows a simple interplay of measured data ([Observation](https://hl7.org/fhir/R4/observation.html)), sensor status ([DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)), and device configuration ([Device](https://hl7.org/fhir/R4/device.html)), e.g. in response for a query for all blood glucose data that was measured for a given patient on May 7th.

<div><img src="/HDDT measurement ad hoc example 1.png" alt="Blood glucose values for a day" width="50%"></div>
<br clear="all"/>

This gets more complex, if the status of the sensor changes. The figure below is based on the previous example, but now data is reqested for a longer period (May 7th and 8th) with the patient calibrating the device within this period.

<div><img src="/HDDT measurement ad hoc example 2.png" alt="Blood glucose values including sensor calibration" width="65%"></div>
<br clear="all"/>

As shown with the example, a calibration of a sensor leads to an update to the sensor's `DeviceMetric` resource. The device data recorder MUST make changes to the calibration status of a sensor make visible to the device data consumer. 

##### Missing Values with Dedicated Measurements
A response of the device data recorder to a query for dedicated measurements MAY be incomplete in a way that there MAY be more data available for the requested period, but the device data recorder does not provide this data to the DiGA. The most common case is that a DiGA requests for data that was measured very recently (e.g. within the last hour). The device data recorder MAY respond with all data that is available at the time of the request, but there MAY be more data available that was measured a short time before the request, but not yet transmitted to the device data recorder. Therefore a DiGA SHOULD always obtain the static property `Delay-From-Real-Time` from the Personal Health Device's [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) (see above) and use this value to overlap two consecutive requests for data.

Missing data MAY even occur if the connection between the Personal Health Device and the AggregationManager or between the AggregationManager and the Health Record was broken during the requested period and the missing data may be transmitted to the Health Record after the connection is re-established. A DiGA can detect this situation by reading the Device resource and checking the `status` element. If the `status` of the device is _unknown_, the DiGA MAY assume that data is missing and may be available later.

___Remark__: FHIR R4 does provide information about a Personal Health Device being offline through the 'statusReason` element of the [Device](https://hl7.org/fhir/R4/device.html) resource. This element is missing in FHIR R5 and therefore not used in the HDDT specification. Due to this incompatibility acrosss FHIR versions, a `status` value of _unknown_ MUST be used by the Device Data Recorder to indicate that the connecton to the Personal Health Device is temporarely broken (which is semanticly correct as the status of the device is unknown to the Health Record if it does not receive any information from the device).  

The easiest way for a DiGA to deal with these kinds of missing data is to set the `date` argument of a new request to one second after the `effectiveDateTime` of the last [Observation](https://hl7.org/fhir/R4/observation.html) it received with the last request. 

#### Continuous Measurements

Values from continuous measurements MUST be provided as chunks of [sampledData](/https://hl7.org/fhir/R4/datatypes.html#SampledData), where each chunk of data is represented as an [Observation](https://hl7.org/fhir/R4/observation.html). As with single data points, the [Observation](https://hl7.org/fhir/R4/observation.html) holding the sampled Data MUST contain a `device` element that either referes to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or a [Device](https://hl7.org/fhir/R4/device.html) resource.
  
The owner of the device data recorder MUST define the _chunk-time-span_ of measurements that can be covered by a single chunk. E.g. if the owner of the device data recorder defines a _chunk-time-span_ of 24 hours for a chunk, each chunk can hold up to 1440 data points for a Personal Health Device that measures data every minute. A chunk MAY cover a shorter period of time than the _chunk-time-span_ (e.g. when the calibration status of the device changed during measurments), but it MUST NOT exceed that value. The _chunk-time-span_ is part of the device definition and can be requested by DiGA trough a defined `property` of the __Device Data Recorder Definition__ resource.

In a query for continuously measured data results in multiple chunks ([Observation](https://hl7.org/fhir/R4/observation.html)s), each chunk's `Observation.effectivePeriod`MUST have the length of the _chunk-time-span_. The only exceptions are changes to the `calibration.state` or a change of the personal health device (see below). In these cases a chunk's `Observation.effectivePeriod` can be shorter than the _chunk-time-span_.

A chunk MAY be in a _preliminary_ `state`. This is the case if the chunk is not filled with values up to the _chunk-time-span_ and the device data recorder expects more data to come until the end of the time period covered by the chunk. The figure below shows an example of a _preliminary_ chunk for a device data recorder with a _chunk-time-span_ of 24 hours and a Personal Health Device with a sample rate of one data point per minute. The `search` query stated by an authorized DiGA requests for all data from May 4th until now. The newest data available to the decvice data recorder is from May, 6th 10:00 am. 

<div><img src="/HDDT measurement sampled data example 1.png" alt="searching for values from a continuous measurement" width="60%"></div>
<br clear="all"/>

If the DiGA states the same `search` query again one hour later, the newest data being available at the device data recorder is now from May, 6th 11:00 am. Therefore now the _premiminary_ chunks contains 60 additional values.

<div><img src="/HDDT measurement sampled data example 1b.png" alt="searching for values from a continuous measurement" width="60%"></div>
<br clear="all"/>

__Remark__: In the given example the DiGA coould as well have used a `read` interaction to just obtain an updated version of the _preliminary_ chunk:
```
GET [base]/Observation/3
```

##### Change of calibration.status
Some sensors for continuous measurements require initial or regular calibration. If this leads to a changed value for `calibration.state` in the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) observation that is bound to a chunk, the device data recorder MUST finish the current chunk and start a new chunk. The same holds for any other change in `calibration.state`, e.g. a sensor that switches from a calibrated to an unknown state  after a certain time (see figure below.)

<div><img src="/HDDT measurement sampled data example 2.png" alt="searching for values from a continuous measurement" width="45%"></div>
<br clear="all"/>

As can be seen with the example, the last chunk before calibration is set to a _final_ status and the èffectivePeriod` is adapted to the end time the calibration state changed. The new chunk is initialized with a _preliminary_ status and the fixed _chunk-time-span_. 

##### Changing Devices
[Pairing](pairing.html) a DiGA with a Device Data Recorder is always done for a specific patient and a specific type of Personal Health Device. If the patient exchanges the Personal Health Device (e.g. gets a new insulin pump) for a new one of the same type, the DiGA does not need to re-pair with the Device Data Recorder. In this case the Device Data Recorder MUST handle the change of the instance of the Personal Health Device internally. Nevertheless, the DiGA MUST be able to detect that a change of the Personal Health Device took place. This is done by the Device Data Recorder by finishing the current chunk and starting a new chunk with a new `device` reference to a [Device](https://hl7.org/fhir/R4/device.html) resource that reflects the new Personal Health Device (see figure below).

<div><img src="/HDDT measurement sampled data example 3.png" alt="searching for values from a continuous measurement" width="65%"></div>
<br clear="all"/>

##### Missing Values with Continuous Measurements
A response of the device data recorder to a query for continuosly measured data MAY be incomplete in a way that there MAY be more data available for the requested period, but the device data recorder does not provide this data to the DiGA. The most common case is that a DiGA requests for data that was measured very recently (e.g. within the last hour). The device data recorder MAY respond with all data that is available at the time of the request, but there MAY be more data being in transmission from the Personal Health Device to the Health Record. Therefore a DiGA SHOULD always obtain the static property `Delay-From-Real-Time` from the Personal Health Device's [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) (see above) and use this value to overlap two consecutive requests for data.

Missing data MAY even occur if the connection between the Personal Health Device and the AggregationManager or between the AggregationManager and the Health Record was broken during the requested period and the missing data may be transmitted to the Health Record after the connection is re-established. A Device Data Recorder MUST signal this kind of missing data by setting the `status` of the [Observation](https://hl7.org/fhir/R4/observation.html) resource that holds the chunk to _preliminary_ with the `effectivePeriod` covering the full _chunk-time-span_. 

Anozther reason for missing data is a change of the Personal Health Device (e.g. a rtCGM is replaced by a new sensor). A DiGA MAY detect missing data due to device changes by analyzing the sequence of ([Observation](https://hl7.org/fhir/R4/observation.html)s) it received from a Device Data Recorder. If the `effectivePeriod.end` of a chunk is before the `effectivePeriod.start` of the next chunk, there is a gap in the data. The DiGA MAY use the `id` of the [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced in the `device` element of the chunks to check if the Personal Health Device changed (see above). 

### Querying for Aggregated or Calculated Data

The legal requirements of § 374a SGB V specify that a medical aid or implant must be able to provide aggregated or calculated data to DiGA via the HDDT interfaces. In the present specification, this is limited to data calculated from the MIVs provided by the medical aid or implant. For example, for a connected rtCGM a Device Data Recorder must only be able to provide derived key figures that can be calculated exclusively on the continuously collected glucose values which represent the MIV "Continuous Glucose Measurement". In order to minimise computational efforts at the manufacturer of the Device Data Recorder, DiGA can only request for derived or summarised data in the form of standardised reports. A DiGA cannot, for example, query the number of hypoglycemias within a given period of time as a single value from the Device Data Recorder of an rtCGM, but only the complete set of relevant key figures, e.g. such as those contained in the _ambulatory glucose profile (AGP)_. 

As far as available and usable, these reports represent existing specifications. For rtCGM data, for example, the specification of a [CGM Summary Observation from HL7 International](https://github.com/HL7/cgm) is adopted unchanged. In order to be as flexible as possible for future MIVs, the specification does not limit the reports to a certain FHIR resource definition. This allows for adopting standard FHIR IGs for standardized reports regardless if they are provided as FHIR Observations, DiagnosticReports or any other kind of DomainResource. 

As a dynamically derived artefact a report only becomes a "true" FHIR resource if it is persisted by a DiGA. The Device Data Recorder MAY decide to NOT persist dynamically assembled reports as addressable FHIR resources. In order to reflect this behaviour and to preserve maximum flexibility with respect to the type of FHIR resource used for a report, the HDDT specification defines dedicated [FHIR operations](https://hl7.org/fhir/R4/operations.html) for querying reports from a Device Data Recorder.

Each report is bound to the MIV that is used to calculate the report. A Device Data Recorder MUST provide a list of available reports for each MIV it supports. This list MUST be published by listing the respective FHIR operations in the Device Data Recorder's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) which MUST be obtainable by a DiGA through the `/metadata` endpoint of the Device Data Recorder's FHIR resource server.
