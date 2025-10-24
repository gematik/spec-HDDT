Medical aids and implants often can measure various kinds of data, depending from the kind of device and the concrete product. Not all of this data can be considered by mid 2027 when § 347a SGB V comes into effect. Therefore an assessment on typical use cases within prioritized domains was conducted in order to discover the kinds of data that are especially relevant for care scenarios which can be supported by DIGA (see chapter on [Methodology](methodology.html)). 

This page lists these __Mandatory Interoperable Values (MIVs)__ for the domains that have been assessed so far.


### Domain: Diabetes Self-Management

Self-management tools used by patients to determine glucose levels analyze either capillary blood ("bloody measurement" on the fingertip) or interstitial fluid (e.g. measurements performed through real-time Continuous Glucose Monitoring (rtCGM)). Other measurement methods - e.g. using aterial blood - are primarily used in the doctor's office and are not taken into account for the HDDT Usecase "Diabetes Self-Management". 

<figure>
<div class="gem-ig-svg-container">
 <img src="11073 Glukose Methoden.png" alt="Glucose Methods" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Glucose Methods; red boxes signal MIVs covered by this specification</em></figcaption>
</figure>
<br clear="all"/>

For the initial specification (version 1) of HDDT, two mandatory interoperable values (MIVs) are defined for diabetes self-management:
* Blood Glucose Measurement: values measured from (capillary) blood that provide a high accuracy for therapeutical decision making
* Continuous Glucose Measurement: values continuously measured, e.g. by real-time Continuous Glucose Monitoring devices (rtCGM) from intersitial fluid (ISF) that provide a high density of values over a long period of time and are used to derive key metrics for therapy monitoring and to detect dependencies between a patient's individual habits and behaviors and his glucose level.

The table below lists typical use cases and certification relevant systems for these MIVs.

| MIV                            | examples of typical use cases | examples of certification relevant systems  |
|--------------------------------|-------------------------------|---------------------------------------------|
| Blood Glucose Measurement      | • monitoring of patients with a combination of basal insulin with oral antidiabetic drugs<br> • diabetes diary for DMT2 patients  | • blood glucose meter (glucometer) |
| Continuous Glucose Measurement | • supporting patients in flattening glucose curves<br> • analyzing behavioral effects on glucose level<br> • gathering key metrics for measuring the status of the diabetes therapy<br> • analyzing hidden hypoglycaemias | • real-time Contiuous Clucose Monitoring (rtCGM)<br> • Closed Loop Systems |

#### Blood Glucose Value
The MIV _Blood Glucose Measurement_ covers values from "bloody measurements" using capillary blood from the finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc (e.g. a patient feeling dim what may be an indicator for a hypoglycamia). Values are very acurate and therefore best suited for therapeutical decision making. 

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Blood Glucose Measurement_ is defined by the FHIR ValueSet [_Blood Glucose Measurement from LOINC_](ValueSet-hddt-miv-blood-glucose-measurement.html).<br>This ValueSet contains LOINC codes for blood glucose measurements using blood or plasma as reference methods with the values provided as mass/volume and moles/volume. In addition more granular LOINC codes for "Glucose in Capillary blood by Glucometer" provided as mass/volume and moles/volume are included with the value set because these codes are already in use by several manufacturers of glucometers. |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-glucose-measurement<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
| __FHIR Observation Profile__  | Device Data Recorders provide _Blood Glucose Measurement_ to DiGA using the MIV-specific Observation Profile [__HDDT Blood Glucose Measurement__](StructureDefinition-hddt-blood-glucose-measurement.html). This profile allows to share a set of blood glucose values as single FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. |
| __FHIR Interactions__ | Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-blood-glucose.html). |
| __Aggregated Data__ | By now there are no aggregated data defined for the MIV "Blood Glucose Measurement". |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Blood Glucose Measurement_ data MUST make the measured values retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Blood Glucose Measurement_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
| __`Chunk-Time-Span`__ | _not applicable_ |
|  |   | 

#### Continuous Glucose Measurement
The MIV _Continuous Glucose Measurement_ covers values from continuous monitoring of the glucose level, e.g. by rtCGM in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to one value per minute. By this _Continuous Glucose Measurement_ can e.g. be used to assess dependencies between a patient's individual habits and behaviours and his glucose level. Due to the high density of values over a long period of time, many key metrics can be calculated from _Continuous Glucose Measurement_ which help the patient and his doctor to easily capture the status of the patient's health and therapy.

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Continuous Glucose Measurement_ is defined by the FHIR ValueSet [_Continuous Glucose Measurement from LOINC_](ValueSet-hddt-miv-continuous-glucose-measurement.html).<br>This ValueSet includes codes relevant to continuous glucose monitoring (CGM) of ISF glucose, considering mass/volume and moles/volume as commonly used units. In the future codes defining non-invasive glucose measuring methods may be added to this value set. |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
|__FHIR Observation Profile__ | Device Data Recorders provide _Continuous Glucose Measurement_ to DiGA using the MIV-specific Observation Profile [__HDDT Continuous Glucose Measurement__](StructureDefinition-hddt-continuous-glucose-measurement.html). This profile allows to share sampled glucose values as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Each resource holds multiple values while the time stamp of each value can be determined by the time stamp of the first value and the fixed sample rate. |
|__FHIR Interactions__ | Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-tissue-glucose.html). |
| __Aggregated Data__ | As stated above, _Continuous Glucose Measurement_ sampled data are a basis for many key metrics used in diabetes therapy monitoring, e.g. times in ranges (e.g. times in hypoglycemia and hyperglycemia) and Glucose Management Index (GMI).<br>Device Data Recorders MUST provide the structured, coded part of the _HL7 CGM Summary Report_ to DiGA using the MIV-specific Profile [__HDDT CGM Summary Report__](measurement-tissue-glucose.html). This profile allows to share a well defined set of relevant key metrics as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Access to the summary report is provided through the FHIR operation [$hddt-cgm-summary](OperationDefinition-hddt-cgm-summary-operation.html). |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Continuous Glucose Measurement_ data MUST make the measured values and aggregated key metrics (per _CGM Summary Report_) retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Continuous Glucose Measurement_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
| __`Chunk-Time-Span`__ | The _Chunk-Time-Span_ depends on the sample rate of the personal health device. Chunks of sampled data SHOULD be sized to hold between 200 and 2000 single data points. |
|  |   |


### Domain: Respiratory Monitoring
MIVS for this domain are expected to be published by November 2025.

### Domain: Simple Cardiac Monitoring
MIVS for this domain are expected to be published by November 2025.
