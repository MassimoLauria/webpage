<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">
                              
<!-- ************* FORMATTING TEMPLATES **************** -->
<xsl:template match="raw_xhtml">
    <xsl:value-of select="text()" disable-output-escaping="yes" />
</xsl:template>

<xsl:template match="javascript">
</xsl:template>


<xsl:template name="include" match="include">
    <xsl:variable name="incfile" select="document(@filename)"/>
    <xsl:apply-templates select="$incfile//papers"/>
</xsl:template>

</xsl:stylesheet>
