Instance: hddt-miv-lung-function-testing
InstanceOf: $shareable-vs
Usage: #definition
Title: "MIV Lung Function Testing from LOINC"

* name = "HddtMivLungFunctionTesting"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivLungFunctionTesting_ definiert den Mandatory Interoperable Value (MIV) \"Lung Function Testing\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Lung Function Testing_ umfasst Werte aus Lungenfunktionstests, die durch Ausatmen in ein handgehaltenes Peak-Flow-Meter oder Spirometer durchgeführt werden.
Die Messungen erfolgen zweimal täglich oder häufiger, wenn dies durch den Versorgungsplan oder den Zustand des Patienten erforderlich ist.

Das ValueSet für den MIV _Lung Function Testing_ enthält LOINC-Codes für die Messung des _Peak Expiratory Flow_ (PEF) und des Forcierten Exspiratorischen Volumens in 1 Sekunde (FEV1).
Ebenfalls enthalten sind LOINC-Codes für die entsprechenden Referenzwerte sowie relative Werte (z. B. _FEV1 measured/predicted_). Dieses ValueSet enthält die LOINC-Codes nicht direkt, sondern die Codes stammen aus drei separaten ValueSets:
- HddtLungFunctionTestingValues: Codes für einzelne Lungenfunktionstests
- HddtLungFunctionReferenceValues: Codes für Referenzwerte der Lungenfunktion
- HddtLungFunctionRelativeValues: Codes für relative Lungenfunktionswerte, berechnet in Prozent (%)

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

This ValueSet defines the Mandatory Interoperable Value (MIV) \"Lung Function Testing\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_.

The MIV _Lung Function Testing_ covers values from lung function testings that are performed by exhaling air
into a hand-held peak flow meter or spirometer. Measurements are performed twice a day, or more frequently if required
by the care plan or the patient's condition.

The ValueSet for the MIV _Lung Function Testing_ includes LOINC codes for measuring the Peak Expiratory Flow (PEF) and
Forced Expiratory Volume in 1 second (FEV1). Also included are LOINC codes for the corresponding reference values, and 
relative values (e.g. FEV1 measured/predicted). This ValueSet does not include LOIC codes directly, instead the codes 
come from three separate ValueSets:
- HddtLungFunctionTestingValues: codes for individual lung function testings
- HddtLungFunctionReferenceValues: codes for lung function reference values
- HddtLungFunctionRelativeValues: codes for relative lung function values, calculated in percentages (%)
"""
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
* compose.include[0].valueSet = "https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-testing-values|1.0.1"
* compose.include[=].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[=].extension[0].valueString = "This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[+].valueSet = "https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-reference-values|1.0.1"
* compose.include[=].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[=].extension[0].valueString = "This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* compose.include[+].valueSet = "https://gematik.de/fhir/hddt/ValueSet/hddt-lung-function-relative-values|1.0.1"
* compose.include[=].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[=].extension[0].valueString = "This material contains content from [LOINC](http://loinc.org). LOINC is copyright ©1995, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at [http://loinc.org/license](http://loinc.org/license). LOINC® is a registered United States trademark of Regenstrief Institute, Inc."

