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
# lxml is used instead of ElementTree because it tracks parent relationships
from lxml import etree
import requests

def main():

    if len( sys.argv ) < 3:
        print "Usage: codeListsToSchematron.py [schema dir] [output dir]"
        sys.exit(1)

    schemaPath = sys.argv[1]
    outputDir = sys.argv[2]

    # create the directory if needed
    if not os.path.exists(outputDir):
        os.mkdir(outputDir)

    if not os.path.isdir(schemaPath) or not os.path.isdir(outputDir):
        print 'ERROR: %s and %s must be existing directories' % (schemaPath, outputDir)
        sys.exit(1)

    ns = {'xs': 'http://www.w3.org/2001/XMLSchema'}
    sn = {}
    # insert all values as keys as well so the lookups can go both ways
    for key, value in ns.iteritems():
        sn[value]=key
    ns.update(sn)

    xsdfiles = [join(schemaPath,f) for f in os.listdir(schemaPath) if f.endswith(".xsd") and isfile(join(schemaPath, f))]

    schematronFile = join(outputDir,'codelists.sch')

    # remove *.rdf and *.sch before we begin so there aren't any old files
    for rdfFile in os.listdir(outputDir):
        if rdfFile.endswith(".rdf") or rdfFile.endswith(".sch"):
            os.remove(join(outputDir, rdfFile))

    with open(schematronFile, 'w') as schematronFhandle:

        schHeader = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:ns prefix="iwxxm" uri="http://icao.int/iwxxm/2.1"/>
  <sch:ns prefix="sf" uri="http://www.opengis.net/sampling/2.0"/>
  <sch:ns prefix="sams" uri="http://www.opengis.net/samplingSpatial/2.0"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <sch:ns prefix="om" uri="http://www.opengis.net/om/2.0"/>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
  <sch:ns prefix="aixm" uri="http://www.aixm.aero/schema/5.1.1"/>
  <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="reg" uri="http://purl.org/linked-data/registry#"/>'''

        schematronFhandle.write(schHeader)

        # dictionary mapping from XSD Type names such as 'AerodromeRecentWeatherType' to the path on codes.wmo.int such as 'http://codes.wmo.int/49-2/AerodromeRecentWeather'
        typeToCodeList={}

        # first go through the XSD files and find all types with a vocabulary/codelist
        # we walk through the XSD files twice because XSD Types are imported and used in other XSD files which means
        # we need to search all files for elements corresponding to XSD Types
        for xsdFile in xsdfiles:
            print 'Parsing %s for vocabularies/code lists' % xsdFile
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
                    headers = {"Accept": "application/rdf+xml"}
                    print '\tDownloading %s in RDF format' % codeListPath

                    r = requests.get(codeListPath, headers=headers)
                    localCodeListFile=os.path.join(outputDir,parseLocalCodeListFile(codeListPath))
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
                localCodeListFile = parseLocalCodeListFile(codeListPath)
                letStr='''
  <sch:let name="%s" value="document('%s')" />''' % (codeListName,localCodeListFile)
                schematronFhandle.write(letStr)

        schematronFhandle.write('\n')

        # now search each XSD file for elements corresponding to our discovered XSD Types and write out appropriate
        # Schematron rules
        print 'Searching %s for elements matching the discovered code lists' % xsdFile
        for complexTypeName, codeListPath in typeToCodeList.iteritems():
            namespacedTypeName = 'iwxxm:%s' % complexTypeName
            elementsForType=findElementNamesForType(xsdfiles,namespacedTypeName,ns)
            # now find and iterate through elements that are of this type
            for element in elementsForType:
                elementName = element.attrib['name']
                context='iwxxm:'+elementName
                complexTypeParent=findParentNamed(element,'xs:complexType',ns)

                # the simplest context is of the form //iwxxm:phenomenon, i.e. the sub-element name alone.
                # This unfortunately creates conflicts when there is more than one element with the same name in the schemas,
                # and in this case all rules apply to all elements with that name which causes validation failures.
                # To address this issue we search for both parent name and sub-element name in the context, for example:
                #       //*[contains(name(),'AIRMET')]/iwxxm:phenomenon
                #
                # This rule is intentionally ambiguous about "containing" the parent element name rather than an exact
                # match, since there are cases where the rule should match all sub-types of the parent type (SIGMET,
                # VolcanicAshSIGMET, and TropicalCycloneSIGMET).  So far this has been an easy way to represent the
                # Schematron rules without reconstructing the full XSD type hierarchy, but this may become necessary later
                parentElemName=''
                if complexTypeParent is not None:
                    parentTypeName=complexTypeParent.attrib['name']
                    parentElems=findElementNamesForType(xsdfiles,'iwxxm:'+parentTypeName,ns)
                    if len(parentElems) == 1:
                        parentElem=parentElems[0]
                        parentElemName=parentElem.attrib['name']
                        context="*[contains(name(),'%s')]/%s" % (parentElemName,context)
                    else:
                        print 'Multiple elements found matching type %s (%d total). Behavior for this case is not yet implemented' % (parentTypeName,len(parentElems))

                print '\tFound element named "%s" of type "%s" with vocabulary "%s"' % (elementName, complexTypeName, codeListPath)
                codeListName = parseCodeListName(codeListPath)



                # Now create corresponding Schematron rules for each complexType and vocabulary
                rule = '''
  <sch:pattern id="%s-%s-test">
    <sch:rule context="//%s">
      <sch:assert test="@xlink:href = $%s/rdf:RDF/*/skos:member/*/@*[local-name()='about'] or @nilReason" >
        %s iwxxm:%s elements should be a member of %s
      </sch:assert>
    </sch:rule>
  </sch:pattern>''' % (elementName, codeListName, context, codeListName, parentElemName, elementName, codeListPath)
                schematronFhandle.write(rule)

        schFooter = '\n</sch:schema>'
        schematronFhandle.write(schFooter)
        print 'Wrote Schematron rules to %s' % schematronFile

def findElementNamesForType(xsdFiles,namespacedTypeName,namespaceMap):
    '''
    Search every given XSD file for the elements corresponding to an XSD Type
    :param xsdFiles:
    :param namespacedTypeName: a string of the form 'namespace:elementName'
    :param namespaceMap: a map from namespace to prefix and vice versa
    :return:
    '''
    elements=[]
    for xsdFile in xsdFiles:
        tree = etree.parse(xsdFile)
        root = tree.getroot()
        # now find and iterate through elements that are of this type
        for element in root.findall(".//xs:element[@type='%s']" % (namespacedTypeName), namespaceMap):
            elements.append(element)

    return elements

def findParentNamed(element,namespacedParentElemName,nsMap):
    '''
    Find the first parent of the given element with a namespaced element name
    :param element:
    :param namespacedParentElemName: a string of the form 'namespace:elementName'
    :param nsMap: a map from namespace to prefix and vice versa
    :return:
    '''
    parent=element.getparent()
    if parent is None:
        return None
    elemName=lxmlToNormalNamespacedElemName(parent.tag,nsMap)
    if elemName == namespacedParentElemName:
        return parent
    return findParentNamed(parent,namespacedParentElemName,nsMap)

def lxmlToNormalNamespacedElemName(lxmlNamespacedName,nsMap):
    '''
    Change strings of the form ''{http://www.w3.org/2001/XMLSchema}complexType' to 'xs:complexType'
    :param lxmlNamespacedName:
    :param nsMap:
    :return:
    '''
    split=lxmlNamespacedName.split('}')
    nsName=split[0][1:]
    nsName=nsMap[nsName]
    return '%s:%s' % (nsName,split[1])

def parseCodeListName(codeListHttpPath):
    # Get a QName-safe name like 'd020089' from 'http://codes.wmo.int/bufr4/codeflag/0-20-089'
    return 'd'+os.path.basename(codeListHttpPath).split('.')[-1].replace('-', '')

def parseLocalCodeListFile(codeListHttpPath):
    filename = codeListHttpPath.replace('http://', '').replace('/','-')  # remove slashes and 'http://'
    return '%s.rdf' % filename

if __name__ == '__main__':
    main()