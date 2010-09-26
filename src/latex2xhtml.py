#!/usr/bin/env python

import os
import tempfile
from   xml.dom import minidom


latex_preamble=u"""
\\documentclass{article}
\\usepackage{amsmath}
"""

begin_document=u"""
\\begin{document}
"""

end_document=u"""
\end{document}
"""

def latexfragment2xhtml(document, doc_id="tex4ht-doc-", latex_optional_preamble=""):
    """
    Puts a preamble on a fragment of LaTeX code, saves to a temporary
    files and produces the XHTML equivalent (or at least it tries).  
    """

    filename = "0xDEADBEEF"
    xmlcode  = u""
    
    # Produce a LaTeX file with the desired content 
    with tempfile.NamedTemporaryFile(mode="w", dir=".", prefix=doc_id, suffix=".tex", delete=False) as tmp:

        filename = tmp.name
       
        tmp.write(latex_preamble)
        tmp.write(latex_optional_preamble)

        tmp.write(begin_document)
        tmp.write(document)
        tmp.write(end_document)
        tmp.close()

        xmlcode = latexfile2xhtml(filename)
        os.remove(filename)
        
    return xmlcode



def latexfile2xhtml(filename):

    code=u""
    waste_files=["html","css","4ct","4tc","aux","dvi","idv","lg","log","tmp","xref"]

    # Works only on readable .tex files
    if (filename[-4:] != ".tex") or (not os.access(filename,os.R_OK )): return code
    

    name_pattern=os.path.basename(filename)[:-4]

    # Transforms LaTeX in XHTML with TeX4ht
    os.system("htlatex "+filename+" \" xhtml, mathml, charset=utf-8\"  \" -cunihtf -utf8\"  >/dev/null ")

    # Extract the relevant part from the XHTML code
    try:
        with open(name_pattern+".html", mode='r') as xhtmlfile:
            xmldoc=minidom.parse(xhtmlfile)
            body=xmldoc.getElementsByTagName("body")[0]

            data=body.firstChild

            while data:
                code+=data.toprettyxml()
                data=data.nextSibling
    except IOError:
        code=u""
        
    # Clean up the huge mess.
    for ext in waste_files:
        os.remove(name_pattern+"."+ext)

    return code
