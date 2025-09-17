
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

#### HDDT FHIR Observation Profile

<div id="all-tbl-key-inner">
    {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot-by-key-all.xhtml%}
</div>

#### Aggregated and Derived Data
By now there are no aggregated or derived data defined for the MIV "Blood Glucose Value".

### ISF Glucose Sampled Value

#### Defining ValueSet
GEM_HDC_VS_Tissue_Glucose_CGM
This ValueSet includes codes relevant to continuous glucose monitoring (CGM) of tissue glucose, facilitating interoperability for CGM device data.

**ToDo**: Verlinkung https://gematik.de/fhir/hdc/ValueSet/VS-Tissue-Glucose-CGM

#### HDDT FHIR Observation Profile

#### Aggregated Report: CGM Summary

