<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="metce" uri="http://def.wmo.int/metce/2013"></sch:ns>
   <sch:ns prefix="sam" uri="http://www.opengis.net/sampling/2.0"></sch:ns>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"></sch:ns>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"></sch:ns>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"></sch:ns>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"></sch:ns>
   <sch:pattern id="MeasurementContext1">
      <sch:rule context="//metce:MeasurementContext">
         <sch:assert test="((: TO BE IMPLEMENTATED WHEN REPOSITORY IS READY :) true())">MeasurementContext: unitOfMeasure shall be appropriate for measurand</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeasurementContext2">
      <sch:rule context="//metce:MeasurementContext">
         <sch:assert test="(if( exists(metce:measuringInterval) or exists(metce:resolutionScale) ) then ( exists(metce:unitOfMeasure) ) else( true() ))">MeasurementContext: if measuringInterval or resolutionScale or both are given then
            uom must also be provided
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="RangeBounds1">
      <sch:rule context="//metce:RangeBounds">
         <sch:assert test="(number( metce:rangeStart/text() ) lt number( metce:rangeEnd/text() ))">RangeBounds: The extreme lower limit of the range of interval must be less than the
            extreme upper limit.
         </sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>