Medical aids and implants often can measure various kinds of data, depending from the kind of device and the concrete product. Not all of this data can be considered by mid 2027 when § 347a SGB V comes into effect. Therefore an assessment on typical use cases within prioritized domains was conducted in order to discover the kinds of data that are especially relevant for care scenarios which can be supported by DIGA (see chapter on [Methodology](methodology.html)). 

This page lists these __Mandatory Interoperable Values (MIVs)__ for the domains that have been assessed so far.


### Domain: Diabetes Self-Management

Self-management tools used by patients to determine glucose levels analyze either capillary blood ("bloody measurement" on the fingertip) or interstitial fluid (e.g. measurements performed through real-time Continuous Glucose Monitoring (rtCGM)). In the following table from ISO/IEEE 11073-10425:2019, these measurement methods are highlighted in red. The other measurement methods listed are primarily used in the doctor's office and are not taken into account for the HDDT Usecase "Diabetes Self-Management".

<div><img src="/11073_Glukose_Methoden.png" alt="Glucose Methods" width="60%"></div>
<br clear="all"/>

For the first introduction stage of HDDT, two mandatory interoperable values (MIVs) are defined for diabetes self-management:
* Blood Glucose Value: values measured from capillary blood using bloodor plasma as the reference method
* ISF Glucose Sampled Value: values continuously measured from intersitial fluid (ISF) 

The table below lists typical use cases and certification relevant systems for these MIVs.

| MIV                       | examples of typical use cases | examples of certification relevant systems  |
|---------------------------|-------------------------------|---------------------------------------------|
| Blood Glucose Value       | • monitoring of BOT patients<br> • diabetes diary for DMT2 patients  | • blood glucose meter (glucometer) |
| ISF Glucose Sampled Value | • supporting patients in flattening glucose curves<br> • analyzing behavioural effects on glucose level<br> • gathering key figures for online appointments<br> • analyzing hidden hypoglycaemias | • real-time Contiuous Clucose Monitoring (rtCGM)<br> • Closed Loop Systems |

#### Blood Glucose Value
The MIV _Blood Glucose Value_ covers values from "bloody measurments" using capillary blood from the finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc (e.g. a patient feeling dim what may be an indicator for a hypoglycamia). Values are very acurate and therefore best suited for therapeutical decision making. 

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Blood Glucose Value_ is defined by the FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) [__GEM_HDC_VS_Blood_Glucose__](https://gematik.de/fhir/hdc/ValueSet/VS-Blood-Glucose).<br>This ValueSet contains LOINC codes for blood glucose measurements using blood or plasma as reference methods with the values provided as mass/volume and moles/volume. In addition more granular LOINC codes for "Glucose in Capillary blood by Glucometer" provided as mass/volume and moles/volume are included with the value set because these codes are recently used by several manufacturers of glucometers for sharing blood sugar values. |
| __FHIR Observation Profile__  | Health Data Recorders provide _Blood Glucose Values_ to DiGA using the MIV-specific Observation Profile [__Blood Glucose Measurement__](measurement-blood-glucose.html). This profile allows to share a set of blood glucose values as single FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. |
| __FHIR Interactions__ | Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in [Retrieving Data](retrieving-data.html#querying-for-device-data). |
| __Aggregated and Derived Data__ | By now there are no aggregated or derived data defined for the MIV "Blood Glucose Value". |
| __`Historic-Data-Period`__ | Device data recorders that that provide _Blood Glucose Values_ MUST make the measured values retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A device data recorder MAY reject a DiGA's request for a patient's _Blood Glucose Value_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
| __`Chunk-Time-Span`__ | _not applicable_ |
|  |   | 

#### ISF Glucose Sampled Value
The MIV _ISF Glucose Sampled Value_ covers values from continuous monitoring of the glucose level in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to one value per minute. By this _ISF Glucose Sampled Values_ can e.g. be used to assess dependencies between a patient's individual habits and behavious and his glucose level. Due to the high density of values over a long period of time, many key figures can be derived from _ISF Glucose Sampled Values_ which help the patient and his doctor to easily capture the status of the patient's health and therapy.

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _ISF Glucose Sampled Value_ is defined by the FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) [__GEM_HDC_VS_Tissue_Glucose_CGM__](https://gematik.de/fhir/hdc/ValueSet/VS-Tissue-Glucose-CGM).<br>This ValueSet includes codes relevant to continuous glucose monitoring (CGM) of ISF glucose, considering mass/volume and moles/volume as commonly used units. |
|__FHIR Observation Profile__ | Health Data Recorders provide _ISF Glucose Sampled Value_ to DiGA using the MIV-specific Observation Profile [__ISF Glucose Measurement__](measurement-tissue-glucose.html). This profile allows to share sampled ISF glucose values as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Each resource holds multiple values while the time stamp of each value can be determined by the time stamp of the first value and the fixed sample rate. |
|__FHIR Interactions__ | Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in [Retrieving Data](retrieving-data.html#querying-for-device-data).|
| __Aggregated and Derived Data__ | As stated above, _ISF Glucose Sampled Values_ are a basis for many key figures used in diabetes therapy monitoring, e.g. times in ranges (e.g. times in hypoglycemia and hyperglycemia) and Glucose Management Index (GMI).<br>Health Data Recorders MUST provide the structured, coded part of the _HL7 CGM Summary Report_ to DiGA using the MIV-specific Profile [__HDDT CGM Summary Report__](measurement-tissue-glucose.html). This profile allows to share a well defined set of relevant key figures as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. 
| __`Historic-Data-Period`__ | Device data recorders that that provide _ISF Glucose Sampled Values_ MUST make the measured values and derived key figures (per _CGM Summary Report_) retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A device data recorder MAY reject a DiGA's request for a patient's _ISF Glucose Sampled Value_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
| __`Chunk-Time-Span`__ | The _Chunk-Time-Span_ depends on the sample rate of the personal health device. Chunks of sampled data SHOULD be sized to hold between 200 and 2000 single data points. |
|  |   |


### Domain: Respiratory Monitoring
MIVs for this domain will be published by November 2025.

### Domain: Simple Cardiac Monitoring
MIVs for this domain will be published by November 2025.
