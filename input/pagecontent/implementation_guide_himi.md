**ToDO Jörg, Jie, Emil**

### 1 Purpose and Scope

This document specifies the interoperable exchange of **Continuous Glucose Monitoring (CGM)** data as **aggregated reports** using **HL7 FHIR R4**. It defines:

* Constrained **FHIR Profiles** for Observations and device information,
* A normative **Bundle** profile for returning aggregated data,
* A custom **FHIR Operation** for searching and retrieving CGM results with related device context,
* **Security**, **consent**, **error handling**, and **conformance** rules.

Unless explicitly marked as informative, all statements are **normative**.

### 2 Normative References

* HL7® FHIR® R4 (4.0.1)
* HL7 CGM IG (UV):
  `$cgm-summary`, `$cgm-summary-mean-glucose-mass-per-volume`, `$cgm-summary-mean-glucose-moles-per-volume`,
  `$cgm-summary-times-in-ranges`, `$cgm-summary-gmi`, `$cgm-summary-coefficient-of-variation`,
  `$cgm-summary-days-of-wear`, `$cgm-summary-sensor-active-percentage`,
  `$cgm-sensor-reading-mass-per-volume`, `$cgm-sensor-reading-moles-per-volume`
* OAuth 2.0 (RFC 6749), Bearer Token (RFC 6750), PKCE (RFC 7636), OAuth 2.0 MTLS (RFC 8705)
* Authorization Server Metadata (RFC 8414), Pushed Authorization Requests (RFC 9126), Token Revocation (RFC 7009)

### 3 Terms and Abbreviations

* **DiGA**: Digital Health Application (client)
* **Medical Aid Backend**: Resource server exposing FHIR R4 endpoints
* **CGM Summary Observation**: Observation conformant to HL7 CGM summary/profile
* **Bundle-Search-Aggregate-Observations**: Constrained FHIR Bundle profile for operation results

---

### 4 Roles and Interaction Overview

* **DiGA (Client)** requests aggregated CGM data via FHIR Operation and renders reports.
* **Medical Aid Backend (FHIR Server)** authorizes via OAuth 2.0, evaluates search parameters, and returns a constrained **Bundle** with Observations and related device context (Device, DeviceMetric).
* **Authorization Server** issues tokens for the DiGA using Authorization Code + PKCE and MTLS client authentication.

**IG-CGM-001 (MUST)** Implementations shall expose the operation `Observation/$search-aggregate-observations` as specified in this document and return results conformant to the Bundle profile **Bundle-Search-Aggregate-Observations**.

---

### 5 Security and Privacy

#### 5.1 Client and Token Handling

**IG-CGM-010 (MUST)** Authorization flow is **OAuth 2.0 Authorization Code** with **PKCE**.
**IG-CGM-011 (MUST)** Clients are **confidential** and authenticate with **OAuth 2.0 MTLS** (RFC 8705).
**IG-CGM-012 (MUST)** Authorization Server Metadata endpoint `/.well-known/oauth-authorization-server` is provided (RFC 8414).
**IG-CGM-013 (SHALL)** Use **Pushed Authorization Requests** (`/par`) to send request parameters backend-to-backend.
**IG-CGM-014 (MUST)** Access Tokens are **Bearer** (RFC 6750). Certificate-bound access tokens are **not** required.
**IG-CGM-015 (MUST)** **Refresh Token Rotation** is used; `/revoke` (RFC 7009) invalidates refresh token, associated access tokens, and the grant.
**IG-CGM-016 (MUST)** Token responses include granted **scope** and a **subject pseudonym** `sub` specific to the coupling context.

#### 5.2 Transport

**IG-CGM-020 (MUST)** All endpoints use **TLS 1.2+**. Public endpoints (`/metadata`, AS metadata) do **not** require MTLS; token-bearing endpoints do.

#### 5.3 Consent and Minimization

**IG-CGM-025 (MUST)** Resource access is limited to scopes explicitly consented by the end user; servers must return **only** data covered by scope and time window.
**IG-CGM-026 (SHOULD)** Result sets should be minimized to the **requested code(s)** and **effective period**.

---

### Process

**ToDO PUML**

---

### 6 FHIR Content Constraints (Profiles and ValueSets)

#### 6.1 Profiles (canonical IDs as in your FSH)

* **Observation-Blood-Glucose** (LOINC from *VS\_Blood\_Glucose*, UCUM units from *VS\_Blood\_Glucose\_Units*)
* **Observation-CGM-Measurement-Series** (LOINC from *VS\_Tissue\_Glucose\_CGM*, value as `SampledData`)
* **Device-Medical-Aid** (serialNumber, deviceName, reference to `DeviceDefinition`)
* **DeviceMetric-Medical-Aid** (type from LOINC; unit from *VS\_Blood\_Glucose\_Units*; `source` → Device-Medical-Aid)
* **Bundle-Search-Aggregate-Observations** (Bundle type `collection`)

**IG-CGM-030 (MUST)** Resources returned by the operation shall **conform** to their respective profiles.
**IG-CGM-031 (MUST)** `Observation.device` shall reference a **DeviceMetric-Medical-Aid**; `DeviceMetric.source` shall reference the corresponding **Device-Medical-Aid**.
**IG-CGM-032 (MUST)** `Observation.code` shall bind to the specified ValueSet:

* Blood glucose: *VS\_Blood\_Glucose*
* CGM series: *VS\_Tissue\_Glucose\_CGM*
* CGM summary: *VSCGMSummaryCodes* (temporary) where applicable
  **IG-CGM-033 (MUST)** Quantities use **UCUM** (`http://unitsofmeasure.org`).

#### 6.2 Bundle Composition Rules

**IG-CGM-040 (MUST)** Result Bundle type is **`collection`**.
**IG-CGM-041 (MUST)** `entry.resource` is restricted to:

* **HL7 CGM Summary Observations** (`$cgm-summary*`)
* **Observation-Blood-Glucose**
* **Observation-CGM-Measurement-Series**
* **Device-Medical-Aid**, **DeviceMetric-Medical-Aid**
  **IG-CGM-042 (MUST NOT)** Other resource types (e.g., `Composition`, `Patient`, `Encounter`) are **not** included.
  **IG-CGM-043 (SHALL)** Each `entry.fullUrl` is unique.
  **IG-CGM-044 (SHALL)** If `related=true`, Devices/DeviceMetrics **relevant** to returned Observations are included exactly once per instance.

#### 6.3 Observation Details

**IG-CGM-050 (MUST)** **Observation-Blood-Glucose** uses `valueQuantity` with required UCUM code and system.
**IG-CGM-051 (MUST)** **Observation-CGM-Measurement-Series** uses `valueSampledData` with UCUM in `origin`.
**IG-CGM-052 (MUST)** Reference ranges, if present, include `system=http://unitsofmeasure.org` and UCUM `code`.
**IG-CGM-053 (MUST)** **Only** HL7 CGM Observation profiles are permitted for CGM summaries in the result Bundle.

---

### 7 FHIR Operation `$search-aggregate-observations`

#### 7.1 Invocation

**IG-CGM-060 (MUST)** The operation is invoked at `Observation/$search-aggregate-observations`.
**IG-CGM-061 (SHOULD)** Support **POST** invocation; supporting **GET** is optional.
**IG-CGM-062 (MUST)** The response is a **Bundle** conforming to **Bundle-Search-Aggregate-Observations**.

#### 7.2 Parameters (Input)

* `code` *(code, 0..1)* – Filter; required binding to **VSCGMSummaryCodes** (temporary).
* `effectivePeriodStart` *(dateTime, 0..1)* – Inclusive period start.
* `effectivePeriodEnd` *(dateTime, 0..1)* – Inclusive period end.
* `related` *(boolean, 0..1)* – Include related **Device** and **DeviceMetric** when `true`.

**IG-CGM-070 (MUST)** If both `effectivePeriodStart` and `effectivePeriodEnd` are supplied, the server returns Observations whose effective time **overlaps** the interval.
**IG-CGM-071 (SHOULD)** When only one bound is provided, filter accordingly (open interval on the missing side).

#### 7.3 Result (Output)

* `result` *(1..1)* — Bundle of type `collection`, profile **Bundle-Search-Aggregate-Observations**.

**IG-CGM-075 (MUST)** When `related=true`, for each Observation include:

* The **DeviceMetric-Medical-Aid** referenced in `Observation.device`.
* The **Device-Medical-Aid** referenced by `DeviceMetric.source`.

#### 7.4 Paging and Size

**IG-CGM-080 (SHOULD)** Support `_count` to limit entries; if omitted, apply server default.
**IG-CGM-081 (SHOULD)** When result exceeds page size, return a **searchset** continuation via `Bundle.link[relation="next"]` **or** state `collection` without paging if the server only supports complete collections. The chosen behavior MUST be documented in `/metadata`.

---

### 8 Capability Statement

**IG-CGM-090 (MUST)** `/metadata` SHALL advertise:

* FHIR version 4.0.1
* Supported resources: `Observation (read, search, operation)`, `Device (read, search, optional)`, `DeviceMetric (read via include)`
* Supported search parameters for `Observation`: `code`, `date`, `_id`, and `_include=Observation:device`
* The custom operation `Observation/$search-aggregate-observations` with parameter and output profiles.

---

### 9 Error Handling (OperationOutcome)

**IG-CGM-100 (MUST)** Errors are returned as `OperationOutcome` with HTTP status:

| Condition               | HTTP | issue.code      | Description                              |
| ----------------------- | ---: | --------------- | ---------------------------------------- |
| Unsupported parameter   |  400 | `not-supported` | Parameter name not recognized            |
| Invalid parameter value |  400 | `invalid`       | Value not in allowed set or wrong format |
| Unauthorized            |  401 | `login`         | Missing/invalid token                    |
| Forbidden               |  403 | `forbidden`     | Scope/consent does not allow access      |
| Not found               |  404 | `not-found`     | No such endpoint/resource                |
| Conflict                |  409 | `conflict`      | Parameter combination inconsistent       |
| Server error            |  500 | `exception`     | Unhandled error                          |

**IG-CGM-101 (MUST)** If no matches are found, return **200 OK** with an **empty Bundle** (type `collection`).
**IG-CGM-102 (MUST)** For invalid `code` (outside **VSCGMSummaryCodes**), return **400** with `issue.code=invalid` and diagnostics.

---

### 10 Conformance (Server & Client)

#### 10.1 Server Conformance

**IG-CGM-110 (MUST)** Implement profiles and bindings per §6 and advertise them in `/metadata`.
**IG-CGM-111 (MUST)** Enforce scope and consent; filter by `code` and effective period.
**IG-CGM-112 (MUST)** Ensure returned Observations **only** use permitted HL7 CGM profiles for summaries (§6.3, IG-CGM-053).
**IG-CGM-113 (SHALL)** Support `_include=Observation:device` to include `DeviceMetric` (and resulting `Device` via the operation’s `related=true`).
**IG-CGM-114 (SHOULD)** Support `If-None-Match`/`If-Modified-Since` for cache-friendly access (optional).

### 10.2 Client Conformance (DiGA)

**IG-CGM-120 (MUST)** Use Authorization Code + PKCE and MTLS, handle token rotation, and respect scopes.
**IG-CGM-121 (MUST)** Validate response against the declared profiles and handle empty bundles gracefully.
**IG-CGM-122 (SHOULD)** Request `related=true` when device context is required for clinical use.

---

### 11 Versioning and Canonicals

**IG-CGM-130 (MUST)** Profiles, ValueSets, and OperationDefinition use stable **canonical URLs** and semantic versions (`^version`).
**IG-CGM-131 (SHOULD)** Servers maintain backward compatibility for at least one minor version.

---

### 12 Audit, Logging, and Traceability

**IG-CGM-140 (MUST)** Servers log operation invocations with time, client id, pairing id, parameters, and result count.


---

### 13 Validation Rules (Informative FHIRPath)

* **Invariants** (server-side checks recommended):

  * `Observation.device.resolve().ofType(DeviceMetric)`
  * `Observation.device.resolve().source.exists()`
  * `Observation.code.memberOf(VS_Blood_Glucose ∪ VS_Tissue_Glucose_CGM ∪ VSCGMSummaryCodes)`
  * For series: `Observation.value is SampledData and Observation.effective is Period and effective.start.exists() and effective.end.exists()`

---

### 14 Examples

#### 14.1 Operation (POST)

```
POST [base]/Observation/$search-aggregate-observations
Content-Type: application/fhir+json

{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "code", "valueCode": "gmi" },
    { "name": "effectivePeriodStart", "valueDateTime": "2025-07-01T00:00:00Z" },
    { "name": "effectivePeriodEnd",   "valueDateTime": "2025-07-31T23:59:59Z" },
    { "name": "related", "valueBoolean": true }
  ]
}
```

#### 14.2 Successful Response (200)

```
{
  "resourceType": "Bundle",
  "type": "collection",
  "entry": [
    { "fullUrl": "urn:uuid:obs1", "resource": { /* Observation (HL7 CGM summary) */ } },
    { "fullUrl": "urn:uuid:metric1", "resource": { /* DeviceMetric-Medical-Aid */ } },
    { "fullUrl": "urn:uuid:device1", "resource": { /* Device-Medical-Aid */ } }
  ]
}
```

#### 14.3 Error (Invalid Code – 400)

```
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "Parameter 'code' must be a member of VS-CGM-Summary-Codes."
  }]
}
```

---

### 15 Testable Criteria (Extract)

| ID       | Assertion                                                                             | Method                            |
| -------- | ------------------------------------------------------------------------------------- | --------------------------------- |
| T-CGM-01 | Server returns Bundle type `collection` matching Bundle-Search-Aggregate-Observations | Validate instance against profile |
| T-CGM-02 | When `related=true`, each Observation’s DeviceMetric and Device are included once     | Instance inspection + index       |
| T-CGM-03 | `Observation.code` conforms to bound ValueSet                                         | Terminology validation            |
| T-CGM-04 | Series Observations use `SampledData` and `effective:Period` with start & end         | FHIRPath                          |
| T-CGM-05 | Scope enforcement limits resources to consented codes and period                      | Black-box authorization test      |
| T-CGM-06 | Unsupported parameter yields 400 + `OperationOutcome.issue.code=not-supported`        | Negative test                     |

---

### 16 Appendix (Informative)

* **Profiles and ValueSets**: as provided in your FSH (canonical URLs per project).
* **DeviceDefinition** reference: use your canonical if/when available; otherwise, maintain an internal reference and document it in `/metadata`.

---

