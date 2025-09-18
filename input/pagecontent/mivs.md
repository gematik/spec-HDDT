
Self-management tools used by patients to determine glucose levels analyze either capillary blood ("bloody measurement" on the fingertip) or interstitial fluid (e.g. measurements performed through realt-time Continuous Glucose Monitoring (rtCGM)). In the following table from ISO/IEEE 11073-10425:2019, these measurement methods are highlighted in red. The other measurement methods listed are primarily used in the doctor's office and are not taken into account for the HDDT Usecase "Diabetes Self-Management".

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

### Blood Glucose Value
The MIV _Blood Glucose Value_ covers values from "bloody measurments" using capillary blood from the finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc (e.g. a patient feeling dim what may be an indicator for a hypoglycamia). Values are very acurate and therefore best suited for therapeutical decision making. 

#### Defining ValueSet
The MIV _Blood Glucose Value_ is defied by the FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) [__GEM_HDC_VS_Blood_Glucose__](https://gematik.de/fhir/hdc/ValueSet/VS-Blood-Glucose). 

This ValueSet contains LOINC codes for blood glucose measurements using blood or plasma as reference methods with the values provided as mass/volume and moles/volume. In addition more granular LOINC codes for "Glucose in Capillary blood by Glucometer" provided as mass/volume and moles/volume are included with the value set because these codes are recently used by several manufacturers of glucometers for sharing blood sugar values. 

#### HDDT FHIR Observation Profile and API
Health Data Recorders provide _Blood Glucose Values_ to DiGA using the MIV-specific Observation Profile [__Blood Glucose Measurement__](measurement-blood-glucose.html). This profile allows to share a set of blood glucose values as single FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in [Retrieving Data](retrieving-data.html#querying-for-device-data).

#### Aggregated and Derived Data
By now there are no aggregated or derived data defined for the MIV "Blood Glucose Value".

### ISF Glucose Sampled Value
The MIV _ISF Glucose Sampled Value_ covers values from continuous monitoring of the glucose level in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to one value per minute. By this _ISF Glucose Sampled Values_ can e.g. be used to assess dependencies between a patient's individual habits and behavious and his glucose level. Due to the high density of values over a long period of time, many key figures can be derived from _ISF Glucose Sampled Values_ which help the patient and his doctor to easily capture the status of the patient's health and therapy.

#### Defining ValueSet
The MIV _ISF Glucose Sampled Value_ is defined by the FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) [__GEM_HDC_VS_Tissue_Glucose_CGM__](https://gematik.de/fhir/hdc/ValueSet/VS-Tissue-Glucose-CGM).

This ValueSet includes codes relevant to continuous glucose monitoring (CGM) of ISF glucose, considering mass/volume and moles/volume as commonly used units.

#### HDDT FHIR Observation Profile
Health Data Recorders provide _ISF Glucose Sampled Value_ to DiGA using the MIV-specific Observation Profile [__ISF Glucose Measurement__](measurement-tissue-glucose.html). This profile allows to share sampled ISF glucose values as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Each resource holds multiple values while the time stamp of each value can be determined by the time stamp of the first value and the fixed sample rate. Access to the ressources is given through standard FHIR _read_ and _search_ RESTful interactions as described in [Retrieving Data](retrieving-data.html#querying-for-device-data).

#### Aggregated Report: CGM Summary
As stated above, _ISF Glucose Sampled Values_ are a basis for many key figures used in diabetes therapy monitoring, such as:
* times in ranges (e.g. times in hypoglycemia and hyperglycemia) including %TIR as a potential substitute for the HbA1c laboratory value 
* Glucose Management Index (GMI)
* 


