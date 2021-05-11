#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Script to check GML/XML files for mistakes, such as missing xlink references and invalid xlink:href syntax.

Written against Python 2.7
"""

import sys
if not hasattr(sys, "hexversion") or sys.hexversion < 0x020700f0:
    sys.stderr.write("Sorry, your Python is too old.\n")
    sys.stderr.write("Please upgrade at least to 2.7.\n")
    sys.exit(1)

import os
import os.path
import getopt
import re
try:
    import urllib.request as urlRequest
except ImportError:
    import urllib2 as urlRequest

def print_usage():
    print("Usage: checkGMLFiles.py <dir_with_xml_files>")
    print("Options:")
    print("   -h | --help                       : Print usage and exit")
    print(" ")
    return

def check_files(dir):
    '''
    Check all XML files in a given directory for GML correctness
    :return: 0 if the check was successful, non-zero otherwise
    '''
    xmlDocs = [ f for f in os.listdir(dir)
                if os.path.isfile(os.path.join(dir,f)) and f.endswith( '.xml' ) ]

    print("Found %d XML files in %s" % (len(xmlDocs), dir))

    gmlIdRE = re.compile(r"""( \s+(?P<attr_name>gml:id)=\"(?P<attr_value>.*?)\" )""", re.VERBOSE|re.DOTALL)
    xlinkHrefRE = re.compile(r"""( \s+(?P<attr_name>xlink:href)=\"(?P<attr_value>.*?)\" )""", re.VERBOSE|re.DOTALL)

    scriptDir=os.path.dirname(os.path.abspath(__file__))
    # xlink:hrefs that are ignored and for which HTTP resolution is not attempted
    ignoredXLinkUrlREs = readIgnoredXLinkPathRegExes(scriptDir+'/ignored-xlink-paths.txt')
    checkedXLinkTargets = {}

    returnCode=0

    for exampleFile in xmlDocs:
        exampleFile = dir+'/'+exampleFile
        exampleFile = exampleFile.replace( '//', '/' )
        print("Checking %s" % exampleFile)
        #read each line
        with open(exampleFile) as f:
            lines = f.readlines()
            gmlIds = {}

            # find all the gml:ids and put them into a dict
            for line in lines:
                m = gmlIdRE.search( line )
                if m:
                    gmlId = m.groupdict().get('attr_value')
                    gmlIds[gmlId] = gmlId


            # then look for xlink:hrefs and check them
            lineNum=0
            for line in lines:
                lineNum+=1
                m = xlinkHrefRE.search( line )
                if m:
                    xlinkTarget = m.groupdict().get('attr_value')
                    if not xlinkTarget.startswith( 'http' ):
                        if not xlinkTarget.startswith( '#' ):
                            print("\tERROR: line %d: xlink:href is not prefixed with a '#' sign" % (lineNum))
                            returnCode = 1

                        if not gmlIds.get(xlinkTarget[1:]):
                            print("\tERROR: line %d: xlink:href to '%s' does not refer to a valid gml:id" % (lineNum,xlinkTarget))
                            returnCode = 1

                    #check that HTTP paths resolve
                    else:
                        if checkedXLinkTargets.get(xlinkTarget) is None:
                            checked = True
                            # see if this XLink matches any of the ignore rules
                            for ignoredXLinkUrlRE in ignoredXLinkUrlREs:
                                if ignoredXLinkUrlRE.search( xlinkTarget ):
                                    print("\tIgnoring %s (matches the ignore list)" % xlinkTarget)
                                    checked = False

                            if checked:
                                print("\tRESOLVING xlink:href %s" % xlinkTarget)
                                response = urlRequest.urlopen(xlinkTarget)
                                code = response.getcode()
                                content = response.read().decode('UTF-8')
                                # a 2xx response code is acceptable
                                if( code < 200 or code >= 300 or "404" in content ):
                                    print("\tERROR: line %d: xlink:href to '%s' does not resolve to a valid URL" % (lineNum, xlinkTarget))
                                    returnCode = 1
                                else:
                                    print("\tSUCCESSFULLY resolved %s" % xlinkTarget)

                                checkedXLinkTargets[xlinkTarget] = xlinkTarget
                                response.close()

    return returnCode

def readIgnoredXLinkPathRegExes(filename):
    paths = []
    with open(filename) as f:
        for line in f.readlines():
            # ignore comment and blank lines
            if line.startswith('#') or not line.strip():
                continue
            ignoredRE = re.compile( line.strip(), re.VERBOSE | re.DOTALL)
            paths.append(ignoredRE)

    return paths

###############################################################
# Main program                                                #
###############################################################
if __name__ == "__main__":

    # Schema directory to find files created from UML, modified in place
    examplesDir = ''

    # Get the command line arguments.
    optlist, args = getopt.getopt(sys.argv[1:], 'h', [ 'help' ])

    opt_debug = 0

    for opt in optlist:
        if opt[0] == "-h" or opt[0] == "--help":
            print_usage()
            sys.exit(1)

    if( len( sys.argv ) < 2 ):
        print_usage()
        sys.exit(1)

    examplesDir = sys.argv[1]

    if(examplesDir == ''):
        print_usage()
        sys.exit()

    code = check_files(examplesDir)
    if code != 0:
        sys.exit(code)
