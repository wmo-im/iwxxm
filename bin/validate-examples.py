#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Utility for verifying that examples in IWXXM directories validate against the appropriate version of the IWXXM
schema and meet general guidelines for GML correctness, such as internally and externally resolvable xlink:hrefs.

The main() is intended for use in a Continuous Integration process and as such returns status codes.  Non-zero values
indicate validation failures.  The main() function reads an IWXXM directory from the LATEST_VERSION file to get the
latest version of IWXXM to validate against.

Written against Python 2.7
"""
import sys, os
import checkGMLFiles

def main():
    cwd = os.getcwd()
    if not os.path.isfile( os.path.join( cwd, 'README.md' ) ):
        print "This script must be run from the root directory of the repository, usually 'iwxxm', which contains README.md"
        sys.exit(1)

    # only validate the latest version and examples.  Older versions had a number of issues that have already been fixed
    # and there is little point in running tests against them
    with open('LATEST_VERSION') as fhandle:
        devVersion=fhandle.read().strip()

    # iwxxmDirs = [os.path.join(cwd, f) for f in os.listdir(cwd)
    #            if os.path.isdir(os.path.join(cwd, f)) and not f.startswith('1.') and os.path.isdir( os.path.join(os.path.join(cwd,f),'examples') )]
    iwxxmDirs = [os.path.join(cwd,devVersion)]
    returnCode=0
    for dir in iwxxmDirs:
        result = validate_dir(dir)
        if result > 0:
            print "========= Validation FAILED on %s =========" % dir
            returnCode = result
        else:
            print "========= Validation SUCCESSFUL on %s =========" % dir

    if returnCode != 0:
        sys.exit( returnCode )

def validate_dir(dir):
    catalogTemplate='catalog.template.xml'
    iwxxmDir=os.path.split(dir)[1]
    iwxxmVersion = iwxxmDir[:3]
    thisCatalogFile=catalogTemplate.replace('template',iwxxmDir)

    # replace ${IWXXM_VERSION} and ${IWXXM_VERSION_DIR} with appropriate values in the catalog.xml file
    with open( catalogTemplate ) as templateFhandle:
        with open( thisCatalogFile, 'w' ) as catalogFhandle:
            catalogText=templateFhandle.read()
            catalogText=catalogText.replace("${IWXXM_VERSION}", iwxxmDir)
            catalogText=catalogText.replace("${IWXXM_VERSION_DIR}", iwxxmDir)
            catalogFhandle.write(catalogText)

    print 'Validating %s against XML Schema and Schematron' % dir
    examplesDir = os.path.join(dir,'examples')
    validationResult = os.system( 'bin/crux-1.3-all.jar -c %s -s %s/rule/iwxxm.sch %s/*.xml' % (thisCatalogFile,dir,examplesDir) )
    if validationResult > 0:
        print 'FAILED validation.  Continuing...'
    else:
        print 'SUCCESSFUL validation'

    # remove the modified catalog file
    os.remove(thisCatalogFile)

    print 'CHECKING GML correctness on %s' % dir
    checkResult = checkGMLFiles.check_files(examplesDir)
    if checkResult > 0:
        print 'CHECKING GML correctness finished, some files are not correct!!!'
    else:
        print 'CHECKING GML correctness finished successfuly'

    # this can return status codes of 256, which is an undefined value sometimes interpreted as 0.  Force it to a valid value
    if validationResult != 0:
        validationResult = 1
    return validationResult | checkResult

if __name__ == '__main__':
    main()
