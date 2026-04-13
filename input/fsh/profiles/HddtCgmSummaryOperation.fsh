Instance: HddtCgmSummaryOperation
InstanceOf: OperationDefinition
Usage: #definition
Title: "Search Operation for summary data measurement"
Description: """
The `$hddt-cgm-summary` operation is defined on the *Observation* resource type.  
It allows clients to request CGM summary data filtered by effective period, and optionally include related device context (Device, DeviceMetric).  

**Use cases supported by this operation include:**  
- Retrieving CGM summary statistics (mean glucose, time-in-range, GMI, etc.) for a patient over a specified interval  

**Input Parameters:**  
- `effectivePeriodStart` *(dateTime, optional)*: Lower bound of the observation effective period.  
- `effectivePeriodEnd` *(dateTime, optional)*: Upper bound of the observation effective period.  
- `related` *(boolean, optional)*: If true, the response bundle also contains related Device and DeviceMetric resources.  

**Output Parameter:**  
- `result` *(Reference, required)*: A Bundle conforming to profile `HddtCgmSummary` profile containing all matching CGM Observations and, if requested, their related devices.  

**Error handling (OperationOutcome):**  
- `MSG_PARAM_UNKNOWN`: Returned when an unsupported input parameter is used.  
- `MSG_PARAM_INVALID`: Returned when a parameter value is invalid (e.g., bad date format).  
- `MSG_NO_MATCH`: Returned when no matching observations are found. 
- `MSG_BAD_SYNTAX`: Returned when the request is malformed.  
"""

* id = "hddt-cgm-summary-operation"
* name = "HddtCgmSummaryOperation"
* title = "Search Operation for summary data measurement"
* status = #active
* version = $term-version
* experimental = false
* kind = #operation
* publisher = "gematik GmbH"
* date = "2026-03-04"
* affectsState = false
* code = #hddt-cgm-summary
* system = false
* type = true
* instance = false
* parameter[+].name = #effectivePeriodStart
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "Start of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #effectivePeriodEnd
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "End of effective period"
* parameter[=].type = #dateTime
* parameter[+].name = #related
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "If true, include related Device and DeviceMetric in the result bundle"
* parameter[=].type = #boolean
* parameter[+].name = #result
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].documentation = "Result bundle (HTTP 200 OK) containing summary data of measurements and optionally related resources"
* parameter[=].type = #Reference
* parameter[=].targetProfile = "https://gematik.de/fhir/hddt/StructureDefinition/hddt-cgm-summary"