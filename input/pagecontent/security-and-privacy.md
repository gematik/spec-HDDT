
### Identification and Authentication

#### Identification and Authentication of the Patient
Device Data Recorder and DiGA must not gain knowledge of the patient's health insurance number (KVNR). The transmission of medical data (FHIR) must not contain any information that would allow conclusions to be drawn about the identity of the user.

Nevertheless, DiGA and aids must agree on a common identifier for the patient in order to be able to implement data transmission on a user-based basis. The identifier must be specific to the combination of DiGA and assistive devices. It must be a pseudonym, i.e. it must be excluded that third parties can draw conclusions about the identity of the data subject solely from knowledge of the identifier. 

The coupling-specific user pseudonym spans the coupling context between the DiGA and the aid/implant without a DiGA gaining knowledge of the user ID of the aid. This prevents sensitive data such as e.g. email addresses commonly used for the user ID are disclosed. The pseudonym also serves for an overarching assignment of the respective consent of an insured person or the company data (protocols of DiGA and HiMi).
1.	The pseudonym must be unique (at least) within a tool and must not allow any conclusions to be drawn about the user's identity.
2.	The pseudonym must be linked to the user identity in the tool (Authorization Server and Resource Server).
3.	The pseudonym must not be guessable, i.e. it must be unpredictable and correspondingly long.

Exemplary implementation would be:

`Hash(DiGA-ID, User-ID, Salt)`

whereby "Salt" is a random value known only to the HiMi backend, which is never transmitted and should be at least 128 bits long.



#### Identification and Authentication of the DiGA

#### Identitfication and Authentication of the Device Data Recorder

### Authorization of the DiGA


#### Consent
Data transfer from the aid or implant may only be carried out on the basis of the insured person's consent. In accordance with Art. 7 (3) GDPR, users must therefore be able to revoke their consent at any time once they have been declared. The period of validity of the consent should be adapted to the data protection requirements of the DiGAs. This means that consent for data transmission in accordance with Section 374a SGB V expires at the latest when the prescription period of the DiGA has expired. In addition, manufacturers are generally responsible for properly obtaining and renewing consent and monitoring any revocations as well as the follow-up obligations.

#### Notion of "data for intended use"
In accordance with § 374a SGB V, the BfArM defines the "for intended use" at the level of the vibW per DiGA in the form of a reference to the vibW-specific ValueSet as an entry for a specific DiGA in the DiGA-VZ. The specification to be drawn up in accordance with § 374a SGB V specifies which specific resources (FHIR Observation, Device, DeviceMetric) can be accessed by a DiGA for a vibW and with which method (read, search).

Based on the consent of a specific user, the DiGA-VZ entry with the vibW-specific authorizations for a DiGA, the RESTful FHIR API grants a DiGA access only to:
- FHIR resources with only data about a specific user AND
- FHIR resources for which this user has consented to access through a DiGA AND
- Read-only and search-only access to FHIR resources AND
- FHIR resources with vibW data for which a DiGA has been authorized by the BfArM OR
- FHIR resources with device data that measured the vibW data for which a DiGA was authorized by the BfArM.

If a HiMi manufacturer implements access tokens in the form of opaqen or unstructured tokens, the HiMi (Authorization Server and Resource Server) must manage these relationships internally.

### Secure Communication via mTLS
Connections between the DiGA and HiMi backend are secured via a mutually authenticated TLS channel (mTLS). Since the connection takes place over the Internet, the trust space of the Internet PKI is used. Specifically, the CAs that are members of the CA/Browser Forum form the trust space and CA Authorization (CAA, https://datatracker.ietf.org/doc/html/rfc8659) and Certificate Transparency (CT, https://datatracker.ietf.org/doc/html/rfc6962) are implemented.

For all connections, the DiGA backend acts as a client and the HiMi backend as a server. In the course of establishing a TLS connection, the following steps must be completed as part of the certificate check:
1. Verification of the server certificate of the HiMi backend by the DiGA backend
   - Note: The DiGA backend knows which HiMi backend it wants to communicate with and has determined the FQDN from the HiMi directory of the BfArM in advance for the connection establishment.
   - Check for the trust space CA/Browser Forum
   - Check that the called URI is covered by the FQDN (CN or SAN) specified in the presented server certificate
   - Checking for temporal validity
   - Check that at least two Signed Certificate Timestamps (SCT) are included in the certificate and that they are signed by known CT-Log operators
2. Verification of the client certificate of the DiGA backend by the HiMi backend
   - Check for the trust space CA/Browser Forum
   - Extraction of the FQDN from the presented client certificate (CN and SAN; possibly several FQDN included) and later comparison with the information from the DiGA directory of the BfArM
   - Checking for temporal validity
   - Check that at least two Signed Certificate Timestamps (SCT) are included in the certificate and that they are signed by known CT-Log operators

DiGA and HiMi operators must implement CA Authorization (CAA) and publish a corresponding DNS record for their domain. DiGA and HiMi operators must continuously check the CT logs of the known CT log operators (https://certificate.transparency.dev/google/) for unauthorized certificates for their own domain. The measure ensures that unauthorized certificates are detected and that the operator can report this to the issuing CA. The incident does not go undetected and the affected CA can react to it. In addition, the CA then revokes the certificate issued without authorization. The measure is fully effective if, in addition to the above-mentioned verification steps, the verifying entity also checks the revocation status of the presented certificate against the revocation lists (CRL) provided by the issuing CA. Due to the not inconsiderable size of the CRLs, this can lead to performance problems.

___Additional Notes___: 
* The list of signature verification keys is published by the browser manufacturers, for example. The measure ensures that no certificates are accepted that are not contained in at least two CT logs.
* During the TLS connection, only the certificate of the client is initially determined. The information from it (FQDN or CN &amp; SAN or entire certificate) must then be passed on to the application layer. There, a comparison must take place with the information from the DiGA directory of the BfArM in order to identify the DiGA. If further identification data is transmitted to the DiGA at the application level (e.g. client_id), it must be checked that the identification data match.


### Audit Trails


### Transparency of Operations



### Limits of security performance
The transfer of data between HiMi and DiGA and the necessary pairing between the two is considered here. The processing of the data before or after it is transmitted is not considered. This includes internal processes at the backend operators, protection of data during storage, protection of the existing and new interfaces against hacking attacks, the authentication of the insured person in order to access DiGA and HiMi, as well as the secure implementation of the respective front-end back-end communication.

- Weak user authentication in DiGA and/or HiMi
- Attacks by insiders on the DiGA and/or HiMi backend
- Attacks by users who are authenticated to the DiGA or HiMi and send manipulated requests to the DiGA or HiMi backend
- Attacks against the robustness of the interfaces available on the Internet (also includes the new DiGA&lt;=&gt;HiMi interface)

Likewise, the two directories of the BfArM for DiGAs and HiMis are not considered, although they play a significant role in the security of the solution. The BfArM is responsible for this. This concerns, for example:
- Accidentally incorrect entries in the VZ
- Inadequate processes for checking the authenticity of transmitted data, which enable unauthorized persons to bring their own content to the VZ
- Inadequate processes to protect the FT, which allow unauthorized persons to make entries directly to the FT themselves

The threats and vulnerabilities affecting these parties, components, and services must be considered by those responsible. This is outside the scope for which gematik has a mandate.

