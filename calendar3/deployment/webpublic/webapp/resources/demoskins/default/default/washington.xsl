<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="html"
  indent="yes"
  media-type="text/html"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
  doctype-system="http://www.w3.org/TR/html4/loose.dtd"
  standalone="yes"
/>
  <!-- ======================================= -->
  <!--  WASHINGTON PUBLIC CALENDAR STYLESHEET  -->
  <!-- ======================================= -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="errors.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
  <xsl:variable name="resourcesRoot" select="/bedework/approot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/setSelection"/>
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/fetchPublicCalendars"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/setViewPeriod"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/addEventRef"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/showPage"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>-->

  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="calendarCount" select="count(/bedework/calendars/calendar)"/>
  <xsl:variable name="calAdminSite">http://localhost:8080/caladmin</xsl:variable>
  <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>
          UW Calendar
          <xsl:if test="/bedework/page='event'">
            - <xsl:value-of select="/bedework/event/summary"/>
          </xsl:if>
        </title>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/washington.css" />
      </head>
      <body>
        <xsl:call-template name="header"/>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='calendars'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/bedework/calendars"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <xsl:call-template name="dayWeekMonthLayout"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                <xsl:call-template name="dayWeekMonthLayout"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:call-template name="dayWeekMonthLayout"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="yearView"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==== HEADER ====-->
  <xsl:template name="header">
    <table id="header-table" cellspacing="0" width="100%" cellpadding="0">
      <tr>
        <td id="logo-cell" width="10%">
          <img src="{$resourcesRoot}/images/washington/callogo2.gif" height="54" width="90" id="logo-image" alt="UW Calendar Logo"/>
        </td>
        <td id="rightheader-cell" width="90%">

          <table id="rightheader-table" cellspacing="0"
                 width="100%" cellpadding="0">
            <tr>
              <td colspan="3" class="header-links">

                <span class="aux">
                  <a href="{$resourcesRoot}/info/about.html">About UW Calendar</a> |
                  <a href="{$resourcesRoot}/info/eventindex.html">Help</a>
                </span>
              </td>
            </tr>
            <tr>
              <td id="date-header-cell">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td id="prev-cell">
                      <xsl:variable name="prevdate" select="/bedework/previousdate"/>
                      <a href="{$setViewPeriod}?date={$prevdate}"><img src="{$resourcesRoot}/images/washington/arrowL.gif" height="19" width="30" border="0" id="prev-image" alt="Previous"/></a>
                    </td>
                    <td id="date-header-text-cell">&#160;&#160;
                      <a href="{$setViewPeriod}?date={$curdate}">
                      <xsl:choose>
                        <xsl:when test="/bedework/periodname='Day'">
                          <xsl:value-of select="/bedework/currentdate/longdate"/>
                        </xsl:when>
                        <xsl:when test="/bedework/periodname='Week'">
                          Week of <xsl:value-of select="/bedework/currentdate/monthname"/>&#160;<xsl:value-of select="/bedework/currentdate/dayofmonth"/>, <xsl:value-of select="/bedework/currentdate/year"/>
                        </xsl:when>
                        <xsl:when test="/bedework/periodname='Month'">
                          <xsl:value-of select="/bedework/currentdate/monthname"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="substring(/bedework/currentdate/date,1,4)"/>
                        </xsl:when>
                        <xsl:when test="/bedework/periodname='Year'">
                          <xsl:value-of select="substring(/bedework/currentdate/date,1,4)"/>
                        </xsl:when>
                      </xsl:choose>
                     </a>&#160;&#160;
                    </td>
                    <td id="next-cell">
                      <xsl:variable name="nextdate" select="/bedework/nextdate"/>
                      <a href="{$setViewPeriod}?date={$nextdate}"><img src="{$resourcesRoot}/images/washington/arrowR.gif" height="19" width="30" border="0" id="next-image" alt="Next"/></a>
                    </td>
                  </tr>
                </table>
              </td>
              <td id="goto-cell">
                <form name="calForm" method="post" action="{$setViewPeriod}">
                  <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td>
                        <select name="viewStartDate.month">
                          <xsl:for-each select="/bedework/monthvalues/val">
                            <xsl:variable name="temp" select="."/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:choose>
                              <xsl:when test="/bedework/monthvalues[start=$temp]">
                                <option value="{$temp}" selected="selected">
                                  <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                                </option>
                              </xsl:when>
                              <xsl:otherwise>
                                <option value="{$temp}">
                                  <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                                </option>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </select>
                      </td>
                      <td>
                        <select name="viewStartDate.day">
                          <xsl:for-each select="/bedework/dayvalues/val">
                            <xsl:variable name="temp" select="."/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:choose>
                              <xsl:when test="/bedework/dayvalues[start=$temp]">
                                <option value="{$temp}" selected="selected">
                                  <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                                </option>
                              </xsl:when>
                              <xsl:otherwise>
                                <option value="{$temp}">
                                  <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                                </option>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </select>
                      </td>
                      <td>
                        <xsl:variable name="temp" select="/bedework/yearvalues/start"/>
                        <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                      </td>
                      <td>
                         <input type="hidden" name="viewType" value="dayView"/>
                         <input name="submit" type="SUBMIT" value="Go"/>
                      </td>
                    </tr>
                  </table>
                </form>
              </td>
              <td id="navbutton-cell" width="10%">
                <table id="navbutton-table" cellspacing="0" width="100%" border="1" cellpadding="1">
                  <tr id="navbutton-row">
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname='Day' and
                                     (/bedework/currentdate/date = /bedework/now/date)">
                        <td class="navbutton-on">
                          <a href="{$setViewPeriod}?viewType=todayView&amp;date={$curdate}" class="button-on">Today</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setViewPeriod}?viewType=todayView&amp;date={$curdate}" class="button-off">Today</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname='Day'">
                        <td class="navbutton-on">
                          <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}" class="button-on">Day</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}" class="button-off">Day</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                        <td class="navbutton-on">
                          <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}" class="button-on">Week</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}" class="button-off">Week</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname='Month'">
                        <td class="navbutton-on">
                          <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}" class="button-on">Month</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}" class="button-off">Month</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname='Year'">
                        <td class="navbutton-on">
                          <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}" class="button-on">Year</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}" class="button-off">Year</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td colspan="3" class="header-links">
                <span class="aux">
                  <a href="{$calAdminSite}">Submit Public Event</a>
                </span>
              </td>
            </tr>
            <xsl:if test="/bedework/periodname!='Year' and /bedework/page!='event' and /bedework/page!='calendars'">
              <tr>
                <td id="status-cell" colspan="3">
                  <table id="status-table" cellspacing="0">
                    <tr>
                      <td id="status">
                        <xsl:for-each select="/bedework/error">
                          <xsl:apply-templates select="."/><br/>
                        </xsl:for-each>
                        <xsl:text> </xsl:text>
                        <xsl:choose>
                          <xsl:when test="/bedework/title!=''">
                            Calendar: <xsl:value-of select="/bedework/title"/>
                            <span class="link">[<a href="{$selectView}?calId=">show all calendars</a>]</span>
                          </xsl:when>
                          <xsl:when test="/bedework/search!=''">
                            Current filter: <xsl:value-of select="/bedework/search"/>
                            <span class="link">[<a href="{$selectView}?calId=">clear</a>]</span>
                          </xsl:when>
                          <xsl:otherwise>
                            No filter (showing all events)
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </xsl:if>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--==== MAIN CALENDAR BODY (Day, Week, Month views) ====-->
  <xsl:template name="dayWeekMonthLayout">
    <table id="body-table" cellspacing="2" width="100%" cellpadding="0">
      <tr>
        <td id="eventlist-cell" width="65%">
          <table id="eventlist-table" cellspacing="2" width="100%" cellpadding="1">
            <thead>
              <tr>
                <th id="day-header" colspan="1">
                  Public Events for
                  <xsl:value-of select="/bedework/firstday/longdate"/>
                  <xsl:if test="/bedework[periodname!='Day']">
                    -
                    <xsl:value-of select="/bedework/lastday/longdate"/>
                  </xsl:if>
                </th>
              </tr>
            </thead>
            <xsl:choose>
              <xsl:when test="count(/bedework/eventscalendar/year/month/week/day/event)=0">
                <tr>
                  <td class="eventlist-desc">
                    No events this time period
                  </td>
                </tr>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework[periodname!='Day']">
                    <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[count(event)!=0]" mode="weekMonthListing"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[count(event)!=0]" mode="dayListing"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </table>
        </td>
        <td id="rightbody-cell" width="35%">

          <table id="entryform-table" cellspacing="0" width="100%" border="0" cellpadding="0">
            <tr>
              <td colspan="2" class="form-header">
                Filter Events
              </td>
            </tr>
            <tr>
              <td align="left">
                <table cellspacing="0" width="100%" class="form-element" border="1" cellpadding="0">
                  <tr>
                    <td align="left">
                      <span class="std-text">Show only events that contain this text:
                      </span>&#160;
                      <form name="searchForm" method="get" action="{$selectView}">
                        <input type="text" name="searchString" size="30" value=""/>
                        <input type="submit" value="Go"/>
                      </form>
                    </td>
                  </tr>
                </table>

              </td>
            </tr>
            <tr>
              <td align="left">
                <table cellspacing="0" width="100%" class="form-element" border="0" cellpadding="0">
                  <tr>
                    <td colspan="2" class="spacer-header">
                      &#160;
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td align="left">
                <table cellspacing="0" width="100%" class="form-element" border="1" cellpadding="0">
                  <tr>
                    <td colspan="2">
                      <table class="form-element">
                        <tr>
                          <td colspan="2" class="location-header">
                            Main Calendars
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <span class="std-text">Choose one of the main calendars:</span>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">&#160;
                          </td>
                        </tr>
                        <tr>
                          <td align="left">
                            <xsl:apply-templates select="/bedework/calendars/calendar[position() &lt;= ceiling($calendarCount div 2)]" mode="sideList"/>
                          </td>
                          <td align="left">
                            <xsl:apply-templates select="/bedework/calendars/calendar[position() &gt; ceiling($calendarCount div 2)]" mode="sideList"/>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">&#160;
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <div class="std-text">
                              <a href="{$selectView}">All Events</a>
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            &#160;
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2" align="center">
                            <a href="{$fetchPublicCalendars}">complete list of calendars</a>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td colspan="2" class="form-header">
                &#160;
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

   <!--==== EVENTS LISTING ====-->
  <xsl:template match="day" mode="weekMonthListing">
    <xsl:if test="date != /bedework/firstday/date">
      <tr>
        <td class="list-date-header">
          <xsl:variable name="date" select="date"/>
          <a href="{$setViewPeriod}?viewType=dayView&amp;date={$date}"><xsl:value-of select="longdate"/></a>
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="event">
      <xsl:variable name="id" select="id"/>
      <tr>
        <td class="list-cell">
          <span class="time">
            <xsl:choose>
              <xsl:when test="start/shortdate = end/shortdate">
                <xsl:value-of select="start/time"/>
                <xsl:if test="end/time!=''">
                  - <xsl:value-of select="end/time"/>
                </xsl:if>
                <xsl:if test="not (start/time='' and end/time='')">
                  <br/>
                </xsl:if>
              </xsl:when>
              <xsl:when test="start/shortdate = ../shortdate and start/time != ''">
                <xsl:value-of select="start/time"/> -
                <xsl:value-of select="end/dayname"/>, <xsl:value-of select="end/longdate"/><br/>
              </xsl:when>
              <xsl:when test="end/shortdate = ../shortdate and end/time != ''">
                <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/> -
                <xsl:value-of select="end/time"/><br/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/> -
                <xsl:value-of select="end/dayname"/>, <xsl:value-of select="end/longdate"/><br/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
          <span class="week-desc">

            <a href="{$privateCal}/addEventRef.do?eventId={$id}" title="Add to my UW Calendar" target="myCalendar">
              <img src="{$resourcesRoot}/images/washington/addref.gif" border="0" alt="Add to my UW Calendar"/>
            </a>&#160;
            <span class="day-item">
              <xsl:choose>
                <xsl:when test="link!=''">
                  <xsl:variable name="link" select="link"/>
                  <a href="{$link}">
                    <xsl:value-of select="summary"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="summary"/>
                </xsl:otherwise>
              </xsl:choose>
            </span>,
            <span class="day-item">
              <xsl:choose>
                <xsl:when test="location/link!=''">
                  <xsl:variable name="locationLink" select="location/link"/>
                  <a href="{$locationLink}">
                    <xsl:value-of select="location/address"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="location/address"/>
                </xsl:otherwise>
              </xsl:choose>
            </span>
          </span> &#160;
          <span class="aux">
            <span class="aux">
              <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">More</a> &#160;
            </span>
          </span>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="day" mode="dayListing">
    <tr>
      <td>
        <table border="0" width="100%" id="dayListingTable">
          <xsl:for-each select="event">
            <xsl:variable name="id" select="id"/>
            <xsl:variable name="timeStyle">
              <xsl:choose>
                <xsl:when test="start/shortdate = /bedework/currentdate/shortdate">
                  <xsl:choose>
                    <xsl:when test="contains(start/time,'AM')">eventlist-amtime</xsl:when>
                    <xsl:when test="contains(start/time,'PM')">eventlist-pmtime</xsl:when>
                    <xsl:otherwise>eventlist-notime</xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>eventlist-notime</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <tr>
              <td class="{$timeStyle}">
                <xsl:choose>
                  <xsl:when test="start/shortdate = end/shortdate">
                    <xsl:value-of select="start/time"/>
                    <xsl:if test="end/time!=''">
                      - <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="start/shortdate = ../shortdate and start/time != ''">
                    <xsl:value-of select="start/time"/> -
                    <xsl:value-of select="end/shortdate"/>
                  </xsl:when>
                  <xsl:when test="end/shortdate = ../shortdate and end/time != ''">
                    <xsl:value-of select="start/shortdate"/> -
                    <xsl:value-of select="end/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="start/shortdate"/> -
                    <xsl:value-of select="end/shortdate"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class='eventlist-desc'>

                <a href="{$privateCal}/addEventRef.do?eventId={$id}" title="Add to my UW Calendar" target="myCalendar">
                  <img src="{$resourcesRoot}/images/washington/addref.gif" border="0" alt="Add to my UW Calendar"/>
                </a>&#160;
                <xsl:choose>
                  <xsl:when test="link!=''">
                    <xsl:variable name="link" select="link"/>
                    <a href="{$link}">
                      <xsl:value-of select="summary"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="summary"/>
                  </xsl:otherwise>
                </xsl:choose>,
                <xsl:choose>
                  <xsl:when test="location/link!=''">
                    <xsl:variable name="locationLink" select="location/link"/>
                    <a href="{$locationLink}">
                      <xsl:value-of select="location/address"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="location/address"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class='eventlist-links'>
                 <span class='aux'><span class='aux'><a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">More</a> &#160;</span></span>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>

  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <table id="year-table" cellspacing='2' width='100%' cellpadding='3'>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &lt;= 4]">
          <xsl:with-param name="currentYear" select="/bedework/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 4) and (position() &lt;= 8)]">
          <xsl:with-param name="currentYear" select="/bedework/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &gt; 8]">
          <xsl:with-param name="currentYear" select="/bedework/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
    </table>
  </xsl:template>

  <!-- year view month tables -->
  <xsl:template match="month">
    <xsl:param name="currentYear">1900</xsl:param>
    <xsl:variable name="month-cell-style">
      <xsl:choose>
        <xsl:when test="(value = substring(/bedework/now/date,5,2)) and
                        ($currentYear = substring(/bedework/now/date,1,4))">current-month</xsl:when>
        <xsl:otherwise>month-cell</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <td class="{$month-cell-style}">
      <table cellspacing="1" width="100%" class="smallmonth-table" cellpadding="3">
        <tr>
          <td colspan="8" class="month-name-cell">
            <xsl:variable name="firstDayOfMonth" select="week/day/date"/>
            <a href="{$setViewPeriod}?viewType=monthView&amp;date={$firstDayOfMonth}" class="month">
              <xsl:value-of select="longname"/>
            </a>
          </td>
        </tr>
        <tr>
          <th class='day-of-week-cell'>&#160;</th>
          <th class='day-of-week-cell'>Su</th>
          <th class='day-of-week-cell'>Mo</th>
          <th class='day-of-week-cell'>Tu</th>
          <th class='day-of-week-cell'>We</th>
          <th class='day-of-week-cell'>Th</th>
          <th class='day-of-week-cell'>Fr</th>
          <th class='day-of-week-cell'>Sa</th>
        </tr>
        <xsl:for-each select="week">
          <tr>
            <td class="week-number-cell">
              <xsl:variable name="firstDayOfWeek" select="day/date"/>
              <a href="{$setViewPeriod}?viewType=weekView&amp;date={$firstDayOfWeek}" class="week-number">
                wk<xsl:value-of select="value"/>
              </a>
            </td>
            <xsl:for-each select="day">
              <xsl:choose>
                <xsl:when test="filler='true'">
                  <td class="filler">&#160;</td>
                </xsl:when>
                <xsl:otherwise>
                  <td>
                    <xsl:variable name="dayDate" select="date"/>
                    <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}" class="day">
                      <xsl:value-of select="value"/>
                    </a>
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </table>
    </td>
  </xsl:template>

  <!--==== CALENDARS PAGE ====-->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(/bedework/calendars/calendar)"/>
    <table id="calPageTable">
      <tr>
        <th colspan="2">
          Complete List of Calendars
        </th>
      </tr>
      <tr>
        <td class="leftCell">
          <xsl:apply-templates select="calendar[position() &lt;= ceiling($topLevelCalCount div 2)]" mode="fullList"/>
        </td>
        <td>
          <xsl:apply-templates select="calendar[position() &gt; ceiling($topLevelCalCount div 2)]" mode="fullList"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="fullList">
    <xsl:variable name="id" select="id"/>
    <h2><a href="{$selectView}?calId={$id}"><xsl:value-of select="title"/></a></h2>
    <ul>
      <xsl:for-each select="calendar">
        <li><a href="{$selectView}?calId={$id}"><xsl:value-of select="title"/></a></li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2">Display Event</th>
      </tr>
      <tr>
        <td>Event:</td>
        <td class="fieldval"><xsl:value-of select="summary"/></td>
      </tr>
      <tr>
        <td>When:</td>
        <td style="color:red">
          <xsl:value-of select="start/shortdate"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="start/time"/>
          -
          <xsl:value-of select="end/shortdate"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="end/time"/>
        </td>
      </tr>
      <tr>
        <td>Where:</td>
        <td>
          <xsl:choose>
            <xsl:when test="location/link=''">
              <xsl:value-of select="location/address"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="locationLink" select="location/link"/>
              <a href="{$locationLink}">
                <xsl:value-of select="location/address"/>
              </a>
            </xsl:otherwise>
          </xsl:choose><br />
          <xsl:value-of select="location/subaddress"/>
        </td>
      </tr>
      <xsl:if test="cost!=''">
        <tr>
          <td>Cost:</td>
          <td><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <tr>
        <td>Description:</td>
        <td><xsl:value-of select="description"/></td>
      </tr>
      <tr>
        <td>Sponsor:</td>
        <td>
          <xsl:choose>
            <xsl:when test="sponsor/link=''">
              <xsl:value-of select="sponsor/name"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="sponsorLink" select="sponsor/link"/>
              <a href="{$sponsorLink}">
                <xsl:value-of select="sponsor/name"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="sponsor/phone!=''">
            <br /><xsl:value-of select="sponsor/phone"/>
          </xsl:if>
          <xsl:if test="sponsor/email!=''">
            <br />
            <xsl:variable name="sponsormail" select="sponsor/email"/>
            Public Event. For corrections to this event, contact
            <a href="mailto:{$sponsormail}"><xsl:value-of select="sponsor/email"/></a>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td>Categories:</td>
        <td><xsl:value-of select="categories/category/value"/></td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:variable name="id" select="id"/>

          <a href="{$privateCal}/addEventRef.do?eventId={$id}" title="Add to my UW Calendar" target="myCalendar">
            <img src="{$resourcesRoot}/images/washington/addref.gif" border="0" alt="Add to my UW Calendar"/>
            <span class="footnote">= Add to my UW Calendar</span>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--==== SIDE CALENDAR MENU ====-->
  <xsl:template match="calendar" mode="sideList">
    <xsl:variable name="id" select="id"/>
    <div class="std-text">
      <a href="{$selectView}?calId={$id}"><xsl:value-of select="title"/></a>
    </div>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <xsl:if test="/bedework/page!='event' and /bedework/viewType!='yearView'">
      <p>
        <img src="{$resourcesRoot}/images/washington/addref.gif" border="0" alt="Add to my UW Calendar"/>
        <span class="footnote">= Add to my UW Calendar</span>
      </p>
    </xsl:if>

    <hr align="left" size="2" noshade="noshade"/>

    <table width="100%" border="0">
      <tr>
        <td>
          <p class="aux">
            The University of Washington is committed to
            providing access, equal opportunity and reasonable
            accommodation in its services, programs, activities,
            education and employment for individuals with
            disabilities. To request disability accommodation
            contact the Disability Services Office at least ten
            days in advance at: 206.543.6450/V, 206.543.6452/TTY,
            206.685.7264 (FAX), or e-mail at
            dso@u.washington.edu.
          </p>
        </td>
      </tr>
    </table>
    <hr align="left" size="2" noshade="noshade"/>
    <table width="100%" border="0" id="footerTable">
      <tr>
        <td width="15%" align="center">
          <a href="http://www.washington.edu">
            <img width="94" src="{$resourcesRoot}/images/washington/uwid.gif" height="33" border="0" align="bottom" alt="to UW home" hspace="5"/>
          </a>
        </td>
        <td valign="top">
          <address>
            Computing &amp; Communications<br/>
            uwchelp@cac.washington.edu<br/>
          </address>
        </td>
      </tr>
    </table>
    <div id="skinSelector">
      <form name="skinSelectForm" method="get" action="{$setup}">
        Skin selector:
        <select name="skinNameSticky" onChange="submit()">
          <option>select a skin</option>
          <option value="default">Demo</option>
          <option value="washington">Washington</option>
          <option value="rensselaer">Rensselaer</option>
        </select>
      </form>
    </div>
  </xsl:template>
</xsl:stylesheet>
