<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ==================================================================== -->
  <!-- ==================================================================== -->
  <!--                           BEDEWORK LUWAK                             -->
  <!-- ==================================================================== -->
  <!-- ==================================================================== -->
  <xsl:output method="text" indent="yes" media-type="text/text" standalone="yes"/>
  <xsl:variable name="appRoot" select="/bedeworkconfig/appRoot"/>
  <xsl:variable name="urlPrefix" select="/bedeworkconfig/urlPrefix"/>

  <xsl:template match="/">
    <xsl:for-each select="/bedeworkconfig/propertyGroups/propertyGroup">
#
# <xsl:value-of select="@name"/>
#
<xsl:for-each select="property">
<xsl:value-of select="@name"/>=<xsl:value-of select="."/><xsl:text>
</xsl:text>
</xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>




