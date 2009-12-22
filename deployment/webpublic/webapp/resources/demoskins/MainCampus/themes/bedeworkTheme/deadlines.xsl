<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="deadlines">
    <h3 class="secondaryColHeaderGray">
      <xsl:copy-of select="$bwStr-Deadline-Title"/>
    </h3>
    <ul class="eventList">
      <xsl:choose>
        <xsl:when test="/bedework/eventscalendar//event[entityType = 2]">
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day/event[entityType = 2]">
            <xsl:sort select="start/unformatted" order="ascending" data-type="number" />
            <xsl:sort select="id" data-type="number" />
            <xsl:variable name="lastId" select="id" />
            <xsl:if test="not(preceding::event[id=$lastId])">
              <xsl:call-template name="deadline" />
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li>
            <xsl:copy-of select="$bwStr-Deadline-NoEvents"/>
          </li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <xsl:template name="deadline">
    <li>
      <xsl:variable name="calPath" select="calendar/encodedPath" />
      <xsl:variable name="guid" select="guid" />
      <xsl:variable name="recurrenceId" select="recurrenceId" />
      <xsl:variable name="statusClass">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">
            bwStatusCancelled
          </xsl:when>
          <xsl:when test="status='TENTATIVE'">
            bwStatusTentative
          </xsl:when>
          <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
        <xsl:if test="status != 'CONFIRMED'">
          <xsl:value-of select="status" />
          <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:value-of select="summary" />
        <xsl:if test="summary = ''">
          <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
        </xsl:if>
      </a>, <xsl:copy-of select="$bwStr-SgEv-DueBy" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="end/shortdate" />
      <xsl:text> </xsl:text>
      <xsl:if test="start/allday = 'false'">
        <xsl:value-of select="end/time" />
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
