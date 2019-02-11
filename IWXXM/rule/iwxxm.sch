<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
   <sch:title>Schematron validation</sch:title>
   <sch:ns prefix="iwxxm" uri="http://icao.int/iwxxm/1.1"></sch:ns>
   <sch:ns prefix="saf" uri="http://icao.int/saf/1.1"></sch:ns>
   <sch:ns prefix="sam" uri="http://www.opengis.net/sampling/2.0"></sch:ns>
   <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"></sch:ns>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"></sch:ns>
   <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"></sch:ns>
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"></sch:ns>
   <sch:pattern id="METAR1">
      <sch:rule context="//iwxxm:METAR">
         <sch:assert test="(empty(distinct-values(for $trend-forecast in //iwxxm:trendForecast return((deep-equal(//iwxxm:observation/om:OM_Observation/om:featureOfInterest//sam:sampledFeature,$trend-forecast/om:OM_Observation/om:featureOfInterest//sam:sampledFeature))or(concat('#', //iwxxm:observation/om:OM_Observation/om:featureOfInterest/sams:SF_SpatialSamplingFeature/@gml:id)=$trend-forecast/om:OM_Observation/om:featureOfInterest/@xlink:href)))[.=false()]))">METAR: sampledFeature should be equal in observation and trendForecast</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR2">
      <sch:rule context="//iwxxm:METAR">
         <sch:assert test="(if(@status eq 'MISSING') then( exists(iwxxm:observation//om:result/@nilReason) and ((empty(@automatedStation) or (@automatedStation eq 'false')) and empty(iwxxm:trendForecast)) ) else(true()))">METAR: Missing reports only include identifying information (time, aerodrome) and
            no other information
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR3">
      <sch:rule context="//iwxxm:METAR">
         <sch:assert test="(if( empty(iwxxm:observation//iwxxm:cloud/iwxxm:AerodromeObservedClouds) and ends-with(iwxxm:observation//iwxxm:cloud/@nilReason, 'notDetectedByAutoSystem') ) then(@automatedStation eq 'true') else(true()))">METAR: When no clouds are detected by the auto system, this report must be an auto
            report
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR4">
      <sch:rule context="//iwxxm:METAR">
         <sch:assert test="(((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Aerodrome)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'aerodrome')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())))">MeteorologicalAerodromeObservation: The sampled feature for a METAR/SPECI is an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="METAR5">
      <sch:rule context="//iwxxm:METAR/iwxxm:observation/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:MeteorologicalAerodromeObservationRecord)) else(true()))">MeteorologicalAerodromeObservation: Result should be of appropriate type</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SPECI1">
      <sch:rule context="//iwxxm:SPECI">
         <sch:assert test="(empty(distinct-values(for $trend-forecast in //iwxxm:trendForecast return((deep-equal(//iwxxm:observation/om:OM_Observation/om:featureOfInterest//sam:sampledFeature,$trend-forecast/om:OM_Observation/om:featureOfInterest//sam:sampledFeature))or(concat('#', //iwxxm:observation/om:OM_Observation/om:featureOfInterest/sams:SF_SpatialSamplingFeature/@gml:id)=$trend-forecast/om:OM_Observation/om:featureOfInterest/@xlink:href)))[.=false()]))">SPECI: sampledFeature should be equal in observation and trendForecast</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SPECI2">
      <sch:rule context="//iwxxm:SPECI">
         <sch:assert test="(if(@status eq 'MISSING') then( exists(iwxxm:observation//om:result/@nilReason) and ((empty(@automatedStation) or (@automatedStation eq 'false')) and empty(iwxxm:trendForecast)) ) else(true()))">SPECI: Missing reports only include identifying information (time, aerodrome) and
            no other information
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SPECI3">
      <sch:rule context="//iwxxm:SPECI">
         <sch:assert test="(if( empty(iwxxm:observation//iwxxm:cloud/iwxxm:AerodromeObservedClouds) and ends-with(iwxxm:observation//iwxxm:cloud/@nilReason, 'notDetectedByAutoSystem') ) then(@automatedStation eq 'true') else(true()))">SPECI: When no clouds are detected by the auto system, this report must be an auto
            report
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SPECI4">
      <sch:rule context="//iwxxm:SPECI">
         <sch:assert test="(((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Aerodrome)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'aerodrome')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())))">MeteorologicalAerodromeObservation: The sampled feature for a METAR/SPECI is an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="SPECI5">
      <sch:rule context="//iwxxm:SPECI/iwxxm:observation/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:MeteorologicalAerodromeObservationRecord)) else(true()))">MeteorologicalAerodromeObservation: Result should be of appropriate type</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeObservationRecord1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:visibility) else true())">MeteorologicalAerodromeObservationRecord: should not report visibility when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeObservationRecord2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:rvr) else true())">MeteorologicalAerodromeObservationRecord: should not report rvr when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeObservationRecord3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:presentWeather) else true())">MeteorologicalAerodromeObservationRecord: should not report presentWeather when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeObservationRecord4">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK='true') then empty(iwxxm:cloud) else true())">MeteorologicalAerodromeObservationRecord: should not report cloud when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeObservationRecord5">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeObservationRecord">
         <sch:assert test="(if((exists(iwxxm:visibility)) and (iwxxm:visibility//iwxxm:prevailingVisibility/number(text()) lt 1500) and (iwxxm:visibility//iwxxm:prevailingVisibility/@uom eq 'm')) then (exists(iwxxm:rvr)) else true())">MeteorologicalAerodromeObservationRecord: Table A3-2 Note 7 states: To be included
            if visibility or RVR &lt; 1500 m; for up to a maximum of four runways.  This is interpreted
            to mean that if the prevailing visibility is below 1500 meters, RVR should always
            be included
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeRunwayState1">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if(exists(iwxxm:estimatedSurfaceFriction)) then((number(iwxxm:estimatedSurfaceFriction) gt 0) and (number(iwxxm:estimatedSurfaceFriction) le 0.9) ) else true())">AerodromeRunwayState: Estimated surface friction must  be between 0 and 0.9</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeRunwayState2">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if(@estimatedSurfaceFrictionUnreliable eq 'true') then( empty(iwxxm:estimatedSurfaceFriction) ) else true())">AerodromeRunwayState: When surface friction is unreliable, no surface friction is
            reported
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeRunwayState3">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if(@allRunways eq 'true') then( empty(iwxxm:runway) ) else true())">AerodromeRunwayState: When all runways are being reported upon, no specific Runway
            should be reported
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeRunwayState4">
      <sch:rule context="//iwxxm:AerodromeRunwayState">
         <sch:assert test="(if( exists(iwxxm:runway) ) then( empty(@allRunways) or (@allRunways eq 'false') )  else true())">AerodromeRunwayState: When a single Runway is reported upon, the allRunways flag should
            be missing or false
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeWindShear1">
      <sch:rule context="//iwxxm:AerodromeWindShear">
         <sch:assert test="(if( @allRunways eq 'true' ) then( empty(iwxxm:runway) ) else true())">AerodromeWindShear: When all runways are affected by wind shear, no specific runways
            should be reported
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeObservedClouds1">
      <sch:rule context="//iwxxm:AerodromeObservedClouds">
         <sch:assert test="(if( exists(iwxxm:verticalVisibility) ) then empty(iwxxm:layer) else true())">AerodromeObservedClouds: Vertical visibility cannot be reported with cloud layers</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeObservedClouds2">
      <sch:rule context="//iwxxm:AerodromeObservedClouds">
         <sch:assert test="(if( @amountAndHeightUnobservableByAutoSystem eq 'true' ) then ( empty(iwxxm:layer) ) else true())">AerodromeObservedClouds: When amountAndHeightUnobservableByAutoSystem is true, no
            cloud layers may be reported
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeSeaState1">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( exists(iwxxm:seaState) ) then ( empty(iwxxm:significantWaveHeight) ) else (true()))">AerodromeSeaState: If the sea state is set, significantWaveHeight is not reported
            (one or the other)
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeSeaState2">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( exists(iwxxm:significantWaveHeight) ) then ( empty(iwxxm:seaState) ) else (true()))">AerodromeSeaState: If the significantWaveHeight is set, seaState is not reported (one
            or the other)
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeSeaState3">
      <sch:rule context="//iwxxm:AerodromeSeaState">
         <sch:assert test="(if( empty(iwxxm:seaState) ) then ( exists(iwxxm:significantWaveHeight) ) else (true()))">AerodromeSeaState: Either seaState or significantWaveHeight must be present</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeSurfaceWind1">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( exists(iwxxm:meanWindDirection)and exists(iwxxm:extremeClockwiseWindDirection)and exists(iwxxm:extremeCounterClockwiseWindDirection)  ) then ((iwxxm:meanWindDirection/@uom = iwxxm:extremeClockwiseWindDirection/@uom) and (iwxxm:meanWindDirection/@uom = iwxxm:extremeCounterClockwiseWindDirection/@uom)) else true())">AerodromeSurfaceWind: All wind UOMs must be the same</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeSurfaceWind2">
      <sch:rule context="//iwxxm:AerodromeSurfaceWind">
         <sch:assert test="(if( @variableDirection eq 'true' ) then ( empty(iwxxm:meanWindDirection) ) else true())">AerodromeSurfaceWind: Wind direction is not reported when variable winds are indicated</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeTrendForecastRecord1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:cloud)) else (true()))">MeteorologicalAerodromeTrendForecastRecord: clouds should be absent when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeTrendForecastRecord2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeTrendForecastRecord">
         <sch:assert test="(if( @cloudAndVisibilityOK eq 'true' ) then (empty(iwxxm:forecastWeather)) else (true()))">MeteorologicalAerodromeTrendForecastRecord: forecastWeather should be absent when
            cloudAndVisibilityOK is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromeRecentWeather1">
      <sch:rule context="//iwxxm:recentWeather">
         <sch:assert test="(exists(doc(@xlink:href)/ok))">AerodromeRecentWeather: link tag should be named ok</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="AerodromePresentWeather1">
      <sch:rule context="//iwxxm:presentWeather">
         <sch:assert test="(exists(doc(@xlink:href)/ok))">AerodromePresentWeather: link tag should be named ok</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF1">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(//iwxxm:MeteorologicalAerodromeForecastRecord/@changeIndicator) then(empty(iwxxm:MeteorologicalAerodromeForecastRecord/iwxxm:temperature)) else(true()))">TAF: Forecast conditions cannot include temperature information. They are otherwise
            identical to the prevailing conditions
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF2">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'NORMAL' ) then (empty(iwxxm:previousReportValidPeriod)) else (true()))">TAF: previousReportValidPeriod must be null unless this cancels, corrects or amends
            a previous report
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF3">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'AMENDMENT' ) then (exists(iwxxm:previousReportValidPeriod)) else (true()))">TAF: An amended report must also include the valid time of the amended report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF4">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'CANCELLATION' ) then (exists(iwxxm:previousReportValidPeriod)) else (true()))">TAF: A cancelled report must also include the valid time of the cancelled report</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF5">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'CORRECTION' ) then (exists(iwxxm:previousReportValidPeriod)) else (true()))">TAF: A corrected report must reference</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF6">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(empty(distinct-values(for $change-forecast in iwxxm:changeForecast return($change-forecast/om:OM_Observation/om:resultTime//gml:timePosition/text()=iwxxm:baseForecast/om:OM_Observation/om:resultTime//gml:timePosition/text())or($change-forecast/om:OM_Observation/om:resultTime/@xlink:href=iwxxm:baseForecast/om:OM_Observation/om:resultTime/@xlink:href))[.=false()]))">TAF: resultTime for the baseForecast and the changeForecasts must match</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF7">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if(exists(iwxxm:baseForecast)) then(empty(distinct-values((iwxxm:issueTime//gml:timePosition/text()=iwxxm:baseForecast/om:OM_Observation/om:resultTime//gml:timePosition/text())or(concat( '#', iwxxm:issueTime//@gml:id )=iwxxm:baseForecast/om:OM_Observation/om:resultTime/@xlink:href))[.=false()])) else( true() ))">TAF: TAF issue time must match the baseForecast resultTime</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF8">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(empty(iwxxm:baseForecast//iwxxm:MeteorologicalAerodromeForecastRecord/@changeIndicator) )">TAF: Base conditions may not have a change indicator</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF9">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status = 'MISSING' ) then( (exists(iwxxm:baseForecast//om:result/@nilReason)) and ((empty(iwxxm:validTime)) and ((empty(iwxxm:previousReportValidPeriod)) and (empty(iwxxm:changeForecast))))) else( true()))">TAF: Missing TAF reports only include aerodrome information and issue time information</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF10">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if(count(iwxxm:changeForecast) gt 1) then( empty(iwxxm:changeForecast//iwxxm:MeteorologicalAerodromeForecastRecord[ (starts-with(./@changeIndicator, 'PROBABILITY')) and ((./../../../preceding-sibling::node()//iwxxm:MeteorologicalAerodromeForecastRecord/@changeIndicator = 'FROM') or (./../../../preceding-sibling::node()//iwxxm:MeteorologicalAerodromeForecastRecord/@changeIndicator = 'BECOMING') ) ]) ) else(true()) )">TAF: PROB30/PROB40 never follows a FROM or BECOMING group</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TAF11">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if( @status ne 'MISSING') then(exists(iwxxm:validTime)) else(true()))">TAF: Non-missing TAF reports must contains validTime</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeForecast1">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="(if((exists(//om:OM_Observation)) and (empty(//om:OM_Observation/om:result/@nilReason))) then((exists(//om:OM_Observation/om:validTime/gml:TimePeriod))or(concat( '#', //iwxxm:validTime/gml:TimePeriod/@gml:id ) = //om:OM_Observation/om:validTime/@xlink:href)) else(true()))">MeteorologicalAerodromeForecast: The OM validTime must be a time period for TAF forecasts</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeForecast2">
      <sch:rule context="//iwxxm:TAF">
         <sch:assert test="( if(exists(//om:OM_Observation))  then (  ( (exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Aerodrome)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'aerodrome')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true()) )  )  else(true()) )">MeteorologicalAerodromeForecast: The sampled feature is always an aerodrome</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeForecastRecord1">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:prevailingVisibility) else true())">MeteorologicalAerodromeForecastRecord: Should not report prevailingVisibility when
            cloudAndVisibilityOK is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeForecastRecord2">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:cloud) else true())">MeteorologicalAerodromeForecastRecord: Should not report cloud when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="MeteorologicalAerodromeForecastRecord3">
      <sch:rule context="//iwxxm:MeteorologicalAerodromeForecastRecord">
         <sch:assert test="(if(@cloudAndVisibilityOK = 'true') then empty(iwxxm:weather) else true())">MeteorologicalAerodromeForecastRecord: Should not report weather when cloudAndVisibilityOK
            is true
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET1">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="(if(@status ne 'CANCELLATION') then(exists(//iwxxm:analysis/om:OM_Observation/om:result/iwxxm:EvolvingMeteorologicalCondition)) else(true()))">VolcanicAshSIGMET: OBS and FCST classifications must have a result type of EvolvingMeteorologicalCondition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET2">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="(if(@status = 'CANCELLATION') then exists(iwxxm:analysis//om:result/@nilReason) else(true()))">VolcanicAshSIGMET: A canceled SIGMET should not have an analysis</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET3">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="(if(@status = 'NORMAL') then ((exists(iwxxm:analysis)) and (empty(iwxxm:analysis//om:result/@nilReason))) else(true()))">VolcanicAshSIGMET: There must be at least one analysis when a SIGMET does not have
            canceled status
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET4">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="(if(@status ne 'CANCELLATION') then(exists(iwxxm:forecastPositionAnalysis/om:OM_Observation/om:result/iwxxm:MeteorologicalPositionCollection//iwxxm:MeteorologicalPosition)) else(true()))">VolcanicAshSIGMET: MeteorologicalPosition must be member of MeteorologicalPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET5">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="( if(@status ne 'CANCELLATION') then((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Airspace)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'fir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'uir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'cta')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())) else(true()))">SIGMETEvolvingConditionAnalysis: Sampled feature must be an FIR, UIR, or CTA</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET6">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET//iwxxm:analysis/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:EvolvingMeteorologicalCondition)) else(true()))">SIGMETEvolvingConditionAnalysis: Result must be a single EvolvingMeteorologicalPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET7">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET">
         <sch:assert test="( if(@status ne 'CANCELLATION') then((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Airspace)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'fir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'uir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'cta')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())) else(true()))">SIGMETPositionAnalysis: Sampled feature must be an FIR, UIR, or CTA</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="VolcanicAshSIGMET8">
      <sch:rule context="//iwxxm:VolcanicAshSIGMET//iwxxm:forecastPositionAnalysis/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:MeteorologicalPositionCollection)) else(true()))">SIGMETPositionAnalysis: result must be MeteorologicalPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET1">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status ne 'CANCELLATION') then(exists(//iwxxm:analysis/om:OM_Observation/om:result/iwxxm:EvolvingMeteorologicalCondition)) else(true()))">TropicalCycloneSIGMET: OBS and FCST classifications must have a result type of EvolvingMeteorologicalCondition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET2">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status = 'CANCELLATION') then exists(iwxxm:analysis//om:result/@nilReason) else(true()))">TropicalCycloneSIGMET: A canceled SIGMET should not have an analysis</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET3">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status = 'NORMAL') then ((exists(iwxxm:analysis)) and (empty(iwxxm:analysis//om:result/@nilReason))) else(true()))">TropicalCycloneSIGMET: There must be at least one analysis when a SIGMET does not
            have canceled status
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET4">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="(if(@status ne 'CANCELLATION') then(exists(iwxxm:forecastPositionAnalysis/om:OM_Observation/om:result/iwxxm:MeteorologicalPositionCollection//iwxxm:MeteorologicalPosition)) else(true()))">TropicalCycloneSIGMET: MeteorologicalPosition must be member of MeteorologicalPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET5">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if(@status ne 'CANCELLATION') then((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Airspace)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'fir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'uir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'cta')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())) else(true()))">SIGMETEvolvingConditionAnalysis: Sampled feature must be an FIR, UIR, or CTA</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET6">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET//iwxxm:analysis/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:EvolvingMeteorologicalCondition)) else(true()))">SIGMETEvolvingConditionAnalysis: Result must be a single EvolvingMeteorologicalPosition</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET7">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET">
         <sch:assert test="( if(@status ne 'CANCELLATION') then((exists(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/saf:Airspace)) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'fir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'uir')) or (contains(string(//om:OM_Observation/om:featureOfInterest//sam:sampledFeature/@xlink:href), 'cta')) )  and  ( if(exists(//om:OM_Observation/om:featureOfInterest/@xlink:href)) then (concat( '#', //om:OM_Observation//sams:SF_SpatialSamplingFeature/@gml:id ) = //om:OM_Observation/om:featureOfInterest/@xlink:href) else(true())) else(true()))">SIGMETPositionAnalysis: Sampled feature must be an FIR, UIR, or CTA</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="TropicalCycloneSIGMET8">
      <sch:rule context="//iwxxm:TropicalCycloneSIGMET//iwxxm:forecastPositionAnalysis/om:OM_Observation">
         <sch:assert test="(if(empty(om:result/@nilReason)) then(exists(om:result/iwxxm:MeteorologicalPositionCollection)) else(true()))">SIGMETPositionAnalysis: result must be MeteorologicalPositionCollection</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
