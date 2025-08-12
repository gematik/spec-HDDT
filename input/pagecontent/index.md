# Implementation Guide – vibW Blutzucker

Dieser Implementation Guide beschreibt die technische und semantische Umsetzung für die Bereitstellung von Vitalwerten (vibW) am Beispiel **Blutzucker** nach §374a SGB V.

## Ziele
- Einheitliche Profile und ValueSets für die Interoperabilität zwischen Hilfsmitteln (HiMi) und digitalen Gesundheitsanwendungen (DiGA).
- Verbindliche Codes (LOINC, UCUM) für Messwerte und Einheiten.
- Vollständige Rückverfolgbarkeit zwischen Messwert, Gerätekonfiguration und Gerät.

## Architektur
Die Bereitstellung der Blutzuckerwerte erfolgt über die FHIR-Resource **Observation**.  
Diese enthält Referenzen auf die **DeviceMetric** (Gerätekonfiguration) und **Device** (Geräteinstanz).  
Zusätzlich werden **ValueSets** definiert, die bestimmen:
- Welche Messwerte (LOINC) gültig sind.
- Welche Einheiten (UCUM) zulässig sind.

