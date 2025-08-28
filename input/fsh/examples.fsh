Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $sct = http://snomed.info/sct

Instance: example-glucometer-of-Device
InstanceOf: Device
Usage: #example
* id = "example-glucometer"
* deviceName.name = "Accu-Chek Mobile"
* deviceName.type = #user-friendly-name
* manufacturer = "Roche"
* serialNumber = "2937459287531567"
* modelNumber = "Accu-Chek Mobile U1 mg/dl"
* definition = Reference(DeviceDefinition/example-glucometer-def)

Instance: example-glucometer-metric
InstanceOf: DeviceMetric
Usage: #example
* type = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* unit = $unitsofmeasure#mg/dL "milligram per deciliter"
* source = Reference(Device/example-glukometer)
* parent = Reference(DeviceDefinition/dc102)
* operationalStatus = #on
* category = #measurement
* measurementPeriod.repeat.frequency = 1
* measurementPeriod.repeat.period = 1
* measurementPeriod.repeat.periodUnit = #s
* calibration.state = #calibrated

Instance: example-glucometer-of-Observation
InstanceOf: Observation
Usage: #example
* id = "example-glucometer"
* status = #final
* category = $observation-category#vital-signs
* code = $loinc#2339-0 "Glucose [Mass/volume] in Blood"
* subject = Reference(Patient/example)
* effectiveDateTime = "2025-08-11T08:30:00+01:00"
* valueQuantity = 92 'mg/dL' "mg/dL"
* device = Reference(example-glucometer-metric)

Instance: example-cgm-measurement-series
InstanceOf: Observation
Usage: #example
* status = #preliminary
* category = $observation-category#vital-signs "Vital Signs"
* code = $loinc#99504-3 "Glucose [Mass/volume] in Interstitial fluid"
* code.text = "Tissue glucose [Mass/volume] with rtCGM"
* subject = Reference(Patient/12345)
* effectivePeriod.start = "2025-08-11T08:00:00Z"
* effectivePeriod.end = "2025-08-11T09:00:00Z"
* issued = "2025-08-11T09:01:00Z"
* valueSampledData.origin = $unitsofmeasure#mg/dL "mg/dL"
* valueSampledData.period = 300000
* valueSampledData.dimensions = 1
* valueSampledData.data = "110 112 111 115 118 120 122 121 119 117 115 114"
* dataAbsentReason = #temp-unknown "Temporary loss of data"
* device = Reference(DeviceMetric/rtCGM-Conf-1)
* referenceRange.low = 70 'mg/dL' "mg/dL"
* referenceRange.high = 140 'mg/dL' "mg/dL"
* method = $sct#105824000 "Continuous blood glucose monitoring"