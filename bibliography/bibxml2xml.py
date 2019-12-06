#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from string import Formatter
from xml.dom import minidom

# Setup
CATEGORIES = [
    ('submitted', "Submitted (not yet peer reviewed)", []),
    ('conference', "Conference", []),
    ('journal', "Journal", []),
    ('manuscript', "Manuscripts (not peer reviewed)", []),
    ('thesis', "Thesis", []),
    ('others', "Misc", [])]

PRINT_EMPTY_CATEGORIES = False

SORTBY = "year"
AUTHOR_SEP = ', '
AUTHOR_LAST_SEP = ' and '
TAG_PREFIX = "bibxml:"


# FORMAT TEMPLATES
templates = {
    "article": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    In: {journal}. {volume}({number}):{pages}.<br />""",

    "inproceedings": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    In: {booktitle}. pp. {pages}.<br />""",

    "conference": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    In: {booktitle}. pp. {pages}.<br />""",

    "masterthesis": """
    <strong>Master thesis</strong> <br />
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    {school}.<br />""",

    "misc": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />""",

    "phdthesis": """
    <strong>Ph.D. thesis</strong> <br />
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    {school}.<br />""",

    "techreport": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />
    {institution}. Report {number} of {year}.<br />""",

    "unpublished": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />""",

    "backuptemplate": """
    <span class='bibtitle'>{title}</span> ({year}).<br />
    <span class='bibauthor'>{author}</span>.<br />"""}


# ############### SOURCE CODE STARTS HERE ######################
def author_list(entry):
    """
    Produces the string with the list of authors
    """
    buf = ''
    authors = [a.firstChild.data
               for a in entry.getElementsByTagName(TAG_PREFIX + "author")]
    for a in authors[:-2]:
        buf += a + AUTHOR_SEP
    for a in authors[-2:-1]:
        buf += authors[-2] + AUTHOR_LAST_SEP
    buf += authors[-1]
    return buf


def format_entry(entry):
    """
    Applies the appropriate formatting templates on an entry and
    output the XML string.
    """
    nodetype = [c.nodeName[7:]
                for c in entry.childNodes if c.nodeName[:7] == TAG_PREFIX][0]
    try:
        text = templates[nodetype]
    except KeyError:
        text = templates["backuptemplate"]

    # Find keyword contained in the template string.
    args = {fname for _, fname, _, _ in Formatter().parse(text) if fname}

    def get_value(tag):
        """
        Internal function.
        """
        if tag == "author":
            return author_list(entry)
        else:
            el = entry.getElementsByTagName(TAG_PREFIX + tag)
            if len(el) == 1:
                return "" + el[0].firstChild.data
            else:
                return "??????"

    subst = {a: get_value(a) for a in args}
    return text.format(**subst)


def format_bibhtml(xmldoc):
    """
    Extract the formatted XML (ready for the web) from the document
    """
    entries = xmldoc.getElementsByTagName(TAG_PREFIX + "entry")

    # Keywords triage
    for en in entries:
        entry_keys = [a.firstChild.data
                      for a in en.getElementsByTagName(TAG_PREFIX + "keywords")
                      ]
        for (k, _, l) in CATEGORIES:
            if k in entry_keys:
                l.append(en)
    # Entry formatting
    for (key, title, elist) in CATEGORIES:
        if not (PRINT_EMPTY_CATEGORIES or elist):
            continue
        print("<section>")
        print("<h2>" + title + "</h2>")
        for en in elist:
            eid = en.getAttribute("id")

            # {{{ Load abstract ------------------------------------------
            abstract_data = ""
            el = en.getElementsByTagName(TAG_PREFIX + "abstract_file")
            if len(el):
                abstract_data = read_abstract(el[0].firstChild.data)
            # }}} ---------------------------------------------------------

            # Print initial information
            print('<div class="bibentry">')
            print('<table style="border:0; width:100%;"'
                  ' cellspacing="3" cellpadding="0">')
            print("""
<tr>
<td class="biblinks" valign="top" align="left">
""")
            print("<span class=\"space\"><br/></span>")
            print(format_filelinks(en))
            print("</td>")
            print("<td class=\"bibinfo\" valign=\"baseline\" align=\"left\">")
            print(format_entry(en))
            print(format_note(en))
            print(format_errata(en))

            if len(abstract_data):
                print('<div class="abstract-button" id="button-{0}"'
                      ' onclick=\"toggleAbstract(\'{0}\');\">'.format(eid))
                print("Show Abstract")
                print("</div>")

            print("</td></tr></table>")

            if len(abstract_data):
                print("<div class=\"abstract\" id=\"abs-" + eid + "\" >")

                print("<div class=\"abstract-header\">")
                print("Abstract")
                print("</div>")

                print(abstract_data)
                print("</div>")

            print("</div>")

        print("</section>")


def read_abstract(filename):
    """
    Extract the content of a file and return it as a string
    """
    try:
        with open(filename, "r", encoding="utf-8") as texfile:
            return texfile.read()
    except IOError:
        return ''


def format_filelinks(entry):
    """
    Produces the table of links to files.
    """
    out = ''
    template = '<a href="{}"> <img src="images/{}" alt="[{}]" /> </a>\n'

    for (tag, img, text) in [("pdf", "pdf.png", "PDF"),
                             ("ee", "ee.png", "URL")]:
        el = entry.getElementsByTagName(TAG_PREFIX + tag)
        if len(el) != 1:
            continue
        out += template.format(el[0].firstChild.data, img, text)
    return out


def format_note(entry):
    """
    Outputs the annotation contained in the entry.
    """
    el = entry.getElementsByTagName(TAG_PREFIX + "note")
    if len(el) == 1:
        return el[0].firstChild.data + ".<br />"
    else:
        return ""


def format_errata(entry):
    """
    Outputs the errata contained in the entry.
    """
    el = entry.getElementsByTagName(TAG_PREFIX + "errata")
    if len(el) == 1:
        return "<b>Errata: </b>" + el[0].firstChild.data + ".<br />"
    else:
        return ""


# Main Program
if __name__ == "__main__":
    if len(sys.argv) < 1:
        print("Usage " + sys.argv[0] + " <bibxmlfile>")
    else:
        print("<div class=\"papers\">")
        bib = minidom.parse(sys.argv[1])
        format_bibhtml(bib)
        print("</div>")
