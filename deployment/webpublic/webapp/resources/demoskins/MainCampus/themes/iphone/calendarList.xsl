<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== CALENDAR LIST ====-->
  <xsl:template match="calendars">
    <h1>All Calendars</h1>
    <p>Select a calendar from the list below to see only that calendar's events.</p>
    <p>
      <a class="linkBack" href="{$setup}"><xsl:copy-of select="$bwStr-HdBr-BackLink"/></a>
    </p>
    <ul class="calendarTree">
      <xsl:apply-templates select="calendar/calendar" mode="calTree"/>
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="url" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$setSelection}&amp;calUrl={$url}" title="view calendar"><xsl:value-of select="name"/></a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
