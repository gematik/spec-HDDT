
Requirements, as an expression of normative specifications, are indicated by the German keywords written in uppercase—MUSS, DARF NICHT, SOLL, SOLL NICHT, KANN—and their plural forms, in accordance with [RFC 2119](https://tools.ietf.org/html/rfc2119 "RFC 2119").

## Impact on Certification and Test Reports

**SHALL / MUSS** indicates, in Device2DiGA, a requirement that must be fulfilled. The requirement is covered by one or more tests, so a system cannot be certified for the respective module if it fails any test that verifies compliance with the requirement.

**MAY / KANN** indicates, in Device2DiGA, an optional requirement. The requirement is covered by a test, but the result of this test does not affect the certification of a system for the respective module. If the test for an optional requirement is passed successfully, the result is included in the test report.
