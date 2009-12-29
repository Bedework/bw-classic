<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <div id="eventList">
      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
          <p class="noEvents">No events to display.</p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[count(event)!=0]">

            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <h3>
                <xsl:attribute name="id">dayMarker-<xsl:value-of select="date"/></xsl:attribute>
                <xsl:attribute name="onclick">gotourl(this,'<xsl:value-of select="$setViewPeriod"/>&amp;viewType=dayView&amp;date=<xsl:value-of select="date"/>')</xsl:attribute>
                <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
              </h3>
            </xsl:if>

            <ul>
              <xsl:for-each select="event">
                <li>
                  <xsl:attribute name="id"><xsl:value-of select="guid"/></xsl:attribute>
                  <xsl:attribute name="onclick">gotourl(this,'<xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>')</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">
                      <xsl:attribute name="class">even</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">odd</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/>
                  <xsl:choose>
                    <xsl:when test="start/allday = 'true'">(all day)</xsl:when>
                    <xsl:otherwise> at <xsl:value-of select="start/time"/></xsl:otherwise>
                  </xsl:choose>
                  <br/>
                  <strong>
                    <xsl:if test="status='CANCELLED'">CANCELED: </xsl:if>
                    <xsl:value-of select="summary"/>
                  </strong>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
