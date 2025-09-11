**ToDo Jie, Emil, Sergej**

- Also examples of data requests and of the answers

### Observation – Blood Glucose Value

Example of a measured blood glucose value (`92 mg/dL`) with reference to device configuration. The observation includes details such as the measurement time, and links to the device used for measurement.

```
{
  "resourceType": "Observation",
  "id": "345720845ad235ee32",
  "status": "final",
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "2339-0",
        "display": "Glucose [Mass/volume] in Blood"
      }
    ]
  },
  "effectiveDateTime": "2025-09-02T09:30:00+01:00",
  "valueQuantity": {
    "value": 92,
    "unit": "mg/dl",
    "system": "http://unitsofmeasure.org",
    "code": "mg/dL"
  },
  "device": {
    "reference": "DeviceMetric/dm234788148233190"
  },
}
```

### DeviceMetric – Device Configuration

Contains calibration status and measurement unit. This resource provides information about the current configuration of the device, including calibration details, measurement frequency, and unit of measurement.

### Device – Device Instance

Describes manufacturer, model name, and serial number. The device resource documents the physical device used for the measurement, including its unique identifiers, manufacturer information, and model specifications.

These examples illustrate how FHIR resources can be used to represent clinical measurements, device information, and patient data in a standardized way.

<a name="profile"> </a>

  <h3 id="profile">Formal Views of Profile Content</h3>
  <p>
    <a href="http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions">Description of Profiles, Differentials, Snapshots and how the different presentations work</a>.
  </p>
  <div id="tabs">
    <ul>
      <li>
        <a href="#tabs-key">Key Elements Table</a>
      </li>
      <li>
        <a href="#tabs-diff">Differential Table</a>
      </li>
      <li>
        <a href="#tabs-snap">Snapshot Table</a>
      </li>
{% unless excludexml == 'y' %}
<!--      <li>
        <a href="#tabs-xml">Pseudo-XML</a>
      </li>-->
{% endunless %}
{% unless excludejson == 'y' %}
<!--      <li>
        <a href="#tabs-json">Pseudo-JSON</a>
      </li>-->
{% endunless %}
{% unless excludettl == 'y' %}
      <!--<li>
        <a href="#tabs-ttl">Pseudo-TTL</a>
      </li>-->
{% endunless %}
      <li>
        <a href="#tabs-summ">Statistics/References</a>
      </li>
      <li>
        <a href="#tabs-all">All</a>
      </li>
    </ul>
    <a name="tabs-key"> </a>
    <div id="tabs-key">
      <div id="tbl-key">
        <div id="tbl-key-inner">

          <!-- @Jörg: Syntax ist StructureDefinition-{{id}}-xxx.xhtml -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot-by-key.xhtml%}
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx-key.xhtml%}
        
          {% capture invariantskey %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-key.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariantskey.size <= 218 %}
            <a name="inv-key"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-key.xhtml %}
          {% endunless%}
        </div>
      </div>
    </div>
    <a name="tabs-diff"> </a>
    <div id="tabs-diff">
      <div id="tbl-diff">
        <p>This structure is derived from <a href="{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basepath}}">{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basename}}</a>
        </p>
        <div id="tbl-diff-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-diff.xhtml%}
          <a name="tx"> </a>
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx-diff.xhtml%}
        
          {% capture invariantsdiff %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-diff.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariantsdiff.size <= 218 %}
            <a name="inv-diff"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-diff.xhtml %}
          {% endunless%}
        </div>
      </div>
    </div>
    <a name="tabs-snap"> </a>
    <div id="tabs-snap">
      <div id="tbl-snap">
        <div id="tbl-snap-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot.xhtml%}
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx.xhtml%}
        
          {% capture invariants %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariants.size <= 218 %}
            <a name="inv-snap"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv.xhtml %}
          {% endunless%}
        </div>
      </div>
    </div>
{% unless excludexml == 'y' %}
<!--    <a name="tabs-xml"> </a>
    <div id="tabs-xml">
      <div id="xml">
        <div id="xml-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-xml.xhtml%}
        </div>
      </div>
    </div>-->
{% endunless %}
{% unless excludejson == 'y' %}
<!--    <a name="tabs-json"> </a>
    <div id="tabs-json">
      <div id="json">
        <div id="json-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-json.xhtml%}
        </div>
      </div>
    </div>-->
{% endunless %}
{% unless excludettl == 'y' %}
    <!--<a name="tabs-ttl"> </a>
    <div id="tabs-ttl">
      <div id="ttl">
        <div id="ttl-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-ttl.xhtml%}
        </div>
      </div>
    </div>-->
{% endunless %}
    <a name="tabs-summ"> </a>
    <div id="tabs-summ">
      <div id="tbl-summ">
        <p>This structure is derived from <a href="{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basepath}}">{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basename}}</a>
        </p>
        <div id="tbl-summ-inner">
          <a name="summary"> </a>
          {%include StructureDefinition-Observation-CGM-Measurement-Series-summary.xhtml%}
        </div>
      </div>
    </div>
    <a name="tabs-all"> </a>
    <div id="tabs-all">
      <div id="all-tbl-key">
        <p>
          <b>Key Elements View</b>
        </p>
        <div id="all-tbl-key-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot-by-key-all.xhtml%}
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx-key.xhtml%}
        
          {% capture invariantskey %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-key.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariantskey.size <= 218 %}
            <a name="inv-all-key"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-key.xhtml %}
          {% endunless%}
        </div>
      </div>
      <div id="all-tbl-diff">
        <p>
          <b>Differential View</b>
        </p>
        <p>This structure is derived from <a href="{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basepath}}">{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basename}}</a>
        </p>
        <div id="all-tbl-diff-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-diff-all.xhtml%}
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx-diff.xhtml%}
        
          {% capture invariantsdiff %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-diff.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariantsdiff.size <= 218 %}
            <a name="inv-all-diff"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv-diff.xhtml %}
          {% endunless%}
        </div>
      </div>
      <div id="all-tbl-snap">
        <p>
          <b>Snapshot View</b>
        </p>
        <div id="all-tbl-snap-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-snapshot-all.xhtml%}
          <!--Terminology Bindings heading in the fragment -->
          {%include StructureDefinition-Observation-CGM-Measurement-Series-tx.xhtml%}
        
          {% capture invariants %}
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv.xhtml %}
          {% endcapture %}
          <!-- 218 is size of empty table -->
          {% unless invariants.size <= 218 %}
            <a name="inv-all-snap"> </a>
            <!--Constraints  heading in the fragment -->
            {% include StructureDefinition-Observation-CGM-Measurement-Series-inv.xhtml %}
          {% endunless%}
        </div>
      </div>
{% unless excludexml == 'y' %}
      <!--<div id="all-xml">
        <p>
          <b>XML Template</b>
        </p>
        <div id="all-xml-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-xml.xhtml%}
        </div>
      </div>-->
{% endunless %}
{% unless excludejson == 'y' %}
      <!--<div id="all-json">
        <p>
          <b>JSON Template</b>
        </p>
        <div id="all-json-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-json.xhtml%}
        </div>
      </div>-->
{% endunless %}
{% unless excludettl == 'y' %}
      <!--<div id="all-ttl">
        <p>
          <b>TTL Template</b>
        </p>
        <div id="all-ttl-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-pseudo-ttl.xhtml%}
        </div>
      </div>-->
{% endunless %}
      <div id="all-summ">
        <p>This structure is derived from <a href="{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basepath}}">{{site.data.structuredefinitions['Observation-CGM-Measurement-Series'].basename}}</a>
        </p>
        <div id="all-summ-inner">
          {%include StructureDefinition-Observation-CGM-Measurement-Series-summary-all.xhtml%}
        </div>
      </div>
    </div>
  </div>
