ValueSet: HddtLungFunctionReferenceValueMethod
Id: hddt-lung-function-reference-value-method-codes
Title: "Lung Function Reference Value Method"
Description: """
Ein ValueSet für Codes, die die Methode zur Bestimmung von Referenzwerten der Lungenfunktion angeben. Enthalten sind Codes aus dem CodeSystem _HddtLungFunctionReferenceValueMethodCodes_:
- Personal Best (persönlicher Bestwert)
- Vorhergesagter Wert gemäß Global Lung Initiative 2012
- Vorhergesagter Wert gemäß Global Lung Initiative 2022
- Sonstige

--

A ValueSet for codes used to specify the method used to determine lung function reference values. Included are codes from the _HddtLungFunctionReferenceValueMethodCodes_ CodeSystem:
- Personal Best
- Predicted Value according to Global Lung Initiative 2012
- Predicted Value according to Global Lung Initiative 2022
- Other
"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-04-01"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* include codes from system https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-reference-value-method-codes|1.0.0