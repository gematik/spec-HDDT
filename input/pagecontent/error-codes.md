This page lists the error codes that the Device Data Recorder SHOULD support when returning errors described elsewhere in this specification.

### Authorization Server Errors

Authorization Server implementations (e.g., Keycloak, Auth0, IdentityServer) are expected to be compliant with the OAuth 2.0 specifications listed below. Error messages MUST have the `application/json` media type and MUST at least contain an `error` property with a corresponding error code as value. HTTP status codes, error codes, error descriptions, and additional properties MUST follow the conventions defined in the respective RFCs.

| Endpoint | Applicable RFCs |
|----------|-----------------|
| `/.well-known/oauth-authorization-server` | [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414) |
| `/par` (Pushed Authorization Request) | [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126) |
| `/authorize` (Authorization Endpoint) | [RFC 6749 Section 4.1.2.1](https://www.rfc-editor.org/rfc/rfc6749#section-4.1.2.1) |
| `/token` (Token Endpoint) | [RFC 6749 Section 5.2](https://www.rfc-editor.org/rfc/rfc6749#section-5.2) |
| `/revoke` (Revocation Endpoint) | [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009) |

#### Specification-Specific Error Handling Requirements

Beyond the standard OAuth 2.0 error handling defined in the RFCs above, the Authorization Server MUST implement the following specification-specific requirements:

**DiGA-VZ Validation Failures** (`/par` and `/token` endpoints):

When Mutual-TLS client authentication succeeds but the client certificate does not match an active DiGA registration in the DiGA-VZ, or when requested scopes exceed the DiGA's registered scopes, the Authorization Server MUST return appropriate OAuth 2.0 error responses:

| HTTP Status | Error Code | Situation | Error Description (recommended) |
|-------------|------------|-----------|---------------------------------|
| `401` | `invalid_client` | DiGA is not registered in DiGA-VZ or registration is not active | `The authenticated client is not registered or not active in the DiGA directory` |
| `400` | `invalid_scope` | Requested scopes are not authorized for the DiGA according to its DiGA-VZ registration | `The requested scope exceeds the scope granted to the client` |
| `400` | `unauthorized_client` | DiGA is not permitted to use the requested authorization grant type | `The client is not authorized to use this authorization grant type` |

**Pairing ID Binding** (`/authorize` endpoint):
- When consent is successfully granted, the Authorization Server MUST generate and bind a [Pairing ID](pairing.html#pairing-id) to the authorization grant before redirecting back to the DiGA.
- If Pairing ID generation fails, the Authorization Server MUST include `error=server_error` and `error_description=Failed to generate pairing identifier` in the redirect URI (per [RFC 6749 Section 4.1.2.1](https://www.rfc-editor.org/rfc/rfc6749#section-4.1.2.1)).

**Consent Revocation** (`/revoke` endpoint):
- Upon successful token revocation, the Authorization Server MUST invalidate:
  - The specified refresh token
  - All access tokens issued under the same authorization grant
  - The authorization grant itself
  - The stored user consent linked to the associated Pairing ID
- Per [RFC 7009 Section 2.2](https://www.rfc-editor.org/rfc/rfc7009#section-2.2), the endpoint MUST return `HTTP 200 OK` even if the token was already invalid or unknown.

### Resource Server Errors

This section lists common error scenarios that Device Data Recorders MUST handle. This list is not exhaustive. For a complete understanding of all possible error conditions, implementers SHOULD refer to the [FHIR R4 RESTful API specification](https://hl7.org/fhir/R4/http.html) and the specific interaction definitions for [search](https://hl7.org/fhir/R4/search.html), [read](https://hl7.org/fhir/R4/http.html#read), [vread](https://hl7.org/fhir/R4/http.html#vread), and other operations.

| HTTP Code | Situation | Error Content |
|-----------|-----------|---------------|
| `200` | FHIR-search query contains a `code` that is not in the MIV [ValueSet](https://hl7.org/fhir/R4/valueset.html) | Return an empty [Bundle](https://hl7.org/fhir/R4/bundle.html). Optionally include an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) inside the [Bundle](https://hl7.org/fhir/R4/bundle.html), where:<br>- `issue.severity` set to `warning`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Code %s not in ValueSet %s`. |
| `200` | FHIR-search query requests data that is outside of the historic range | Return an empty [Bundle](https://hl7.org/fhir/R4/bundle.html). Optionally include an [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) inside the [Bundle](https://hl7.org/fhir/R4/bundle.html), where:<br>- `issue.severity` set to `warning`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Search includes a time range which is outside the historical time range of this service. Potentially no matches found.`. |
| `400` | FHIR-search query contains an unknown search parameter | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Unknown search parameter %s`.<br>Optionally provide a list in `diagnostics` with all supported search parameters. |
| `400` | Malformed date range in date parameter (e.g., invalid date format, end date before start date, or syntactically incorrect date prefix) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` describe the issue, e.g., `Invalid date/time format or date range: %s`. |
| `400` | Invalid `_include` or `_revinclude` references (e.g., referencing unsupported resource types or search parameters) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` describe the issue, e.g., `Invalid _include parameter value: %s`. |
| `401` | Token is not a signed JWT | Header: `WWW-Authenticate: Bearer error="invalid_token", error_description="Token is not a signed JWT"`<br><br>Optional JSON body:<br>```json<br>{<br>  "error": "invalid_token",<br>  "error_description": "Token is not a signed JWT"<br>}<br>``` |
| `401` | Invalid token issuer | Header: `WWW-Authenticate: Bearer error="invalid_token", error_description="Invalid token issuer"`<br><br>Optional JSON body:<br>```json<br>{<br>  "error": "invalid_token",<br>  "error_description": "Invalid token issuer"<br>}<br>``` |
| `401` | JWT has expired | Header: `WWW-Authenticate: Bearer error="invalid_token", error_description="The access token expired"`<br><br>Optional JSON body:<br>```json<br>{<br>  "error": "invalid_token",<br>  "error_description": "The access token expired"<br>}<br>``` |
| `401` | Token cannot be used yet (not-before time) | Header: `WWW-Authenticate: Bearer error="invalid_token", error_description="Token cannot be used yet"`<br><br>Optional JSON body:<br>```json<br>{<br>  "error": "invalid_token",<br>  "error_description": "Token cannot be used yet"<br>}<br>``` |
| `403` | Authorization-Header is empty or no Authorization Header provided in request | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Access denied by rule: no-access-token`. |
| `404` | FHIR-Read on a resource that does not exist on the resource server | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Resource %s is not known`. |
| `404` | FHIR-Read on a resource that the DiGA is not allowed to access due to OAuth scope restrictions | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Access to resource not allowed with current OAuth scope.`. |
| `404` | FHIR-vread on a resource version that does not exist | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Version %s is not valid for resource %s.`. |
| `406` | Request specifies an unsupported representation format in the `Accept` header (e.g., RDF/Turtle when only XML and JSON are supported) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `not-supported`<br>- `issue.diagnostics` set to `Requested format not supported. Supported formats: application/fhir+json, application/fhir+xml`. |
| `406` | Request specifies a FHIR version other than 4.0 in the `Accept` header (via `fhirVersion` parameter) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `not-supported`<br>- `issue.diagnostics` set to `FHIR version not supported. This server supports FHIR R4 (version 4.0.1)`. |
| `410` | FHIR-Read on a resource that has been deleted (e.g., due to being outside of the historic range) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `processing`<br>- `issue.diagnostics` set to `Resource was deleted`. |
| `415` | Request sends an unsupported representation format in the `Content-Type` header (e.g., RDF/Turtle when only XML and JSON are supported) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `not-supported`<br>- `issue.diagnostics` set to `Content-Type not supported. Supported formats: application/fhir+json, application/fhir+xml`. |
| `429` | Rate limit exceeded (too many requests from a single client or for a single patient) | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `throttled`<br>- `issue.diagnostics` set to `Rate limit exceeded. Please retry after the specified time.`<br><br>The response MUST include a `Retry-After` header indicating when the client may retry the request (as seconds or HTTP-date). |
| `500` | Any other failure on the Device Data Recorder's side | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `exception`<br>- `issue.diagnostics` indicate the reason for the failure. |
| `503` | Service temporarily unavailable due to rate limiting or overload | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `throttled`<br>- `issue.diagnostics` include explicit rate-limit information, e.g., `Service temporarily unavailable due to rate limiting`.<br><br>The response SHOULD include a `Retry-After` header. **Note:** HTTP 429 is the recommended approach for rate limiting. |
| `503` | Service temporarily unavailable due to planned maintenance | [OperationOutcome](https://hl7.org/fhir/R4/operationoutcome.html) where:<br>- `issue.severity` set to `error`<br>- `issue.code` set to `transient`<br>- `issue.diagnostics` contain information about the maintenance.<br><br>The response SHOULD include a `Retry-After` header. |