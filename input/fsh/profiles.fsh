Alias: $cgm-summary = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary
Alias: $cgm-summary-mean-glucose-mass-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-mass-per-volume
Alias: $cgm-summary-mean-glucose-moles-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-moles-per-volume
Alias: $cgm-summary-times-in-ranges = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-times-in-ranges
Alias: $cgm-summary-gmi = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-gmi
Alias: $cgm-summary-coefficient-of-variation = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-coefficient-of-variation
Alias: $cgm-summary-days-of-wear = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-days-of-wear
Alias: $cgm-summary-sensor-active-percentage = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-sensor-active-percentage
Alias: $ucum-units = http://hl7.org/fhir/ValueSet/ucum-units
// Alias: $DeviceDefinition = http://device-registry.bfarm.de/fhir/StructureDefinition/DeviceDefinition

Profile: HddtCgmSummary
Parent: Bundle
Id: hddt-cgm-summary
Title: "Bundle – Summary Data Measurements with related Devices/DeviceMetrics"
Description: """
This profile constrains the FHIR Bundle resource for use as the result container of the `$hddt-cgm-summary` operation.  
The operation requests CGM summary data and optionally returns the related device context.  

The Bundle is of type *collection* and MUST contain only resources of the following types:  
- Observations conforming to HL7 CGM profiles: 
    - [CGM Summary Observation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary.html)
    - [Mean Glucose (Mass)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
    - [Mean Glucose (Moles)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
    - [Times in Ranges](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-times-in-ranges.html)
    - [Glycemic Variability Index (GMI)](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-gmi.html)
    - [Coefficient of Variation](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-coefficient-of-variation.html)
    - [Days of Wear](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-days-of-wear.html)!
    - [Sensor Active Percentage](https://build.fhir.org/ig/HL7/cgm/StructureDefinition-cgm-summary-sensor-active-percentage.html)

- DeviceMetric resources conforming to `HddtSensorTypeAndCalibrationStatus` to provide configuration details for the CGM measurement device.  
- Device resources conforming to `HddtPersonalHealthDevice` to provide context about the actual Personal Health Device device used.  

The purpose of this Bundle profile is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic.  
It ensures interoperability across different implementations by defining a predictable response format.  
This supports use cases such as:  
- Retrieval of CGM summary metrics over a given time interval  
- Retrieval of raw CGM measurement series together with the associated device configuration  
- Combining measurement data and device metadata for downstream applications such as visualization, clinical decision support, or data export.  

**Constraints applied:**  
- `Bundle.type` is fixed to `collection`.  
- `Bundle.entry.resource` is restricted to CGM Observation profiles, HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus.  
- No other resource types are allowed in the Bundle.  
"""
* ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of CGM summary Observations and optionally related device resources returned by the $hddt-cgm-summary operation."
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus
* entry.resource ^short = "Observations with their related Devices and DeviceMetrics"

Profile: HddtPersonalHealthDevice
Parent: Device
Id: hddt-personal-health-device
Title: "Device – Personal Health Device"
Description: "Profile for a Personal Health Device used in the provision of healthcare."
* ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Personal Health Device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device MUST be a personal health device."
* type from HddtDeviceType (required)
* type ^short = "The machine-readable type of the Personal health device"
* statusReason MS
* statusReason ^short = "Reason for the current status of the Personal health device"
* statusReason ^definition = "A description of the reason for the current status of the Personal health device."
* definition 1..1
* definition only Reference(DeviceDefinition)
* definition ^short = "Definition of the Personal health device"
* definition ^definition = "Reference to a DeviceDefinition resource that describes the technical and functional details of the Personal health device."
* expirationDate MS
* expirationDate ^short = "Date and time of expiry of this Personal health device (if applicable)"
* expirationDate ^definition = "The date and time beyond which this Personal health device is no longer valid or should not be used (if applicable)."
* serialNumber MS
* serialNumber ^short = "Serial number of the Personal health device"
* serialNumber ^definition = "The serial number that uniquely identifies the Personal health device instance."
* deviceName MS
* deviceName ^short = "Name of the Personal health device"
* deviceName ^definition = "The name of the Personal health device as given by the manufacturer and listed in the BfArM Device registry."


Profile: HddtSensorTypeAndCalibrationStatus
Parent: DeviceMetric
Id: hddt-sensor-type-and-calibration-status
Title: "DeviceMetric – Sensor Type and Calibration Status"
Description: "Profile for the sensor type and calibration status of a Personal Health Device."
* ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Configuration or setting capability of a personal health device"
* . ^definition = "Describes the sensor type and calibration status of a personal health device as a DeviceMetric."
* unit from $ucum-units (preferred)
* unit ^short = "Unit of the measurement"
* unit ^definition = "The unit in which the associated measuring device delivers its measurement values."
* unit ^binding.description = "Defines the unit of measurement using codes from the ValueSet for blood glucose units."
* source 1..
* source only Reference(HddtPersonalHealthDevice)
* source ^short = "Reference to the device instance"
* source ^definition = "Points to the specific Device resource that uses this device configuration."
* operationalStatus MS
* calibration MS
* calibration.state 1..1

Profile: HddtBloodGlucoseMeasurement
Parent: Observation
Id: hddt-blood-glucose-measurement
Title: "Observation – Blood Glucose Measurement"
Description: "Profile for capturing blood glucose measurements as Observation."
* ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements is fixed to 'final'. Only verified and complete measurements with a valid value are represented."
* code from HddtMivBloodGlucoseMeasurement (required)
* code ^short = "Measurement type of blood glucose"
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for blood glucose measurements."
* effective[x] 1..1
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time or period when the blood glucose measurement was taken."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Measured blood glucose value"
* value[x] ^definition = "The quantitative blood glucose value, measured either in mass/volume (mg/dL) or moles/volume (mmol/L), represented as a UCUM Quantity."
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "References a DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference Device resource that describes the personal health device itself."


Profile: HddtContinuousGlucoseMeasurement
Parent: Observation
Id: hddt-continuous-glucose-measurement
Title: "Observation – Continuous Glucose Measurement"
Description: "Profile for capturing continuous glucose measurements (CGM) as Observation, representing a chunk of SampledData over a defined effective period."
* ^version = "0.1.1"
* ^status = #draft
* ^date = "2025-09-26"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Chunk of continuous glucose measurements"
* . ^definition = "An Observation representing a continuous glucose measurement (CGM) series over a defined effective period, captured as SampledData from a personal health device."
* status ^short = "Status of the continuous glucose measurements chunk"
* status ^definition = "The status of the continuous glucose measurements chunk. The status 'final' means the measurement is complete and verified; 'preliminary' means the data MAY be still being collected and not complete. It SHOULD be called at a later time for collecting complete data."
* code from HddtMivContinuousGlucoseMeasurement (required)
* code ^short = "Type of continuous glucose measurement"
* code ^binding.description = "Specifies the type of continuous glucose measurement using codes from the ValueSet for CGM measurements."
* effective[x] 1..1
* effective[x] only Period
* effective[x] ^short = "Time interval of CGM measurements chunk"
* effective[x] ^definition = "The time span covered by this chunk of continuous glucose measurements. The chunk-time-span is defined by the data recorder of the personal health device."
* effective[x].start 1..1
* effective[x].start ^short = "Start of measurement chunk"
* effective[x].end 1..1
* effective[x].end ^short = "End of measurement chunk"
* value[x] MS
* value[x] only SampledData
* value[x] ^short = "Series of glucose measurements"
* value[x].origin.unit ^short = "Unit of continuous glucose measurement"
* value[x].origin.unit ^definition = "The unit of measurement used for the origin of the SampledData in this continuous glucose measurement."
* value[x].origin.system 1..1
* value[x].origin.system = "http://unitsofmeasure.org" (exactly)
* value[x].origin.code 1..1
* value[x].origin.code from $ucum-units (required)
* value[x].origin.code ^short = "UCUM code for glucose unit"
* value[x].origin.code ^definition = "The UCUM code representing the unit of the continuous glucose measurement."
* value[x].origin.code ^binding.description = "Defines the measurement unit for continuous glucose values using UCUM codes."
* value[x].data 1..
* dataAbsentReason 0..1
* dataAbsentReason ^definition = "Indicates why the measurement data is missing. If set to 'temp-unknown', this measurement should be re-collected at a later time."
* dataAbsentReason ^comment = "For preliminary CGM measurements where the data is temporarily unavailable, use 'temp-unknown'. This signals that the measurement should be repeated later."
* device 1..1
* device only Reference(HddtPersonalHealthDevice or HddtSensorTypeAndCalibrationStatus)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "Reference to the DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference Device resource that describes the personal health device itself."


ValueSet: HddtMivBloodGlucoseMeasurement
Id: hddt-miv-blood-glucose-measurement
Title: "ValueSet - Blood Glucose Measurement from LOINC"
Description: "This ValueSet contains LOINC codes for blood glucose measurements."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-blood-glucose-measurement"
* ^version = "0.1.1"
* ^status = #draft
* ^experimental = false
* ^date = "2025-09-19"
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[+].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* LOINC#2339-0 "Glucose [Mass/volume] in Blood"
* LOINC#15074-8 "Glucose [Moles/volume] in Blood"
* LOINC#2345-7 "Glucose [Mass/volume] in Serum or Plasma"
* LOINC#14749-6 "Glucose [Moles/volume] in Serum or Plasma"


ValueSet: HddtMivContinuousGlucoseMeasurement
Id: hddt-miv-continuous-glucose-measurement
Title: "ValueSet – Continuous Glucose Measurement from LOINC"
Description: "This ValueSet contains LOINC codes for continuous glucose measurements."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-continuous-glucose-measurement"
* ^version = "0.1.1"
* ^status = #draft
* ^experimental = false
* ^date = "2025-09-19"
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[+].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* LOINC#105272-9 "Glucose [Moles/volume] in Interstitial fluid"
* LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"


ValueSet: HddtDeviceType
Id: hddt-device-type
Title: "Device Type of personal health devices"
Description: "Codes used to identify personal health devices, including BfArM, MDC, and SNOMED CT device concepts."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/hddt-device-type"
* ^version = "0.1.1"
* ^status = #draft
* ^experimental = true
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[+].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* Mdc#528391 "Blood Pressure Cuff"
* Mdc#528404 "Body Composition Analyzer"
* Mdc#528425 "Cardiovascular Device"
* Mdc#528402 "Coagulation meter"
* Mdc#528409 "Continuous Glucose Monitor"
* Mdc#528390 "Electro cardiograph"
* Mdc#528457 "Generic 20601 Device"
* Mdc#528401 "Glucose Monitor"
* Mdc#528455 "Independent Activity/Living Hub"
* Mdc#528403 "Insulin Pump"
* Mdc#528405 "Peak Flow meter"
* Mdc#528388 "Pulse Oximeter"
* Mdc#528397 "Respiration rate"
* Mdc#528408 "Sleep Apnea Breathing Equipment"
* Mdc#528426 "Strength Equipment"
* Mdc#528392 "Thermometer"
* Mdc#528399 "Weight Scale"
* urn:oid:2.16.840.1.113883.6.276#38017 "Dry salt inhalation therapy device"
* urn:oid:2.16.840.1.113883.6.276#38663 "Flexible video nephroscope"
* urn:oid:2.16.840.1.113883.6.276#42347 "Dental implant, endosseous, partially-embedded"
* urn:oid:2.16.840.1.113883.6.276#46352 "Bare-metal intracranial vascular stent"
* urn:oid:2.16.840.1.113883.6.276#47264 "Dual-chamber implantable pacemaker, demand"
* urn:oid:2.16.840.1.113883.6.276#62163 "Intrauterine cannula, reusable"
* urn:oid:2.16.840.1.113883.6.276#62260 "Air-conduction hearing aid acoustic tube"
* urn:oid:2.16.840.1.113883.6.276#62423 "Spinal cord/peripheral nerve implantable analgesic electrical stimulation system lead, wired connection"
* urn:oid:2.16.840.1.113883.6.276#62414 "Blue-light phototherapy lamp, home-use"
* urn:oid:2.16.840.1.113883.6.276#64587 "Uncoated knee femur prosthesis, ceramic"
* urn:oid:2.16.840.1.113883.6.276#64992 "ADAMTS13 activity IVD, kit, chemiluminescent immunoassay"
* include codes from system SNOMED_CT where concept is-a #49062001


Instance: HddtCgmSummaryOperation
InstanceOf: OperationDefinition
Usage: #definition
Title: "Search Operation for summary data measurement"
Description: """
The `$hddt-cgm-summary` operation is defined on the *Observation* resource type.  
It allows clients to request CGM summary data filtered by effective period, and optionally include related device context (Device, DeviceMetric).  

**Use cases supported by this operation include:**  
- Retrieving CGM summary statistics (mean glucose, time-in-range, GMI, etc.) for a patient over a specified interval  

**Input Parameters:**  
- `effectivePeriodStart` *(dateTime, optional)*: Lower bound of the observation effective period.  
- `effectivePeriodEnd` *(dateTime, optional)*: Upper bound of the observation effective period.  
- `related` *(boolean, optional)*: If true, the response bundle also contains related Device and DeviceMetric resources.  

**Output Parameter:**  
- `result` *(Reference, required)*: A Bundle conforming to profile `HddtCgmSummary` profile containing all matching CGM Observations and, if requested, their related devices.  

"""
* version = "0.1.1"
* id = "hddt-cgm-summary-operation"
* name = "HddtCgmSummaryOperation"
* title = "Search Operation for summary data measurement"
* status = #draft
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2025-09-19"
* affectsState = false
* code = #hddt-cgm-summary
* system = false
* type = true
* instance = false
* parameter[+].name = #effectivePeriodStart
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "Start of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #effectivePeriodEnd
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "End of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #related
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "If true, include related Device and DeviceMetric in the result bundle"
* parameter[=].type = #boolean
* parameter[+].name = #result
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].documentation = "Result bundle (HTTP 200 OK) containing summary data of measurements and optionally related resources"
* parameter[=].type = #Reference
* parameter[=].targetProfile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-cgm-summary"
