# OAuth 2.0 JWKS Endpoint

### Introduction

This document describes the JWKS endpoint of the OAuth 2.0 Authorization Server. The endpoint provides the JSON Web Key
Set (JWKS) used to validate signatures on JWT-based tokens issued by the Authorization Server. Resource Servers use this
endpoint to fetch the current set of public keys.

The JWKS endpoint is a **public endpoint** and does not require authentication.

---

### Endpoint

Note: There is no strict definition of the JWKS endpoint URL in [RFC 7517](https://www.rfc-editor.org/rfc/rfc7517). The
URL below is a common convention. HiMi manufacturers MAY choose a different URL structure as long as it is properly
documented in the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                      |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/jwks`                                                                                                                                                                                                                                              |
| **HTTP Method**      | GET                                                                                                                                                                                                                                                  |
| **Description**      | Returns a JSON Web Key Set (JWKS) containing the public keys that can be used by Resource Servers to validate JWT access tokens issued by the Authorization Server.                                                                                  |
| **Authentication**   | None (public endpoint)                                                                                                                                                                                                                               |
| **Returned Objects** | JSON Web Key Set (JWKS) as defined in [RFC 7517](https://www.rfc-editor.org/rfc/rfc7517)                                                                                                                                                             |
| **Specifications**   | • MUST comply with [RFC 7517](https://www.rfc-editor.org/rfc/rfc7517).<br> • MUST publish all active signing keys.<br> • SHOULD support key rotation.<br> • MUST expose this endpoint via the `jwks_uri` field in the Authorization Server Metadata. |
| **Error codes**      | `500` (Internal Server Error)                                                                                                                                                                                                                        |

---

### Example

**Request:**

```bash
curl -X GET "https://himi.example.com/jwks" \
  -H "Accept: application/json"
```

**Response:**

```json
{
  "keys": [
    {
      "kty": "RSA",
      "kid": "2024-10-01",
      "use": "sig",
      "alg": "RS256",
      "n": "sXchPQ7ydJQwU2w5mQj3hE...",
      "e": "AQAB"
    }
  ]
}
```
