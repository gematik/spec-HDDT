Profile: HddtSensorTypeAndCalibrationStatus
Parent: DeviceMetric
Id: hddt-sensor-type-and-calibration-status
Title: "DeviceMetric – Sensor Type and Calibration Status"
Description: """
The HddtSensorTypeAndCalibrationStatus profile captures the calibration status of a sensor which is part of a Personal Health Device. 

Personal Health Devices need to be calibrated in order to provide safe measurements. Some devices are already calibrated by the 
manufacturer while others calibrate themselves after activation and others need to be calibrated by the patient. 
If a Personal Health Device transmits data from a non calibrated sensor to the resource server at all depends on the concrete product. 
For a DiGA as a device data consumer to process device data in a safe manner, it must be transparent if the data it received was 
measured by a calibrated sensor or not. 

For devices where the sensor that measured a value requires automated or manual calibration, the Observation capturing this value 
MUST refer to a HddtSensorTypeAndCalibrationStatus resource through its `Observation.device` element. 
The HddtSensorTypeAndCalibrationStatus implements a FHIR [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resource which 
holds calibration information in a `calibration.type`, a `calibration.state` and a `calibration.date` element. In addition 
the HddtSensorTypeAndCalibrationStatus can provide a definition of the `unit` that is preferrably to be used for presenting 
measured values to the patient. 

The HddtSensorTypeAndCalibrationStatus of a measurement MUST always refer to a HddTPersonalHealthDevice [Device](https://hl7.org/fhir/R4/device.html) resource that represents the 
Personal Health Device that contains the sensor. This is a many-to-one relationship which allows for a Personal Health Device to 
contain multiple sensors for different measured values. E.g. by this a pulse oximeter as a HDDT Personal Health Device can 
provide _pulse_ and _SPO2_ as two different interoperable values with each of this values being linked with a 
dedicated HddtSensorTypeAndCalibrationStatus resource. 

**Obligations and Conventions:**

DiGA as device data consumers SHOULD NOT rely on the `DeviceMetric.operationalStatus` of a sensor as this status does only reflect the status of the sensor 
and does not provide information about the end-to-end status of the flow of device data from the sensor within the Personal Health Device 
to the resource server in the device backend. Instead DiGA SHOULD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element considers the end-to-end availability of data and therefore is the only source for 
information about potentially missing data (e.g. due to temporal problems with the bluetooth or internet connection).

**Constraints applied:**  
- `unit` is restricted to UCUM. 
- `source` is constrained as a mandatory element in order to enable a DiGA to obtain dynamic and static device attributes through this reference
- `calibration` is set to _Must Support_. This element and respective status information MUST be provided if the sensor performs automated or requires manual calibration after the device has been put into operation with the patient (`Device.status`is `active`).
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* . ^short = "Configuration or setting capability of a personal health device"
* . ^definition = "Describes the sensor type and calibration status of a sensor within a Personal Health Device as a DeviceMetric."
* unit from $ucum-units (required)
* unit ^short = "UCUM code of the unit of the measurement as it is used when presenting data to the patient"
* unit ^definition = "The unit in which the Personal Health Device presents its measurement values to the patient."
* unit ^requirements = "allow a DiGA to detect the unit the patient is used to"
* unit ^comment = """
This element holds the unit of measurement that is preferrably to be used for presenting measured values to the patient. 
This unit MAY differ from the unit that is used with the `Observation.value[x]` of measured data.

_Example_: A rtCGM sensor measures glucose values as mg/dl. All data is stored in the health record in this unit. 
The resource server provides the data only using mg/dl as the unit. At the mobile app that came with the rtCGM (the rtCGM’s 
Personal Health Gateway) the patient configured the preferred unit as mmol/l. Therefore all data is calculated (by the device or 
the app) to mmol/l before displaying it to the patient. In this example the unit of `Observation.value[x]` is mg/dl 
while `DeviceMetric.unit` is mmol/l. The motivation for this behaviour is to allow the DiGA to obtain information about the 
patient’s preference and thus to be in sync with the medical aid by displaying measured values in the same unit.
"""
* unit ^binding.description = "For HDDT only codes from UCUM MUST be used for coding units of measurements"
* source 1..
* source only Reference(HddtPersonalHealthDevice)
* source ^short = "Reference to the Personal Health Device holding the sensor"
* source ^definition = "Points to the specific Device resource that holds the sensor for which the documented calibration status applies."
* operationalStatus 0..1
* operationalStatus ^comment = """
DiGA as device data consumers SHOULD NOT rely on the `operationalStatus` of a sensor as this status does only reflect the status of the sensor 
and does not provide information about the end-to-end status of the flow of device data from the sensor within the Personal Health device 
to the resource server in the device backend. Instead DiGA SHOILD process the `Device.status` information that can be obtained through the 
`DeviceMetric.source` reference. This element considers the end-to-end availability of data and therefore is the only source for 
information about potentially missing data (e.g. due to temporal problems with the bluetooth or internet connection).
"""
* calibration MS
* calibration.state 1..1
* calibration.time MS
* calibration.time ^short = "Time when the last calibration has been performed"
* calibration.time ^definition = """
The time when the last calibration has been performed. This element covers both manual calibration performed 
by the patient and automated calibration performed by the device itself. E.g. with a self-calibrating rtCGM `calibration.time`
signals the time when the device started sending calibrated values after the initial calibration phase. 

If the sensor does not require calibration, this element MAY be omitted. 
"""
