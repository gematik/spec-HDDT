Profile: HddtCgmSummary
Parent: Bundle
Id: hddt-cgm-summary
Title: "Bundle – HDDT CGM Summary Report"
Description: """
This profile defines the exchange of aggregated measurement data for the Mandatory Interoperable Value (MIV) \"Continuous 
Glucose Measurement\". By this it provides a patient's glucose profile for a defined period. The MIV \"Continuous 
Glucose Measurement\" is e.g. implemented by real-time Continuous Glocose Monitoring devices (rtCGM) and Automated Insulin Delivery systems (AID) that control 
an insulin pump from rtCGM data. Future non-invasive measuring methods will expectedly be linked with this MIV and therefore use this profile for sharing aggregated glucose profile data with DiGA, too.

This profile constrains the FHIR Bundle resource for use as the result container of the `$hddt-cgm-summary` operation.  
The operation requests a patient's glucose profile. The glucose profile is calculated form continuous glucose measurement data
and consists of the machine-readable parts of the [_HL7 CGM summary profile_](https://hl7.org/fhir/uv/cgm/). 

The Bundle is of type *collection* and MUST contain only resources of the following types:  
- Observations conforming to [HL7 CGM profiles](https://hl7.org/fhir/uv/cgm/): 
    - [CGM Summary Observation](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary.html)
    - [Mean Glucose (Mass)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html)
    - [Mean Glucose (Moles)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html)
    - [Times in Ranges](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-times-in-ranges.html)
    - [Glycemic Variability Index (GMI)](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-gmi.html)
    - [Coefficient of Variation](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-coefficient-of-variation.html)
    - [Days of Wear](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-days-of-wear.html)
    - [Sensor Active Percentage](https://hl7.org/fhir/uv/cgm/StructureDefinition-cgm-summary-sensor-active-percentage.html)

- Device resources conforming to `HddtPersonalHealthDevice` to provide context about the actual Personal Health Device device used.  

The purpose of this Bundle profile is to provide a consistent structure for server responses when clients query for CGM data with aggregation logic.  
It ensures interoperability across different implementations by defining a predictable response format.  
This supports use cases such as:  
- Retrieval of CGM summary metrics over a given time interval in support for the upcoming digital disease management program (dDMP) on Diabetes, e.g. for 
    - continuous therapy monitoring and adjustment
    - forwarding key data to treating physicians, e.g. for clinical decision support
    - supporting asynchonous telemonitoring by ad hoc provisioning of condensed status information
- Combining aggregated measurement data and device metadata for downstream applications such as visualization or compliance monitoring

**Constraints applied:**  
- `Bundle.type` is fixed to `collection`.  
- `Bundle.entry.resource` is restricted to CGM Observation profiles and `HddtPersonalHealthDevice`. No other resource types are allowed in the Bundle.  
- `Bundle.entry` is set as mandatory. A requests for a CGM summary that would result in an empty bundle, MUST give an _OperationOutcome_ with an error or warning message as its response. Therefore there is no scenario where an empty bundle would be shared with a DiGA.
"""

* ^status = #active
* ^date = "2026-03-04"
* ^version = $term-version
* ^publisher = "gematik GmbH"
* ^copyright = "Copyright (c) 2026 gematik GmbH"
* type = #collection (exactly)
* type ^short = "The bundle is always a collection of CGM summary Observations and optionally related Device and DeviceMetric resources returned by the $hddt-cgm-summary operation."
* entry 1..*
* entry.resource only $cgm-summary or $cgm-summary-mean-glucose-mass-per-volume or $cgm-summary-mean-glucose-moles-per-volume or $cgm-summary-times-in-ranges or $cgm-summary-gmi or $cgm-summary-coefficient-of-variation or $cgm-summary-days-of-wear or $cgm-summary-sensor-active-percentage or HddtPersonalHealthDevice 
* entry.resource ^short = "Observations with their related Device and DeviceMetric information"