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

<!-- =========================================================

              DEMONSTRATION CALENDAR STYLESHEET

     This stylesheet is devoid of school branding.  It is a good
     starting point for development of a customized calendar.

     For detailed instructions on how to work with the XSLT
     stylesheets included with this distribution, please see the
     helper web site found at
     http://localhost:8080/cal/info/designhelp/

     (you can also get it from the source at ../info/designhelp/)

===============================================================  -->

  <!-- ================================= -->
  <!--  DEMO PUBLIC CALENDAR STYLESHEET  -->
  <!-- ================================= -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="errors.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
  <xsl:variable name="resourcesRoot" select="/bedework/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/setSelection"/>
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/fetchPublicCalendars"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/setViewPeriod"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/export"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mailEvent"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/showPage"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>

  <!--========= BEGIN DEPRECATED VARIABLES =========-->
  <!-- URL of the web application - includes host, port, and web context.  This
       value was originally prepended to all URLs generated in this stylesheet
       but will probably be deprecated in favor of relative references
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/> -->
  <!--========= END DEPRECATED VARIABLES =========-->

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Calendar of Events</title>
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='style']/value='red'">
            <link rel="stylesheet" href="{$resourcesRoot}/default/default/red.css"/>
          </xsl:when>
          <xsl:when test="/bedework/appvar[key='style']/value='green'">
            <link rel="stylesheet" href="{$resourcesRoot}/default/default/green.css"/>
          </xsl:when>
          <xsl:otherwise>
            <link rel="stylesheet" href="{$resourcesRoot}/default/default/blue.css"/>
          </xsl:otherwise>
        </xsl:choose>
        <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/default/default/print.css" />
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <p><xsl:apply-templates select="/bedework/error"/></p>
          </div>
        </xsl:if>
        <!-- <xsl:call-template name="alerts"/> -->
        <xsl:call-template name="tabs"/>
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
            <!-- otherwise, show the eventsCalendar -->
            <xsl:call-template name="navigation"/>
            <xsl:if test="/bedework/periodname!='Year'">
              <xsl:call-template name="searchBar"/>
            </xsl:if>
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <xsl:call-template name="listView"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="weekView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="monthView"/>
                  </xsl:otherwise>
                </xsl:choose>
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

  <!--==== BLOCK (named) TEMPLATES and NAVIGATION  ====-->
  <!-- these templates are separated out for convenience and to simplify the default template -->

  <xsl:template name="headBar">
    <h1 id="titleBar">
      Bedework: Demonstration Calendar
    </h1>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="http://www.bedework.org/"><img src="{$resourcesRoot}/images/demo/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
    <h2>Public Calendar</h2>
          <a href="{$privateCal}">Personal Calendar</a> |
          <a href="http://www.yourschoolhere.edu">School Home</a> |
          <a href="http://www.washington.edu/ucal/">Other Link</a> |
          <a href="http://helpdesk.rpi.edu/update.do?catcenterkey=51">
            Example Calendar Help
          </a>
          </td>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td><img alt="" src="{$resourcesRoot}/images/demo/std-title-left.gif" width="8" height="16" border="0"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/demo/std-title-space.gif" width="100%" height="16" border="0"/></td>
        <td><img src="{$resourcesRoot}/images/demo/std-title.gif" width="485" height="16" border="0" alt="Calendar of Events"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/demo/std-title-space.gif" width="100%" height="16" border="0"/></td>
        <td><img alt="" src="{$resourcesRoot}/images/demo/std-title-right.gif" width="9" height="16" border="0"/></td>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="dateBarTable">
      <tr>
        <td width="50" class="imgCell"><img alt="*" src="{$resourcesRoot}/images/demo/spacer.gif" width="50" height="14" border="0"/></td>
        <td align="center" width="100%">
          <xsl:value-of select="/bedework/firstday/longdate"/>
          <xsl:if test="/bedework/periodname!='Day'">
            -
            <xsl:value-of select="/bedework/lastday/longdate"/>
          </xsl:if>
        </td>
        <td width="50" class="imgCell">
          <a href="javascript:window.print()" title="print this view">
            <img alt="print this view" src="{$resourcesRoot}/images/demo/std-print-icon.gif" width="20" height="14" border="0"/>
          </a>
          <a class="rss" href="{$setSelection}?calId=&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
          <xsl:variable name="calcategory">
            <xsl:choose>
              <xsl:when test="/bedework/title=''">all</xsl:when>
              <xsl:otherwise><xsl:value-of select="translate(/bedework/title,' ','')"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!--<xsl:variable name="icalName"
                        select="concat('ucal',$curdate,/bedework/periodname,$calcategory,'.ics')"/>
          <a class="rss" href="{$export}?nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$icalName}" title="Download all events currently displayed as iCal - for multiple events, save to disk and import">iCal</a>
          -->
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/bedework/page='eventscalendar'">
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-day-on.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                  <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Month'">
                  <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Year'">
                  <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="centerCell">
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  <img src="{$resourcesRoot}/images/demo/std-button-listview-off.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                </xsl:when>
                <xsl:when test="/bedework/periodname='Year'">
                  <img src="{$resourcesRoot}/images/demo/std-button-calview-off.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                </xsl:when>
                <xsl:when test="/bedework/periodname='Month'">
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                      <a href="{$setup}?setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/demo/std-button-calview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=monthViewMode(list)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/demo/std-button-listview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                      <a href="{$setup}?setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/demo/std-button-calview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=weekViewMode(list)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/demo/std-button-listview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Year' or
                                (/bedework/periodname='Month' and
                                (/bedework/appvar[key='monthViewMode']/value='cal' or
                                 count(/bedework/appvar[key='monthViewMode'])=0)) or
                                (/bedework/periodname='Week' and
                                (/bedework/appvar[key='weekViewMode']/value='cal' or
                                 count(/bedework/appvar[key='weekViewMode'])=0))">
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <img src="{$resourcesRoot}/images/demo/std-button-summary-off.gif" width="67" height="20" border="0" alt="only summaries of events supported in this view"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <img src="{$resourcesRoot}/images/demo/std-button-details-off.gif" width="67" height="20" border="0" alt="only summaries of events supported in this view"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$setup}?setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                        <img src="{$resourcesRoot}/images/demo/std-button-summary.gif" width="67" height="20" border="0" alt="toggle summary/detailed view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=summaryMode(details)" title="toggle summary/detailed view">
                        <img src="{$resourcesRoot}/images/demo/std-button-details.gif" width="67" height="20" border="0" alt="toggle summary/detailed view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rightCell">
              <a href="setup.do"><img src="{$resourcesRoot}/images/demo/std-button-refresh.gif" width="69" height="20" border="0" alt="refresh view"/></a>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/demo/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="centerCell">
                &#160;<!--login-->
            </td>
            <td class="rightCell">
              &#160;
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="alerts">
    <table id="alertsTable">
      <tr>
        <td>
          I'm an alert
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="navigation">
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$setViewPeriod}?date={$prevdate}"><img src="{$resourcesRoot}/images/demo/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$setViewPeriod}?date={$nextdate}"><img src="{$resourcesRoot}/images/demo/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Day'">
              <xsl:value-of select="substring(/bedework/eventscalendar/year/month/week/day/name,1,3)"/>, <xsl:value-of select="/bedework/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/bedework/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
              Week of <xsl:value-of select="/bedework/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/bedework/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:value-of select="/bedework/eventscalendar/year/month/longname"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="get" action="{$setViewPeriod}">
             <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <xsl:if test="/bedework/periodname!='Year'">
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
                  <xsl:if test="/bedework/periodname!='Month'">
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
                  </xsl:if>
                </xsl:if>
                <td>
                  <xsl:variable name="temp" select="/bedework/yearvalues/start"/>
                  <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                </td>
                <td>
                  <input name="submit" type="submit" value="go"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
        <td class="todayButton">
          <a href="{$setViewPeriod}?viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/images/demo/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
        </td>
        <td class="rightCell">
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="searchBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="searchBarTable">
       <tr>
         <td class="leftCell">
           <xsl:choose>
             <xsl:when test="/bedework/name!=''">
               View:
               <form name="selectViewForm" method="get" action="{$setSelection}">
                <select name="viewName" onChange="submit()" >
                  <xsl:for-each select="/bedework/views/view">
                    <xsl:variable name="name" select="name"/>
                    <xsl:choose>
                      <xsl:when test="name=/bedework/name">
                        <option value="{$name}" selected="selected"><xsl:value-of select="name"/></option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="{$name}"><xsl:value-of select="name"/></option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </select>
              </form>
              <span class="calLinks"><a href="{$setSelection}">default view</a> | <a href="{$fetchPublicCalendars}">calendar list</a></span>
             </xsl:when>
             <xsl:when test="/bedework/search!=''">
               Current search: <xsl:value-of select="/bedework/search"/>
               <span class="link">[<a href="{$setSelection}">default view</a>]</span>
             </xsl:when>
           </xsl:choose>
         </td>
         <td class="rightCell"><!--<form name="searchForm" method="get" action="{$setSelection}">Search: <input type="text" name="searchString" size="30" value=""/><input type="submit" value="go"/></form>--></td>
       </tr>
    </table>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <th class="fieldname">Event:</th>
        <th class="fieldval">
          <xsl:choose>
            <xsl:when test="link != ''">
              <xsl:variable name="link" select="link"/>
              <a href="{$link}">
                <xsl:value-of select="summary"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="summary"/>
            </xsl:otherwise>
          </xsl:choose>
        </th>
        <th class="icalIcon" rowspan="2">
          <xsl:variable name="id" select="id"/>
          <xsl:variable name="subscriptionId" select="subscription/id"/>
          <xsl:variable name="guid" select="guid"/>
          <xsl:variable name="recurrenceId" select="recurrenceId"/>
          <a href="{$privateCal}/addEventRef.do?eventId={$id}" title="Add event to MyCalendar" target="myCalendar">
            <img class="addref" src="{$resourcesRoot}/images/demo/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
          </a>
          <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
          <a href="{$export}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/images/demo/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
          </a>
        </th>
      </tr>
      <tr>
        <td class="fieldname">When:</td>
        <td class="fieldval">
          <!-- was using abbrev dayname: substring(start/dayname,1,3) -->
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <span class="time"><xsl:value-of select="start/time"/></span>
          <xsl:if test="end/time != '' or end/longdate != start/longdate"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate"><xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="end/time != ''"><span class="time"><xsl:value-of select="end/time"/></span></xsl:if>
        </td>
      </tr>
      <tr>
        <td class="fieldname">Where:</td>
        <td colspan="2" class="fieldval">
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
          </xsl:choose>
          <xsl:if test="location/subaddress!=''">
            <br/><xsl:value-of select="location/subaddress"/>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="fieldname">Description:</td>
        <td colspan="2" class="fieldval">
          <xsl:value-of select="description"/>
        </td>
      </tr>
       <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname">Cost:</td>
          <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname">See:</td>
          <td colspan="2" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sponsor/name!='none'">
        <tr>
          <td class="fieldname">Contact:</td>
          <td colspan="2" class="fieldval">
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
            <!-- If you want to display email addresses, uncomment the
                 following 8 lines. -->
            <!-- <xsl:if test="sponsor/email!=''">
              <br />
              <xsl:variable name="email" select="sponsor/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}?subject={$subject}">
                <xsl:value-of select="sponsor/email"/>
              </a>
            </xsl:if> -->
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <table id="listTable" border="0" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="count(/bedework/eventscalendar/year/month/week/day/event)=0">
          <tr>
            <td class="noEventsCell">
              There are no events posted
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  today<xsl:if test="/bedework/title!=''"> for <strong><xsl:value-of select="/bedework/title"/></strong></xsl:if><xsl:if test="/bedework/search!=''"> for search term <strong>"<xsl:value-of select="/bedework/search"/>"</strong></xsl:if>.
                </xsl:when>
                <xsl:when test="/bedework/periodname='Month'">
                  this month<xsl:if test="/bedework/title!=''"> for <strong><xsl:value-of select="/bedework/title"/></strong></xsl:if><xsl:if test="/bedework/search!=''"> for search term <strong>"<xsl:value-of select="/bedework/search"/>"</strong></xsl:if>.
                </xsl:when>
                <xsl:otherwise>
                  this week<xsl:if test="/bedework/title!=''"> for <strong><xsl:value-of select="/bedework/title"/></strong></xsl:if><xsl:if test="/bedework/search!=''"> for search term <strong>"<xsl:value-of select="/bedework/search"/>"</strong></xsl:if>.
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[count(event)!=0]">
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="5" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <a href="{$setViewPeriod}?viewType=dayView&amp;date={$date}">
                     <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                   </a>
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <tr>
                <xsl:variable name="dateRangeStyle">
                  <xsl:choose>
                    <xsl:when test="start/shortdate = parent::day/shortdate">
                      <xsl:choose>
                        <xsl:when test="start/allday = 'true'">dateRangeCrossDay</xsl:when>
                        <xsl:when test="start/hour24 &lt; 6">dateRangeEarlyMorning</xsl:when>
                        <xsl:when test="start/hour24 &lt; 12">dateRangeMorning</xsl:when>
                        <xsl:when test="start/hour24 &lt; 18">dateRangeAfternoon</xsl:when>
                        <xsl:otherwise>dateRangeEvening</xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>dateRangeCrossDay</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="start/allday = 'true' and
                                  start/shortdate = end/shortdate">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      all day
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="start/allday = 'true' and
                                        parent::day/shortdate = start/shortdate">
                          today
                        </xsl:when>
                        <xsl:when test="parent::day/shortdate != start/shortdate">
                          <span class="littleArrow">&#171;</span>&#160;
                          <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="start/time"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      </a>
                    </td>
                    <td class="{$dateRangeStyle} center">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="end/allday = 'true' and
                                        parent::day/shortdate = end/shortdate">
                          today
                        </xsl:when>
                        <xsl:when test="parent::day/shortdate != end/shortdate">
                          <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                          &#160;<span class="littleArrow">&#187;</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/time"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      </a>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:variable name="descriptionClass">
                  <xsl:choose>
                    <xsl:when test="priority='cancelled'">description cancelled</xsl:when>
                    <xsl:otherwise>description</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <td class="{$descriptionClass}">
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <strong><xsl:value-of select="summary"/>: </strong>
                        <xsl:value-of select="description"/>&#160;
                        <em>
                          <xsl:value-of select="location/address"/>
                          <xsl:if test="location/subaddress != ''">
                            , <xsl:value-of select="location/subaddress"/>
                          </xsl:if>.&#160;
                          <xsl:if test="cost!=''">
                            <xsl:value-of select="cost"/>.&#160;
                          </xsl:if>
                          <xsl:if test="sponsor/name!='none'">
                            Contact: <xsl:value-of select="sponsor/name"/>
                          </xsl:if>
                        </em>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="summary"/>, <xsl:value-of select="location/address"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="icons">
                  <variable name="confId" select="/bedework/confirmationid"/>
                  <a href="{$privateCal}/addEventRef.do?eventId={$id}" title="Add event to MyCalendar" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/demo/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="Add event to MyCalendar"/>
                  </a>
                  <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                  <a href="{$export}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
                    <img src="{$resourcesRoot}/images/demo/std-ical_icon_small.gif" width="12" height="16" border="0" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each select="/bedework/eventscalendar/year/month/week/day">
          <xsl:variable name="dayPos" select="position()"/>
          <xsl:if test="filler='false'">
            <td>
              <xsl:variable name="dayDate" select="date"/>
              <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
                <xsl:value-of select="value"/>
              </a>
              <ul>
                <xsl:apply-templates select="event" mode="calendarLayout">
                  <xsl:with-param name="dayPos" select="$dayPos"/>
                </xsl:apply-templates>
              </ul>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>

  <!--==== MONTH CALENDAR VIEW ====-->
  <xsl:template name="monthView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="/bedework/eventscalendar/year/month/week">
        <tr>
          <xsl:for-each select="day">
           <xsl:variable name="dayPos" select="position()"/>
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:variable name="dayDate" select="date"/>
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
                    <xsl:value-of select="value"/>
                  </a>
                  <ul>
                    <xsl:apply-templates select="event" mode="calendarLayout">
                      <xsl:with-param name="dayPos" select="$dayPos"/>
                    </xsl:apply-templates>
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
    <xsl:param name="dayPos"/>
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='cancelled'">eventCancelled</xsl:when>
        <xsl:when test="calendar/name='Holidays'">holiday</xsl:when>
        <!-- Alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass}">
        <xsl:value-of select="summary"/>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <strong><xsl:value-of select="summary"/></strong><br/>
          <xsl:if test="start/time != ''">
            Time: <xsl:value-of select="start/time"/>
            <xsl:if test="end/time != ''">
              - <xsl:value-of select="end/time"/>
            </xsl:if>
            <br/>
          </xsl:if>
          <xsl:if test="location/address">
            Location: <xsl:value-of select="location/address"/><br/>
          </xsl:if>
          Calendar: <xsl:value-of select="calendar/name"/>
        </span>
      </a>
    </li>
  </xsl:template>

  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <table id="yearCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &lt;= 3]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 3) and (position() &lt;= 6)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 6) and (position() &lt;= 9)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &gt; 9]"/>
      </tr>
    </table>
  </xsl:template>

  <!-- year view month tables -->
  <xsl:template match="month">
    <td>
      <table class="yearViewMonthTable" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td colspan="8" class="monthName">
            <xsl:variable name="firstDayOfMonth" select="week/day/date"/>
            <a href="{$setViewPeriod}?viewType=monthView&amp;date={$firstDayOfMonth}">
              <xsl:value-of select="longname"/>
            </a>
          </td>
        </tr>
        <tr>
          <th>&#160;</th>
          <xsl:for-each select="/bedework/shortdaynames/val">
            <th><xsl:value-of select="."/></th>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="week">
          <tr>
            <td class="weekCell">
              <xsl:variable name="firstDayOfWeek" select="day/date"/>
              <a href="{$setViewPeriod}?viewType=weekView&amp;date={$firstDayOfWeek}">
                <xsl:value-of select="value"/>
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
                    <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}">
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
    <xsl:variable name="topLevelCalCount" select="count(/bedework/calendars/calendar/calendar)"/>
    <table id="calPageTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2">
          All Calendars
        </th>
      </tr>
      <tr>
        <td colspan="2" class="infoCell">
          Select a calendar from the list below to see only that calendar's events.
        </td>
      </tr>
      <tr>
        <td class="leftCell">
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[position() &lt;= floor($topLevelCalCount div 2)]" mode="calTree"/>
          </ul>
        </td>
        <td>
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[position() &gt; floor($topLevelCalCount div 2)]" mode="calTree"/>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url" select="url"/>
    <li class="{$itemClass}">
      <a href="{$setSelection}?calUrl={$url}"><xsl:value-of select="name"/></a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

<!--==== FOOTER ====-->

  <xsl:template name="footer">
    <div id="footer">
      Demonstration calendar; place footer information here.
    </div>
    <table id="skinSelectorTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="leftCell">
          Based on the <a href="http://www.bedework.org/">Bedework Calendar</a>
        </td>
        <td class="rightCell">
          <form name="styleSelectForm" method="get" action="{$setup}">
            style selector:
            <select name="setappvar" onChange="submit()">
              <option>choose a style</option>
              <option value="style(green)">green</option>
              <option value="style(red)">red</option>
              <option value="style(blue)">blue</option>
            </select>
          </form>
          <form name="skinSelectForm" method="get" action="{$setup}">
            skin selector:
            <select name="skinNameSticky" onChange="submit()">
              <option>select a skin</option>
              <option value="default">Demo</option>
              <option value="washington">Washington</option>
              <option value="rensselaer">Rensselaer</option>
            </select>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
