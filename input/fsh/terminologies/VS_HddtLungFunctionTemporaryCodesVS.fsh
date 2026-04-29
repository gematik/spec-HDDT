
ValueSet: HddtLungFunctionTemporaryCodesVS
Id: hddt-lung-function-temporary-codes
Title: "Lung Function Temporary Codes"
Description: """
ValueSet für temporäre Codes, die im CodeSystem _HddtLungFunctionTemporaryCodes_ definiert sind, bis LOINC-Codes verfügbar sind.

--

A ValueSet for temporary codes defined in the _HddtLungFunctionTemporaryCodes_ CodeSystem until LOINC codes are available.
"""
* ^name = "HddtLungFunctionTemporaryCodes" // override name. FSH instance name is different to avoid confusion with the CodeSystem of the same name.
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-29"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^experimental = false
* ^date = "2026-04-29"
* ^publisher = "gematik GmbH"
* ^contact.telecom[0].system = #url
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH"
* include codes from system HddtLungFunctionTemporaryCodes|1.0.1