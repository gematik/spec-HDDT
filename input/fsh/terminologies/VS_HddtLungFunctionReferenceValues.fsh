
Instance: HddtLungFunctionReferenceValues
InstanceOf: $shareable-vs
Usage: #definition
Title: "Lung Function Reference Values from LOINC"
* id = "hddt-lung-function-reference-values"
* name = "HddtLungFunctionReferenceValues"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die LOINC-Codes, die für Referenzwerte der Lungenfunktion verwendet werden:
- Der Referenzwert für den _Peak Expiratory Flow_ (PEF) ist der persönliche Bestwert, den der Patient innerhalb eines bestimmten Zeitraums erreicht hat.
- Der Referenzwert für das Forcierte Exspiratorische Volumen in 1 Sekunde (FEV1) ist in den meisten Fällen ein vorhergesagter Wert, der auf Basis der demografischen Daten des Patienten berechnet wird.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the LOINC codes, used for lung function reference values:
- The reference value for Peak Expiratory Flow (PEF) is the personal best value achieved by the patient within a certain time frame. 
- The reference value for Forced Expiratory Volume in 1 second (FEV1) is in most cases a predicted value, calculated based on demographic data of the patient.
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
* compose.include[0].concept[+].code = #83368-1 
* compose.include[0].concept[=].display = "Personal best peak expiratory gas flow Respiratory system airway"
* compose.include[0].concept[+].code = #20149-1 
* compose.include[0].concept[=].display = "FEV1 predicted"