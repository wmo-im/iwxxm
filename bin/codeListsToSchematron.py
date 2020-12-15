#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Search all IWXXM schemas for vocabulary/codelist entries and download each entry in RDF format.
For use with iwxxm.sch which has schematron rules derived from the IWXXM UML model that ensure
a codelist element's xlink:href is a member of the corresponding codelist.

Written using Python 2.7
"""

import os
import sys
from os.path import isfile, join
# lxml is used instead of ElementTree because it tracks parent relationships
from lxml import etree
import requests

def main():

    if len( sys.argv ) < 3:
        print("Usage: codeListsToSchematron.py [schema dir] [output dir]")
        sys.exit(1)

    schemaPath = sys.argv[1]
    outputDir = sys.argv[2]
    run(schemaPath, outputDir)

def run(schemaPath, outputDir):
    # create the directory if needed
    if not os.path.exists(outputDir):
        os.mkdir(outputDir)

    if not os.path.isdir(schemaPath) or not os.path.isdir(outputDir):
        print('ERROR: %s and %s must be existing directories' % (schemaPath, outputDir))
        sys.exit(1)

    ns = {'xs': 'http://www.w3.org/2001/XMLSchema'}
    sn = {}
    # insert all values as keys as well so the lookups can go both ways
    for key, value in ns.items():
        sn[value]=key
    ns.update(sn)

    xsdfiles = [join(schemaPath,f) for f in os.listdir(schemaPath) if f.endswith(".xsd") and isfile(join(schemaPath, f))]

    # dictionary mapping from XSD Type names such as 'AerodromeRecentWeatherType' to the path on codes.wmo.int such as 'http://codes.wmo.int/49-2/AerodromeRecentWeather'
    typeToCodeList={}

    # first go through the XSD files and find all types with a vocabulary/codelist
    # we walk through the XSD files twice because XSD Types are imported and used in other XSD files which means
    # we need to search all files for elements corresponding to XSD Types
    for xsdFile in xsdfiles:
        print('Parsing %s for vocabularies/code lists' % xsdFile)
        tree = etree.parse(xsdFile)
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
                download_codelist(codeListPath, outputDir)
    # Also download http://codes.wmo.int/common/nil for nilReason instances, not referenced by an xsd
    # see https://github.com/wmo-im/iwxxm/issues/193
    download_codelist('http://codes.wmo.int/common/nil', outputDir)
    
def download_codelist(codeListPath, outputDir):
    '''Download the RDF representation of this vocabulary'''
    headers = {"Accept": "application/rdf+xml"}
    print('\tDownloading %s in RDF format' % codeListPath)

    r = requests.get(codeListPath, headers=headers)
    localCodeListFile=os.path.join(outputDir,parseLocalCodeListFile(codeListPath))
    if r.status_code == 200:
        with open(localCodeListFile, 'w') as fhandle:
            try:
                fhandle.write(r.text)
            except UnicodeEncodeError:
                fhandle.write(r.text.encode('utf-8'))
    else:
        print('ERROR: Could not load code list at %s!' % codeListPath)


def parseLocalCodeListFile(codeListHttpPath):
    filename = codeListHttpPath.replace('http://', '').replace('/','-')  # remove slashes and 'http://'
    return '%s.rdf' % filename

if __name__ == '__main__':
    main()
