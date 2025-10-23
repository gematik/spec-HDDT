The pairing procedure is the central mechanism for securely connecting _DiGA_ (digital health application acc. § 33a SGB V) with Device Data Recorders that provide access to data from medical aids and implants. The goal is to enable patients to use health data collected by their medical aid or implant in a DiGA in accordance with their consent and within the legal framework of § 374a SGB V.

The key requirements for the pairing procedure are:

* **Consent-based** – Pairing MUST require the patient’s explicit and informed consent.
* **Fine-grained** – Consent MUST only apply to [Mandatory Interoperable Values](methodology.html#from-use-cases-to-mivs) (MIVs), not to the entire set of data gathered by a medical aid or implant.
* **Revocable** – The patient MUST be able to terminate pairing at any time.
* **Pseudonymous** – To comply with [data protection requirements](security-and-privacy.html#identification-and-authentication-of-the-patient), personal identifiers MUST NOT be exchanged between
  DiGA and Device Data Recorders.
* **Standardized** – The procedure MUST be implemented uniformly across all DiGA and Device Data Recorder manufacturers participating in the § 374a SGB V ecosystem.

From a technical perspective, the pairing process relies on OAuth 2.0 as the authorization framework, extended by SMART
scopes. Since data retrieval is performed via a RESTful FHIR API, [SMART scopes](smart-scopes.html) are used to align
access control directly with FHIR resource types and search parameters. This enables fine-grained access restrictions,
such as limiting a DiGA’s access to specific vital signs (e.g. blood glucose or blood pressure) or to particular device
information. By binding consent to concrete FHIR query constraints, patients gain precise and enforceable control
over which data elements are shared with a DiGA.

A further key element of the pairing process is the [__Pairing ID__](#pairing-id). This pseudonymous identifier links the patient’s
consent with the subsequent data transfer. It ensures that data flows can be traced back to a specific pairing of two odentified actors without revealing the patient’s identity.

To perform the pairing process, each Device Data Recorder MUST implement an OAuth2 Authorization Server. This document describes the role of the OAuth2 Authorization Server, the use of OAuth 2.0 and [SMART scopes](smart-scopes.html), the purpose of the Pairing ID, and a deep dive into the pairing process itself.

### OAuth2 Authorization Server Prerequisites

The OAuth2 Authorization Server of the Device Data Recorder plays a pivotal role in the pairing process. It is responsible for:
* triggering and deciding the existence of a valid consent of the affected patient.
* Verifying whether a DiGA is authorized to access specific data (is a registered client).
* Issuing OAuth 2.0 access tokens that enable secure communication between the DiGA and the Device Data Recorder's FHIR Resource Server.

In practice, the OAuth2 Authorization Server is the technical anchor for the entire pairing mechanism. It ensures that OAuth 2.0 is applied correctly and that [SMART scopes](smart-scopes.html) are enforced, while also binding consent and
subsequent data flows to the Pairing ID.

The OAuth2 Authorization Server follows the **OAuth 2.0 Authorization Code Flow with PKCE** and **Pushed Authorization
Requests (PAR)** over **mutual TLS (mTLS)**. Certificate-bound access tokens MUST NOT be used as mTLS already provides sufficient binding between client and server. A discovery document MUST be provided under the well-known path
`/.well-known/oauth-authorization-server` in accordance with [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414).

The authorization server MUST implement the following key RFCs and associated mechanisms:

| RFC                                                | Title                                                                     | Purpose / Scope in the § 374a SGB V Context                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|----------------------------------------------------|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749) | *The OAuth 2.0 Authorization Framework*                                   | Forms the foundation of the pairing process using the **Authorization Code Flow**. Other flow types MUST NOT be used.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009) | *OAuth 2.0 Token Revocation*                                              | Defines the revocation endpoint used by the DiGA to signal that user consent is no longer valid on the DiGA side. The revocation request triggers the withdrawal of consent in the Device Data Recorder for the patient associated with the pseudonymous Pairing ID. The OAuth2 Authorization Server MUST support this endpoint, perform Mutual-TLS client authentication and accept the following parameters:<br>• `client_id` <br>• `token` <br>• `token_type_hint=refresh_token` <br> Upon receiving a valid revocation request, the Authorization Server MUST invalidate the specified `refresh_token`, all `access_token` values issued under the same authorization grant, the authorization grant itself, and the stored user consent linked to the affected Pairing ID.                |
| [RFC 7636](https://www.rfc-editor.org/rfc/rfc7636) | *Proof Key for Code Exchange (PKCE)*                                      | Protects the authorization code flow from interception. The OAuth2 Authorization Server MUST enforce PKCE with the `S256` code challenge method for all public clients.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414) | *OAuth 2.0 Authorization Server Metadata*                                 | Defines the discovery document exposed at `/.well-known/oauth-authorization-server`. The metadata document MUST include at least the following attributes:<br>• `scopes_supported` (according to SMART Scope definitions)<br>• `grant_types_supported` = `authorization_code`<br>• `pushed_authorization_request_endpoint`<br>• `require_pushed_authorization_requests` = `true`<br>• `token_endpoint`<br>• `token_endpoint_auth_methods_supported` = `tls_client_auth`<br>• `revocation_endpoint`<br>• `revocation_endpoint_auth_methods_supported` = `tls_client_auth`<br>• `code_challenge_methods_supported` = `S256`<br>• `tls_client_certificate_bound_access_tokens` = `false`<br>• `service_documentation` (client registration info). <br>Signed metadata documents are NOT REQUIRED. |
| [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705) | *OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Tokens* | The mechanism for authenticating DiGA clients using mutual TLS (`tls_client_auth`) MUST be used. Certificate-bound access tokens from RFC 8705 MUST NOT be used.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126) | *OAuth 2.0 Pushed Authorization Requests (PAR)*                           | Ensures secure backend-to-backend transmission of authorization requests before user consent. The following attributes MUST be used: <br>•`client_id` <br>•`scope` <br>•`code_challenge` <br>•`code_challenge_method=S256` <br>•`redirect_uri` <br>•`state` <br>•`response_type=code` <br><br>Both the `request` attribute and [RFC 9101 (JWT-Secured Authorization Request)](https://datatracker.ietf.org/doc/rfc9101/) MUST NOT be used.                                                                                                                                                                                                                                                                                                                                                     |
| [RFC 9700](https://www.rfc-editor.org/rfc/rfc9700) | *Best Current Practice for OAuth 2.0 Security*                            | Consolidates and extends security best practices for OAuth 2.0 and adds further important recommendations (e.g., strict redirect URI validation, PKCE enforcement, refresh token protection/rotation) that MUST be applied by the OAuth2 Authorization Server.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

The listed requirements are based on open, established standards and will not be explained in detail in this
specification. For further information, please refer to the respective RFC documents.

#### Client Registration

The provider of the Device Data Recorder is responsible for configuring OAuth 2.0 clients that represent authorized DiGA in the
Device Data Recorder's OAuth2 Authorization Server. Other than properly registered DiGAs MUST NOT obtain access tokens and MUST NOT access any data through the APIs of the Device Data Recorder's FHIR Resource Server.

For a DiGA to be registered as a client with the Device Data Recorder's OAuth2 Authorization Server, it MUST be listed in the BfArM _DiGA VZ_ (DiGA Registry) according to § 139e SGB V. The registration data and [trust attributes](security-and-privacy.html#identification-and-authentication-of-the-diga) kept by the Device Data Recorder MUST originate from verified information in the _DiGA-VZ_ as provided by BfArM.

Each registered DiGA's client configuration MUST include the attributes listed below. These attributes establish the trust
relationship between the DiGA and the OAuth2 Authorization Server and determine which FHIR resources may be accessed from the Device Data Recorder's FHIR Resource Server.

| Attribute                  | Description                                                                  | Requirement                                                                                                                                                                                                                                                                                                                          |
|----------------------------|------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **client_id**              | Unique identifier of the DiGA on application level used in OAuth 2.0 flows.  | MUST correspond to the value stored in the _DiGA-VZ_ and follow the structure `urn:diga:bfarm:{DiGA-ID}` where `{DiGA-ID}` is the unique five-digit identifier of the DiGA as published in the _DiGA-VZ_.                                                                                                                            |
| **scopes**                 | SMART scopes defining the DiGA’s authorized access to medical device data.             | MUST contain the SMART scopes for each [supported MIV](mivs.html). Each scope represents permission to access specific FHIR [Observation](https://hl7.org/fhir/R4/observation.html) resources and the related [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) resources. |
| **redirect_uri**           | Redirect target for the OAuth 2.0 Authorization Code Flow.                   | Serves as a security anchor ensuring that authorization codes are returned only to registered and verified DiGA endpoints. MUST exactly match the URI registered in the _DiGA-VZ_ (strict comparison MUST be performed).                                                                                                             |
| **tls_client_certificate** | TLS client certificate identifying the DiGA backend for mTLS authentication. | MUST uniquely identify the DiGA backend. The certificate typically renews annually or earlier if revoked. The OAuth2 Authorization Server MUST validate that the presented certificate matches the one registered in the DiGA-VZ at connection time. A certificate MAY be cached (see [Caching of Trust-Related Information](security-and-privacy.html#caching-of-trust-related-information)).                                             |

The provider of the Device Data Recorder MUST ensure that all client registrations remain synchronized with the _DiGA-VZ_. If a DiGA is
removed, retired, or its authorization attributes change, the corresponding client configuration MUST be updated or
revoked without undue delay (see also [Obligations for Regular Inspections](security-and-privacy.html#obligations-for-regular-inspections)).

The set of supported [SMART scopes](smart-scopes.html) MUST also be published in the OAuth2 Authorization Server’s metadata
document as defined in [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414). Only scopes corresponding to the Device Data Recorder’s supported MIVs may be exposed. Any change in supported scopes, endpoints, or client configurations MUST be reflected in the discovery metadata without undue delay.

#### Consent for Fine-Grained Access

The Device Data Recorder's OAuth2 Authorization Server is responsible for displaying and managing the patient’s consent. During the pairing process, the server MUST present a consent dialogue to the patient that clearly lists all requested data
categories represented by SMART scopes.

The consent dialogue MUST display the requested access rights in a human-readable and comprehensible form. Each SMART
scope represents a distinct category of data — typically corresponding to one MIV — and MUST be shown as an individual,
selectable consent option. The patient MUST be able to grant or deny access for each category separately.

The consent granted by the patient MUST be explicit, informed, and bound to the individual SMART scopes selected
during pairing. Consent MUST be linked to the corresponding [Pairing ID](#pairing-id). The OAuth2 Authorization Server MUST ensure that
consent is collected and recorded before issuing any access or refresh tokens to the DiGA, and that token issuance and
subsequent data access remain limited to the consented scopes and the patient associated with the specific Pairing ID.

The Authorization Server MUST validate requested scopes against the DiGA-VZ entry for the client and strictly verify
that each referenced ValueSet URL used within SMART scopes matches the DiGA’s registered permissions. If scopes or
parameter syntax deviate from the defined SMART scope format the authorization MUST be rejected.

The patient MUST be able to withdraw consent at any time, which immediately invalidates the associated authorization
grant, refresh token, and any active access tokens.

The technical enforcement of scopes on the resource server is described separately in the chapter
on [SMART scopes](smart-scopes.html).

### Pairing ID

The Pairing ID is a pseudonymous identifier that defines the coupling context between a DiGA and a Device Data Recorder. It ensures that consent, authorization, and subsequent data flows can be securely linked without
exposing any real-world identifiers of the patient. By design, it prevents disclosure of internal user IDs or
personal information (such as email addresses) while still allowing precise assignment of consent and the creation of
audit trails.

The Pairing ID MUST adhere to the following properties:

| **Property**            | **Requirement**                                                                                                                                                                                                                          |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Authoritative**       | The Pairing ID MUST always be generated by the OAuth2 Authorization Server when a new pairing is established. <br>The DiGA and the patient MUST NOT participate in generating the identifier.                                            |
| **Unique**              | The Pairing ID MUST be unique at least within each Device Data Recorder. <br>If the same patient pairs with multiple DiGAs, each pairing MUST result in a distinct Pairing ID.                                                 |
| **Unpredictable**       | The Pairing ID MUST NOT be guessable; it must be sufficiently long, random, and unpredictable.                                                                                                                                           |
| **Anonymous**           | The Pairing ID MUST NOT allow any conclusions about the real-world identity of the patient.                                                                                                                                              |
| **Stable and Retained** | The Pairing ID MUST be created once during the pairing sequence after the patient has authenticated and given consent. <br>It MUST remain stable for the entire lifetime of the pairing and MUST be retained by the Device Data Recorder. |

To meet these requirements, the Pairing ID SHOULD be derived from a combination of internal attributes and a secret
random value (salt) that is known only to the Device Data Recorder. This approach ensures that the Pairing ID is both
unique and stable, while also being resistant to brute-force or guessing attacks. A sample construction is:

```
PairingID = Hash(DiGA-ID, internal User-ID, Salt)
```

where

- `Salt` is a secret random value of sufficient length (e.g., 128 bits) that is securely stored with the Device Data
  Recorder and
- `Hash` is a secure hash function like SHA-256.

### Tokens and the Token Response

OAuth 2.0 access and refresh tokens are the core security artifacts enabling a DiGA to retrieve data from the Device Data Recorder's FHIR Resource Server in
accordance with the patient’s consent. The OAuth2 Authorization Server is responsible for issuing, validating,
signing, and revoking these tokens.

#### Access Tokens

* The OAuth2 Authorization Server MUST issue an access token upon successful completion of the OAuth 2.0 Authorization Code
  Flow with PKCE ([RFC 6749](https://www.rfc-editor.org/info/rfc6749), 
  [RFC 7636](https://www.rfc-editor.org/info/rfc7636)).
* The access token MAY be represented either as an opaque token or as a self-encoded JSON Web Token (
  JWT, [RFC 7519](https://www.rfc-editor.org/info/rfc7519)).
* Access and refresh tokens MUST be cryptographically signed by the OAuth2 Authorization Server and MUST be verified for
  authenticity and integrity at each endpoint that is exposed to external parties by the Device Data Recorder.
* The lifetime of an access token is defined by the provider of the Device Data Recorder. The provider SHALL balance availability (
  e.g., load on the token endpoint) and security considerations when choosing the expiration period.
* If the access token is represented as a JWT and includes the `sub` claim, it MUST contain the Pairing-ID and MUST NOT
  contain any internal user identifiers or personal identifiers.
* Token use MUST be secured via mutual TLS (mTLS, [RFC 8705](https://www.rfc-editor.org/info/rfc8705)) between the DiGA
  and the Device Data Recorder. Certificate-bound and session-bound tokens MUST NOT be used, as mTLS already provides sufficient binding
  between client and server.

#### Refresh Tokens

* The OAuth2 Authorization Server MUST issue a refresh token together with the access token.
* The refresh token MUST have a lifetime of 30 days to allow continued access without further user interaction
  while maintaining revocation capability in line with patient consent.
* Refresh tokens MUST be revocable by the DiGA via the revocation
  endpoint ([RFC 7009](https://www.rfc-editor.org/info/rfc7009)).
* If the patient withdraws consent (regardless if via the DiGA or directly at the Device Data Recorder), all tokens
  associated with the Pairing ID MUST be invalidated immediately.

#### Token Response

* The token endpoint response MUST include the claims listed below in a JSON body:
  * `access_token` 
  * `refresh_token` 
  * `token_type`
  * `expires_in` 
  * `scope`
  * `sub`
* The claim `sub` MUST be carrying the Pairing ID
* The access token format (JWT vs. opaque) and claim structure MAY vary between Device Data Recorders, provided all normative
  requirements above are met.
* All token exchanges MUST take place over a mutually authenticated TLS channel, ensuring confidentiality and integrity
  of the authorization process.

An example token response (with a JWT access token) is shown below:

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 600,
  "refresh_token": "9e35d65d-ec12-4b8d-a8b1-dff2f7cf6a5e",
  "scope": "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-blood-glucose-measurement patient/Device.rs patient/DeviceMetric.rs",
  "sub": "8c9a85fe78f6ccd91a62aff2bf7cf3ea4929a8f1ccbd24f2874ab853fe4815fc"
}
```

### Pairing Sequence

The following diagram illustrates the detailed sequence of interactions during the pairing process between the patient,
the DiGA, and the Device Data Recorder. Each step is explained in detail below.

<figure>
<div class="gem-ig-svg-container" style="width: 100%;">
  {% include pairing_sequence_detailed.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Perform Pairing between DiGA and Device Data Recorder (detailed)</em></figcaption>
</figure>
<br>

| Process Step                                             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. Patient initiates Pairing with a Device Data Recorder | After logging into the **DiGA** (login is out of scope), the **patient** starts pairing in the DiGA frontend. The **DiGA** shows a list of compatible Device Data Recorders and the permissions it will request (based on the Device Data Recorder’s published scopes). The patient selects a Device Data Recorder and **confirms the requested permissions**. <br><br> **Failure case:** If the patient cancels, no pairing request is initiated.                                                                                                                                                                                                                                                                                                      |
| 2. Send Authorization Request to Device Data Recorder    | The **DiGA** fetches the OAuth2 Authorization Server Metadata from `/.well-known/oauth-authorization-server` and identifies endpoints and required scopes (e.g., MIV ValueSets). It generates PKCE artifacts and sends a **Pushed Authorization Request (PAR)** containing `client_id`, `redirect_uri`, scopes, and PKCE via **mutual TLS (`tls_client_auth`)**. The **DiGA** validates the Device Data Recorder’s FQDN and certificate; the **Authorization Server** authenticates the DiGA via `client_id` and certificate, validates the PAR (including `redirect_uri` and scopes), stores it, and returns a **`request_uri`** with **`expires_in`**. <br><br> **Failure case:** On validation failure, an error (e.g., `400` or `401`) is returned. |
| 3. Authorization Confirmation by patient                 | The **DiGA** redirects the user agent to the Device Data Recorder’s **`/authorize`** endpoint with the **`request_uri`**. The **Authorization Server** loads the stored PAR data and initiates login via system browser (or deep link). After login (out of scope), the **Device Data Recorder frontend** presents the DiGA’s requested permissions; the **patient approves or denies**. If approved, the server **locates or generates a Pairing ID** and **creates a consent** linked to the Pairing ID and the patient’s identity on the Device Data Recorder side. <br><br> **Failure case:** If consent is denied, no tokens are issued and the flow ends.                                                                                         |
| 4. Perform Authorization                                 | The **Authorization Server** redirects the user agent to the **DiGA** with an **authorization code**. The **DiGA** exchanges the code at **`/token`** over **mTLS** with PKCE verifier and `client_id`. The **DiGA** again validates the Device Data Recorder’s FQDN and certificate; the **Authorization Server** authenticates the DiGA (certificate + `client_id`), verifies PKCE and code, and returns a **token response** containing: **access token**, **refresh token**, **granted `scope`**, and the **Pairing ID** in the JSON body (and, if JWT access tokens are used, also as the `sub` claim). <br><br> **Failure case:** If the code is invalid/expired, the Authorization Server returns `400` or `403`.                                |
| 5. Complete Pairing                                      | The **DiGA backend** records its **local consent** for the Pairing ID, including the **prescription/entitlement expiration date**, and links it to the patient’s identity in the DiGA context. The **DiGA frontend** confirms successful pairing to the patient. <br><br> **Failure case:** If local persistence fails, pairing may need to be re-initiated.                                                                                                                                                                                                                                                                                                                                                                                            |

<br>

### Unpairing by the patient

The unpairing process allows the patient to terminate the connection between their DiGA and their Device Data Recorder.
The patient can initiate unpairing directly from the DiGA or from the Device Data Recorder. Each scenario is explained
in detail below.

<figure>
<div class="gem-ig-svg-container" style="width: 75%;">
  {% include unpairing_by_patient.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>Patient-Initiated Consent Revocation</em></figcaption>
</figure>

<br>

| Process Step                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Revocation at the DiGA                 | The **patient** initiates revocation of consent for a specific Pairing ID in the **DiGA frontend**. The **DiGA backend** invalidates the associated consent and sends a revocation request to the **OAuth2 Authorization Server** of the **Device Data Recorder** at the `/revoke` endpoint. Client authentication is performed via **mutual TLS (`tls_client_auth`)**, where both parties verify each other's X.509 certificates (the DiGA validates the Device Data Recorder’s FQDN and certificate; the Authorization Server authenticates the DiGA by its `client_id` and certificate). The Authorization Server invalidates all authorization artifacts linked to the Pairing ID — including the authorization grant, refresh token, access tokens, and stored consent — and responds with `HTTP 200 OK`. The **DiGA frontend** then displays a confirmation that the pairing has been successfully revoked. <br><br> **Failure case:** If the refresh token is already invalid, the Authorization Server may still return `HTTP 200 OK` in accordance with [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009). |
| Revocation at the Device Data Recorder | The **patient** may alternatively initiate revocation in the **frontend of the Device Data Recorder**. The **OAuth2 Authorization Server** invalidates all authorization artifacts (authorization grant, refresh token, access tokens, and stored consent) linked to the Pairing ID and confirms the revocation to the patient. <br><br> After revocation, any data request from the **DiGA** to the Device Data Recorder’s **FHIR Resource Server** fails with `HTTP 401 Unauthorized` and an `invalid_token` error. If the **DiGA** subsequently attempts to refresh its tokens at the `/token` endpoint using the revoked refresh token, the Authorization Server authenticates the client via **mTLS**, rejects the request with `HTTP 400 Bad Request` and `invalid_grant`, and the **DiGA backend** invalidates its local consent record. Optionally, the **DiGA frontend** may inform the patient that consent and pairing have been revoked. <br><br> **Failure case:** If the DiGA does not properly handle `401` or `400` errors, it may continue attempting to use invalid tokens until corrected.        |

<br>

### Unpairing by the System

The unpairing process initiated by the system allows for the automatic termination of the connection between a DiGA and
a Device Data Recorder under specific conditions.

<figure>
<div class="gem-ig-svg-container" style="width: 100%;">
  {% include unpairing_by_system.svg %}
  </div>
    <figcaption><em><strong>Figure: </strong>System-Initiated Revocation of Authorizations</em></figcaption>
</figure>
<br>

| Process Step                                                         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. Prescription duration for Pairing ID expired                      | The **DiGA backend** periodically checks whether the consent associated with a Pairing ID is still valid by comparing the current system time with the prescription’s expiry date. If the prescription is about to expire, the **DiGA frontend** informs the patient. Once expired, the **DiGA backend** invalidates the local consent and sends a revocation request to the **OAuth2 Authorization Server** of the **Device Data Recorder** at the `/revoke` endpoint. Authentication is performed via **mutual TLS (`tls_client_auth`)**, where both systems validate each other’s X.509 certificates (the DiGA verifies the Device Data Recorder’s FQDN and certificate; the Authorization Server authenticates the DiGA by its `client_id` and certificate). The Authorization Server invalidates all authorization artifacts linked to the Pairing ID—authorization grant, refresh token, access tokens, and stored consent—and responds with `HTTP 200 OK`. The **DiGA frontend** then confirms to the patient that the pairing has been successfully revoked. <br><br> **Failure case:** If the DiGA fails to trigger revocation, tokens may remain apparently valid until they expire naturally.                                                                                                                    |
| 2. DiGA loses authorization for interface acc. § 374a SGB V          | The **manufacturer** of the **DiGA** or the **Device Data Recorder** queries the _DiGA-VZ_ (BfArM DiGA Registry) to verify the DiGA’s status (`client_id`). If the registry indicates that the DiGA is **retired** or not found (HTTP `404 Not Found`), the **Device Data Recorder’s manufacturer** instructs its **OAuth2 Authorization Server** to revoke all authorizations linked to the affected Pairing IDs. The server invalidates the authorization grant, refresh token, access tokens, stored consent, and deregisters the DiGA. The **Device Data Recorder frontend** then notifies the patient about the revoked consent. <br><br> Subsequent DiGA data requests to the Device Data Recorder’s **FHIR Resource Server** fail with `HTTP 401 Unauthorized` and an `invalid_token` error. If the DiGA attempts to refresh tokens at the `/token` endpoint, the Authorization Server—after mutual TLS authentication—returns either `HTTP 400 Bad Request` (`invalid_grant`) or `HTTP 401 Unauthorized` (if the DiGA has already been deregistered). The **DiGA backend** invalidates the local consent record and MAY inform the patient. <br><br> **Failure case:** If the DiGA ignores registry updates or continues to use stale credentials, it may repeatedly attempt to use invalid tokens until corrected. |
| 3. Device Data Recorder no longer offers interface acc. § 374a SGB V | The **manufacturer** of the **DiGA** or the **Device Data Recorder** queries the _HIIS-VZ_ (BfArM Device Registry) to verify the Device Data Recorder’s status. If the registry indicates that the Device Data Recorder is **retired** or not found (HTTP `404 Not Found`), the **DiGA backend** invalidates the consent for the affected Pairing IDs and initiates a revocation request to the Device Data Recorder’s **OAuth2 Authorization Server** at the `/revoke` endpoint. Mutual TLS authentication is used, and both endpoints validate their X.509 certificates. The Authorization Server invalidates the authorization grant, refresh token, access tokens, and stored consent. If the Device Data Recorder’s Authorization Server is still reachable, it responds with `HTTP 200 OK`; if it is offline or the DiGA has been deregistered, a timeout occurs, and the **manufacturer** instructs the **DiGA** to locally invalidate consent. The **manufacturer** also ensures that configurations specific to the retired Device Data Recorder are removed. Finally, the **DiGA frontend** notifies the patient that the pairing and consent have been revoked. <br><br> **Failure case:** If the DiGA backend fails to remove old configurations, the patient may continue to see outdated device options.      |