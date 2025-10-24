
The legal requirements specify that a medical aid or implant must be able to provide the following types of data to DiGA:

* measurement data collected by the personal health device,
* aggregated data,
* therapy plans and configurations stored in the device.

For the first implementation stage of HDDT, only 
* measurement data collected by medical aids and 
* aggregated data in the form of calculated metrics 
will be considered.

This section describes the fundamental mechanisms for exchanging measurement data and metrics. For measurement data, both single measurements and continuously collected time series are considered.

### Querying for Device Data

In general, data can be measured in two different scenarios by personal health devices:
* dedicated measurements: scheduled by a defined care plan or triggered by an unscheduled event (e.g. a patient feeling symptoms of hypoglycemia). A dedicated measurement occurs at a dedicated point in time and records single values for one or more data items (e.g. systolic and diastolic blood pressure). Typical examples of devices which are used ad hoc or based on a care plan are blood glucose meters, smart insulin pens, blood pressure cuffs and peak flow meters.
* continuous measurements: The patient is connected to a sensor (almost) all the time and the sensor continuously measures and records data. Typical examples of devices that perform continuous measurements are rtCGM, insulin pumps and pacemakers.

In addition, there are also devices and scenarios, which combine both paradigms, e.g.
* personal ECG recorders for recording short, single-channel ECGs based on a plan (e.g. patient is asked to perform a measurement after physical activity)
* pulse oximeters which are used ad hoc, but record data continuously for a certain period of time (e.g. monitoring SPO2 during sleep time of a person suffering from sleep apnea)

The HDDT FHIR API handles dedicated and continuous measurements in different ways. Which flavor of the API is to be used, is part of the FHIR implementation guide of a [MIV](methodology.html). For combined scenarios usually the API flavor for continuous measurements is used, because it is much more efficient in transferring sampled data.

#### General Requirements
The specification of the technical interfaces for retrieving device data considers the following determinations and requirements:
* A DiGA pulls data from the Device Data Recorder by stating a request for data. This may either be a FHIR RESTful interaction or a FHIR operation (for details see below). The Device Data Recorder MUST validate the request and upon acceptance MUST respond with a set of FHIR resources that match the request.
* For all data transmitted to a DiGA by a Device Data Recorder it MUST be clear to the DiGA, if the device that collected the data was in a calibrated state or not. 
* Usually, a set of device data provided by a Device Data Recorder covers a period of time that was given with the request (e.g. all measurements for the last 4 hours). For each response of a Device Data Recorder it MUST be clear to the DiGA if the provided set of data is complete or not. E.g. a set of data may be incomplete, if the connection between the Personal Health Gateway and the Health Record was broken during the requested period and the missing data may be transmitted to the health record after the connection is re-established. 
* A Device Data Recorder MUST NOT disclose information to a DiGA that allows the DiGA to identify the patient as a natural person. Guidance on the use of the `Device.patient` and the `Observation.subject` elements is given in the [Security and Privacy](security-and-privacy.html#identification-and-authentication-of-the-patient) chapter of this specification.

#### Searching Observations Using FHIR _search_ Interactions

A DiGA requests device data from a Device Data Recorder using a standard FHIR [search interaction](https://hl7.org/fhir/R4/http.html#search) on the [Observation](https://hl7.org/fhir/R4/observation.html) resource type.
The Device Data Recorder MUST respond to a [search](https://hl7.org/fhir/R4/http.html#search) request with a collection of [Observation](https://hl7.org/fhir/R4/observation.html) resources or with an appropriate error.

The request MUST include an OAuth 2.0 access token in the `Authorization` header (as defined in the HDDT [OAuth2 profile](pairing.html#access-tokens)). This access token is issued by the [Authorization Server](authorization-server.html) of the Device Data Recorder.

The Device Data Recorder MUST be able to derive the internal patient identifier corresponding to the Pairing ID contained in the access token. This identifier MUST implicitly be used as the `subject` parameter in every query to the Device Data Recorder’s FHIR API. If a DiGA explicitly provides a `subject` parameter, the Device Data Recorder MUST ignore it and SHOULD return a `400 Bad Request` error.

The Device Data Recorder MUST be able to retrieve the [SMART scopes](smart-scopes.html) from the access token, which were consented to during pairing with the requesting DiGA (see [Pairing](pairing.html)). The SMART scope (with the resource type [Observation](https://hl7.org/fhir/R4/observation.html)) and it's query parameters MUST implicitly be applied as a `code` search parameter in every FHIR search query. ValueSets used in scopes MUST be expanded since they MAY consist of multiple LOINC codes. All of these codes MUST be considered in the search (logical OR semantics). A DiGA MAY further narrow the result by explicitly providing a `code` parameter.

With every FHIR search interaction, the DiGA SHOULD provide a `date` parameter to limit the time period of data retrieval. If no `date` is specified, the Device Data Recorder MUST return all matching data according to the implicit and explicit query parameters.

<hr>

__Example__: 

```
GET [base]/Observation?date=gt20250912
```
The HTTP header holds an Access Token, from which the Device Data Recorder can obtain its internal patient identifier _123_ and a SMART scope that resolves to the [ValueSet](https://hl7.org/fhir/R4/valueset.html) _https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement_ which contains the LOINC codes [105272-9](https://loinc.org/105272-9/) and [99504-3](https://loinc.org/99504-3). The "real" query processed by the Device Data Recorder's FHIR Resource Server in this example is 
```
GET [base]/Observation?date=gt20250912&subject=Patient/123&code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement
```
<hr>

___Remark__: The MIV ValueSets will be published on the ZTS (https://terminologien.bfarm.de) after the final approval of this specification. By now the ValueSets can only be found in the [ValueSet section](artifacts.html#terminology-value-sets) of this specifications's artifact summary._

A DiGA MAY further constrain the kind of requested values by providing one or more `code` arguments with the search request. In this case only [Observation](https://hl7.org/fhir/R4/observation.html) resources are returned, where the contained data exactly matches the given codes.

Example: If no `code` argument is given, the data recorder of a blood glucose meter will respond to a query for blood glucose data with all glucose values regardless of the unit (e.g. _mg/dl_ and _mmol/l_). If the LOINC code `2339-0` (_Glucose [Mass/volume] in Blood_) is given as a `code` argument, the device recorder will only respond with values that were measured in blood and which are available as _mg/dl_.

All `code` values provided as explicit query arguments MUST be part of the [ValueSet](https://hl7.org/fhir/R4/valueset.html) that is referenced in the SMART scope that is linked with the Access Token. If a DiGA requests for a code which is not contained with this value set, the Device Data Recorder MUST respond with an 'Invalid Request` error.

`date` and `code` are the only search parameters that each DiGA and Device Data Recorder MUST support for all MIVs. A MIV-specific implementation guide MAY request for supporting further search arguments and MAY constrain the use and semantics of these arguments. A Device Data Recorder MAY support even more search parameters in accordance to the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition. In this case these arguments MUST be published through the Device Data Recorders [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html). 

#### Fetching Single Observations using FHIR _read_ Interactions
Per HL7 FHIR a _resource_ is a a definable, identifiable, addressable collection of data elements that represents a concept or entity in health care. By this each [Observation](https://hl7.org/fhir/R4/observation.html) resource a Device Data Recorder transmits to a DiGA MUST be identifiable and addressable through an `id`. Device Data Recorder MUST allow a DiGA to request a known Observation by using a FHIR [_read_ interaction](https://hl7.org/fhir/R4/http.html#read):
```
GET [base]/Observation/[id]
```
___Remark__: As stated in [General Considerations](general-considerations.html), device data recordes MAY limit access to historical data to 30 days, unless the [MIV-specific specification](mivs.html) requests for a longer period. In case a DiGA requests such a historic resource by its `id` after the availability period ended, the Device Data Recorder MUST respond with a _404 Not Found_ error (see https://hl7.org/fhir/R4/http.html#read for details on handling deleted resources). 

#### Paging

In accordance with the [HL7 FHIR specification](https://hl7.org/fhir/R4/http.html#paging), supporting _paging_ is recommended but optional for Device Data Recorders (SHOULD). DiGA manufacturers MUST consider, that a specific Device Data Recorder may only be able to respond with a limited number of [Observation](https://hl7.org/fhir/R4/observation.html) resources in response to a query. 

#### Device Status and Device Configuration

Each [Observation](https://hl7.org/fhir/R4/observation.html) resource returned by a Device Data Recorder MUST contain a `device` element that either refers to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or a [Device](https://hl7.org/fhir/R4/device.html) resource. 

A Device Data Recorder MUST provide a `device` reference to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) with the [Observation](https://hl7.org/fhir/R4/observation.html) resources, if the sensor needs to be calibrated before or during use or if the calibration status of the sensor may change over time. The [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource MUST reflect the status of the sensor that was used to measure the observation. It MUST at least 
* provide the `calibration.state` of the sensor and 
* a `source` reference to the [Device](https://hl7.org/fhir/R4/device.html) resource that represents the configuration of the personal health device at the time the measurement was performed.

If the Device Data Recorder does not provide a `device` reference to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource, it MUST provide a `device` reference to a [Device](https://hl7.org/fhir/R4/device.html) resource. 

A DiGA MAY store the `id` of a [Device](https://hl7.org/fhir/R4/device.html) resource, it received through a `Observation.device` or `DeviceMetric.source` reference or from a _search_ interaction. The DiGA MAY use this `id` to request the [Device](https://hl7.org/fhir/R4/device.html) resource - and by this the device's current status - through a FHIR _read_ interaction. This information can be helpful for detecting missing data (see section _Missing Data_ below). 

The [Device](https://hl7.org/fhir/R4/device.html) resource MUST contain a `definition` reference to the device's product definition as registered with the BfArM _HIIS-VZ_ (Device Registry). The reference MUST be given as the canonical url of the [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) resource that can be obtained from the BfArM _HIIS-VZ_. The reference MAY contain a _version_ value.

Every Device Data Recorder holds information about its static attributes as part of its definition. These attributes can be obtained as key-value-pairs from the BfArM _HIIS-VZ_. The table below lists the keys defined so far.

| key                  | value | obligation | comments |
|----------------------|-------|------------|----------|
| Store-Capacity-Count | number of measured values that can be stored locally with the sensor | MUST | In cases where the sensor cannot synchronize with the Personal Health Gateway (e.g. due to connection failures) data gets lost if the amount of measured data since the last synchronization exceeds _Store-Capacity-Count_ |
| Historic-Data-Period | minimum number of days historic data is available at the Device Data Recorder | MUST | If a DiGA queries for data that is older than _Historic-Data-Period_, the Device Data Recorder MAY respond with an error. _Historic-Data-Period_ MUST NOT be shorter than the minimum historic data period defined for the affected MIV. |
| Delay-From-Real-Time | aximum delay in seconds of the end-to-end synchronization from the Personal Health Device to the Health Record under normal operational conditions. | MUST | if a DiGA polls for new device data in fixed intervals, the `Delay-From-Real-Time' denotes the overlap of two consecutive intervals in order to catch all measured data. | 
| Grace-Period | Time span a DiGA must wait between two requests for the same patient's data. | MUST | A Device Data Recorder MAY reject a new request that is issued before the end of this time span. | 
| Chunk-Time-Span      | size of a chunk for sharing sampled data (see below) | MUST if applicable | This property is only applicable for Device Data Recorders that provide Observation values as sampled data |  

#### Versioning of Device and DeviceMetric Resources
The HDDT specification does not mandate a specific versioning strategy for [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources. A Device Data Recorder MAY use the FHIR _versionId_ mechanism or MAY use its own versioning strategy (e.g. by creating new resources whenever a relevant element changes). 

##### Versioning of Device Resources
A Device Data Recorder MUST track the Medical Health Devices used by a patient. If a patient exchanges a Personal Health Device (e.g. gets a new insulin pump), the Device Data Recorder MUST create a new [Device](https://hl7.org/fhir/R4/device.html) resource with a new `id` that reflects the new Personal Health Device.

Unless stated otherwise in the MIV-specific implementation guide, a Device Data Recorder MAY not perform any versioning on any of the elements of the Device resource or MAY not expose such changes to the DiGA (see [https://hl7.org/fhir/R4/resource.html#versions(https://hl7.org/fhir/R4/resource.html#versions)]). In this case the Device Data Recorder MUST NOT change the `id` and the 'meta.versionID' of the [Device](https://hl7.org/fhir/R4/device.html) resource as long as the Personal Health Device does not change. Nevertheless, a _read_ interaction on the [Device](https://hl7.org/fhir/R4/device.html) resource MUST always return the current status of the Personal Health Device (e.g. _active_, _inactive_, _unknown_), but it is up to the manufacturer, if this leads to a new, persistent, addressable version of the resource.

If a manufacturer implements versioning by creating a new record version of a [Device](https://hl7.org/fhir/R4/device.html) resource whenever a relevant element changes, the manufacturer MUST implement the FHIR _vread_ interaction to allow a DiGA to request a specific record version of a [Device](https://hl7.org/fhir/R4/device.html) resource. See [_vread_ interaction for Personal Health Device resources](fhir-api-device.html#device---vread) for details.

##### Overlapping Device Resources
Device resources MAY overlap in time. This is e.g. the case if a patient exchanges a Personal Health Device with a new one of the same type but keeps the old device for some time (e.g. when changing a rtCGM sensor the patient may take on the new sensor while still wearing the old one until the new sensor is fully calibrated). In this case it is up to the Device Data Recorder on how to handle the overlapping devices. Depending on the concrete kind of device and its typical usage patterns, the Device Data Recorder MAY either
* keep both devices as active (status = _active_) until the old device is no longer used and then set the status of the old device to _inactive_. During the overlapping period the Device Data Recorder provides Observation resources from both devices. E.g. if a DiGA requests for today's continuous glucose values, the Device Data Recorder provides Observation resources (chunks, see below) from both devices. These Observation resources mix or overlap in `effectiveDateTime` or `effectivePeriod`, but the DiGA can distinguish the source of the data by the `device` reference of the Observation resources.

##### Versioning of DeviceMetric Resources
A change of the Personal Health Device MUST always lead to a new DeviceMetric resource with a new `id`. 

For sensors that need to be calibrated or change their calibration status over time, the Device Data Recorder MUST at least track the changes in `calibration.state` of the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource. If the `calibration.state` changes, the Device Data Recorder MUST either create a new DeviceMetric resource with a new `id` or MUST create a new record version of the existing DeviceMetric resource by using the FHIR _versionId_ mechanism.

Unless stated otherwise in the MIV-specific implementation guide, a Device Data Recorder MAY not perform any versioning on any elements of the Device resource other than `calibration.state` or MAY not expose such changes to the DiGA (see [https://hl7.org/fhir/R4/resource.html#versions](https://hl7.org/fhir/R4/resource.html#versions)). In this case the Device Data Recorder MUST NOT change the `id` and the 'meta.versionID' of the [Device](https://hl7.org/fhir/R4/device.html) resource as long as the `calibration.state` does not change. 

If a manufacturer implements versioning by creating a new record version of a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource whenever `calibration.state` or any other relevant element changes, the manufacturer MUST implement the FHIR _vread_ interaction to allow a DiGA to request a specific version of a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource. See [_vread_ interaction for Device Configuration and Calibration Status resources](fhir-api-devicemetric.html#devicemetric---vread) for details.

#### Use of _include
The Device Data Recorder must respond a _search_ request with a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request. A DiGA MAY add the search parameter `_include=Observation:device` with the request. In this case the Device Data Recorder MUST include the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced by the `device` element of the [Observation](https://hl7.org/fhir/R4/observation.html) in the same Bundle (see https://hl7.org/fhir/R4/search.html#revinclude for details).

Example:
```
GET [base]/Observation?date=gt20250912&_include=Observation:device 
```
will return a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request and for each [Observation](https://hl7.org/fhir/R4/observation.html) the referenced [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource.

Example:
```
GET [base]/Observation?date=gt20250912&_include=Observation:device&_include:iterate=DeviceMetric:source
```
will return a Bundle of type _searchset_ that contains all [Observation](https://hl7.org/fhir/R4/observation.html) resources that match the request and for each [Observation](https://hl7.org/fhir/R4/observation.html) the referenced [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource. If a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource is referenced, the Bundle will also contain the [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced by the `source` element of the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html).

#### Dedicated Measurements

In general, HDDT only requests a minimum of data elements to be mandatory with an [Observation](https://hl7.org/fhir/R4/observation.html) resource that reflects a single measurement. The example below is based on the HDDT FHIR implementation guideline for the MIV _Blood Glucose Measurement_. 

{% include Observation-example-blood-glucose-measurement-1-json-html.xhtml %}

As the information on the time and result of the measurement is a rather straight-forward adoption of the FHIR standard, some HDDT-specific conventions have to be considered with the `device` reference (see above). The figure below shows a simple interplay of measured data ([Observation](https://hl7.org/fhir/R4/observation.html)), sensor status ([DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)), and device configuration ([Device](https://hl7.org/fhir/R4/device.html)), e.g. in response for a query for all blood glucose data that was measured for a given patient on May 7th.

<figure>
<div class="gem-ig-svg-container">
 <img src="HDDT measurement ad hoc example 1.png" alt="Blood glucose values for a day" width="50%">
  </div>
    <figcaption><em><strong>Figure: </strong>Blood glucose values for a day</em></figcaption>
</figure>
<br clear="all"/>

This gets more complex if the status of the sensor changes. The figure below is based on the previous example, but now data is requested for a longer period (May 7th and 8th) with the patient calibrating the device within this period.

<figure>
<div class="gem-ig-svg-container">
 <img src="HDDT measurement ad hoc example 2.png" alt="Blood glucose values including sensor calibration" width="65%">
  </div>
    <figcaption><em><strong>Figure: </strong>Blood glucose values including sensor calibration</em></figcaption>
</figure>
<br clear="all"/>

As shown with the example, a calibration of a sensor leads to an update to the sensor's `DeviceMetric` resource. The Device Data Recorder MUST make changes to the calibration status of a sensor make visible to the device data consumer. 

##### Missing Values with Dedicated Measurements
A response of the Device Data Recorder to a query for dedicated measurements MAY be incomplete in a way that there MAY be more data measured for the requested period, but the Device Data Recorder does not provide this data to the DiGA. The Device Data Recorder MUST respond with all data that is available at the time of the request, but there MAY be more data available that was measured a short time before the request, but not yet transmitted to the Device Data Recorder. Therefore a DiGA SHOULD always obtain the static property `Delay-From-Real-Time` from the Personal Health Device's [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) (see above) and use this value to overlap two consecutive requests for data.

Missing data MAY even occur if the connection between the Personal Health Device and the Personal Health Gateway or between the Personal Health Gateway and the Health Record was broken during the requested period and the missing data may be transmitted to the Health Record after the connection is re-established. A DiGA can detect this situation by reading the Device resource and checking the `status` element. If the `status` of the device is _unknown_, the DiGA SHOULD assume that data is missing and may be available later.

___Remark__: FHIR R4 does provide information about a Personal Health Device being offline through the `statusReason` element of the [Device](https://hl7.org/fhir/R4/device.html) resource. This element is missing in FHIR R5 and therefore not used in the HDDT specification. Due to this incompatibility across FHIR versions, a `status` value of _unknown_ MUST be used by the Device Data Recorder to indicate that the connection to the Personal Health Device is temporarily broken (which is semantically correct as the status of the device is unknown to the Health Record if it does not receive any information from the device).  

The easiest way for a DiGA to deal with these kinds of missing data is to set the `date` argument of a new request to one second after the `effectiveDateTime` of the last [Observation](https://hl7.org/fhir/R4/observation.html) it received with the last request. 

#### Continuous Measurements

Values from continuous measurements MUST be provided as chunks of [sampledData](https://hl7.org/fhir/R4/datatypes.html#SampledData), where each chunk of data is represented as an [Observation](https://hl7.org/fhir/R4/observation.html) resource. As with single data points, the [Observation](https://hl7.org/fhir/R4/observation.html) holding the sampled Data MUST contain a `device` element that either refers to a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or a [Device](https://hl7.org/fhir/R4/device.html) resource.
  
The owner of the Device Data Recorder MUST define the _chunk-time-span_ of measurements that can be covered by a single chunk. E.g. if the owner of the Device Data Recorder defines a _chunk-time-span_ of 24 hours for a chunk, each chunk can hold up to 1440 data points for a Personal Health Device that measures data every minute. A chunk MAY cover a shorter period of time than the _chunk-time-span_ (e.g. when the calibration status of the device changed during measurements), but it MUST NOT exceed that value. The _chunk-time-span_ is part of the device definition and can be requested by DiGA trough a defined `property` of the __Device Data Recorder Definition__ resource.

If a query for continuously measured data results in multiple chunks ([Observation](https://hl7.org/fhir/R4/observation.html)s), each chunk's `Observation.effectivePeriod` MUST have the length of the _chunk-time-span_. The only exceptions are changes to the `calibration.state` or a change of the personal health device (see below). In these cases a chunk's `Observation.effectivePeriod` can be shorter than the _chunk-time-span_.

A chunk MAY be in a _preliminary_ `state`. This is the case if the chunk is not filled with values up to the _chunk-time-span_ and the Device Data Recorder expects more data to come until the end of the time period covered by the chunk. The figure below shows an example of a _preliminary_ chunk for a Device Data Recorder with a _chunk-time-span_ of 24 hours and a Personal Health Device with a sample rate of one data point per minute. The `search` query stated by an authorized DiGA requests for all data from May 4th until now. The newest data available to the Device Data Recorder is from May, 6th 10:00 am. 

<figure>
<div class="gem-ig-svg-container">
  <img src="HDDT measurement sampled data example 1.png" alt="searching for values from a continuous measurement" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Searching for values from a continuous measurement</em></figcaption>
</figure>
<br clear="all"/>

If the DiGA states the same `search` query again one hour later, the newest data being available at the Device Data Recorder is now from May, 6th 11:00 am. Therefore now the _preliminary_ chunk contains 60 additional values.

<figure>
<div class="gem-ig-svg-container">
  <img src="HDDT measurement sampled data example 1b.png" alt="searching for values from a continuous measurement" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Searching for values from a continuous measurement</em></figcaption>
</figure>
<br clear="all"/>

__Remark__: In the given example the DiGA could as well have used a `read` interaction to just obtain an updated version of the _preliminary_ chunk:
```
GET [base]/Observation/3
```

##### Change of calibration.status
Some sensors for continuous measurements require initial or regular calibration. If this leads to a changed value for `calibration.state` in the [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) observation that is bound to a chunk, the Device Data Recorder MUST finish the current chunk and start a new chunk. The same holds for any other change in `calibration.state`, e.g. a sensor that switches from a calibrated to an unknown state after a certain time (see figure below.)

<figure>
<div class="gem-ig-svg-container">
  <img src="HDDT measurement sampled data example 2.png" alt="searching for values from a continuous measurement" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Searching for values from a continuous measurement</em></figcaption>
</figure>
<br clear="all"/>

As can be seen with the example, the last chunk before calibration is set to a _final_ status and the `effectivePeriod` is adapted to the end time the calibration state changed. The new chunk is initialized with a _preliminary_ status and the fixed _chunk-time-span_. 

It is up to the Device Data Recorder if a change of `calibration.state` leads to a new [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource or if a new version of the existing resource is created. See [Versioning of Device and DeviceMetric Resources](#versioning-of-device-and-devicemetric-resources) above for possible options related to the manufacturer's overall versioning strategy.

Personal Health Devices MAY require a Personal Health Device of another type to perform the calibration (e.g. a blood glucose meter for calibrating a rtCGM). Values measured with another Personal Health Device for calibration purposes MUST NOT be part of a chunk of continuously measured data. 

##### Changing Devices
[Pairing](pairing.html) a DiGA with a Device Data Recorder is always done for a specific patient and a specific type of Personal Health Device. If the patient exchanges the Personal Health Device (e.g. gets a new insulin pump) for a new one of the same type, the DiGA does not need to re-pair with the Device Data Recorder. In this case the Device Data Recorder MUST handle the change of the instance of the Personal Health Device internally. Nevertheless, the DiGA MUST be able to detect that a change of the Personal Health Device took place. This is done by the Device Data Recorder by finishing the current chunk and starting a new chunk with a new `device` reference to a [Device](https://hl7.org/fhir/R4/device.html) resource that reflects the new Personal Health Device (see figure below).

<figure>
<div class="gem-ig-svg-container">
  <img src="HDDT measurement sampled data example 3.png" alt="searching for values from a continuous measurement" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Searching for values from a continuous measurement</em></figcaption>
</figure>
<br clear="all"/>

In contrast to a change of `calibration.state`, a change of the Personal Health Device MUST always result in a new Device resource with a new `id`. 

##### Missing Values with Continuous Measurements
A response of the Device Data Recorder to a query for continuously measured data MAY be incomplete in a way that there MAY be more data measured for the requested period, but the Device Data Recorder does not provide this data to the DiGA. The most common case is that a DiGA requests for data that was measured very recently (e.g. within the last hour). The Device Data Recorder MAY respond with all data that is available at the time of the request, but there MAY be more data being in transmission from the Personal Health Device to the Health Record. Therefore a DiGA SHOULD always obtain the static property `Delay-From-Real-Time` from the Personal Health Device's [DeviceDefinition](https://hl7.org/fhir/R4/devicedefinition.html) (see above) and use this value to overlap two consecutive requests for data.

Missing data MAY even occur if the connection between the Personal Health Device and the Personal Health Gateway or between the Personal Health Gateway and the Health Record was broken during the requested period and the missing data may be transmitted to the Health Record after the connection is re-established. A Device Data Recorder MUST signal this kind of missing data by setting the `status` of the [Observation](https://hl7.org/fhir/R4/observation.html) resource that holds the chunk to _preliminary_ with the `effectivePeriod` covering the full _chunk-time-span_. 

Another reason for missing data is a change of the Personal Health Device (e.g. a rtCGM is replaced by a new sensor). A DiGA MAY detect missing data due to device changes by analyzing the sequence of ([Observation](https://hl7.org/fhir/R4/observation.html)s) it received from a Device Data Recorder. If the `effectivePeriod.end` of a chunk is before the `effectivePeriod.start` of the next chunk, there is a gap in the data. The DiGA MAY use the `id` of the [Device](https://hl7.org/fhir/R4/device.html) resource that is referenced in the `device` element of the chunks to check if the Personal Health Device changed (see above). 

##### Continuously Polling for New Data
A DiGA MAY poll a Device Data Recorder in regular intervals for new data. For the current chunk data updates can be polled by _read_ interactions. A `status` switch from _preliminary_ to _final_ signals that the chunk is full or that the status of the Personal Health Device changed (e.g. the sensor changed its calibration status or the patient put on a new sensor). In this case the DiGA MUST use the `effectivePeriod.end` of the last chunk as a starting point for a new _search_ interaction to obtain the next chunk. 

The pseudo code below shows an example of a DiGA polling for new data in regular intervals.

```
chunk = read [base]/Observation?date= [now]

loop
  while chunk.status == preliminary 
    wait some time
    chunk = read [base]/Observation/[chunk.id] 
  end
  wait some time
  chunk = read [base]/Observation?date=gt[chunk.effectivePeriod.end + 1 second]
end

```

### Querying for Aggregated Data

The legal requirements of § 374a SGB V specify that a medical aid or implant must be able to provide aggregated data to DiGA. In the present specification, this is limited to data calculated from the MIVs provided by the medical aid or implant. For example, for a connected rtCGM a Device Data Recorder must only be able to provide key metrics that can be calculated exclusively on the continuously collected glucose values which represent the MIV "Continuous Glucose Measurement". In order to minimise computational efforts at the manufacturer of the Device Data Recorder, DiGA can only request for aggregated or summarised data in the form of standardised reports. A DiGA cannot, for example, query the number of hypoglycemias within a given period of time as a single value from the Device Data Recorder of an rtCGM, but only the complete set of relevant key metrics, e.g. such as those contained in the _ambulatory glucose profile (AGP)_. 

As far as available and usable, these reports represent existing specifications. For rtCGM data, for example, the specification of a [CGM Summary Observation from HL7 International](https://github.com/HL7/cgm) is adopted unchanged. In order to be as flexible as possible for future MIVs, the specification does not limit the reports to a certain FHIR resource definition. This allows for adopting standard FHIR IGs for standardized reports regardless if they are provided as FHIR Observations, DiagnosticReports or any other kind of DomainResource. 

As a dynamically derived artefact a report only becomes a "true" FHIR resource if it is persisted by a DiGA. The Device Data Recorder MAY decide to NOT persist dynamically assembled reports as addressable FHIR resources. In order to reflect this behaviour and to preserve maximum flexibility with respect to the type of FHIR resource used for a report, the HDDT specification defines dedicated [FHIR operations](https://hl7.org/fhir/R4/operations.html) for querying reports from a Device Data Recorder.

Each report is bound to the MIV that is used to calculate the report. A Device Data Recorder MUST provide a list of available reports for each MIV it supports. This list MUST be published by listing the respective FHIR operations in the Device Data Recorder's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) which MUST be obtainable by a DiGA through the `/metadata` endpoint of the Device Data Recorder's FHIR resource server.
