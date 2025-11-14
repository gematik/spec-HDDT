[comment]: # (List of profile names below for easier replacing. Select -> Change All Occurances)
[comment]: # (HDDT Lung Function Single Measurement --- StructureDefinition-hddt-lung-function-measurement.html)
[comment]: # (HDDT Lung Function Reference Value --- StructureDefinition-hddt-lung-reference-value.html)
[comment]: # (HDDT Complete Lung Function Measurement --- StructureDefinition-hddt-lung-function-measurement-complete.html)

This chapter provides obligations and guidelines for manufacturers of Device Data Recorders for implementing a FHIR Resource Server for the Mandatory Interoperable Value (MIV) _Lung Function Meansurement_.

This chapter builds on the [HDDT Information Model](information-model.html), the [HDDT Generic FHIR API](himi-diga-api.html), and the [HDDT guide for retrieving device data](retrieving-data.html). It constraints these guidelines with respect to the specific requirements for exposing lung function measurements to DiGA, including:

- The endpoints to implement and how they differ from the [Generic FHIR API model](himi-diga-api.html)
- The relevant FHIR profiles for lung function measurement and how they constrain and extends the [HDDT Information Model](information-model.html)
- CConventions for sharing FHIR resources to ensure compliance with the [HDDT guide for retrieving device data](retrieving-data.html)
- Example requests and responses to support implementation

### Impelemntation Duties for Manufacturers of Device Data Recorders

Manufacturers of Device Data Recorders that support the MIV _Lung Function Measurement_:
- MUST implement and operate a FHIR Resource Server as defined in this chapter, 
- MUST implement and operate an [OAuth2 Authorization Server](authorization-server.html),
- MUST register the Device Data Recorder with its FHIR Resource Server and OAuth2 Authorization Server at the _BfARM HIIS-VZ_ (BfArM Device Registry),
- MUST consider the HDDT requirements on [security, privacy](security-and-privacy.html) and [operational service levels](operational-requirements.html).

Further obligations MAY be defined by gematik and BfArM as part of the upcoming processes for conformance validation and registration.

### FHIR Resource Server
The Device Data Recorder's FHIR Resource Server gives DIGA access to measured data and related information about devices. A Device Data Recorder's FHIR Resource Server that serves the MIV _Lung Function Measurement_ MUST implement the following endpoints and profiles:

* retrieval of the Resource Servers's [Capability Statement](https://hl7.org/fhir/R4/capabilitystatement.html) through a [`/metadata` endpoint](fhir-api-metadata.html).
* HDDT common RESTful interactions on a [Device](https://hl7.org/fhir/R4/device.html) endpoint that implements the [HDDT Personal Health Device](StructureDefinition-hddt-personal-health-device.html) profile. These interactions are common for all MIVs. The full specification of the interactions can be found [here](fhir-api-device.html).
* MIV-specific interactions on an [Observation](https://hl7.org/fhir/R4/observation.html) endpoint that implements all observavtion profiles relevant for the MIV _Lung Function Measurement_. These interactions and underlying profiles are specific for implementing the MIV. The full specifications are given below.
    - [HDDT Lung Function Single Measurement](StructureDefinition-hddt-lung-function-measurement.html)
    - [HDDT Lung Function Reference Value](StructureDefinition-hddt-lung-reference-value.html)
    - [HDDT Complete Lung Function Measurement](StructureDefinition-hddt-lung-function-measurement-complete.html)

The figure below shows the adaption of the [HDDT Information Model](information-model.html) for the MIV _Lung Function Measurement_. Elements denoted as _[1..1]_ or _MS_ are mandatory for the MIV _Lung Function Measurement_ (see [Use of HL7 FHIR](use_of_hl7_fhir.html)).

<figure>
<div class="gem-ig-svg-container" style="width: 80%;">
  {% include HDDT_Informationsmodell_MIV_Lung_Function.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Profiling of the HDDT Information Model for the MIV Lung Function Measurement</em></figcaption>
</figure>

<br clear="all"/>

All interactions on HDDT-specific endpoints require that the requestor presents a valid Access Token that was issued by the Device Data Recorder's OAuth2 Authorization Server (see [Pairing](pairing.html) for details). The authorization of the reuqest follows the principles defined for [HDDT Smart Scopes](smart-scope.html). For the MIV _Lung Function Measurement_ only the following scopes MUST be set:

```
patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-lung-function-measurement
patient/Device.rs
patient/DeviceMetric.rs
```

### Observation Profiles 
#### Observation Profile _HDDT Lung Function Single Measurement_



##### Snapshot View of the Profile

<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-function-measurement'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-function-measurement'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-function-measurement'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-function-measurement-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-function-measurement-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-function-measurement.html) for this profile.

#### Observation Profile _HDDT Lung Function Reference Value_
##### Snapshot View of the Profile
<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-reference-value'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-reference-value'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-reference-value'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-reference-value-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-reference-value-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-reference-value.html) for this profile.

#### Observation Profile _HDDT Complete Lung Function Measurement_
##### Snapshot View of the Profile
<div id="tabs-key">
  <div id="tbl-key">
    <p><strong>Profile: </strong> {{site.data.structuredefinitions['hddt-lung-function-measurement-complete'].title}}</p>
    <p>
      This structure is derived from
      <a href="{{site.data.structuredefinitions['hddt-lung-function-measurement-complete'].basepath}}">
        {{site.data.structuredefinitions['hddt-lung-function-measurement-complete'].basename}}
      </a>
    </p>
    <div id="tbl-key-inner">
      {% include StructureDefinition-hddt-lung-function-measurement-complete-snapshot-by-key-all.xhtml %}
    </div>
  </div>
</div>

<div>
    <p><strong>Detailed description of differential elements</strong></p>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      {%include StructureDefinition-hddt-lung-function-measurement-complete-dict-diff.xhtml%}
    </div>
</div>

For information on general constraints and terminology bindings see the full [StructureDefinition](StructureDefinition-hddt-lung-function-measurement-complete.html) for this profile.



#### Conventions and Best Practice

#### Examples

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include HDDT_Objektmodell_LF_Complete.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>HDDT Object Model Example (Lung Function Measurement)</em></figcaption>
</figure>

<br clear="all"/>


### MIV-specific Endpoints and Interactions
#### Observation - READ

#### Observation - SEARCH

#### Example: FHIR-READ

### Example: FHIR-Search for specific LOINC code

### Example: FHIR-Search include DeviceMetric

