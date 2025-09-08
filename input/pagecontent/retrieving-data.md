**ToDo**
* **hauptsächlich Jörg** - Beschreibt die verschiedene Arten Daten abzufragen
* Motivation und Anforderungen (Jie, Emil)
* grobe Ablaufbeschreibung (Jie, Emil)
* Sequenzdiagramme (Jie, Emil)

# Retrieving Device Data

In general, data can be measured in two different scenarios by personal health devices:
* dedicated measurements: scheduled by a defined care plan or triggered by an unscheduled event, the patient performs a measurement using a medical aid. The measurement takes a defined period of time and records single values for one or more data item (e.g. pulse and blood pressure). Typical examples of devices, which are used ad hoc or based on a care plan are blood glucose meters, smart insulin pens, blood pressure cuffs and peak flow meters.
* continuous measurements: The patient is connected to a sensor (almost) all the time and the sensor continuously measures and records data. Typical examples of devices that perform continuous measurements are rtCGM, insulin pumps and pace makers.

In addition, there are also devices and scenarios, which combine both paradigms, e.g.
* personal ECG recorders for recording short, single-channel ECGs based on a plan (e.g. patient is asked to perform a measurement after physical activity)
* pulse oximeters which are used ad hoc, but record data continuously for a certain period of time (e.g. monitoring SPO2 during sleep time of a person suffering from sleep apnea)

The HDDT FHIR API handles dedicated and continuous measurements in different ways. Which flavor of the API is to be used, is part of the FHIR implementation guide of a MIV. For combined scenarios usually the API flavor for continuous measurements is used, because it is much more efficient in transfering sampled data.

## General Query Parameters



## Ad Hoc Measurements

<div><img src="/HDDT measurement ad hoc example 1.png" alt="Blood glucose values for a day" width="60%"></div>
<br clear="all"/>

<div><img src="/HDDT measurement ad hoc example 2.png" alt="Blood glucose values including sensor calibration" width="60%"></div>
<br clear="all"/>

## Continuous Measurements