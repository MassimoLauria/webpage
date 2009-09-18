<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns="http://www.w3.org/1999/xhtml">
                              
<!-- ************ PAGE TEMPLATES *********************** -->

<xsl:template match="page/title">
</xsl:template>

<xsl:template match="page">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="page_title">
    <h1 class="page_title"><xsl:apply-templates /></h1>
</xsl:template>

<xsl:template match="entry">
    <div class="entry">
        <xsl:apply-templates />
    </div>
</xsl:template>

<xsl:template match="entry_title">
    <h2 class="entry_title"><xsl:apply-templates /></h2>
</xsl:template>

</xsl:stylesheet>
