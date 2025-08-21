**To Do**
* Überarbeitung/Konkretisierung Endpunkte (gematik, _fbeta)
* Beschreibung Endpunkte (Thomas, Sergej)
* Protokollierung (Thomas, Sergej)
* Fehlerbehandlung (Thomas, Sergej)
* openAPI (Thomas, Sergej)
* Beispiele (Thomas, Sergej)

### OAuth 2.0 Authorization Code Grant API (OAuth ACG API)

**Description**  
Authorization of a DiGA for accessing FHIR resources of a medical device/implant allowed for this DiGA, using the OAuth 2.0 Authorization Code Flow.

| Description | Standard | Specifications | Quality Criteria |
|-------------|-----------|----------------|------------------|
| Authorization of a DiGA for access to FHIR resources of a medical device/implant using the OAuth 2.0 Authorization Code Flow. | rfc6749<br>rfc7636<br>rfc8705<br>rfc6750 | Authorization Code Flow with PKCE (mandatory from OAuth 2.1)<br>Mutual-TLS Client Authentication<br>PKI Mutual-TLS Method<br>**No** certificate-bound access tokens<br>Confidential OAuth Client<br>Self-encoded Bearer Token | Security: rfc9700 |

---

### Endpoints

| Endpoint | Use Case | Standard | Specifications | Data Objects |
|----------|----------|----------|----------------|--------------|
| `/.well-known/oauth-authorization-server` | Initial configuration of a DiGA<br>Automated discovery for DiGA (as OAuth Client)<br>Automated adaptation of DiGA configuration (as OAuth Client) | rfc8414 | No signed Authorization Server Metadata<br>No Mutual-TLS Client Authentication (public endpoint) | Authorization Server Metadata Document |
| `/par` | Client authentication before user consent & authorization request<br>Transmission of potentially sensitive information only between backends<br>Avoid URL length limitations in User Agents (browser) | rfc9126 | PKCE<br>No `request` parameter<br>Response with `response_type=code`<br>Response with `expires_in` parameter<br>No rfc9101 (backend communication only) | `request_uri`<br>`expires_in` |
| `/authorize` | User-agent based user interaction for authorization and consent | – | Request only with `client_id` and `request_uri` (from `/par`)<br>Strict `redirect_uri` validation<br>No Mutual-TLS Client Authentication (frontend calls this endpoint) | `code`<br>User Consent / Consent decision |
| `/token` | Authorization of DiGA via access token issuance<br>Signal granted permissions<br>Access-token renewal via refresh-token (without user interaction) | – | PKCE<br>Response includes OAuth scope parameter in HTTP body (JSON)<br>Token Response extension in HTTP body with parameter: `"sub": "{coupling-specific pseudonym}"`<br>Issuance of access **and** refresh tokens<br>Refresh token rotation<br>No token encryption (backend communication only) | Coupling-specific pseudonym<br>OAuth scope parameter<br>Access Token<br>Refresh Token |
| `/revoke` | DiGA-initiated invalidation of refresh tokens to signal revoked consent | rfc7009 | Revocation of refresh-token invalidates all access-tokens for the associated authorization grant and the authorization grant itself | Refresh Token |
