<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml">

<!-- *********** NAVIGATION TEMPLATE ********************* -->
<xsl:template match="toc">
    <ul class="toc">
        <xsl:apply-templates />
    </ul>
</xsl:template>

<xsl:template match="toc/toc_title">
    <li class="toc_title"> <b> <xsl:apply-templates /> </b> </li>
</xsl:template>

<xsl:template match="toc/toc_link">
    <li class="toc_item">
        <a>
        <xsl:for-each select="@*">
            <xsl:if test="not(normalize-space(.) = '')">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates /> 
        </a>
    </li>
</xsl:template>

<xsl:template match="toc/toc_item">
    <li class="toc_item">
        <xsl:apply-templates />
    </li>
</xsl:template>

<xsl:template match="toc/toc_nil">
    <li class="toc_nil">
        <xsl:apply-templates />
    </li>
</xsl:template>


</xsl:stylesheet>
