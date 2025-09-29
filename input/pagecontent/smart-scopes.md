SMART on FHIR v2 (based on the HL7 SMART App Launch Framework) extends OAuth with semantically meaningful scopes that
map directly to FHIR resources. This allows access to be restricted not only by resource type, but also by subsets of
values (e.g., specific vital signs defined by the MIVs). A general overview of SMART scopes can be found in the official
specification: [SMART App Launch Framework – Scopes and Launch Context](https://hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html)
.

The core idea behind SMART scopes is to enable applications to request only the minimum data necessary for a defined use
case, and to allow patients to understand and control which types of health data will be shared.

Examples of SMART scopes:

| SMART Scope                                                                                                                | Description                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| `patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/ValueSet-hddt-miv-blood-glucose-measurement`  | Read and Search access to all blood glucose observations, limited by a ValueSet published by BfArM.                             |
| `patient/Observation.rs?code:in=https://terminologien.bfarm.de/fhir/ValueSet/ValueSet-hddt-miv-blood-pressure-measurement` | Read and Search access to all blood pressure observations, including systolic and diastolic values.                             |
| `patient/Device.rs`                                                                                                        | Read and Search access to device resources.                                                                                     |
| `patient/DeviceMetric.rs`                                                                                                  | Read and Search access to measurement configurations, but only when tied to an Observation already authorized by another scope. |

Concrete SMART scopes are always use case specific: a DiGA treating diabetes MAY request access to blood glucose
measurements, while a DiGA focused on hypertension MAY request access to blood pressure values.

While the SMART scopes are configured and consented to on the authorization server of the HiMi as described in the
[pairing chapter](pairing.html), it is vital that the HiMi resource server strictly enforces these scope restrictions.
Even if a DiGA
holds a valid access token, it MUST only be allowed to retrieve data elements explicitly covered by the granted
SMART
scopes. Failure to enforce these restrictions would undermine the purpose of fine-grained consent and could result in
unauthorized disclosure of sensitive health data. Proper enforcement ensures that patient consent is respected at the
technical level and that data access remains fully aligned with the intended use case.

### Enforcement of SMART Scopes on Observations, DeviceMetric, and Device

All enforcement rules defined in the official SMART App Launch Framework – Scopes and Launch Context
specification apply without exception. These rules define the general semantics of SMART scopes and how they restrict
FHIR resource access.

However, the official SMART specification does not consider concrete implementation guides (IGs) or the domain-specific
relationships between resources. In the context of § 374a SGB V and the interoperability profiles defined for DiGA–HiMi
integration, additional enforcement rules are REQUIRED for the
resources [Observation](https://hl7.org/fhir/R4/observation.html), [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html),
and [Device](https://hl7.org/fhir/R4/device.html).

#### Observation as the Anchor

Observations are the primary and anchoring resource for all scope enforcement. SMART scopes of the form
`patient/Observation…` determine which clinical measurements a DiGA is entitled to access. All other resources (
[DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html), [Device](https://hl7.org/fhir/R4/device.html)) are only made
available in relation to these Observations.

Concretely:

* Enforcement of the `code:in` search parameter MUST be applied. Only Observations whose `code` is contained in the
  [ValueSet](https://hl7.org/fhir/R4/valueset.html)
  referenced by the authorized SMART scope MAY be returned.
* Each [Observation](https://hl7.org/fhir/R4/observation.html) MUST belong to the patient identified by the `sub`
  /Pairing ID in the access token.
* Observations that do not match both conditions (code and patient) MUST NOT be returned.

#### DeviceMetric and Device in Relation to Observations

A HiMi backend MAY manage multiple devices and observations spanning different medical use cases (e.g., blood glucose
for diabetes, heart rate for cardiology, blood pressure for hypertension). If Devices or DeviceMetrics were returned
purely based on patient identity, a DiGA could learn about other devices or conditions unrelated to its authorized use
case. To prevent this leakage, Devices and DeviceMetrics MUST always be filtered through their relationship to
authorized Observations.

Two constellations are relevant:

<div style="width: 50%;">
  <img src="assets/images/model_constellations.svg" style="width: 100%;" />
</div>

<br>

* In Constellation A an [Observation](https://hl7.org/fhir/R4/observation.html) directly references
the [Device](https://hl7.org/fhir/R4/device.html) that produced the measurement.
* In Constellation B an [Observation](https://hl7.org/fhir/R4/observation.html) references
a [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html), which in turn references a
[Device](https://hl7.org/fhir/R4/device.html).

For both constellations, the following compartment rule applies:

* A [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource
  MUST NOT be returned solely because it belongs to the patient.
* A [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html) or [Device](https://hl7.org/fhir/R4/device.html) resource
  MUST only be returned if it is referenced (directly or indirectly) by an
  [Observation](https://hl7.org/fhir/R4/observation.html)
  that is itself authorized by the patient’s granted `patient/Observation…` SMART scope.

This enforcement model makes the [Observation](https://hl7.org/fhir/R4/observation.html) and its authorized SMART scope
the single anchor point for all related
data. [Device](https://hl7.org/fhir/R4/device.html) and [DeviceMetric](https://hl7.org/fhir/R4/devicemetric.html)
resources never “stand alone” but are revealed only insofar as they are part of an
[Observation](https://hl7.org/fhir/R4/observation.html) chain permitted by the patient’s consent. This ensures that
consent is applied consistently, prevents
cross-use-case data leakage, and upholds the principle of fine-grained, use case–specific access.