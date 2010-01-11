<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== THEME UTILITIES ====-->

  <!-- look for existence of ongoing events as appropriate -->
  <xsl:variable name="ongoingEvents">
    <xsl:choose>
      <xsl:when test="$ongoingEventsEnabled = 'true' and
                      /bedework/page = 'eventscalendar' and
                      /bedework/periodname != 'Year'">
        <xsl:choose>
          <xsl:when test="$ongoingEventsAlwaysDisplayed = 'true'">true</xsl:when>
          <xsl:when test="$ongoingEventsUseCategory = 'true' and
                          /bedework/eventscalendar//event/categories//category/uid = $ongoingEventsCatUid">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- look for existence of deadlines -->
  <!--
  <xsl:variable name="deadlines">
    <xsl:choose>
      <xsl:when test="$deadlinesEnabled = 'true' and
                      /bedework/page = 'eventscalendar' and
                      /bedework/periodname != 'Year'">
        <xsl:choose>
          <xsl:when test="$deadlinesAlwaysDisplayed = 'true'">true</xsl:when>
          <xsl:when test="/bedework/eventscalendar//event/entityType = 2">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  -->

</xsl:stylesheet>
