<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== CALENDARS ====-->
  <!-- list of available calendars -->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount"
      select="count(calendar/calendar)" />

    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Cals-AllTopicalAreas"/></h3>
    </div>

    <ul class="calendarTree">
      <li>
        <a class="breadcrumb" href="/cal/">
          « Return to Main Calendar
        </a>
      </li>
      <xsl:apply-templates select="calendar/calendar"
        mode="calTree" />
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">
          folder
        </xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url" select="encodedPath" />
    <li class="{$itemClass}">
      <a href="{$setSelection}&amp;calUrl={$url}"
        title="view calendar">
        <xsl:value-of select="name" />
      </a>
      <xsl:if test="calendarCollection='true'">
        <xsl:variable name="calPath" select="path" />
        <span class="exportCalLink">
          <a
            href="{$calendar-fetchForExport}&amp;calPath={$calPath}"
            title="export calendar as iCal">
            <img
              src="{$resourcesRoot}/images/calIconExport-sm.gif"
              alt="export calendar" />
          </a>
        </span>
      </xsl:if>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar"
            mode="calTree" />
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <h2 class="bwStatusConfirmed">Export Calendar</h2>
    <div id="export">
      <p>
        <strong>Calendar to export:</strong>
      </p>
      <div class="indent">
        Name:
        <strong>
          <em>
            <xsl:value-of select="name" />
          </em>
        </strong>
        <br />
        Path:
        <xsl:value-of select="path" />
      </div>
      <p>
        <strong>Event date limits:</strong>
      </p>
      <form name="exportCalendarForm" id="exportCalendarForm"
        action="{$export}" method="post">
        <input type="hidden" name="calPath">
          <xsl:attribute name="value">
            <xsl:value-of select="path" />
          </xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year"
          value="" />
        <input type="hidden" name="eventStartDate.month"
          value="" />
        <input type="hidden" name="eventStartDate.day" value="" />
        <input type="hidden" name="eventEndDate.year" value="" />
        <input type="hidden" name="eventEndDate.month" value="" />
        <input type="hidden" name="eventEndDate.day" value="" />
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no" />
        <input type="hidden" name="skinName" value="ical" />
        <input type="hidden" name="contentType"
          value="text/calendar" />
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of
              select="name" />.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" name="dateLimits" value="active"
          checked="checked"
          onclick="changeClass('exportDateRange','invisible')" />
        today forward
        <input type="radio" name="dateLimits" value="none"
          onclick="changeClass('exportDateRange','invisible')" />
        all dates
        <input type="radio" name="dateLimits" value="limited"
          onclick="changeClass('exportDateRange','visible')" />
        date range
        <div id="exportDateRange" class="invisible">
          Start:
          <div dojoType="dropdowndatepicker"
            formatLength="medium" saveFormat="yyyyMMdd"
            id="bwExportCalendarWidgetStartDate">
            <xsl:text> </xsl:text>
          </div>
          Ends
          <div dojoType="dropdowndatepicker"
            formatLength="medium" saveFormat="yyyyMMdd"
            id="bwExportCalendarWidgetEndDate">
            <xsl:text> </xsl:text>
          </div>
        </div>
        <p>
          <input type="submit" value="export"
            class="bwWidgetSubmit" onclick="fillExportFields(this.form)" />
        </p>
      </form>
    </div>
  </xsl:template>

</xsl:stylesheet>
