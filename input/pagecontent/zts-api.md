### ZTS Endpoints in the context of §374a SGB V

| Endpoint / Reference         | Use Cases                                                                                                   | Data Objects                                                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `/packages/catalog`           | Identify FHIR packages containing §374a-relevant ValueSets for specific medical devices/implants and DiGA   | Package catalog (list of available FHIR packages)                                                                                |
| `/packages`                   | Retrieve §374a-relevant code systems, ValueSets, metadata, etc.<br>Provide device-/implant-specific ValueSets for HiMi-SST-VZ as subset of §374a ValueSets<br>Enable interpretation of device/implant data by a DiGA | `VS_vibW` (e.g., VS_BloodPressure)<br>`VS_HiMi_DeviceType` (for HiMi-SST-VZ)<br>`VS_vibW_AuthZ`<br>`CS_OAuth_Scopes`<br>`CS_HiMi_DeviceType` |
| `/api/generate-token`         | Acceptance of ZTS download terms before package retrieval                                                   | JSON Web Token                                                                                                                   |
| `/feeds/**`                   | Subscribe to automated notifications on updates of FHIR packages containing §374a-relevant code systems, ValueSets, metadata | RSS Feed                                                                                                                         |

#### Notes
- `VS_vibW_AuthZ` (alternative: `CS_OAuth_Scopes`) should be accessible to both DiGA and HiMi manufacturers if a **normed user-consent** across all DiGA/HiMi is required.  
- `CS_HiMi_DeviceType` should be accessible to both DiGA and HiMi manufacturers (e.g., for HiMi manufacturers when using the normed scope for Device resources).  
