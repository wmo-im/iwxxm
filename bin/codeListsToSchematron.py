#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Search all IWXXM schemas for vocabulary/codelist entries, download each entry to RDF format, then create
Schematron rules that checks that each element's xlink:href is a member of the corresponding codelist

Written using Python 2.7
"""

import os
import sys
from os.path import isfile, join
import xml.etree.ElementTree as ET
import requests

def main():

    if len( sys.argv ) < 3:
        print "Usage: codeListsToSchematron.py [schema dir] [output dir]"
        sys.exit(1)

    schemaPath = sys.argv[1]
    outputDir = sys.argv[2]

    if not os.path.isdir(schemaPath) or not os.path.isdir(outputDir):
        print 'ERROR: %s and %s must be existing directories' % (schemaPath, outputDir)
        sys.exit(1)

    ns = {'xs': 'http://www.w3.org/2001/XMLSchema'}

    xsdfiles = [f for f in os.listdir(schemaPath) if f.endswith(".xsd") and isfile(join(schemaPath, f))]

    schematronFile = join(outputDir,'codelists.sch')

    # remove *.rdf and *.sch before we begin so there aren't any old files
    for rdfFile in os.listdir(outputDir):
        if rdfFile.endswith(".rdf") or rdfFile.endswith(".sch"):
            os.remove(join(outputDir, rdfFile))

    with open(join(outputDir, schematronFile), 'w') as schematronFhandle:

        schHeader = '''<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="iwxxm" uri="http://icao.int/iwxxm/2.1"/>
  <ns prefix="sf" uri="http://www.opengis.net/sampling/2.0"/>
  <ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"/>
  <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <ns prefix="om" uri="http://www.opengis.net/om/2.0"/>
  <ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <ns prefix="aixm" uri="http://www.aixm.aero/schema/5.1.1"/>
  <ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <ns prefix="reg" uri="http://purl.org/linked-data/registry#"/>'''

        schematronFhandle.write(schHeader)

        # dictionary mapping from XSD Type names such as 'AerodromeRecentWeatherType' to the path on codes.wmo.int such as 'http://codes.wmo.int/49-2/AerodromeRecentWeather'
        typeToCodeList={}

        # first go through the XSD files and find all types with a vocabulary/codelist
        # we walk through the XSD files twice because XSD Types are imported and used in other XSD files which means
        # we need to search all files for elements corresponding to XSD Types
        for xsdFile in xsdfiles:
            xsdFullPath = join(schemaPath, xsdFile)
            print 'Parsing %s for vocabularies/code lists' % xsdFullPath
            tree = ET.parse(xsdFullPath)
            root = tree.getroot()
            # for complexType in root.findall( '//{http://www.w3.org/2001/XMLSchema}complexType[annotation/appinfo/vocabulary]' ):
            for complexType in root.findall( 'xs:complexType', ns ):
                # print "Found complexType: "+str(complexType)
                for vocabularyElem in complexType.findall( 'xs:annotation/xs:appinfo/xs:vocabulary', ns ):
                    codeListPath = vocabularyElem.text
                    # for example, WeatherCausingVisibilityReductionType
                    complexTypeName=complexType.attrib['name']

                    typeToCodeList[complexTypeName]=codeListPath

                    # Download the RDF representation of this vocabulary
                    headers = {"Accept": "application/rdf+xml"}
                    print '\tDownloading %s in RDF format' % codeListPath
                    
                    r = requests.get(codeListPath, headers=headers)
                    localCodeListFile=parseLocalCodeListFile(outputDir,codeListPath)
                    if r.status_code == 200:
                        with open(localCodeListFile, 'w') as fhandle:
                            fhandle.write(r.text.encode('utf-8'))
                    else:
                        print 'ERROR: Could not load code list at %s!' % codeListPath

        schematronFhandle.write( '\n')
        # write each codelist file as a "let" variable in the Schematron.  We don't want duplicates of the same
        # variable to exist so this is done above all the Schematron pattern definitions
        writtenDocuments=set()
        for complexTypeName, codeListPath in typeToCodeList.iteritems():
            codeListName=parseCodeListName(codeListPath)
            if codeListName not in writtenDocuments:
                writtenDocuments.add(codeListName)
                localCodeListFile = parseLocalCodeListFile(outputDir, codeListPath)
                letStr='''
  <let name="%s" value="document('%s')" />''' % (codeListName,localCodeListFile)
                schematronFhandle.write(letStr)

        schematronFhandle.write('\n')

        # now search each XSD file for elements corresponding to our discovered XSD Types and write out appropriate
        # Schematron rules
        for xsdFile in xsdfiles:
            xsdFullPath = join(schemaPath, xsdFile)
            print 'Searching %s for elements matching the discovered code lists' % xsdFullPath
            tree = ET.parse(xsdFullPath)
            root = tree.getroot()
            for complexTypeName, codeListPath in typeToCodeList.iteritems():
                namespacedTypeName='iwxxm:%s' % complexTypeName
                # now find and iterate through elements that are of this type
                for element in root.findall(".//xs:element[@type='%s']" % (namespacedTypeName), ns ):
                    elementName=element.attrib['name']
                    print '\tFound element named %s of type %s with vocabulary %s' % (elementName,complexTypeName,codeListPath)

                    codeListName=parseCodeListName(codeListPath)

                    # Now create corresponding Schematron rules for each complexType and vocabulary
                    rule = '''
  <pattern id="%s-%s-test">
    <rule context="//iwxxm:%s">
      <assert test="@xlink:href = $%s/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason" >
        iwxxm:%s should be a member of %s
      </assert>
    </rule>
  </pattern>''' % (elementName,codeListName,elementName,codeListName,elementName,codeListPath)
                    schematronFhandle.write(rule)

        schFooter = '\n</schema>'
        schematronFhandle.write(schFooter)
        print 'Wrote Schematron rules to %s' % schematronFile

def parseCodeListName(codeListHttpPath):
    # Get a QName-safe name like 'd020089' from 'http://codes.wmo.int/bufr4/codeflag/0-20-089'
    return 'd'+os.path.basename(codeListHttpPath).split('.')[-1].replace('-', '')

def parseLocalCodeListFile(outputDir,codeListHttpPath):
    filename = codeListHttpPath.replace('http://', '').replace('/','-')  # remove slashes and 'http://'
    return join(outputDir, '%s.rdf' % filename)

if __name__ == '__main__':
    main()