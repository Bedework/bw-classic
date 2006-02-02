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
  <!-- ================================== -->
  <!--  DEMO PERSONAL CALENDAR STYLESHEET -->
  <!-- ================================== -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="errors.xsl"/>
  <xsl:include href="messages.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the personal calendar
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot" select="'https://mywebserver.edu/myresourcesdir'"/>
    -->
  <xsl:variable name="resourcesRoot" select="/ucalendar/approot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/ucalendar/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal. -->
  <xsl:variable name="setup" select="/ucalendar/urlPrefixes/setup"/>
  <xsl:variable name="selectCalendar" select="/ucalendar/urlPrefixes/selectCalendar"/>
  <xsl:variable name="showCals" select="/ucalendar/urlPrefixes/showCals"/>
  <xsl:variable name="setView" select="/ucalendar/urlPrefixes/setView"/>
  <xsl:variable name="eventView" select="/ucalendar/urlPrefixes/eventView"/>
  <xsl:variable name="addEvent" select="/ucalendar/urlPrefixes/addEvent"/>
  <xsl:variable name="editEvent" select="/ucalendar/urlPrefixes/editEvent"/>
  <xsl:variable name="delEvent" select="/ucalendar/urlPrefixes/delEvent"/>
  <xsl:variable name="addEventRef" select="/ucalendar/urlPrefixes/addEventRef"/>
  <xsl:variable name="showPage" select="/ucalendar/urlPrefixes/showPage"/>
  <xsl:variable name="manageLocations" select="/ucalendar/urlPrefixes/manageLocations"/>
  <xsl:variable name="addLocation" select="/ucalendar/urlPrefixes/addLocation"/>
  <xsl:variable name="editLocation" select="/ucalendar/urlPrefixes/editLocation"/>
  <xsl:variable name="delLocation" select="/ucalendar/urlPrefixes/delLocation"/>
  <xsl:variable name="subscribe" select="/ucalendar/urlPrefixes/subscribe"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/ucalendar/urlprefix"/> -->

  <!-- Other generally useful global variables -->
  <xsl:variable name="confId" select="/ucalendar/confirmationid"/>
  <xsl:variable name="prevdate" select="/ucalendar/previousdate"/>
  <xsl:variable name="nextdate" select="/ucalendar/nextdate"/>
  <xsl:variable name="curdate" select="/ucalendar/currentdate/date"/>
  <xsl:variable name="calendarCount" select="count(/ucalendar/calendars/calendar)"/>

 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:call-template name="headSection"/>
      </head>
      <body>
        <xsl:call-template name="header"/>
        <xsl:choose>
          <xsl:when test="/ucalendar/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/ucalendar/event"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='editEvent'">
            <!-- edit an event -->
            <xsl:apply-templates select="/ucalendar/eventform"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='manageLocations'">
            <xsl:call-template name="manageLocations" />
          </xsl:when>
          <xsl:when test="/ucalendar/page='editLocation'">
            <!-- edit an event -->
            <xsl:apply-templates select="/ucalendar/locationform"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='calendars'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/ucalendar/calendars"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='other'">
            <!-- show an arbitrary page -->
            <xsl:call-template name="selectPage"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/ucalendar/periodname='Day'">
                <xsl:call-template name="dayLayout"/>
              </xsl:when>
              <xsl:when test="/ucalendar/periodname='Week'">
                <xsl:call-template name="weekLayout"/>
              </xsl:when>
              <xsl:when test="/ucalendar/periodname='Month'">
                <xsl:call-template name="monthLayout"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="yearLayout"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==== <head></head> SECTION ====-->
  <xsl:template name="headSection">
        <title>
          UW Calendar
          <xsl:choose>
            <xsl:when test="/ucalendar/page='event'">
              - <xsl:value-of select="/ucalendar/event/summary"/>
            </xsl:when>
            <xsl:when test="/ucalendar/page='calendars'">
              - subscribe to calendars
            </xsl:when>
            <xsl:when test="/ucalendar/periodname='Day'">
              - day view
            </xsl:when>
            <xsl:when test="/ucalendar/periodname='Week'">
              - week view
            </xsl:when>
            <xsl:when test="/ucalendar/periodname='Month'">
              - month view
            </xsl:when>
            <xsl:otherwise>
              - year view
            </xsl:otherwise>
          </xsl:choose>
        </title>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/washington.css" />
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
                  <a href="{$resourcesRoot}/info/help/help.html">Help</a>
                </span>
              </td>
            </tr>
            <tr>
              <td id="date-header-cell">
                <table cellpadding="0" cellspacing="0">
                  <tr>
                    <td id="prev-cell">
                      <xsl:variable name="prevdate" select="/ucalendar/previousdate"/>
                      <a href="{$setView}?date={$prevdate}"><img src="{$resourcesRoot}/images/washington/arrowL.gif" height="19" width="30" border="0" id="prev-image" alt="Previous"/></a>
                    </td>
                    <td id="date-header-text-cell">&#160;&#160;
                     <a href="{$setView}?date={$curdate}">
                      <xsl:choose>
                        <xsl:when test="/ucalendar/periodname='Day'">
                          <xsl:value-of select="/ucalendar/currentdate/longdate"/>
                        </xsl:when>
                        <xsl:when test="/ucalendar/periodname='Week'">
        Week of <xsl:value-of select="/ucalendar/currentdate/monthname"/>&#160;<xsl:value-of select="/ucalendar/currentdate/dayofmonth"/>, <xsl:value-of select="/ucalendar/currentdate/year"/>
                        </xsl:when>
                        <xsl:when test="/ucalendar/periodname='Month'">
                          <xsl:value-of select="/ucalendar/currentdate/monthname"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="substring(/ucalendar/currentdate/date,1,4)"/>
                        </xsl:when>
                        <xsl:when test="/ucalendar/periodname='Year'">
                          <xsl:value-of select="substring(/ucalendar/currentdate/date,1,4)"/>
                        </xsl:when>
                      </xsl:choose>
                     </a>&#160;&#160;
                    </td>
                    <td id="next-cell">
                      <xsl:variable name="nextdate" select="/ucalendar/nextdate"/>
                      <a href="{$setView}?date={$nextdate}"><img src="{$resourcesRoot}/images/washington/arrowR.gif" height="19" width="30" border="0" id="next-image" alt="Next"/></a>
                    </td>
                  </tr>
                </table>
              </td>
              <td id="goto-cell">
                <form name="calForm" method="get" action="{$setView}">
                  <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td>
                        <select name="viewStartDate.month">
                          <xsl:for-each select="/ucalendar/monthvalues/val">
                            <xsl:variable name="temp" select="."/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:choose>
                              <xsl:when test="/ucalendar/monthvalues[start=$temp]">
                                <option value="{$temp}" selected="selected">
                                  <xsl:value-of select="/ucalendar/monthlabels/val[position()=$pos]"/>
                                </option>
                              </xsl:when>
                              <xsl:otherwise>
                                <option value="{$temp}">
                                  <xsl:value-of select="/ucalendar/monthlabels/val[position()=$pos]"/>
                                </option>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </select>
                      </td>
                      <td>
                        <select name="viewStartDate.day">
                          <xsl:for-each select="/ucalendar/dayvalues/val">
                            <xsl:variable name="temp" select="."/>
                            <xsl:variable name="pos" select="position()"/>
                            <xsl:choose>
                              <xsl:when test="/ucalendar/dayvalues[start=$temp]">
                                <option value="{$temp}" selected="selected">
                                  <xsl:value-of select="/ucalendar/daylabels/val[position()=$pos]"/>
                                </option>
                              </xsl:when>
                              <xsl:otherwise>
                                <option value="{$temp}">
                                  <xsl:value-of select="/ucalendar/daylabels/val[position()=$pos]"/>
                                </option>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </select>
                      </td>
                      <td>
                        <xsl:variable name="temp" select="/ucalendar/yearvalues/start"/>
                        <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                      </td>
                      <td>
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
                      <xsl:when test="/ucalendar/periodname='Day' and
                                     (/ucalendar/currentdate/date = /ucalendar/now/date)">
                        <td class="navbutton-on">
                          <a href="{$setView}?viewType=todayView&amp;date={$curdate}" class="button-on">Today</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setView}?viewType=todayView&amp;date={$curdate}" class="button-off">Today</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/ucalendar/periodname='Day'">
                        <td class="navbutton-on">
                          <a href="{$setView}?viewType=dayView&amp;date={$curdate}" class="button-on">Day</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setView}?viewType=dayView&amp;date={$curdate}" class="button-off">Day</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/ucalendar/periodname='Week'">
                        <td class="navbutton-on">
                          <a href="{$setView}?viewType=weekView&amp;date={$curdate}" class="button-on">Week</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setView}?viewType=weekView&amp;date={$curdate}" class="button-off">Week</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/ucalendar/periodname='Month'">
                        <td class="navbutton-on">
                          <a href="{$setView}?viewType=monthView&amp;date={$curdate}" class="button-on">Month</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setView}?viewType=monthView&amp;date={$curdate}" class="button-off">Month</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="/ucalendar/periodname='Year'">
                        <td class="navbutton-on">
                          <a href="{$setView}?viewType=yearView&amp;date={$curdate}" class="button-on">Year</a>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="navbutton-off">
                          <a href="{$setView}?viewType=yearView&amp;date={$curdate}" class="button-off">Year</a>
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                  </tr>
                </table>
              </td>
            </tr>
            <xsl:if test="/ucalendar/page!='event' and /ucalendar/page!='calendars'">
              <tr>
                <td colspan="3" class="header-links">
                  <span class="aux">
                    <a href="{$manageLocations}">Manage Locations</a> |
                    <a href="{$showCals}">Manage Subscriptions</a>
                  </span>
                </td>
              </tr>
            </xsl:if>
<!--            <xsl:if test="/ucalendar/periodname!='Year' and /ucalendar/page!='event' and /ucalendar/page!='calendars'"> -->
              <xsl:variable name="statusCellStyle">
                <xsl:choose>
                  <xsl:when test="count(/ucalendar/error)&gt;0 or
                                  count(/ucalendar/message)&gt;0">has-status</xsl:when>
                  <xsl:otherwise>no-status</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <tr>
                <td colspan="3" class="{$statusCellStyle}">
                  <xsl:for-each select="/ucalendar/error">
                   <xsl:apply-templates select="."/><br/>
                  </xsl:for-each>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="/ucalendar/message"/>
                </td>
              </tr>
<!--            </xsl:if> -->
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--==== DAY VIEW ====-->
  <xsl:template name="dayLayout">
    <table id="body-table" cellspacing="2" width="100%" cellpadding="0">
      <tr>
        <td id="eventlist-cell" width="65%">
          <xsl:call-template name="dayEventListing"/>
        </td>
        <td id="rightbody-cell" width="35%">
          <xsl:call-template name="eventEntryForm"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="dayEventListing">
    <table id="eventlist-table" cellspacing="2" width="100%" cellpadding="1">
      <thead>
        <tr>
          <th id="day-header" colspan="1">
            Calendar Entries for
            <xsl:value-of select="/ucalendar/firstday/longdate"/>
            <xsl:if test="/ucalendar/periodname!='Day'">
              -
              <xsl:value-of select="/ucalendar/lastday/longdate"/>
            </xsl:if>
          </th>
        </tr>
      </thead>
      <xsl:choose>
        <xsl:when test="count(/ucalendar/eventscalendar/year/month/week/day/event)=0">
          <tr>
            <td class="eventlist-desc">
              No events this time period
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/ucalendar/periodname!='Day'">
              <xsl:apply-templates select="/ucalendar/eventscalendar/year/month/week/day[count(event)!=0]" mode="weekMonthListing"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/ucalendar/eventscalendar/year/month/week/day[count(event)!=0]" mode="dayListing"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <xsl:template name="eventEntryForm">
    <form name="addEventForm" method="post" action="addEvent.do">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="entryform-table" cellspacing="0" width="100%" border="1" cellpadding="3">
        <tr>
          <td colspan="2" class="form-header">Add Event</td>
        </tr>
        <tr>
          <td align="left">
            <span class="std-text">Title/Summary </span>
            <span class="required-field" title="required">* </span>
            <xsl:copy-of select="/ucalendar/eventform/form/title/*"/>
          </td>
        </tr>
        <tr>
          <td align="left" valign="top">
            <span class="std-text">Description </span>
            <xsl:copy-of select="/ucalendar/eventform/form/description/*"/>
          </td>
        </tr>
        <tr>
          <td align="left">
            <span class="std-text">Entry Link </span>
            <xsl:copy-of select="/ucalendar/eventform/form/link/*"/>
          </td>
        </tr>
        <tr>
          <td align="left">
            <table cellspacing="0" width="100%" class="form-element" border="0" cellpadding="0">
              <tr>
                <td colspan="2" class="location-header">Location</td>
              </tr>
              <tr>
                <td align="left">
                  <span class="std-text">choose </span>
            <select name="locationId">
              <xsl:for-each select="/ucalendar/eventform/form/location/locationmenu/select/option">
                <xsl:variable name="value" select="@value"/>
                      <xsl:variable name="label">
                        <xsl:choose>
                          <xsl:when test="string-length() &gt; 30">
                            <xsl:value-of select="substring(node(),1,30)"/>...
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="."/>
                          </xsl:otherwise>
            </xsl:choose>
                      </xsl:variable>
          <xsl:choose>
                        <xsl:when test="@selected">
                          <option value="{$value}" selected="selected">
                            <xsl:value-of select="$label" />
                          </option>
            </xsl:when>
            <xsl:otherwise>
                          <option value="{$value}">
                            <xsl:value-of select="$label" />
                          </option>
            </xsl:otherwise>
          </xsl:choose>
              </xsl:for-each>
            </select>
                  <br/><span class="std-text"><span class="bold">or</span> add </span>
                  <xsl:copy-of select="/ucalendar/eventform/form/location/locationtext/*"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="left">
            <table cellspacing="0" width="100%" class="form-element" border="0" cellpadding="0">
              <tr>
                <td colspan="2" class="datetime-header">Date/Time</td>
              </tr>
              <tr>
                <td align="left"><span class="field-name">Start:</span></td>
                <td align="left">
                  <span>
                    <xsl:for-each select="/ucalendar/eventform/form/startdate/*">
                      <xsl:choose>
                        <xsl:when test="@name='eventStartDate.month'">
        <xsl:copy-of select="."/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="@name='eventStartDate.day'">
        <xsl:copy-of select="."/>
                        </xsl:when>
                      </xsl:choose>
        </xsl:for-each>
                    <xsl:variable name="temp" select="/ucalendar/yearvalues/start"/>
                    <input type="text" name="eventStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                  </span>
                </td>
              </tr>
              <tr>
                <td align="left">&#160;</td>
                <td align="left">
                  <span class="std-text">at  </span>
                  <xsl:copy-of select="/ucalendar/eventform/form/starttime/*"/>
                </td>
              </tr>
              <tr>
                <td colspan="2"><hr size="1" noshade="noshade"/></td>
              </tr>
              <tr>
                <td align="left"><span class="field-name">End:</span></td>
                <td align="left">
                  <span>
                    <xsl:for-each select="/ucalendar/eventform/form/enddate/*">
                      <xsl:choose>
                        <xsl:when test="@name='eventEndDate.month'">
        <xsl:copy-of select="."/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="@name='eventEndDate.day'">
        <xsl:copy-of select="."/>
                        </xsl:when>
                      </xsl:choose>
        </xsl:for-each>
                    <xsl:variable name="temp" select="/ucalendar/yearvalues/start"/>
                    <input type="text" name="eventEndDate.year" maxlength="4" size="4" value="{$temp}"/>
                  </span>
                </td>
              </tr>
              <tr>
                <td align="left">&#160;</td>
                <td align="left">
                  <span class="std-text">at  </span>
                  <xsl:copy-of select="/ucalendar/eventform/form/endtime/*"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td id="submit-cell">
            <input name="submit" type="submit" value="Submit Entry"/>
          </td>
        </tr>
        <tr>
          <td class="footnoteCell">
            <span style="color:red;">*</span> = required field
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== WEEK VIEW ====-->
  <xsl:template name="weekLayout">
    <table id="calendarGridViewTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th class="dayHeading">Sunday</th>
        <th class="dayHeading">Monday</th>
        <th class="dayHeading">Tuesday</th>
        <th class="dayHeading">Wednesday</th>
        <th class="dayHeading">Thursday</th>
        <th class="dayHeading">Friday</th>
        <th class="dayHeading">Saturday</th>
      </tr>
      <tr>
        <xsl:for-each select="/ucalendar/eventscalendar/year/month/week/day">
          <xsl:if test="filler='false'">
            <td>
              <xsl:variable name="dayDate" select="date"/>
              <a href="{$setView}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
                <xsl:value-of select="value"/>
              </a>
              <ul>
                <xsl:apply-templates select="event" mode="calendarLayout"/>
              </ul>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>

  <!--==== MONTH VIEW ====-->
  <xsl:template name="monthLayout">
    <table id="calendarGridViewTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th class="dayHeading">Sunday</th>
        <th class="dayHeading">Monday</th>
        <th class="dayHeading">Tuesday</th>
        <th class="dayHeading">Wednesday</th>
        <th class="dayHeading">Thursday</th>
        <th class="dayHeading">Friday</th>
        <th class="dayHeading">Saturday</th>
      </tr>
      <xsl:for-each select="/ucalendar/eventscalendar/year/month/week">
        <tr>
          <xsl:for-each select="day">
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:variable name="dayDate" select="date"/>
                  <a href="{$setView}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
                    <xsl:value-of select="value"/>
                  </a>
                  <ul>
                    <xsl:apply-templates select="event" mode="calendarLayout"/>
                  </ul>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="event" mode="calendarLayout">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass}"><xsl:value-of select="summary"/></a>
    </li>
  </xsl:template>

  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearLayout">
    <table id="year-table" cellspacing='2' width='100%' cellpadding='3'>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[position() &lt;= 4]">
          <xsl:with-param name="currentYear" select="/ucalendar/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[(position() &gt; 4) and (position() &lt;= 8)]">
          <xsl:with-param name="currentYear" select="/ucalendar/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[position() &gt; 8]">
          <xsl:with-param name="currentYear" select="/ucalendar/eventscalendar/year/value"/>
        </xsl:apply-templates>
      </tr>
    </table>
  </xsl:template>

  <!-- year view month tables -->
  <xsl:template match="month">
    <xsl:param name="currentYear">1900</xsl:param>
    <xsl:variable name="month-cell-style">
      <xsl:choose>
        <xsl:when test="(value = substring(/ucalendar/now/date,5,2)) and
                        ($currentYear = substring(/ucalendar/now/date,1,4))">current-month</xsl:when>
        <xsl:otherwise>month-cell</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <td class="{$month-cell-style}">
      <table cellspacing="1" width="100%" class="smallmonth-table" cellpadding="3">
        <tr>
          <td colspan="8" class="month-name-cell">
            <xsl:variable name="firstDayOfMonth" select="week/day/date"/>
            <a href="{$setView}?viewType=monthView&amp;date={$firstDayOfMonth}" class="month">
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
              <a href="{$setView}?viewType=weekView&amp;date={$firstDayOfWeek}" class="week-number">
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
                    <a href="{$setView}?viewType=dayView&amp;date={$dayDate}" class="day">
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
    <xsl:variable name="topLevelCalCount" select="count(/ucalendar/calendars/calendar)"/>
    <form name="subscriptionForm" method="post" action="subscribe.do">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="calPageTable">
        <tr>
          <th colspan="2">
            Calendar Subscriptions
          </th>
        </tr>
        <tr>
          <td colspan="2" class="submit-row">
            Subscribe to these calendars by checking the boxes, then click the Submit button &#62;&#62;&#160;
            <input name="submit" type="submit" value="Submit"/>
          </td>
      </tr>
        <tr>
          <td class="leftCell">
            <xsl:apply-templates select="calendar[position() &lt; ceiling($topLevelCalCount div 2)]" mode="fullList"/>
          </td>
          <td>
            <xsl:apply-templates select="calendar[position() &gt;= ceiling($topLevelCalCount div 2)]" mode="fullList"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="calendar" mode="fullList">
    <xsl:variable name="id" select="id"/>
    <h2>
      <xsl:copy-of select="form/checkbox/*" />
      <xsl:value-of select="title"/>
    </h2>
    <ul>
      <xsl:for-each select="calendar">
        <li>
          <xsl:copy-of select="form/checkbox/*" />
          <xsl:value-of select="title"/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!--==== EVENTS LISTING ====-->
  <xsl:template match="day" mode="weekMonthListing">
    <xsl:if test="date != /ucalendar/firstday/date">
      <tr>
        <td class="list-date-header">
          <xsl:variable name="date" select="date"/>
          <a href="{$setView}?viewType=dayView&amp;date={$date}"><xsl:value-of select="longdate"/></a>
        </td>
      </tr>
    </xsl:if>
    <xsl:for-each select="event">
      <xsl:variable name="subscriptionId" select="subscription/id"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
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
            <span class="day-item"><xsl:value-of select="summary"/></span>,
            <span class="day-item">
              <xsl:value-of select="location"/>
            </span>
          </span> &#160;
          <span class="aux">
            <span class="aux">
              <xsl:call-template name="eventLinks"/>
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
            <xsl:variable name="subscriptionId" select="subscription/id"/>
            <xsl:variable name="guid" select="guid"/>
            <xsl:variable name="recurrenceId" select="recurrenceId"/>
            <xsl:variable name="timeStyle">
              <xsl:choose>
                <xsl:when test="start/date = parent::day/date">
                  <xsl:choose>
                    <xsl:when test="start/hour='0' and end/hour='0'">eventlist-notime</xsl:when>
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
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="end/time"/>
                  </xsl:when>
                  <xsl:when test="end/shortdate = ../shortdate and end/time != ''">
                    <xsl:value-of select="start/shortdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="start/time"/> -
                    <xsl:value-of select="end/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="start/shortdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="start/time"/> -
                    <xsl:value-of select="end/shortdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="end/time"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class='eventlist-desc'>
                <xsl:choose>
                  <xsl:when test="link='' or link='http://'">
                    <xsl:value-of select="summary"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="link" select="link"/>
                    <a href="{$link}">
                      <xsl:value-of select="summary"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="location/address!=''">,
                  <xsl:choose>
                    <xsl:when test="location/link='' or location/link='http://'">
                      <xsl:value-of select="location/address"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="locationLink" select="location/link"/>
                      <a href="{$locationLink}">
                        <xsl:value-of select="location/address"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </td>
              <td class='eventlist-links'>
                <span class='aux'>
                  <span class='aux'>
                    <xsl:call-template name="eventLinks"/>
                  </span>
                </span>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="eventLinks">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">More</a>
    <xsl:if test="kind='0'">
      | <a href="{$editEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">Edit</a>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="kind='0'">
        <xsl:choose>
          <xsl:when test="recurring=true">
            | <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}">Delete All</a>
          </xsl:when>
          <xsl:otherwise>
            | <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Delete</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="kind='1'">
        <xsl:choose>
          <xsl:when test="recurring=true">
            | <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}">Remove All</a>
          </xsl:when>
          <xsl:otherwise>
            | <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Remove</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        | <a href="{$showCals}">Subscriptions</a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2">
          Display Event
        </th>
      </tr>
      <tr>
        <td colspan="2" class="publicPrivate">
          <xsl:choose>
            <xsl:when test="kind='0'">
              private event
            </xsl:when>
            <xsl:when test="kind='1'">
              public event
            </xsl:when>
            <xsl:otherwise>
              public event from subscription
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td>Event:</td>
        <td class="fieldval">
          <xsl:choose>
            <xsl:when test="link='' or link='http://'">
              <xsl:value-of select="summary"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="link" select="link"/>
              <a href="{$link}">
                <xsl:value-of select="summary"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td>When:</td>
        <td style="color:red">
          <xsl:value-of select="start/shortdate"/><xsl:text> </xsl:text>
          <xsl:value-of select="start/time"/>
          -
          <xsl:value-of select="end/shortdate"/><xsl:text> </xsl:text>
          <xsl:value-of select="end/time"/>
        </td>
      </tr>
      <xsl:if test="location/address!=''">
        <tr>
          <td>Where:</td>
          <td>
            <xsl:choose>
              <xsl:when test="location/link='' or location/link='http://'">
                <xsl:value-of select="location/address"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="locationLink" select="location/link"/>
                <a href="{$locationLink}">
                  <xsl:value-of select="location/address"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="kind='0'">
              <xsl:variable name="locationId" select="location/id"/>
              <span class="editLocation">
              [<a href="{$editLocation}?locationId={$locationId}">
                 edit location
              </a>]
              </span>
            </xsl:if>
            <br />
            <xsl:value-of select="location/subaddress"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="cost!=''">
        <tr>
          <td>Cost:</td>
          <td><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="description!=''">
        <tr>
          <td>Description:</td>
          <td><xsl:value-of select="description"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="sponsor/name!=''">
        <tr>
          <td>Sponsor:</td>
          <td>
            <xsl:choose>
              <xsl:when test="sponsor/link='' or sponsor/link='http://'">
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
      </xsl:if>
      <xsl:if test="calendar/name!=''">
        <tr>
          <td>Calendar:</td>
          <td><xsl:value-of select="calendar/name"/></td>
        </tr>
      </xsl:if>
      <xsl:variable name="subscriptionId" select="subscription/id"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <tr>
        <td>&#160;</td>
        <td class="buttons">
          <xsl:if test="kind='0'">
            <a href="{$editEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="buttonOther">
              Edit Event
            </a>&#160;&#160;
          </xsl:if>
          <xsl:choose>
            <xsl:when test="kind='0'">
              <xsl:choose>
                <xsl:when test="recurring=true">
                  <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}" class="buttonDelete">
                    Delete All (recurring)
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}" class="buttonDelete">
                    Delete Event
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="kind='1'">
              <xsl:choose>
                <xsl:when test="recurring=true">
                  <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}" class="buttonDelete">
                    Remove All (recurring)
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}" class="buttonDelete">
                    Remove
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$showCals}" class="buttonOther">
                Subscriptions
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="eventform">
    <form name="editEventForm" method="post" action="{$editEvent}">
      <input type="hidden" name="updateEvent" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="eventTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2">Edit Event</th>
        </tr>
        <tr>
          <td>
            <span class="required-field" title="required">*</span>
            Title/Summary:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/eventform/form/title/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Start Date/Time:
          </td>
          <td>
            <xsl:for-each select="/ucalendar/eventform/form/startdate/*">
              <xsl:choose>
                <xsl:when test="@name='eventStartDate.month'">
      <xsl:copy-of select="."/>
                </xsl:when>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="@name='eventStartDate.day'">
      <xsl:copy-of select="."/>
                </xsl:when>
              </xsl:choose>
      </xsl:for-each>
            <xsl:variable name="temp" select="/ucalendar/yearvalues/eventStart"/>
            <input type="text" name="eventStartDate.year" maxlength="4" size="4" value="{$temp}"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/starttime/*"/>
          </td>
        </tr>
        <tr>
          <td>
            End Date/Time:
          </td>
          <td>
            <xsl:for-each select="/ucalendar/eventform/form/enddate/*">
              <xsl:choose>
                <xsl:when test="@name='eventEndDate.month'">
                  <xsl:copy-of select="."/>
                </xsl:when>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="@name='eventEndDate.day'">
      <xsl:copy-of select="."/>
                </xsl:when>
              </xsl:choose>
      </xsl:for-each>
            <xsl:variable name="temp" select="/ucalendar/yearvalues/eventEnd"/>
            <input type="text" name="eventEndDate.year" maxlength="4" size="4" value="{$temp}"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/endtime/*"/>
          </td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><xsl:copy-of select="/ucalendar/eventform/form/description/*"/></td>
        </tr>
        <tr>
          <td>Location:</td>
          <td align="left">
            <span class="std-text">choose </span>
      <select name="locationId">
        <xsl:for-each select="/ucalendar/eventform/form/location/locationmenu/select/option">
          <xsl:variable name="value" select="@value"/>
                <xsl:variable name="label">
                  <xsl:choose>
                    <xsl:when test="string-length() &gt; 30">
                      <xsl:value-of select="substring(node(),1,30)"/>...
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                    </xsl:otherwise>
      </xsl:choose>
                </xsl:variable>
    <xsl:choose>
                  <xsl:when test="@selected">
                    <option value="{$value}" selected="selected">
                      <xsl:value-of select="$label" />
                    </option>
      </xsl:when>
      <xsl:otherwise>
                    <option value="{$value}">
                      <xsl:value-of select="$label" />
                    </option>
      </xsl:otherwise>
    </xsl:choose>
        </xsl:for-each>
      </select>

            <span class="std-text"><span class="bold">or</span> add </span>
            <xsl:copy-of select="/ucalendar/eventform/form/location/locationtext/*"/>
          </td>
        </tr>
        <tr>
          <td>Event Link:</td>
          <td>
            <xsl:copy-of select="/ucalendar/eventform/form/link/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Submit Event"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
            <xsl:variable name="subscriptionId" select="subscription/id"/>
            <xsl:variable name="guid" select="guid"/>
            <xsl:variable name="recurrenceId" select="recurrenceId"/>
            <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="buttonDelete">
              Delete Event
            </a>
          </td>
        </tr>
        <tr>
          <td class="footnoteCell">
            <span style="color:red;">*</span> = required field
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== EDIT LOCATION ====-->
  <xsl:template match="locationform">
    <form name="editLocationForm" method="post" action="{$editLocation}">
      <input type="hidden" name="updateLocation" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="eventTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2">Edit Location</th>
        </tr>
        <tr>
          <td>
            <span class="required-field" title="required">*</span>
            Address:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/locationform/form/address/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Subaddress:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/locationform/form/subaddress/*"/>
          </td>
        </tr>
        <tr>
          <td>Location's URL:</td>
          <td>
            <xsl:copy-of select="/ucalendar/locationform/form/link/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
            <xsl:variable name="locId" select="/ucalendar/locationform/form/id"/>
            <a href="{$delLocation}?locationId={$locId}" class="buttonDelete">
              Delete Location
            </a>
          </td>
        </tr>
        <tr>
          <td class="footnoteCell">
            <span style="color:red;">*</span> = required field
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== SIDE CALENDAR MENU ====-->
  <xsl:template match="calendar" mode="sideList">
    <xsl:variable name="id" select="id"/>
    <div class="std-text">
      <a href="{$selectCalendar}?calId={$id}"><xsl:value-of select="title"/></a>
    </div>
  </xsl:template>

   <!--==== STAND-ALONE PAGES ====-->
   <xsl:template name="selectPage">
    <xsl:choose>
      <xsl:when test="count(/ucalendar/appvar[key='page'])!=0">
        <xsl:choose>
          <xsl:when test="/ucalendar/appvar[key='page']/value='locationForm'">
            <xsl:call-template name="manageLocations"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="noPage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="noPage"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="noPage">
    <p>
      Error: there is no page with that name.  Please select a navigational
      link to continue.
    </p>
  </xsl:template>

  <xsl:template name="manageLocations">
    <form name="addLocationForm" method="post" action="addLocation.do">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table border="0" id="locationFormTable">
        <tr>
    <th colspan="2">Manage Locations</th>
        </tr>
        <tr>
          <th colspan="2" class="form-header">Add Location</th>
        </tr>
        <tr>
          <td>
            <span class="std-text">Main Address </span><span class="required-field" title="required">*</span>
          </td>
          <td>
            <input size="25" name="newLocation.address" type="text"/>
          </td>
        </tr>
        <tr>
          <td>
            <span class="std-text">Subaddress</span>
          </td>
          <td>
            <input size="25" name="newLocation.subaddress" type="text"/>
          </td>
        </tr>
        <tr>
          <td>
            <span class="std-text">Location Link</span>
          </td>
          <td>
            <input size="25" name="newLocation.link" type="text"/>
          </td>
        </tr>
        <tr>
          <td colspan="2" id="submit-cell">
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="required-field" title="required">*</span><span class="footnote">= required field</span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            &#160;
          </td>
        </tr>
        <tr>
          <th colspan="2" class="form-header">Edit/Delete Locations</th>
        </tr>
        <td colspan="2">
          <ul>
            <xsl:for-each select="/ucalendar/eventform/form/location/locationmenu/select/option[@value>'3']">
              <xsl:sort select="."/>
              <li>
                <xsl:variable name="locationId" select="@value"/>
                <a href="{$editLocation}?locationId={$locationId}"><xsl:value-of select="."/></a>
              </li>
            </xsl:for-each>
          </ul>
        </td>
      </table>
    </form>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <p id="loggedInAs">
      <em>Logged in as:</em><xsl:text> </xsl:text>
      <xsl:value-of select="/ucalendar/userid"/>
      [<a href="{$setup}?logout=true">logout</a>]
    </p>
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
        skin selector:
        <select name="skinNameSticky" onChange="submit()">
          <option>select a skin</option>
          <option value="default">Demo Calendar</option>
          <option value="rensselaer">Rensselaer</option>
          <option value="washington">Washington</option>
        </select>
      </form>
    </div>
  </xsl:template>
</xsl:stylesheet>
