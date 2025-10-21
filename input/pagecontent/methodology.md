The range of medical aids and implants that could potentially be affected by § 374a SGB V is broad and diverse. It includes items such as blood pressure cuffs, blood glucose meters, real-time continuous glucose monitoring (rtCGM) devices, pacemakers, and neurostimulators.

In principle, different approaches are possible for specifying the FHIR interfaces used for data exchange between medical aids and DiGA (digital health applications acc. § 33a SGB V). These approaches range from defining a modular, device-independent toolkit of FHIR building blocks to creating specific FHIR implementation guides for each kind of medical aid.

The modular “toolkit” approach was discarded. Even though this approach provides a high degree of flexibility using only few rather generic FHIR profiles, giving responsibility for the assembly and further constraining of these building blocks to manufacturers may lead to incompatible resource definitions even for rather similar data sets (e.g. there are at least three different ways for giving provenance to a device data item): compliant data on the producers' side may not be interoperable for data consumers. On the other hand, device-specific implementation guides were also considered unsuitable. This is because they take the perspective of data producers as the standard, while the law clearly requires alignment with the intended purposes of DiGA as consumers of device data.

### From Use Cases to MIVs

To meet this legal requirement – namely, to design the interface according to the processing purposes of the device data consumers – the approach outlined in the following diagram was chosen.

<div><img src="/HDDT Methodik.png" alt="From Use Cases to MIVs" width="60%"></div>
<br clear="all"/>

In a first step, _gematik_ and the Federal Ministry of Health identified domains that seemed particularly relevant for data exchange between medical aids and DiGA. A domain can roughly be understood as an area of use or a care environment for existing and, above all, future DiGA.

The selection of domains to be prioritized considered prescription numbers of certain medical aids as well as the potential of DiGA to support therapy management from a patient's perspective. It was also important to initially choose domains that overlap with Disease Management Programs (DMP). Starting in 2027, the concept of “digital DMPs” will provide an innovation-friendly framework for the use of DiGA in the care of people with chronic diseases. Having access to device data will help to position innovative DiGA in this new regulatory environment.

The table below shows the domains and related DMP that have been chosen for the first set of FHIR guidelines.

| Domain                    | related DMP                                                         |
|---------------------------|---------------------------------------------------------------------|
| Diabetes Self-Management  | • Diabetes mellitus Typ 1<br>• Diabetes mellitus Typ 2              |
| Respiratory Monitoring    | • COPD<br>• Asthma bronchiale                                       |
| Simple Cardiac Monitoring | • Coronary Heart Disease<br>• Chronic Heart Failure<br>• Adipositas | 


For each domain, three aspects were analyzed: __medical aids__, __interoperable values__, and __use cases__. Each aspect was understood as a perspective from which the other two aspects could also be considered.
* __Medical aids__: Which medical aids and implants are typical for care in this domain? What kind of data do these medical aids and implants generate? In which situations are such aids usually prescribed by physicians? How do patients use them in everyday life?
* __Interoperable values__: Which data is typically processed in this domain? Where does this data come from? In which situations do physicians need it? How can this data also support patients in managing their health conditions and actively taking part in their therapy? How must the data be defined so that it can be exchanged as interoperable values?
* __Use cases__: Which care scenarios are typical for this domain? What added value could a DiGA provide in such scenarios? Which interoperable values would a DiGA need in order to generate these benefits?

Based on these analyses, the next step was to evaluate the interoperable values in terms of their contribution to the use cases and their relevance for the underlying care scenarios. It was considered which properties of the values are important for the use cases and how the various concrete data can be assigned to these values. From this, a manageable set of particularly relevant interoperable values was conceptually defined for each domain. These are called __"mandatory interoperable values" (MIVs)__. Every medical aid or implant that processes one or more MIVs is a potential [HDDT certification relevant system](certification-relevant-systems.html) that is obliged to implement the HDDT API for the provided MIVs.  

MIVs are "conceptually defined" through their properties and purposes within the context of typical DiGA device data processing scenarios. This kind of rather logical than technical definition  reflects the legal obligation from § 374a SGB V that a DiGA must only process device data if and only if this data is needed for the intended purposes of the DiGA. 

Example: _Blood Glucose Measurement_ and _Continuous Glucose Measurement_ are two different _MIVs_: While the first is measured ad hoc and usable for clinical decisions the second is measured continuously in interstitial fluid (ISF) and suitable for calculating key indicators for the status of the treatment (e.g. %TIR and GMI). These different properties and contexts of use are also reflected in the considered use cases, where a DiGA can typically make use of only one or the other MIV.

### From MIVs to APIs

Once a MIV is defined, a MIV-specific __HDDT Observation Profile__ is specified. This profile constrains the FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resource definition to match the requirements and specialties of the MIV. Measured values for MIVs are made available by the backend of a medical aid or implant through the standard FHIR RESTful `read` and `search` interactions. 

Some MIVs are the basis for aggregated or derived data. Such data is provided to DiGA as structured, standardized reports. Depending on the report's content and structure, a dedicated FHIR profile (e.g. based on [Observation](https://hl7.org/fhir/R4/observation.html) or [DiagnosticReport](https://hl7.org/fhir/R4/diagnosticreport.html) resource definitions) and a dedicated FHIR operation is defined for each report.

HDDT Observation Profiles and profiles for structured reports are managed by _gematik_ and made available as FHIR [StructureDefinition](https://hl7.org/fhir/R4/structuredefinition.html) resources. FHIR operations for fetching a structured report are defined using formal definitions of input parameters and possible results.  

Each MIV is expressed as a FHIR [ValueSet](https://hl7.org/fhir/R4/valueset.html) which is managed with the _ZTS_ (German Central Terminology Server). The LOINC codes within a MIV's ValueSet are the only values allowed for the `code` element that classifies an FHIR Observation resource that holds a measured value for the MIV. 

The figure below summarizes the interplay of MIV-specific FHIR profiles (yellow), MIV definitions (green) and measured MIV resources (light blue).

<div style="width: 50%;">
  <img src="assets/images/methodology_miv.svg" style="width: 100%;" />
</div>

### Defined MIVs

The table below lists the use cases, medical aids, and interoperable values that have been assessed so far. Interoperable values in fat letters are MIVs of the first specification stage (MVP). Medical aids in fat letters are devices that presumably are [certification relevant systems](certification-relevant-systems.html) with respect to the identified MIVs.

| Domain                    | Use Cases | Medical Aids                                                                         | Interoperable Values                                                                        |
|---------------------------|-----------|--------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------| 
| Diabetes Self-Management  |• DiGA for supporting the adaptation of basal insulin rate<br>• DiGA with digital diabetes diary<br>• DiGA for simple asynchronous telemonitoring<br>• DiGA for the prevention of glucose peeks<br>• DiGA for triggering alerts on critical measurements  | • __blood glucose meter__ <br> • __rtCGM__ <br> • smart pen <br> • insulin pump <br> | • __Blood Glucose Measurement__<br>• __Continuous Glucose Measurement__<br>• insulin intake |
| Respiratory Monitoring    | • DiGA to support treatment of asthma bronciale<br>• DiGA to support treatment of  sleep apnea  | • __peak flow meter__<br>• __spirometer__<br>• CPAP<br>• APAP                                | • __PEF__<br>• __FEV1__<br>• FVC<br>• FEV6, ...                                             |
| Simple Cardiac Monitoring | _to be defined_           | • __blood pressure cuff__<br>• scale                                                 | • __Blood Pressure__<br>• __Pulse__<br>• body weight                                        |
