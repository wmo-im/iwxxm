<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="saf" uri="http://icao.int/saf/1.1"></sch:ns>
   <sch:ns prefix="sam" uri="http://www.opengis.net/sampling/2.0"></sch:ns>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"></sch:ns>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"></sch:ns>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"></sch:ns>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"></sch:ns>
   <sch:pattern id="Aerodrome1">
      <sch:rule context="//saf:Aerodrome/saf:designator">
         <sch:assert test="matches(text(), '^([A-Z]|\d){3,6}$')">Aerodrome: designator not match with pattern CodeAirportHeliportDesignatorType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Aerodrome2">
      <sch:rule context="//saf:Aerodrome/saf:name">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,60}$')">Aerodrome: name not match with pattern TextNameType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Aerodrome3">
      <sch:rule context="//saf:Aerodrome/saf:locationIndicatorICAO">
         <sch:assert test="matches(text(), '^[A-Z]{4}$')">Aerodrome: locationIndicatorICAO not match with pattern CodeICAOType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Aerodrome4">
      <sch:rule context="//saf:Aerodrome/saf:designatorIATA">
         <sch:assert test="matches(text(), '^[A-Z]{3}$')">Aerodrome: designatorIATA not match with pattern CodeIATAType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Runway1">
      <sch:rule context="//saf:Runway/saf:designator">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,16}$')">Runway: designator not match with pattern TextDesignatorType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="RunwayDirection1">
      <sch:rule context="//saf:RunwayDirection/saf:designator">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,16}$')">RunwayDirection: designator not match with pattern TextDesignatorType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Airspace1">
      <sch:rule context="//saf:Airspace/saf:designator">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,10}$')">Airspace: designator not match with pattern CodeAirspaceDesignatorType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Airspace2">
      <sch:rule context="//saf:Airspace/saf:name">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,60}$')">Airspace: name not match with pattern TextNameType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Unit1">
      <sch:rule context="//saf:Unit/saf:name">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,60}$')">Unit: name not match with pattern TextNameType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Unit2">
      <sch:rule context="//saf:Unit/saf:designator">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9])+([ \+\-/]*([A-Z]|[0-9])+){1,12}$')">Unit: designator not match with pattern CodeOrganisationDesignatorType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Service1">
      <sch:rule context="//saf:Service/saf:name">
         <sch:assert test="matches(text(), '^([A-Z]|[0-9]|[, !&#34;&amp;#\$%''\(\)\*\+\-\./:;&lt;=&gt;\?@\[\\\]\^_\|\{\}]){1,60}$')">Service: name not match with pattern TextNameType</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
