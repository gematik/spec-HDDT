Medical aids and implants often can measure various kinds of data, depending from the kind of device and the concrete product. Not all of this data can be considered by mid 2027 when § 374a SGB V comes into effect. Therefore an assessment on typical use cases within prioritized domains was conducted in order to discover the kinds of data that are especially relevant for care scenarios which can be supported by DiGA (see chapter on [Methodology](methodology.html)). 

This page lists these __Mandatory Interoperable Values (MIVs)__ for the domains that have been assessed so far. Each MIV is described by a structured profile in table form that contains all relevant references for implementers of Device Data Recorders and DiGA.:

| | |
|--|--| 
|__Defining ValueSet__ | Each MIV is defined by a FHIR ValueSet which is referenced in the MIV profile as the defining value set. This ValueSet contains the LOINC codes for the data that implement the MIV. In order to implement the MIV, a DiGA MUST be able to process at least one of these LOINC codes. In order to implement the MIV, a Device Data Recorder MUST be able to provide data that complies at least to one of these LOINC codes.  |
| __SMART Scopes__ | DiGA are only allowed to retrieve data elements explicitly covered by the granted [SMART scopes](smart-scopes.html). These scopes are defined per MIV and listed here. |
| __FHIR Observation Profile__  | Device Data Recorders provide measured data as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Each MIV is bound to one or more FHIR resource profiles that define the structure and semantics of the provided resources. The Observation profiles that are defined for the specific MIV are listed in this row of the MIV profile table. |
| __FHIR Interactions__ | Access to the resources is given through standard FHIR _read_ and _search_ RESTful interactions and - if the MIV covers aggregated data - FHIR operations. These interactions and operations are described per MIV including MIV-specific examples. A reference to this description is given here. |
| __Aggregated Data__ | Data from a MIV's measured data may be aggregated as a standardized report. If such a report is defined for a specific MIV, a reference to the respective FHIR specification is given here. |
| __Vendor Holdup__ | The _Vendor Holdup_ defines the maximum acceptable delay between data availability in the Health Record and data availability through the HDDT interface. The _Vendor Holdup_ is given in seconds delay and defined per MIV based on the MIV-specific use cases. E.g. if a _Vendor Holdup_ of 60 seconds is defined for a MIV, the Device Data Recorder MUST be able to provide the measured data to a DiGA at last 60 seconds after he received that data from the Personal Health Device through the device's Personal Health Gateway. |
| __`Historic-Data-Period`__ | The `Historic Data Period` defines the period for which a Device Data Recorder MUST be able to provide data back into the past. The `Historic Data Period` is defined by the Device Data Recorder per MIV. A DiGA can retrive the specific value for a given Device Data Recorder and MIV through the BfArM [HIIS-VZ](registries-and-zts.html#hiis-vz) API. This row of the MIV profile defines the __minimum__ acceptable value for the `Historic Data Period` for the given MIV. E.g. if a `Historic Data Period` of 30 days is given in the MIV profile, a Device Data Recorder MUST be able to serve a request for data that was measured 30 days ago. Nevertheless, a Device Data Recorder can define its MIV-specific `Historic Data Period` to 60 days to signal connecting DiGA that they may even obtain data which is 7 weeks old. But in the given example, the Device Data Recorder would not be allowed to set its `Historic Data Period` value to 14 days, because the acceptable minimum is defined as 30 days for the MIV. |
| __`Grace-Period`__ | A DiGA may request data from a Device Data Recorder at any time. However, to avoid overload situations on the Device Data Recorder side, a `Grace Period` is defined per MIV. This `Grace Period` defines the minimum time span that a DiGA MUST wait after a previous request for data from the same patient before a new request for data from that patient can be sent to the Device Data Recorder. If a DiGA sends a request for data from a patient before the `Grace Period` has elapsed since the last request for that patient, the Device Data Recorder MAY reject the new request. The `Grace Period` is defined by the Device Data Recorder per MIV. A DiGA can retrive the specific value for a given Device Data Recorder and MIV through the BfArM [HIIS-VZ](registries-and-zts.html#hiis-vz) API. This row of the MIV profile defines the __maximum__ acceptable value for the `Grace Period` for the given MIV. E.g. if a `Grace Period` of 60 minutes is given in the MIV profile, a Device Data Recorder MUST be able to serve requests from a DiGA for a certain patient's data with a frequency of one request per hour. Nevertheless, a Device Data Recorder can define its MIV-specific `Grace Period` to a lower value, e.g. 10 minutes in this example, to signal connecting DiGA that they may even obtain data with higher frequency. But in the given example, the Device Data Recorder would not be allowed to set its `Grace Period` value to 120 minutes, because the acceptable maximum is defined as 60 minutes for the MIV. | 
|  |   | 

### Domain: Diabetes Self-Management

Self-management tools used by patients to determine glucose levels analyze either capillary blood ("bloody measurement" on the fingertip) or interstitial fluid (e.g. measurements performed through real-time Continuous Glucose Monitoring (rtCGM)). Other measurement methods - e.g. using arterial blood - are primarily used in the doctor's office and are not taken into account for the HDDT Usecase "Diabetes Self-Management". 

<figure>
<div class="gem-ig-svg-container">
 <img src="11073 Glukose Methoden.png" alt="Glucose Methods" width="60%">
  </div>
    <figcaption><em><strong>Figure: </strong>Glucose Methods; red boxes signal MIVs covered by this specification</em></figcaption>
</figure>
<br clear="all"/>

For the initial specification (version 1) of HDDT, two mandatory interoperable values (MIVs) are defined for diabetes self-management:
* Blood Glucose Measurement: values measured from (capillary) blood that provide a high accuracy for therapeutical decision making
* Continuous Glucose Measurement: values continuously measured, e.g. by real-time Continuous Glucose Monitoring devices (rtCGM) from interstitial fluid (ISF) that provide a high density of values over a long period of time and are used to derive clinical metrics for therapy monitoring and to detect dependencies between a patient's individual habits and behaviors and his glucose level.

The table below lists typical use cases and certification relevant systems for these MIVs.

| MIV                            | examples of typical use cases | examples of certification relevant systems  |
|--------------------------------|-------------------------------|---------------------------------------------|
| Blood Glucose Measurement      | • monitoring of patients with a combination of basal insulin with oral antidiabetic drugs<br> • diabetes diary for DMT2 patients  | • blood glucose meter (glucometer) |
| Continuous Glucose Measurement | • supporting patients in flattening glucose curves<br> • analyzing behavioral effects on glucose level<br> • gathering clinical metrics for measuring the status of the diabetes therapy<br> • analyzing hidden hypoglycaemias | • real-time Continuous Glucose Monitoring (rtCGM)<br> • Closed Loop Systems |

#### MIV: Blood Glucose Value
The MIV _Blood Glucose Measurement_ covers values from "bloody measurements" using capillary blood from the finger tip. Measurements are performed based on a care plan (e.g. measuring blood sugar before each meal) or ad hoc (e.g. a patient feeling dim what may be an indicator for a hypoglycamia). Values are very accurate and therefore best suited for therapeutical decision making. 

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Blood Glucose Measurement_ is defined by the FHIR ValueSet [_Blood Glucose Measurement from LOINC_](ValueSet-hddt-miv-blood-glucose-measurement.html).<br>This ValueSet contains LOINC codes for blood glucose measurements using blood or plasma as reference methods with the values provided as mass/volume and moles/volume. In addition more granular LOINC codes for "Glucose in Capillary blood by Glucometer" provided as mass/volume and moles/volume are included with the value set because these codes are already in use by several manufacturers of glucometers. |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-glucose-measurement<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
| __FHIR Observation Profile__  | Device Data Recorders provide _Blood Glucose Measurement_ to DiGA using the MIV-specific Observation Profile [__HDDT Blood Glucose Measurement__](StructureDefinition-hddt-blood-glucose-measurement.html). This profile allows to capture a single blood glucose value as a FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource. |
| __FHIR Interactions__ | Access to the resources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-blood-glucose.html). |
| __Aggregated Data__ | By now there are no aggregated data defined for the MIV "Blood Glucose Measurement". |
| __Vendor Holdup__ | The maximum acceptable delay between data availability in the Health Record and data availability through the HDDT interface is __60 seconds__. |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Blood Glucose Measurement_ data MUST make the measured values retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Blood Glucose Measurement_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
|  |   | 

#### MIV: Continuous Glucose Measurement
The MIV _Continuous Glucose Measurement_ covers values from continuous monitoring of the glucose level, e.g. by rtCGM in interstitial fluid (ISF). Measurements are performed through sensors with a sample rate of up to one value per minute. By this _Continuous Glucose Measurement_ can e.g. be used to assess dependencies between a patient's individual habits and behaviours and his glucose level. Due to the high density of values over a long period of time, many clinical metrics can be calculated from _Continuous Glucose Measurement_ which help the patient and his doctor to easily capture the status of the patient's health and therapy.

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Continuous Glucose Measurement_ is defined by the FHIR ValueSet [_Continuous Glucose Measurement from LOINC_](ValueSet-hddt-miv-continuous-glucose-measurement.html).<br>This ValueSet includes codes relevant to continuous glucose monitoring (CGM) of ISF glucose, considering mass/volume and moles/volume as commonly used units. In the future codes defining non-invasive glucose measuring methods may be added to this value set. |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-continuous-glucose-measurement<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
|__FHIR Observation Profile__ | Device Data Recorders provide _Continuous Glucose Measurement_ to DiGA using the MIV-specific Observation Profile [__HDDT Continuous Glucose Measurement__](StructureDefinition-hddt-continuous-glucose-measurement.html). This profile allows to share sampled glucose values as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Each resource holds multiple values while the time stamp of each value can be determined by the time stamp of the first value and the fixed sample rate. |
|__FHIR Interactions__ | Access to the resources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-tissue-glucose.html). |
| __Aggregated Data__ | As stated above, _Continuous Glucose Measurement_ sampled data are a basis for many clinical metrics used in diabetes therapy monitoring, e.g. times in ranges (e.g. times in hypoglycemia and hyperglycemia) and Glucose Management Index (GMI).<br>Device Data Recorders MUST provide the structured, coded part of the _HL7 CGM Summary Report_ to DiGA using the MIV-specific Profile [__HDDT CGM Summary Report__](measurement-tissue-glucose.html). This profile allows to share a well defined set of relevant clinical metrics as FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources. Access to the summary report is provided through the FHIR operation [$hddt-cgm-summary](OperationDefinition-hddt-cgm-summary-operation.html). |
| __Vendor Holdup__ | The maximum acceptable delay between data availability in the Health Record and data availability through the HDDT interface is __15 minutes__. |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Continuous Glucose Measurement_ data MUST make the measured values and aggregated clinical metrics (per _CGM Summary Report_) retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Continuous Glucose Measurement_ if the previous request for that patient was answered less than __15 minutes__ ago. | 
|  |   |


### Domain: Lung Function Testing
In Germany, more than ten million people live with chronic lung and respiratory diseases, which significantly affect their quality of life. The most common conditions include bronchial asthma, chronic obstructive pulmonary disease (COPD), and obstructive sleep apnea syndrome (OSAS or simply sleep apnea). These conditions often require continuous monitoring and therapy. This is where aids such as peak flow meters for lung function measurement come in, allowing those affected to have more control over their condition and improving the quality of treatment.

For the initial specification (version 1) of HDDT, one mandatory interoperable value (MIV) is defined for lung function testing:
* Lung Function Testing: values measured using peak flow meters or spirometers to monitor lung function in patients with (chronic) respiratory diseases.

The table below lists typical use cases and certification relevant systems for this MIV:

| MIV                            | examples of typical use cases | examples of certification relevant systems  |
|--------------------------------|-------------------------------|---------------------------------------------|
| Lung Function Testing          | • DiGA to support treatment of asthma bronciale<br>• DiGA for compliance monitoring | • peak flow meter<br>• spirometer |

#### MIV: Lung Function Testing
The MIV _Lung Function Testing_ covers values from measurements using peak flow meters or spirometers to monitor lung function in patients with (chronic) respiratory diseases. Measurements are performed based on a care plan (e.g. measuring peak expiratory flow (PEF) in the morning and evening) or ad hoc (e.g. a patient experiencing breathing difficulties). 
 
| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Lung Function Testing_ is defined by the FHIR ValueSet [_Lung Function Testing_](ValueSet-hddt-miv-lung-function-testing.html).<br>This ValueSet contains LOINC codes for individual lung function testings (PEF and FEV1), LOINC codes for associated lung function reference values (e.g. personal best), and LOINC codes for relative lung function values, calculated in percentages (e.g. PEF relative to a reference value). |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-lung-function-testing<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
| __FHIR Observation Profile__  | Device Data Recorders provide _Lung Function Testing_ related measurements and derived values to DiGA using the MIV-specific Observation Profiles [__HDDT Lung Function Testing__](StructureDefinition-hddt-lung-function-testing.html), [__HDDT Lung Function Reference Value__](StructureDefinition-hddt-lung-reference-value.html), and [__HDDT Lung Function Testing Complete__](StructureDefinition-hddt-lung-function-testing-complete.html). |
| __FHIR Interactions__ | Access to these resources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-lung-function.html). |
| __Aggregated Data__ | By now there are no aggregated reports defined for the MIV "Lung Function Testing". |
| __Vendor Holdup__ | The maximum acceptable delay between data availability in the Health Record and data availability through the HDDT interface is __60 seconds__. |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Lung Function Testing_ data MUST make the measured values retrievable for at least __14 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Lung Function Testing_ data if the previous request for that patient was answered less than __15 minutes__ ago. | 
|  |   | 

### Domain: Blood Pressure Monitoring
Independent monitoring of blood pressure by the patient can be essential in several cases. After serious cardiac events such as a heart attack, blood pressure needs to be monitored, as it can provide information about important risk factors such as hypertension. Uncontrolled blood pressure can contribute to a repeat heart attack or heart failure. When treating with blood pressure-lowering medications, such as ACE inhibitors, regular monitoring is crucial to avoid both over- and under-treatment, which can lead to kidney damage or circulatory problems. Studies indicate that a systolic blood pressure below 120 mmHg in patients with chronic kidney disease is associated with lower mortality, fewer severe cardiovascular events, and the 
preservation of cognitive functions.

Typically, blood pressure is measured using a non-invasive method, usually by inflating a cuff on the upper arm. The cuff is inflated above the systolic blood pressure, completely occluding the artery. As the cuff pressure is slowly released and falls below the systolic pressure, the heart begins to pump blood into the partially compressed artery. The pumping of the blood causes minimal pressure fluctuations within the cuff. The amplitude of these pressure fluctuations can then be used to determine the systolic and diastolic blood pressure values through various methods. 

Another non-invasive method is measuring volume changes in the vascular system via an optical interface (photoplethysmography). Currently, these optical methods are not reimbursable under the statutory health insurance (GKV) and therefore are not covered under § 374a SGB V, and thus are not considered here.

For the initial specification (version 1) of HDDT, one mandatory interoperable value (MIV) is defined for blood pressure monitoring:
* Blood Pressure Monitoring: values measured at home by the patient using a blood pressure cuff.

The table below lists typical use cases and certification relevant systems for this MIV:

| MIV                            | examples of typical use cases | examples of certification relevant systems  |
|--------------------------------|-------------------------------|---------------------------------------------|
| Blood Pressure Monitoring      | • Preeclampsia prevention in pregnancies<br>• Recording of blood pressure before a doctor's visit<br>• Monitoring blood pressure alongside medication    | • blood pressure cuff |

#### MIV: Blood Pressure Value
The MIV _Blood Pressure Value_ covers values from measurements using a blood pressure cuff at home

| | |
|--|--| 
|__Defining ValueSet__ | The MIV _Blood Pressure Value_ is defined by the FHIR ValueSet [_Blood Pressure Value from LOINC_](ValueSet-hddt-miv-blood-pressure-value.html).<br>This ValueSet contains LOINC codes for blood pressure measurements using a blood pressure cuff. The cuff may be placed at the upper arm or above the wrist. Different LOINC codes indicate whether blood pressure was measured using an oscillometric method, an auscultatory method, or a combination of both methods. |
| __SMART Scopes__ |  patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-pressure-value<br>&nbsp;<br>patient/Device.rs<br>&nbsp;<br>patient/DeviceMetric.rs|
| __FHIR Observation Profile__  | Device Data Recorders provide _Blood Pressure Values_ to DiGA using the MIV-specific Observation Profile [__HDDT Blood Pressure Value__](StructureDefinition-hddt-blood-pressure-value.html). This profile allows to capture systolic, diastolic and mean arterial blood pressure values as a single FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource. |
| __FHIR Interactions__ | Access to the resources is given through standard FHIR _read_ and _search_ RESTful interactions as described in the [MIV-specific API](measurement-blood-pressure.html). |
| __Aggregated Data__ | By now there are no aggregated data defined for the MIV "Blood Pressure Value". |
| __Vendor Holdup__ | The maximum acceptable delay between data availability in the Health Record and data availability through the HDDT interface is __60 seconds__. |
| __`Historic-Data-Period`__ | Device Data Recorders that provide _Blood Pressure Values_ MUST make the measured values retrievable for at least __30 days__.  |
| __`Grace-Period`__ | A Device Data Recorder MAY reject a DiGA's request for a patient's _Blood Pressure Values_ if the previous request for that patient was answered less than __5 minutes__ ago. | 
|  |   | 