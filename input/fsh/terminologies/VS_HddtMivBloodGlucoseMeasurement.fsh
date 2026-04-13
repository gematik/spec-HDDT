Instance: HddtMivBloodGlucoseMeasurement
InstanceOf: $shareable-vs
Usage: #definition
Title: "Blood Glucose Measurement from LOINC"
* id = "hddt-miv-blood-glucose-measurement"
* name = "HddtMivBloodGlucoseMeasurement"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivBloodGlucoseMeasurement_ definiert den Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Blood Glucose Measurement_ umfasst Werte aus „blutigen Messungen“, z. B. mit kapillarem Blut aus der Fingerkuppe. Die Messungen erfolgen gemäß Versorgungsplan
(z. B. Blutzuckermessung vor jeder Mahlzeit) oder ad hoc (z. B. bei Unwohlsein des Patienten, was auf eine Hypoglykämie hindeuten kann).
DiGA-Anwendungsfälle, die durch diesen MIV abgedeckt werden, erfordern sehr genaue Glukosewerte, die für therapeutische Entscheidungen geeignet sind.

Das ValueSet für den MIV _Blood Glucose Measurement_ enthält LOINC-Codes für Blutzuckermessungen mit Blut oder Plasma als Referenzmethoden, wobei die Werte als Masse/Volumen und Mol/Volumen angegeben werden.
Zusätzlich sind granularere LOINC-Codes für „Glukose im Kapillarblut mittels Glukometer“ als Masse/Volumen und Mol/Volumen enthalten, da diese Codes bereits von mehreren Herstellern von Glukometern verwendet werden.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

The ValueSet _HddtMivBloodGlucoseMeasurement_ defines the Mandatory Interoperable Value (MIV) \"Blood Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Blood Glucose Measurement_ covers values from \"bloody measurements\" e.g. using capillary blood from the 
finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc 
(e.g. a patient feeling dim what may be an indicator for a hypoglycamia). 
DiGA use cases served by this MIV require glucose values that are very acurate and therefore suited for therapeutical decision making. 

The ValueSet for the MIV _Blood Glucose Measurement_ contains LOINC codes for blood glucose measurements using 
blood or plasma as reference methods with the values provided as mass/volume and moles/volume. 
In addition more granular LOINC codes for \"Glucose in Capillary blood by Glucometer\" provided as mass/volume 
and moles/volume are included with the value set because these codes are already in use by several 
manufacturers of glucometers.
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
* compose.include[0].concept[+].code = #2339-0
* compose.include[0].concept[=].display = "Glucose [Mass/volume] in Blood"
* compose.include[0].concept[+].code = #15074-8
* compose.include[0].concept[=].display = "Glucose [Moles/volume] in Blood"
* compose.include[0].concept[+].code = #2345-7
* compose.include[0].concept[=].display = "Glucose [Mass/volume] in Serum or Plasma"
* compose.include[0].concept[+].code = #14749-6
* compose.include[0].concept[=].display = "Glucose [Moles/volume] in Serum or Plasma"
* compose.include[0].concept[+].code = #41653-7
* compose.include[0].concept[=].display = "Glucose [Mass/volume] in Capillary blood by Glucometer"
* compose.include[0].concept[+].code = #14743-9
* compose.include[0].concept[=].display = "Glucose [Moles/volume] in Capillary blood by Glucometer"