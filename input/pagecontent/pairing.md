The pairing procedure is the central mechanism for securely connecting a medical aid or implant (HiMi) with a digital
health application (DiGA). The goal is to enable insured persons to use health data collected by their HiMi in a DiGA
under their control.

The key requirements for the pairing procedure are:

* **Consent-based** – Pairing requires the insured person’s explicit and informed consent.
* **Fine-grained** – Consent applies to Mandatory Interoperable Values (MIVs), not to the entire device.
* **Revocable** – The insured person must be able to terminate pairing at any time.
* **Pseudonymized** – To comply with data protection requirements, no personal identifiers may be exchanged between DiGa
  and medical aid or implant.
* **Standardized** – The procedure must be implemented uniformly across all HiMi and DiGA manufacturers to ensure
  interoperability.

From a technical perspective, the pairing process relies on OAuth 2.0 as the authorization framework, extended by SMART
scopes. Since data retrieval is performed via a RESTful FHIR API, SMART scopes are used to align access control directly
with FHIR resource types and search parameters. This enables fine-grained access restrictions, such as limiting a DiGA’s
access to specific vital signs (e.g. blood glucose or blood pressure) or to particular device definitions. By binding
consent to concrete FHIR query constraints, insured persons gain precise and enforceable control over which data
elements are shared with a DiGA.

A further key element of the pairing process is the pairing ID. This pseudonymous identifier links the insured person’s
consent with the subsequent data transfer. It ensures that data flows can be traced back to a specific pairing without
revealing the insured person’s identity.

This document describes the role of the authorization server, the use of OAuth 2.0 and SMART scopes, the purpose of the
pairing ID, and a deep dive in the pairing process itself.

### Authorization Server Prerequisites

The authorization server of the medical aid or implant plays a pivotal role in the pairing process. It is responsible
for:

* Managing the insured person’s consent.
* Verifying whether a DiGA is authorized to access specific data (is a registered client).
* Issuing OAuth 2.0 access tokens that enable secure communication between the DiGA and the HiMi.

In practice, the authorization server is the technical anchor for the entire pairing mechanism. It ensures that OAuth
2.0 is applied correctly and that SMART scopes are enforced, while also binding consent and subsequent data flows to the
pairing ID.

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
essential to ensure that only authorized DiGAs can obtain access tokens and that the granted scopes reflect the intended
use cases of the HiMi.

The HiMi manufacturer is responsible for publishing and enforcing the supported SMART scopes. Scopes MUST be aligned
with the FHIR resources and search parameters relevant to the device, e.g., specific vital signs (blood glucose, blood
pressure) or supported device types. Only scopes that are necessary for the functional use cases of the HiMi MUST be
exposed. The set of supported scopes MUST be advertised in the authorization server metadata document as defined in RFC
8414.

In addition, the HiMi manufacturer is responsible for configuring OAuth 2.0 clients corresponding to DiGAs. A DiGA MAY
only be registered if it is listed in the official DiGA directory (DiGA-VZ). Each client configuration MUST include, at
a minimum, the following parameters:

* `client_id`
* `redirect_uri`
* the set of authorized SMART scopes

The `client_id` MUST follow the structure: `urn:diga:bfarm:{DiGA-ID}` where `{DiGA-ID}` is the unique five-digit
identifier of the DiGA as published in the DiGA directory.

The HiMi manufacturer MUST ensure that client registrations are kept in sync with the DiGA directory. If a DiGA is
removed or its authorization attributes change, the corresponding client configuration MUST be updated or revoked
without undue delay.

#### SMART Scopes and Consent for fine-grained access

SMART on FHIR v2 (based on the HL7 SMART App Launch Framework) extends OAuth with semantically meaningful scopes that
map directly to FHIR resources. This allows access to be restricted not only by resource type, but also by subsets of
values (e.g., specific vital signs defined by the MIVs). A general overview of SMART scopes can be found in the official
specification: [SMART App Launch Framework – Scopes and Launch Context](https://hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html)
.

The core idea behind SMART scopes is to enable applications to request only the minimum data necessary for a defined use
case, and to allow patients to understand and control which types of health data will be shared. Concrete SMART scopes
are always use case specific: a DiGA treating diabetes may request access to blood glucose measurements, while a DiGA
focused on hypertension may request access to blood pressure values.

Examples of SMART scopes:

* `patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutzucker` → Read access to all blood
  glucose observations, limited by a ValueSet published by BfArM.
* `patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutdruck` → Read access to all blood
  pressure observations, including systolic and diastolic values.
* `patient/Device.r?type=https://terminologien.bfarm.de/fhir/CodeSystem/CS_HiMi_DeviceType|glucometer` → Read access to
  device resources of type “glucometer”.
* `patient/DeviceMetric.r` → Read access to measurement configurations, but only when tied to an Observation already
  authorized by another scope.

Supported scopes MUST be declared by the HiMi authorization server at its discovery endpoint (
`/.well-known/oauth-authorization-server`) as required by [RFC 8414].

Scopes form the basis of the patient consent dialogue. The insured person MUST be presented with the requested scopes in
a human-readable form, allowing them to see exactly which categories of data are being shared and to grant or deny
access individually. Consent MUST be stored and MUST be revocable by the insured person at
any time.

Finally, it is the responsibility of the HiMi resource server to enforce the granted scopes and restrict resource access
accordingly. The exact enforcement of scopes on the resource server is addressed separately in the chapter on resource
server behavior.

### Pairing ID as a Central Link

The Pairing ID establishes the coupling context between the DiGA and the medical aid or implant (HiMi). It is the
central pseudonymous identifier that binds consent, authorization, and subsequent data flows together.

The following rules apply:

* The Pairing ID MUST always be generated by the HiMi authorization server at the moment a new pairing is established.
* Generation MUST occur after the insured person has authenticated and given consent and the authorization server is
  about to issue the first access token.
* Neither the DiGA nor the insured person MAY be involved in generating the identifier.
* The Pairing ID MUST be unique per pairing, MUST be non-predictable, and MUST NOT be linkable to the real-world identity
of the insured person.

To achieve this:

* The Pairing ID SHOULD be derived from a combination of internal attributes (such as the DiGA identifier and the user’s
internal id within the HiMi) and a random salt value that remains secret in the backend.
* The Pairing ID MUST be sufficiently long and randomly distributed to prevent guessing or brute-force attacks.
* The identifier MUST remain stable for the lifetime of the pairing.

If the same insured person pairs with multiple DiGA, each relationship MUST result in a distinct Pairing ID.

The Pairing ID MUST be retained by the HiMi backend and MUST also be embedded into the access tokens issued to the DiGA.


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
    * the authorized SMART scopes, either in the scope claim (if JWT) or in the token response body;
    * the pairing-id, binding the token to a specific pairing;
    * an expiration time (exp).
* The lifetime of an access token MUST be limited to 10 minutes.
* Token usage MUST be bound to the TLS session established between DiGA and HiMi (mTLS, [RFC 8705]).
* Certificate-bound access tokens MUST NOT be used; instead, client authentication is performed via mutual TLS.

#### Refresh Tokens

* The authorization server MUST issue a refresh token together with the access token.
* The refresh token MUST be valid for at least 30 days.
* Refresh tokens MUST support rotation: when a refresh token is used to obtain a new access token, a new refresh token
  MUST be issued and the previous one MUST be invalidated.
* Refresh tokens MUST be revocable by the DiGA through the /revoke endpoint ([RFC 7009]).
* If the insured person withdraws consent, the associated refresh token MUST be invalidated immediately, and all access
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
  "scope": "patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/VS_Blutzucker",
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

The following diagram illustrates the detailed sequence of interactions during the pairing process between the insured person,
the DiGA, and the HiMi. Each step is explained in detail below.

<div style="width: 85%;">
  <img src="assets/images/pairing_sequence_detailed.svg" style="width: 100%;" />
</div>

**1) Insured Person Initiates HiMi Pairing (DiGA UI)**

* **1.1 Login to DiGA (out of scope).**

  The insured person authenticates in the DiGA (any DiGA-specific login mechanism).

* **1.2 Start pairing.**

  The insured person triggers “Pair with HiMi” in the DiGA frontend.

* **1.3 Select HiMi and sensors/devices.**

  The DiGA frontend shows (a) compatible HiMi systems and (b) compatible sensors/devices for this DiGA.
The insured person selects the target HiMi and the relevant device/sensor types.

* **1.4 Preview required permissions.**

  The DiGA displays the permissions it intends to request (SMART scopes), allowing the insured person to pre-review what will later be confirmed on the HiMi side.

**2) Send Authorization Request to HiMi (Backend-to-Backend, then PAR)**

* **2.1 Discovery / Metadata retrieval.**

  The DiGA fetches the HiMi Authorization Server Metadata (/.well-known/oauth-authorization-server) to obtain endpoints, supported grant types, and scopes_supported.

* **2.2 Scope selection & PKCE artifacts.**

  The DiGA determines the exact scopes needed (e.g., vibW ValueSets; device type filters) and generates PKCE parameters (code_verifier, code_challenge(S256)).

* **2.3 Pushed Authorization Request (PAR) over mTLS.**

  The DiGA sends a PAR to the HiMi AS including client_id, redirect_uri, scope, code_challenge, etc., using mutual TLS (tls_client_auth).

* **2.4 Mutual authentication and request validation.**

  * DiGA ↔ HiMi authenticate each other via X.509 certificates.
  * The HiMi AS validates the PAR contents (e.g., that redirect_uri and requested scopes match the DiGA’s registered profile).
  * The HiMi AS persists the PAR parameters and issues a request_uri with expires_in.

**3) Authorization Confirmation by the Insured Person (User-Agent Flow)**

* **3.1 Front-channel authorize.**

  The DiGA initiates GET /authorize with client_id and the request_uri (from PAR). This is a user-agent redirect so the insured person can interact with the HiMi.

* **3.2 HiMi login (out of scope).**
  
  The HiMi AS triggers the insured person’s login in the system browser (and, if applicable, via app/deep link).

* **3.3 Consent dialog (SMART scopes).**
  
  The HiMi frontend displays a human-readable list of the requested scopes (mapped to data categories like blood glucose / blood pressure, device types, etc.).
The insured person reviews and confirms the requested permissions for the DiGA (or cancels).

* **3.4 Pairing ID handling.**

  * If a Pairing ID already exists for this insured person ↔ DiGA, the HiMi locates it.
  * Otherwise, the HiMi generates a new Pairing ID, links it to the insured person’s HiMi account, and associates it with this consent.

* **3.5 Persist consent.**

  The HiMi persists consent bound to the Pairing ID and the insured person’s identity (within HiMi). The consent will drive scope enforcement and can be revoked later.

**4) Perform Authorization (Code Exchange)**

* **4.1 Authorization response.**

  The HiMi AS redirects the user agent back to the DiGA redirect_uri with an authorization_code.

* **4.2 Token request over mTLS with PKCE.**

  The DiGA backchannel-calls the HiMi POST /token using mTLS (tls_client_auth), sending authorization_code, code_verifier, client_id, etc.

* **4.3 Validation & token issuance.**

  The HiMi AS:

  * Authenticates the DiGA via X.509 certificate.
  * Validates the authorization_code and PKCE (code_verifier).
  * Issues the token response that includes:
    * access_token (10-minute lifetime),
    * refresh_token (≈30-day lifetime with rotation),
    * granted scope (the actually consented subset),
    * the Pairing ID (in the JSON body; if JWT is used, also as a claim).

**5) Complete Pairing (State Finalization, User Feedback)**

* **5.1 DiGA stores pairing state.**

  The DiGA records:
  * the Pairing ID,
  * the granted scopes,
  * the prescription/entitlement end date (if applicable to the insured person) as part of its internal consent state for this pairing.

* **5.2 DiGA consent record.**

  The DiGA links its local consent record to the Pairing ID to reflect the patient’s choices and to enable revocation handling and auditability.

* **5.3 User confirmation.**

  The DiGA frontend confirms the successful pairing to the insured person.

**Notes (clarifications that align with your model)**

* **Out of scope:** DiGA login and HiMi login are explicitly outside the pairing spec (implementation-specific).
* **mTLS & X.509:** All backchannel calls (PAR, token) use mutual TLS; both parties validate each other’s certificates against registry trust data.
* **Scopes presentation:** Requested scopes must be human-readable on the HiMi consent screen; the insured person can accept or deny per scope.
* **Pairing ID:** Always generated/managed by the HiMi; unique per DiGA–insured pairing; embedded in token response and (if JWT) in the access token.
* **Revocation:** If the insured person revokes consent, the HiMi must invalidate the refresh token and render related access tokens unusable; the DiGA must respect revocation on subsequent calls.
* **Resource enforcement:** Scope enforcement (e.g., code:in=ValueSet for Observations, type= for Device) occurs on the HiMi Resource Server and is specified in a separate chapter on resource-server behavior.

