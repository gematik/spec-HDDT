Instance: HddtLungFunctionTemporaryToLoinc
InstanceOf: ConceptMap
Usage: #definition
Title: "Lung Function Temporary Codes to LOINC"
Description: """
Eine Abbildung von temporären Codes, die im CodeSystem _HddtLungFunctionTemporaryCodes_ definiert sind, auf LOINC-Codes.
Falls noch kein LOINC-Code verfügbar ist, wird dies mit einer Äquivalenz von 'unmatched' angezeigt.
Sobald ein LOINC-Code für einen temporären Code verfügbar ist, wird diese ConceptMap entsprechend aktualisiert.

--

A mapping from temporary codes defined in the _HddtLungFunctionTemporaryCodes_ CodeSystem to LOINC codes.
In case no LOINC code is available yet, the mapping indicates that with an equivalence of 'unmatched'.
Whenever a LOINC code becomes available for a temporary code, this ConceptMap will be updated accordingly.
"""
* experimental = false
* language = #en
* version = $term-version
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* extension[=].valuePeriod.start = "2026-04-01"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* extension[=].valueContactDetail.name = "gematik GmbH"
* name = "HddtLungFunctionTemporaryToLoinc"
* status = #active
* publisher = "gematik GmbH"
* date = "2026-04-01"
* contact.telecom[0].system = #url 
* contact.telecom[=].value = "https://www.gematik.de"
* copyright = "gematik GmbH."
* sourceCanonical = Canonical(HddtLungFunctionTemporaryCodesVS|1.0.0) 
* group[+].source = "https://gematik.de/fhir/hddt/CodeSystem/hddt-lung-function-temporary-codes"
* group[=].sourceVersion = "1.0.0"
* group[=].target = $LNC
* group[=].targetVersion = "2.82"
* group[=].element[+].code = #PEF-measured/predicted
* group[=].element[=].target.comment = "No target LOINC code available yet."
* group[=].element[=].target.equivalence = #unmatched