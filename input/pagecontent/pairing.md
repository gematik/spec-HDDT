The pairing procedure is the central mechanism for securely connecting a medical aid or implant (HiMi) with a digital
health application (DiGA). The goal is to enable insured persons to use health data collected by their HiMi in a DiGA in
accordance with their consent, within the framework of § 374a SGB V.

The key requirements for the pairing procedure are:

* **Consent-based** – Pairing requires the insured person’s explicit and informed consent.
* **Fine-grained** – Consent applies to Mandatory Interoperable Values (MIVs), not to the entire device.
* **Revocable** – The insured person MUST be able to terminate pairing at any time.
* **Pseudonymous** – To comply with data protection requirements, no personal identifiers MAY be exchanged between
  DiGa
  and medical aid or implant.
* **Standardized** – The procedure MUST be implemented uniformly across all DiGA and HiMi manufacturers participating
  under § 374a SGB V.

From a technical perspective, the pairing process relies on OAuth 2.0 as the authorization framework, extended by SMART
scopes. Since data retrieval is performed via a RESTful FHIR API, [SMART scopes](smart-scopes.html) are used to align
access control directly with FHIR resource types and search parameters. This enables fine-grained access restrictions,
such as limiting a DiGA’s access to specific vital signs (e.g. blood glucose or blood pressure) or to particular device
definitions. By binding consent to concrete FHIR query constraints, insured persons gain precise and enforceable control
over which data elements are shared with a DiGA.

A further key element of the pairing process is the pairing ID. This pseudonymous identifier links the insured person’s
consent with the subsequent data transfer. It ensures that data flows can be traced back to a specific pairing without
revealing the insured person’s identity.

This document describes the role of the authorization server, the use of OAuth 2.0
and [SMART scopes](smart-scopes.html), the purpose of the pairing ID, and a deep dive in the pairing process itself.

### Authorization Server Prerequisites

The authorization server of the medical aid or implant plays a pivotal role in the pairing process. It is responsible
for:

* Managing the insured person’s consent.
* Verifying whether a DiGA is authorized to access specific data (is a registered client).
* Issuing OAuth 2.0 access tokens that enable secure communication between the DiGA and the HiMi.

In practice, the authorization server is the technical anchor for the entire pairing mechanism. It ensures that OAuth
2.0 is applied correctly and that [SMART scopes](smart-scopes.html) are enforced, while also binding consent and
subsequent data flows to the Pairing ID.

The authorization server follows the **OAuth 2.0 Authorization Code Flow with PKCE** and **Pushed Authorization
Requests (PAR)** over **mutual TLS (mTLS)**. Certificate-bound access tokens MUST NOT be used; mutual TLS serves solely
for client authentication. A discovery document MUST be provided under the well-known path
`/.well-known/oauth-authorization-server` in accordance with [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414).

The authorization server MUST implement the following key RFCs and associated mechanisms:

| RFC                                                | Title                                                                     | Purpose / Scope in the § 374a SGB V Context                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|----------------------------------------------------|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749) | *The OAuth 2.0 Authorization Framework*                                   | Forms the foundation of the pairing process using the **Authorization Code Flow**. Only this flow type is supported.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009) | *OAuth 2.0 Token Revocation*                                              | Defines the revocation endpoint used by the DiGA to withdraw consent and invalidate refresh and access tokens. The HiMi authorization server MUST support this endpoint.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [RFC 7636](https://www.rfc-editor.org/rfc/rfc7636) | *Proof Key for Code Exchange (PKCE)*                                      | Protects the authorization code flow from interception. The HiMi authorization server MUST enforce PKCE with the `S256` code challenge method for all public clients.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414) | *OAuth 2.0 Authorization Server Metadata*                                 | Defines the discovery document exposed at `/.well-known/oauth-authorization-server`. The metadata document MUST include at least the following attributes:<br>• `scopes_supported` (according to SMART Scope definitions)<br>• `grant_types_supported` = `authorization_code`<br>• `pushed_authorization_request_endpoint`<br>• `require_pushed_authorization_requests` = `true`<br>• `token_endpoint`<br>• `token_endpoint_auth_methods_supported` = `tls_client_auth`<br>• `revocation_endpoint`<br>• `revocation_endpoint_auth_methods_supported` = `tls_client_auth`<br>• `code_challenge_methods_supported` = `S256`<br>• `tls_client_certificate_bound_access_tokens` = `false`<br>• `service_documentation` (client registration info). <br>Signed metadata documents are NOT REQUIRED. |
| [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705) | *OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Tokens* | Provides the mechanism for authenticating DiGA clients using mutual TLS (`tls_client_auth`). Certificate-bound access tokens from RFC 8705 MUST NOT be used.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126) | *OAuth 2.0 Pushed Authorization Requests (PAR)*                           | Ensures secure backend-to-backend transmission of authorization requests before user consent. The following attributes MUST be used: <br>•`client_id` <br>•`scope` <br>•`code_challenge` <br>•`code_challenge_method=S256` <br>•`redirect_uri` <br>•`state` <br>•`response_type=code` <br><br>Neither the `request` attribute, nor [RFC 9101 (JWT-Secured Authorization Request)](https://datatracker.ietf.org/doc/rfc9101/) SHALL be used.                                                                                                                                                                                                                                                                                                                                                                                     |

The listed requirements are based on open, established standards and will not be explained in detail in this
specification. For further information, please refer to the respective RFC documents.

#### Client Registration

The HiMi manufacturer is responsible for configuring OAuth 2.0 clients that represent authorized DiGAs in the
authorization server. Only properly registered DiGAs MAY obtain access tokens and access the HiMi’s FHIR resources in
accordance with the insured person’s consent.

A DiGA MUST only be registered as a client if it is listed in the official DiGA directory (DiGA-VZ) according to § 139e
SGB V. The registration data and trust attributes MUST originate from verified information in the DiGA-VZ as provided by
BfArM.

Each registered DiGA client configuration MUST include the attributes listed below. These attributes establish the trust
relationship between the DiGA and the HiMi authorization server and determine which FHIR resources may be accessed.

| Attribute                  | Description                                                                  | Requirement                                                                                                                                                                                                                                   |
|----------------------------|------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **client_id**              | Unique identifier of the DiGA on application level used in OAuth 2.0 flows.  | MUST correspond to the value stored in the DiGA-VZ and follow the structure `urn:diga:bfarm:{DiGA-ID}` where `{DiGA-ID}` is the unique five-digit identifier of the DiGA as published in the DiGA directory.                                  |
| **scopes**                 | SMART scopes defining the DiGA’s authorized access to HiMi data.             | MUST contain the SMART scopes for each supported MIV. Each scope represents permission to access specific FHIR Observation resources and the related Device / DeviceMetric resources.                                                         |
| **redirect_uri**           | Redirect target for the OAuth 2.0 Authorization Code Flow.                   | Serves as a security anchor ensuring that authorization codes are returned only to registered and verified DiGA endpoints. MUST exactly match the URI registered in the DiGA-VZ (strict comparison).                                          |
| **tls_client_certificate** | TLS client certificate identifying the DiGA backend for mTLS authentication. | MUST uniquely identify the DiGA backend. The certificate typically renews annually or earlier if revoked. The authorization server MUST validate that the presented certificate matches the one registered in the DiGA-VZ at connection time. |

The HiMi manufacturer MUST ensure that all client registrations remain synchronized with the DiGA-VZ. If a DiGA is
removed, retired, or its authorization attributes change, the corresponding client configuration MUST be updated or
revoked without undue delay.

The set of supported [SMART scopes](smart-scopes.html) MUST also be published in the authorization server’s metadata
document as defined in [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414). Only scopes corresponding to the HiMi’s
supported MIVs may be exposed. Any change in supported scopes, endpoints, or client configurations MUST be reflected in
the discovery metadata without undue delay.

#### Consent for Fine-Grained Access

The authorization server of the HiMi is responsible for obtaining and managing the insured person’s consent. During the
pairing process, the server MUST present a consent dialogue to the insured person that clearly lists all requested data
categories represented by SMART scopes.

The consent dialogue MUST display the requested access rights in a human-readable and comprehensible form. Each SMART
scope represents a distinct category of data — typically corresponding to one MIV — and MUST be shown as an individual,
selectable consent option. The insured person MUST be able to grant or deny access for each category separately.

The consent granted by the insured person MUST be explicit, informed, and bound to the individual SMART scopes selected
during pairing. Consent MUST be linked to the corresponding Pairing ID. The authorization server MUST ensure that
consent is collected and recorded before issuing any access or refresh tokens to the DiGA, and that token issuance and
subsequent data access remain limited to the consented scopes and the specific Pairing ID.

The Authorization Server MUST validate requested scopes against the DiGA-VZ entry for the client and strictly verify
that each referenced ValueSet URL used within SMART scopes matches the DiGA’s registered permissions. If scopes or
parameter syntax deviate from the defined SMART scope format the authorization MUST be rejected.

Consent decisions MUST be stored securely and in an auditable manner, allowing verification of consent history,
versioning, and revocation actions. This is true for both the HiMi authorization server and the DiGA, which also MUST
maintain a local record of consent associated with each Pairing ID. The insured person MUST be able to withdraw consent
at any time, which immediately invalidates the associated authorization grant, refresh token, and any active access
tokens. All consent grants and revocations MUST be logged in a tamper-resistant audit trail.

The technical enforcement of scopes on the resource server is described separately in the chapter
on [SMART scopes](smart-scopes.html).

### Pairing ID

The Pairing ID is a pseudonymous identifier that defines the coupling context between a DiGA and a medical aid or
implant (HiMi). It ensures that consent, authorization, and subsequent data flows can be securely linked without
exposing any real-world identifiers of the insured person. By design, it prevents disclosure of internal user IDs or
personal information (such as email addresses) while still allowing precise assignment of consent and the creation of
audit trails.

The Pairing ID MUST adhere to the following properties:

| **Property**            | **Requirement**                                                                                                                                                                                                                          |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Authoritative**       | The Pairing ID MUST always be generated by the HiMi Authorization Server when a new pairing is established. <br>Neither the DiGA nor the insured person MAY participate in generating the identifier.                                    |
| **Unique**              | The Pairing ID MUST be unique **at least within each HiMi system**. <br>If the same insured person pairs with multiple DiGAs, each pairing MUST result in a distinct Pairing ID.                                                         |
| **Unpredictable**       | The Pairing ID MUST NOT be guessable; it must be sufficiently long, random, and unpredictable.                                                                                                                                           |
| **Anonymous**           | The Pairing ID MUST NOT allow any conclusions about the real-world identity of the insured person.                                                                                                                                       |
| **Stable and Retained** | The Pairing ID MUST be created once during the pairing sequence after the insured person has authenticated and given consent. <br>It MUST remain stable for the entire lifetime of the pairing and MUST be retained by the HiMi backend. |

To meet these requirements, the Pairing ID SHOULD be derived from a combination of internal attributes and a secret
random value (salt) that is known only to the Device Data Recorder. This approach ensures that the Pairing ID is both
unique and stable, while also being resistant to brute-force or guessing attacks. A sample construction is:

```
PairingID = Hash(DiGA-ID, User-ID, Salt)
```

where

- `Salt` is a secret random value of sufficient length (e.g., 128 bits) that is securely stored with the Device Data
  Recorder and
- `Hash` is a secure hash function like SHA-256.

### Tokens and the Token Response

OAuth 2.0 access and refresh tokens are the core security artifacts enabling a DiGA to retrieve data from a HiMi in
accordance with the insured person’s consent. The HiMi authorization server is responsible for issuing, validating,
signing, and revoking these tokens.

#### Access Tokens

* The authorization server MUST issue an access token upon successful completion of the OAuth 2.0 Authorization Code
  Flow with PKCE ([RFC 6749](https://www.rfc-editor.org/info/rfc6749), 
  [RFC 7636](https://www.rfc-editor.org/info/rfc7636)).
* The access token MAY be represented either as an opaque token or as a self-encoded JSON Web Token (
  JWT, [RFC 7519](https://www.rfc-editor.org/info/rfc7519)).
* Access and refresh tokens MUST be cryptographically signed by the HiMi authorization server and MUST be verified for
  authenticity and integrity at each HiMi endpoint.
* The lifetime of an access token is defined by the HiMi manufacturer. The manufacturer SHALL balance availability (
  e.g., load on the token endpoint) and security considerations when choosing the expiration period.
* If the access token is represented as a JWT and includes the `sub` claim, it MUST contain the Pairing-ID and MUST NOT
  contain any internal user identifiers or personal identifiers.
* Token use MUST be secured via mutual TLS (mTLS, [RFC 8705](https://www.rfc-editor.org/info/rfc8705)) between the DiGA
  and the HiMi. No certificate-bound or session-bound tokens SHALL be used, as mTLS already provides sufficient binding
  between client and server.

#### Refresh Tokens

* The authorization server MUST issue a refresh token together with the access token.
* The refresh token MUST be valid for at exactly 30 days to allow continued access without further user interaction
  while maintaining revocation capability in line with patient consent.
* Refresh tokens MUST support rotation: each use of a refresh token to obtain a new access token MUST result in a new
  refresh token, and the previous one MUST be invalidated.
* Refresh tokens MUST be revocable by the DiGA via the revocation
  endpoint ([RFC 7009](https://www.rfc-editor.org/info/rfc7009)).
* If the insured person withdraws consent, the corresponding refresh token and all access tokens derived from it MUST be
  invalidated immediately.

#### Token Response

* The token endpoint response MUST include the claims listed below in a JSON body:
  * `access_token` 
  * `refresh_token` 
  * `token_type`
  * `expires_in` 
  * `scope`
  * `sub`
* The claim `sub` MUST be carrying the Pairing ID
* The access token format (JWT vs. opaque) and claim structure MAY vary between manufacturers, provided all normative
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

The following diagram illustrates the detailed sequence of interactions during the pairing process between the insured
person,
the DiGA, and the HiMi. Each step is explained in detail below.

<div style="width: 100%;">
  <img src="assets/images/pairing_sequence_detailed.svg" style="width: 100%;" />
</div>

<br>

| Process Step                                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. Insured Person Initiates HiMi Pairing        | The process begins after the **insured person** logs into the **DiGA** (login is out of scope of this specification). Within the DiGA frontend, the insured person selects the option to pair with a HiMi. The **DiGA** presents a list of compatible HiMi systems and available sensors or devices; the insured person selects the desired options. Finally, the **DiGA** displays the permissions ([SMART scopes](smart-scopes.html)) it intends to request, so the insured person can preview which types of data will later be shared. <br><br> **Failure case:** If the insured person cancels here, no pairing request is initiated.                                                                                                                                                                                                  |
| 2. Send Authorization Request to HiMi           | The **DiGA** retrieves the HiMi Authorization Server Metadata from [`/.well-known/oauth-authorization-server`](authorization-server-metadata-endpoint.html) to learn about supported endpoints, grant types, and scopes. It then determines the exact scopes required (e.g., specific MIV ValueSets) and generates PKCE parameters. Using mutual TLS, the **DiGA** submits a [Pushed Authorization Request (PAR)](authorization-server-par-endpoint.html) with details such as `client_id`, `redirect_uri`, scope, and PKCE parameters. The **HiMi Authorization Server** authenticates the DiGA via X.509 certificates, validates the request, persists it, and responds with a `request_uri`. <br><br> **Failure case:** If validation fails, the HiMi responds with an error (e.g., `400` or `401`).                                     |
| 3. Authorization Confirmation by Insured Person | The **DiGA** redirects the **insured person’s** browser to the HiMi Authorization Server’s [`/authorize`](authorization-server-authorization-endpoint.html) endpoint, using the `request_uri` from step 2. The insured person logs into the **HiMi** (login itself is out of scope). The **HiMi** presents a consent dialogue showing the requested [SMART scopes](smart-scopes.html), mapped to categories like “blood glucose” or “blood pressure.” The insured person approves or denies the request. If pairing is approved, the **HiMi** either retrieves an existing Pairing ID for this DiGA or generates a new one, linking it to the insured person’s account and consent record. Consent is then stored and bound to the Pairing ID. <br><br> **Failure case:** If consent is denied, the flow terminates without issuing tokens. |
| 4. Perform Authorization                        | After consent, the **HiMi Authorization Server** redirects the user agent back to the **DiGA’s** `redirect_uri` with an authorization code. The **DiGA** exchanges this code at the [`/token`](authorization-server-token-endpoint.html) endpoint over mutual TLS, providing the code, client credentials, and PKCE verifier. The **HiMi** validates the request, authenticates the DiGA, and verifies the PKCE challenge. If successful, it issues a token response containing an access token (short-lived), a refresh token (long-lived with rotation), the granted scopes, and the Pairing ID (in the JSON body and, if JWT is used, also as a claim in the token). <br><br> **Failure case:** If the authorization code is invalid or expired, the HiMi responds with `403` or `400`.                                                  |
| 5. Complete Pairing                             | The **DiGA** stores the resulting state locally, including the Pairing ID, granted scopes, and, where applicable, the prescription or entitlement expiration date. It links this information to its internal consent record to support auditing and revocation handling. Finally, the **DiGA frontend** confirms to the insured person that the pairing has been successfully established. <br><br> **Failure case:** If state persistence fails on the DiGA side, pairing may need to be re-initiated.                                                                                                                                                                                                                                                                                                                                     |

<br>

### Unpairing by the Insured Person

The unpairing process allows the insured person to terminate the connection between their DiGA and the medical aid or
implant (HiMi). Each step is explained in detail below.

<div style="width: 75%;">
  <img src="assets/images/unpairing_by_patient.svg" style="width: 100%;" />
</div>

<br>

| Process Step                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. Revocation at the Diga           | The **insured person** initiates revocation of consent for a specific Pairing ID in the **DiGA frontend**. The **DiGA backend** marks the associated consent as invalid and sends a revocation request to the **HiMi Authorization Server’s** [`/revoke`](authorization-server-revocation-endpoint.html) endpoint, including the Pairing ID and refresh token. The **HiMi** invalidates the authorization grant, refresh token, any active access tokens, and the stored consent. It responds with HTTP `200 OK`, and the **DiGA frontend** displays a confirmation that the pairing has been successfully revoked. <br><br> **Failure case:** If the refresh token is already invalid, the HiMi may still return HTTP 200 (per RFC 7009).                                                                                                                                                                                                                                                   |
| 2. Revocation at the Medical Device | The **insured person** initiates revocation for a specific Pairing ID in the **HiMi frontend**. The **HiMi Authorization Server** invalidates the authorization grant, refresh token, any active access tokens, and the stored consent. The **HiMi frontend** confirms revocation to the insured person. <br><br> After revocation, if the **DiGA** attempts to access data at the HiMi Resource Server, the request fails with HTTP `401 Unauthorized` and an `invalid_token` error. If the **DiGA** attempts to refresh tokens at the [`/token`](authorization-server-token-endpoint.html) endpoint using the revoked refresh token, the HiMi responds with HTTP `400 Bad Request` and `invalid_grant`. The **DiGA backend** then marks the local consent for the Pairing ID as invalid and may optionally notify the insured person. <br><br> **Failure case:** If the DiGA does not handle the 401/400 errors correctly, it may continue attempting to use invalid tokens until corrected. |

<br>

### Unpairing by the System

The unpairing process initiated by the system allows for the automatic termination of the connection between a DiGA and
a
medical aid or implant (HiMi) under specific conditions.

<div style="width: 80%;">
  <img src="assets/images/unpairing_by_system.svg" style="width: 100%;" />
</div>

<br>

| Process Step                                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|-------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. Prescription duration for Pairing ID expired | The **DiGA backend** regularly checks whether the consent associated with a Pairing ID is still valid by comparing the current system time with the prescription expiry date. If the prescription is about to expire, the **DiGA frontend** informs the insured person. Once expired, the **DiGA backend** invalidates the consent locally and sends a revocation request to the **HiMi Authorization Server’s** [`/revoke`](authorization-server-revocation-endpoint.html) endpoint. The **HiMi** invalidates the authorization grant, refresh token, active access tokens, and stored consent, then responds with HTTP `200 OK`. The **DiGA frontend** confirms to the insured person that the pairing has been revoked. <br><br> **Failure case:** If the DiGA does not trigger revocation, the HiMi tokens may still appear active until they expire naturally.                                                                                                                                   |
| 2. DiGA loses authorization for §374a interface | The **DiGA** or **HiMi manufacturer** queries the DiGA registry to verify the DiGA’s status (`client_id`). If the DiGA is retired or not found, the registry responds with “retired” or HTTP `404 Not Found`. The **manufacturer** then instructs the **HiMi Authorization Server** to revoke the Pairing ID: it invalidates the grant, refresh token, active tokens, stored consent, and deregisters the DiGA. The **HiMi frontend** displays a notification to the insured person. After revocation, any DiGA access to the HiMi Resource Server fails with HTTP `401 Unauthorized` and `invalid_token`. Attempts to refresh the access token at the [`/token`](authorization-server-token-endpoint.html) endpoint fail with HTTP 400 `invalid_grant` or HTTP 401 Unauthorized. The **DiGA backend** marks the consent as invalid and may optionally notify the insured person. <br><br> **Failure case:** If the DiGA ignores registry updates, it may continue to operate with stale credentials. |
| 3. HiMi no longer offers §374a interface        | The **DiGA** or **HiMi manufacturer** queries the HiMi registry to check the HiMi’s status (HiMi-ID). If the HiMi is retired or not found, the registry responds with “retired” or HTTP `404 Not Found`. The **manufacturer** then instructs the **DiGA backend** to invalidate the consent for the Pairing ID and remove HiMi-specific configurations. The **DiGA frontend** informs the insured person that the consent has been invalidated. <br><br> **Failure case:** If the DiGA backend does not remove old configurations, the insured person may see outdated device options.                                                                                                                                                                                                                                                                                                                                                                                                                |