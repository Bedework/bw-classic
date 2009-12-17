<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== THEME UTILITIES ====-->
  <xsl:template match="events" mode="ongoingEventsExist">
    <xsl:choose>

                            ($ongoingEventsUseCategory = 'true' and /bedework/eventscalendar//events[category/name = $ongoingEventsCatName]) or
                            ($ongoingEventsUseDayRange = 'true' and $
  </xsl:template>


</xsl:stylesheet>
