
§ 374a SGB V requests vendors of medical aids and implants to provide medical device data for authorized digital health applications (DiGA) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT), which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

### Building Blocks: Actors and Roles

The core building blocks of the HDDT ecosystem are already defined by law. § 374a SGB V names __Personal Health Devices__ (medical aids and implants) as Personal Health Device data providers and __DiGA__ as eligible Personal Health Device data consumers. Definitions of these actors are managed by BfArM in dedicated registries for DiGA and devices (_BfARM DiGA Verzeichnis_ and _BfARM Hilfsmittel-Schnittstellen-Verzeichnis (HiMi-SST-VZ)_) . DiGA vendors and manufacturers of Personal Health Devices are responsible for actively ensuring that their respective entries in these directories are complete and current. HDDT makes intense use of coded values to allow for an interoperable sharing and automated processing of all transmitted data. All definitions of these codes used are managed in the German __Central Terminology Server__ (_Zentraler Terminologieserver_). 

<div><img src="/HDDT core actors.png" alt="core building blocks of the HDDT ecosystem" width="60%"></div>
<br clear="all"/>

The HDDT API is defined as an backend API. It is asumed that the Personal Health Device manufacturer (or an associated vendor) operates a Health Record on a server or in a cloud where data measured by the device sensor is stored. The DiGA from its backend explicitly requests data from the Personal Health Device's Health Record through FHIR RESTful queries and FHIR operations. 

Further information on the HDDT buildung blocks is given in the section [Participants](participants.html). The technical specifications of the interfaces which have to be provided by the defined building blocks can be found in the chapter __REST API__.

### Data to be transferred through the HDDT API

Subject of the data transmission as requested by § 374a SGB V are measured data, aggregated/derived data and configuration data:
- All data that is measured through sensors of the Personal Health Device is considered as measured data and as such subject to the HDDT specifications. Data that is obtained by the Personal Health Device from other sources (e.g. entered by the patient) is not considered to be measured data.
- All data that is aggregated or derived from measured data by the Personal Health Device is subject to the HDDT specification, too.
- Any static and dynamic attributes that make up the configuration of the device are subject to the HDDT specification, too. For the first introduction of HDDT in 2027 only attributes will only be considered that 
  - affect the general ability of a DiGA to process the received device data for the DiGA's eligible purposes (e.g. calibration status of the Personal Health Device) or 
  - that affect the interaction between the DiGA and the backend services of the Personal Health Device (e.g. discovering missing data so that a request may be stated again in the future).

The figure below shows the relationship between Personal Health Devices, measured data and derived data for the domain "Diabetes Self-Management". Relationships between devices and measured data is n:m which means that any device could provide many kinds of measured data while each measured data may be provided by multiple kinds of personal Personal Health Devices.

<div><img src="/diabetes devices and values.png" alt="devices and values in the domain diabetes self-management" width="60%"></div>
<br clear="all"/>

Further information on devices and data is given in the sections [Information Model](information-model.html) and [Retrieving Data](retrieving-data.html). The technical specifications of the FHIR resources that represent data and devices are domain specific. FHIR implementation guides for various kinds of device and data related to glucose measurements can be found in the chapter __MIV-Specific APIs__.

### Minimum Interoperable Values

As stated, the relationship between Personal Health Devices and measured data is many-to-many. The same holds for DiGA and required data; e.g. a diabetes DiGA may use blood glucose values from glucometers as well as data about insulin injections from SmartPens for it's legitimite purposes. For matching data which is requested by DiGA with data which is provided by Personal Health Devices, the HDDT specification introduces the notion of __Mandatory Interoperable Values (MIVs)__. A MIV is a conceptual definition of a certain kind of device data that is processed by DiGA. A "conceptual definition" defines data by its properties and purposes within the context of a DiGA device data processing scenario. An example for a MIV is _Blood Glucose Measurement_. This MIV is measured from blood according to care plan (e.g. taking measurements before main meals) or on demand. Values are usable for clinical decisions. _Continuous Glucose Measurement_ is another example for a MIV. This one is measured continuously in interstitial fluid (and in the future probably even through optical means) and suitable for calculating key indicators for the status of the treatment (e.g. %TIR and GMI). By this even though these two MIVs express glucose values, they both will presumably be used in different use cases by different DiGA. 

The DiGA Registry and _HiMi-SST-VZ_ (Device Registry) at BfArM record for each DiGA and Personal Health Device the MIVs which are processed. This allows for discovering which devices match the demands of a certain DiGA and which DiGA can process the data provided by a certain device.

### Security Services
It is asumed that the DiGA and the Personal Health Device do not have a common shared patient identifier. Even though the German _GesundheitsID_ (health ID) is a global patient ID which could be used for identifying the patient, recently neither DiGA nor Personal Health Devices are allowed to obtain this identifier from the patient's health insurance. Therefore if a patient allows a DiGA to request device data from a Personal Health Device, DiGA and Personal Health Device must first link their respective patient accounts. This is done by the DiGA calling an API at an Authorization Server that has to be implemented as part of the Personal Health Device's backend services. At this point the patient is already logged in with the DiGA while the Authorization Server forces the patient to as well log in with the patient frontend that controls the Personal Health Device. The patient is now simultanously activated with both actors, which allows DiGA and Personal Health Device to share a common identifier that unambigously identifies the combination of patient, DiGA and Personal Health Device ("pairing-ID"). 

The pairing flow is based on the OAuth2 standard. The requested measured data which is requested by the DiGA is encoded as an OAuth Scope. Upon pairing the Personal Health Device validates the requested scope with the DiGA registry at BfArM. This registry lists for all DiGA the MIVS - represented by MIVs value set of LOINC codes - that the DiGA is allowed to process. The committed OAuth2 Scope is then encapsuled with an access token that is handed back to the DiGA by the authorization server. Whith every request for data the DiGA provides the Personal Health Device with this access token as a proof of authorization. Access token can be renewed using the standard means of OAuth2.

The sequence diagramm below sketches the pairing flow between DiGA and Personal Health Device followed by a request for device data using a FHIR RESTful interaction.

<div style="width: 100%;">
  <img src="assets/images/pairing_sequence_high_level.svg" style="width: 100%;" />
</div>

Further information on the authorization server and the authorization flow is given in the section [Pairing](pairing.html). The technical sepcification of the HDDT profile on the OAuth2 standard can be found in the section [OAuth API](oauth-api.html).

