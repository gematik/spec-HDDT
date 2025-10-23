### Introduction

This document describes the revocation endpoint of the OAuth 2.0 Authorization Server. The revocation endpoint allows a
DiGA to signal that user consent is no longer valid on its side. The revocation request triggers the withdrawal of
consent in the Device Data Recorder for the patient associated with the pseudonymous Pairing ID. Once a refresh token is
revoked, all access tokens issued under the same authorization grant and the grant itself become invalid.

The revocation endpoint is a **backend-to-backend endpoint** and requires client authentication using Mutual-TLS (
`tls_client_auth`).

---

### Endpoint

Note: There is no strict definition of the revocation endpoint URL
in [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009). The URL below is a common convention. Device Data Recorder
manufacturers MAY choose a different URL structure as long as it is properly documented in
the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/revoke`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **HTTP Method**      | POST                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Description**      | Allows a DiGA to revoke a refresh token and thereby signal consent withdrawal. The revocation invalidates the corresponding refresh token, all access tokens issued under the same authorization grant, the authorization grant itself, and the stored user consent linked to the affected Pairing ID.                                                                                                                                                                                                                                                                                                                                                                                                    |
| **Authentication**   | Mutual-TLS Client Authentication (see [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705)), using `tls_client_auth`. The Authorization Server MUST validate the client certificate against the DiGA’s registration in the DiGA-VZ.                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Returned Objects** | None (empty response on success).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Specifications**   | • MUST comply with [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009).<br>• MUST perform revocation over Mutual-TLS authentication.<br>• MUST accept the following parameters:<br>    • `client_id`      – identifies the DiGA client in the Authorization Server.<br>    • `token` – identifies the token to be revoked.<br>    • `token_type_hint=refresh_token` – indicates the token type.<br>• Upon successful revocation, the Authorization Server MUST invalidate the refresh token, all access tokens issued under the same grant, the authorization grant itself, and the stored user consent linked to the Pairing ID.<br>• MAY return `HTTP 200 OK` even if the token was already invalidated. |
| **Error codes**      | `400` (Invalid request)<br>`401` (Unauthorized – client authentication failed)<br>`403` (Forbidden – client not authorized)<br>`500` (Internal Server Error)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |

---

### Example

**Request:**

```bash
curl -X POST "https://himi.example.com/revoke" \
  --cert client-cert.pem --key client-key.pem \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=urn:diga:bfarm:12345" \
  -d "token=9e35d65d-ec12-4b8d-a8b1-dff2f7cf6a5e" \
  -d "token_type_hint=refresh_token"
```

**Response:**

```http
HTTP/1.1 200 OK
```
