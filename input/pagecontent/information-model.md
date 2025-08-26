**@Jörg**

### Interoperable FHIR-based Data Model for vibW

The diagram describes an interoperable, FHIR-based data model for the structured provision of **vibW** between assistive devices (HiMi) and DiGAs, exemplarily illustrated for the vibW "blood glucose."

The **Observation `vibW_BloodGlucose`** represents a specific measurement (e.g., `valueQuantity.value = 90`, `unit = mg/dL`). This measurement references a corresponding **DeviceMetric** resource, **`DeviceMetric_GlucometerConfig`**, via the `device` attribute. The DeviceMetric describes the configuration of the measuring device—particularly the unit, calibration status, and the specific device (`source`).

The **DeviceMetric** is linked to a concrete **Device** instance, **`DeviceInstance_Glucometer`**, which contains the serial number, model name, and manufacturer information. This instance references its technical description through the `definition` attribute to the **DeviceDefinition `DD_Sensor_AccuChekMobile`**.

The **DeviceDefinition** of the sensor describes which vibW (e.g., LOINC:2339-0 for blood glucose) this device type can capture. This is done via `capability.type`, which references a **ValueSet `VS_HiMi_ACM_SupportedVibW`**. Additionally, the DeviceDefinition specifies the unit (e.g., mg/dL) through `property.valueCode`, also based on a UCUM-based ValueSet **`VS_BloodGlucose_Units`**. Optionally, a value range (`property.valueRange`) can be provided for orientation or validation.

For describing device types (e.g., glucometer, rtCGM, HiMi backend, etc.), the **CodeSystem `CS_HiMi_DeviceType`** is used.

To model the § 374a interface directory, a backend can also be represented as its own **DeviceDefinition `DeviceDefinition_HiMi_Backend`**. This backend can be linked as a `parentDevice` to one or more sensor devices.

<div>{% include information_model.svg %}</div>
<br clear="all"/>