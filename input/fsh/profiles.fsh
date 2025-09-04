Alias: $cgm-summary = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary
Alias: $cgm-summary-mean-glucose-mass-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-mass-per-volume
Alias: $cgm-summary-mean-glucose-moles-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-moles-per-volume
Alias: $cgm-summary-times-in-ranges = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-times-in-ranges
Alias: $cgm-summary-gmi = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-gmi
Alias: $cgm-summary-coefficient-of-variation = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-coefficient-of-variation
Alias: $cgm-summary-days-of-wear = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-days-of-wear
Alias: $cgm-summary-sensor-active-percentage = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-sensor-active-percentage
// Alias: $DeviceDefinition = http://device-registry.bfarm.de/fhir/StructureDefinition/DeviceDefinition

Profile: BundleSearchSummaryDataMeasurements
Parent: Bundle
Id: Bundle-Search-Summary-Data-Measurements
Title: "Bundle – Summary Data Measurements with related Devices/DeviceMetrics"
Description: """
This profile constrains the FHIR Bundle resource for use as the result container of the `$search-summary-data-measurement` operation.  
The operation requests CGM summary data and optionally returns the related device context.  

The Bundle is of type *collection* and must contain only resources of the following types:  
- Observations conforming to HL7 CGM profiles (e.g., `$cgm-summary`, `$cgm-summary-mean-glucose-mass-per-volume`, `$cgm-summary-times-in-ranges`, `$cgm-summary-gmi`, `$cgm-summary-coefficient-of-variation`, `$cgm-summary-days-of-wear`, `$cgm-summary-sensor-active-percentage`, `$cgm-sensor-reading-mass-per-volume`, `$cgm-sensor-reading-moles-per-volume`).  
- DeviceMetric resources conforming to `DeviceMetric-Medical-Aid` to provide configuration details for the CGM measurement device.  
- Device resources conforming to `Device-Medical-Aid` to provide context about the actual medical aid device used.  

The purpose of this Bundle profile is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic.  
It ensures interoperability across different implementations by defining a predictable response format.  
This supports use cases such as:  
- Retrieval of CGM summary metrics over a given time interval  
- Retrieval of raw CGM measurement series together with the associated device configuration  
- Combining measurement data and device metadata for downstream applications such as visualization, clinical decision support, or data export.  

**Constraints applied:**  
- `Bundle.type` is fixed to `collection`.  
- `Bundle.entry.resource` is restricted to CGM Observation profiles, DeviceMetric-Medical-Aid, or Device-Medical-Aid.  
- No other resource types are allowed in the Bundle.  
"""
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2025-08-28"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of related resources"
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or DeviceMetric_Medical_Aid or Device_Medical_Aid
* entry.resource ^short = "Observations with their related Devices and DeviceMetrics"

Profile: Device_Medical_Aid
Parent: Device
Id: Device-Medical-Aid
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2025-08-28"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Medical aid or personal medical device"
* . ^definition = "A type of a manufactured device that is used in the provision of healthcare without being substantially changed through that activity. The device must be a medical device."
* definition 1..1
* definition only Reference(DeviceDefinition)
* definition ^short = "Definition of the medical aid"
* definition ^definition = "Reference to a DeviceDefinition resource that describes the technical and functional details of the medical aid."
* expirationDate MS
* expirationDate ^short = "Date and time of expiry of this medical aid (if applicable)"
* expirationDate ^definition = "The date and time beyond which this medical aid is no longer valid or should not be used (if applicable)."
* serialNumber 1..1
* serialNumber ^short = "Serial number of the medical aid"
* serialNumber ^definition = "The serial number that uniquely identifies the medical aid instance."
* deviceName 1..1
* deviceName ^short = "Name of the medical aid"
* deviceName ^definition = "The name of the medical aid as given by the manufacturer and listed in the device registry."
* modelNumber MS
* modelNumber ^short = "Model number of the medical aid"
* modelNumber ^definition = "The model number of the medical aid."

Profile: DeviceMetric_Medical_Aid
Parent: DeviceMetric
Id: DeviceMetric-Medical-Aid
Title: "Device configuration – Medical Aid"
Description: "Profile for the device configuration of a Medical Aid device."
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2025-08-28"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Configuration or setting capability of a medical device"
* . ^definition = "Describes a configuration or setting capability of a medical device."
* type ^short = "Definition of the measurement type"
* type ^definition = "Definition of the measurement type of a Medical aid device, e.g. that the device only measures tissue glucose. Only codes from LOINC are allowed. Codes must be match to code in measurements, e.g from this ValueSet. : https://gematik.de/fhir/hddt/ValueSet/VS-Tissue-Glucose-CGM"
* type ^comment = "Note: For the OAuth scopes, so that the corresponding FHIR endpoint only returns the allowed device configuration that matches the measurements."
* type ^patternCodeableConcept.coding.system = "http://loinc.org"
* unit 1..
* unit from VS_Blood_Glucose_Units (required)
* unit ^short = "Unit of the measurement"
* unit ^definition = "The unit in which the associated measuring device delivers its measurement values."
* unit ^binding.description = "Defines the unit of measurement using codes from the ValueSet for blood glucose units."
* source 1..
* source only Reference(Device_Medical_Aid)
* source ^short = "Reference to the device instance"
* source ^definition = "Points to the specific Device resource that uses this device configuration."
* operationalStatus MS
* measurementPeriod MS
* calibration MS

Profile: Observation_Blood_Glucose
Parent: Observation
Id: Observation-Blood-Glucose
Title: "Observation – Blood Glucose"
Description: "Profile for capturing blood glucose measurements as Observation."
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2025-08-28"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* status = #final (exactly)
* status ^short = "Measurement status"
* status ^definition = "The status of the Measurement is fixed to 'final', meaning the measurement is complete and no further updates are expected."
* status ^comment = "This element is fixed to 'final' to ensure that the glucose measurement is considered a completed observation."
* code from VS_Blood_Glucose (required)
* code ^short = "Measurement type of vital sign"
* code ^definition = "The code specifies which vital sign was measured (e.g., LOINC 2339-0 for blood glucose)."
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for blood glucose measurements."
* effective[x] only dateTime
* effective[x] ^short = "Time of measurement"
* effective[x] ^definition = "The time or period when the blood glucose measurement was taken."
* value[x] 1..
* value[x] only Quantity
* value[x] ^short = "Measured value"
* value[x] ^definition = "The blood glucose value measured, represented as a quantity."
* value[x].value 1..
* value[x].unit 1..
* value[x].system 1..
* value[x].system = "http://unitsofmeasure.org" (exactly)
* value[x].code 1..
* value[x].code from VS_Blood_Glucose_Units (required)
* value[x].code ^binding.description = "Defines the unit of measurement using codes from the ValueSet for blood glucose units (UCUM code)."
* note ^short = "Comments about the measurement."
* note ^definition = "Comments about the measurement or the results."
* method MS
* method ^short = "Measurement method"
* method ^definition = "The measurement method (e.g., finger-stick check)."
* device 1..
* device only Reference(DeviceMetric_Medical_Aid)
* device ^short = "Reference to device configuration"
* device ^definition = "References a DeviceMetric resource that describes the current configuration of the measuring device."

Invariant: obs-cgm-preliminary-dataAbsentReason
Description: "If the measurement status is 'preliminary', a dataAbsentReason could be provided."
Severity: #warning
Expression: "status = 'preliminary' implies dataAbsentReason.exists()"

Profile: Observation_CGM_Measurement_Series
Parent: Observation
Id: Observation-CGM-Measurement-Series
Title: "Observation – Tissue Glucose (CGM Measurement Series)"
Description: "Profile for capturing a CGM measurement time series (tissue glucose) as Observation."
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2025-08-12"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* . ^short = "Tissue glucose measurement series"
* . ^definition = "A series of measurements of tissue glucose taken by a CGM device, captured as a single observation."
* status from VS_Observation_CGM_Status (required)
* status ^short = "Measurements status"
* status ^definition = "The status of the measurements, restricted to values defined in the ValueSet VS_Observation_CGM_Status, which includes only 'final' and 'preliminary'.'final' means the measurement is complete and verified; 'preliminary' means the data is still being collected and not complete."
* status ^comment = "Binding to the custom ValueSet enforces that only 'final' or 'preliminary' can be used, in accordance with the profile requirements for CGM measurement series."
* obeys obs-cgm-preliminary-dataAbsentReason
* code from VS_Tissue_Glucose_CGM (required)
* code ^short = "Type of measurement"
* code ^definition = "Coding of this measurement, e.g., tissue glucose from LOINC."
* code ^binding.description = "Specifies the type of measurement using codes from the ValueSet for tissue glucose measurements."
* subject only Reference(Patient)
* subject ^short = "Patient subject"
* subject ^definition = "Reference to the patient to whom this time series belongs."
* effective[x] 1..
* effective[x] only Period
* effective[x] ^short = "Measurement time point or period"
* effective[x] ^definition = "The time or period when the CGM measurement was taken."
* effective[x].start 1..
* effective[x].start ^short = "Start of measurement period"
* effective[x].start ^definition = "The starting time of the CGM measurement period."
* effective[x].end 1..
* effective[x].end ^short = "End of measurement period"
* effective[x].end ^definition = "The ending time of the CGM measurement period."
* value[x] 1..
* value[x] only SampledData
* value[x] ^short = "Time series"
* value[x] ^definition = "CGM time series as a SampledData object."
* value[x].origin.unit 1..
* value[x].origin.unit ^short = "Unit of measurement"
* value[x].origin.unit ^definition = "The unit of measurement for the origin of the SampledData."
* value[x].origin.system 1..
* value[x].origin.system = "http://unitsofmeasure.org" (exactly)
* value[x].origin.system ^short = "System of measurement"
* value[x].origin.system ^definition = "The system of measurement for the origin of the SampledData."
* value[x].origin.code 1..
* value[x].origin.code from VS_Blood_Glucose_Units (required)
* value[x].origin.code ^short = "Code of measurement unit"
* value[x].origin.code ^definition = "The code representing the unit of measurement for the origin of the SampledData."
* value[x].origin.code ^binding.description = "Defines the unit of measurement using codes from the ValueSet for blood glucose units (UCUM code)."
* value[x].data 1..
* dataAbsentReason 0..1
* dataAbsentReason ^short = "Reason for missing data"
* dataAbsentReason ^definition = "Indicates why the measurement data is missing. If set to 'temp-unknown', this measurement should be re-collected at a later time."
* dataAbsentReason ^comment = "For preliminary CGM measurements where the data is temporarily unavailable, use 'temp-unknown'. This signals that the measurement should be repeated later."
* note ^short = "Comments about the measurement"
* note ^definition = "Additional comments on the measurement."
* method MS
* method ^short = "Measurement method"
* method ^definition = "The measurement method (e.g., sensor technology)."
* device 1..
* device only Reference(DeviceMetric_Medical_Aid)
* device ^short = "Device configuration"
* device ^definition = "Reference to the DeviceMetric resource of the configuration."

ValueSet: VS_Observation_CGM_Status
Id: vs-observation-cgm-status
Title: "Observation Status for CGM Measurement Series"
Description: "Only final and preliminary statuses from the HL7 observation-status CodeSystem."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2025-08-28"
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2025 gematik GmbH"
* include http://hl7.org/fhir/observation-status#final
* include http://hl7.org/fhir/observation-status#preliminary


ValueSet: VS_Blood_Glucose_Units
Id: vs-glucose-units
Title: "Blood Glucose Measurement Units"
Description: "This ValueSet contains UCUM units codes used for blood glucose measurements (e.g., mg/dL, mmol/L)."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/VS-Blood-Glucose-Units"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2025-08-28"
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[+].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* UCUM#mg/dL "milligram per deciliter"
* UCUM#mmol/L "millimole per liter"

ValueSet: VS_Blood_Glucose
Id: vs-blood-glucose
Title: "ValueSet Blood Glucose from LOINC"
Description: "This ValueSet contains LOINC codes for blood glucose measurements."
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^url = "https://terminologien.bfarm.de/fhir/ValueSet/VS-Blood-Glucose"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2025-08-28"
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
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2025-08-28"
* ^publisher = "BfArM"
* ^contact.telecom[0].system = #email
* ^contact.telecom[=].value = "klassi@bfarm.de"
* ^contact.telecom[+].system = #url
* ^contact.telecom[=].value = "https://www.bfarm.de"
* ^copyright = "BfArM - Die Erstellung erfolgt unter Verwendung der maschinenlesbaren Fassung des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM)."
* LOINC#105272-9 "Glucose [Moles/volume] in Interstitial fluid"
* LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"

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
- `code` *(code, optional)*: Restricts results to Observations of the specified measurement type. The parameter is bound to the ValueSet `VS-CGM-Summary-Codes`.  
- `effectivePeriodStart` *(dateTime, optional)*: Lower bound of the observation effective period.  
- `effectivePeriodEnd` *(dateTime, optional)*: Upper bound of the observation effective period.  
- `related` *(boolean, optional)*: If true, the response bundle also contains related Device and DeviceMetric resources.  

**Output Parameter:**  
- `result` *(Reference, required)*: A Bundle conforming to `Bundle-Search-Summary-Data-Measurements` containing all matching CGM Observations and, if requested, their related devices.  

**Constraints applied:**  
- The operation is defined at the type level for *Observation* (`type = true`).  
- It does not affect state (`affectsState = false`).  
- The output Bundle must always conform to the `Bundle-Search-Summary-Data-Measurements` profile.  
"""
// * url = "https://gematik.de/fhir/hddt/OperationDefinition/Operation-Search-Aggregate-Observations"
* version = "0.1.0"
* id = "search-summary-data-measurement"
* name = "Search_Summary_Data_Measurement"
* title = "Search Operation for summary data measurement"
* status = #draft
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2025-08-28"
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