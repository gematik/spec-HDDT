This page lists the codes that the Device Data Recorder SHOULD support, whenever returning an error described elsewhere in this specification.

### General Errors

### Authorization Server Errors

### Resource Server Errors

|HTTP Code| Situation | Error Content |
|-|-|-|
| `400` | - FHIR-search query contains an unknown search parameter<br>- FHIR-search query contains `subject` or `patient` as a search parameter.| [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` should be set to `processing`<br>- `issue.diagnostics` should be `Unknown search parameter %s`.<br>Optionally can provide a list in `diagnostics` with all supported search parameters. |
| `401` | Token is not a signed JWT | Plaintext Message: `Token is not a signed JWT` |
| `401` | Invalid token issuer | Plaintext Message: `Invalid token issuer` |
| `401` | JWT has expired | Plaintext Message: `Expired JWT` |
| `401` | Token cannot be used yet (not-before time) | Plaintext Message: `Token cannot be used yet` |
| `403` | Authorization-Header is empty or no Authorization Header provided in request | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` should be set to `processing`<br>- `issue.diagnostics` should be `Access denied by rule: no-access-token` |
| `404` | - FHIR-Read on a on a resource that does not exist on the resource server<br> - FHIR-Read on a resource that has been deleted, due to being outside of the historic range.<br>- FHIR-Read on a resource that the DiGA is not allowed to access due to OAuth scope restrictions. | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` should be set to `processing`<br>- `issue.diagnostics` should be `Resource %s is not known` | 
| `500` | Any other failure on the Device Data Recorder's side | Optional plaintext message describing the failure. |

### Special Cases

### Examples