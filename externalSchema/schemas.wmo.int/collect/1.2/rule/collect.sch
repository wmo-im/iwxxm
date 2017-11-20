<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="collect" uri="http://def.wmo.int/collect/2014"/>
   <sch:ns prefix="sf" uri="http://www.opengis.net/sampling/2.0"/>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"/>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
   <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"/>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
   <sch:pattern id="COLLECT.MB1">
      <sch:rule context="//collect:MeteorologicalBulletin">
         <sch:assert test="count(distinct-values(for $item in //collect:meteorologicalInformation/child::node() return(node-name($item))))eq 1">COLLECT.MB1: All meteorologicalInformation instances in MeteorologicalBulletin must be of the same type</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
