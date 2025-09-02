# Logical Viewpoints

§ 374a SGB V requests vendors of medical aids and implants to provide medical device data for authorized digital health applications (DiGA) through a standardized backend API. This API is specified by the Health Device Data Transfer (HDDT), which provides normative definitions for the data transfer itself as well as for accomplishing security services.   

## Building Blocks: Actors and Roles

The core building blocks of the HDDT ecosystem are already defined by law. § 374a SGB V names __personal health devices__ (medical aids and implants) as health device data providers and __DiGA__ as eligible health device data consumers. Definitions of these actors are managed by BfArM in the __DiGA registry__ and the __device registry__. DiGA vendors and health device vendors are responsible for actively ensuring that their respective entriesin these directories are complete and current. HDDT makes intense use of coded values to allow for an interoperable sharing and automatted processing of all transmitted data. All definitions of these codes used are managed in the German __central terminology server__ (ZTS). 

<div><img src="/HDDT core actors.png" alt="core building blocks of the HDDT ecosystem" width="60%"></div>
<br clear="all"/>

Further information on the HDDT buildung blocks is given in the section [Participants](participants.md). The technical sepcifications of the interfaces which have to be provided by the defined building blocks can be found in the chapter __REST API__.

## Data to be transferd through the HDDT API

Subject of the data transmission as requested by § 374a SGB V are measured data, aggregated/derived data and configuration data:
- All data that is measured through sensors of the personal health device is considered as measured data and as such subject to the HDDT specifications. Data that is obtained by the personal health device from other sources (e.g. entered by the patient) is not considered to be measued data.
- All data that is aggregated or derived from measured data by the personal health device is subject to the HDDT specification, too.
- Any configuration settings that affect measured data directly or indirectly are subject to the HDDT specification, too. For the first introduction of HDDT in 2027 configuration data will only be considered if it directly affects measured data.  

The figure below shows the relationship between personal health devices, measured data and derived data for the domain "Diabetes Self-Management". Relationships between devices and measured data is n:m which means that any device could provide many kinds of measured data while each measured data may be provided by multiple kinds of personal health devices.

<div><img src="/diabetes devices and values.png" alt="devices and values in the domain diabetes self-management" width="60%"></div>
<br clear="all"/>

Further information on devices and data is given in the sections [Information Model](information-model.md) and (Retrieving Data)[retrieving-data.md]. The technical specifications of the FHIR resources that represent data and devices are domain specific. FHIR implementation guides for various kinds of device and data related to glucose measurements can be found in the chapter __UseCase Diabetes Self Management__.

## Security Services


