
§ 374a SGB V requests vendors of medical aids and implants to provide medical device data for authorized digital health applications (DiGA) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT), which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

This chapter provides a logical view on the HDDT ecosystem and by this gives an overview of the specification-relevant aspects of the HDDT ecosystem. It introduces the core building blocks and their interactions. It also defines the data that is subject to the HDDT specification and the security services that are required for securely grant access to a patient's device data.

### Logical Building Blocks

For the HDDT specification, the HDDT ecosystem is be divided into several logical building blocks. For the components operated by the manufacturers of the medical aids' and implants' devices, frontends and backend systems, the HDDT specification follows the logical decomposition defined by the [Continua Health Alliance](https://www.slideserve.com/kanoa/continua-health-alliance) and adopted by the [HL7 Personal Health Device WG](https://hl7.org/fhir/uv/phd/index.html):
* The __Personal Health Device__ is the sensor hardware of the medical aid or implant and realizes the sensory recording of data on, at or inside the patient. 
* The data is transmitted via a local point-to-point connection to a __Personal Health Gateway__, which validates the data, prepares it and, if necessary, merges it with other data. For most devices, the Personal Health Gateway will be a mobile application on a smartphone or tablet, but it is not uncommon to have dedicated mobile controllers (e.g. in some insulin pumps), desktop systems or web portals (e.g. for wired data import) or set-top boxes (e.g. for implants). 
* The data is transmitted to a background system via an internet connection and persisted there in a __Health Record__. 

The legislative rational for § 374a SGB V explicitly defines the HDDT API for disclosing data from medical aids and implants to eligible DiGA as a backend API. Therefore DiGA MUST access device data only through the Health Record. For HDDT the Health Record acts as a __FHIR Resource Server__ that implements standard FHIR RESTful interactions that provide access to device data as FHIR resources. In this specification the term __Health Record__ is used synonymously with __FHIR Resource Server__, with the first preferably used when the perspective of the data controlling entity is taken and the second being preferred when the perspective of the data provider to DiGA is taken.

Access to the FHIR Resource Server is restricted to authorized DiGA which are listed with the ___BfArM DiGA-VZ___ (BfArM DiGA Registry). DiGA can proof authorization to the FHIR Resource Server through an OAuth Access Token. This token is issued by an __OAuth2 Authorization Server__ which is operated by the data controller, which is the owner of the Health Record. The Authorization Server not only considers a DiGA's permissions as recorded in the _BfArM DiGA-VZ_ but also takes care that the patient has given valid consent for sharing his health data with authorized DiGA (see [Pairing](pairing.html) for details).

In this specification the combination of Personal Health Gateway, Health Record (Resource Server), and OAuth2 Authorization Server is called the __Device Data Recorder__ (see section on [Certification Relevant Systems](certification-relevant-systems.html) for a discussion on various vendor constellations). The manufacturer of the Device Data Recorder is responsible for implementing the HDDT API which consists of the FHIR based API of the __FHIR Resource Server__ and the OAuth2 compliant API of the __OAuth2 Authorization Server__. 

In order to securely operate the HDDT API, Manufacturers of Device Data Recorders MUST
* gather information about connecting DiGA from the _DiGA-VZ_ (BfArM DiGA Registry),
* update their own entries with the _HIIS-VZ_ (BfArM Device Registry), and
* retrieve semantic artifacts from the __German Central Terminology Server__ (ZTS).

Interfaces to these three services are not part of the HDDT specification. A non-normative description of these services is given in the section [BfArM Registries and ZTS](registries-and-zts.html).

The figure below shows how these logical building blocks interact with each other.

<figure>
<div class="gem-ig-svg-container">
 <img src="HDDT building blocks.png" alt="building blocks of the HDDT ecosystem" width="65%">
  </div>
    <figcaption><em><strong>Figure: </strong>Building blocks of the HDDT ecosystem</em></figcaption>
</figure>
<br clear="all"/>


### Data to be transferred through the HDDT API

Subject of the data transmission as requested by § 374a SGB V are measured data, aggregated/derived data and configuration data:
- All data that is measured through sensors of the Personal Health Device is considered as measured data and as such subject to the HDDT specifications. Data that is obtained by the Personal Health Device or the Personal Health Gateway from other sources (e.g. entered by the patient) is not considered to be measured data.
- All data that is aggregated or derived from measured data is subject to the HDDT specification, if and only if it is stored with the Health Record. This includes data that is derived by the Personal Health Device or the Personal Health Gateway as well as key figures that are calculated by the Health Record itself. If a derived value is only processed locally with the Personal Health Device or the Personal Health Gateway and not stored with the Health Record, it is not subject to the HDDT specification.
- Any static and dynamic attributes that make up the configuration of the device are subject to the HDDT specification, too. For the initial HDDT specification (Version 1) only attributes will be considered that 
  - affect the general ability of a DiGA to process the received device data for the DiGA's eligible purposes (e.g. calibration status of the Personal Health Device) or 
  - affect the interaction between the DiGA and the Device Data Recorder (e.g. for discovering missing data so that a request may be stated again in the future).

The figure below shows the relationship between Personal Health Devices, measured data and derived data for the domain "Diabetes Self-Management". Relationships between Personal Health Devices and measured data is n:m which means that a Personal Health Device could provide many kinds of measured data while each measured data may be provided by multiple kinds of Personal Health Devices.

<figure>
<div class="gem-ig-svg-container">
 <img src="diabetes devices and values.png" alt="devices and values in the domain diabetes self-management" width="70%">
  </div>
    <figcaption><em><strong>Figure: </strong>Devices and values in the domain diabetes self-management</em></figcaption>
</figure>
<br clear="all"/>

Further information on devices and data is given in the sections [Information Model](information-model.html) and [Retrieving Data](retrieving-data.html). The technical specifications of the FHIR resources that measured data are domain specific. FHIR implementation guides for various kinds of data related to glucose measurements can be found in the chapter __MIV-Specific APIs__.

### Minimum Interoperable Values

As stated, the relationship between Personal Health Devices and measured data is many-to-many. The same holds for DiGA and required data; e.g. a diabetes DiGA may use blood glucose values from glucometers as well as data about insulin injections from SmartPens and body weight measurements from a digital scale for it's legitimate purposes. For matching the data that is requested by a DiGA with the data that is provided by Personal Health Devices via Device Data Recorders, the HDDT specification introduces the notion of __Mandatory Interoperable Values (MIVs)__. A MIV is a conceptual definition of a certain kind of device data that is processed by DiGA. A "conceptual definition" defines data by its properties and purposes within the context of a DiGA device data processing scenario. An example for a MIV is _Blood Glucose Measurement_. This MIV is measured from blood according to a care plan (e.g. taking measurements before main meals) or on demand (e.g. a patient detecting symptoms of hypoglycemia). Values are usable for clinical decisions. _Continuous Glucose Measurement_ is another example for a MIV. This one is measured continuously in interstitial fluid (and in the future probably even through optical means) and suitable for calculating key indicators for the status of the treatment (e.g. times in ranges and glucose management indicator) but values are not as acurate as _Blood Glucose Measurements_. Even though both of these two MIVs express glucose values, they both will presumably be used in different use cases by different DiGA. 

The _DiGA Verzeichnis_ and _HIIS-VZ_ at BfArM record for each DiGA, each Personal Health Device and each Device Data Recorder the MIVs which are processed. This allows for discovering which device data providers match the demands of a certain DiGA and which DiGA can process the data provided by a certain Personal Health Device via a certain Device Data Recorder.

### Security Services
It is assumed that the DiGA and Device Data Recorder do not have a common shared patient identifier. Even though the German _GesundheitsID_ (health ID) is a global patient ID which could be used for identifying the patient, recently neither DiGA nor Personal Health Devices or Device Data Recorders are allowed to obtain this identifier from the patient's health insurance. Therefore, if a patient allows a DiGA to request device data from a Personal Health Device through a Device Data Recorder, DiGA and Device Data Recorder must first link their respective patient accounts. This is done by the DiGA calling an API at the Device Data Recorder's OAuth2 Authorization Server. At this point the patient is already logged in with the DiGA while the OAuth2 Authorization Server forces the patient to as well log in with the Device Data Recorder's Personal Health Gateway that controls the Personal Health Device. The patient is now simultaneously activated with both actors, which allows DiGA and Device Data Recorder to share a common identifier that unambiguously identifies the combination of patient, DiGA and Device Data Recorder ("pairing-ID"). 

The [pairing flow](pairing.html) is based on the OAuth2 standard. The MIV that defines the measured data which is requested by the DiGA is encoded as an OAuth Scope. Upon pairing the Device Data Recorder validates the requested scope with the _DiGA-VZ_ at BfArM. This registry lists for all DiGA the MIVS - represented by a value set of LOINC codes - that the DiGA is allowed to process. The committed OAuth2 Scope is then encapsuled with an access token that is handed back to the DiGA by the OAuth2 Authorization Server. Whith every request for data the DiGA provides the Device Data Recorder with this access token as a proof of authorization. Access token can be renewed using the standard means of OAuth2.

The sequence diagramm below sketches the pairing flow between DiGA and Device Data Recorder followed by a request for device data using a FHIR RESTful interaction.

<figure>
<div class="gem-ig-svg-container" style="width: 80%;">
  {% include pairing_sequence_high_level.svg %}
  </div>
  <figcaption><em><strong>Figure: </strong>DiGA–Health Device Pairing (High Level)</em></figcaption>
</figure>

Further information on the OAuth2 Authorization Server and the authorization flow is given in the section [Pairing](pairing.html). The technical specification of the HDDT profile on the OAuth2 standard can be found in the section [Authorization Server](authorization-server.html). The required validation of access tokens for accessing FHIR resources from the Device Data Recorders FHIR Resource Server is specified in the section [Generic FHIR Resource Server API](himi-diga-api.html).

