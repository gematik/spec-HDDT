The pairing procedure is the central mechanism for securely connecting a medical device or implant (HiMi) with a digital health application (DiGA). The goal is to enable insured persons to use health data collected by their HiMi in a DiGA under their control.

The key requirements for the pairing procedure are:

* **Consent-based** – Pairing requires the insured person’s explicit and informed consent.
* **Fine-grained** – Consent applies to Mandatory Interoperable Values (MIVs), not to the entire device.
* **Revocable** – The insured person must be able to terminate pairing at any time.
* **Pseudonymized** – To comply with data protection requirements, no personal identifiers may be exchanged between DiGa and medical device or implant.
* **Standardized** – The procedure must be implemented uniformly across all HiMi and DiGA manufacturers to ensure interoperability.

Several actors are involved in this process:

* **Insured persons**, who use both a DiGA and a device, and who authorize the pairing through their consent.
* **DiGA manufacturers**, who require access to device data for their applications.
* **HiMi manufacturers**, who provide the interface and ensure that consent is technically enforced.
* **The authorization server** of the HiMi, which manages consent and issues the tokens needed for secure access.

From a technical perspective, the pairing process relies on OAuth 2.0 as the authorization framework, extended by SMART scopes. SMART scopes enable fine-grained access control, for example restricting access to specific vital signs such as blood glucose or blood pressure or specific device configurations. This gives insured persons precise control over which data can be shared with a DiGA.

A further key element of the pairing process is the pairing ID. This pseudonymous identifier links the insured person’s consent with the subsequent data transfer. It ensures that data flows can be traced back to a specific pairing without revealing the insured person’s identity.

This document describes the role of the authorization server, the use of OAuth 2.0 and SMART scopes, the purpose of the pairing ID, and the high-level sequence of steps in the pairing process.

### Role of the Authorization Server

The authorization server of the medical device or implant plays a pivotal role in the pairing process. It is responsible for:

* Managing the insured person’s consent.
* Verifying whether a DiGA is authorized to access specific data.
* Issuing access tokens that enable secure communication between the DiGA and the HiMi.

In practice, the authorization server is the technical anchor for the entire pairing mechanism. It ensures that OAuth 2.0 is applied correctly and that SMART scopes are enforced, while also binding consent and subsequent data flows to the pairing ID.

#### OAuth 2.0 and SMART Scopes

The pairing process is built on OAuth 2.0 as the authorization framework, extended with SMART scopes to allow fine-grained, patient-specific access control.

The following OAuth mechanisms are mandated for secure and interoperable pairing:

* Authorization Code Flow with PKCE (RFC 6749, RFC 7636) – ensures secure authorization even for public clients.
* Mutual TLS client authentication (RFC 8705) – guarantees that only trusted DiGA can connect.
* Bearer token usage (RFC 6750) – standard way for resource servers to verify access.
* Token format (RFC 9068, JWT-based or opaque tokens) – scopes and consent are reflected in issued tokens.
* Authorization Server Metadata Discovery (RFC 8414) – allows DiGA to automatically configure themselves with the HiMi’s authorization server.

Together, these ensure that only properly registered and trusted DiGA can obtain access, and that this access is always tied to the insured person’s explicit consent.

##### SMART Scopes for fine-grained access

SMART on FHIR (based on the HL7 SMART App Launch Framework) extends OAuth with semantically meaningful scopes that map directly to FHIR resources. This allows access to be restricted not only by resource type, but also by specific vital signs (the so-called “verbindlich bereitzustellende Werte”, or vibW).

Examples:

* `patient/Observation.rs?code:in=http://loinc.org|2339-0` → Read access to blood glucose measurements (LOINC 2339-0).
* `patient/Observation.rs?code:in=http://loinc.org|8480-6` → Read access to systolic blood pressure values.
* `patient/Device.r?type=http://example.org/CodeSystem/HiMiDeviceType|glucometer` → Read access to a device resource, restricted to glucometers.
* `patient/DeviceMetric.r` → Read access to associated measurement configuration, but only when tied to an Observation already authorized.

These scopes are centrally defined and published by BfArM to ensure uniform semantics across all DiGA and HiMi. They also form the basis of the consent dialogue, since they provide human readable text for each scope. The insured person sees clearly which type of data will be shared, and can approve or deny access on a per-vital-sign basis.

### Pairing ID as a Central Link

The pairing ID establishes the coupling context between the DiGA and the medical device/implant. It is always generated by the HiMi backend at the moment a new pairing is established. This occurs after the insured person has authenticated and given consent in the HiMi (authorization) frontend and the authorization server issues the first access token. Neither the DiGA nor the user is involved in creating the identifier. By design, the Pairing ID is unique for each pairing and cannot be predicted or linked to the real-world identity of the insured person.

To achieve this, the ID is derived from a combination of internal information such as the DiGA identifier, the user’s internal account within the HiMi, and a random salt value that remains secret on the backend. The result is a long, pseudonymous, and non-guessable identifier that remains stable for the lifetime of the pairing. Even if the same insured person pairs with several different DiGA, each relationship produces a distinct Pairing ID.

The identifier is not only kept in the backend but is also embedded directly into the `access_token` that is issued to the DiGA. In a JWT-based token, the Pairing ID typically appears in the `pairing-id` claim, together with the authorized SMART scopes that reflect the insured person’s consent. For example, an access token might contain the following payload:


### High-Level Pairing Workflow

The pairing process unfolds in several steps:

1. Initiation in the DiGA frontend – The insured person triggers the pairing process.

2. Selection of the device – The DiGA presents a list of compatible devices; the user selects the one they are using.

3. Consent in the HiMi frontend – The insured person is shown which data the DiGA is requesting (via SMART scopes) and grants consent either permanently or for a specific period.

4. Authorization via the authorization server – The HiMi’s authorization server performs the OAuth flow, verifies the DiGA’s credentials, and issues tokens bound to the agreed scopes.

5. Assignment of the pairing ID – A pseudonymous pairing ID is generated and stored by both systems, linking consent and data exchange.

6. Ongoing data transfer – The DiGA retrieves health data via the standardized FHIR interface, always under the constraints defined by the consent and scopes associated with the pairing ID.