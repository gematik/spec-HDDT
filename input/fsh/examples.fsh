Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $sct = http://snomed.info/sct
Alias: $mdc = urn:iso:std:iso:11073:10101

Instance: Example-Blood-Glucose
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "Blood Glucose Measurement"
Description: "Example of a blood glucose measurement taken with a glucometer."
* id = "example-blood-glucose"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* effectiveDateTime = "2025-08-28T08:30:00Z"
* valueQuantity = 110 'mg/dL' "mg/dL"
* device = Reference(Example-Glucometer-Metric)
* referenceRange.low = 70 'mg/dL' "mg/dL"
* referenceRange.high = 140 'mg/dL' "mg/dL"


Instance: Example-Glucometer
InstanceOf: HddtPersonalHealthDevice
Usage: #example
Title: "Glucometer Device"
Description: "Example of a personal health device (glucometer) used for blood glucose measurements."
* id = "example-glucometer"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
* type =  $mdc#528401 "Glucose Monitor"
* statusReason = #online
* deviceName.name = "Accu-Chek Mobile"
* deviceName.type = #user-friendly-name
* manufacturer = "Roche"
* serialNumber = "SN123456"
* modelNumber = "Accu-Chek Mobile U1 mg/dl"
* definition = Reference(Example-Glucometer-Def)

Instance: Example-Glucometer-Metric
InstanceOf: HddtSensorTypeAndCalibrationStatus
Usage: #example
Title: "Glucometer Device Metric"
Description: "Example of a device metric for blood glucose measurements from a glucometer."
* id = "example-glucometer-metric"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
* type = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* unit = $unitsofmeasure#mg/dL "milligram per deciliter"
* source = Reference(Example-Glucometer)
* operationalStatus = #on
* category = #measurement
* measurementPeriod.repeat.frequency = 1
* measurementPeriod.repeat.period = 1
* measurementPeriod.repeat.periodUnit = #s
* calibration.state = #calibrated



// Instance: Example-Glucometer-Def
// InstanceOf: DeviceDefinition
// Usage: #example
// Title: "DeviceDefinition – Roche Accu-Chek"
// Description: "Example for a medical device (CGM sensor) from the medical device directory."
// * id = "example-glucometer-def"
// * identifier.system = "https://hilfsmittelverzeichnis.de"
// * identifier.value = "12.34.56.7890" 
// * deviceName[0].name = "Accu-Chek Mobile"
// * deviceName[0].type = #user-friendly-name
// * type = $sct#105824000 "Continuous blood glucose monitoring"
// * manufacturerString = "Roche Diabetes Care"
// * parentDevice = Reference(Example-DeviceDefinition-Backend)
// * property[0].type.text = "Supported unit"
// * property[0].valueCode = $unitsofmeasure#mg/dL "milligram per deciliter"
// * property[+].type.text = "Supported unit"
// * property[=].valueCode = $unitsofmeasure#mmol/L "millimole per liter"
// * property[+].type.text = "Reference range low"
// * property[=].valueQuantity.value = 70
// * property[=].valueQuantity.unit = "mg/dL"
// * property[=].valueQuantity.system = $unitsofmeasure
// * property[+].type.text = "Reference range high"
// * property[=].valueQuantity.value = 180
// * property[=].valueQuantity.unit = "mg/dL"
// * property[=].valueQuantity.system = $unitsofmeasure
// * capability[0].type.coding[0].system = $loinc
// * capability[0].type.coding[0].code = #2339-0
// * capability[0].type.coding[0].display = "Glucose [Mass/volume] in Blood"
// * capability[0].type.text = "Blood glucose measurement (fingerstick and continuous monitoring)"

// Instance: Example-DeviceDefinition-Backend
// InstanceOf: DeviceDefinition
// Usage: #example
// Title: "DeviceDefinition – Roche Device Backend"
// Description: "Example for a backend system for processing HiMi data according to §374a SGB V."

// * deviceName[0].name = "§374a SGB V Backend"
// * deviceName[0].type = #manufacturer-name
// * manufacturerString = "Acme Health IT GmbH"
// * type = $sct#706689003 "Health information exchange infrastructure (physical object)"
// * url = "https://himi-backend.de/fhir"

Instance: Example-CGM-Series
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "CGM Measurement Series"
Description: "Example of a CGM time series with 1-minute intervals over 1 hour (60 samples)."
Usage: #example
* id = "example-cgm-series"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #final
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-08-28T08:00:00Z"
* effectivePeriod.end   = "2025-08-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dL"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 60000
* valueSampledData.dimensions = 1
* valueSampledData.data = "110 111 112 113 114 115 116 117 118 119 
                          120 121 122 123 124 125 126 127 128 129 
                          130 129 128 127 126 125 124 123 122 121 
                          120 119 118 117 116 115 114 113 112 111 
                          110 111 112 113 114 115 116 117 118 119 
                          120 121 122 123 124 125 126 127 128 129 
                          130 129 128 127 126 125 124 123 122 121"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct#105824000 "Continuous blood glucose monitoring"
* note.text = "Example CGM data series with 1-minute intervals over 1 hour (60 samples)."

Instance: Example-CGM-Series-Incomplete
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "CGM Measurement Series Incomplete"
Description: "Example of a CGM time series with 1-minute intervals over 10 minutes (10 samples), but incomplete."
Usage: #example
* id = "example-cgm-series-incomplete"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #preliminary
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-08-28T08:00:00Z"
* effectivePeriod.end   = "2025-08-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dL"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 60000
* valueSampledData.dimensions = 1
* valueSampledData.data = "110 111 112 113 114 115 116 117 118 119"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct#105824000 "Continuous blood glucose monitoring"
* note.text = "Example CGM data series with 1-minute intervals over 10 minutes (10 samples), but status incomplete."


Instance: Example-Observation-CGM-Series-Data-Unavailable
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "CGM Measurement Series – Data Unavailable"
Description: "Example of a CGM time series with status preliminary and dataAbsentReason"
Usage: #example
* id = "example-cgm-series-data-unavailable"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #preliminary
* code = LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* effectivePeriod.start = "2025-09-01T08:00:00+02:00"
* effectivePeriod.end   = "2025-09-01T10:00:00+02:00"
* dataAbsentReason = http://terminology.hl7.org/CodeSystem/data-absent-reason#temp-unknown "temporarily unavailable"
* device = Reference(Example-DeviceMetric-CGM)
* note.text = "Sensor warm-up phase, values not yet validated."

Instance: Example-Device-CGM
InstanceOf: HddtPersonalHealthDevice
Title: "Personal Health Device – CGM"
Description: "Example of a continuous glucose monitoring device"
Usage: #example
* id = "example-device-cgm"
* status = #active
* statusReason = #online
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-personal-health-device"
* type = Mdc#528409 "Continuous Glucose Monitor"
* definition = Reference(DeviceDefinition/device-definition-cgm-001)
* deviceName.name = "Dexcom G7 Sensor"
* deviceName.type = #user-friendly-name
* modelNumber = "G7-2025"
* serialNumber = "CGM1234567890"
* expirationDate = "2025-09-10"

Instance: Example-DeviceMetric-CGM
InstanceOf: HddtSensorTypeAndCalibrationStatus
Title: "DeviceMetric – CGM tissue glucose configuration"
Description: "Example configuration for CGM measurements"
Usage: #example
* id = "example-devicemetric-cgm"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-sensor-type-and-calibration-status"
* type = LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* unit = UCUM#mg/dL "milligram per deciliter"
* source = Reference(Example-Device-CGM)
* operationalStatus = #on
* category = #measurement
* measurementPeriod.repeat.frequency = 1
* measurementPeriod.repeat.period = 5
* measurementPeriod.repeat.periodUnit = #min


Instance: cgmSummaryMeanGlucoseMassPerVolumeExample
InstanceOf: CGMSummaryMeanGlucoseMassPerVolume
Title: "Mean Glucose (Mass) Example"
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
Title: "Mean Glucose (Molar) Example"
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
Title: "CGM Summary Times in Ranges Example" 
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
Title: "GMI Example"
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
Title: "Coefficient of Variation Example"
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
Title: "Days of Wear Example"
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
Title: "Sensor Active Percentage Example" 
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
Title: "CGM Summary Example"
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
Title: "Example Bundle – CGM Summary Data with Device Context"
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

* entry[9].fullUrl = "https://gematik.de/fhir/hddt/DeviceMetric/example-devicemetric-cgm"
* entry[9].resource = Example-DeviceMetric-CGM
