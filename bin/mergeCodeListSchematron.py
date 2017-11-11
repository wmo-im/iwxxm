#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Merge the Schematron and associated code list information into an existing IWXXM Schematron file.  This utility is used
to put the output of codeListsToSchematron.py at the end of the IWXXM structural Schematron content (typically iwxxm.sch)

If the Schematron content is already present in its entirety no action will be taken.  If the comment is found (indicating that
CodeList content was added in the past) but the output Schematron does not include the full CodeList Schematron
content then everything after the comment and before the end tag is replaced/updated.

Written using Python 2.7
"""

import os, sys, shutil

def main():

    if len( sys.argv ) < 3:
        print "Usage: mergeCodeListSchematron.py [input dir with Schematron and rdf files] [Schematron file to modify]"
        sys.exit(1)

    codeListDir = sys.argv[1]
    outputSchFile = sys.argv[2]

    if not os.path.isdir(codeListDir) or not os.path.isfile(outputSchFile):
        print 'ERROR: %s must be an existing directory and %s must be an existing file' % (codeListDir, outputSchFile)
        sys.exit(1)

    tmpFile = '%s.tmp' % outputSchFile

    inputCodeListSchFile = os.path.join(codeListDir,'codelists.sch')

    commentSeparator = '  <!-- Rules to enforce WMO Code List constraints are below this line -->'

    with open(inputCodeListSchFile, 'r') as inputCodeListSchFhandle:
        inputCodeListSchStr = inputCodeListSchFhandle.read()
        filteredStr=''
        for line in inputCodeListSchStr.splitlines(True):
            # get rid of all namespaces other than rdf, skos, and reg.  These three are used for RDF XPaths and are not
            # present in the stock IWXXM namespaces
            filteredNSLine='sch:ns' in line and 'rdf' not in line and 'skos' not in line and '\"reg\"' not in line
            if 'sch:schema' not in line and not filteredNSLine:
                filteredStr = filteredStr + line

        inputCodeListSchStr=filteredStr

    with open(outputSchFile, 'r') as outputSchFhandle:
        outputSchStr = outputSchFhandle.read()

    # if the content is already included (exactly) then take no action
    if inputCodeListSchStr in outputSchStr:
        print 'Code list Schematron content is already present in the output file.  No modifications were made'
        return

    with open(tmpFile, 'w') as tmpFhandle:

        # read line by line - we will either encounter the ending Schematron or an existing comment separator first
        # If we encounter the comment separator we need to update the existing content, which means ignoring all
        # existing Schematron down to the end tag

        updatingExistingCodeListSchematron=False
        for line in outputSchStr.splitlines(True):

            # we've encountered the comment but the content is not an exact match.  Ignore lines
            # until we reach the end tag, then write the comment and the CodeList SCH
            if commentSeparator in line:
                updatingExistingCodeListSchematron=True

            elif '</sch:schema>' in line:
                tmpFhandle.write(commentSeparator)
                tmpFhandle.write('\n')

                if updatingExistingCodeListSchematron:
                    tmpFhandle.write(inputCodeListSchStr)
                    print 'Updated existing CodeList Schematron rules in %s' % outputSchFile

                else:
                    tmpFhandle.write(inputCodeListSchStr)
                    print 'Wrote CodeList Schematron rules into %s' % outputSchFile

                tmpFhandle.write('\n')
                tmpFhandle.write(line)

            else:
                # write out each line unless we've previously passed the commentSeparator and are ignoring this content
                if not updatingExistingCodeListSchematron:
                    tmpFhandle.write(line)


    # move tmp file to original filename
    os.rename(tmpFile,outputSchFile)

    # now copy the RDF files into the same directory
    outdir=os.path.dirname(outputSchFile)
    rdffiles = [f for f in os.listdir(codeListDir) if f.endswith(".rdf") and os.path.isfile(os.path.join(codeListDir, f))]
    copiedRdfFiles=0
    for f in rdffiles:
        fromfile = os.path.join(codeListDir,f)
        tofile=os.path.join(outdir,f)
        shutil.copy(fromfile, tofile)
        copiedRdfFiles+=1

    print 'Copied %d RDF files into %s' % (copiedRdfFiles,outdir)

if __name__ == '__main__':
    main()