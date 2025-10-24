### Introduction

This document describes the authorization endpoint of the OAuth 2.0 Authorization Server. The authorization endpoint is
used to initiate the Authorization Code Flow. It is the endpoint where the patient (resource owner) is redirected
for authentication and to give consent to a DiGA.

Unlike other endpoints, the authorization endpoint is called through the user agent (browser or app). It does not
require Mutual-TLS client authentication, but it MUST strictly validate the `client_id` and `redirect_uri`.

---

### Endpoint

Note: There is no strict definition of the authorization endpoint URL
in [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749). The URL below is a common convention. Device Data Recorder manufacturers MAY
choose a different URL structure as long as it is properly documented in
the [OAuth 2.0 Authorization Server Metadata](authorization-server-metadata-endpoint.html).

|                      |                                                                                                                                                                                                                                                                                                                    |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**         | `/authorize`                                                                                                                                                                                                                                                                                                       |
| **HTTP Method**      | GET (via user agent redirect)                                                                                                                                                                                                                                                                                      |
| **Description**      | Initiates the OAuth 2.0 Authorization Code Flow. The patient is authenticated at the OAuth2 Authorization Server and presented with a consent dialogue for the requested SMART scopes.                                                                                                                             |
| **Authentication**   | User authentication (patient login). No Mutual-TLS client authentication.                                                                                                                                                                                                                                          |
| **Returned Objects** | Authorization Code and State parameters (passed via redirect to DiGA `redirect_uri`).                                                                                                                                                                                                                              |
| **Specifications**   | • MUST comply with [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749).<br> • MUST be called with `client_id` and `request_uri` (from PAR).<br>• MUST present requested SMART scopes in a human-readable form for patient consent.<br> • MUST generate and bind consent to a [Pairing ID](pairing.html#pairing-id). |
| **Error codes**      | `400` (Invalid request)<br>`401` (Unauthorized – authentication failure)<br>`403` (Access denied – consent not given)<br>`500` (Internal Server Error)                                                                                                                                                             |

---

### Example

**Request (user agent redirect):**

```bash
GET /authorize?
  client_id=urn:diga:bfarm:12345&
  request_uri=urn:uuid:a1b2c3d4-5678-90ab-cdef-111213141516
```

**Response (redirect to DiGA):**

```http
HTTP/1.1 302 Found
Location: https://diga.example.com/callback?
  code=SplxlOBeZQQYbYS6WxSbIA&
  state=af0ifjsldkj
```
