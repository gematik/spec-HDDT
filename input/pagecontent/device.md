**FHIR resource type**: Device

FHIR Attribute | Description | Cardinality | FHIR Data Type | Note |
---------------|------------|------------|----------------|------|
| serialNumber | Serial number | 1..1 | string | User verification (patient safety) |
| deviceName | Product name | 1..1 | string | e.g., "Accu-Chek Mobile" |
| manufacturer | Manufacturer | 0..1 | string | Sensor manufacturer |
| definition | Device definition | 1..1 | Reference(DeviceDefinition) | Link to device description |

---