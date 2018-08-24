<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="iwxxm" uri="http://icao.int/iwxxm/3.0"/>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
   <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
   <sch:ns prefix="aixm" uri="http://www.aixm.aero/schema/5.1.1"/>
   <sch:ns prefix="collect" uri="http://def.wmo.int/collect/2014"/>
   <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
   <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
   <sch:ns prefix="reg" uri="http://purl.org/linked-data/registry#"/>
   <sch:pattern id="COLLECT.MB1">
      <sch:rule context="//collect:MeteorologicalBulletin">
         <sch:assert test="count(distinct-values(for $item in //collect:meteorologicalInformation/child::node() return(node-name($item))))eq 1">COLLECT.MB1: All meteorologicalInformation instances in MeteorologicalBulletin must be of the same type</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayState-1">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="( if( @allRunways = 'true' ) then( empty(iwxxm:runway) ) else( true() ) )">METAR_SPECI.AerodromeRunwayState-1: When all runways are being reported upon, no specific runway should be reported</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayState-2">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if( exists(iwxxm:runway) ) then( empty(@allRunways) or (@allRunways = 'false') ) else( true() ) )">METAR_SPECI.AerodromeRunwayState-2: When a single Runway is reported upon, the allRunways flag should be missing or false</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayVisualRange-1">
      <sch:rule context="//iwxxm:AerodromeRunwayVisualRange">
         <sch:assert test="( if( exists(iwxxm:meanRVR) and not(iwxxm:meanRVR/@xsi:nil = 'true') ) then( iwxxm:meanRVR/@uom = 'm' ) else( true() ) )">METAR_SPECI.AerodromeRunwayVisualRange-1: meanRVR shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation.recentWeather">
      <sch:rule context="//*[contains(name(),'MeteorologicalAerodromeObservation')]/iwxxm:recentWeather">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AerodromeRecentWeather.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">MeteorologicalAerodromeObservation iwxxm:recentWeather elements should be a member of http://codes.wmo.int/49-2/AerodromeRecentWeather</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-6">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( empty(iwxxm:observation//iwxxm:cloud//iwxxm:layer//iwxxm:amount/*) and ends-with(iwxxm:observation//iwxxm:cloud//iwxxm:layer//iwxxm:amount/@nilReason, 'notDetectedByAutoSystem') ) then( @automatedStation = 'true' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-6: When cloud amount is not detected by an automated station, this report must be an automated station report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-7">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( empty(iwxxm:observation//iwxxm:cloud//iwxxm:layer//iwxxm:base/*) and ends-with(iwxxm:observation//iwxxm:cloud//iwxxm:layer//iwxxm:base/@nilReason, 'notDetectedByAutoSystem') ) then( @automatedStation = 'true' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-7: When cloud base is not detected by an automated station, this report must be an automated station report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-4">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( empty(iwxxm:observation//iwxxm:cloud/*) and ends-with(iwxxm:observation//iwxxm:cloud/@nilReason, 'notDetectedByAutoSystem') ) then( @automatedStation = 'true' ) else( true() ))">METAR_SPECI.MeteorologicalAerodromeObservationReport-4: When no clouds are detected by an automated station, this report must be an automated station report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-5">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( empty(iwxxm:observation//iwxxm:cloud//iwxxm:layer/*) and ends-with(iwxxm:observation//iwxxm:cloud//iwxxm:layer/@nilReason, 'notDetectedByAutoSystem') ) then( @automatedStation = 'true' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-5: When both cloud amount and base are not detected by an automated station, this report must be an automated station report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-2">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( @status = 'MISSING' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:observationTime) and empty(iwxxm:observation/*) and (iwxxm:observation/@nilReason = 'http://codes.wmo.int/common/nil/missing') and empty(iwxxm:trendForecast) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-2: A 'Nil' report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:aerodrome, iwxxm:observationTime, iwxxm:observation (empty with nilReason) and iwxxm:trendForecast (missing)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-3">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( (@status = 'NORMAL' or @status = 'CORRECTION') and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:observationTime) and exists(iwxxm:observation) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-3: A NORMAL or CORRECTION report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:aerodrome, iwxxm:observationTime and iwxxm:observation</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservationReport-1">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:observationTime) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservationReport-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime, iwxxm:aerodrome and iwxxm:observationTime</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSeaState.seaState">
      <sch:rule context="//*[contains(name(),'AerodromeSeaState')]/iwxxm:seaState">
         <sch:assert test="@xlink:href = document('codes.wmo.int-bufr4-codeflag-0-22-061.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AerodromeSeaState iwxxm:seaState elements should be a member of http://codes.wmo.int/bufr4/codeflag/0-22-061</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayState.depositType">
      <sch:rule context="//*[contains(name(),'AerodromeRunwayState')]/iwxxm:depositType">
         <sch:assert test="@xlink:href = document('codes.wmo.int-bufr4-codeflag-0-20-086.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AerodromeRunwayState iwxxm:depositType elements should be a member of http://codes.wmo.int/bufr4/codeflag/0-20-086</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSeaState-1">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="( if( exists(iwxxm:seaState) ) then( empty(iwxxm:significantWaveHeight) ) else( true() ) )">METAR_SPECI.AerodromeSeaState-1: If the sea state is set, significantWaveHeight is not reported</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSeaState-2">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="( if( exists(iwxxm:significantWaveHeight) ) then( empty(iwxxm:seaState) ) else( true() ) )">METAR_SPECI.AerodromeSeaState-2: If significantWaveHeight is reported, seaState should not be set</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSeaState-3">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="( if( exists(iwxxm:seaSurfaceTemperature) and not(iwxxm:seaSurfaceTemperature/@xsi:nil = 'true') ) then( iwxxm:seaSurfaceTemperature/@uom = 'Cel' ) else( true() ) )">METAR_SPECI.AerodromeSeaState-3: seaSurfaceTemperature shall be reported in degrees Celsius (Cel)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSeaState-4">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="( if( exists(iwxxm:significantWaveHeight) and not(iwxxm:significantWaveHeight/@xsi:nil = 'true') ) then( iwxxm:significantWaveHeight/@uom = 'm' ) else( true() ) )">METAR_SPECI.AerodromeSeaState-4: significantWaveHeight shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeWindShear-1">
      <sch:rule context="//iwxxm:AerodromeWindShear">
         <sch:assert test="(if( @allRunways = 'true' ) then( empty(iwxxm:runway) ) else( true() ) )">METAR_SPECI.AerodromeWindShear-1: When all runways are affected by wind shear, no specific runways should be reported</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeWindShear-2">
      <sch:rule context="//iwxxm:AerodromeWindShear">
         <sch:assert test="( if( exists(iwxxm:runway) ) then( empty(@allRunways) or (@allRunways = 'false') ) else( true() ) )">METAR_SPECI.AerodromeWindShear-2: When a single Runway is reported upon, the allRunways flag should be missing or false</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayState.contamination">
      <sch:rule context="//*[contains(name(),'AerodromeRunwayState')]/iwxxm:contamination">
         <sch:assert test="@xlink:href = document('codes.wmo.int-bufr4-codeflag-0-20-087.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AerodromeRunwayState iwxxm:contamination elements should be a member of http://codes.wmo.int/bufr4/codeflag/0-20-087</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeTrendForecast-1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecast">
         <sch:assert test="( if( @cloudAndVisibilityOK = 'true' ) then( empty(iwxxm:cloud) and empty(iwxxm:weather) and empty(iwxxm:prevailingVisibility) and empty(iwxxm:prevailingVisibilityOperator) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeTrendForecast-1: When cloudAndVisibilityOK is true cloud, weather, prevailingVisibility and prevailingVisibilityOperator should be missing</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeTrendForecast-2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecast">
         <sch:assert test="( if( exists(iwxxm:prevailingVisibility) and not(iwxxm:prevailingVisibility/@xsi:nil = 'true') ) then( iwxxm:prevailingVisibility/@uom = 'm' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeTrendForecast-2: prevailingVisibility shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation-3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservation">
         <sch:assert test="( if( exists(iwxxm:airTemperature) and not(iwxxm:airTemperature/@xsi:nil = 'true') ) then( iwxxm:airTemperature/@uom = 'Cel' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservation-3: airTemperature shall be reported in degrees Celsius (Cel)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation-4">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservation">
         <sch:assert test="( if( exists(iwxxm:dewpointTemperature) and not(iwxxm:dewpointTemperature/@xsi:nil = 'true') ) then( iwxxm:dewpointTemperature/@uom = 'Cel' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservation-4: dewpointTemperature shall be reported in degrees Celsius (Cel)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation-1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservation">
         <sch:assert test="( if( @cloudAndVisibilityOK = 'true' ) then( empty(iwxxm:visibility) and empty(iwxxm:rvr) and empty(iwxxm:presentWeather) and empty(iwxxm:cloud) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservation-1: When cloudAndVisibilityOK is true, visibility, rvr, presentWeather and cloud should be missing</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation-2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservation">
         <sch:assert test="( if( exists(iwxxm:visibility) and (iwxxm:visibility//iwxxm:prevailingVisibility/number(text()) lt 1500) and (iwxxm:visibility//iwxxm:prevailingVisibility/@uom = 'm') ) then( exists(iwxxm:rvr) ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservation-2: RVR should always be included if prevailing visibility is below 1500 meters,</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation-5">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservation">
         <sch:assert test="( if( exists(iwxxm:qnh) and not(iwxxm:qnh/@xsi:nil = 'true') ) then( iwxxm:qnh/@uom = 'hPa' ) else( true() ) )">METAR_SPECI.MeteorologicalAerodromeObservation-5: qnh shall be reported in hectopascals (hPa)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeCloud-2">
      <sch:rule context="//iwxxm:AerodromeCloud">
         <sch:assert test="( if( exists(iwxxm:layer) ) then( empty(iwxxm:verticalVisibility) ) else( true() ) )">METAR_SPECI.AerodromeCloud-2: When cloud layers are reported vertical visibility should be empty</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeCloud-1">
      <sch:rule context="//iwxxm:AerodromeCloud">
         <sch:assert test="( if( exists(iwxxm:verticalVisibility) ) then( empty(iwxxm:layer) ) else( true() ) )">METAR_SPECI.AerodromeCloud-1: When vertical visibility is reported cloud layers should be empty</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeCloud-3">
      <sch:rule context="//iwxxm:AerodromeCloud">
         <sch:assert test="( if( exists(iwxxm:verticalVisibility) and not(iwxxm:verticalVisibility/@xsi:nil = 'true') ) then( (iwxxm:verticalVisibility/@uom = 'm') or (iwxxm:verticalVisibility/@uom = '[ft_i]') ) else( true() ) )">METAR_SPECI.AerodromeCloud-3: verticalVisibility shall be reported in metres (m) or feet ([ft_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-3">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="( if( exists(iwxxm:extremeClockwiseWindDirection) and not(iwxxm:extremeClockwiseWindDirection/@xsi:nil = 'true') ) then( iwxxm:extremeClockwiseWindDirection/@uom = 'deg') else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-3: extremeClockwiseWindDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-4">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="( if( exists(iwxxm:extremeCounterClockwiseWindDirection) and not(iwxxm:extremeCounterClockwiseWindDirection/@xsi:nil = 'true') ) then( iwxxm:extremeCounterClockwiseWindDirection/@uom = 'deg' ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-4: extremeCounterClockwiseWindDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-2">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( @variableDirection = 'true' ) then( empty(iwxxm:meanWindDirection) ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-2: Wind direction is not reported when variable winds are indicated</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-5">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="( if( exists(iwxxm:meanWindDirection) and not(iwxxm:meanWindDirection/@xsi:nil = 'true') ) then( iwxxm:meanWindDirection/@uom = 'deg' ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-5: meanWindDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( exists(iwxxm:meanWindDirection/@uom) and exists(iwxxm:extremeClockwiseWindDirection/@uom) and exists(iwxxm:extremeCounterClockwiseWindDirection/@uom) ) then( (iwxxm:meanWindDirection/@uom = iwxxm:extremeClockwiseWindDirection/@uom) and (iwxxm:meanWindDirection/@uom = iwxxm:extremeCounterClockwiseWindDirection/@uom) ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-1: All wind UOMs must be the same</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-6">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="( if( exists(iwxxm:meanWindSpeed) and not(iwxxm:meanWindSpeed/@xsi:nil = 'true') ) then( (iwxxm:meanWindSpeed/@uom = 'm/s') or (iwxxm:meanWindSpeed/@uom = '[kn_i]') ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-6: meanWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeSurfaceWind-7">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="( if( exists(iwxxm:windGustSpeed) and not(iwxxm:windGustSpeed/@xsi:nil = 'true') ) then( (iwxxm:windGustSpeed/@uom = 'm/s') or (iwxxm:windGustSpeed/@uom = '[kn_i]') ) else( true() ) )">METAR_SPECI.AerodromeSurfaceWind-7: windGustSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeObservation.presentWeather">
      <sch:rule context="//*[contains(name(),'MeteorologicalAerodromeObservation')]/iwxxm:presentWeather">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AerodromePresentOrForecastWeather.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">MeteorologicalAerodromeObservation iwxxm:presentWeather elements should be a member of http://codes.wmo.int/49-2/AerodromePresentOrForecastWeather</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeRunwayState.estimatedSurfaceFrictionOrBrakingAction">
      <sch:rule context="//*[contains(name(),'AerodromeRunwayState')]/iwxxm:estimatedSurfaceFrictionOrBrakingAction">
         <sch:assert test="@xlink:href = document('codes.wmo.int-bufr4-codeflag-0-20-089.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AerodromeRunwayState iwxxm:estimatedSurfaceFrictionOrBrakingAction elements should be a member of http://codes.wmo.int/bufr4/codeflag/0-20-089</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeHorizontalVisibility-1">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="( if( exists(iwxxm:minimumVisibility) and not(iwxxm:minimumVisibility/@xsi:nil = 'true') ) then( iwxxm:minimumVisibility/@uom = 'm' ) else( true() ) )">METAR_SPECI.AerodromeHorizontalVisibility-1: minimumVisibility shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeHorizontalVisibility-2">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="( if( exists(iwxxm:minimumVisibilityDirection) and not(iwxxm:minimumVisibilityDirection/@xsi:nil = 'true') ) then( iwxxm:minimumVisibilityDirection/@uom = 'deg') else( true() ) )">METAR_SPECI.AerodromeHorizontalVisibility-2: minimumVisibilityDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.AerodromeHorizontalVisibility-3">
      <sch:rule context="//iwxxm:AerodromeHorizontalVisibility">
         <sch:assert test="( if( exists(iwxxm:prevailingVisibility) and not(iwxxm:prevailingVisibility/@xsi:nil = 'true') ) then( iwxxm:prevailingVisibility/@uom = 'm') else( true() ) )">METAR_SPECI.AerodromeHorizontalVisibility-3: prevailingVisibility shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MeteorologicalAerodromeForecast-1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecast">
         <sch:assert test="( if( @cloudAndVisibilityOK = 'true' ) then( empty(iwxxm:prevailingVisibility) and empty(iwxxm:rvr) and empty(iwxxm:weather) and empty(iwxxm:cloud) ) else( true() ) )">TAF.MeteorologicalAerodromeForecast-1: When cloudAndVisibilityOK is true, prevailingVisibility, rvr, weather and cloud should be missing</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MeteorologicalAerodromeForecast-2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecast">
         <sch:assert test="( if( exists(iwxxm:prevailingVisibility) and not(iwxxm:prevailingVisibility/@xsi:nil = 'true') ) then( iwxxm:prevailingVisibility/@uom = 'm' ) else true())">TAF.MeteorologicalAerodromeForecast-2: prevailingVisibility shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.AerodromeAirTemperatureForecast-1">
      <sch:rule context="//iwxxm:AerodromeAirTemperatureForecast">
         <sch:assert test="( if( exists(iwxxm:maximumTemperature) and not(iwxxm:maximumTemperature/@xsi:nil = 'true') ) then( iwxxm:maximumTemperature/@uom = 'Cel' ) else( true() ) )">TAF.AerodromeAirTemperatureForecast-1: maximumTemperature shall be reported in degrees Celsius (Cel)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.AerodromeAirTemperatureForecast-2">
      <sch:rule context="//iwxxm:AerodromeAirTemperatureForecast">
         <sch:assert test="( if( exists(iwxxm:minimumTemperature) and not(iwxxm:minimumTemperature/@xsi:nil = 'true') ) then( iwxxm:minimumTemperature/@uom = 'Cel' ) else( true() ) )">TAF.AerodromeAirTemperatureForecast-2: minimumTemperature shall be reported in degrees Celsius (Cel)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-5">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if( exists(iwxxm:baseForecast/*) ) then( empty(iwxxm:baseForecast/iwxxm:MeteorologicalAerodromeForecast/@changeIndicator) ) else( true() ) )">TAF.TAF-5: A non-empty iwxxm:baseForecast should not have @changeIndicator</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-6">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if( exists(iwxxm:baseForecast/*) ) then( exists(iwxxm:baseForecast/iwxxm:MeteorologicalAerodromeForecast/iwxxm:surfaceWind) ) else( true() ) )">TAF.TAF-6: in a non-empty iwxxm:baseForecast wxxm:surfaceWind is mandatory</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-7">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if( exists(iwxxm:baseForecast/*) and not(iwxxm:baseForecast/iwxxm:MeteorologicalAerodromeForecast/@cloudAndVisibilityOK = 'true') ) then( exists(iwxxm:baseForecast/iwxxm:MeteorologicalAerodromeForecast/iwxxm:prevailingVisibility) and exists(iwxxm:baseForecast/iwxxm:MeteorologicalAerodromeForecast/iwxxm:cloud) ) else( true() ) )">TAF.TAF-7: In a non-empty iwxxm:baseForecast when @cloudAndVisibilityOK is false iwxxm:prevailingVisibility and iwxxm:cloud are mandatory</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-2">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if( @status = 'MISSING' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and empty(iwxxm:validTime) and (empty(iwxxm:baseForecast/*) and iwxxm:baseForecast/@nilReason = 'http://codes.wmo.int/common/nil/missing') and empty(iwxxm:changeForecast) and empty(iwxxm:previousReportAerodrome) and empty(iwxxm:previousReportValidPeriod) ) else( true() ) )">TAF.TAF-2: A 'Nil' report should have appropriately filled elements including iwxxm:issueTime, iwxxm:aerodrome, iwxxm:validTime (missing), iwxxm:baseForecast (empty with nilReason), iwxxm:changeForecast (missing), iwxxm:previousReportAerodrome (missing) and iwxxm:previousReportValidPeriod (missing)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-3">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'NORMAL' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:validTime) and exists(iwxxm:baseForecast) and empty(iwxxm:previousReportAerodrome) and empty(iwxxm:previousReportValidPeriod) ) else( true() ) )">TAF.TAF-3: A NORMAL report should have appropriately filled elements including iwxxm:issueTime, iwxxm:aerodrome, iwxxm:validTime, iwxxm:baseForecast, iwxxm:previousReportAerodrome (missing) and iwxxm:previousReportValidPeriod (missing)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-1">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:validTime) ) else( true() ) )">TAF.TAF-1: A report that failed translation should have as a minimum appropriately filled elements including iwxxm:issueTime, iwxxm:aerodrome and iwxxm:validTime</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.TAF-4">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( (@status = 'AMENDMENT' or @status = 'CANCELLATION' or @status = 'CORRECTION') and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:aerodrome) and exists(iwxxm:validTime) and exists(iwxxm:previousReportAerodrome) and exists(iwxxm:previousReportValidPeriod) ) else( true() ) )">TAF.TAF-4: An AMENDMENT, CANCELLATION or CORRECTION report should have the appropriate elements filled including iwxxm:issueTime, iwxxm:aerodrome, iwxxm:validTime, iwxxm:previousReportAerodrome and iwxxm:previousReportValidPeriod should be non-empty</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-4">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) eq 0 and exists(iwxxm:analysis//iwxxm:phenomenonTime/*) and exists(iwxxm:validPeriod/*) ) then( empty(index-of(for $i in iwxxm:analysis return number(translate($i//iwxxm:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','')) eq number(translate(iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')),false())) ) else( true() ) )">SIGMET.SIGMET-4: iwxxm:analysis//iwxxm:phenomenonTime must be equal to iwxxm:validPeriod//gml:beginPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-6">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) eq 0 ) then( (exists(iwxxm:forecastPositionAnalysis) and empty(iwxxm:analysis//iwxxm:directionOfMotion) and empty(iwxxm:analysis//iwxxm:speedOfMotion)) or (empty(iwxxm:forecastPositionAnalysis) and exists(iwxxm:analysis//iwxxm:directionOfMotion)) or (empty(iwxxm:forecastPositionAnalysis) and empty(iwxxm:analysis//iwxxm:directionOfMotion) and empty(iwxxm:analysis//iwxxm:speedOfMotion)) ) else( true() ) )">SIGMET.SIGMET-6: A report cannot have both iwxxm:forecastPositionAnalysis and iwxxm:analysis//iwxxm:directionOfMotion (with or without iwxxm:analysis//iwxxm:speedOfMotion) at the same time</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-5">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) eq 0 and exists(iwxxm:forecastPositionAnalysis//iwxxm:phenomenonTime/*) and exists(iwxxm:validPeriod/*) ) then( empty(index-of(for $i in iwxxm:forecastPositionAnalysis return number(translate($i//iwxxm:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','')) eq number(translate(iwxxm:validPeriod/gml:TimePeriod/gml:endPosition,'-T:Z','')),false())) ) else( true() ) )">SIGMET.SIGMET-5: iwxxm:forecastPositionAnalysis//iwxxm:phenomenonTime must be less than or equal to iwxxm:validPeriod//endPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-8">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'SIGMET' and exists(iwxxm:analysis/*) ) then( exists(iwxxm:analysis/iwxxm:SIGMETEvolvingConditionCollection) and empty(iwxxm:analysis/*[name() != 'iwxxm:SIGMETEvolvingConditionCollection']) ) else( true() ) )">SIGMET.SIGMET-8: In a SIGMET report the child element of iwxxm:analysis should be SIGMETEvolvingConditionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-9">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'SIGMET' and exists(iwxxm:forecastPositionAnalysis) ) then( exists(iwxxm:forecastPositionAnalysis/iwxxm:SIGMETPositionCollection) and empty(iwxxm:forecastPositionAnalysis/*[name() != 'iwxxm:SIGMETPositionCollection']) ) else( true() ) )">SIGMET.SIGMET-9: In a SIGMET report the child element of iwxxm:forecastPositionAnalysis should be SIGMETPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-10">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'SIGMET' and exists(iwxxm:analysis/*) ) then( count(iwxxm:analysis) eq 1 ) else( true() ) )">SIGMET.SIGMET-10: In a SIGMET report there should be one iwxxm:analysis at most</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-11">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'SIGMET' and exists(iwxxm:forecastPositionAnalysis) ) then( count(iwxxm:forecastPositionAnalysis) eq 1 ) else( true() ) )">SIGMET.SIGMET-11: In a SIGMET report there should be one iwxxm:forecastPositionAnalysis at most</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-2">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( @status = 'CANCELLATION' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:originatingMeteorologicalWatchOffice) and exists(iwxxm:issuingAirTrafficServicesRegion) and exists(iwxxm:sequenceNumber) and exists(iwxxm:validPeriod) and exists(iwxxm:cancelledSequenceNumber) and exists(iwxxm:cancelledValidPeriod) and (empty(iwxxm:phenomenon/*) and iwxxm:phenomenon/@nilReason = 'http://codes.wmo.int/common/nil/inapplicable') and (empty(iwxxm:analysis/*) and iwxxm:analysis/@nilReason = 'http://codes.wmo.int/common/nil/inapplicable') ) else( true() ) )">SIGMET.SIGMET-2: A 'CANCELLATION' report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit, iwxxm:originatingMeteorologicalWatchOffice, iwxxm:issuingAirTrafficServicesRegion, iwxxm:sequenceNumber, iwxxm:validPeriod, iwxxm:cancelledSequenceNumber, iwxxm:cancelledValidPeriod, iwxxm:phenomenon (inapplicable) and iwxxm:analysis (inapplicable)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-3">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( @status = 'NORMAL' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:originatingMeteorologicalWatchOffice) and exists(iwxxm:issuingAirTrafficServicesRegion) and exists(iwxxm:sequenceNumber) and exists(iwxxm:validPeriod) and exists(iwxxm:phenomenon) and exists(iwxxm:analysis) ) else( true() ) )">SIGMET.SIGMET-3: A 'NORMAL' report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit, iwxxm:originatingMeteorologicalWatchOffice, iwxxm:issuingAirTrafficServicesRegion, iwxxm:sequenceNumber, iwxxm:validPeriod, iwxxm:phenomenon, iwxxm:analysis, iwxxm:forecastPositionAnalysis (optional)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-1">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:validPeriod) ) else( true() ) )">SIGMET.SIGMET-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit and iwxxm:validPeriod</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET-7">
      <sch:rule context="//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( exists(iwxxm:volcanicAshMovedToFIR) ) then( local-name( . ) = 'VolcanicAshSIGMET' and @status = 'CANCELLATION' ) else( true() ) )">SIGMET.SIGMET-7: iwxxm:volcanicAshMovedToFIR can only be used in a VolcanicAshSIGMET 'CANCELLATION' report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMET.phenomenon">
      <sch:rule context="//*[contains(name(),'SIGMET')]/iwxxm:phenomenon">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-SigWxPhenomena.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">SIGMET iwxxm:phenomenon elements should be a member of http://codes.wmo.int/49-2/SigWxPhenomena</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMETEvolvingCondition-2">
      <sch:rule context="//iwxxm:SIGMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:directionOfMotion) and not(iwxxm:directionOfMotion/@xsi:nil = 'true') ) then ( iwxxm:directionOfMotion/@uom = 'deg' ) else( true() ) )">SIGMET.SIGMETEvolvingCondition-2: directionOfMotion shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMETEvolvingCondition-1">
      <sch:rule context="//iwxxm:SIGMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:speedOfMotion) ) then( exists(iwxxm:directionOfMotion) ) else( true() ) )">SIGMET.SIGMETEvolvingCondition-1: iwxxm:speedOfMotion cannot be given without having iwxxm:directionOfMotion</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SIGMET.SIGMETEvolvingCondition-3">
      <sch:rule context="//iwxxm:SIGMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:speedOfMotion) and not(iwxxm:speedOfMotion/@xsi:nil = 'true') ) then ( (iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]') ) else( true() ) )">SIGMET.SIGMETEvolvingCondition-3: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET.TropicalCycloneSIGMET-1">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( @status = 'NORMAL' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:tropicalCyclone) ) else( true() ) )">TropicalCycloneSIGMET.TropicalCycloneSIGMET-1: A 'NORMAL' report should also have iwxxm:TropicalCyclone</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET.TropicalCycloneSIGMET-2">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'TropicalCycloneSIGMET' and exists(iwxxm:analysis/*) ) then( exists(iwxxm:analysis/iwxxm:TropicalCycloneSIGMETEvolvingConditionCollection) and empty(iwxxm:analysis/*[name() != 'iwxxm:TropicalCycloneSIGMETEvolvingConditionCollection']) ) else( true() ) )">TropicalCycloneSIGMET.TropicalCycloneSIGMET-2: In a TC SIGMET report the child elements of iwxxm:analysis should be TropicalCycloneSIGMETEvolvingConditionCollection and TropicalCycloneSIGMETEvolvingCondition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET.TropicalCycloneSIGMET-3">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if( local-name( . ) = 'TropicalCycloneSIGMET' and exists(iwxxm:forecastPositionAnalysis/*) ) then( exists(iwxxm:forecastPositionAnalysis/iwxxm:TropicalCycloneSIGMETPositionCollection) and empty(iwxxm:forecastPositionAnalysis/*[name() != 'iwxxm:TropicalCycloneSIGMETPositionCollection']) ) else( true() ) )">TropicalCycloneSIGMET.TropicalCycloneSIGMET-3: In a TC SIGMET report the child elements of iwxxm:forecastPositionAnalysis should be TropicalCycloneSIGMETPositionCollection and TropicalCycloneSIGMETPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET.VolcanicAshSIGMET-1">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="( if( @status = 'NORMAL' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:eruptingVolcano) ) else( true() ) )">VolcanicAshSIGMET.VolcanicAshSIGMET-1: A 'NORMAL' report should also have iwxxm:eruptingVolcano</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET.VolcanicAshSIGMET-2">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="( if( local-name( . ) = 'VolcanicAshSIGMET' and exists(iwxxm:analysis/*) ) then( exists(iwxxm:analysis/iwxxm:VolcanicAshSIGMETEvolvingConditionCollection) and empty(iwxxm:analysis/*[name() != 'iwxxm:VolcanicAshSIGMETEvolvingConditionCollection']) ) else( true() ) )">VolcanicAshSIGMET.VolcanicAshSIGMET-2: In a VA SIGMET report the child elements of iwxxm:analysis should be VolcanicAshSIGMETEvolvingConditionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET.VolcanicAshSIGMET-3">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="( if( local-name( . ) = 'VolcanicAshSIGMET' and exists(iwxxm:forecastPositionAnalysis/*) ) then( exists(iwxxm:forecastPositionAnalysis/iwxxm:VolcanicAshSIGMETPositionCollection) and empty(iwxxm:forecastPositionAnalysis/*[name() != 'iwxxm:VolcanicAshSIGMETPositionCollection']) ) else( true() ) )">VolcanicAshSIGMET.VolcanicAshSIGMET-3: In a VA SIGMET report the child elements of iwxxm:forecastPositionAnalysis should be VolcanicAshSIGMETPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition.surfaceVisibilityCause">
      <sch:rule context="//*[contains(name(),'AIRMETEvolvingCondition')]/iwxxm:surfaceVisibilityCause">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-WeatherCausingVisibilityReduction.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AIRMETEvolvingCondition iwxxm:surfaceVisibilityCause elements should be a member of http://codes.wmo.int/49-2/WeatherCausingVisibilityReduction</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-1">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:cloudBase) and not(iwxxm:cloudBase/@xsi:nil = 'true') ) then( (iwxxm:cloudBase/@uom = 'm') or (iwxxm:cloudBase/@uom = '[ft_i]') ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-1: cloudBase shall be reported in metres (m) or feet ([ft_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-2">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:cloudTop) and not(iwxxm:cloudTop/@xsi:nil = 'true') ) then( (iwxxm:cloudTop/@uom = 'm') or (iwxxm:cloudTop/@uom = '[ft_i]') ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-2: cloudTop shall be reported in metres (m) or feet ([ft_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-3">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:directionOfMotion) and not(iwxxm:directionOfMotion/@xsi:nil = 'true') ) then( iwxxm:directionOfMotion/@uom = 'deg' ) else true())">AIRMET.AIRMETEvolvingCondition-3: directionOfMotion shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-4">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:speedOfMotion) and not(iwxxm:speedOfMotion/@xsi:nil = 'true') ) then( (iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]') ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-4: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-5">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:surfaceVisibility) and not(iwxxm:surfaceVisibility/@xsi:nil = 'true') ) then( iwxxm:surfaceVisibility/@uom = 'm' ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-5: surfaceVisibility shall be reported in metres (m)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-8">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( not((exists(iwxxm:surfaceWindDirection) and exists(iwxxm:surfaceWindSpeed)) or (empty(iwxxm:surfaceWindDirection) and empty(iwxxm:surfaceWindSpeed))) ) then( false() ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-8: surfaceWindDirection and surfaceWindSpeed must be reported together</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-7">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:surfaceWindDirection) and not(iwxxm:surfaceWindDirection/@xsi:nil = 'true') ) then( iwxxm:surfaceWindDirection/@uom = 'deg' ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-7: surfaceWindDirection shall be reported in the degrees unit of measure ('deg')</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMETEvolvingCondition-6">
      <sch:rule context="//iwxxm:AIRMETEvolvingCondition">
         <sch:assert test="( if( exists(iwxxm:surfaceWindSpeed) and not(iwxxm:surfaceWindSpeed/@xsi:nil = 'true') ) then( (iwxxm:surfaceWindSpeed/@uom = 'm/s') or (iwxxm:surfaceWindSpeed/@uom = '[kn_i]') ) else( true() ) )">AIRMET.AIRMETEvolvingCondition-6: surfaceWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET.phenomenon">
      <sch:rule context="//*[contains(name(),'AIRMET')]/iwxxm:phenomenon">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AirWxPhenomena.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">AIRMET iwxxm:phenomenon elements should be a member of http://codes.wmo.int/49-2/AirWxPhenomena</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET-4">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) eq 0 and exists(iwxxm:analysis//iwxxm:phenomenonTime/*) and exists(iwxxm:validPeriod/*) ) then( empty(index-of(for $i in iwxxm:analysis return number(translate($i//iwxxm:phenomenonTime/gml:TimeInstant/gml:timePosition,'-T:Z','')) eq number(translate(iwxxm:validPeriod/gml:TimePeriod/gml:beginPosition,'-T:Z','')),false())) ) else( true() ) )">AIRMET.AIRMET-4: iwxxm:analysis//iwxxm:phenomenonTime must be equal to iwxxm:validPeriod//gml:beginPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET-2">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="( if( @status = 'CANCELLATION' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:originatingMeteorologicalWatchOffice) and exists(iwxxm:issuingAirTrafficServicesRegion) and exists(iwxxm:sequenceNumber) and exists(iwxxm:validPeriod) and exists(iwxxm:cancelledSequenceNumber) and exists(iwxxm:cancelledValidPeriod) and (empty(iwxxm:phenomenon/@xlink:href) and iwxxm:phenomenon/@nilReason = 'http://codes.wmo.int/common/nil/inapplicable') and (empty(iwxxm:analysis/*) and iwxxm:analysis/@nilReason = 'http://codes.wmo.int/common/nil/inapplicable') ) else( true() ) )">AIRMET.AIRMET-2: A 'CANCELLATION' report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit, iwxxm:originatingMeteorologicalWatchOffice, iwxxm:issuingAirTrafficServicesRegion, iwxxm:sequenceNumber, iwxxm:validPeriod, iwxxm:cancelledSequenceNumber, iwxxm:cancelledValidPeriod, iwxxm:phenomenon (inapplicable) and iwxxm:analysis (inapplicable)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET-3">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="( if( @status = 'NORMAL' and string-length(@translationFailedTAC) eq 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:originatingMeteorologicalWatchOffice) and exists(iwxxm:issuingAirTrafficServicesRegion) and exists(iwxxm:sequenceNumber) and exists(iwxxm:validPeriod) and exists(iwxxm:phenomenon) and exists(iwxxm:analysis) ) else( true() ) )">AIRMET.AIRMET-3: A 'NORMAL' report should have appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit, iwxxm:originatingMeteorologicalWatchOffice, iwxxm:issuingAirTrafficServicesRegion, iwxxm:sequenceNumber, iwxxm:validPeriod, iwxxm:phenomenon, iwxxm:analysis, iwxxm:forecastPositionAnalysis (optional)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AIRMET.AIRMET-1">
      <sch:rule context="//iwxxm:AIRMET">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingAirTrafficServicesUnit) and exists(iwxxm:validPeriod) ) else( true() ) )">AIRMET.AIRMET-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime, iwxxm:issuingAirTrafficServicesUnit and iwxxm:validPeriod</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneForecastConditions-1">
      <sch:rule context="//iwxxm:TropicalCycloneForecastConditions">
         <sch:assert test="( if( exists(iwxxm:maximumSurfaceWindSpeed) and not(iwxxm:maximumSurfaceWindSpeed/@xsi:nil = 'true') ) then( (iwxxm:maximumSurfaceWindSpeed/@uom = 'm/s') or (iwxxm:maximumSurfaceWindSpeed/@uom = '[kn_i]') ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneForecastConditions-1: maximumSurfaceWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneAdvisory-1">
      <sch:rule context="//iwxxm:TropicalCycloneAdvisory">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingTropicalCycloneAdvisoryCentre) ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneAdvisory-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime, and iwxxm:issuingTropicalCycloneAdvisoryCentre</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneObservedConditions-1">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="( if( exists(iwxxm:centralPressure) and not(iwxxm:centralPressure/@xsi:nil = 'true') ) then( iwxxm:centralPressure/@uom = 'hPa' ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneObservedConditions-1: centralPressure shall be reported in hectopascals (hPa)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneObservedConditions-2">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="( if( exists(iwxxm:meanMaxSurfaceWind) and not(iwxxm:meanMaxSurfaceWind/@xsi:nil = 'true') ) then( (iwxxm:meanMaxSurfaceWind/@uom = 'm/s') or (iwxxm:meanMaxSurfaceWind/@uom = '[kn_i]') ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneObservedConditions-2: meanMaxSurfaceWind shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneObservedConditions-3">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="( if( exists(iwxxm:movementDirection) and not(iwxxm:movementDirection/@xsi:nil = 'true') ) then( iwxxm:movementDirection/@uom = 'deg' ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneObservedConditions-3: movementDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneAdvisory.TropicalCycloneObservedConditions-4">
      <sch:rule context="//iwxxm:TropicalCycloneObservedConditions">
         <sch:assert test="( if( exists(iwxxm:movementSpeed) and not(iwxxm:movementSpeed/@xsi:nil = 'true') ) then( (iwxxm:movementSpeed/@uom = 'km/h') or (iwxxm:movementSpeed/@uom = '[kn_i]') ) else( true() ) )">TropicalCycloneAdvisory.TropicalCycloneObservedConditions-4: movementSpeed shall be reported in kilometres per hour (km/h) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshCloud-1">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="( if( exists(iwxxm:directionOfMotion) and not(iwxxm:directionOfMotion/@xsi:nil = 'true') ) then( iwxxm:directionOfMotion/@uom = 'deg' ) else( true() ) )">VolcanicAshAdvisory.VolcanicAshCloud-1: directionOfMotion shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshCloud-2">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="( if( exists(iwxxm:speedOfMotion) and not(iwxxm:speedOfMotion/@xsi:nil = 'true') ) then( (iwxxm:speedOfMotion/@uom = 'km/h') or (iwxxm:speedOfMotion/@uom = '[kn_i]') ) else( true() ) )">VolcanicAshAdvisory.VolcanicAshCloud-2: speedOfMotion shall be reported in kilometres per hour (km/h) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshCloud-3">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="( if( exists(iwxxm:windDirection) and not(iwxxm:windDirection/@xsi:nil = 'true') ) then( iwxxm:windDirection/@uom = 'deg' ) else( true() ) )">VolcanicAshAdvisory.VolcanicAshCloud-3: windDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshCloud-4">
      <sch:rule context="//iwxxm:VolcanicAshCloud">
         <sch:assert test="( if( exists(iwxxm:windSpeed) and not(iwxxm:windSpeed/@xsi:nil = 'true') ) then( (iwxxm:windSpeed/@uom = 'm/s') or (iwxxm:windSpeed/@uom = '[kn_i]') ) else( true() ) )">VolcanicAshAdvisory.VolcanicAshCloud-4: windSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshAdvisory.colourCode">
      <sch:rule context="//*[contains(name(),'VolcanicAshAdvisory')]/iwxxm:colourCode">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AviationColourCode.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">VolcanicAshAdvisory iwxxm:colourCode elements should be a member of http://codes.wmo.int/49-2/AviationColourCode</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshAdvisory.VolcanicAshAdvisory-1">
      <sch:rule context="//iwxxm:VolcanicAshAdvisory">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingVolcanicAshAdvisoryCentre) ) else( true() ) )">VolcanicAshAdvisory.VolcanicAshAdvisory-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime and iwxxm:issuingVolcanicAshAdvisoryCentre</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SpaceWeatherAdvisory.SpaceWeatherRegion.locationIndicator">
      <sch:rule context="//*[contains(name(),'SpaceWeatherRegion')]/iwxxm:locationIndicator">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-SpaceWxLocation.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">SpaceWeatherRegion iwxxm:locationIndicator elements should be a member of http://codes.wmo.int/49-2/SpaceWxLocation</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SpaceWeatherAdvisory.SpaceWeatherAdvisory.phenomenon">
      <sch:rule context="//*[contains(name(),'SpaceWeatherAdvisory')]/iwxxm:phenomenon">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-SpaceWxPhenomena.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">SpaceWeatherAdvisory iwxxm:phenomenon elements should be a member of http://codes.wmo.int/49-2/SpaceWxPhenomena</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SpaceWeatherAdvisory.SpaceWeatherAdvisory-1">
      <sch:rule context="//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( string-length(@translationFailedTAC) gt 0 ) then( exists(iwxxm:issueTime) and exists(iwxxm:issuingSpaceWeatherCentre) ) else( true() ) )">SpaceWeatherAdvisory.SpaceWeatherAdvisory-1: A report that failed translation should have as a minimum appropriately filled elements including Iwxxm:issueTime and iwxxm:issuingSpaceWeatherCentre</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR_SPECI.MeteorologicalAerodromeTrendForecast.weather">
      <sch:rule context="//*[contains(name(),'MeteorologicalAerodromeTrendForecast')]/iwxxm:weather">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AerodromePresentOrForecastWeather.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">MeteorologicalAerodromeTrendForecast iwxxm:weather elements should be a member of http://codes.wmo.int/49-2/AerodromePresentOrForecastWeather</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF.MeteorologicalAerodromeForecast.weather">
      <sch:rule context="//*[contains(name(),'MeteorologicalAerodromeForecast')]/iwxxm:weather">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-AerodromePresentOrForecastWeather.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">MeteorologicalAerodromeForecast iwxxm:weather elements should be a member of http://codes.wmo.int/49-2/AerodromePresentOrForecastWeather</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Common.CloudLayer.cloudType">
      <sch:rule context="//*[contains(name(),'CloudLayer')]/iwxxm:cloudType">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-SigConvectiveCloudType.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">CloudLayer iwxxm:cloudType elements should be a member of http://codes.wmo.int/49-2/SigConvectiveCloudType</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Common.CloudLayer.amount">
      <sch:rule context="//*[contains(name(),'CloudLayer')]/iwxxm:amount">
         <sch:assert test="@xlink:href = document('codes.wmo.int-49-2-CloudAmountReportedAtAerodrome.rdf')/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason">CloudLayer iwxxm:amount elements should be a member of http://codes.wmo.int/49-2/CloudAmountReportedAtAerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.CloudLayer-1">
      <sch:rule context="//iwxxm:CloudLayer">
         <sch:assert test="( if( exists(iwxxm:base) and not(iwxxm:base/@xsi:nil = 'true') ) then( (iwxxm:base/@uom = 'm') or (iwxxm:base/@uom = '[ft_i]') ) else( true() ) )">COMMON.CloudLayer-1: base shall be reported in metres (m) or feet ([ft_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report-5">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory|//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( //@gml:id[not(matches(.,'uuid\.[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}'))] ) then( false() ) else( true() ) )">COMMON.Report-5: All gml:ids in IWXXM reports must be prefixed with 'uuid.' and must be UUID version 4</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report-4">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory|//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( exists(//iwxxm:extension) ) then( sum(//iwxxm:extension/.//text()/string-length(.) ) +sum( //iwxxm:extension/.//element()/( (string-length( name() ) * 2 ) + 5 ) ) +sum( //iwxxm:extension/.//@*/( 1 + string-length(name()) + 3 + string-length(.) ) ) +sum( //iwxxm:extension/.//comment()/( string-length( . ) + 7 )) lt 5000 ) else( true() ) )">COMMON.Report-4: Total size of extension content must not exceed 5000 characters per report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report-1">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory|//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( @permissibleUsage = 'NON-OPERATIONAL' ) then( exists(@permissibleUsageReason) ) else( true() ) )">COMMON.Report-1: Non-operational reports must include a permissibleUsageReason</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report-2">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory|//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( @permissibleUsage ='OPERATIONAL') then( empty(@permissibleUsageReason) ) else( true() ) )">COMMON.Report-2: Operational reports should not include a permissibleUsageReason</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.Report-3">
      <sch:rule context="//iwxxm:METAR|//iwxxm:SPECI|//iwxxm:TAF|//iwxxm:SIGMET|//iwxxm:VolcanicAshSIGMET|//iwxxm:TropicalCycloneSIGMET|//iwxxm:AIRMET|//iwxxm:TropicalCycloneAdvisory|//iwxxm:VolcanicAshAdvisory|//iwxxm:SpaceWeatherAdvisory">
         <sch:assert test="( if( exists(@translatedBulletinID) or exists(@translatedBulletinReceptionTime) or exists(@translationCentreDesignator) or exists(@translationCentreName) or exists(@translationTime) or exists(@translationFailedTAC)) then( exists(@translatedBulletinID) and exists(@translatedBulletinReceptionTime) and exists(@translationCentreDesignator) and exists(@translationCentreName) and exists(@translationTime) ) else( true() ) )">COMMON.Report-3: Translated reports must include @translatedBulletinID, @translatedBulletinReceptionTime, @translationCentreDesignator, @translationCentreName, @translationTime and optionally @translationFailedTAC if translation failed</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeCloudForecast-2">
      <sch:rule context="//iwxxm:AerodromeCloudForecast">
         <sch:assert test="(if( exists(iwxxm:layer) ) then( empty(iwxxm:verticalVisibility) ) else( true() ) )">COMMON.AerodromeCloudForecast-2: If cloud layers are reported vertical visibility should be empty</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeCloudForecast-1">
      <sch:rule context="//iwxxm:AerodromeCloudForecast">
         <sch:assert test="(if( exists(iwxxm:verticalVisibility) ) then( empty(iwxxm:layer) ) else( true() ) )">COMMON.AerodromeCloudForecast-1: If vertical visibility is reported cloud layers should be empty</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeCloudForecast-3">
      <sch:rule context="//iwxxm:AerodromeCloudForecast">
         <sch:assert test="( if( exists(iwxxm:verticalVisibility) and not(iwxxm:verticalVisibility/@xsi:nil = 'true') ) then( (iwxxm:verticalVisibility/@uom = 'm') or (iwxxm:verticalVisibility/@uom = '[ft_i]') ) else( true() ) )">COMMON.AerodromeCloudForecast-3: verticalVisibility shall be reported in metres (m) or feet ([ft_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeSurfaceWindForecast-1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="( if( @variableDirection = 'true' ) then( empty(iwxxm:meanWindDirection) ) else( true() ) )">COMMON.AerodromeSurfaceWindForecast-1: Wind direction is not reported when variable winds are indicated</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeSurfaceWindTrendForecast-1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="( if( exists(iwxxm:meanWindDirection) and not(iwxxm:meanWindDirection/@xsi:nil = 'true') ) then( iwxxm:meanWindDirection/@uom = 'deg' ) else( true() ) )">COMMON.AerodromeSurfaceWindTrendForecast-1: meanWindDirection shall be reported in degrees (deg)</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeSurfaceWindTrendForecast-2">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="( if( exists(iwxxm:meanWindSpeed) and not(iwxxm:meanWindSpeed/@xsi:nil = 'true') ) then( (iwxxm:meanWindSpeed/@uom = 'm/s') or (iwxxm:meanWindSpeed/@uom = '[kn_i]') ) else( true() ) )">COMMON.AerodromeSurfaceWindTrendForecast-2: meanWindSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="COMMON.AerodromeSurfaceWindTrendForecast-3">
      <sch:rule context="//iwxxm:AerodromeSurfaceWindTrendForecast|//iwxxm:AerodromeSurfaceWindForecast">
         <sch:assert test="( if( exists(iwxxm:windGustSpeed) and not(iwxxm:windGustSpeed/@xsi:nil = 'true') ) then( (iwxxm:windGustSpeed/@uom = 'm/s') or (iwxxm:windGustSpeed/@uom = '[kn_i]') ) else( true() ) )">COMMON.AerodromeSurfaceWindTrendForecast-3: windGustSpeed shall be reported in metres per second (m/s) or knots ([kn_i])</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="IWXXM.ExtensionAlwaysLast">
      <sch:rule context="//iwxxm:extension">
         <sch:assert test="following-sibling::*[1][self::iwxxm:extension] or not(following-sibling::*)">IWXXM.ExtensionAlwaysLast: Extension elements should be the last elements in their parents</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
