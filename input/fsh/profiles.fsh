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

Profile: BundleSearchSummaryDataMeasurements
Parent: Bundle
Id: Bundle-Search-Summary-Data-Measurements
Title: "Bundle – Summary Data Measurements with related Devices/DeviceMetrics"
Description: """
This profile constrains the FHIR Bundle resource for use as the result container of the `$search-summary-data-measurement` operation.  
The operation requests CGM summary data and optionally returns the related device context.  

The Bundle is of type *collection* and **MUST** contain only resources of the following types:  
- Observations conforming to HL7 CGM profiles: 
    - [CGM Summary Observation](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary.html)
    - [Mean Glucose (Mass)](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
    - [Mean Glucose (Moles)](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
    - [Times in Ranges](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-times-in-ranges.html)
    - [Glycemic Variability Index (GMI)](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-gmi.html)
    - [Coefficient of Variation](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-coefficient-of-variation.html)
    - [Days of Wear](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-days-of-wear.html)
    - [Sensor Active Percentage](https://hl7.org/fhir/uv/cgm/2025May/StructureDefinition-cgm-summary-sensor-active-percentage.html)
 
- DeviceMetric resources conforming to `DeviceMetric-Personal-Health-Device` to provide configuration details for the CGM measurement device.  
- Device resources conforming to `Device-Personal-Health-Device` to provide context about the actual Personal Health Device device used.  

The purpose of this Bundle profile is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic.  
It ensures interoperability across different implementations by defining a predictable response format.  
This supports use cases such as:  
- Retrieval of CGM summary metrics over a given time interval  
- Retrieval of raw CGM measurement series together with the associated device configuration  
- Combining measurement data and device metadata for downstream applications such as visualization, clinical decision support, or data export.  

**Constraints applied:**  
- `Bundle.type` is fixed to `collection`.  
- `Bundle.entry.resource` is restricted to CGM Observation profiles, DeviceMetric-Personal-Health-Device, or Device-Personal-Health-Device.  
- No other resource types are allowed in the Bundle.  
"""
* ^version = "0.3.0"
* ^status = #draft
* ^date = "2025-09-19"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of related resources"
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or DeviceMetric_Sensor_Type_and_Calibration_Status or Device_Personal_Health_Device
* entry.resource ^short = "Observations with their related Devices and DeviceMetrics"

Profile: Device_Personal_Health_Device
Parent: Device
Id: Device-Personal-Health-Device
Title: "Device – Personal Health Device"
Description: "Profile for a Personal Health Device used in the provision of healthcare."
* ^version = "0.3.0"
* ^status = #draft
* ^date = "2025-09-18"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Personal Health Device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device **MUST** be a personal health device."
* type from VS_DeviceType (required)
* type ^short = "The machine-readable type of the Personal health device"
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
* deviceName ^short = "Name of the Personal health device"
* deviceName ^definition = "The name of the Personal health device as given by the manufacturer and listed in the BfArM Device registry."
* modelNumber MS
* modelNumber ^short = "Model number of the Personal health device"
* modelNumber ^definition = "The model number of the Personal health device."

Profile: DeviceMetric_Sensor_Type_and_Calibration_Status
Parent: DeviceMetric
Id: DeviceMetric-Sensor-Type-and-Calibration-Status
Title: "DeviceMetric – Sensor Type and Calibration Status"
Description: "Profile for the sensor type and calibration status of a Personal Health Device."
* ^version = "0.3.0"
* ^status = #draft
* ^date = "2025-09-18"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Configuration or setting capability of a personal health device"
* . ^definition = "Describes a configuration or setting capability of a personal health device."
* type ^short = "Definition of kind of measurement value"
* type ^definition = "Definition of kind of measurement value of a Personal health device, e.g. that the device only measures tissue glucose."
* unit from $ucum-units (preferred)
* unit ^short = "Unit of the measurement"
* unit ^definition = "The unit in which the associated measuring device delivers its measurement values."
* unit ^binding.description = "Defines the unit of measurement using codes from the ValueSet for blood glucose units."
* source 1..
* source only Reference(Device_Personal_Health_Device)
* source ^short = "Reference to the device instance"
* source ^definition = "Points to the specific Device resource that uses this device configuration."
* operationalStatus MS
* calibration MS
* calibration.state 1..1

Profile: Observation_Blood_Glucose
Parent: Observation
Id: Observation-Blood-Glucose
Title: "Observation – Blood Glucose"
Description: "Profile for capturing blood glucose measurements as Observation."
* ^version = "0.3.0"
* ^status = #draft
* ^date = "2025-09-19"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* status ^short = "Measurement status"
* status ^definition = "The status of the measurements. The status 'final' means the measurement is complete and verified; 'preliminary' means the data MAY be incomplete or unverified, the measurement SHOULD be called at a later time for collecting complete data. "
* code from VS_Blood_Glucose (required)
* code ^short = "Measurement type of vital sign"
* code ^definition = "The code specifies which vital sign was measured (e.g., LOINC 2339-0 for blood glucose)."
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for blood glucose measurements."
* effective[x] 1..1
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time or period when the blood glucose measurement was taken."
* value[x] MS
* value[x] only Quantity
* value[x] ^short = "Measured value"
* value[x] ^definition = "The blood glucose value measured, represented as a quantity."
* value[x].value 1..1
* value[x].system 1..1
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..1
* value[x].code from $ucum-units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet ."
* note ^short = "Comments about the measurement."
* note ^definition = "Comments about the measurement or the results."
* method ^short = "Measurement method"
* method ^definition = "The measurement method (e.g., finger-stick check)."
* device 1..1
* device only Reference(DeviceMetric_Sensor_Type_and_Calibration_Status or Device_Personal_Health_Device)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "References a DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference Device resource that describes the personal health device itself.."


Profile: Observation_CGM_Measurement_Series
Parent: Observation
Id: Observation-CGM-Measurement-Series
Title: "Observation – Tissue Glucose (CGM Measurement Series)"
Description: "Profile for capturing a CGM measurement time series (tissue glucose) as Observation."
* ^version = "0.3.0"
* ^status = #draft
* ^date = "2025-08-12"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Tissue glucose measurement series"
* . ^definition = "A series of measurements of tissue glucose taken by a CGM device, captured as a single observation."
* status ^short = "Measurements status"
* status ^definition = "The status of the measurements. The status 'final' means the measurement is complete and verified; 'preliminary' means the data MAY be still being collected and not complete. It SHOULD be called at a later time for collecting complete data."
* code from VS_Tissue_Glucose_CGM (required)
* code ^short = "Type of measurement"
* code ^definition = "Coding of this measurement, e.g., tissue glucose from LOINC."
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for tissue glucose measurements."
* effective[x] 1..1
* effective[x] only Period
* effective[x] ^short = "The chunk-time-span of measurements"
* effective[x] ^definition = "The owner of the device data recorder MUST define the chunk-time-span of measurements that can be covered by a chunk. E.g. if the owner of the device data recorder defines a chunk-time-span of 24 hours for a chunk, each chunk can hold up to 1440 data points for a personal health device that measures data every minute. A chunk MAY cover a shorter period of time than the chunk-time-span (e.g. when the calibration status of the device changed during measurments), but it MUST NOT exceed that value."
* effective[x].start 1..1
* effective[x].start ^short = "Start of chunk-time-span"
* effective[x].start ^definition = "The starting time of the chunk-time-span of measurements."
* effective[x].end 1..1
* effective[x].end ^short = "End of chunk-time-span"
* effective[x].end ^definition = "The ending time of the chunk-time-span of measurements."
* value[x] MS
* value[x] only SampledData
* value[x] ^short = "Time series"
* value[x] ^definition = "CGM time series as a SampledData object."
* value[x].origin.unit ^short = "Unit of measurement"
* value[x].origin.unit ^definition = "The unit of measurement for the origin of the SampledData."
* value[x].origin.system 1..1
* value[x].origin.system = "http://unitsofmeasure.org" (exactly)
* value[x].origin.system ^short = "System of measurement"
* value[x].origin.system ^definition = "The system of measurement for the origin of the SampledData."
* value[x].origin.code 1..1
* value[x].origin.code from $ucum-units (required)
* value[x].origin.code ^short = "Code of measurement unit"
* value[x].origin.code ^definition = "The code representing the unit of measurement for the origin of the SampledData."
* value[x].origin.code ^binding.description = "Defines the unit of measurement using codes from the UCUM units ValueSet."
* value[x].period 1..1
* value[x].period ^short = "Sampling period"
* value[x].period ^definition = "The time interval between samples in milliseconds."
* value[x].data 1..
* dataAbsentReason 0..1
* dataAbsentReason ^definition = "Indicates why the measurement data is missing. If set to 'temp-unknown', this measurement should be re-collected at a later time."
* dataAbsentReason ^comment = "For preliminary CGM measurements where the data is temporarily unavailable, use 'temp-unknown'. This signals that the measurement should be repeated later."
* note ^short = "Comments about the measurement"
* note ^definition = "Additional comments on the measurement."
* method ^short = "Measurement method"
* method ^definition = "The measurement method (e.g., sensor technology)."
* device 1..1
* device only Reference(DeviceMetric_Sensor_Type_and_Calibration_Status or Device_Personal_Health_Device)
* device ^short = "Reference to personal health device or its sensor type and calibration status"
* device ^definition = "Reference to the DeviceMetric resource that describes the sensor type and calibration status of the personal health device or reference Device resource that describes the personal health device itself."


ValueSet: VS_Blood_Glucose
Id: vs-blood-glucose
Title: "ValueSet Blood Glucose from LOINC"
Description: "This ValueSet contains LOINC codes for blood glucose measurements."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/VS-Blood-Glucose"
* ^version = "0.3.0"
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


ValueSet: VS_Tissue_Glucose_CGM
Id: vs-tissue-glucose-cgm
Title: "ValueSet – Tissue Glucose for rtCGM from LOINC"
Description: "This ValueSet contains LOINC codes for tissue glucose measurements."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/VS-Tissue-Glucose-CGM"
* ^version = "0.3.0"
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


ValueSet: VS_DeviceType
Id: vs-device-type
Title: "Device Type of personal health devices"
Description: "Codes used to identify medical devices."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/VS-Device-Type"
* ^version = "0.3.0"
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
// * include codes from system SNOMED_CT where concept is-a #49062001


Instance: search-summary-data-measurement
InstanceOf: OperationDefinition
Usage: #definition
Title: "Search Operation for summary data measurement"
Description: """
The `$search-summary-data-measurement` operation is defined on the *Observation* resource type.  
It allows clients to request CGM summary data filtered by measurement code and effective period, and optionally include related device context (Device, DeviceMetric).  

**Use cases supported by this operation include:**  
- Retrieving CGM summary statistics (mean glucose, time-in-range, GMI, etc.) for a patient over a specified interval  

**Input Parameters:**  
- `effectivePeriodStart` *(dateTime, optional)*: Lower bound of the observation effective period.  
- `effectivePeriodEnd` *(dateTime, optional)*: Upper bound of the observation effective period.  
- `related` *(boolean, optional)*: If true, the response bundle also contains related Device and DeviceMetric resources.  

**Output Parameter:**  
- `result` *(Reference, required)*: A Bundle conforming to `Bundle-Search-Summary-Data-Measurements` containing all matching CGM Observations and, if requested, their related devices.  

**Constraints applied:**  

- The output Bundle **MUST** always conform to the `Bundle-Search-Summary-Data-Measurements` profile.  
"""
// * url = "https://gematik.de/fhir/hddt/OperationDefinition/Operation-Search-Aggregate-Observations"
* version = "0.3.0"
* id = "search-summary-data-measurement"
* name = "Search_Summary_Data_Measurement"
* title = "Search Operation for summary data measurement"
* status = #draft
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2025-09-19"
* affectsState = false
* code = #search-summary-data-measurement
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
* parameter[=].targetProfile = "https://gematik.de/fhir/hddt/StructureDefinition/Bundle-Search-Summary-Data-Measurements"
