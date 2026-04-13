CodeSystem: HddtLungFunctionTemporaryCodes
Id: hddt-lung-function-temporary-codes
Title: "Lung Function Temporary Codes"
Description: """
Temporäre Codes für den MIV _Lung Function Testing_, bis LOINC-Codes verfügbar sind.

--

Temporary codes for the MIV _Lung Function Testing_ until LOINC codes are avaiblable.
"""
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-01"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^experimental = false
* ^caseSensitive = false
* ^status = #active
* ^versionNeeded = true
* ^publisher = "gematik GmbH"
* ^date = "2026-04-01"
* ^contact.telecom[0].system = #url 
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* ^valueSet = Canonical(HddtLungFunctionTemporaryCodesVS|1.0.0)
* #PEF-measured/predicted "PEF measured/predicted"