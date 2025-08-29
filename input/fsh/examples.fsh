Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $sct = http://snomed.info/sct

Instance: example-blood-glucose
InstanceOf: Observation-Blood-Glucose
Usage: #example
* id = "example-blood-glucose"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/Observation-Blood-Glucose"
* status = #final
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* subject = Reference(Patient/example)
* effectiveDateTime = "2025-08-28T08:30:00Z"
* valueQuantity = 110 'mg/dL' "mg/dL"
* device = Reference(example-glucometer-metric)
* referenceRange.low = 70 'mg/dL' "mg/dL"
* referenceRange.high = 140 'mg/dL' "mg/dL"

Instance: example-cgm-series
InstanceOf: Observation-CGM-Measurement-Series
Usage: #example
* id = "example-cgm-series"
* status = #preliminary
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* subject = Reference(Patient/example)
* effectivePeriod.start = "2025-08-28T08:00:00Z"
* effectivePeriod.end = "2025-08-28T09:00:00Z"
* valueSampledData.origin.value = 0
* valueSampledData.origin.unit = "mg/dL"
* valueSampledData.origin.system = $unitsofmeasure
* valueSampledData.origin.code = #mg/dL
* valueSampledData.period = 300000
* valueSampledData.dimensions = 1 
* valueSampledData.data = "110 112 115 118 120 119 117"
* device = Reference(example-glucometer-metric)
* method = $sct#105824000 "Continuous blood glucose monitoring"

Instance: example-glucometer
InstanceOf: Device-Medical-Aid
Usage: #example
* id = "example-glucometer"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/Device-Medical-Aid"
* deviceName.name = "Accu-Chek Mobile"
* deviceName.type = #user-friendly-name
* manufacturer = "Roche"
* serialNumber = "SN123456"
* modelNumber = "Accu-Chek Mobile U1 mg/dl"
* definition = Reference(example-glucometer-def)

Instance: example-glucometer-metric
InstanceOf: DeviceMetric-Medical-Aid
Usage: #example
* id = "example-glucometer-metric"
* meta.profile = "https://gematik.de/fhir/hddt/StructureDefinition/DeviceMetric-Medical-Aid"
* type = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* unit = $unitsofmeasure#mg/dL "milligram per deciliter"
* source = Reference(example-glucometer)
* operationalStatus = #on
* category = #measurement
* measurementPeriod.repeat.frequency = 1
* measurementPeriod.repeat.period = 1
* measurementPeriod.repeat.periodUnit = #s
* calibration.state = #calibrated



Instance: example-glucometer-def
InstanceOf: DeviceDefinition
Usage: #example
Title: "DeviceDefinition – Roche Accu-Chek"
Description: "Example for a medical device (CGM sensor) from the medical device directory."

* identifier.system = "https://hilfsmittelverzeichnis.de"
* identifier.value = "12.34.56.7890" 
* deviceName[0].name = "Accu-Chek Mobile"
* deviceName[0].type = #user-friendly-name
* type = $sct#105824000 "Continuous blood glucose monitoring"
* manufacturerString = "Roche Diabetes Care"
* parentDevice = Reference(example-devicedef-backend)
* property[0].type.text = "Supported unit"
* property[0].valueCode = $unitsofmeasure#mg/dL "milligram per deciliter"
* property[+].type.text = "Supported unit"
* property[=].valueCode = $unitsofmeasure#mmol/L "millimole per liter"
* property[+].type.text = "Reference range low"
* property[=].valueQuantity.value = 70
* property[=].valueQuantity.unit = "mg/dL"
* property[=].valueQuantity.system = $unitsofmeasure
* property[+].type.text = "Reference range high"
* property[=].valueQuantity.value = 180
* property[=].valueQuantity.unit = "mg/dL"
* property[=].valueQuantity.system = $unitsofmeasure
* capability[0].type.coding[0].system = $loinc
* capability[0].type.coding[0].code = #2339-0
* capability[0].type.coding[0].display = "Glucose [Mass/volume] in Blood"
* capability[0].type.text = "Blood glucose measurement (fingerstick and continuous monitoring)"

Instance: example-devicedef-backend
InstanceOf: DeviceDefinition
Usage: #example
Title: "DeviceDefinition – Roche Device Backend"
Description: "Example for a backend system for processing HiMi data according to §374a SGB V."

* deviceName[0].name = "§374a SGB V Backend"
* deviceName[0].type = #manufacturer-name
* manufacturerString = "Acme Health IT GmbH"
* type = $sct#706689003 "Health information exchange infrastructure (physical object)"
* url = "https://himi-backend.de/fhir"
