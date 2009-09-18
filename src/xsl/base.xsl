<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">

<!-- INCLUDE LIST -->
<xsl:include href="navigator.xsl"/>
<xsl:include href="page.xsl"     />
<xsl:include href="xhtmltag.xsl" />
<xsl:include href="xhtmltable.xsl" />
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
		<xsl:call-template name="load_meta_tags" />
		<xsl:call-template name="load_javascript" />
        <link rel="stylesheet" type="text/css" media="all" href="css/default.css" />
        <title><xsl:value-of select="./page/title" /></title>
        </head>
        
        <body>
          <div id="container">
           
            <!-- 2-Columns Layout with right menu "http://matthewjamestaylor.com/" --> 
            <div id="boxOuter">
              <div id="boxInner">
                <div id="content">
                  <xsl:apply-templates/>
                </div>
                <div id="navigator">
                  <xsl:apply-templates select="document('../navigator.xml')/*" />
                </div>     
              </div>
            </div>
           
            <div id="footer">
              <xsl:apply-templates select="document('../footer.xml')/*" />
            </div>
          
          </div>
        </body>
    </html>
    
</xsl:template>

<!-- Manage meta tags -->
<xsl:template name="load_meta_tags">
    <!-- Load meta tags, for page indexing -->
	<xsl:for-each select="page/meta">
        <meta>
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="content">
                <xsl:value-of select="@content"/>
            </xsl:attribute>
        </meta>
	</xsl:for-each>
    <!-- Load links tags, for special CSS -->
	<xsl:for-each select="page/link">
        <link>
            <xsl:attribute name="rel">
                <xsl:value-of select="@rel"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:attribute name="media">
                <xsl:value-of select="@media"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
        </link>
	</xsl:for-each>
</xsl:template>

<!-- Load Javascript snippets -->
<xsl:template name="load_javascript">
	<xsl:for-each select="page/javascript">
        <script type="text/javascript">
          <xsl:value-of select="text()" disable-output-escaping="yes" />
        </script>
	</xsl:for-each>
</xsl:template>



</xsl:stylesheet>
