### Introduction

This document describes the Pushed Authorization Request (PAR) endpoint of the OAuth 2.0 Authorization Server.  
The PAR endpoint allows a DiGA to send an authorization request directly to the OAuth2 Authorization Server backend *
*before user consent is collected**.  
By doing so, sensitive request parameters are not exposed to the user agent and URL length limitations are avoided.

The PAR endpoint is a **backend-to-backend endpoint** and requires client authentication using **Mutual-TLS**.

---

### Endpoint

Note: There is no strict definition of the PAR endpoint URL in [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126).  
The URL below is a common convention. Device Data Recorder manufacturers MAY choose a different URL structure as long as it is properly
documented in the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/par`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **HTTP Method**      | POST                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Description**      | Allows a DiGA (OAuth client) to register an authorization request with the OAuth2 Authorization Server. Returns a `request_uri` that the DiGA later uses when redirecting the patient to the `/authorize` endpoint.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Authentication**   | **Mutual-TLS Client Authentication** (see [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705)), using `tls_client_auth`. The Authorization Server MUST validate the client certificate against the DiGA’s registration in the DiGA-VZ.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Returned Objects** | JSON object containing `request_uri` and `expires_in`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **Specifications**   | • MUST comply with [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126).<br> • The Authorization Server MUST **require** PAR for all authorization flows (`require_pushed_authorization_requests = true`).<br> • MUST use PKCE ([RFC 7636](https://www.rfc-editor.org/rfc/rfc7636)).<br> • MUST strictly validate `redirect_uri` and `scope` parameters against the DiGA-VZ registration.<br> • MUST NOT support the `request` parameter.<br> • MUST NOT support JWT-Secured Authorization Requests ([RFC 9101](https://www.rfc-editor.org/rfc/rfc9101)).<br> • MUST return a JSON object containing `request_uri` and `expires_in`.<br> • Interaction with the patient MUST NOT occur at this endpoint (backend-only). |
| **Error codes**      | `400` (Invalid request)<br>`401` (Unauthorized – client authentication failed)<br>`403` (Forbidden – client not authorized or scope invalid)<br>`500` (Internal Server Error)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |

---

### Example

**Request:**

```bash
curl -X POST "https://himi.example.com/par" \
  --cert client-cert.pem --key client-key.pem \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=urn:diga:bfarm:12345" \
  -d "response_type=code" \
  -d "redirect_uri=https%3A%2F%2Fdiga.example.com%2Fcallback" \
  -d "scope=patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutzucker" \
  -d "code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM" \
  -d "code_challenge_method=S256"
```

**Response:**

```json
{
  "request_uri": "urn:uuid:a1b2c3d4-5678-90ab-cdef-111213141516",
  "expires_in": 90
}
```
