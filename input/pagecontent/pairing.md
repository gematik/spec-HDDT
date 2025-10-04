The pairing procedure is the central mechanism for securely connecting a medical aid or implant (HiMi) with a digital
health application (DiGA). The goal is to enable insured persons to use health data collected by their HiMi in a DiGA
under their control.

The key requirements for the pairing procedure are:

* **Consent-based** – Pairing requires the insured person’s explicit and informed consent.
* **Fine-grained** – Consent applies to Mandatory Interoperable Values (MIVs), not to the entire device.
* **Revocable** – The insured person MUST be able to terminate pairing at any time.
* **Pseudonymized** – To comply with data protection requirements, no personal identifiers MAY be exchanged between
  DiGa
  and medical aid or implant.
* **Standardized** – The procedure MUST be implemented uniformly across all HiMi and DiGA manufacturers to ensure
  interoperability.

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
subsequent data flows to the pairing ID.

The authorization server MUST implement the following key OAuth 2.0 mechanisms:

| RFC                                                | Description                                                             |
|----------------------------------------------------|-------------------------------------------------------------------------|
| [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749) | The OAuth 2.0 Authorization Framework                                   |
| [RFC 6750](https://www.rfc-editor.org/rfc/rfc6750) | OAuth 2.0 Bearer Token Usage                                            |
| [RFC 7009](https://www.rfc-editor.org/rfc/rfc7009) | OAuth 2.0 Token Revocation                                              |
| [RFC 7519](https://www.rfc-editor.org/rfc/rfc7519) | JSON Web Token (JWT)                                                    |
| [RFC 7636](https://www.rfc-editor.org/rfc/rfc7636) | Proof Key for Code Exchange by OAuth Public Clients                     |
| [RFC 8414](https://www.rfc-editor.org/rfc/rfc8414) | OAuth 2.0 Authorization Server Metadata                                 |
| [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705) | OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Tokens |
| [RFC 9068](https://www.rfc-editor.org/rfc/rfc9068) | JWT Profile for OAuth 2.0 Access Tokens                                 |
| [RFC 9101](https://www.rfc-editor.org/rfc/rfc9101) | JWT-Secured Authorization Request (JAR)                                 |
| [RFC 9126](https://www.rfc-editor.org/rfc/rfc9126) | OAuth 2.0 Pushed Authorization Requests (PAR)                           |

The listed requirements are based on open, established standards and will not be explained in detail in this
specification. For further information, please refer to the respective RFC documents.

#### Configuration

The authorization server of the HiMi is operated and configured by the HiMi manufacturer. Proper configuration is
essential to ensure that only authorized DiGAs can obtain access tokens and that the granted scopes reflect the intended use cases of the HiMi.

The HiMi manufacturer is responsible for publishing and enforcing the supported [SMART scopes](smart-scopes.html).
Scopes MUST be aligned with the FHIR resources and search parameters relevant to the device, e.g., specific vital
signs (blood glucose, blood pressure) or supported device types. Only scopes that are necessary for the functional use
cases of the HiMi MUST be exposed. The set of supported scopes MUST be advertised in the authorization server metadata
document as defined in [RFC 8414].

In addition, the HiMi manufacturer is responsible for configuring OAuth 2.0 clients corresponding to DiGAs. A DiGA MAY
only be registered if it is listed in the official DiGA directory (DiGA-VZ). Each client configuration MUST include,
at a minimum, the following DiGA trust attributes:

* `client_id`
* `redirect_uri`
* 'TLS_Client_Certificate_DiGA' (for mTLS authentication)
* the set of authorized [SMART scopes](smart-scopes.html)

The `client_id`MUST follow the structure: `urn:diga:bfarm:{DiGA-ID}` where `{DiGA-ID}` is the unique five-digit
identifier of the DiGA as published in the DiGA directory.

The HiMi manufacturer MUST ensure that client registrations are kept in sync with the DiGA directory. If a DiGA is
removed or its authorization attributes change, the corresponding client configuration MUST be updated or revoked
without undue delay.

#### SMART Scopes and Consent for fine-grained access

The supported [SMART scopes](smart-scopes.html) MUST be declared by the HiMi authorization server at its discovery
endpoint ( `/.well-known/oauth-authorization-server`) as REQUIRED by [RFC 8414].

[SMART scopes](smart-scopes.html) restrict access to resources in a precise and use case–specific manner. They determine
which FHIR resources, value sets, or device categories a DiGA MAY access. Because these scopes directly control the
visibility of sensitive health data, they MUST be presented to the insured person in a clear and understandable fashion.
This requirement is realized through the consent dialogue, which ensures that the patient is explicitly informed about
the requested access rights before granting or denying them.

Scopes form the basis of the patient consent dialogue. The insured person MUST be presented with the requested scopes in
a human-readable form, allowing them to see exactly which categories of data are being shared and to grant or deny
access individually. Consent MUST be stored and MUST be revocable by the insured person at any time. The consent record
MUST be linked to the Pairing ID to enable manufacturer-independent assignment of consent.

Finally, it is the responsibility of the HiMi resource server to enforce the granted scopes and restrict resource access
accordingly. The exact enforcement of scopes on the resource server is addressed separately in the chapter
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
random value (salt) that is known only to the HiMi backend. This approach ensures that the Pairing ID is both unique and
stable, while also being resistant to brute-force or guessing attacks. A sample construction is:

```
PairingID = Hash(DiGA-ID, User-ID, Salt)
```

where `Salt` is a secret random value of sufficient length (e.g., 128 bits) that is securely stored in the HiMi backend.

### Tokens and the Token Response

OAuth 2.0 access and refresh tokens are the core security artifacts enabling a DiGA to retrieve data from a HiMi in
accordance with the insured person’s consent. The HiMi authorization server is responsible for issuing, validating, and
revoking these tokens.

#### Access Tokens

* The authorization server MUST issue an access token upon successful completion of the OAuth 2.0 Authorization Code
  flow with PKCE.
* The access token MUST be standard-conformant and MAY be represented either as a self-encoded JSON Web Token (
  JWT, [RFC 7519]) or as an opaque token.
* The access token MUST include the following:
    * the authorized [SMART scopes](smart-scopes.html), either in the scope claim (if JWT) or in the token response body;
    * the pairing-id, binding the token to a specific pairing;
    * an expiration time (exp).
* The lifetime of an access token MUST be limited to 10 minutes.
* Token usage MUST be bound to the TLS session established between DiGA and HiMi (mTLS, [RFC 8705]).
* Certificate-bound access tokens MUST NOT be used; instead, client authentication is performed via mutual TLS.
* If the access token is a JWT, the `sub` claim MUST contain the Pairing ID.
  * The `sub` claim MUST NOT contain the internal identifier of the HiMi user or any other personal identifier.

#### Refresh Tokens

* The authorization server MUST issue a refresh token together with the access token.
* The refresh token MUST be valid for at least 30 days.
* Refresh tokens MUST support rotation: when a refresh token is used to obtain a new access token, a new refresh
  token
MUST be issued and the previous one MUST be invalidated.
* Refresh tokens MUST be revocable by the DiGA through the /revoke endpoint ([RFC 7009]).
* If the insured person withdraws consent, the associated refresh token MUST be invalidated immediately, and all
  access
  tokens issued under that grant MUST be rendered unusable.

#### Token Response

The token endpoint response MUST include both tokens, their validity, the granted scopes, and the Pairing ID. The
Pairing ID MUST be included in the JSON body of the token response and, if JWT access tokens are used, also as a
dedicated claim inside the access token.

An example token response (with a JWT access token) is shown below:

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 600,
  "refresh_token": "9e35d65d-ec12-4b8d-a8b1-dff2f7cf6a5e",
  "scope": "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/hddt-miv-blood-glucose-measurement",
  "pairing-id": "c42a87f6-9f91-44d7-aea9-47b1e70b2213"
}
```

**Notes:**

* The format of the access token (JWT vs. opaque) is left to the HiMi manufacturer, but the inclusion of the Pairing ID
  in the token response is mandatory in all cases.
* If JWTs are used, the Pairing ID MUST be present as a claim (e.g., pairing-id or sub) in the token payload.
* Refresh token validity ensures that the DiGA can continue to access data without further user interaction, while still
  preserving revocation capabilities in line with patient consent.

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