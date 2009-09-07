<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">

<!-- INCLUDE LIST -->
<xsl:include href="navigator.xsl"/>
<xsl:include href="page.xsl"     />
<xsl:include href="xhtmltag.xsl" />
<xsl:include href="alert.xsl"   />
<xsl:include href="special.xsl"  />


<xsl:output method="xml" 
            encoding="utf-8" 
            indent="yes"
            omit-xml-declaration="yes"
            doctype-public="-//W3C//DTD XHTML 1.1//EN"
            doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
            />

<xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
        
        <head>
        <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
        </head>
        
        <body>
                <xsl:apply-templates/>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>
