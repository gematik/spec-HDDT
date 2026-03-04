Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $sct = http://snomed.info/sct
Alias: $oi = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation
Alias: $oc = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $mdc = urn:iso:std:iso:11073:10101

Instance: Example-Blood-Glucose
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "HDDT Blood Glucose Obervation Example (general)"
Description: "Example of a blood glucose measurement taken with a glucometer."
* id = "example-blood-glucose"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* effectiveDateTime = "2025-10-23T08:30:00Z"
* valueQuantity = 30 'mg/dL' "mg/dl"
* valueQuantity.comparator = #<
* device = Reference(Example-Glucometer-Metric)

Instance: Example-Blood-Glucose-Measurement-1
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "HDDT Blood Glucose Measurement 1 (from Example Object Diagram)"
Description: "Example of a blood glucose measurement taken with a glucometer."
* id = "example-blood-glucose-measurement-1"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* effectiveDateTime = "2025-09-26T12:00:00+02:00"
* valueQuantity = 120 'mg/dL' "mg/dl"
* device = Reference(Example-Glucometer-Metric)

Instance: Example-Blood-Glucose-Measurement-2
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "HDDT Blood Glucose Measurement 2 (from Example Object Diagram)"
Description: "Example of a blood glucose measurement taken with a glucometer."
* id = "example-blood-glucose-measurement-2"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* effectiveDateTime = "2025-09-26T16:30:00+02:00"
* valueQuantity = 129 'mg/dL' "mg/dl"
* device = Reference(Example-Glucometer-Metric)

Instance: Example-Glucometer
InstanceOf: HddtPersonalHealthDevice
Usage: #example
Title: "HDDT Glucometer Device Example"
Description: """
Example of a __glucometer as a personal health device__:
The device _GlukkCheck plus mg/dl_ from _Glukko Inc._ performs "bloody" measurements from capillary blood. 
As glucometers do not expire (that is just the case for the test stripes), the expiration date is not set.
The vendor-defined model number of this typeof devices is _CGPA987654_ and the serial number of the patient's 
individual device is _SN123456_. Both identifiers are printed on the back of the device and allow the patient 
to validate the authenticity of this Personal Health Device resource.
"""
* id = "example-glucometer"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
* type =  $sct-version#337414009 "Blood glucose meter (physical object)"
* status = #active
// * statusReason = #online
* deviceName.name = "GlukkoCheck plus mg/dL"
* deviceName.type = #user-friendly-name
* manufacturer = "Glukko Inc."
* serialNumber = "SN123456"
* modelNumber = "CGPA987654"
* definition = Reference(Example-Glucometer-Def)

Instance: Example-Glucometer-Metric
InstanceOf: HddtSensorTypeAndCalibrationStatus
Usage: #example
Title: "HDDT Glucometer DeviceMetric Example"
Description: """
Example of a __DeviceMetric for blood glucose measurements__ from a glucometer:
The device measures the glucose concentration from capillary blood by using test strips. 
The patient's preferred unit is mg/dl which is used by the device for displaying measured values. 
The glucometer needs to be calibrated by the patient using control strips. 
The last calibration was performed in Septemer 2025 and the glucometer is still calibrated.
"""
* id = "example-glucometer-metric"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
* type = $sct-version#700585005 "Invasive interstitial-fluid glucose monitoring system (physical object)"
* unit = $unitsofmeasure#mg/dL "mg/dL"
* source = Reference(Example-Glucometer)
* operationalStatus = #on
* category = #measurement
* calibration.type = #gain
* calibration.state = #calibrated
* calibration.time = "2025-09-01T09:08:04+02:00"


Instance: Example-Glucometer-Def
InstanceOf: DeviceDefinition
Usage: #example
Title: "HDDT Glucometer DeviceDefinition Example"
Description: "Example for a medical device definition (Glucometer) from the HIIS-VZ."
* id = "example-glucometer-def"
* identifier.system = "http://fhir.de/sid/gkv/hmnr"
* identifier.value = "12.34.56.7890" 
* deviceName[0].name = "GlucoCheck Plus mg/dL"
* deviceName[0].type = #user-friendly-name
* type = $sct-version#337414009 "Blood glucose meter (physical object)"
* manufacturerReference = Reference(Example-Glucometer-Manufacturer)
* modelNumber = "GCPlus 1"
* extension[0].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDefinitionMivSet"
* extension[0].extension[0].url = "mivSet"
* extension[0].extension[0].valueReference = Reference(Example-Universal-Backend)
* extension[1].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceDefinition.regulatoryIdentifier"
* extension[1].extension[0].url = "deviceIdentifier"
* extension[1].extension[0].valueString = "9912345GLUCOMETER7A"
* parentDevice = Reference(Example-Universal-Backend)
* property[0].type.text = "Supported unit"
* property[0].valueCode = $unitsofmeasure#mg/dL "mg/dL"
* property[+].type.text = "Reference range low"
* property[=].valueQuantity.value = 70
* property[=].valueQuantity.unit = "mg/dl"
* property[=].valueQuantity.system = $unitsofmeasure
* property[+].type.text = "Reference range high"
* property[=].valueQuantity.value = 180
* property[=].valueQuantity.unit = "mg/dl"
* property[=].valueQuantity.system = $unitsofmeasure
* capability[0].type.coding[0].system = $loinc
* capability[0].type.coding[0].code = #2339-0
* capability[0].type.coding[0].display = "Glucose [Mass/volume] in Blood"

Instance: Example-Glucometer-Manufacturer
InstanceOf: Organization
Usage: #example
Title: "HDDT Glucometer Manufacturer Example"
Description: "Example organization representing the manufacturer of the glucometer device."
* id = "example-glucometer-manufacturer"
* type.coding[0].system = "https://fhir.bfarm.de/CodeSystem/HiisManufacturerType"
* type.coding[0].code = #legal
* type.coding[0].display = "Legal Entity"
* name = "Glukko Inc."
* telecom[0].system = #email
* telecom[0].value = "info@glukko.com"
* address[0].line[0] = "Glukko Street 1"
* address[0].city = "Berlin"
* address[0].postalCode = "10115"
* address[0].country = "DE"
* contact[0].name.given = "John"
* contact[0].name.family = "Glucose"
* contact[0].telecom[0].system = #phone
* contact[0].telecom[0].value = "+49-30-1234567"

Instance: Example-Universal-Backend
InstanceOf: DeviceDefinition
Usage: #example
Title: "HDDT Universal Device Backend Example"
Description: "Example for a universal backend system for processing HiMi data according to § 374a SGB V. Supports multiple device types. Values in the 'mivSet' extensions are just exemplary, and do not reflect the specification."
* id = "example-universal-backend"
* identifier.system = "https://fhir.bfarm.de/Identifier/HiisId"
* identifier.value = "DE-1234567890"
* manufacturerString = "Health IT Solutions AG"
* deviceName[0].name = "§ 374a SGB V Universal Backend"
* deviceName[0].type = #user-friendly-name
* version = "1.0.0"
* extension[0].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDataRecorderEndpointLink"
* extension[=].valueReference[+] = Reference(Example-Universal-Endpoint-fhir)
* extension[+].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDataRecorderEndpointLink"
* extension[=].valueReference[+] = Reference(Example-Universal-Endpoint-Auth)
//* extension[+].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceDefinition.link"
//* extension[=].extension[0].url = "relation"
//* extension[=].extension[=].valueCode = #supports
//* extension[=].extension[+].url = "relatedDevice"
//* extension[=].extension[=].extension[0].url = "reference"
//* extension[=].extension[=].extension[0].valueReference = Reference(Example-Glucometer-Def)
//* extension[=].extension[+].url = "relatedDevice"
//* extension[=].extension[=].extension[0].url = "reference"
//* extension[=].extension[=].extension[0].valueReference = Reference(DeviceDefinition/device-definition-cgm-001)
//* extension[=].extension[+].url = "relatedDevice"
//* extension[=].extension[=].extension[0].url = "reference"
//* extension[=].extension[=].extension[0].valueReference = Reference(DeviceDefinition/device-definition-peak-flow-001)
//* extension[=].extension[+].url = "relatedDevice"
//* extension[=].extension[=].extension[0].url = "reference"
//* extension[=].extension[=].extension[0].valueReference = Reference(DeviceDefinition/device-definition-blood-pressure-cuff-001)
* extension[+].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDefinitionMivSet"
* extension[=].extension[0].url = "delayFromRealTime"
* extension[=].extension[0].valueDuration.value = 60
* extension[=].extension[0].valueDuration.unit = "s"
* extension[=].extension[1].url = "gracePeriod"
* extension[=].extension[1].valueDuration.value = 15
* extension[=].extension[1].valueDuration.unit = "min"
* extension[=].extension[2].url = "historicDataPeriod"
* extension[=].extension[2].valueDuration.value = 30
* extension[=].extension[2].valueDuration.unit = "d"

Instance: Example-Universal-Endpoint-fhir
InstanceOf: Endpoint
Usage: #example
Title: "HDDT Universal Backend FHIR Endpoint Example"
Description: "Example FHIR endpoint for a universal backend system for processing HiMi data according to § 374a SGB V."
* id = "example-universal-endpoint-fhir"
* status = #active
* connectionType.system = "https://fhir.bfarm.de/CodeSystem/HiisEndpointConnectionType"
* connectionType.code = #hl7-fhir-rest
* name = "cloud.health-it.de"
* address = "https://cloud.health-it.de/fhir"
* payloadType[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/endpoint-payload-type"
* payloadType[0].coding[0].code = #any

Instance: Example-Universal-Endpoint-Auth
InstanceOf: Endpoint
Usage: #example
Title: "HDDT Universal Backend Auth Endpoint Example"
Description: "Example authentication endpoint for a universal backend system for processing HiMi data according to § 374a SGB V."
* id = "example-universal-endpoint-auth"
* status = #active
* connectionType.system = "https://fhir.bfarm.de/CodeSystem/HiisEndpointConnectionType"
* connectionType.code = #oauth-authz-server
* name = "cloud.health-it.de"
* address = "https://cloud.health-it.de/.well-known/openid-configuration"
* payloadType[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/endpoint-payload-type"
* payloadType[0].coding[0].code = #any




// Instance: Example-DeviceDefinition-Backend
// InstanceOf: DeviceDefinition
// Usage: #example
// Title: "DeviceDefinition – Roche Device Backend"
// Description: "Example for a backend system for processing HiMi data according to § 374a SGB V."

// * deviceName[0].name = "§ 374a SGB V Backend"
// * deviceName[0].type = #manufacturer-name
// * manufacturerString = "Acme Health IT GmbH"
// * type = $sct-version#706689003 "Health information exchange infrastructure (physical object)"
// * url = "https://himi-backend.de/fhir"

Instance: Example-CGM-Series
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Full Chunk Observation Example"
Description: "Example of a CGM time series with 1-minute intervals over 1 hour (60 samples)."
Usage: #example
* id = "example-cgm-series"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #final
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-10-28T08:00:00Z"
* effectivePeriod.end   = "2025-10-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dl"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 60000
* valueSampledData.dimensions = 1
* valueSampledData.lowerLimit = 35
* valueSampledData.upperLimit = 360
* valueSampledData.data = "110 111 112 113 114 115 116 117 118 119 120 90 77 66 56 39 36 L L L 40 51 66 81 91 99 101 120 122 121 120 119 118 117 116 115 114 113 112 111 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct-version#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* note.text = "Example CGM data series with 1-minute intervals over 1 hour (60 samples)."

Instance: Example-CGM-Series-1
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Full Chunk Observation Example"
Description: "Example of a CGM time series with 5-minute intervals over 1 hour (12 samples)."
Usage: #example
* id = "example-cgm-series-1"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #final
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-09-26T16:00:00Z"
* effectivePeriod.end   = "2025-09-26T16:59:59Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dl"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 300000
* valueSampledData.dimensions = 1
* valueSampledData.data = "123 122 126 134 129 128 130 131 129 127 127 133"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct-version#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* note.text = "Example CGM data series with 5-minute intervals over 1 hour (12 samples)."

Instance: Example-CGM-Series-Incomplete
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Incomplete Chunk Observation Example"
Description: "Example of a CGM time series with 1-minute intervals over 20 minutes (20 samples), but incomplete."
Usage: #example
* id = "example-cgm-series-incomplete"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #preliminary
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-08-28T08:00:00Z"
* effectivePeriod.end   = "2025-08-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dl"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 60000
* valueSampledData.dimensions = 1
* valueSampledData.data = "110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct-version#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* note.text = "Example CGM data series with 1-minute intervals over 20 minutes (20 samples), but status incomplete."


Instance: Example-Observation-CGM-Series-Data-Unavailable
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Data Unavailable Observation Example"
Description: "Example of a CGM time series with status preliminary and dataAbsentReason"
Usage: #example
* id = "example-cgm-series-data-unavailable"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #preliminary
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-09-01T08:00:00+02:00"
* effectivePeriod.end   = "2025-09-01T10:00:00+02:00"
* dataAbsentReason = http://terminology.hl7.org/CodeSystem/data-absent-reason#temp-unknown "Temporarily Unknown"
* device = Reference(Example-DeviceMetric-CGM)
* note.text = "Sensor warm-up phase, values not yet validated."

Instance: Example-Device-CGM
// InstanceOf: HddtPersonalHealthDevice
InstanceOf: Device
Title: "HDDT rtCGM Device Example"
Description: """
Example of a __real-time Continuous Glucose Monitoring device (rtCGM) as a personal health device__: 
The device _GlukkoCGM 18_ from _Glukko Inc._ performs continuous glucose measurements from interstitial fluid. 
The sensor stops transmitting data on September 10, 2025, and must be replaced by the patient at that date.
The vendor-defined model number of this typeof devices is _GCGMA98765_ and the serial number of the patient's 
individual device is _CGM1234567890_. Both identifiers are printed on the package of the device and allow the patient 
to validate the authenticity of this Personal Health Device resource.
"""
Usage: #example
* id = "example-device-cgm"
* status = #active
// * statusReason = #online
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
* type = $sct-version#700585005 "Invasive interstitial-fluid glucose monitoring system (physical object)"
* definition = Reference(DeviceDefinition/device-definition-cgm-001)
* deviceName.name = "GlukkoCGM 18"
* deviceName.type = #user-friendly-name
* modelNumber = "GCGMA98765"
* manufacturer = "Glukko Inc."
* serialNumber = "CGM1234567890"
* expirationDate = "2025-09-10"

Instance: Example-DeviceMetric-CGM
InstanceOf: HddtSensorTypeAndCalibrationStatus
Title: "HDDT rtCGM DeviceMetric Example"
Description: """
Example __configuration for measurements from a real-time Continuous Glucose Monitoring (rtCGM)__:
The device measures the glucose concentration from interstitial fluid with a frequency of one measurement every minute. 
The the unit set by the patient for displaying measured values is mg/dl.
The device is calibrated by the manufacturer and does not require user calibration.
"""
Usage: #example
* id = "example-devicemetric-cgm"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
* type = $mdc#160212 "MDC_CONC_GLU_ISF"
* unit = $unitsofmeasure#mg/dL "mg/dL"
* source = Reference(Example-Device-CGM)
* operationalStatus = #on
* category = #measurement
* measurementPeriod.repeat.frequency = 1
* measurementPeriod.repeat.period = 1
* measurementPeriod.repeat.periodUnit = #min
* calibration.type = #unspecified
* calibration.state = #calibrated


Instance: cgmSummaryMeanGlucoseMassPerVolumeExample
InstanceOf: CGMSummaryMeanGlucoseMassPerVolume
Title: "HL7 CGM Summary: Mean Glucose (Mass) Example"
Description: "This example is an instance of the Mean Glucose (Mass) profile. It represents a summary observation of the mean glucose level for a patient over the period from May 1, 2024, to May 31, 2024, with a final recorded value of 145 mg/dL (mass per volume)."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 145


Instance: cgmSummaryMeanGlucoseMolesPerVolumeExample
InstanceOf: CGMSummaryMeanGlucoseMolesPerVolume
Title: "HL7 CGM Summary: Mean Glucose (Molar) Example"
Description: "This example is an instance of the Mean Glucose (Molar) profile. It represents a summary observation of the mean glucose level for a patient over the period from May 1, 2024, to May 31, 2024, with a final recorded value of 8.1 mmol/L (moles per volume)."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 8.1

Instance: cgmSummaryTimesInRangesExample
InstanceOf: CGMSummaryTimesInRanges
Title: "HL7 CGM Summary: Times in Ranges Example" 
Usage: #example
Description: "This example is an instance of the CGM Summary Times in Ranges profile. It represents a summary observation of the time a patient spent in different glucose ranges over the period from May 1, 2024, to May 31, 2024. The recorded values are 3% in the very low range, 8% in the low range, 65% in the target range, 20% in the high range, and 4% in the very high range."
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* component[timeInVeryLow].valueQuantity.value = 3
* component[timeInLow].valueQuantity.value = 8
* component[timeInTarget].valueQuantity.value = 65
* component[timeInHigh].valueQuantity.value = 20
* component[timeInVeryHigh].valueQuantity.value = 4

Instance: cgmSummaryGMIExample
InstanceOf: CGMSummaryGMI  
Title: "HL7 CGM Summary: GMI Example"
Description: "This example is an instance of the Glucose Management Indicator (GMI) profile. It represents a summary observation of the estimated A1C-like value (GMI) for a patient over the period from May 1, 2024, to May 31, 2024, with a final recorded value of 6.8%."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 6.8

Instance: cgmSummaryCoefficientOfVariationExample
InstanceOf: CGMSummaryCoefficientOfVariation
Title: "HL7 CGM Summary: Coefficient of Variation Example"
Description: "This example is an instance of the Coefficient of Variation (CV) profile. It represents a summary observation of the glucose variability for a patient over the period from May 1, 2024, to May 31, 2024, with a final recorded coefficient of variation value of 34%."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 34


Instance: cgmSummaryDaysOfWearExample
InstanceOf: CGMSummaryDaysOfWear
Title: "HL7 CGM Summary: Days of Wear Example"
Description: "This example is an instance of the Days of Wear profile. It represents a summary observation of the number of days a Continuous Glucose Monitoring (CGM) device was worn by the patient over the period from May 1, 2024, to May 31, 2024, with a final recorded value of 28 days."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 28

Instance: cgmSummarySensorActivePercentageExample  
InstanceOf: CGMSummarySensorActivePercentage
Title: "HL7 CGM Summary: Sensor Active Percentage Example" 
Description: "This example is an instance of the Sensor Active Percentage profile. It represents a summary observation of the percentage of time a Continuous Glucose Monitoring (CGM) sensor was active for the patient over the period from May 1, 2024, to May 31, 2024, with a final recorded value of 95%." 
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* valueQuantity.value = 95

Instance: cgmSummaryExample
InstanceOf: CGMSummaryObservation
Title: "HL7 CGM Summary: CGM Summary Example"
Description: "This example is an instance of the CGM Summary profile. It provides a consolidated summary of a patient's CGM data over one month, linking to more detailed observations for specific metrics."
Usage: #example
* status = #final
* subject = Reference(patientExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory
* effectivePeriod.start = "2025-09-01"
* effectivePeriod.end = "2025-09-30"
* hasMember[meanGlucoseMassPerVolume] = Reference(cgmSummaryMeanGlucoseMassPerVolumeExample)
* hasMember[timesInRanges] = Reference(cgmSummaryTimesInRangesExample)
* hasMember[gmi] = Reference(cgmSummaryGMIExample)
* hasMember[cv] = Reference(cgmSummaryCoefficientOfVariationExample)
* hasMember[daysOfWear] = Reference(cgmSummaryDaysOfWearExample)  
* hasMember[sensorActivePercentage] = Reference(cgmSummarySensorActivePercentageExample)

Instance: example-cgm-summary-bundle
InstanceOf: HddtCgmSummary
Usage: #example
Title: "HL7 CGM Summary: Example Bundle"
Description: "Bundle containing CGM summary observations for a patient together with associated Device and DeviceMetric resources."

* id = "example-cgm-summary-bundle"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-cgm-summary"
* type = #collection
* timestamp = "2025-10-01T09:15:00Z"

* entry[0].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryExample"
* entry[0].resource = cgmSummaryExample

* entry[1].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryMeanGlucoseMassPerVolumeExample"
* entry[1].resource = cgmSummaryMeanGlucoseMassPerVolumeExample

* entry[2].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryMeanGlucoseMolesPerVolumeExample"
* entry[2].resource = cgmSummaryMeanGlucoseMolesPerVolumeExample

* entry[3].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryTimesInRangesExample"
* entry[3].resource = cgmSummaryTimesInRangesExample

* entry[4].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryGMIExample"
* entry[4].resource = cgmSummaryGMIExample

* entry[5].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryCoefficientOfVariationExample"
* entry[5].resource = cgmSummaryCoefficientOfVariationExample

* entry[6].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummaryDaysOfWearExample"
* entry[6].resource = cgmSummaryDaysOfWearExample

* entry[7].fullUrl = "https://gematik.de/fhir/hddt/Observation/cgmSummarySensorActivePercentageExample"
* entry[7].resource = cgmSummarySensorActivePercentageExample

* entry[8].fullUrl = "https://gematik.de/fhir/hddt/Device/example-device-cgm"
* entry[8].resource = Example-Device-CGM

Instance: HddtCgmSummaryOutcomeUnknownParam
InstanceOf: OperationOutcome
Title: "HL7 CGM Summary OperationOutcome Example: Unknown parameter error"
Description: "Returned when an unsupported input parameter is provided."
* issue[0].severity = #error
* issue[0].code = #invalid
* issue[0].details.coding[0].system = "http://terminology.hl7.org/CodeSystem/operation-outcome"
* issue[0].details.coding[0].code = #MSG_PARAM_UNKNOWN
* issue[0].details.text = "Unknown input parameter 'foo'."


Instance: HddtCgmSummaryOutcomeInvalid
InstanceOf: OperationOutcome
Title: "HL7 CGM Summary OperationOutcome Example: Invalid parameter error"
Description: "Returned when a parameter value is invalid."
* issue[0].severity = #error
* issue[0].code = #invalid
* issue[0].details.coding[0].system = "http://terminology.hl7.org/CodeSystem/operation-outcome"
* issue[0].details.coding[0].code = #MSG_PARAM_INVALID
* issue[0].details.text = "Invalid date format in effectivePeriodStart."


Instance: HddtCgmSummaryOutcomeNoResults
InstanceOf: OperationOutcome
Title: "HL7 CGM Summary OperationOutcome Example: No results information"
Description: "Returned when no CGM observations are found."
* issue[0].severity = #information
* issue[0].code = #not-found
* issue[0].details.coding[0].system = "http://terminology.hl7.org/CodeSystem/operation-outcome"
* issue[0].details.coding[0].code = #MSG_NO_MATCH
* issue[0].details.text = "No CGM summary observations found for the given effective period."


Instance: HddtCgmSummaryOutcomeBadSyntax
InstanceOf: OperationOutcome
Title: "HL7 CGM Summary OperationOutcome Example: Bad syntax error"
Description: "Returned when the request is malformed."
* issue[0].severity = #error
* issue[0].code = #invalid
* issue[0].details.coding[0].system = "http://terminology.hl7.org/CodeSystem/operation-outcome"
* issue[0].details.coding[0].code = #MSG_BAD_SYNTAX
* issue[0].details.text = "The request is malformed."

Instance: patientExample
InstanceOf: Patient
Title: "HL7 CGM Summary Patient Example: no content"
Description: "This example represents a patient without content."
Usage: #example
* id = "patientExample"

Instance: DeviceDefinition/device-definition-cgm-001
InstanceOf: DeviceDefinition
Title: "HDDT rtCGM DeviceDefinition Example"
Description: "This example represents a Continuous Glucose Monitoring (CGM) device definition from the HIIS-VZ."
Usage: #example
* id = "device-definition-cgm-001"
* identifier.system = "http://fhir.de/sid/gkv/hmnr"
* identifier.value = "30.29.05.2004"
* deviceName[0].name = "CGM Model mg/dL"
* deviceName[0].type = #user-friendly-name
* type = $sct-version#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* manufacturerReference = Reference(Example-CGM-Manufacturer)
* modelNumber = "CGM Model mg/dL"
* extension[0].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDefinitionMivSet"
* extension[0].extension[0].url = "mivSet"
* extension[0].extension[0].valueReference = Reference(Example-Universal-Backend)
* extension[1].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceDefinition.regulatoryIdentifier"
* extension[1].extension[0].url = "deviceIdentifier"
* extension[1].extension[0].valueString = "9912345CGM001A"
* parentDevice = Reference(Example-Universal-Backend)
* property[0].type.text = "Supported unit"
* property[0].valueCode = $unitsofmeasure#mg/dL "mg/dL"
* property[+].type.text = "Reference range low"
* property[=].valueQuantity.value = 70
* property[=].valueQuantity.unit = "mg/dl"
* property[=].valueQuantity.system = $unitsofmeasure
* property[+].type.text = "Reference range high"
* property[=].valueQuantity.value = 180
* property[=].valueQuantity.unit = "mg/dl"
* property[=].valueQuantity.system = $unitsofmeasure
* capability[0].type.coding[0].system = $loinc
* capability[0].type.coding[0].code = #105272-9
* capability[0].type.coding[0].display = "Glucose [Moles/volume] in Interstitial fluid"

Instance: Example-CGM-Manufacturer
InstanceOf: Organization
Usage: #example
Title: "HDDT CGM Manufacturer Example"
Description: "Example organization representing the manufacturer of the CGM device."
* id = "example-cgm-manufacturer"
* type.coding[0].system = "https://fhir.bfarm.de/CodeSystem/HiisManufacturerType"
* type.coding[0].code = #legal
* type.coding[0].display = "Legal Entity"
* name = "rtCGM Manufacturer Inc."
* telecom[0].system = #email
* telecom[0].value = "info@rtcgm-manufacturer.com"
* address[0].line[0] = "CGM Technology Park 15"
* address[0].city = "Munich"
* address[0].postalCode = "80331"
* address[0].country = "DE"
* contact[0].name.given = "Maria"
* contact[0].name.family = "Sensor"
* contact[0].telecom[0].system = #phone
* contact[0].telecom[0].value = "+49-89-9876543"

// ---
// Lung Function Examples 
// ---

Instance: Example-Peak-Flow-Simple
InstanceOf: HddtLungFunctionTesting
Usage: #example
Title: "HDDT Lung Function Obervation Example (simple)"
Description: "Example of a peak expiratory flow measurement (PEF) taken with a peak flow meter. 
Simple version without a reference value or relative value."
* id = "example-peak-flow-simple"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#19935-6 "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
* effectiveDateTime = "2025-12-28T08:00:00Z"
* valueQuantity = 612 'L/min' "L/min"
* device = Reference(Example-Device-Peak-Flow)

Instance: Example-FEV1-Single-Measurement
InstanceOf: HddtLungFunctionTesting
Usage: #example
Title: "HDDT Lung Function Obervation Example (FEV1 single measurement)"
Description: "Example of a forced expiratory volume in 1 second (FEV1) measurement taken with a digital peak flow meter."
* id = "example-fev1-single-measurement"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#20150-9 "FEV1"
* effectiveDateTime = "2025-12-28T08:00:00Z"
* valueQuantity = 3.4 'L' "L"
* device = Reference(Example-Device-Peak-Flow)

Instance: Example-FEV1-Reference-Value
InstanceOf: HddtLungFunctionReferenceValue
Usage: #example
Title: "HDDT Lung Function Reference Value Obervation Example (FEV1 predicted)"
Description: "Example of a forced expiratory volume in 1 second (FEV1) reference value (predicted) for a patient."
* id = "example-fev1-reference-value"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#20149-1 "FEV1 predicted"
* effectivePeriod.start = "2025-05-01"
* valueQuantity = 4.5 'L' "L"
* method.coding[0].system = "https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-reference-value-method-codes"
* method.coding[0].code = #GLI-2022
* device = Reference(Example-Device-Peak-Flow)

Instance: Example-FEV1-Relative-Value
InstanceOf: HddtLungFunctionTestingComplete
Usage: #example
Title: "HDDT Lung Function Relative Value Obervation Example (FEV1 measured/predicted)"
Description: "Example of a forced expiratory volume in 1 second (FEV1) relative value (measured/predicted) for a patient."
* id = "example-fev1-relative-value"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#20152-5 "FEV1 measured/predicted"
* effectiveDateTime = "2025-12-28T08:00:00Z"
* valueQuantity = 75.5 '%' "%"
* derivedFrom[measurement] = Reference(Example-FEV1-Single-Measurement)
* derivedFrom[referenceValue] = Reference(Example-FEV1-Reference-Value)
* device = Reference(Example-Device-Peak-Flow)

Instance: Example-Device-Peak-Flow
InstanceOf: HddtPersonalHealthDevice
Title: "HDDT Peak Flow Meter Example"
Description: """
Example of a __real-time Continuous Glucose Monitoring device (rtCGM) as a personal health device__: 
The device _GlukkoCGM 18_ from _Glukko Inc._ performs continuous glucose measurements from interstitial fluid. 
The sensor stops transmitting data on September 10, 2025, and must be replaced by the patient at that date.
The vendor-defined model number of this typeof devices is _GCGMA98765_ and the serial number of the patient's 
individual device is _CGM1234567890_. Both identifiers are printed on the package of the device and allow the patient 
to validate the authenticity of this Personal Health Device resource.
"""
Usage: #example
* id = "example-device-peak-flow-meter"
* status = #active
* type = $sct-version#334990001 "Peak flow meter (physical object)"
* definition = Reference(DeviceDefinition/device-definition-peak-flow-001)
* deviceName.name = "Peak Flow Pro"
* deviceName.type = #user-friendly-name
* modelNumber = "Smart 2"
* manufacturer = "HealthTech GmbH"
* serialNumber = "PFM0011223344"
* expirationDate = "2027-12-15"

Instance: DeviceDefinition/device-definition-peak-flow-001
InstanceOf: DeviceDefinition
Title: "HDDT Peak Flow Meter DeviceDefinition Example"
Description: "This example represents a Peak Flow Meter device definition from the HIIS-VZ."
Usage: #example
* id = "device-definition-peak-flow-001"
* identifier.system = "http://fhir.de/sid/gkv/hmnr"
* identifier.value = "21.24.01.2005"
* deviceName[0].name = "Peak Flow Pro"
* deviceName[0].type = #user-friendly-name
* type = $sct-version#334990001 "Peak flow meter (physical object)"
* manufacturerString = "HealthTech GmbH"
* modelNumber = "Smart 2"
* extension[0].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDefinitionMivSet"
* extension[0].extension[0].url = "mivSet"
* extension[0].extension[0].valueReference = Reference(Example-Universal-Backend)
* extension[1].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceDefinition.regulatoryIdentifier"
* extension[1].extension[0].url = "deviceIdentifier"
* extension[1].extension[0].valueString = "9912345PEAKFLOW001"
* parentDevice = Reference(Example-Universal-Backend)
* capability[0].type.coding[0].system = $loinc
* capability[0].type.coding[0].code = #19935-6
* capability[0].type.coding[0].display = "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
* capability[1].type.coding[0].system = $loinc
* capability[1].type.coding[0].code = #20150-9
* capability[1].type.coding[0].display = "FEV1"
* capability[2].type.coding[0].system = $loinc
* capability[2].type.coding[0].code = #83368-1
* capability[2].type.coding[0].display = "Personal best peak expiratory gas flow Respiratory system airway"
* capability[3].type.coding[0].system = $loinc
* capability[3].type.coding[0].code = #20149-1
* capability[3].type.coding[0].display = "FEV1 predicted"
* capability[4].type.coding[0].system = $loinc
* capability[4].type.coding[0].code = #20152-5
* capability[4].type.coding[0].display = "FEV1 measured/predicted"
* capability[5].type.coding[0].system = "https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-temporary-codes"
* capability[5].type.coding[0].code = #PEF-measured/predicted

// ---
// Blood Pressure Measurement Examples 
// ---
Instance: DeviceDefinition/device-definition-blood-pressure-cuff-001
InstanceOf: DeviceDefinition
Title: "HDDT Blood Pressure Cuff DeviceDefinition Example"
Description: "This example represents a Blood Pressure Cuff device definition from the HIIS-VZ."
Usage: #example
* id = "device-definition-blood-pressure-cuff-001"
* identifier.system = "http://fhir.de/sid/gkv/hmnr"
* identifier.value = "21.28.01.2020"
* deviceName[0].name = "BP Cuff Pro"
* deviceName[0].type = #user-friendly-name
* type = $sct-version#70665002 "Blood pressure cuff"
* manufacturerString = "HealthTech GmbH"
* modelNumber = "Digital BT 2"
* extension[0].url = "https://fhir.bfarm.de/StructureDefinition/HiisDeviceDefinitionMivSet"
* extension[0].extension[0].url = "mivSet"
* extension[0].extension[0].valueReference = Reference(Example-Universal-Backend)
* extension[1].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-DeviceDefinition.regulatoryIdentifier"
* extension[1].extension[0].url = "deviceIdentifier"
* extension[1].extension[0].valueString = "9912345BPCUFF001"
* parentDevice = Reference(Example-Universal-Backend)
* capability[0].type.coding[0].system = $loinc
* capability[0].type.coding[0].code = #8480-6
* capability[0].type.coding[0].display = "Systolic blood pressure"
* capability[1].type.coding[0].system = $loinc
* capability[1].type.coding[0].code = #8462-4
* capability[1].type.coding[0].display = "Diastolic blood pressure"
* capability[2].type.coding[0].system = $loinc
* capability[2].type.coding[0].code = #8478-0
* capability[2].type.coding[0].display = "Mean blood pressure"

Instance: Example-Device-Blood-Pressure-Cuff
InstanceOf: HddtPersonalHealthDevice
Title: "HDDT Blood Pressure Cuff Example"
Description: """
Example of a __blood pressure cuff as a personal health device__: 
The device _BP Cuff Pro_ from _HealthTech GmbH_ performs blood pressure measurements. 
The device does not have an expiration date as it is a durable medical device.
The vendor-defined model number of this type of device is _Digital BT 2_ and the serial number of the patient's 
individual device is _BPC0011223345_. Both identifiers are printed on the device and allow the patient 
to validate the authenticity of this Personal Health Device resource.
"""
Usage: #example
* id = "example-device-blood-pressure-cuff"
* status = #active
* type = $sct-version#70665002 "Blood pressure cuff, device (physical object)"
* definition = Reference(DeviceDefinition/device-definition-blood-pressure-cuff-001)
* deviceName.name = "BP Cuff Pro"
* deviceName.type = #user-friendly-name
* modelNumber = "Digital BT 2"
* manufacturer = "HealthTech GmbH"
* serialNumber = "BPC0011223345"
* expirationDate = "2027-12-15"


Instance: Example-Blood-Pressure-Value
InstanceOf: HddtBloodPressureValue
Usage: #example
Title: "HDDT Blood Pressure Value Example"
Description: "Example of a blood pressure measurement with systolic, diastolic, and mean blood pressure components."
* id = "example-blood-pressure-value"
* status = #final
* category[VSCat] = $oc#vital-signs
* subject = Reference(patientExample)
* code.coding[loinc] = $loinc#85354-9 "Blood pressure panel with all children optional"
* effectiveDateTime = "2025-10-23T09:15:00+02:00"
* device = Reference(Example-Device-Blood-Pressure-Cuff)
* interpretation = $oi#N "Normal"
* component[SystolicBP].code = $loinc#8480-6 "Systolic blood pressure"
* component[SystolicBP].valueQuantity = 120 'mm[Hg]' "mm[Hg]"
* component[DiastolicBP].code = $loinc#8462-4 "Diastolic blood pressure"
* component[DiastolicBP].valueQuantity = 80 'mm[Hg]' "mm[Hg]"
* component[meanBP].code = $loinc#8478-0 "Mean blood pressure"
* component[meanBP].valueQuantity = 93 'mm[Hg]' "mm[Hg]"