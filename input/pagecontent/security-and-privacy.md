
### Identification and Authentication

#### Identification and Authentication of the Patient
Every DiGA maintains a patient account for each patient. Patients authenticate with this account using credentials that have been initialized during the patient's registration with the DiGA. By regulation, DiGA MUST NOT identify the patient as a natural person unless this is required for fulfilling regulatory requirements (e.g. exporting data to the electronic patient record). Therefore the patient identifier used internally by a DiGA is considered as a pseudonym that allows for authenticationg the owner of a patient account without identifying this person.      

With respect to Device Data Recorders, HDDT makes no asumptions about if and how a patient is identified. Again, the only asumption is that the Device Data Recorder is able to authenticate a user as the owner of a patient account that links to that user's device data. 

A Device Data Recorder MUST NOT transmit any data to a DiGA that allows the DiGA to identify the patient as a natural person. In particular, the Device Data Recorder
- MUST NOT implement a `/patient`endpoint that is accessible to DiGA
- SHOULD NOT include a `subject` reference with any resources that are transmitted to a DiGA
- MUST NOT use identifying data within a `subject` reference (if such a reference is included with a resource). 

#### Pseudonymous Identifier

To enable user-based data transmission, DiGA and Device Data Recorder MUST agree on a common identifier for the insured
person. This identifier is specific to the combination of DiGA and Personal Health Device. It MUST be a pseudonym,
meaning that third parties MUST NOT be able to infer the identity of the data subject solely from the identifier itself.

Neither Personal Health Devices nor DiGA SHALL obtain knowledge of the patient's health insurance number (KVNR). In
addition, medical data transmitted via FHIR MUST NOT contain information that reveals or enables inference of the
insured person’s identity.

Further normative requirements and technical details regarding the identifier are specified in the
dedicated [Pairing ID](pairing.html#pairing-id)
chapter.

#### Identification and Authentication of the DiGA
A DiGA authenticates with a Device Data Recorder during connection establishment (mutual TLS, see below). The DiGA's X.509 client certificate MUST be registered with the BfArM-SST-VZ. The DiGA MAY use self-signed certificates. Certificates MUST comply with [BSI TR-02102-2](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR02102/BSI-TR-02102-2.pdf?__blob=publicationFile&v=11).

Procedures for registering certificates and for exchanging outdates certificates will be published by BfArM as part of the HiMi-SST-VZ specification or corresponding guidelines.

#### Identitfication and Authentication of the Device Data Recorder
A Device Data Recorder authenticates with a DiGA during connection establishment (mutual TLS, see below). The _Fully Qualified Domain Name (FQDN)_ used for Device Data Recorder's X.509 certificate MUST be registered with the BfArM-SST-VZ. The Device Data Recorder MUST NOT use self-signed certificates. Certificates MUST comply with [BSI TR-02102-2](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR02102/BSI-TR-02102-2.pdf?__blob=publicationFile&v=11).

Procedures for registering FQDNs with the _BfArM HiMi-SST-VZ_ will be published by BfArM as part of the HiMi-SST-VZ specification or corresponding guidelines.


### Authorization of the DiGA
The Device Data Recorder takes the role of the Data Controller acc. Art. 4 Sentence 1 No. 7 GDPR. The Device Data Recorder MUST implement suitable technical and organizational measures to ensure and be able to prove that the processing is carried out in accordance with the GDPR (Art. 42 GDPR). This especially includes the Device Data Recorder's responsibility to ensure that device data is only disclosed to authorized DiGA. 

The authorization of a DiGA to obtain data from a Device Data Recorder is based on three mechanisms:
* a valid shared patient identifier MUSZT have been agreed for the patient this data belongs to (see above),
* the provided data MUST be required by the DiGA for the DiGA's intended use and
* the patient MUST have given informed consent for sharing device data with a DiGA.

The Device Data Recorder verifies these conditions and issues an OAuth2 Access Token for an authorized DiGA (see [pairing](pairing.html)). This token MUST be presented by the DiGA with any request for device data. HDDT does not make any presumptions on the content of this Access Token. A manufacturer of a Device Data Recorder  ;MAY place all authorization information directly into the token or use opaque tokens which just refer to information which is managed internally. 

#### Intended Use
Upon registration with the _DiGA-VZ_, a DiGA registers the values it processes for its "intended use". For any of these values that match a defined MIV, BfArM links the DiGA with the respective MIV (see [Information Model](information-model.html)). For each request for measured or aggregated data the Device Data Recorder MUST verify that the requesting DiGA requires the requested data for its intended use. As MIVs are defined through FHIR [ValueSets](https://hl7.org/fhir/R4/valueset.html) this means:
* if a DiGA requests for measured data that is assigned to a certain MIV, the Device Data Recorder MUST verify that the DiGA was authorized for this MIV
* if a DiGA requests for aggregated data (device data report), the Device Data Recorder MUST verify that the respective FHIR Operation is linked with the MIV that the DiGA was autorized for (see [MIVs](mivs.html) for the currently defined MIVs and their associated FHIR Operations).
* if a DiGA requests for a specific LOINC code, the Device Data Recorder MUST verify that this code is included with the ValueSet of the MIV that the DiGA was autorized for. This information can be obtained from the [ZTS](zts-api.html) (German Central Terminology Server).

In addition to measured and aggregated data, a DiGA can as well request information about the patient's Personal Health Device from the Device Data Recorder. See [Smart Scopes](smart-scopes.html) for the enforcement of authorization upon such requests.

#### Consent
Data transfer from a Device Data Recorder to a DiGA MUST only be carried out on the basis of the affected patient's informed consent (Art. 9 GDPR in conjunction with Art. 6 GDPR). Both the DiGA and the Device Data Recorder MUST provide means to the patient to revoke the consent from within the DiGA and from all patient GUIs of the Device Data Recorder. Once a consent is revoked, the Access Token MUST be invalidated and the DiGA MUST NOT be able to obtain device data from the Device Data Recorder any more (see [unpairing of a DiGA](pairing.html#unpairing-by-the-insured-person)).

The period of validity of the consent MUST NOT be longer tha the prescription period of the DiGA. If a DiGA has an unlimited prescription period or an prescription period of more than one year, the consent SHOULD NOT exceed one year. The manufacturer of the Device Data Recorder is generally responsible for properly obtaining and renewing consent and monitoring any revocations as well as the follow-up obligations. 

### Secure Communication via mTLS
Connections between the DiGA and HiMi backend are secured via a mutually authenticated TLS channel (mTLS). Since the connection takes place over the Internet, the trust space of the Internet PKI is used. Specifically, the CAs that are members of the CA/Browser Forum form the trust space and CA Authorization (CAA, https://datatracker.ietf.org/doc/html/rfc8659) and Certificate Transparency (CT, https://datatracker.ietf.org/doc/html/rfc6962) are implemented.

For all connections, the DiGA acts as a client and the Device Data Recorder as a server. In the course of establishing a TLS connection, the following steps must be completed as part of the certificate check:
1. Verification of the server certificate of the Device Data Recorder by the DiGA:
   - Precondition: The DiGA backend knows which Device Data Recorder it wants to communicate with and has determined the FQDN from the _BfArM HiMi-SST-VZ_ in advance for the connection establishment.
   - Check for the trust space CA/Browser Forum
   - Check that the called URI is covered by the FQDN (CN or SAN) specified in the presented server certificate
   - Checking for temporal validity
   - Check that at least two Signed Certificate Timestamps (SCT) are included in the certificate and that they are signed by known CT-Log operators
2. Verification of the client certificate of the DiGA by the Device Data Recorder:
   - Check for the trust space CA/Browser Forum
   - Extraction of the FQDN from the presented client certificate (CN and SAN; possibly several FQDN included) and later comparison with the information from the _DiGA-VZ_ of the BfArM
   - Checking for temporal validity
   - Check that at least two Signed Certificate Timestamps (SCT) are included in the certificate and that they are signed by known CT-Log operators

DiGA and Device Data Recorder operators must implement CA Authorization (CAA) and publish a corresponding DNS record for their domain. DiGA and Device Data Recorder operators must continuously check the CT logs of the known CT log operators (https://certificate.transparency.dev/google/) for unauthorized certificates for their own domain. The measure ensures that unauthorized certificates are detected and that the operator can report this to the issuing CA. The incident does not go undetected and the affected CA can react to it. In addition, the CA then revokes the certificate issued without authorization. The measure is fully effective if, in addition to the above-mentioned verification steps, the verifying entity also checks the revocation status of the presented certificate against the revocation lists (CRL) provided by the issuing CA. Due to the not inconsiderable size of the CRLs, this can lead to performance problems.

___Additional Notes___: 
* The list of signature verification keys is published by the browser manufacturers, for example. The measure ensures that no certificates are accepted that are not contained in at least two CT logs.
* During the TLS connection, only the certificate of the client is initially determined. The information from it (FQDN or CN &amp; SAN or entire certificate) must then be passed on to the application layer. There, a comparison must take place with the information from the _DiGA-VZ_ of the BfArM in order to identify the DiGA. If further identification data is transmitted to the DiGA at the application level (e.g. `client_id`), it must be checked that the identification data match.

### Transparency of Operations
Both the DiGA and the Device Data Recorder MUST write an audit trail for privacy purposes. This audit trail MUST at least log the following events for at least 30 days:
* pairing of a DiGA with a Device Data Recorder
* unpairing of a DiGA with a Device Data Recorder
* unsuccessful pairing and unpairing attempts
* unauthorized access attempts to device data (Device Data Recorder)

Both the DiGA and the Device Data Recorder MUST provide the patient the ability to inspect the audit trail. Both the DiGA and the Device Data Recorder MUST upon request give responsible data privacy commissionars access to the audit trails.

### Limits of security performance
The transfer of data between Device Data Recorder and DiGA and the necessary pairing between the two is considered here. The processing of the data before or after it is transmitted is not considered. This includes internal processes at the backend operators, protection of data during storage, protection of the existing and new interfaces against hacking attacks, the authentication of the insured person in order to access DiGA, Personal Health Devices and Device Data Recorder, as well as the secure implementation of the respective front-end to back-end communication.

The threats and vulnerabilities affecting these parties, components, and services must be considered by those responsible. This is outside the scope for which gematik has a mandate.

