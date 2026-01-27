### Introduction
Authorized DiGA can access data from medical devices and implants through standard FHIR RESTful APIs and dedicated FHIR operations. These endpoints MUST be implemented by Device Data Recorders as [certification relevant systems](certification-relevant-systems.html)

This chapter defines the FHIR endpoints which are common to all Mandatory Interoperable Values (MIVs). MIV-specific specifications for _HDDT Observation Profiles_ and HDDT-specific FHIR operations can be found under the menu **MIV-Specific APIs**.

### FHIR Endpoints
The manufacturer of a certification relevant Device Data Recorder MUST implement the following endpoints, for the purpose of allowing DiGAs to access data from medical aids and implants according to § 374a SGB V:

- [API: CapabilityStatement (Metadata)](fhir-api-metadata.html)
- [API: Observation (Measurement data)](fhir-api-observation.html)
- [API: DeviceMetric (Device calibration)](fhir-api-devicemetric.html)
- [API: Device (Device instance and configuration)](fhir-api-device.html)

### Search Parameters

Search parameters are an integral part of this FHIR API, as they allow the client to request only resources matching certain criteria. For example, by requesting measurement data for a specific date range, or only for a specific LOINC code, as well as including of additional FHIR resources in the search result, sorting of search results, etc.

The table below lists what search parameters MUST, SHOULD, or MAY be supported. Each entry links to the search parameters section of the relevant FHIR resource specification. Implementation details for each search parameter (such as syntax and behavior) are defined by their data type on the linked page. For example, `code` uses the [token](https://hl7.org/fhir/R4/search.html#token) data type, while `device-name` uses the [string](https://hl7.org/fhir/R4/search.html#string) data type.

| Search parameter | Support | Applies to | Note |
|------------------|---------|------|------|
| `code`           | MUST | [Observation](https://hl7.org/fhir/R4/observation.html) | Constraining the search to a specific LOINC code, or code from a MIV [ValueSet](https://hl7.org/fhir/R4/valueset.htm).<br>[Link to search parameter list](https://hl7.org/fhir/R4/observation.html#search). |
| `date`           | MUST | [Observation](https://hl7.org/fhir/R4/observation.html) | Constrain search results based on a date or date range.<br>[Link to search parameter list](https://hl7.org/fhir/R4/observation.html#search).|
| `subject`        | MUST\* | [Observation](https://hl7.org/fhir/R4/observation.html) | \* Special considerations apply for the `subject` search parameter. See [Retrieving Data](retrieving-data.html#searching-observations-using-fhir-search-interactions) for more details.  <br>[Link to search parameter list](https://hl7.org/fhir/R4/observation.html#search).|
| `device-name`    | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their name.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `type`           | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their coded type.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `manufacturer`   | MUST | [Device](https://hl7.org/fhir/R4/device.html) | Search for devices by their manufacturer.<br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search) |
| `patient`        | MUST\* | [Device](https://hl7.org/fhir/R4/device.html) | \* The same special considerations as for the `Observation.subject` search parameter apply. See [Retrieving Data](retrieving-data.html#searching-observations-using-fhir-search-interactions) for more details.  <br>[Link to search parameter list](https://hl7.org/fhir/R4/device.html#search).|
| `_id`            | MUST | all | Search for resources by their logical id.<br>[Link](https://hl7.org/fhir/R4/search.html#id) |
|`_include`        | MUST | all | Request an additional FHIR resource to be included in the search results, e.g. search for [Observation](https://hl7.org/fhir/R4/observation.html) resources and include the referenced [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources in the resulting [Bundle](https://hl7.org/fhir/R4/bundle.html).<br>[Link](https://hl7.org/fhir/R4/search.html#include) |
| `_sort`          | MUST | all | Specifies the order to return search results, with optional descending order using a '-' prefix.<br>[Link](https://hl7.org/fhir/R4/search.html#sort) |
| `_count`         | MUST | all | Specifies the maximum number of resources to return in a single page of search results.<br>[Link](https://hl7.org/fhir/R4/search.html#count) |
| `_lastUpdated`   | SHOULD | all | Search for resources based on the last time they were changed.<br>[Link](https://hl7.org/fhir/R4/search.html#lastUpdated) |
| `_has`           | MAY | all | Allows selecting resources based on the properties of resources that refer to them (reverse chaining).<br>[Link](https://hl7.org/fhir/R4/search.html#has) |
| `_revinclude`    | MAY | all | Requests that resources which refer to the matched search results also be included in the resulting [Bundle](https://hl7.org/fhir/R4/bundle.html).<br>[Link](https://hl7.org/fhir/R4/search.html#revinclude) |


### Security Considerations

Access to a Device Data Recorder's FHIR Resource Server MUST be secured according to [RFC 8705: OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens](https://datatracker.ietf.org/doc/html/rfc8705). Details on concrete procedures and requirements for OAuth 2.0 Mutual-TLS Client Authentication are specified in the [Security and Privacy](security-and-privacy.html) chapter. 

With each request the DiGA MUST present a valid access token issued by the OAuth2 Authorization Server of the Device Data Recorder. The Device Data Recorder MUST validate the access token and MUST consider the data associated with the token (patientID, eligible MIVs) with the access control decision. Details about issuance and renewal of Access Token are specified in the [OAuth2 Authorization Server](authorization-server.html) chapter. Details about the application of the SMART scopes encoded with the Access Token are given in the [Smart Scopes](smart-scopes.html) chapter.

Both DiGA and Device Data Recorder MUST write access and usage logs according to the [Security and Privacy](security-and-privacy.html) chapter. 

The sequence diagram below illustrates the access control flow between a DiGA and the Device Data Recorder's FHIR Resource Server and OAuth2 Authorization Server. 

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Sequenz_Access_Control.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>RESTFul FHIR API Access Control Logic</em></figcaption>
</figure>
<br clear="all"/>

Remark: The FHIR Resource Server MAY cache registry information (e.g. certificate of a DiGA) and certificate status information (e.g. revocation status of a DiGA certificate). See the [Security and Privacy](security-and-privacy.html) chapter for details and maximum caching durations.