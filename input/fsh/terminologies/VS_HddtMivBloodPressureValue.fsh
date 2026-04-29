
Instance: HddtMivBloodPressureValue
InstanceOf: $shareable-vs
Usage: #definition
Title: "Blood Pressure Value from LOINC"
* id = "hddt-miv-blood-pressure-value"
* name = "HddtMivBloodPressureValue"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivBloodPressureValue_ definiert den Mandatory Interoperable Value (MIV) \"Blood Pressure Monitoring\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Blood Pressure Monitoring_ umfasst Werte aus Blutdruckmessungen, die mit oszillometrischen oder auskultatorischen, automatisierten 
Sphygmomanometern durchgeführt werden. Die Messungen erfolgen gemäß Versorgungsplan (z. B. täglich oder einmal pro Woche).
DiGA-Anwendungsfälle, die durch diesen MIV abgedeckt werden, erfordern genaue Blutdruckwerte, die für therapeutische Entscheidungen geeignet sind.

Das ValueSet für den MIV _Blood Pressure Monitoring_ enthält den LOINC-Code für das vollständige Blutdruck-Panel, sollte aber auch die Möglichkeit bieten, in zukünftigen Updates zusätzliche Codes aufzunehmen.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The ValueSet _HddtMivBloodPressureValue_ defines the Mandatory Interoperable Value (MIV) \"Blood Pressure Monitoring\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Blood Pressure Monitoring_ covers values from blood pressure measurements performed using oszillometric or auscultatory, automated 
sphygmomanometers. Measurements are performed based on a care plan (e.g., daily or once per week).
DiGA use cases served by this MIV require blood pressure values that are accurate and therefore suited for therapeutic decision making. 

The ValueSet for the MIV _Blood Pressure Monitoring_ contains the LOINC code for complete blood pressure panel, but should still have the option to include additional code in future updates.
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
* compose.include[0].concept[0].code = #85354-9
* compose.include[0].concept[0].display = "Blood pressure panel with all children optional"