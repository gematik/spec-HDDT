### Introduction

This document describes the `/.well-known/oauth-authorization-server` endpoint for retrieving the OAuth 2.0
Authorization Server Metadata. The metadata document provides information about the Authorization Server’s
configuration, including supported endpoints, grant types, and security mechanisms. This endpoint is
public and does not require authentication.

---

### Endpoint

|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/.well-known/oauth-authorization-server`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **HTTP Method**      | GET                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Description**      | Provides an OAuth 2.0 Authorization Server Metadata Document with information about supported endpoints, grant types, scopes, and other capabilities.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Authentication**   | None (public endpoint)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **Returned Objects** | OAuth 2.0 Authorization Server Metadata Document (JSON)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **Specifications**   | • MUST comply with [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414).<br> • MUST declare **Authorization Code** as the supported grant type and **PKCE S256** as the code challenge method.<br> • MUST declare **Pushed Authorization Requests (PAR)** and set `require_pushed_authorization_requests` to `true`.<br> • MUST declare **Mutual-TLS client auth** (`tls_client_auth`) for the token and revocation endpoints.<br> • MUST declare **revocation** endpoint and its auth methods.<br> • MUST publish **supported SMART scopes** (MIV-specific).<br> • MUST publish `tls_client_certificate_bound_access_tokens: false` (certificate-bound access tokens are not used).<br> • SHOULD publish `service_documentation` (client registration information). |
| **Error codes**      | `500` (Internal Server Error)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |

---

### Example

**Request:**

```bash
curl -X GET "https://himi.example.com/.well-known/oauth-authorization-server" \
     -H "Accept: application/json"
```

**Response (example):**

```json
{
  "issuer": "https://himi.example.com",
  "authorization_endpoint": "https://himi.example.com/authorize",
  "token_endpoint": "https://himi.example.com/token",
  "revocation_endpoint": "https://himi.example.com/revoke",
  "pushed_authorization_request_endpoint": "https://himi.example.com/par",
  "response_types_supported": [
    "code"
  ],
  "grant_types_supported": [
    "authorization_code",
    "refresh_token"
  ],
  "code_challenge_methods_supported": [
    "S256"
  ],
  "token_endpoint_auth_methods_supported": [
    "tls_client_auth"
  ],
  "revocation_endpoint_auth_methods_supported": [
    "tls_client_auth"
  ],
  "require_pushed_authorization_requests": true,
  "request_parameter_supported": false,
  "tls_client_certificate_bound_access_tokens": false,
  "scopes_supported": [
    "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutzucker",
    "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutdruck",
    "patient/Device.r?type=https://terminologien.bfarm.de/fhir/CodeSystem/CS_HiMi_DeviceType|glucometer",
    "patient/DeviceMetric.r"
  ],
  "service_documentation": "https://himi.example.com/docs/client-registration"
}
```
