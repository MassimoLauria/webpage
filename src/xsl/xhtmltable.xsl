<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">

<!-- ************** XHTML TABLE TAGS RETAGGING********************* --> 

<xsl:template match="table|thead|tbody|tfoot|tr|td|th">
	<xsl:element name="{name()}">
	<xsl:for-each select="@*">
		<xsl:if test="not(normalize-space(.) = '')">
			<xsl:attribute name="{name()}"><xsl:value-of
select="."/></xsl:attribute>
		</xsl:if>
	</xsl:for-each>
	<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
