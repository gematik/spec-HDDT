CodeSystem: HddtLungFunctionReferenceValueMethodCodes
Id: hddt-lung-function-reference-value-method-codes
Title: "Lung Function Reference Value Method Codes"
Description: """
Dieses CodeSystem ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Der MIV _HddtMivLungFunctionTesting_ erfordert Referenzwerte zur Bewertung gemessener Lungenfunktionswerte. Diese Referenzwerte können mit unterschiedlichen
Methoden bestimmt werden. Dieses CodeSystem stellt Codes zur Verfügung, um typische Methoden zur Bestimmung von Lungenfunktions-Referenzwerten auszudrücken.

--

This CodeSystem is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The MIV _HddtMivLungFunctionTesting_ requires reference values for evaluating measured lung function values. These reference
values can be determined using different methods. This CodeSystem provides codes to express typical methods for determining lung function reference values.
"""
* ^language = #en
* ^version = $term-version
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
* ^extension[=].valuePeriod.start = "2026-04-29"
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/artifact-author"
* ^extension[=].valueContactDetail.name = "gematik GmbH"
* ^status = #active
* ^publisher = "gematik GmbH"
* ^date = "2026-04-29"
* ^contact.telecom[0].system = #url 
* ^contact.telecom[=].value = "https://www.gematik.de"
* ^copyright = "gematik GmbH."
* ^experimental = false
* ^caseSensitive = false
* ^versionNeeded = true
* ^valueSet = Canonical(hddt-lung-function-reference-value-method-codes|1.0.1)

* #personal-best "Personal Best"
    "Reference value based on the personal best value achieved by the patient within a certain time frame."
* #GLI-2012 "Predicted Value according to Global Lung Initiative 2012"
    "Reference value calculated based on the Global Lung Initiative 2012 equations. I.e the patient's 'race' is considered."
* #GLI-2022 "Predicted Value according to Global Lung Initiative 2022"
    "Reference value calculated based on the Global Lung Initiative 2022 equations. I.e. a 'race'-neutral approach is used."
* #other "Other"
    "Other method used to determine the lung function reference value. Specify details via text input."