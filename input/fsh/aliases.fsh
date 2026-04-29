Alias: $cgm-summary = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary
Alias: $cgm-summary-mean-glucose-mass-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-mass-per-volume
Alias: $cgm-summary-mean-glucose-moles-per-volume = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-mean-glucose-moles-per-volume
Alias: $cgm-summary-times-in-ranges = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-times-in-ranges
Alias: $cgm-summary-gmi = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-gmi
Alias: $cgm-summary-coefficient-of-variation = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-coefficient-of-variation
Alias: $cgm-summary-days-of-wear = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-days-of-wear
Alias: $cgm-summary-sensor-active-percentage = http://hl7.org/fhir/uv/cgm/StructureDefinition/cgm-summary-sensor-active-percentage
Alias: $bp-sd = http://fhir.de/StructureDefinition/observation-de-vitalsign-blutdruck
Alias: $ucum-units = http://hl7.org/fhir/ValueSet/ucum-units
Alias: $mdc = urn:iso:std:iso:11073:10101

// LOINC version hard-coded in some locations; update manually if version changes
Alias: $LNC = http://loinc.org
Alias: $LNC-versioned = http://loinc.org|2.81

// change both 'version' and 'version-suffix'!!!
Alias: $sct = http://snomed.info/sct
Alias: $sct-version-suffix = http://snomed.info/sct/11000274103/version/20251115
Alias: $sct-version = http://snomed.info/sct|http://snomed.info/sct/11000274103/version/20251115 // german Snomed

Alias: $shareable-vs = http://hl7.org/fhir/StructureDefinition/shareablevalueset
// since the VS is an instance, we need to hardcode the URI for bindings, etc.
Alias: $vs-device-type = https://gematik.de/fhir/hddt/ValueSet/hddt-device-type
// placeholder does not work for includes, references, bindings, etc., so replace manually !!
Alias: $term-version = 1.0.1

Alias: $loinc = http://loinc.org
Alias: $unitsofmeasure = http://unitsofmeasure.org
Alias: $sct = http://snomed.info/sct
Alias: $oi = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation
Alias: $oc = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $mdc = urn:iso:std:iso:11073:10101