### Introduction

This document describes the revocation endpoint of the OAuth 2.0 Authorization Server. The revocation endpoint allows a
DiGA to signal that a refresh token is no longer valid. This endpoint is essential for implementing consent revocation:
once a refresh token is revoked, all access tokens issued under that grant become invalid.

The revocation endpoint is a **backend-to-backend endpoint** and requires client authentication using Mutual-TLS.

---

### Endpoint

Note: There is no strict definition of the revocation endpoint URL
in [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009). The URL below is a common convention. HiMi manufacturers MAY
choose a different URL structure as long as it is properly documented in
the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                                       |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/revoke`                                                                                                                                                                                                                                                             |
| **HTTP Method**      | POST                                                                                                                                                                                                                                                                  |
| **Description**      | Allows a DiGA to revoke a refresh token. The revocation invalidates all access tokens associated with the same authorization grant, as well as the grant itself.                                                                                                      |
| **Authentication**   | Mutual-TLS Client Authentication (see [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705)).                                                                                                                                                                            |
| **Returned Objects** | None (empty response on success).                                                                                                                                                                                                                                     |
| **Specifications**   | • MUST comply with [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009).<br> • MUST accept refresh tokens as input.<br> • MUST invalidate the refresh token and all access tokens derived from it.<br> • MAY return HTTP 200 even if the token was already invalidated. |
| **Error codes**      | `400` (Invalid request)<br>`401` (Unauthorized – client authentication failed)<br>`403` (Forbidden – client not authorized)<br>`500` (Internal Server Error)                                                                                                          |

---

### Example

**Request:**

```bash
curl -X POST "https://himi.example.com/revoke" \
  --cert client-cert.pem --key client-key.pem \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "token=9e35d65d-ec12-4b8d-a8b1-dff2f7cf6a5e" \
  -d "token_type_hint=refresh_token"
```

**Response:**

```http
HTTP/1.1 200 OK
```
