# Status: Pre-Final
* Verantwortlich: @jcaumann
* ToDo:
    * QS (insb. Sprache)
    

# Methodology

The range of medical aids and implants that could potentially be affected by § 374a SGB V is broad and diverse. It includes items such as blood pressure cuffs, blood glucose meters, real-time continuous glucose monitoring (rtCGM) devices, pacemakers, and neurostimulators.

In principle, different approaches are possible for specifying the FHITR interfaces used for data exchange between medical devices and digital health applications (DiGA). These approaches range from defining a modular, device-independent set of FHIR building blocks to creating specific FHIR implementation guides for each device type.

The modular “building block” approach was discarded. Experience with the DiGA MIO Toolkit has shown that this kind of flexibility can negatively affect interoperability. On the other hand, device-specific implementation guides were also considered unsuitable. This is because they take the perspective of data producers as the standard, while the law clearly requires alignment with the intended purposes of DiGA as consumers of device data.

## From Use Cases to MIVs

To meet this legal requirement – namely, to design the interface according to the processing purposes of the device data consumers – the approach outlined in the following diagram was chosen.

<div><img src="/HDDT Methodik.png" alt="From Use Cases to MIVs" width="60%"></div>
<br clear="all"/>

In a first step, gematik and the Federal Ministry of Health identified domains that seemed particularly relevant for data exchange between medical devices and digital health applications (DiGA). A domain can roughly be understood as an area of use or a care environment for existing and, above all, future DiGA.

The selection of domains to be prioritized took into account prescription numbers of certain medical aids as well as the potential of DiGA to support therapy management from a patient's perspective. It was also important to initially choose domains that overlap with Disease Management Programs (DMP). Starting in 2027, the concept of “digital DMPs” will provide an innovation-friendly framework for the use of DiGA in the care of people with chronic illnesses. Having access to device data will help to position innovative DiGA in this new regulatory environment.

The table below shows the domains and related DMP that haven been chosen for the first set of FHIR guidelines.

| Domain                    | related DMP                                                         |
|---------------------------|---------------------------------------------------------------------|
| Diabetes Self-Management  | • Diabetes mellitus Typ 1<br>• Diabetes mellitus Typ 2              |
| Breath Therapy            | • COPD<br>• Asthma bronchiale                                       |
| Simple Cardiac Monitoring | • Coronary Heart Disease<br>• Chronic Heart Failure<br>• Adipositas | 


For each domain, three aspects were analyzed: __medical devices__, __interoperable values__, and __use cases__. Each aspect was understood as a perspective from which the other two aspects could also be considered.
* __Medical devices__: Which aids and implants are typical for care in this domain? What kind of data do these devices generate? In which situations are such devices usually prescribed by physicians? How do patients use them in everyday life?
* __Interoperable values__: Which data are typically processed in this domain? Where does this data come from? In which situations do physicians need it? How can this data also support patients in managing their condition and implementing therapy? How must the data be defined so that it can be exchanged as interoperable values?
* __Use cases__: Which care scenarios are typical for this domain? What added value can a DiGA provide in such scenarios? Which interoperable values does a DiGA need in order to generate these benefits?

Based on these analyses, the next step was to evaluate the interoperable values in terms of their contribution to the use cases and their relevance for the underlying care scenarios. It was considered which properties of the values are important for the use cases and how the various concrete data can be assigned to these values.From this, a manageable set of particularly relevant  interoperable values was conceptually defined for each domain. These are the values, which are mandatory to be provided by medical devices in order to implement § 374a SGB V (__"mandatory interoperable values", MIVs__)

MIVs are "conceptually defined" through their properties and purposes within the context of typical DiGA device data processing scenarios. This kind of rather logical than technical definition  reflects the legal obligation from § 374a SGB V that a DiGA must only process device data if and only if this data is needed for the intended purposes of the DiGA. 

Example: _Glucose in capillary Blood_ and _Glucose in interstitial fluid_ are two different _MIVs_: While the first is measured ad hoc and usable for clinical decisions the second is measured continuously and suitable for calculating key indicators for the status of the treatment (e.g. %TIR and GMI). These different properties and contexts of use are also reflected in the considered use cases, where a DiGA can typically make use of only one or the other MIV.

## Defined MIVs

The table below lists the use cases, medical aids, and interoperable values that have been assessed so far. Interoperable values in fat letters are MIVs. Medical aids in fat letters are devices that presumerably are certification relevant systems with respect to the identified MIVs.

| Domain                    | Use Cases | Medical Aids                                                                         | Interoperable Values                                                                        |
|---------------------------|-----------|--------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------| 
| Diabetes Self-Management  |           | • __blood glucose meter__ <br> • __rtCGM__ <br> • smart pen <br> • insulin pump <br> | • __glucose in capillary blood__<br>• __glucose in interstitial fluid__<br>• insulin intake |
| Breath Therapy            |           | • peak flow meter<br>• spirometer<br>• CPAP<br>• APAP                                | • __PEF__<br>• __FEV1__<br>• FVC<br>• FEV6, ...                                             |
| Simple Cardiac Monitoring |           | • __blood pressure cuff__<br>• scale                                                 | • __blood pressure__<br>• __pulse__<br>• body weight                                        |
