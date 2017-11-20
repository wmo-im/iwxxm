<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="metce" uri="http://def.wmo.int/metce/2013"/>
   <sch:ns prefix="sf" uri="http://www.opengis.net/sampling/2.0"/>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"/>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
   <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"/>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
   <sch:pattern id="METCE.MC2">
      <sch:rule context="//metce:MeasurementContext">
         <sch:assert test="(if(exists(metce:measuringInterval) or exists(metce:resolutionScale)) then(exists(metce:unitOfMeasure)) else(true()))">METCE.MC2: if measuringInterval or resolutionScale or both are given then unitOfMeasure must also be provided</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METCE.MC1">
      <sch:rule context="//metce:MeasurementContext">
         <sch:assert test="(true())">METCE.MC1: If unitOfMeasure exists it shall be appropriate for measurand</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METCE.RB1">
      <sch:rule context="//metce:RangeBounds">
         <sch:assert test="(number(metce:rangeStart/text()) lt number(metce:rangeEnd/text()))">METCE.RB1: The extreme lower limit of the range of interval must be less than the extreme upper limit</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
