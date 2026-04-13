Instance: HddtLungFunctionRelativeValues
InstanceOf: $shareable-vs
Usage: #definition
Title: "Lung Function Relative Values from LOINC"
* id =  "hddt-lung-function-relative-values"
* name = "HddtLungFunctionRelativeValues"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert.

Dieses ValueSet definiert die LOINC-Codes, die für relative Lungenfunktionswerte verwendet werden. Der relative Wert wird berechnet, indem die 
individuelle Messung durch den Referenzwert geteilt wird, was zu einem Prozentwert (%) führt. Enthaltene Codes sind für
- FEV1 measured/predicted
- PEF measured/predicted

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). 

This ValueSet defines the LOINC codes, used for relative lung function values. The relative value is calculated by dividing the 
individual measurement by the reference value, resulting in a percentage value (%). Included codes are for 
- FEV1 measured/predicted
- PEF measured/predicted
"""
* meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-01"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"
* status = #active
* experimental = false
* date = "2026-04-01"
* publisher = "gematik GmbH"
* contact.telecom[0].system = #url
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "gematik GmbH. This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[0].system = $LNC
* compose.include[0].version = "2.82"
* compose.include[0].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[0].extension[0].valueString = "This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[0].concept[+].code = #20152-5 
* compose.include[0].concept[=].display = "FEV1 measured/predicted"
* compose.include[1].system = "https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-temporary-codes"
* compose.include[1].version = "1.0.0"
* compose.include[1].concept[+].code = #PEF-measured/predicted
* compose.include[1].concept[=].display = "PEF measured/predicted"