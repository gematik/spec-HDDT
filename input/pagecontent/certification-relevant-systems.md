
# Status: Pre-Final (Inhalt mit BMG abgestimmt)
* Verantwortlich: @jcaumann
* ToDo:
    * finale QS

# Certification Relevant Systems    
Via the interface according to § 374a SGB V, medical aids and implants must be able to pass on data to authorized DiGA if they are 
- distributed to insured persons at the expense of the statutory health insurance and 
- transmit the data about the insured person electronically to the manufacturer or third parties via publicly accessible networks. 

Examples of such aids and implants include rtCGM, insulin pumps and pacemakers. 
However, peak flow meters, blood glucose meters, blood pressure cuffs, pulse oximeters and other aids that are not necessarily perceived as digital by the patient also fall under § 374a SGB V, provided that they import the collected data into a back-end system. 

The interface itself MUST be offered via a backend system and is called by DiGA via the Internet.

## Building Blocks 

The present specification is based on the reference model of the Continua Health Alliance, which logically divides a medical device worn at, on or inside the patient into defined technical blocks.

<div><img src="/HDC_Medical_Aid_Decomposition.png" alt="reference model of the personal health device ecosystem" width="60%"></div>
<br clear="all"/>

The personal device is the hardware of the medical aid or implant and realizes the sensory recording of data on or in the patient. The data is transmitted via a local point-to-point connection to an aggregation manager, which validates the data, prepares it and, if necessary, merges it with other data. For most devices, the aggregation manager will be a mobile application on a smartphone or tablet, but it is not uncommon to have dedicated mobile controllers (e.g. in some insulin pumps), desktop systems or web portals (e.g. for wired data import) or set-top boxes (e.g. in implants). The data is transmitted to a background system via an Internet connection and persisted there in a health record. The HDC interface for data transmission to DIGA is based on the health record. Thus, only data that is available in the health record of a background system are affected by § 374a SGB V; data that is only processed in the Personal Health Device or the Aggregation Manager does not fall under § 374a SGB V and therefore must not be made available through the HDDC API.

## Relevant Systems

The necessary prerequisite for a medical aid or implant to fall under the regulations of § 374a SGB V is the financial viability of the aid or implant through the statutory health insurance (GKV). The aid or implant is considered to be financially viable under the statutory health insurance system if:
- it is listed in the list of medical aids of the GKV,
- it can be assigned to a product type defined in the list of medical aids of the GKV (7-digit number) or
- it is reimbursed within the framework of a contract pursuant to § 140a SGB V.

In addition, the aid or implant must have an interface through which the collected data is extracted and forwarded to a health record in a back-end system via an aggregation manager. 

These requirements lead to the division of the ecosystem of the aid into two subsystems outlined in the figure below.

<div><img src="/HDC_Medical_Aid_Subsystems.png" alt="subsystems of the personal health device ecosystem" width="60%"></div>
<br clear="all"/>

The responsibility for the implementation of the interface according to § 374a SGB V lies with the entity responsible for Subsystem-2, i.e. the Aggregation Manager and the Health Record. In the simplest case, the manufacturer of the aid or implant (subsystem-1) is also responsible for subsystem-2. If the aid meets the conditions mentioned, then the manufacturer MUST implement and operate the HDC interfaces on its backend system. This also applies if Subsystem-1 and Subsystem-2 are managed by different providers, if they both belong to the same parent company or if one of the providers is a subsidiary of the other provider.

___Example 1__: Manufacturer A offers a blood glucose meter. The aid is listed in the list of medical aids of the GKV and can export the collected data via a USB cable. Manufacturer A does not offer an aggregation manager itself, i.e. it does not support data storage in its own backend. However, manufacturer A has a subsidiary B that offers a desktop application for doctors to monitor and control the therapy of their diabetes patients. This application allows data to be read out of A's blood glucose meter via a USB cable and stored in a health record in the backend system of company B. In this case, company B is obliged to implement the HDC interface in order to enable DiGA to retrieve data from company A's glucose meter._

If both subsystems do not belong to the same vendor or group, the manufacturer responsible for subsystem 2 is only obliged to implement the HDC interface if subsystem 2 or one of the components contained therein is itself a medical aid that can be financed by the statutory health insurance system or is part of such an aid. The only exception to this rule is that Subsystem-2 is a DiGA or a component of a DiGA.  

___Example 2__: Manufacturer A offers an rtCGM that can also be coupled with an insulin pump in the context of an AID system. The rtCGM is listed in the list of aids of the GKV and can be connected to paired apps via Bluetooth LE and thus continuously transmit the measured data to this app. Manufacturer A offers an app for its rtCGM itself and stores the data in its own backend. Manufacturer A is therefore obliged to implement the HDC interface. However, if the rtCGM is used as part of an AID system, the rtCGM is not connected to A's app, but to the AID control app of the insulin pump manufacturer (manufacturer B). The app and insulin pump are listed as integrated aids in the list of aids of the GKV, i.e. they are reimbursed in the GKV. This means that the AID control app is part of an aid that can be financed by the GKV, which means that manufacturer B is obliged to implement the HDC interface in such a way that both the original data of the insulin pump and the data taken over from the rtCGM can be made available for DiGA._

<div><img src="/HDDT affected systems example 2.png" alt="Example 2" width="60%"></div>
<br clear="all"/>

___Example 3__: Manufacturer A offers an rtCGM. An unaffiliated manufacturer B offers a diabetes diary that can receive data from manufacturer A's rtCGM via a proprietary interface. The diabetes diary is not a DiGA and is not otherwise reimbursable in the statutory health insurance. Manufacturer B is not obliged to implement the HDC interface and cannot be listed in the HiMi-SST-VZ of the BfArM._

___Example 4__: Manufacturers A and B each offer an rtCGM. A manufacturer C that is not affiliated with A or B offers a diabetes diary as a DiGA that can receive data from the rtCGMs of manufacturers A and B via a proprietary interface. Manufacturer C is not obliged to implement the HDC interface. However, he must disclose the interface used (IOP criterion 3 in Annex 2 DiGAV) and take the received data into account in an appropriate form in his ePA export._

___Example 5__: Manufacturers A and B each offer an rtCGM. A manufacturer C that is not affiliated with A or B offers an rtCGM as well as a diabetes diary. The diabetes diary is a DiGA that can receive data from the rtCGMs of manufacturers A, B and C (i.e. its own product) via a proprietary interface. Manufacturer C is obliged to implement the HDC interface and to make the data received from its own rtCGM available to other DiGA via it. It does not have to be able to extract the data received from the rtCGMs of manufacturers A and B via the HDC interface. However, he must disclose the interface used to connect the rtCGM (IOP criterion 3 in Appendix 2 DiGAV) and take the data received from all three rtCGMs into account in an appropriate form in his ePA export._

