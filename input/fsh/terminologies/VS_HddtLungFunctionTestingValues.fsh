Instance: HddtLungFunctionTestingValues
InstanceOf: $shareable-vs
Usage: #definition
Title: "Lung Function Testing Values from LOINC"
* id = "hddt-lung-function-testing-values"
* name = "HddtLungFunctionTestingValues"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die Codes für einzelne Lungenfunktionstests, die mit handgehaltenen Peak-Flow-Metern oder Spirometern gemessen werden.
Enthalten sind Codes für den _Peak Expiratory Flow_ (PEF) und das Forcierte Exspiratorische Volumen in 1 Sekunde (FEV1).

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the codes used for individual lung function testings, measured by hand-held peak flow meters or spirometers.
Included are codes for Peak Expiratory Flow (PEF) and Forced Expiratory Volume in 1 second (FEV1).
"""
* meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-29"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"
* status = #active
* experimental = false
* date = "2026-04-29"
* publisher = "gematik GmbH"
* contact.telecom[0].system = #url
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[0].system = $LNC
* compose.include[0].version = "2.82"
* compose.include[0].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[0].extension[0].valueString = "This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[0].concept[+].code = #19935-6 
* compose.include[0].concept[=].display = "Maximum expiratory gas flow Respiratory system airway by Peak flow meter"
* compose.include[0].concept[+].code = #20150-9 
* compose.include[0].concept[=].display = "FEV1"
