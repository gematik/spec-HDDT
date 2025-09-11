### Status: Draft (vollständig)
* Verantwortlich: @jcaumann
* ToDo:
    * Review

<hr>

§ 374a SGB V requests vendors of medical aids and implants to provide medical device data for authorized digital health applications (DiGA) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT), which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

### Building Blocks: Actors and Roles

The core building blocks of the HDDT ecosystem are already defined by law. § 374a SGB V names __personal health devices__ (medical aids and implants) as health device data providers and __DiGA__ as eligible health device data consumers. Definitions of these actors are managed by BfArM in the __DiGA registry__ and the __device registry__. DiGA vendors and health device vendors are responsible for actively ensuring that their respective entriesin these directories are complete and current. HDDT makes intense use of coded values to allow for an interoperable sharing and automatted processing of all transmitted data. All definitions of these codes used are managed in the German __central terminology server__ (ZTS). 

<div><img src="/HDDT core actors.png" alt="core building blocks of the HDDT ecosystem" width="60%"></div>
<br clear="all"/>

The HDDT API is defined as an backend API. It is asumed that the personal health device vendor (or an associated vendor) operates a health record on a server or in a cloud where all data measured by the device sensor is stored. The DiGA from its backend explicitly requests data from the personal health device's health record through FHIR RESTful queries and FHIR operations. 

Further information on the HDDT buildung blocks is given in the section [Participants](participants.md). The technical sepcifications of the interfaces which have to be provided by the defined building blocks can be found in the chapter __REST API__.

### Data to be transferd through the HDDT API

Subject of the data transmission as requested by § 374a SGB V are measured data, aggregated/derived data and configuration data:
- All data that is measured through sensors of the personal health device is considered as measured data and as such subject to the HDDT specifications. Data that is obtained by the personal health device from other sources (e.g. entered by the patient) is not considered to be measued data.
- All data that is aggregated or derived from measured data by the personal health device is subject to the HDDT specification, too.
- Any configuration settings that affect measured data directly or indirectly are subject to the HDDT specification, too. For the first introduction of HDDT in 2027 configuration data will only be considered if it directly affects measured data.  

The figure below shows the relationship between personal health devices, measured data and derived data for the domain "Diabetes Self-Management". Relationships between devices and measured data is n:m which means that any device could provide many kinds of measured data while each measured data may be provided by multiple kinds of personal health devices.

<div><img src="/diabetes devices and values.png" alt="devices and values in the domain diabetes self-management" width="60%"></div>
<br clear="all"/>

Further information on devices and data is given in the sections [Information Model](information-model.md) and (Retrieving Data)[retrieving-data.md]. The technical specifications of the FHIR resources that represent data and devices are domain specific. FHIR implementation guides for various kinds of device and data related to glucose measurements can be found in the chapter __UseCase Diabetes Self Management__.


### Security Services
It is asumed that the DiGA and the personal health device do not have a common shared patient identifier. Even though the German GesundheitsID is a global patient ID which could be used for identifying the patient, recently neither DiGA nor personal helath devices are allowed to obtain this identifier from the patient's health insurance. Therefore if a patient allows a DiGA to request device data from a personal heath device, DiGA and health device must first link their respective patient accounts. This is done by the DiGA calling an API at an Authorization Server that has to be implemented by the health device vendor. At this point the patient is already logged in with the DiGA while the Authorization Server forces the patient to as well log in with the patient frontend of the personal health device. The patient is now simultanously activated with at both actors, which allows DiGA and health device to share a common identifier that unambigously identifies the combination of patient, DiGA and health device ("pairingID"). 

The pairing flow is based on the OAuth2 standard. The requested measured data which is requested by the DiGA is encoded as an OAuth Scope. Upon pairing the personal health device validates the requested scope with the DiGA registry at BfArM. This registry lists for all DiGA the measured data that the DiGA is allowed to process. The committed OAuth2 Scope is then encapsuled with an access token that is handed back to the DiGA by the authorization server. Whith every request for data the DiGA provides the personal health device with this access token as a proof of authorization. Access token can be renewed using the standard means of OAuth2.

The sequence diagramm below sketches the pairing flow between DiGA and personal heath device.

__@sergej-reiser-fbeta: Bitte hier noch ein vereinfachtes Sequenzdiagramm zu dem Pairing-Flow einfügen.__

Further information on the authorization server and the authorization flow is given in the section [Pairing](pairing.md). The technical sepcification of the HDDT profile on the OAuth2 standard can be found in the section [OAuth API](oauth-api.md).

