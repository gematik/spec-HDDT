Via the interface according to § 374a SGB V, backend systems of medical aids and implants must be able to pass on data to authorized DiGA if they are 
- distributed to insured people at the expense of statutory health insurance and 
- transmit data about the insured person electronically to the manufacturer or third parties via publicly accessible networks. 

Examples of such medical aids and implants include rtCGM, insulin pumps and pacemakers. 
However, peak flow meters, blood glucose meters, blood pressure cuffs, pulse oximeters and other aids that are not necessarily perceived as digital by the patient also fall under § 374a SGB V, if they transfer the collected data to a backend system. 

§ 374a SGB V will be established stepwise in the German healthcare system. In a first implementation phase three domains (diabetes self-management, respiratory monitoring, simple cardiac monitoring) with selected Mandatory Interoperable Values (MIVs) are affected, while more will be elaborated in the future (see [Roadmap](roadmap.html) and [Methodology](methodology.html) for details).

### Building Blocks 

The definition of HDDT building blocks is based on the reference model of the [_Continua Health Alliance_](https://www.slideserve.com/kanoa/continua-health-alliance), which logically divides a medical aid worn at, on or inside the patient into defined technical blocks.

<div><img src="/HDC Medical Aid Decomposition.png" alt="reference model of the personal health device ecosystem" width="60%"></div>
<br clear="all"/>

The __Personal Health Device__ is the hardware of the medical aid or implant and realizes the sensory recording of data on or in the patient. The data is transmitted via a local point-to-point connection to an __Aggregation Manager__, which validates the data, prepares it and, if necessary, merges it with other data. For most devices, the Aggregation Manager will be a mobile application on a smartphone or tablet, but it is not uncommon to have dedicated mobile controllers (e.g. with some insulin pumps), desktop systems or web portals (e.g. for wired data import) or set-top boxes (e.g. for implants). The data is transmitted to a background system via an internet connection and persisted there in a __Health Record__. The HDDT interface for data transmission to DIGA is based on the Health Record. Thus, only data that is available in the Health Record of a background system is affected by § 374a SGB V; data that is only processed in the Personal Device or the Aggregation Manager does not fall under § 374a SGB V and therefore must not be made available through the HDDT API.

### Relevant Systems

The necessary prerequisite for a medical aid or implant to fall under the regulations of § 374a SGB V is the financial viability of the aid or implant through statutory health insurance (GKV). The aid or implant is financially viable under the statutory health insurance system if:
- it is listed in the [directory of medical aids of the GKV](https://hilfsmittel.gkv-spitzenverband.de/home),
- it can be assigned to a product type defined in the list of medical aids of the GKV (7-digit number) or
- it is reimbursed within the framework of a contract pursuant to § 140a SGB V.

In addition, the aid or implant must have an interface through which the collected data is extracted and forwarded to a Health Record in a back-end system via an Aggregation Manager. These two components - Aggregation Manager and Health Record - are usually combined into a single product that implements a vendor specific data sharing platform. For manufacturers who have multiple Personal Health Device products, data from these products is often recorded in this unique platform and thus allows for integrating data from different devices to gain additional insight into a patient's health status.

Therefore, the HDDT specification considers the Aggregation Manager and the Health Record as a single logical component. This component is named __Device Data Recorder__. This logical division of the ecosystem is outlined in the figure below.

<div><img src="/HDC Medical Aid Subsystems.png" alt="subsystems of the personal health device ecosystem" width="60%"></div>
<br clear="all"/>

The responsibility for the implementation of the interface according to § 374a SGB V lies with the entity responsible for the Device Data Recorder. In the simplest case, the manufacturer of the Personal Health Device (medical aid or implant) is also responsible for the Device Data Recorder. If the Personal Health Device meets the conditions mentioned, then the manufacturer MUST implement and operate the HDDT interfaces on its backend system. This also applies if the Personal Health Device and the Device Data Recorder are provided by different manufacturers, if they both belong to the same parent company or if one of the providers is a subsidiary of the other provider.

___Example 1__: Manufacturer A offers a blood glucose meter. The aid is listed in the list of medical aids of the GKV and can export the collected data via a USB cable. Manufacturer A does not offer an Aggregation Manager itself, i.e. it does not support data storage in its own backend. However, manufacturer A has a subsidiary B that offers a desktop application for doctors to monitor and control the therapy of their diabetes patients. This application allows data to be read out of A's blood glucose meter via a USB cable and stored in a health record in the backend system of company B. In this case, company B MUST implement the HDDT interface in order to enable DiGA to retrieve data from company A's glucose meter._

If both subsystems do not belong to the same vendor or group, the manufacturer responsible for the Device Data Recorder MUST implement the HDDT interface if the Device Data Recorder or one of the components contained therein is itself a medical aid that can be financed by the statutory health insurance system or is part of such an aid. The only exception to this rule is that the Device Data Recorder is a DiGA or a component of a DiGA.  

___Example 2__: Manufacturer A offers a rtCGM that can also be coupled with an insulin pump in the context of an Automated Insulin Delivery (AID) system. The rtCGM is listed in the [directory of medical aids of the GKV](https://hilfsmittel.gkv-spitzenverband.de/home) and can be connected to paired apps via Bluetooth LE and thus continuously transmit the measured data to this app. Manufacturer A offers an app for its rtCGM itself and stores the data in its own backend. Manufacturer A is therefore obliged to implement the HDDT interface. However, if the rtCGM is used as part of an AID system, the rtCGM is not connected to A's app, but to the AID control app of the insulin pump manufacturer (manufacturer B). The app and insulin pump are listed as integrated aids in the list of aids of the GKV, i.e. they are reimbursed in the GKV. This means that the AID control app is part of an aid that can be financed by the GKV, which means that manufacturer B MUST implement the HDDT interface in such a way that both the original data of the insulin pump and the data taken over from the rtCGM can be made available for DiGA._

<div><img src="/HDDT affected systems example 2.png" alt="Example 2" width="70%"></div>
<br clear="all"/>

___Example 3__: Manufacturer A offers an rtCGM. An unaffiliated manufacturer B offers a diabetes diary that can receive data from manufacturer A's rtCGM via a proprietary interface. The diabetes diary is not a DiGA and is not otherwise reimbursable in statutory health insurance. Manufacturer B is not obliged to implement the HDDT interface and cannot be listed in the HiMi-SST-VZ of the BfArM._

___Example 4__: Manufacturers A and B each offer an rtCGM. A manufacturer C that is not affiliated with A or B offers a diabetes diary as a DiGA that can receive data from the rtCGMs of manufacturers A and B via a proprietary interface. Manufacturer C is not obliged to implement the HDDT interface. However, he must disclose the interface used (interoperability criteria 3 in Annex 2 DiGAV) and take the received data into account in an appropriate form in his ePA export._

___Example 5__: Manufacturers A and B each offer an rtCGM. A manufacturer C that is not affiliated with A or B offers an rtCGM as well as a diabetes diary. The diabetes diary is a DiGA that can receive data from the rtCGMs of manufacturers A, B and C (i.e. its own product) via a proprietary interface. Manufacturer C MUST implement the HDDT interface and MUST make the data received from its own rtCGM available to other DiGA via it. It does not have to be able to extract the data received from the rtCGMs of manufacturers A and B via the HDDT interface. However, he MUST disclose the interface used to connect the rtCGM (IOP criterion 3 in Appendix 2 DiGAV) and take the data received from all three rtCGMs into account in an appropriate form in his ePA export._

