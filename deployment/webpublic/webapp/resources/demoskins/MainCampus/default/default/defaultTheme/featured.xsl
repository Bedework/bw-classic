<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="image" mode="featuredEvents">
    <xsl:choose>
      <xsl:when test="link = ''">
        <img width="241" height="189">
          <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/data/<xsl:value-of select="name"/></xsl:attribute>
          <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
          <img width="241" height="189">
            <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/data/<xsl:value-of select="name"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
          </img>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
