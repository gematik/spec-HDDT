_Hinweis: Der Text ist einfach nur per Copilot übersetzt und muss noch geprüft und angepasst werden._

### Availability
#### Availability Goals
The service MUST maintain at least 99.5% monthly availability. Availability MUST be calculated in relation to one entire calendar month. Planned and unplanned unavailability need to be taken into account in accordance with the rules defined below.

#### Uptime 
The service MUST be available 24 hours a day, 7 days a week (24/7). 

#### Maintenance Windows
Scheduled maintenance windows MAY only be performed in connection with specification changes or product changes. Scheduled maintenance MUST be announced at least 5 business days prior to commencement, including start time, end time, expected impact, and touchpoint. During a planned maintenance window, impairments MAY occur; these times are considered planned unavailability and are excluded from the availability calculation, if the notification and communication obligations have been met.

The service MUST provide a machine-readable response (e.g., specific HTTP status/error code and/or dedicated header/response body) during an active maintenance window that allows DiGA clients to clearly identify that a scheduled maintenance is currently active. Alternatively or additionally, out-of-band information (e.g. status feed/status page/webhook) MUST be provided.

#### Error Detection and Error Coding in Case of Unavailability
In the event of unavailability (planned or unplanned), the service MUST provide clear, documented error codes that differentiate the cause (e.g. planned maintenance, temporary disruption, dependency failed).

For planned maintenance, a dedicated code/flag MUST be used, which is different from generic 5xx errors, so that DiGA clients can react accordingly (retry strategies, user notices).

#### Duty to Provide Information 
The provider MUST inform as early as possible in the event of (imminent or occurring) unavailability.

A public, machine-readable status feed MUST be provided that contains at least the following information:
* Current operational status (operational/demoted/unavailable)
* Start, end (as soon as known) and cause of the fault or maintenance window
* Affected functions/endpoints
* Next update time or timestamp of the last update

### Response times (latency) in regular operation
#### Response Time
The service MUST relate its response times on a defined reference system. The target values published in the interface documentation per endpoint/category (e.g. authentication, read, write operations) are used as a reference.

For each referenced endpoint, 95% of all responses must be fast enough that their time does not exceed one and a half times the specified reference value over a course of a calendar month (P95, 95th percentile response time).
Example: Reference P95 = 400 ms → permissible P95 ≤ 600 ms.

#### Independent monitoring of response times
The provider MUST operate continuous synthetic monitoring that captures P50/P95/P99 response times per endpoint. The retention period is 30 days.

#### AFO Throughput and Load Requirements
The service MUST be able to handle at least 50 parallel requests per second without violating the availability or response time targets. If the specified load is exceeded, requests MAY be rejected without counting as unavailability.

Rejected requests MUST be documented with a clear error:
* Recommended: HTTP 429 Too Many Requests with Header Retry-After.
* Alternatively allowed: HTTP 503 with explicit rate-limit error code in the body and retry-after.

Correctly documented rejections due to allowed rate limits (e.g. 429 with Retry-After) do NOT count as unavailability or downtime.

### Self-Logged Monitoring
#### AFO Scope of Logging
The provider MUST log every incoming call to the interface as well as every associated response (request-response pair).

The logs MUST contain at least the following metadata per operation:

| Attribute         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| checksum          | Optional for integrity check of protocol data                               |
| data_volume_bytes | Data transfer volume                                                        |
| error_code        | In case of malfunctions: standardized error number                          |
| error_description | In case of malfunctions: explanatory text                                   |
| event_type        | Interface operation, e.g., "Heartbeat", "Connection", "Transfer"            |
| interface_id      | Unique identifier of the interface operator                                 |
| message           | Message text                                                                |
| pairing_id        | Coupling-specific user pseudonym                                            |
| partner_id        | Full FQDN of the executed operation                                         |
| response_time_ms  | Response time                                                               |
| status            | 3-digit HTTP status code according to [RFC9110]                             |
| timestamp         | Time of the respective action or status message (ISO-8601, including timezone) |
| transaction_id    | Unique request ID/Correlation ID                                            |

#### Retention Period and Deletion
The logs MUST be kept audit-proof for at least 30 days from the date of creation.

After the retention period has expired, logs MUST be deleted in a timely manner and in compliance with data protection regulations.

#### Information Obligation and Provision Channel
The provider MUST provide a dedicated request channel to request log information (e.g., email address, ticket portal, or API endpoint). This channel MUST be named in the interface documentation.

A legitimate request for the release of minutes MUST be responded to within 3 working days:
* Confirmation of receipt 
* Provision of the requested minutes excerpts or a binding delivery date, with justification, if not immediately possible

The release MUST be earmarked, secure and encrypted (e.g. password-protected archives, mTLS-secured download links). The identity and authorization of the requester MUST be verified before deployment.

#### Formats and Filterability
Protocols MUST be provided in a standard machine-readable format (e.g. B. JSON lines). Timestamps MUST be ISO-8601 compliant.

It MUST be possible to filter logs by time period, client/tenant, endpoint, status code, and correlation ID

#### AFO Proof and Audit Capability
The provider MUST provide proof of log integrity (e.g. checksums/signatures) and completeness for a period of time upon request.


Changes to logging scopes, masking rules, or retention periods MUST be documented and dated with a date stamp. Affected parties SHOULD be informed at least 10 business days prior to the productive change, unless there are security reasons to the contrary.
