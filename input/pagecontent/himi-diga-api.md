### Introduction
Authorized DiGA can access data from medical devices and implants through standard FHIR RESTful APIs and dedicated FHIR operations. These endpoints MUST be implemented by Device Data Recorders as [certification relevant systems](certification-relevant-systems.html)

This chapter defines the FHIR endpoints which are common to all Mandatory Interoperable Values (MIVs). MIV-specific specifications for _HDDT Observation Profiles_ and HDDT-specific FHIR operations can be found under the menu **MIV-Specific APIs**.

### FHIR Endpoints
The manufacturer of a certification relevant Device Data Recorder MUST implement the following endpoints, for the purpose of allowing DiGA to access data from medical aid and implants according to § 374a SGB V:

- [API: CapabilityStatement (Metadata)](fhir-api-metadata.html)
- [API: Observation (Measurement data)](fhir-api-observation.html)
- [API: DeviceMetric (Device calibration)](fhir-api-devicemetric.html)
- [API: Device (Device instance and configuration)](fhir-api-device.html)


### Security Considerations

Access to a Device Data Recorder's FHIR Resource Server MUST be secured according to [RFC 8705: OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens](https://datatracker.ietf.org/doc/html/rfc8705). Details on concrete procedures and requirements for OAuth 2.0 Mutual-TLS Client Authentication are specified in the [Security and Privacy](security-and-privacy.html) chapter. 

With each request the DiGA MUST present a valid access token issued by the OAuth2 Authorization Server of the Device Data Recorder. The access token MUST be bound to the client certificate used for mutual TLS authentication. The Device Data Recorder MUST validate the access token and MUST consider the data associated wth the token (patientID, eligible MIVs) with the access control decision. Details about issuance and renewal of Access Token are specified in the [OAuth2 Authorization Server](oauth2-authorization-server.html) chapter. Details about the application of the SMART scopes encoded with the Access Token are given in the [Smart Scopes](smart-scopes.html) chapter.

Both DiGA and Device Data Recorder MUST write access and usage logs according to the [Security and Privacy](security-and-privacy.html) chapter. 

The sequence diagram below illustrates the access control flow between a DiGA and the Device Data Recorder's FHIR Resource Server and OAuth2 Authorization Server.

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Sequenz_Access_Control.svg %}
  <figcaption>RESTFul FHIR API Access Control Logic</figcaption>
  </div>
</figure>
<br clear="all"/>

