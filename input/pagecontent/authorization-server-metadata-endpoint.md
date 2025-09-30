### Introduction

This document describes the `/.well-known/oauth-authorization-server` endpoint for retrieving the OAuth 2.0
Authorization Server Metadata. The metadata document provides information about the Authorization Server’s
configuration, including supported endpoints, grant types, token formats, and security mechanisms. This endpoint is
public and does not require authentication.

---

### Endpoint

|                      |                                                                                                                                                                                                                                                                                                                                                         |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/.well-known/oauth-authorization-server`                                                                                                                                                                                                                                                                                                               |
| **HTTP Method**      | GET                                                                                                                                                                                                                                                                                                                                                     |
| **Description**      | Provides an OAuth 2.0 Authorization Server Metadata Document with information about supported endpoints, grant types, scopes, and other capabilities.                                                                                                                                                                                                   |
| **Authentication**   | None (public endpoint)                                                                                                                                                                                                                                                                                                                                  |
| **Returned Objects** | OAuth 2.0 Authorization Server Metadata Document (JSON)                                                                                                                                                                                                                                                                                                 |
| **Specifications**   | • MUST comply with [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414).<br> • MUST list all mandatory endpoints defined in this specification.<br> • MUST declare supported grant types and PKCE (RFC 7636).<br> • MUST declare Mutual-TLS Client Authentication as the supported client authentication method.<br> • MUST declare supported scopes.<br> |
| **Error codes**      | `500` (Internal Server Error)                                                                                                                                                                                                                                                                                                                           |

---

### Example

**Request:** 

```bash
curl -X GET "https://himi.example.com/.well-known/oauth-authorization-server" \
  -H "Accept: application/json"
```

**Response:**

```json
{
  "issuer": "https://himi.example.com",
  "authorization_endpoint": "https://himi.example.com/authorize",
  "token_endpoint": "https://himi.example.com/token",
  "revocation_endpoint": "https://himi.example.com/revoke",
  "pushed_authorization_request_endpoint": "https://himi.example.com/par",
  "introspection_endpoint": "https://himi.example.com/introspect",
  "jwks_uri": "https://himi.example.com/jwks.json",
  "mtls_endpoint_aliases": {
    "token_endpoint": "https://mtls.himi.example.com/token",
    "revocation_endpoint": "https://mtls.himi.example.com/revoke",
    "pushed_authorization_request_endpoint": "https://mtls.himi.example.com/par",
    "introspection_endpoint": "https://mtls.himi.example.com/introspect"
  },
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
  "scopes_supported": [
    "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutzucker",
    "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutdruck",
    "patient/Device.r?type=https://terminologien.bfarm.de/fhir/CodeSystem/CS_HiMi_DeviceType|glucometer",
    "patient/DeviceMetric.r"
  ],
  "subject_types_supported": [
    "public"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ]
}
```
