// this is an instance, because we need to add an extension to the include for copyrights.
// for instances, we can't explicitely set `id`, but it is automaticly generated from the 'Instance' field. We also need to explicitely set the name.
Instance: hddt-device-type
InstanceOf: $shareable-vs
Usage: #definition
Title: "Device Type of personal health devices"
* name = "HddtDeviceType"
* description = """
Dieses ValueSet enthält Codes zur Identifikation von _Personal Health Devices_ und _Device Data Recordern_.

Die Definition dieses ValueSets ist eine Teilmenge der Definition des FHIR R5 ValueSet [Device Type](https://hl7.org/fhir/R5/valueset-device-type.html),
angepasst für die Verwendung mit den auf FHIR R4 basierenden HDDT-Profilen.

Dieses Material enthält SNOMED Clinical Terms® (SNOMED CT®), die mit Genehmigung der International Health Terminology Standards Development Organisation (IHTSDO) verwendet werden.
Alle Rechte vorbehalten. SNOMED CT® wurde ursprünglich vom College of American Pathologists entwickelt. 'SNOMED' und 'SNOMED CT' sind eingetragene Warenzeichen der IHTSDO.

Dieses ValueSet ist Teil der Health Device Data Transfer Spezifikation (HDDT), die Profile, Operationen und ValueSets für den Datenaustausch 
zwischen Hilfsmitteln und digitalen Gesundheitsanwendungen (DiGA) definiert. Der Inhalt des ValueSets umfasst immer mindestens alle Gerätetypen,
für die HDDT _Mandatory Interoperable Values_ (MIVs) definiert. Damit kann dieses ValueSet zukünftig auch Codes enthalten, die nicht Teil des FHIR ValueSet _Device Type_ sind.

--

This ValueSet includes codes used to identify Personal Health Devices and Device Data Recorders.

This ValueSet's definition is a subset of the definition of the FHIR R5 ValueSet 
[Device Type](https://hl7.org/fhir/R5/valueset-device-type.html), adapted for use with the FHIR R4 based HDDT profiles. 

This material includes SNOMED Clinical Terms® (SNOMED CT®) which is used by permission of the International Health Terminology Standards Development Organisation (IHTSDO).
All rights reserved. SNOMED CT®, was originally created by The College of American Pathologists. 'SNOMED' and 'SNOMED CT' are registered trademarks of the IHTSDO.

CAVE: This ValueSet is part of the Health Device Data Transfer specification (HDDT) which defines profiles, operations, and value sets 
for sharing data between medical aids and digital health applications (DiGA). The content of the value set will always at latest
cover all types of device types for whoch HDDT defines _Mandatory Interoperable Values_ (MIVs). By this, this value set MAY
in the future include codes which are not part of the FHIR ValueSet _Device Type_. 
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
* copyright = "The copyright for the compilation of this value set is held by gematik GmbH and by Federal Institute for Drugs and Medical Devices (BfArM). This valueset includes SNOMED Clinical Terms® (SNOMED CT®) which is used by permission of the International Health Terminology Standards Development Organisation (IHTSDO). All rights reserved. SNOMED CT®, was originally created by The College of American Pathologists. 'SNOMED' and 'SNOMED CT' are registered trademarks of the IHTSDO."
* compose.include[0].system = $sct
* compose.include[0].version = $sct-version-suffix
* compose.include[0].extension[0].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.compose.include.copyright"
* compose.include[0].extension[0].valueString = "This valueset includes SNOMED Clinical Terms® (SNOMED CT®) which is used by permission of the International Health Terminology Standards Development Organisation (IHTSDO). All rights reserved. SNOMED CT®, was originally created by The College of American Pathologists. 'SNOMED' and 'SNOMED CT' are registered trademarks of the IHTSDO."
* compose.include[0].concept[0].code = #337414009
* compose.include[0].concept[=].display = "Blood glucose meter (physical object)"
* compose.include[0].concept[+].code = #700585005
* compose.include[0].concept[=].display = "Invasive interstitial-fluid glucose monitoring system (physical object)"
* compose.include[0].concept[+].code = #701815004
* compose.include[0].concept[=].display = "Non-invasive interstitial-fluid glucose monitoring system (physical object)"
* compose.include[0].concept[+].code = #702203005
* compose.include[0].concept[=].display = "Invasive interstitial fluid glucose monitoring/insulin infusion system (physical object)"
* compose.include[0].concept[+].code = #463729000
* compose.include[0].concept[=].display = "Point-of-care blood glucose continuous monitoring system (physical object)"
* compose.include[0].concept[+].code = #701750003
* compose.include[0].concept[=].display = "Subcutaneous glucose sensor (physical object)"
* compose.include[0].concept[+].code = #70665002
* compose.include[0].concept[=].display = "Blood pressure cuff, device (physical object)"
* compose.include[0].concept[+].code = #334990001
* compose.include[0].concept[=].display = "Peak flow meter (physical object)"
* compose.include[0].concept[+].code = #303501006
* compose.include[0].concept[=].display = "Spirometer (physical object)"