**@Jörg**

## Measurements and Devices

As depicted in the definition of (certification relevant systems)[certification-relevant-systems.md], each medical aid or implant can be divided into
* __personal device__: the hardware part including the __sensors__ that measure __patient data__ (e.g. vital signs)
* __aggregation manager__: an intermediate hardware and/or software that retrieves the sensor data at the patient's or doctor's side and takes care of securely forwarding it to a health record
* __health record__: a backend platform that stores the device data

This logical model builds the foundation of the HDDT FHIR data model:

| Logical model       | HDDT information model                                   | 
|---------------------|----------------------------------------------------------|
| personal device     | Personal Health Device `FHIR Device`                     |
| sensor              | Sensor Type and Calibration Status `FHIR DeviceMetric`   |
| patient data        | Interoperable Value `FHIR Observation`                   |
| aggregation manager | _no corresponding class_                                 |
| health record       | Health Record `FHIR Device`                              |

This core part of the HDDT information model can be implemented using standard HL7 FHIR resource definitions as shown in the UML class diagram below.

<div><img src="/HDDT_Informationsmodell_Generisch_DevicePart.svg" alt="core parts of the HDDT FHIR information model" width="60%"></div>
<br clear="all"/>

An __Interoperable Value__ represents the data that is measured by the sensor. This data can either be a single point of data or a sampled stream of data. An example of a single data point is an ad hoc measurement of capillary blood sugar using a blood glucose meter. An example of a stream of data is a sequence of continuous measurements done by a real time Continuous Glucose Monitoring device (rtCGM) during a defined period of time. Each measured data is classified by 
* a LOINC _code_ that defines the kind of data, e.g. a blood sugar value measured as mass per volume
* a timestamp (_date_) that marks the time or period at which the measurement was performed
* a _value_ that gives the measured value as defined by the _code_ including the _unit_ of the value and the sample rate (for data streams)
* a _status_ that signals the status of the _value_; e.g. signaling if a data stream is finalized or not

Each __Interoperable Value__ refers to the __Sensor Type and Calibration Status__ of the sensor that measured the value. The sensor type is defined by 
* a coded _type_ value that corresponds to the LOINC _code_ given with the measurement (Interoperable Value)
* a definition of the _unit_ that is preferrably to be used for presenting measured values to the patient. This _unit_ MAY differ from the _unit_ that is used with the _value_ of the Interoperable Value.

Example: A rtCGM sensor measures glucose values as mg/dl. All data is stored in the health record in this unit. The HDDT API at the health record provides the data only using mg/dl as the unit. At the mobile app that came with the rtCGM (the rtCGM's aggregation manager) the patient configured the preferred unit as mmol/l. Therefore even though the mobile app retrieves all data as mg/dl from the health record it transfers it to mmol/l before displaying it to the patient. In this example _value.unit_ of the __Interoperable Value__ is mg/dl while _unit_ within __Sensor Type and Calibration Status__ is mmol/l. The motivation for this behaviour is to allow the DiGA to obtain information about the patient's preference and thus to be in sync with the medical aid by displying measured values in the same unit.

Medical aids need to be calibrated in order to provide safe measurements. Some aids are already calibated by the manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. If a medical aid transmits data from a non calibrated sensor to the health record depends on the concrete product. For a DiGA to process device data in a safe manner, the DIGA must know if the data it received was gathered by a calibrated sensor or not. For this the __Sensor Type and Calibration Status__ contains a _calibration.state_ element.  

The __Sensor Type and Calibration Status__ of a measurement refers to the __Personal Device__ that contains the sensor. This is a many-to-one relationship which allows for a personal device to contain multiple sensors for different measured values. E.g. by this a pulseoximeter __Personal Device__ can provide _pulse_ and _SPO2_ as two diffferent interoperable values with each of this values being linked with a dedicated __Sensor Type and Calibration Status__. Each __Personal Device__ is described by 
* a human readable _device name_ and the name of the _manufacturer_
* its _serial number_. This element is flagged as _Must Support_ (see (_Use of HL7 FHIR_)[use_of_hl7_fhir.md#must-support-elements]) and as such MUST be provided by the medical device through the health record. This allows the patient to verify that the data processed by the DiGA really originated from the device he is wearing in/at his body.
* an _expiration date_ for devices which have a defined end-of-life. An example for this is an rtCGM which only transmitts data for 14 or 15 days (depending on the product) and after this is to be replaced by another device.
* further _property_ elements may be defined by the HDDT specification to cover specific configuration settings of specific decvice types.

As described in the section on (certification relevant systems)[certification-relevant-systems.md], a personal device may connect to different health records. E.g. a manufacturer of a blood glucose meter may have different diabetes management systems for different user groups that all can import data from the glucose meter. Each of these solutions may have its own backend and health record (e.g. a diabetes diary for patients as a mobile app and a monitoring website for doctors). All of these health records must be able to provide the imported blood glucose values to DiGA via the HDDT API. By this there is a many-to-many relationship between devices and health record. This is reflected in the HDDT FHIR information model by linking each __Personal Device__ resource with an __Health Record__ resource. 

The __Health Record__ resource again is based on the FHIR _Device_ resource definition. The resource only holds informative elements such as the name of the product that contains health record and the manufacturer of this product. The main purpose of this resource chain is in ensuring that a DiGA can access the right instance of the HDDT API by knowing, which health record is currently connected to the patients personal health device (see next section on _BfArM Registries_).


## BfArM Registries

<div>{% include HDDT_Informationsmodell_Generisch_Device_and_Definition.svg %}</div>
<br clear="all"/>

## MIVs

<div>{% include HDDT_Informationsmodell_Generisch_Complete.svg %}</div>
<br clear="all"/>