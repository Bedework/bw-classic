<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="featuredEvents">
    <xsl:if test="$featuredEventsAlwaysOn = 'true' or
                 ($featuredEventsForEventDisplay = 'true' and /bedework/page = 'event') or
                 ($featuredEventsForCalList = 'true' and /bedework/page = 'calendarList') or
                 (/bedework/page = 'eventscalendar' and (
                   ($featuredEventsForDay = 'true' and /bedework/periodname = 'Day') or
                   ($featuredEventsForWeek = 'true' and /bedework/periodname = 'Week') or
                   ($featuredEventsForMonth = 'true' and /bedework/periodname = 'Month') or
                   ($featuredEventsForYear = 'true' and /bedework/periodname = 'Year')))">
      <div id="feature">
        <!-- pulls in the first three images from the FeaturedEvent.xml document -->
        <xsl:apply-templates select="document('../../themes/bedeworkTheme/featured/FeaturedEvent.xml')/featuredEvents/image[position() &lt; 4]" mode="featuredEvents" />
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image" mode="featuredEvents">
    <xsl:choose>
      <xsl:when test="link = ''">
        <img width="241" height="189">
          <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/featured/<xsl:value-of select="name"/></xsl:attribute>
          <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
          <img width="241" height="189">
            <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/featured/<xsl:value-of select="name"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
          </img>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
