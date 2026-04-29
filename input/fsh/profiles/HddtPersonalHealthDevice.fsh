Profile: HddtPersonalHealthDevice
Parent: Device
Id: hddt-personal-health-device
Title: "Device – Personal Health Device"
Description: """
This profile defines a Personal Health Device within the context of § 374a SGB V. A Personal Health Device acc. to this profile is any
medical aid or implant that 
- is distributed to patients at the expense of the statutory health insurance and 
- transmits the data about the patient electronically to the device manufacturer or third parties, which make the data available to patients and/or physicians via publicly accessible networks. 
 
Personal Health Devices that fulfill the criteria of this regulation MUST be able to pass on data to authorized Digital Health Applications (DiGA acc. § 374a SGB V) using the protocols 
and interfaces as defined in the HDDT specification.

This profile helps a device data consuming DiGA to
- increase patient safety by comparing the serial number of a Personal Health Device as presented with this profile with the serial number the patient may have provided to the DiGA
- increase data quality by getting information about the current status of the end-to-end communication flow from the Personal Health Device to the device backend and thus being able to detect if there may be more data available for the requested period
- optimize its interactions with the device data providing resource server by getting access to the DeviceDefinition resource that holds static attributes about the device and its connected backend (e.g. minimum delay between data measurement and data availability)

**Obligations and Conventions:**

The Personal Health Device's backend regularely synchronizes with the device hardware through a gateway (_Personal Health Gateway_). 
The maximum delay that the concrete end-to-end synchronization from the Personal Health Device to the FHIR resource server imposes is provided by the BfArM _HIIS-VZ_ (Device Registry) per MIV
through the static attribute `Delay-From-Real-Time`. If a resource server has not synchronized with the connected Personal Health Device for a time span 
longer than `Delay-From-Real-Time`(e.g. due to temporarely lost Bluetooth or internet connectivity), the `status` of the Device resource that represents the 
Personal Health Device MUST be set to `unknown`.

**Constraints applied:**  
- `status` is set to _Must Support_ in order to allow a DiGA to detect missing data (e.g. due to connection issues)
- `deviceName` and `serialNumber` are set to _Must Support_ to allow a validation of the source of device data by comparing this information with information printed on the Personal Health Device
- `definition` is optional. If present it MUST refer to a DeviceDefinition resource in the BfARM HIIS VZ. This ensures that DiGA can only receive static product information which was registered by the vendor of the device.
- `expirationDate` is set to _Must Support_ to allow a DiGA to be aware of regular sensor changes (e.g. for patient wearing a rtCGM)
"""

* ^status = #active
* ^date = "2026-04-29"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* . ^short = "Personal Health Device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device MUST be a medical aid or implant."
* type from $vs-device-type (required)
* type ^short = "The machine-readable type of the Personal health device"
* status MS
* status ^requirements = "allow a requesting party to detect missing data (e.g. due to connection issues)"
* status ^comment = """
The `status` values _active_ and _inactive_ refer to the ability of the Personal Health Device to record and share measured data. E.g. a real-time 
Continuous Glucose Monitoring device usually stops recording and sharing glucose values after 14 days of wear, 
even though the sensor is still alive for a longer time. After these 14 days, the `status` switches from _active_ to _inactive_.

If a resource server has not synchronized with the connected Personal Health Device for a time span longer 
than stated in the static attribute `Delay-From-Real-Time`(e.g. due to temporarely lost Bluetooth or internet connectivity), 
the `status` of the Device resource that represents the Personal Health Device MUST be set to `unknown`. The device 
specific value of the static attribute `Delay-From-Real-Time` can be obtained through the device's DeviceDefinition resource.
"""
* definition 0..1
// * definition only Reference(DeviceDefinition)
* definition ^short = "Definition of the Personal health device"
* definition ^definition = "Reference to a DeviceDefinition resource of the HIIS that describes the technical and functional details of the Personal health device."
* obeys device-definition-reference-check-1
* expirationDate MS
* expirationDate ^short = "Date and time of expiry of this Personal health device (if applicable)"
* expirationDate ^definition = "The date and time beyond which this Personal Health Device is no longer valid or should not be used (if applicable)."
* expirationDate ^comment = """
The expiration date signals the _end of communication_ (which is latest the devices _end of life_). E.g. a real-time 
Continuous Glucose Monitoring device usually stops recording and sharing glucose values after 14 days of wear, 
even though the sensor is still alive for a longer time. The `expirationDate` in this case is 14 days after the 
patient started the sensor.  
"""
* serialNumber MS
* serialNumber ^short = "Serial number of the Personal health device"
* serialNumber ^definition = "The serial number that uniquely identifies the Personal Health Device instance."
* serialNumber ^comment = "The serial number MAY only be omitted if neither the Personal Health Device nor its manual and packaging hold the printed serial number and if the Personal Health Device does not provide an API for reading a unique number from the device hardware."
* deviceName MS
* deviceName ^short = "Name of the Personal health device"
* deviceName ^definition = "The name of the Personal health device as given by the manufacturer and listed in the _HIIS-VZ_ (BfARM Device Registry)."

Invariant: device-definition-reference-check-1
Description: "Ensures that any device definition reference points to the HIIS domain."
Severity: #error
Expression: "definition.exists() implies definition.reference.contains('hiis.bfarm.de') or definition.resolve().identifier.where(system ='http://fhir.de/sid/gkv/hmnr').exists()"

