### Status: Pre-Final
* Verantwortlich: @jcaumann
* ToDo:
    * Festlegungen zu "must support" konsentieren
    * QS (insb. Sprache)


### FHIR Version
This specification is based on HL7 FHIR R4 (v4.0.1), which is the normative FHIR version for the German healthcare system.

Taking into account that existing implementations at affected health record manufactures may use FHIR R5 or may even prepare for the upcoming release R6, serious efforts have been made to allow for semantic and structural conformance of the HDDT specification with FHIR R4, R5 and R6. This means that sole syntactical transformations allow for existing implementations based on R5 to be mapped an the R4 based HDDT specification. 

### Representation Format
The FHIR standard defines three different representation formats: XML, JSON, and RDF (Turtle). Within the scope of the HDDT specification, health records as HDDT device data providers MUST support both the XML and JSON formats. 

DiGA as HDDT device data consumers may choose between XML and JSON representations, but MUST indicate the chosen representation in the HTTP `Accept` and `Content-Type` headers.

If a HDDT device data consumer requests a format in the `Accept` header that is not supported by the HDDT device data provider, the HDDT device data provider MUST respond with the error code _406 Not Acceptable_. If a HDDT device data consumer sends a format in the `Content-Type` header that is not supported by the HDDT device data provider, the HDDT device data provider MUST respond with the error code _415 Unsupported Media Type_.

It should be noted that the `Content-Type` and `Accept` headers may include additional FHIR-specific and general parameters:
* HDDT device data providers MUST support [FHIR HTTP Version Parameters](https://www.hl7.org/fhir/R4/http.html#version-parameter). If a requests specifies a FHIR version other than version 4.0 the HDDT device data provider MUST responded to with error code _406 Not Acceptable_.
* HDDT device data providers SHOULD support the [FHIR HTTP `_format` Parameter](https://www.hl7.org/fhir/R4/http.html#parameters) and MAY support the other parameters defined at https://www.hl7.org/fhir/R4/http.html#parameters.

### _Mandatory_, _Must Support_ and _Optional_ Elements
The elements defined within the HDDT FHIR profiels consist of _Mandatory_, _Must Support_ and _Optional_ elements. 
#### _Mandatory_ Elements
Mandatory elements are elements with a minimum cardinality of 1 (min=1). A HDDT device data provider always MUST provide a valid value for such elements. A HDDT device data consumer MUST be able to process such elements according to the semantics as defined with the HDDT specifications or the core HL7 FHIR R4 specification.

#### _Must Support_ Elements
_Must Support_ elements are flagged with an "S" in the HDDT FHIR profile definitions. A HDDT device data provider SHOULD provide a valid value for each _Must Support_ element. Omitting a _Must Support_ element in response to a query is only allowed if 
* an exceptional case exists which is described in the HDDT specification
* the element holds a codeable value which is bound to a required _ValueSet_ where none of the defined codes matches for the value.

A HDDT device data consumer MUST be able to process all _Must Support_ elements according to the semantics as defined with the HDDT specification or the core HL7 FHIR R4 specification. 

#### _Optional_ Elements
Optional elements are elements with a minimum cardinality of 0 (min=0) which are not flagged as _Must Support_. A HDDT device data provider MAY omit optional elements from a response to a request. A HDDT device data consumer MAY ignore optional elements included with the response to a request. 

Remark: _Ignoring_ an element means that the element is not interpreted by the device data consumer and does not affect the device data consumer's perception of the semantics of the resource.

