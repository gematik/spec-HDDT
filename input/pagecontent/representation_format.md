## Representation Formats

The FHIR standard defines three different representation formats: XML, JSON, and RDF (Turtle). Within the scope of the Device2DiGA specification, **confirmation-relevant systems (servers) MUST support the XML and JSON formats**.

Client-side implementations may choose between XML and JSON representations, but **must indicate the chosen representation in the HTTP `Accept` and `Content-Type` headers**.

If a client requests a format in the `Accept` header that is not supported by the server, the server **MUST respond with the error code 406 Not Acceptable**. If a client sends a format in the `Content-Type` header that is not supported by the server, the server **MUST respond with the error code 415 Unsupported Media Type**.

It should be noted that the `Content-Type` and `Accept` headers may include additional FHIR-specific and general parameters. See, for example, [FHIR HTTP Version Parameter](https://www.hl7.org/fhir/R4/http.html#version-parameter). The presence of these parameters **must not cause an error**.

Requests specifying a FHIR version other than the agreed version 4.0 **MUST be responded to with error code 406 Not Acceptable**.
