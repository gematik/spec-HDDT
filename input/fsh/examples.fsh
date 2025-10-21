Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $sct = http://snomed.info/sct
Alias: $mdc = urn:iso:std:iso:11073:10101|20250520

Instance: Example-Blood-Glucose
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "HDDT Blood Glucose Obervation Example (general)"
Description: "Example of a blood glucose measurement taken with a glucometer."
* id = "example-blood-glucose"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-blood-glucose-measurement"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* effectiveDateTime = "2025-08-28T08:30:00Z"
* valueQuantity = 110 'mg/dL' "mg/dl"
* device = Reference(Example-Glucometer-Metric)

Instance: Example-Blood-Glucose-Measurement-1
InstanceOf: HddtBloodGlucoseMeasurement
Usage: #example
Title: "HDDT Blood Glucose Measurement 1 (from Example Object Diagram) "
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
Title: "HDDT Blood Glucose Measurement 2 (from Example Object Diagram) "
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
* type =  $mdc#528401 "Glucose Monitor"
* status = #active
// * statusReason = #online
* deviceName.name = "GlukkoCheck plus mg/dl"
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
* type = $mdc#160184 "MDC_CONC_GLU_CAPILLARY_WHOLEBLOOD"
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
Title: "DeviceDefinition – Roche Accu-Chek"
Description: "Example for a medical device (CGM sensor) from the medical device directory."
* id = "example-glucometer-def"
* identifier.system = "https://hilfsmittelverzeichnis.de"
* identifier.value = "12.34.56.7890" 
* deviceName[0].name = "Accu-Chek Mobile"
* deviceName[0].type = #user-friendly-name
* type = $sct#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* manufacturerString = "Roche Diabetes Care"
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
// Description: "Example for a backend system for processing HiMi data according to § 374a SGB V."

// * deviceName[0].name = "§ 374a SGB V Backend"
// * deviceName[0].type = #manufacturer-name
// * manufacturerString = "Acme Health IT GmbH"
// * type = $sct#706689003 "Health information exchange infrastructure (physical object)"
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
* effectivePeriod.start = "2025-08-28T08:00:00Z"
* effectivePeriod.end   = "2025-08-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dl"
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
* method = $sct#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* note.text = "Example CGM data series with 1-minute intervals over 1 hour (60 samples)."

Instance: Example-CGM-Series-Incomplete
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Incomplete Chunk Observation Example"
Description: "Example of a CGM time series with 1-minute intervals over 10 minutes (10 samples), but incomplete."
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
* valueSampledData.data = "110 111 112 113 114 115 116 117 118 119"
* device = Reference(Example-DeviceMetric-CGM)
* method = $sct#463729000 "Point-of-care blood glucose continuous monitoring system (physical object)"
* note.text = "Example CGM data series with 1-minute intervals over 10 minutes (10 samples), but status incomplete."


Instance: Example-Observation-CGM-Series-Data-Unavailable
InstanceOf: HddtContinuousGlucoseMeasurement
Title: "HDDT rtCGM Data Unavailable Observation Example"
Description: "Example of a CGM time series with status preliminary and dataAbsentReason"
Usage: #example
* id = "example-cgm-series-data-unavailable"
// * meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-continuous-glucose-measurement"
* status = #preliminary
* code = LOINC#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
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
* type = $mdc#528409 "MDC_DEV_SPEC_PROFILE_CGM"
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
* unit = UCUM#mg/dL "mg/dL"
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
Title: "Example Patient" 
Description: "This example represents a patient without content."
Usage: #example
* id = "patientExample"

Instance: DeviceDefinition/device-definition-cgm-001
InstanceOf: DeviceDefinition
Title: "Example CGM Device"
Description: "This example represents a Continuous Glucose Monitoring (CGM) device."
Usage: #example
* id = "device-definition-cgm-001"
* type = #device
* manufacturerString = "Example Manufacturer"
* modelNumber = "CGM Model 1"