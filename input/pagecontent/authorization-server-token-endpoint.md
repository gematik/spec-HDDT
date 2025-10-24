### Introduction

This document describes the token endpoint of the OAuth 2.0 Authorization Server. The token endpoint is used by a DiGA
to exchange an authorization code for an access token and a refresh token. It is also used to obtain new access tokens
via refresh tokens without further user interaction. 

The token endpoint is a **backend-to-backend endpoint** and requires client authentication using **Mutual-TLS**.

---

### Endpoint

Note: There is no strict definition of the token endpoint URL in [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749). The
URL below is a common convention. Device Data Recorder manufacturers MAY choose a different URL structure as long as it is properly
documented in the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/token`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **HTTP Method**      | POST                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Description**      | Issues OAuth 2.0 access and refresh tokens to a DiGA. Tokens reflect the patient’s consent and are bound to the Pairing ID. Supports refresh token rotation to maintain long-lived authorization without repeated user interaction.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **Authentication**   | **Mutual-TLS Client Authentication** (see [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705)) using `tls_client_auth`. The Authorization Server MUST validate the presented client certificate against the DiGA’s registration in the DiGA-VZ. Only registered and active DiGAs MAY invoke this endpoint.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| **Returned Objects** | JSON object containing `access_token`, `refresh_token`, `token_type`, `expires_in`, `scope`, and `sub`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **Specifications**   | • MUST comply with [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749).<br>• MUST follow a Pushed Authorization Request (PAR) ([RFC 9126](https://www.rfc-editor.org/rfc/rfc9126)) with a valid `request_uri`.<br>• MUST support PKCE ([RFC 7636](https://www.rfc-editor.org/rfc/rfc7636)).<br>• MUST issue both access and refresh tokens.<br>• Access and refresh tokens MUST be cryptographically signed by the OAuth2 Authorization Server.<br>• The lifetime of an access token is manufacturer-defined and should balance availability and security.<br>• MUST include the granted `scope` parameter in the response.<br>• MUST include the Pairing ID in the `sub` claim of the JSON response body<br>• MUST support refresh token rotation.<br>• MUST NOT encrypt tokens.<br>• MUST NOT issue certificate-bound access tokens (RFC 8705 §3.2). |
| **Error codes**      | `400` (Invalid request)<br>`401` (Unauthorized – client authentication failed)<br>`403` (Access denied – invalid authorization code or revoked consent)<br>`500` (Internal Server Error)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

---

### Example

**Request (exchange authorization code):**

```bash
curl -X POST "https://himi.example.com/token" \
  --cert client-cert.pem --key client-key.pem \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code=SplxlOBeZQQYbYS6WxSbIA" \
  -d "redirect_uri=https%3A%2F%2Fdiga.example.com%2Fcallback" \
  -d "client_id=urn:diga:bfarm:12345" \
  -d "code_verifier=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
```

**Response:**

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 600,
  "refresh_token": "9e35d65d-ec12-4b8d-a8b1-dff2f7cf6a5e",
  "scope": "patient/Observation.rs?code:in=https://gematik.de/fhir/hddt/ValueSet/hddt-miv-blood-glucose-measurement patient/Device.rs patient/DeviceMetric.rs",
  "sub": "8c9a85fe78f6ccd91a62aff2bf7cf3ea4929a8f1ccbd24f2874ab853fe4815fc"
}
```
