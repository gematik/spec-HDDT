**To Do**
* Update to last information model status (Emil, Jie)
* Review (Jie)

### Introduction

### MIV-Specific Observation Profile

Baum und Tabelle als include

#### Conventions and Good Practices

#### Examples 

### FHIR RESTful Interactions

#### read
Nutzung, Parameter, Beispiele

#### search
Nutzung, Parameter, Beispiele

### MIV-Specific Aggregated Report (falls vorhanden)

#### FHIR Profile

#### FHIR Operation

| | |
|-|-|
| **Resource** | Observation |
| **Operation name** | `$cgm-summary-data-report` |
|**Purpose** |  Request a summary of desired CGM values (e.g tissue glucose values below lower threshold) for a certain range of time. |
|**Parameters** |  See section "[OpenAPI Description](#openapi-description) for parameter definitions and examples.<br> • `effectivePeriodStart (dateTime)` (optional) <br> • `effectivePeriodEnd (dateTime)` (optional) - End of the effective time period <br> •  `related (boolean)` (optional)|
| **Specifications** | • Summary is calculated at run-time and results are not stored persistently. <br> •  **MUST** support all profiles listed in `Bundle-Search-Summary-Data-Measurements`. <br> • **MUST** support all listed parameters.<br> •  If no period is specified, the server selects a time range starting from the current date, which **MUST** cover at least 14 days.<br> •  The Summary-Operation **MUST** support a minimal duration of 7 days for the effective period, and an error must be returned if the client requests a shorter time period. |

#### Example

### Conventions for DeviceMetric and Device Resources



## Observation for Time Series Measurement - MIV Tissue Glucose

This [Observation](https://hl7.org/fhir/R4/observation.html) profile represents a continuous glucose monitoring (CGM) measurement produced by a CGM device. For this use case, only `valueSampledData` is allowed as the result of the Observation.

The `code` element must be selected from the [Tissue Glucose CGM ValueSet](ValueSet-vs-tissue-glucose-cgm.html), consistent with the units supported by the device. The unit specified in the LOINC code’s display must match the `valueSampledData.unit` or `valueSampledData.code`.

When calibration status is relevant, the `device` element must reference a [DeviceMetric](StructureDefinition-DeviceMetric-Personal-Health-Device.html) resource, where calibration details are recorded. If calibration is not relevant for the device, then `device` must instead reference a [Device](https://victorious-coast-07193b503.2.azurestaticapps.net/StructureDefinition-Device-Personal-Health-Device.html) resource.

The `status` of the Observavtion reflects whether the Observation is "complete", i.e. if no more `valueSampledData.data` can be added. See chapter [Retrieving Data](retrieving-data.html), for the full list of considerations.

The table below highlights elements that are additionally constrained by this profile, or that carry particular semantic importance for the continuous measurement of tissue glucose.


**FHIR resource type**: Observation

| Description | FHIR Attribute | FHIR Data Type | Cardinality | Note |
|------------|----------------|----------------|------------|------|
| Status of the Observation | `status` | code | 1..1 | See chapter [Retrieving Data](retrieving-data.html)  |
| Result of the Observation | `valueSampledData` | SampledData |  0..1 | In cases where data is missing, a reason must be given via `dataAbsentReason` |
| Values of the measurement series | `valueSampledData.data` | string | 1..1 | The actual data.  |
| Unit of the measurement series | `valueSampledData.origin.unit` | string | 1..1 | The measurement unit. Shoud be the same as the unit from the LOINC code in `Observation.code`. |
| Code system of the unit | `valueSampledData.origin.system` | uri | 1..1 | UCUM: http://unitsofmeasure.org  |
| Code of the unit from the specified code system | `valueSampledData.origin.code` | code | 1..1 | Code of the unit, from the UCUM code system.  |
| Coding of this measurement (type of measurement) | `code` | CodeableConcept | 1..1 | e.g., "105272-9" (	Glucose [Moles/volume] in Interstitial fluid) from ValueSet [VS_Tissue_Glucose_CGM](ValueSet-vs-tissue-glucose-cgm.html). |
| Reason for missing data | `dataAbsentReason` | CodeableConcept | 0..1 | A reason must be given if `valueSampledData` is not set. | 
| Reference to the device configuration ([DeviceMetric](https://victorious-coast-07193b503.2.azurestaticapps.net/StructureDefinition-DeviceMetric-Personal-Health-Device.html)) or a device instance ([Device](https://victorious-coast-07193b503.2.azurestaticapps.net/StructureDefinition-Device-Personal-Health-Device.html)) | `device` | Reference | 1..1 | The type of resource referenced, depends on whether sensor calibration is required for the correct interpretation of the data (DeviceMetric), or device does not need calibration (Device). |
| Measurement time or period | `effective[x]` |  Period | 1..1 |  |
| Measurement method | `method` | CodeableConcept | 0..1 | e.g., continuous blood monitoring. This field is flagged as **must support**. |


---

### Profile

The full profile definition can be found at the following places:

- In this specification under Artifacts -> [StructureDefinition/Observation-Tissue-Glucose-CGM-Measurement-Series](https://victorious-coast-07193b503.2.azurestaticapps.net/StructureDefinition-Observation-CGM-Measurement-Series.html)
- **ToDo**: Verlinkung https://gematik.de/fhir/hdc/StructureDefinition/Observation-CGM-Measurement-Series

<hr>
<div id="all-tbl-key-inner">
    {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot-by-key-all.xhtml%}
</div>
<hr>


### Search parameters

The following search parameters **MUST** be supported by the medical aid manufacturer. Examples can be found in the [FHIR API specification](himi-diga-api.html).

| Search parameter | Description |
| --- | -- | 
|`code` | Request Observations of a particular type, e.g. list all Observations that measure blood glucose in mg/dL  from a blood sample | 
|`date` | Request Observations for a particular time range, e.g in the last 14 days. |
| `_include` | An addition to the search query, allowing to also request the full Device/DeviceMetric resource, referenced in `device`. |
