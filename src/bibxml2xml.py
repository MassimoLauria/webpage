#!/usr/bin/env python
# Setup
CATEGORIES=[ 
    (u'journal' , "Journal",[]),
    (u'conference' , "Conference",[]),
    (u'manuscript', "Manuscripts",[]),
    (u'thesis' , "Thesis",[]),
    (u'others' , "Misc",[])
]

PRINT_EMPTY_CATEGORIES=False

SORTBY=u"year"
AUTHOR_SEP=u', '
AUTHOR_LAST_SEP=u' and '
TAG_PREFIX=u"bibxml:"

#FORMAT TEMPLATES
templates={

"article": ("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />
In: %s. %s(%s):%s.<br />""",
("title","year","author","journal","volume","number","pages")),

"inproceedings": ("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />
In: %s. pp. %s.<br />""",
("title","year","author","booktitle","pages")),

"masterthesis":("""
<strong>Master thesis</strong> <br />
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />
%s.<br />""",
("title","year","author","school")),

"misc": ("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />""",
("title","year","year")),

"phdthesis":("""
<strong>Ph.D. thesis</strong> <br />
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />
%s.<br />""",
("title","year","author","school")),

"techreport":("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />
%s. Report %s of %s.<br />""",
("title","year","author","institution","number","year")),

"unpublished": ("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />""",
("title","year","author")),

"backuptemplate": ("""
<span class='bibtitle'>%s</span> (%s).<br />
<span class='bibauthor'>%s</span>.<br />""",
("title","year","author")) }


################ SOURCE CODE STARTS HERE ######################
import sys
from xml.dom import minidom

from latex2xhtml import latexfile2xhtml,latexfragment2xhtml


def author_list(entry):
    buf=u''
    authors= [a.firstChild.data for a in entry.getElementsByTagName(TAG_PREFIX+"author")]
    for a in authors[:-2]:
        buf+= a + AUTHOR_SEP
    for a in authors[-2:-1]:
       buf+=authors[-2]+AUTHOR_LAST_SEP
    buf+=authors[-1]
    return buf

def format_entry(entry):
    nodetype=[ c.nodeName[7:] for c in entry.childNodes if c.nodeName[:7] == TAG_PREFIX][0]    
    try:
        (text,args) = templates[nodetype]
    except KeyError:
        (text,args) = templates["backuptemplate"]
    def get_value(tag):
        if tag=="author":
            return author_list(entry)
        else:
            el=entry.getElementsByTagName(TAG_PREFIX+tag)
            if len(el) == 1: return el[0].firstChild.data
            else: return "??????"
    return text % tuple(map(get_value,args))
    

def format_bibxml(xmldoc):
    entries=bib.getElementsByTagName(TAG_PREFIX+"entry");
   
    # Keywords triage
    for en in entries:
        entry_keys=[a.firstChild.data for a in en.getElementsByTagName(TAG_PREFIX+"keywords")]
        for (k,t,l) in CATEGORIES:
            if k in entry_keys: 
                l.append(en)
    # Entry formatting
    for (key,title,elist) in CATEGORIES:
        if not (PRINT_EMPTY_CATEGORIES or elist): continue 
        print "<entry>"
        print "<entry_title><a id=\""+key+"\"/>"+title+"</entry_title>"
        for en in elist:
            eid=en.getAttribute("id")
            # Print information
            print "<div class=\"bibentry\" onclick=\"toggleAbstract('"+eid+"');\">"
            print "<table style=\"border:0; width:100%;\" cellspacing=\"3\" cellpadding=\"0\">"
            print """
<tr>
<td class="biblinks" valign="top" align="left">
"""
            print "<span class=\"space\"><br/></span>"            
            print format_filelinks(en)
            print "</td>"
            print "<td class=\"bibinfo\" valign=\"baseline\" align=\"left\">"
            print format_entry(en)
            print format_note(en)
            print "</td></tr></table>"
            print "</div>"

            # {{{ Load abstract ------------------------------------------
            abstract_data=u""
            
            # From formatted LaTeX file (1)
            el=en.getElementsByTagName(TAG_PREFIX+"abstract_file")
            if len(el):
                abstract_data=latexfile2xhtml(el[0].firstChild.data)

            # From LaTex fragment (2)    
            el=en.getElementsByTagName(TAG_PREFIX+"abstract_fragment")
            if len(abstract_data)==0 and len(el):
                try:
                    fragment=open(el[0].firstChild.data, mode='r')
                    abstract_data=latexfragment2xhtml("\\abstract{"+ fragment.read() + "}",doc_id=eid+"-")
                except IOError:
                    abstract_data=u""

            # From LaTex fragment embedded in bibliography (3)    
            el=en.getElementsByTagName(TAG_PREFIX+"abstract_text")
            if len(abstract_data)==0 and len(el):
                abstract_data=latexfragment2xhtml("\\abstract{"+ el[0].firstChild.data + "}",doc_id=eid+"-")
                
            if len(abstract_data):
                print "<div class=\"box tex4ht\" id=\"abs-"+eid+"\">"
                print abstract_data.encode("utf8")
                print "</div>"
            # }}} ---------------------------------------------------------
        print "</entry>"

        
def format_filelinks(entry):
    out=""
    for (tag,img,text) in [
         ("url","ps.png","PS"),
         ("urlzip","ps_gz.png","PS.GZ"),
         ("pdf","pdf.png","PDF"),
         ("ee","ee.png","Online")
        ]:
        el=entry.getElementsByTagName(TAG_PREFIX+tag)
        if len(el) != 1: continue
        en = el[0]
        out += "<a href=\"" + en.firstChild.data +"\">"
        out += "<img src=\"images/"+img+"\" alt=\"Download Article ("+text+")\" style=\"border:0;\"/>"
        out += "</a>\n"
    return out

        
def format_note(entry):
    el=entry.getElementsByTagName(TAG_PREFIX+"note")
    if len(el) == 1: return el[0].firstChild.data+"<br />"
    else: return ""



# Main Program
if __name__ == "__main__":
    if len(sys.argv)<1:
        print "Usage "+sys.argv[0]+" <bibxmlfile>"
    else:
        print "<papers>"
        bib=minidom.parse(sys.argv[1])
        format_bibxml(bib)
        print "</papers>"
