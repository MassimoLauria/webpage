<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">

<!-- ************** XHTML RETAG ************************ --> 

<xsl:template match="a|br|div|em|img|p|pre|span|strong|sub|sup|tt|li|ul|ol|h1|h2|h3|h4|h5|h6">
	<xsl:element name="{name()}">
	<xsl:for-each select="@*">
		<xsl:if test="not(normalize-space(.) = '')">
			<xsl:attribute name="{name()}"><xsl:value-of
select="." disable-output-escaping="yes" /></xsl:attribute>
		</xsl:if>
	</xsl:for-each>
	<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
