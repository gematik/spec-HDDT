
This chapter provides obligations and hints for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Blood Pressure Monitoring_.  

This chapter builds on the [HDDT Information Model](information-model.html), the [HDDT Generic FHIR API](himi-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constraints these guidelines with respect to the specific requirements for exposing blood pressure monitoring to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html)
- The relevant FHIR profile for blood pressure monitoring and how it constraints and extends the [HDDT Information Model](information-model.html)
- Conventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Implementation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Blood Pressure Monitoring_ 
- MUST implement and operate a FHIR Resource Server as defined in this chapter, 
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HIIS-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server
The Device Data Recorder's FHIR Resource Server gives DiGA access to measured data and related information about devices and device metrics. A Device Data Recorder's FHIR Resource Server that serves the MIV _Blood Pressure Monitoring_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Server's [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](fhir-api-metadata.html).
* HDDT common RESTful interactions on a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) endpoint that implements the [HDDT Sensor Type and Calibration Status]
  <!--Question: auch relevant für BPM? -->
* (StructureDefinition-hddt-sensor-type-and-calibration-status.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-devicemetric.html).
* HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-device.html).
* MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Blood Value](StructureDefinition-hddt-pressure-value.html) profile. These interactions and the underlying profile are specific for implementing the MIV _Blood Pressure Monitoring_. The full specifications are given below.

The figure below shows the adaption of the [HDDT Information Model](information-model.html) for the MIV _Blood Pressure Monitoring_. Elements denoted as _[1..1]_ are mandatory oder MS for the MIV _Blood Pressure Monitoring_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)). 

<figure>
<div class="gem-ig-svg-container" style="width: 80%;">
  {% include HDDT_Informationsmodell_MIV_Blood_Glucose.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Profiling of the HDDT Information Model for the MIV Blood Glucose Measurement</em></figcaption>
</figure>

<br clear="all">

<!-- HIER FEHLT NOCH DER ZWISCHENTEIL -->
All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.html) for details). The authorization of the request follows the principles defined for [HDDT Smart Scopes](smart-scopes.html). For the MIV _Blood Glucose Measurement_ only the following scopes MUST be set:
```
patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-glucose-measurement
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profile _HDDT Blood Glucose Measurement_
This section discusses the _HDDT Blood Glucose Measurement_ profile, which constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource for representing blood glucose measurements. For the full normative specifiction of this profile see the respective [StructureDefinition](StructureDefinition-hddt-blood-glucose-measurement.html).
<!-- -------------------------------- -->
#### Snapshot View of the Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-blood-pressure-value'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-blood-pressure-value'].basepath}}">
        {{site.data.structuredefinitions['hddt-blood-pressure-value'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-blood-pressure-value-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-blood-pressure-value-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-blood-pressure-value.html) for this profile.

#### Conventions and Best Practice
<!-- S -->

