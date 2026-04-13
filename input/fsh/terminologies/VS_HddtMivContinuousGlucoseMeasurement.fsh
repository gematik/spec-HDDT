Instance: HddtMivContinuousGlucoseMeasurement
InstanceOf: $shareable-vs
Usage: #definition
Title: "Continuous Glucose Measurement from LOINC"
* id = "hddt-miv-continuous-glucose-measurement"
* name = "HddtMivContinuousGlucoseMeasurement"
* description = """
Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch zwischen 
Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Zentrales Element der HDDT-Spezifikation sind _Mandatory Interoperable Values_ (MIVs).
MIVs sind Klassen von Messwerten, die zu definierten Anwendungsfällen und Zwecken von DiGA beitragen.

Das ValueSet _HddtMivContinuousGlucoseMeasurement_ definiert den Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". Die Definition besteht aus
- dieser Beschreibung, die die Semantik und die bestimmenden Merkmale des MIV liefert
- einer Menge von LOINC-Codes, die MIV-konforme Messklassifikationen entlang der LOINC-Achsen _Komponente_, _System_, _Skala_ und _Methode_ definieren

Der MIV _Continuous Glucose Measurement_ umfasst Werte aus der kontinuierlichen Überwachung des Glukosespiegels, z. B. 
durch rtCGM im Interstitialfluid (ISF). Die Messungen werden mit Sensoren durchgeführt, die eine Abtastrate von bis zu 
einem Wert pro Minute (oder sogar mehr) ermöglichen. Dadurch kann der MIV _Continuous Glucose Measurement_ z. B. genutzt werden, um Zusammenhänge
zwischen den individuellen Gewohnheiten und dem Glukosespiegel eines Patienten zu beurteilen. Aufgrund der hohen Dichte an Werten über einen langen
Zeitraum können aus _Continuous Glucose Measurement_ viele Schlüsselmetriken berechnet werden, die dem Patienten und seinem Arzt helfen,
den Gesundheits- und Therapiezustand des Patienten einfach zu erfassen.

Das ValueSet für den MIV _Continuous Glucose Measurement_ enthält Codes, die für die kontinuierliche Glukoseüberwachung (CGM) im Interstitialfluid (ISF) relevant sind, 
wobei Masse/Volumen und Mol/Volumen als gebräuchliche Einheiten berücksichtigt werden. In Zukunft können diesem ValueSet Codes für nicht-invasive Glukosemessmethoden hinzugefügt werden.

--

This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). Core of the HDDT specification are _Mandatory Interoperable 
Values_ (MIVs). MIVs are classes of measurements that contribute to defined use cases and purposes of DiGA.

This ValueSet defines the Mandatory Interoperable Value (MIV) \"Continuous Glucose Measurement\". The definition is made up from
- this description which provides the semantics and defining characteristics of the MIV
- a set of LOINC codes that define MIV-compliant measurement classifications along the LOINC axes _component_, _system_, _scale_ and _method_ 

The MIV _Continuous Glucose Measurement_ covers values from continuous monitoring of the glucose level, e.g. 
by rtCGM in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to 
one value per minute (or even more). By this, the MIV _Continuous Glucose Measurement_ can e.g. be used to assess dependencies between a 
patient's individual habits and behavious and his glucose level. Due to the high density of values over a long period 
of time, many key metrics can be calculated from _Continuous Glucose Measurement_ which help the patient and 
his doctor to easily capture the status of the patient's health and therapy.

The ValueSet for the MIV _Continuous Glucose Measurement_ includes codes relevant to continuous glucose 
monitoring (CGM) in interstitial fluid (ISF), considering mass/volume and moles/volume as commonly used units. 
In the future codes defining non-invasive glucose measuring methods may be added to this value set.
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
* compose.include[0].concept[+].code = #105272-9 
* compose.include[0].concept[=].display = "Glucose [Moles/volume] in Interstitial fluid"
* compose.include[0].concept[+].code = #99504-3 
* compose.include[0].concept[=].display = "Glucose [Mass/volume] in Interstitial fluid"