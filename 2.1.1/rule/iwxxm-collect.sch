<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="collect" uri="http://def.wmo.int/collect/2014"/>
   <sch:ns prefix="iwxxm" uri="http://icao.int/iwxxm/2.1"/>
   <sch:ns prefix="sf" uri="http://www.opengis.net/sampling/2.0"/>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"/>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
   <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"/>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
   <sch:ns prefix="aixm" uri="http://www.aixm.aero/schema/5.1.1"/>
   <sch:pattern id="COLLECT.MB1">
      <sch:rule context="//collect:MeteorologicalBulletin">
         <sch:assert test="count(distinct-values(for $item in //collect:meteorologicalInformation/child::node() return(node-name($item))))eq 1">COLLECT.MB1: All meteorologicalInformation instances in MeteorologicalBulletin must be of the same type</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ARS1">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if(@allRunways eq 'true') then( empty(iwxxm:runway) ) else true())">METAR_SPECI.ARS1: When all runways are being reported upon, no specific Runway should be reported</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ARS2">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if( exists(iwxxm:runway) ) then( empty(@allRunways) or (@allRunways eq 'false') ) else true())">METAR_SPECI.ARS2: When a single Runway is reported upon, the allRunways flag should be missing or false</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ARVR1">
      <sch:rule context="//iwxxm:AerodromeRunwayVisualRange">
         <sch:assert test="(if(exists(iwxxm:meanRVR) and (not(exists(iwxxm:meanRVR/@xsi:nil)) or iwxxm:meanRVR/@xsi:nil != 'true')) then (iwxxm:meanRVR/@uom = 'm') else true())">METAR_SPECI.ARVR1: meanRVR shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep2">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if( empty(iwxxm:observation//iwxxm:cloud/iwxxm:AerodromeObservedClouds) and ends-with(iwxxm:observation//iwxxm:cloud/@nilReason, 'notDetectedByAutoSystem') ) then(@automatedStation eq 'true') else(true()))">METAR_SPECI.MAORep2: When no clouds are detected by the auto system, this report must be an auto report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep1">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if(@status eq 'MISSING') then( exists(iwxxm:observation//om:result/@nilReason) and ((empty(@automatedStation) or (@automatedStation eq 'false')) and empty(iwxxm:trendForecast)) ) else(true()))">METAR_SPECI.MAORep1: Missing reports only include identifying information (time, aerodrome) and no other information</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep6">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if(exists(.//iwxxm:trendForecast) and not((count(.//iwxxm:trendForecast) eq 1) and (.//iwxxm:trendForecast = ''))) then(empty(distinct-values(for $trend-forecast in .//iwxxm:trendForecast return((deep-equal(.//iwxxm:observation/om:OM_Observation/om:featureOfInterest//sf:sampledFeature,$trend-forecast/om:OM_Observation/om:featureOfInterest//sf:sampledFeature)) or (concat('#', current()//iwxxm:observation/om:OM_Observation/om:featureOfInterest/sams:SF_SpatialSamplingFeature/@gml:id)=$trend-forecast/om:OM_Observation/om:featureOfInterest/@xlink:href)))[.=false()])) else(true()))">METAR_SPECI.MAORep6: The sampled feature should be equal in observation and trendForecast</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep3">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(((exists(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/aixm:AirportHeliport)) or (contains(string(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'aerodrome')) ) and ( if(exists(.//om:OM_Observation/om:featureOfInterest/@xlink:href)) then(concat( '#', current()//om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = .//om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())))">METAR_SPECI.MAORep3: The sampled feature for a METAR/SPECI observation is an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep7">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:observation)) then(not(exists(iwxxm:observation//om:procedure/*[name() != 'metce:Process']))) else(true()))">METAR_SPECI.MAORep7: The procedure of a METAR/SPECI observation should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep4">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:observation)) then(not(exists(iwxxm:observation//om:result/*[name() != 'iwxxm:MeteorologicalAerodromeObservationRecord']))) else(true()))">METAR_SPECI.MAORep4: The result of a METAR/SPECI observation should be a MeteorologicalAerodromeObservationRecord</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORep5">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="(if(exists(iwxxm:trendForecast)) then(not(exists(iwxxm:trendForecast//om:result/*[name() != 'iwxxm:MeteorologicalAerodromeTrendForecastRecord']))) else(true()))">METAR_SPECI.MAORep5: The result of a METAR/SPECI trendForecast should be a MeteorologicalAerodromeTrendForecastRecord</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASS1">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( exists(iwxxm:seaState) ) then ( empty(iwxxm:significantWaveHeight) ) else (true()))">METAR_SPECI.ASS1: If the sea state is set, significantWaveHeight is not reported (one or the other)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASS3">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( empty(iwxxm:seaState) ) then ( exists(iwxxm:significantWaveHeight) ) else (true()))">METAR_SPECI.ASS3: Either seaState or significantWaveHeight must be present</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASS4">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if(exists(iwxxm:seaSurfaceTemperature) and (not(exists(iwxxm:seaSurfaceTemperature/@xsi:nil)) or iwxxm:seaSurfaceTemperature/@xsi:nil != 'true')) then (iwxxm:seaSurfaceTemperature/@uom = 'Cel') else true())">METAR_SPECI.ASS4: seaSurfaceTemperature shall be reported in degrees Celsius (Cel).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASS2">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( exists(iwxxm:significantWaveHeight) ) then ( empty(iwxxm:seaState) ) else (true()))">METAR_SPECI.ASS2: If the significantWaveHeight is set, seaState is not reported (one or the other)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASS5">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if(exists(iwxxm:significantWaveHeight) and (not(exists(iwxxm:significantWaveHeight/@xsi:nil)) or iwxxm:significantWaveHeight/@xsi:nil != 'true')) then (iwxxm:significantWaveHeight/@uom = 'm') else true())">METAR_SPECI.ASS5: significantWaveHeight shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AWS1">
      <sch:rule context="//iwxxm:AerodromeWindShear">
         <sch:assert test="(if( @allRunways eq 'true' ) then( empty(iwxxm:runway) ) else true())">METAR_SPECI.AWS1: When all runways are affected by wind shear, no specific runways should be reported</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MATFR5">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @changeIndicator eq 'NO_SIGNIFICANT_CHANGES' ) then (empty(iwxxm:prevailingVisibility) and empty(iwxxm:prevailingVisibilityOperator) and empty(iwxxm:clouds) and empty(iwxxm:forecastWeather) and empty(iwxxm:cloudAndVisibilityOK)) else (true()))">METAR_SPECI.MATFR5: prevailingVisibility, prevailingVisibilityOperator, clouds, forecastWeather and cloudAndVisibilityOK should be absent when changeIndicator equals 'NO_SIGNIFICANT_CHANGES'</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MATFR1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:cloud)) else (true()))">METAR_SPECI.MATFR1: clouds should be absent when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MATFR2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:forecastWeather)) else (true()))">METAR_SPECI.MATFR2: forecastWeather should be absent when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MATFR4">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:prevailingVisibility) and empty(iwxxm:prevailingVisibilityOperator)) else (true()))">METAR_SPECI.MATFR4: prevailingVisibility and prevailingVisibilityOperator should be absent when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MATFR3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if(exists(iwxxm:prevailingVisibility) and (not(exists(iwxxm:prevailingVisibility/@xsi:nil)) or iwxxm:prevailingVisibility/@xsi:nil != 'true')) then (iwxxm:prevailingVisibility/@uom = 'm') else true())">METAR_SPECI.MATFR3: prevailingVisibility shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec6">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(exists(iwxxm:airTemperature) and (not(exists(iwxxm:airTemperature/@xsi:nil)) or iwxxm:airTemperature/@xsi:nil != 'true')) then (iwxxm:airTemperature/@uom = 'Cel') else true())">METAR_SPECI.MAORec6: airTemperature shall be reported in degrees Celsius (Cel).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec4">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:cloud)) else (true()))">METAR_SPECI.MAORec4: clouds should be absent when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:presentWeather) else true())">METAR_SPECI.MAORec3: presentWeather should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:rvr) else true())">METAR_SPECI.MAORec2: rvr should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:visibility) else true())">METAR_SPECI.MAORec1: visibility should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec7">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(exists(iwxxm:dewpointTemperature) and (not(exists(iwxxm:dewpointTemperature/@xsi:nil)) or iwxxm:dewpointTemperature/@xsi:nil != 'true')) then (iwxxm:dewpointTemperature/@uom = 'Cel') else true())">METAR_SPECI.MAORec7: dewpointTemperature shall be reported in degrees Celsius (Cel).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec8">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(exists(iwxxm:qnh) and (not(exists(iwxxm:qnh/@xsi:nil)) or iwxxm:qnh/@xsi:nil != 'true')) then (iwxxm:qnh/@uom = 'hPa') else true())">METAR_SPECI.MAORec8: qnh shall be reported in hectopascals (hPa).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MAORec5">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if((exists(iwxxm:visibility)) and (iwxxm:visibility//iwxxm:prevailingVisibility/number(text()) lt 1500) and (iwxxm:visibility//iwxxm:prevailingVisibility/@uom eq 'm')) then (exists(iwxxm:rvr)) else true())">METAR_SPECI.MAORec5: Table A3-2 Note 7 states: "To be included if visibility or RVR &amp;lt; 1500 m; for up to a maximum of four runways". This is interpreted to mean that if the prevailing visibility is below 1500 meters, RVR should always be included</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AOC1">
      <sch:rule context="//iwxxm:AerodromeObservedClouds">
         <sch:assert test="(if( exists(iwxxm:verticalVisibility) ) then empty(iwxxm:layer) else true())">METAR_SPECI.AOC1: Vertical visibility cannot be reported with cloud layers</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AOC2">
      <sch:rule context="//iwxxm:AerodromeObservedClouds">
         <sch:assert test="(if(exists(iwxxm:verticalVisibility) and (not(exists(iwxxm:verticalVisibility/@xsi:nil)) or iwxxm:verticalVisibility/@xsi:nil != 'true')) then ((iwxxm:verticalVisibility/@uom = 'm') or (iwxxm:verticalVisibility/@uom = '[ft_i]')) else true())">METAR_SPECI.AOC2: verticalVisibility shall be reported in metres (m) or feet ([ft_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW3">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if(exists(iwxxm:extremeClockwiseWindDirection) and (not(exists(iwxxm:extremeClockwiseWindDirection/@xsi:nil)) or iwxxm:extremeClockwiseWindDirection/@xsi:nil != 'true')) then (iwxxm:extremeClockwiseWindDirection/@uom = 'deg') else true())">METAR_SPECI.ASW3: extremeClockwiseWindDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW4">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if(exists(iwxxm:extremeCounterClockwiseWindDirection) and (not(exists(iwxxm:extremeCounterClockwiseWindDirection/@xsi:nil)) or iwxxm:extremeCounterClockwiseWindDirection/@xsi:nil != 'true')) then (iwxxm:extremeCounterClockwiseWindDirection/@uom = 'deg') else true())">METAR_SPECI.ASW4: extremeCounterClockwiseWindDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW5">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if(exists(iwxxm:meanWindDirection) and (not(exists(iwxxm:meanWindDirection/@xsi:nil)) or iwxxm:meanWindDirection/@xsi:nil != 'true')) then (iwxxm:meanWindDirection/@uom = 'deg') else true())">METAR_SPECI.ASW5: meanWindDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW6">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if(exists(iwxxm:meanWindSpeed) and (not(exists(iwxxm:meanWindSpeed/@xsi:nil)) or iwxxm:meanWindSpeed/@xsi:nil != 'true')) then ((iwxxm:meanWindSpeed/@uom = 'm/s') or (iwxxm:meanWindSpeed/@uom = '[kn_i]')) else true())">METAR_SPECI.ASW6: meanWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW2">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( @variableDirection eq 'true' ) then ( empty(iwxxm:meanWindDirection) ) else true())">METAR_SPECI.ASW2: Wind direction is not reported when variable winds are indicated</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW7">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if(exists(iwxxm:windGustSpeed) and (not(exists(iwxxm:windGustSpeed/@xsi:nil)) or iwxxm:windGustSpeed/@xsi:nil != 'true')) then ((iwxxm:windGustSpeed/@uom = 'm/s') or (iwxxm:windGustSpeed/@uom = '[kn_i]')) else true())">METAR_SPECI.ASW7: windGustSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.ASW1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( exists(iwxxm:meanWindDirection)and exists(iwxxm:extremeClockwiseWindDirection)and exists(iwxxm:extremeCounterClockwiseWindDirection) ) then ((iwxxm:meanWindDirection/@uom = iwxxm:extremeClockwiseWindDirection/@uom) and (iwxxm:meanWindDirection/@uom = iwxxm:extremeCounterClockwiseWindDirection/@uom)) else true())">METAR_SPECI.ASW1: All wind UOMs must be the same</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AHV1">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="(if(exists(iwxxm:minimumVisibility) and (not(exists(iwxxm:minimumVisibility/@xsi:nil)) or iwxxm:minimumVisibility/@xsi:nil != 'true')) then (iwxxm:minimumVisibility/@uom = 'm') else true())">METAR_SPECI.AHV1: minimumVisibility shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AHV2">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="(if(exists(iwxxm:minimumVisibilityDirection) and (not(exists(iwxxm:minimumVisibilityDirection/@xsi:nil)) or iwxxm:minimumVisibilityDirection/@xsi:nil != 'true')) then (iwxxm:minimumVisibilityDirection/@uom = 'deg') else true())">METAR_SPECI.AHV2: minimumVisibilityDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AHV3">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="(if(exists(iwxxm:prevailingVisibility) and (not(exists(iwxxm:prevailingVisibility/@xsi:nil)) or iwxxm:prevailingVisibility/@xsi:nil != 'true')) then (iwxxm:prevailingVisibility/@uom = 'm') else true())">METAR_SPECI.AHV3: prevailingVisibility shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MAFR2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:cloud) else true())">TAF.MAFR2: cloud should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MAFR1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:prevailingVisibility) else true())">TAF.MAFR1: prevailingVisibility should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MAFR3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:weather) else true())">TAF.MAFR3: weather should not be reported when cloudAndVisibilityOK is true</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MAFR4">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(exists(iwxxm:prevailingVisibility) and (not(exists(iwxxm:prevailingVisibility/@xsi:nil)) or iwxxm:prevailingVisibility/@xsi:nil != 'true')) then (iwxxm:prevailingVisibility/@uom = 'm') else true())">TAF.MAFR4: prevailingVisibility shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.AATF1">
      <sch:rule context="//iwxxm:AerodromeAirTemperatureForecast">
         <sch:assert test="(if(exists(iwxxm:maximumTemperature) and (not(exists(iwxxm:maximumTemperature/@xsi:nil)) or iwxxm:maximumTemperature/@xsi:nil != 'true')) then (iwxxm:maximumTemperature/@uom = 'Cel') else true())">TAF.AATF1: maximumTemperature shall be reported in degrees Celsius (Cel).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.AATF2">
      <sch:rule context="//iwxxm:AerodromeAirTemperatureForecast">
         <sch:assert test="(if(exists(iwxxm:minimumTemperature) and (not(exists(iwxxm:minimumTemperature/@xsi:nil)) or iwxxm:minimumTemperature/@xsi:nil != 'true')) then (iwxxm:minimumTemperature/@uom = 'Cel') else true())">TAF.AATF2: minimumTemperature shall be reported in degrees Celsius (Cel).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF19">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(not(empty(iwxxm:baseForecast//om:result/iwxxm:MeteorologicalAerodromeForecastRecord)) and (iwxxm:baseForecast//om:result/iwxxm:MeteorologicalAerodromeForecastRecord/@cloudAndVisibilityOK = 'false')) then(exists(iwxxm:baseForecast//om:result/iwxxm:MeteorologicalAerodromeForecastRecord/iwxxm:cloud)) else(true()))">TAF.TAF19: cloud is mandatory in a non-empty baseForecast when cloudAndVisibilityOK is false</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF18">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(not(empty(iwxxm:baseForecast//om:result/iwxxm:MeteorologicalAerodromeForecastRecord))) then(not(empty(iwxxm:baseForecast//om:result/iwxxm:MeteorologicalAerodromeForecastRecord/iwxxm:surfaceWind))) else(true()))">TAF.TAF18: surfaceWind is mandatory in a non-empty baseForecast</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF3">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'AMENDMENT' ) then (not(empty(iwxxm:previousReportValidPeriod))) else (true()))">TAF.TAF3: An amended report must also include the valid time of the amended report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF4">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'CANCELLATION' ) then (not(empty(iwxxm:previousReportValidPeriod))) else (true()))">TAF.TAF4: A cancelled report must also include the valid time of the cancelled report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF5">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'CORRECTION' ) then (not(empty(iwxxm:previousReportValidPeriod))) else (true()))">TAF.TAF5: A corrected report must reference</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF9">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'MISSING' ) then( (exists(iwxxm:baseForecast//om:result/@nilReason)) and ((empty(iwxxm:validTime)) and ((empty(iwxxm:previousReportValidPeriod)) and (empty(iwxxm:changeForecast))))) else( true()))">TAF.TAF9: Missing TAF reports only include aerodrome information and issue time information</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF2">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'NORMAL' ) then (empty(iwxxm:previousReportValidPeriod)) else (true()))">TAF.TAF2: previousReportValidPeriod must be null unless this cancels, corrects or amends a previous report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF11">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status ne 'MISSING') then(not(empty(iwxxm:validTime))) else(true()))">TAF.TAF11: Non-missing TAF reports must contains validTime</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF8">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(empty(iwxxm:baseForecast//iwxxm:MeteorologicalAerodromeForecastRecord/@changeIndicator) )">TAF.TAF8: Base conditions may not have a change indicator</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF14">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if(exists(.//iwxxm:baseForecast/om:OM_Observation)) then ( ( (exists(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest//sf:sampledFeature/aixm:AirportHeliport)) or (contains(string(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'aerodrome')) ) and ( if(exists(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest/@xlink:href)) then (not(exists(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest[@xlink:href != concat( '#', current()//iwxxm:baseForecast/om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id )]))) else(true()) ) ) else(true()) )">TAF.TAF14: The sampled feature of baseForecast is always an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF16">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:baseForecast)) then(not(exists(iwxxm:baseForecast//om:procedure/*[name() != 'metce:Process']))) else(true()))">TAF.TAF16: The procedure of a TAF baseForecast should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF12">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if((exists(.//iwxxm:baseForecast/om:OM_Observation)) and (empty(.//iwxxm:baseForecast/om:OM_Observation/om:result/@nilReason))) then((exists(.//iwxxm:baseForecast/om:OM_Observation/om:validTime/gml:TimePeriod))or(concat( '#', current()//iwxxm:validTime/gml:TimePeriod/@gml:id ) = .//iwxxm:baseForecast/om:OM_Observation/om:validTime/@xlink:href)) else(true()))">TAF.TAF12: The O&amp;amp;M validTime of baseForecast must be a time period for TAF forecasts</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF15">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if(exists(.//iwxxm:changeForecast/om:OM_Observation)) then ( ( (exists(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest//sf:sampledFeature/aixm:AirportHeliport)) or (contains(string(.//iwxxm:baseForecast/om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'aerodrome')) ) and ( if(exists(.//iwxxm:changeForecast/om:OM_Observation/om:featureOfInterest/@xlink:href)) then (not(exists(.//iwxxm:changeForecast/om:OM_Observation/om:featureOfInterest[@xlink:href != concat( '#', current()//iwxxm:baseForecast/om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id )]))) else(true()) ) ) else(true()) )">TAF.TAF15: The sampled feature of changeForecast is always an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF17">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:changeForecast)) then(not(exists(iwxxm:changeForecast//om:procedure/*[name() != 'metce:Process']))) else(true()))">TAF.TAF17: The procedure of a TAF changeForecast should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF13">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if((exists(.//iwxxm:changeForecast/om:OM_Observation)) and (empty(.//iwxxm:changeForecast/om:OM_Observation/om:result/@nilReason))) then((exists(.//iwxxm:changeForecast/om:OM_Observation/om:validTime/gml:TimePeriod))or(concat( '#', current()//iwxxm:validTime/gml:TimePeriod/@gml:id ) = .//iwxxm:changeForecast/om:OM_Observation/om:validTime/@xlink:href)) else(true()))">TAF.TAF13: The O&amp;amp;M validTime of changeForecast must be a time period for TAF forecasts</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF6">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(empty(distinct-values(for $change-forecast in iwxxm:changeForecast return($change-forecast/om:OM_Observation/om:resultTime//gml:timePosition/text()=iwxxm:baseForecast/om:OM_Observation/om:resultTime//gml:timePosition/text())or($change-forecast/om:OM_Observation/om:resultTime/@xlink:href=iwxxm:baseForecast/om:OM_Observation/om:resultTime/@xlink:href))[.=false()]))">TAF.TAF6: resultTime for the baseForecast and the changeForecasts must match</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET9">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(exists(iwxxm:forecastPositionAnalysis)) then(not(exists(iwxxm:analysis/om:OM_Observation/om:result/iwxxm:EvolvingMeteorologicalCondition/iwxxm:speedOfMotion)) and not(exists(iwxxm:analysis/om:OM_Observation/om:result/iwxxm:EvolvingMeteorologicalCondition/iwxxm:directionOfMotion))) else(true()))">SIGMET.SIGMET9: SIGMET can not have both a forecastPositionAnalysis and expected speed and/or direction of motion</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET1">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status = 'CANCELLATION') then exists(iwxxm:analysis//om:result/@nilReason) else(true()))">SIGMET.SIGMET1: A cancelled SIGMET should only include identifying information (time and airspace) and no other information</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET2">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status = 'NORMAL') then ((exists(iwxxm:analysis)) and (empty(iwxxm:analysis//om:result/@nilReason))) else(true()))">SIGMET.SIGMET2: There must be at least one analysis when a SIGMET does not have canceled status</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET10">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(exists(iwxxm:volcanicAshMovedToFIR)) then(@status = 'CANCELLATION') else(true()))">SIGMET.SIGMET10: SIGMET must have a cancelled status if reporting volcanicAshMovedToFIR</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET4">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if((@status ne 'CANCELLATION') and (not(@translationFailedTAC))) then((exists(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/aixm:Airspace)) or (contains(string(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'fir')) or (contains(string(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'uir')) or (contains(string(.//om:OM_Observation/om:featureOfInterest//sf:sampledFeature/@xlink:href), 'cta')) ) and ( if(exists(.//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', current()//om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = .//om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())) else(true()))">SIGMET.SIGMET4: Sampled feature in analysis and forecastPositionAnalysis must be an FIR, UIR, or CTA</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET7">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:analysis)) then(not(exists(iwxxm:analysis//om:procedure/*[name() != 'metce:Process']))) else(true()))">SIGMET.SIGMET7: The procedure of a SIGMET analysis should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET3">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if((@status ne 'CANCELLATION') and exists(//iwxxm:analysis/om:OM_Observation)) then(exists(//iwxxm:analysis/om:OM_Observation/om:result/iwxxm:SIGMETEvolvingConditionCollection)) else(true()))">SIGMET.SIGMET3: OBS and FCST analyses must have a result type of SIGMETEvolvingConditionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET8">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:forecastPositionAnalysis)) then(not(exists(iwxxm:forecastPositionAnalysis//om:procedure/*[name() != 'metce:Process']))) else(true()))">SIGMET.SIGMET8: The procedure of a SIGMET forecastPositionAnalysis should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET5">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if((@status ne 'CANCELLATION') and exists(iwxxm:forecastPositionAnalysis)) then(not(exists(iwxxm:forecastPositionAnalysis//om:result/*[name() != 'iwxxm:SIGMETPositionCollection']))) else(true()))">SIGMET.SIGMET5: The result of a forecastPositionAnalysis should be a SIGMETPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SEC1">
      <sch:rule context="//iwxxm:SIGMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:directionOfMotion) and (not(exists(iwxxm:directionOfMotion/@xsi:nil)) or iwxxm:directionOfMotion/@xsi:nil != 'true')) then (iwxxm:directionOfMotion/@uom = 'deg') else true())">SIGMET.SEC1: directionOfMotion shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SEC2">
      <sch:rule context="//iwxxm:SIGMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:speedOfMotion) and (not(exists(iwxxm:speedOfMotion/@xsi:nil)) or iwxxm:speedOfMotion/@xsi:nil != 'true')) then ((iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]')) else true())">SIGMET.SEC2: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SECC3">
      <sch:rule context="//iwxxm:SIGMETEvolvingConditionCollection">
         <sch:assert test="(if(exists(/iwxxm:SIGMET)) then(count(iwxxm:member) eq 1) else(true()))">SIGMET.SECC3: The number of SIGMETEvolvingConditionCollection member should be 1 for non-Tropical Cyclone/Volcanic Ash SIGMETs</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SECC2">
      <sch:rule context="//iwxxm:SIGMETEvolvingConditionCollection">
         <sch:assert test="(if(@timeIndicator='FORECAST' and ../../om:phenomenonTime/gml:TimeInstant/gml:timePosition) then (translate(../../om:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','') ge translate(../../../../iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')) else(true()))">SIGMET.SECC2: When SIGMETEvolvingConditionCollection timeIndicator is a forecast, the phenomenonTime must be later than or equal to the beginning of the validPeriod of the report.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SECC1">
      <sch:rule context="//iwxxm:SIGMETEvolvingConditionCollection">
         <sch:assert test="(if(@timeIndicator='OBSERVATION' and ../../om:phenomenonTime/gml:TimeInstant/gml:timePosition) then (translate(../../om:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','') le translate(../../../../iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')) else(true()))">SIGMET.SECC1: When SIGMETEvolvingConditionCollection timeIndicator is an observation, the phenomenonTime must be earlier than or equal to the beginning of the validPeriod of the report.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SPC1">
      <sch:rule context="//iwxxm:SIGMETPositionCollection">
         <sch:assert test="(if(exists(/iwxxm:SIGMET)) then(count(iwxxm:member) eq 1) else(true()))">SIGMET.SPC1: The number of SIGMETPositionCollection member should be 1 for non-Tropical Cyclone/Volcanic Ash SIGMETs</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AECC2">
      <sch:rule context="//iwxxm:AIRMETEvolvingConditionCollection">
         <sch:assert test="(if(@timeIndicator='FORECAST' and ../../om:phenomenonTime/gml:TimeInstant/gml:timePosition) then (translate(../../om:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','') ge translate(../../../../iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')) else true())">AIRMET.AECC2: When AIRMETEvolvingConditionCollection timeIndicator is a forecast, the phenomenonTime must be later than or equal to the beginning of the validPeriod of the report.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AECC1">
      <sch:rule context="//iwxxm:AIRMETEvolvingConditionCollection">
         <sch:assert test="(if(@timeIndicator='OBSERVATION' and ../../om:phenomenonTime/gml:TimeInstant/gml:timePosition) then (translate(../../om:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','') le translate(../../../../iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')) else true())">AIRMET.AECC1: When AIRMETEvolvingConditionCollection timeIndicator is an observation, the phenomenonTime must be earlier than or equal to the beginning of the validPeriod of the report.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC1">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:cloudBase) and (not(exists(iwxxm:cloudBase/@xsi:nil)) or iwxxm:cloudBase/@xsi:nil != 'true')) then ((iwxxm:cloudBase/@uom = 'm') or (iwxxm:cloudBase/@uom = '[ft_i]')) else true())">AIRMET.AEC1: cloudBase shall be reported in metres (m) or feet ([ft_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC2">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:cloudTop) and (not(exists(iwxxm:cloudTop/@xsi:nil)) or iwxxm:cloudTop/@xsi:nil != 'true')) then ((iwxxm:cloudTop/@uom = 'm') or (iwxxm:cloudTop/@uom = '[ft_i]')) else true())">AIRMET.AEC2: cloudTop shall be reported in metres (m) or feet ([ft_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC3">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:directionOfMotion) and (not(exists(iwxxm:directionOfMotion/@xsi:nil)) or iwxxm:directionOfMotion/@xsi:nil != 'true')) then (iwxxm:directionOfMotion/@uom = 'deg') else true())">AIRMET.AEC3: directionOfMotion shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC4">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:speedOfMotion) and (not(exists(iwxxm:speedOfMotion/@xsi:nil)) or iwxxm:speedOfMotion/@xsi:nil != 'true')) then ((iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]')) else true())">AIRMET.AEC4: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC5">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:surfaceVisibility) and (not(exists(iwxxm:surfaceVisibility/@xsi:nil)) or iwxxm:surfaceVisibility/@xsi:nil != 'true')) then (iwxxm:surfaceVisibility/@uom = 'm') else true())">AIRMET.AEC5: surfaceVisibility shall be reported in metres (m).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC7">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:surfaceWindDirection) and (not(exists(iwxxm:surfaceWindDirection/@xsi:nil)) or iwxxm:surfaceWindDirection/@xsi:nil != 'true')) then ((iwxxm:surfaceWindDirection/@uom = 'deg')) else true())">AIRMET.AEC7: surfaceWindDirection shall be reported in the degrees unit of measure ('deg').</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC6">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:surfaceWindSpeed) and (not(exists(iwxxm:surfaceWindSpeed/@xsi:nil)) or iwxxm:surfaceWindSpeed/@xsi:nil != 'true')) then ((iwxxm:surfaceWindSpeed/@uom = 'm/s') or (iwxxm:surfaceWindSpeed/@uom = '[kn_i]')) else true())">AIRMET.AEC6: surfaceWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AEC8">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="(if(exists(iwxxm:surfaceWindDirection) or exists(iwxxm:surfaceWindSpeed)) then (exists(iwxxm:surfaceWindDirection) and exists(iwxxm:surfaceWindSpeed)) else true())">AIRMET.AEC8: surfaceWindDirection and surfaceWindSpeed must be reported together</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET5">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="(if(exists(iwxxm:forecastPositionAnalysis)) then(not(exists(iwxxm:analysis/om:OM_Observation/om:result/iwxxm:AIRMETEvolvingMeteorologicalCondition/iwxxm:speedOfMotion)) and not(exists(iwxxm:analysis/om:OM_Observation/om:result/iwxxm:AIRMETEvolvingMeteorologicalCondition/iwxxm:directionOfMotion))) else(true()))">AIRMET.AIRMET5: AIRMET can not have both a forecastPositionAnalysis and expected speed and/or direction of motion</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET2">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="(if(@status = 'CANCELLATION') then exists(iwxxm:analysis//om:result/@nilReason) else(true()))">AIRMET.AIRMET2: A canceled AIRMET only include identifying information (time and airspace) and no other information</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET3">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="(if(@status = 'NORMAL') then ((exists(iwxxm:analysis)) and (empty(iwxxm:analysis//om:result/@nilReason))) else(true()))">AIRMET.AIRMET3: There must be at least one analysis when a AIRMET does not have canceled status</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET4">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:analysis)) then(not(exists(iwxxm:analysis//om:procedure/*[name() != 'metce:Process']))) else(true()))">AIRMET.AIRMET4: The procedure of an AIRMET analysis should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET1">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="(if((@status ne 'CANCELLATION') and exists(//iwxxm:analysis/om:OM_Observation)) then(exists(//iwxxm:analysis/om:OM_Observation/om:result/iwxxm:AIRMETEvolvingConditionCollection)) else(true()))">AIRMET.AIRMET1: OBS and FCST classifications must have a result type of AIRMETEvolvingConditionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCFC1">
      <sch:rule context="//iwxxm:TropicalCycloneForecastConditions">
         <sch:assert test="(if(exists(iwxxm:maximumSurfaceWindSpeed) and (not(exists(iwxxm:maximumSurfaceWindSpeed/@xsi:nil)) or iwxxm:maximumSurfaceWindSpeed/@xsi:nil != 'true')) then ((iwxxm:maximumSurfaceWindSpeed/@uom = 'm/s') or (iwxxm:maximumSurfaceWindSpeed/@uom = '[kn_i]')) else true())">TCA.TCFC1: maximumSurfaceWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCA4">
      <sch:rule context="//iwxxm:TropicalCycloneAdvisory">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:forecast)) then(not(exists(iwxxm:forecast//om:procedure/*[name() != 'metce:Process']))) else(true()))">TCA.TCA4: The procedure of a TCA forecast should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCA2">
      <sch:rule context="//iwxxm:TropicalCycloneAdvisory">
         <sch:assert test="(if(exists(iwxxm:forecast)) then(not(exists(iwxxm:forecast//om:result/*[name() != 'iwxxm:TropicalCycloneForecastConditions']))) else(true()))">TCA.TCA2: The result of a TCA forecast should be a TropicalCycloneForecastConditions</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCA3">
      <sch:rule context="//iwxxm:TropicalCycloneAdvisory">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:observation)) then(not(exists(iwxxm:observation//om:procedure/*[name() != 'metce:Process']))) else(true()))">TCA.TCA3: The procedure of a TCA observation should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCA1">
      <sch:rule context="//iwxxm:TropicalCycloneAdvisory">
         <sch:assert test="(if(exists(iwxxm:observation)) then(not(exists(iwxxm:observation//om:result/*[name() != 'iwxxm:TropicalCycloneObservedConditions']))) else(true()))">TCA.TCA1: The result of a TCA observation should be a TropicalCycloneObservedConditions</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCOC1">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="(if(exists(iwxxm:centralPressure) and (not(exists(iwxxm:centralPressure/@xsi:nil)) or iwxxm:centralPressure/@xsi:nil != 'true')) then (iwxxm:centralPressure/@uom = 'hPa') else true())">TCA.TCOC1: centralPressure shall be reported in hectopascals (hPa).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCOC2">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="(if(exists(iwxxm:meanMaxSurfaceWind) and (not(exists(iwxxm:meanMaxSurfaceWind/@xsi:nil)) or iwxxm:meanMaxSurfaceWind/@xsi:nil != 'true')) then ((iwxxm:meanMaxSurfaceWind/@uom = 'm/s') or (iwxxm:meanMaxSurfaceWind/@uom = '[kn_i]')) else true())">TCA.TCOC2: meanMaxSurfaceWind shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCOC3">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="(if(exists(iwxxm:movementDirection) and (not(exists(iwxxm:movementDirection/@xsi:nil)) or iwxxm:movementDirection/@xsi:nil != 'true')) then (iwxxm:movementDirection/@uom = 'deg') else true())">TCA.TCOC3: movementDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TCA.TCOC4">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="(if(exists(iwxxm:movementSpeed) and (not(exists(iwxxm:movementSpeed/@xsi:nil)) or iwxxm:movementSpeed/@xsi:nil != 'true')) then ((iwxxm:movementSpeed/@uom = 'km/h') or (iwxxm:movementSpeed/@uom = '[kn_i]')) else true())">TCA.TCOC4: movementSpeed shall be reported in kilometres per hour (km/h) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAC1">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="(if(exists(iwxxm:directionOfMotion) and (not(exists(iwxxm:directionOfMotion/@xsi:nil)) or iwxxm:directionOfMotion/@xsi:nil != 'true')) then (iwxxm:directionOfMotion/@uom = 'deg') else true())">VAA.VAC1: directionOfMotion shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAC2">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="(if(exists(iwxxm:speedOfMotion) and (not(exists(iwxxm:speedOfMotion/@xsi:nil)) or iwxxm:speedOfMotion/@xsi:nil != 'true')) then ((iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]')) else true())">VAA.VAC2: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAC3">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="(if(exists(iwxxm:windDirection) and (not(exists(iwxxm:windDirection/@xsi:nil)) or iwxxm:windDirection/@xsi:nil != 'true')) then (iwxxm:windDirection/@uom = 'deg') else true())">VAA.VAC3: windDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAC4">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="(if(exists(iwxxm:windSpeed) and (not(exists(iwxxm:windSpeed/@xsi:nil)) or iwxxm:windSpeed/@xsi:nil != 'true')) then ((iwxxm:windSpeed/@uom = 'm/s') or (iwxxm:windSpeed/@uom = '[kn_i]')) else true())">VAA.VAC4: windSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAA2">
      <sch:rule context="//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="(if(empty(om:result/@nilReason) and exists(iwxxm:analysis)) then(not(exists(iwxxm:analysis//om:procedure/*[name() != 'metce:Process']))) else(true()))">VAA.VAA2: The procedure of a VAA analysis should be a metce:Process</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VAA.VAA1">
      <sch:rule context="//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="(if(exists(iwxxm:analysis)) then(not(exists(iwxxm:analysis//om:result/*[name() != 'iwxxm:VolcanicAshConditions']))) else(true()))">VAA.VAA1: The result of a VAA analysis should be a VolcanicAshConditions</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.CL1">
      <sch:rule context="//iwxxm:CloudLayer">
         <sch:assert test="(if(exists(iwxxm:base) and (not(exists(iwxxm:base/@xsi:nil)) or iwxxm:base/@xsi:nil != 'true')) then ((iwxxm:base/@uom = 'm') or (iwxxm:base/@uom = '[ft_i]')) else true())">COMMON.CL1: base shall be reported in metres (m) or feet ([ft_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report4">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="sum( //iwxxm:extension/.//text()/string-length(.) ) +sum( //iwxxm:extension/.//element()/( (string-length( name() ) * 2 ) + 5 ) ) +sum( //iwxxm:extension/.//@*/( 1 + string-length(name()) + 3 + string-length(.) ) ) +sum( //iwxxm:extension/.//comment()/( string-length( . ) + 7 ) ) lt 5000">COMMON.Report4: Total size of extension content must not exceed 5000 characters per report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report2">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="(if(@permissibleUsage eq 'OPERATIONAL') then( not( exists(@permissibleUsageReason))) else(true()))">COMMON.Report2: Operational reports should not include a permissibleUsageReason</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report1">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="(if(@permissibleUsage eq 'NON-OPERATIONAL') then( exists(@permissibleUsageReason) ) else(true()))">COMMON.Report1: Non-operational reports must include a permissibleUsageReason</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report3">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="(if( exists(@translatedBulletinID) or exists(@translatedBulletinReceptionTime) or exists(@translationCentreDesignator) or exists(@translationCentreName) or exists(@translationTime) or exists(@translationFailedTAC)) then( exists(@translatedBulletinID) and exists(@translatedBulletinReceptionTime) and exists(@translationCentreDesignator) and exists(@translationCentreName) and exists(@translationTime)) else(true()))">COMMON.Report3: Translated reports must include translatedBulletinID, translatedBulletinReceptionTime, translationCentreDesignator, translationCentreName, translationTime and optionally translationFailedTAC if translation failed</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ACF1">
      <sch:rule context="//iwxxm:AerodromeCloudForecast">
         <sch:assert test="(if( exists(iwxxm:verticalVisibility) ) then empty(iwxxm:layer) else true())">COMMON.ACF1: Vertical visibility cannot be reported together with cloud layers</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ACF2">
      <sch:rule context="//iwxxm:AerodromeCloudForecast">
         <sch:assert test="(if(exists(iwxxm:verticalVisibility) and (not(exists(iwxxm:verticalVisibility/@xsi:nil)) or iwxxm:verticalVisibility/xsi:nil != 'true')) then ((iwxxm:verticalVisibility/@uom = 'm') or (iwxxm:verticalVisibility/@uom = '[ft_i]')) else true())">COMMON.ACF2: verticalVisibility shall be reported in metres (m) or feet ([ft_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ASWF1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="(if( @variableDirection eq 'true' ) then ( empty(iwxxm:meanWindDirection) ) else true())">COMMON.ASWF1: Wind direction is not reported when variable winds are indicated</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ASWTF1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="(if(exists(iwxxm:meanWindDirection) and (not(exists(iwxxm:meanWindDirection/@xsi:nil)) or iwxxm:meanWindDirection/@xsi:nil != 'true')) then (iwxxm:meanWindDirection/@uom = 'deg') else true())">COMMON.ASWTF1: meanWindDirection shall be reported in degrees (deg).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ASWTF2">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="(if(exists(iwxxm:meanWindSpeed) and (not(exists(iwxxm:meanWindSpeed/@xsi:nil)) or iwxxm:meanWindSpeed/@xsi:nil != 'true')) then ((iwxxm:meanWindSpeed/@uom = 'm/s') or (iwxxm:meanWindSpeed/@uom = '[kn_i]')) else true())">COMMON.ASWTF2: meanWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.ASWTF3">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="(if(exists(iwxxm:windGustSpeed) and (not(exists(iwxxm:windGustSpeed/@xsi:nil)) or iwxxm:windGustSpeed/@xsi:nil != 'true')) then ((iwxxm:windGustSpeed/@uom = 'm/s') or (iwxxm:windGustSpeed/@uom = '[kn_i]')) else true())">COMMON.ASWTF3: windGustSpeed shall be reported in metres per second (m/s) or knots ([kn_i]).</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="IWXXM.ExtensionAlwaysLast">
      <sch:rule context="//iwxxm:extension">
         <sch:assert test="following-sibling::*[1][self::iwxxm:extension] or not(following-sibling::*)">IWXXM.ExtensionAlwaysLast: Extension elements should be the last elements in their parents</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
