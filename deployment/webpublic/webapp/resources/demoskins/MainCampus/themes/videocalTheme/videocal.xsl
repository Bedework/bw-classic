<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" media-type="text/html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" standalone="yes"/>
  <!-- ======================= -->
  <!--  VIDEO FEED STYLESHEET  -->
  <!-- ======================= -->

  <!-- Run your browser full screen at 800 x 600 and feed this to video.
       There are better approaches to this, but it's an interesting example. -->


  <!-- **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits. -->

  <!-- DEFINE GLOBAL CONSTANTS -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>
  <xsl:variable name="prevDate" select="/bedework/previousdate"/>
  <xsl:variable name="nextDate" select="/bedework/nextdate"/>
  <xsl:variable name="curDate" select="/bedework/currentdate/date"/>

  <!-- URL of html resources (images, css, other html); by default this is
       set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot"/>/default/default/videocalTheme</xsl:variable>

  <!-- Duration of each slide in seconds; set this to your preference -->
  <xsl:variable name="slideDuration">10</xsl:variable>

  <!-- Number of consecutive days to iterate over; set this to your preference -->
  <xsl:variable name="dayCount">5</xsl:variable>

  <!-- Skin name -->
  <xsl:variable name="skinName">videocal</xsl:variable>

  <!-- Position of the current day to be displayed -->
  <xsl:variable name="day">
    <xsl:choose>
      <xsl:when test="/bedework/appvar[key='day']">
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='day']/value > $dayCount">1</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/bedework/appvar[key='day']/value"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Position of the next day (add 1)-->
  <xsl:variable name="nextDay" select="number($day)+1"/>

  <!-- Event count for the current day -->
  <xsl:variable name="eventCount" select="count(/bedework/eventscalendar/year/month/week/day[date=$curDate]/event)"/>

  <!-- Position of the current event being displayed -->
  <xsl:variable name="event">
    <xsl:choose>
      <xsl:when test="/bedework/appvar[key='event']">
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='event']/value > $eventCount">1</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/bedework/appvar[key='event']/value"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Position of the next event (add 1)-->
  <xsl:variable name="nextEvent" select="number($event)+1"/>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Event Calendar Video Feed</title>
        <link rel="stylesheet" href="{$resourcesRoot}/videocal.css"/>
        <meta name="robots" content="noindex,nofollow"/>
        <script language="JavaScript">
          function today() {
            var now = new Date();
            var today;
            today = now.getFullYear().toString();
            if (now.getMonth() &lt; 9) {
              today += "0";
            }
            today += (now.getMonth() + 1).toString();
            today += now.getDate().toString();
            return today;
          }
        </script>
        <xsl:choose>
          <xsl:when test="/bedework/periodname!='Day'">
            <!-- we're starting up on the wrong view; go to today and begin with the first event;
                 the title slide will display during this switch. -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/main/setViewPeriod.do?viewType=todayView&amp;setappvar=event(1)&amp;setappvar=day(1)&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:when>
          <xsl:when test="($nextDay > $dayCount) and ($nextEvent > $eventCount)">
            <!-- passed the last day, and all events have been displayed,
                 so start over: go to today, set day=1 and *event=0* to allow
                 for the title slide "calPlug" -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/main/setViewPeriod.do?viewType=todayView&amp;setappvar=event(0)&amp;setappvar=day(1)&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:when>
          <xsl:when test="$nextEvent > $eventCount">
            <!-- passed the last event for the day; go to the next day and set event=1 -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/main/setViewPeriod.do?date={$nextDate}&amp;viewType=dayView&amp;setappvar=event(1)&amp;setappvar=day({$nextDay})&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, go to the next event on the same day -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/setup.do?viewType=dayView&amp;setappvar=event({$nextEvent})&amp;setappvar=day({$day})&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:otherwise>
        </xsl:choose>
      </head>
      <body>
        <xsl:choose>
          <xsl:when test="($eventCount = 0) or ($event = 0) or (/bedework/periodname!='Day')">
            <div id="calPlug">
              <h1>
                Bedework Calendar of Events
                Video Feed
              </h1>
              <h2>http://www.bedework.org</h2>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <h2 id="calTitle">
              BEDEWORK CALENDAR OF EVENTS
            </h2>
            <h2 id="dayTitle">
              <xsl:value-of select="/bedework/firstday/longdate"/><!--
              <br/>Events: <xsl:value-of select="$event"/> of <xsl:value-of select="$eventCount"/>
              <br/>Days: <xsl:value-of select="$day"/> of <xsl:value-of select="$dayCount"/> -->
            </h2>
            <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[date=$curDate]/event[position()=$event]"/>
          </xsl:otherwise>
        </xsl:choose>
        <!-- remove the following two divs if used for video -->
        <div id="getBack">
          (<a href="{$urlPrefix}/setup.do?skinNameSticky=default">restore normal calendar</a>)
        </div>
        <div id="info">
          This stylesheet will rotate through five days of events at ten
          second intervals.  It is intended as a video feed running full screen
          at 800x600px.  It's settings
          can be set from the top of
          the videocal.xsl stylesheet.
        </div>
      </body>
    </html>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <h1>
      <xsl:value-of select="summary"/>
    </h1>
    <xsl:if test="(start/allday = 'false')">
      <div id="time">
        <!-- this logic needs to be updated for new event model -->
        <xsl:choose>
          <xsl:when test="start/time=''">
            <xsl:value-of select="start/shortdate"/>
          </xsl:when>
          <xsl:when test="start/date != /bedework/firstday">
            <xsl:value-of select="start/shortdate"/>
            <xsl:value-of select="start/time"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="start/time"/>
          </xsl:otherwise>
        </xsl:choose>
        -
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="end/shortdate"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="end/time"/>
      </div>
    </xsl:if>
    <xsl:if test="location/address!='Campus-wide'">
      <div id="location">
        <xsl:value-of select="location/address"/>
      </div>
    </xsl:if>
    <div id="description">
      <xsl:value-of select="description"/>
    </div>
  </xsl:template>

</xsl:stylesheet>