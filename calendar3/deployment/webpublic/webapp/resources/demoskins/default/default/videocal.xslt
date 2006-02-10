<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" media-type="text/html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" standalone="yes"/>
  <!-- ================ -->
  <!--  DEFAULT STYLESHEET -->
  <!-- ================  -->
  <!-- DEFINE GLOBAL CONSTANTS -->
  <xsl:variable name="appRoot" select="/ucalendar/approot"/>
  <xsl:variable name="urlPrefix" select="/ucalendar/urlprefix"/>
  <xsl:variable name="prevDate" select="/ucalendar/previousdate"/>
  <xsl:variable name="nextDate" select="/ucalendar/nextdate"/>
  <xsl:variable name="curDate" select="/ucalendar/currentdate"/>
    
  <!-- Duration of each slide in seconds; set this to your preference -->
  <xsl:variable name="slideDuration">10</xsl:variable>
  
  <!-- Number of consecutive days to iterate over; set this to your preference --> 
  <xsl:variable name="dayCount">5</xsl:variable>
  
  <!-- Skin name --> 
  <xsl:variable name="skinName">videocal</xsl:variable>
  
  <!-- Position of the current day to be displayed -->
  <xsl:variable name="day">
    <xsl:choose>
      <xsl:when test="/ucalendar/appvar[key='day']">        
        <xsl:choose>
          <xsl:when test="/ucalendar/appvar[key='day']/value > $dayCount">1</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/ucalendar/appvar[key='day']/value"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Position of the next day (add 1)-->
  <xsl:variable name="nextDay" select="number($day)+1"/>
  
  <!-- Event count for the current day -->
  <xsl:variable name="eventCount" select="count(/ucalendar/eventscalendar/year/month/week/day[date=$curDate]/event)"/>
  
  <!-- Position of the current event being displayed -->
  <xsl:variable name="event">
    <xsl:choose>
      <xsl:when test="/ucalendar/appvar[key='event']">        
        <xsl:choose>
          <xsl:when test="/ucalendar/appvar[key='event']/value > $eventCount">1</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/ucalendar/appvar[key='event']/value"/>
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
        <title>Rensselaer Institutional Calendar of Events</title>
        <link rel="stylesheet" href="{$appRoot}/en_US/default/videocalLarger.css"/>
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
          <xsl:when test="/ucalendar/periodname!='Day'">
            <!-- we're starting up on the wrong view; go to today and begin with the first event;
                 the title slide will display during this switch. -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/setView.do?viewType=todayView&amp;setappvar=event(1)&amp;setappvar=day(1)&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:when>
          <xsl:when test="($nextDay > $dayCount) and ($nextEvent > $eventCount)">
            <!-- passed the last day, and all events have been displayed,
                 so start over: go to today, set day=1 and *event=0* to allow 
                 for the title slide "calPlug" -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/setView.do?viewType=todayView&amp;setappvar=event(0)&amp;setappvar=day(1)&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>          
          </xsl:when>
          <xsl:when test="$nextEvent > $eventCount">
            <!-- passed the last event for the day; go to the next day and set event=1 -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/setView.do?date={$nextDate}&amp;viewType=dayView&amp;setappvar=event(1)&amp;setappvar=day({$nextDay})&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, go to the next event on the same day -->
            <meta http-equiv="refresh" content="{$slideDuration};url={$urlPrefix}/setup.do?viewType=dayView&amp;setappvar=event({$nextEvent})&amp;setappvar=day({$day})&amp;skinNameSticky={$skinName}&amp;setappvar=summaryMode(details)"/>            
          </xsl:otherwise>
        </xsl:choose>
      </head>
      <body>
        <xsl:choose>
          <xsl:when test="($eventCount = 0) or ($event = 0) or (/ucalendar/periodname!='Day')">
            <div id="calPlug">
              <h1>
                Rensselaer Institutional<br/>
                Calendar of Events
              </h1>
              <h2>http://j2ee.rpi.edu/cal</h2>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <h2 id="calTitle">
              RENSSELAER'S INSTITUTIONAL CALENDAR OF EVENTS
            </h2>
            <h2 id="dayTitle">
              <xsl:value-of select="/ucalendar/firstday"/><!-- 
              <br/>Events: <xsl:value-of select="$event"/> of <xsl:value-of select="$eventCount"/>
              <br/>Days: <xsl:value-of select="$day"/> of <xsl:value-of select="$dayCount"/> -->
            </h2>    
            <xsl:apply-templates select="/ucalendar/eventscalendar/year/month/week/day[date=$curDate]/event[position()=$event]"/>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <h1>
      <xsl:value-of select="shortdesc"/>
    </h1>
    <xsl:if test="(start/time!='12:00 AM') and (end/time!='12:00 AM')">
      <div id="time">
        <xsl:choose>
          <xsl:when test="start/time=''">
            <xsl:value-of select="start/shortdate"/>
          </xsl:when>
          <xsl:when test="start/date!=/ucalendar/firstday">
            <xsl:value-of select="start/shortdate"/>
            <xsl:value-of select="start/time"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="start/time"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="end/time != '' or end/longdate != start/longdate"> - </xsl:if>
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="end/shortdate"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="end/time != ''">
          <xsl:value-of select="end/time"/>
        </xsl:if>
      </div>
    </xsl:if>
    <xsl:if test="location/address!='Campus-wide'">
      <div id="location">
        <xsl:value-of select="location/address"/>
      </div>
    </xsl:if>
    <div id="description">
      <xsl:value-of select="longdesc"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
