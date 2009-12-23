<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== CALENDARS ====-->
  <!-- list of available calendars -->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(calendar/calendar[calType != 5 and calType != 6 and name != 'calendar'])"/>

    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Cals-AllTopicalAreas"/></h3>
    </div>
    <p class="info">
      <xsl:copy-of select="$bwStr-Cals-SelectTopicalArea"/>
    </p>

    <!-- adjust the following calculations to get a balanced layout between the cells -->
    <div class="calendarList">
      <ul class="calendarTree">
        <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar') and (position() &lt;= ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
      </ul>
    </div>
    <div class="calendarList">
      <ul class="calendarTree">
        <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar') and (position() &gt; ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Calr-Folder"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-Calr-Calendar"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <li class="{$itemClass}">
      <xsl:variable name="calPath" select="path"/>
      <a href="{$setSelection}&amp;virtualPath={$virtualPath}&amp;setappvar=curCollection({$calPath})" title="view calendar"><xsl:value-of select="name"/></a>
      <xsl:variable name="calPath" select="path"/>
      <span class="exportCalLink">
        <a href="{$calendar-fetchForExport}&amp;calPath={$calPath}&amp;virtualPath={$virtualPath}" title="export calendar as iCal">
          <img src="{$resourcesRoot}/images/calIconExport-sm.gif" width="13" height="13" alt="export calendar" border="0"/>
        </a>
      </span>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Cals-ExportCals"/></h3>
    </div>
    <div id="export">
      <p>
        <xsl:copy-of select="$bwStr-Cals-CalendarToExport"/>
        <xsl:text> </xsl:text>
        <em><xsl:value-of select="name"/></em>
      </p>

      <form name="exportCalendarForm" id="exportCalendarForm" action="{$export}" method="post">
        <xsl:copy-of select="$bwStr-Cals-EventDateLimits"/><br/>
        <input type="hidden" name="calPath">
          <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year" value=""/>
        <input type="hidden" name="eventStartDate.month" value=""/>
        <input type="hidden" name="eventStartDate.day" value=""/>
        <input type="hidden" name="eventEndDate.year" value=""/>
        <input type="hidden" name="eventEndDate.month" value=""/>
        <input type="hidden" name="eventEndDate.day" value=""/>
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no"/>
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of select="name"/>.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-TodayForward"/>
        <input type="radio" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-AllDates"/>
        <input type="radio" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-DateRange"/>
        <div id="exportDateRange" class="invisible">
          <xsl:copy-of select="$bwStr-Cals-Start"/><xsl:text> </xsl:text>
          <input type="text" name="bwExportCalendarWidgetStartDate" id="bwExportCalendarWidgetStartDate" size="10"/>
          <span id="bwExportEndField"><xsl:copy-of select="$bwStr-Cals-End"/><xsl:text> </xsl:text>
          <input type="text" name="bwExportCalendarWidgetEndDate" id="bwExportCalendarWidgetEndDate" size="10"/></span>
        </div>
        <input type="submit" value="{$bwStr-Cals-Export}" class="bwWidgetSubmit" onclick="fillExportFields(this.form)"/>
      </form>
    </div>
  </xsl:template>

</xsl:stylesheet>