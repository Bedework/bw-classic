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
   <!-- ======================================== -->
  <!--  Rensselaer PERSONAL CALENDAR STYLESHEET  -->
  <!-- ========================================= -->

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
  <xsl:variable name="initEvent" select="/ucalendar/urlPrefixes/initEvent"/>
  <xsl:variable name="addEvent" select="/ucalendar/urlPrefixes/addEvent"/>
  <xsl:variable name="addEventUsingPage" select="/ucalendar/urlPrefixes/addEventUsingPage"/>
  <xsl:variable name="editEvent" select="/ucalendar/urlPrefixes/editEvent"/>
  <xsl:variable name="delEvent" select="/ucalendar/urlPrefixes/delEvent"/>
  <xsl:variable name="addEventRef" select="/ucalendar/urlPrefixes/addEventRef"/>
  <xsl:variable name="mailEvent" select="/ucalendar/urlPrefixes/mailEvent"/>
  <xsl:variable name="showPage" select="/ucalendar/urlPrefixes/showPage"/>
  <xsl:variable name="manageLocations" select="/ucalendar/urlPrefixes/manageLocations"/>
  <xsl:variable name="addLocation" select="/ucalendar/urlPrefixes/addLocation"/>
  <xsl:variable name="editLocation" select="/ucalendar/urlPrefixes/editLocation"/>
  <xsl:variable name="delLocation" select="/ucalendar/urlPrefixes/delLocation"/>
  <xsl:variable name="subscribe" select="/ucalendar/urlPrefixes/subscribe"/>
  <xsl:variable name="initEventAlarm" select="/ucalendar/urlPrefixes/initEventAlarm"/>
  <xsl:variable name="setAlarm" select="/ucalendar/urlPrefixes/setAlarm"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/ucalendar/urlprefix"/> -->

  <!-- Other generally useful global variables -->
  <xsl:variable name="confId" select="/ucalendar/confirmationid"/>
  <xsl:variable name="prevdate" select="/ucalendar/previousdate"/>
  <xsl:variable name="nextdate" select="/ucalendar/nextdate"/>
  <xsl:variable name="curdate" select="/ucalendar/currentdate/date"/>
  <xsl:variable name="skin">rensselaer</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>

 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:call-template name="headSection"/>
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/ucalendar/message">
          <div id="messages">
            <p><xsl:apply-templates select="/ucalendar/message"/></p>
          </div>
        </xsl:if>
        <xsl:if test="/ucalendar/error">
          <div id="errors">
            <p><xsl:apply-templates select="/ucalendar/error"/></p>
          </div>
        </xsl:if>
        <!-- <xsl:call-template name="alerts"/> -->
        <xsl:call-template name="tabs"/>
        <xsl:choose>
          <xsl:when test="/ucalendar/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/ucalendar/event"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='addEvent'">
            <xsl:call-template name="addEvent"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='editEvent'">
            <!-- edit an event -->
            <xsl:apply-templates select="/ucalendar/eventform"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='alarmOptions'">
            <xsl:call-template name="alarmOptions" />
          </xsl:when>
          <xsl:when test="/ucalendar/page='manageLocations'">
            <xsl:call-template name="manageLocations" />
          </xsl:when>
          <xsl:when test="/ucalendar/page='editLocation'">
            <!-- edit an event -->
            <xsl:apply-templates select="/ucalendar/locationform"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='calendars'">
            <!-- show a list of all calendars and manage subscriptions -->
            <xsl:apply-templates select="/ucalendar/calendars"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='other'">
            <!-- show an arbitrary page -->
            <xsl:call-template name="selectPage"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show the eventsCalendar -->
            <xsl:call-template name="navigation"/>
            <xsl:call-template name="userBar"/>
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/ucalendar/periodname='Day'">
                <xsl:call-template name="listView"/>
              </xsl:when>
              <xsl:when test="/ucalendar/periodname='Week' or /ucalendar/periodname=''">
                <xsl:choose>
                  <xsl:when test="/ucalendar/appvar[key='weekViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="weekView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="/ucalendar/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/ucalendar/appvar[key='monthViewMode']/value='list'">
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

  <!--==== HEAD SECTION  ====-->

  <xsl:template name="headSection">
     <title>Rensselaer Personal Calendar</title>
      <link rel="stylesheet" href="{$resourcesRoot}/en_US/default/rensselaer.css"/>
      <meta name="robots" content="noindex,nofollow"/>
      <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/en_US/default/rensselaer-print.css" />
      <link rel="icon" type="image/ico" href="http://www.rpi.edu/favicon.ico" />
      <script language="JavaScript">
        // launches new browser window with print-friendly version of page when
        // print icon is clicked
        function launchPrintWindow(URL) {
          printWindow = window.open(URL, "printWindow", "width=640,height=500,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes");
          window.printWindow.focus();
        }
      </script>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="headBar">
    <h1 id="titleBar">
      RENSSELAER PERSONAL CALENDAR
    </h1>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="http://www.rpi.edu"><img src="{$resourcesRoot}/images/rensselaer/std-rpilogo.gif" width="282" height="55" border="0" alt="Rensselaer"/></a></td>
        <td colspan="2" id="rpiLinksCell">
          <a href="{$publicCal}">Public Calendar</a> |
          <a href="http://www.rpi.edu">RPI Home</a> |
          <a href="http://www.rpi.edu/rpinfo">RPInfo</a> |
          <a href="http://www.rpi.edu/web/Campus.News">Campus.News</a> |
          <a href="http://helpdesk.rpi.edu/update.do?catcenterkey=51">
            Calendar Help
          </a>
          </td>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/rensselaer/metacal-topBorder.gif" width="100%" height="23" border="0"/></td>
        <td><img src="{$resourcesRoot}/images/rensselaer/metacal-topTitle.gif" width="373" height="23" border="0" alt="Rensselaer Polytechnic Institute Events Calendar"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/rensselaer/metacal-topBorder.gif" width="100%" height="23" border="0"/></td>
      </tr>
    </table>
    <div id="photo">
      <h2>Events Calendar</h2>
    </div>
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/ucalendar/page='eventscalendar'">
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Day'">
                  <a href="{$setView}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-day-on.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setView}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Week' or /ucalendar/periodname=''">
                  <a href="{$setView}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$setView}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Month'">
                  <a href="{$setView}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setView}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Year'">
                  <a href="{$setView}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setView}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="centerCell">
                <a href="setup.do">refresh view</a><!-- <a href="http://www.rpi.edu/dept/cct/apps/pubeventsxml/calendarfeatures.html">login</a> -->
                <!-- <span id="featureHighlight">switch view &#8594;</span> -->
            </td>
            <td class="rssPrint">
              <a href="javascript:window.print()" title="print this view">
                <img alt="print this view" src="{$resourcesRoot}/images/rensselaer/std-print-icon.gif" width="20" height="14" border="0"/> print
              </a>
              <a class="rss" href="http://helpdesk.rpi.edu/update.do?artcenterkey=255" title="RSS feed">RSS</a>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Day'">
                  <img src="{$resourcesRoot}/images/rensselaer/std-button-listview-off.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                </xsl:when>
                <xsl:when test="/ucalendar/periodname='Year'">
                  <img src="{$resourcesRoot}/images/rensselaer/std-button-calview-off.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                </xsl:when>
                <xsl:when test="/ucalendar/periodname='Month'">
                  <xsl:choose>
                    <xsl:when test="/ucalendar/appvar[key='monthViewMode']/value='list'">
                      <a href="{$setup}?setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-calview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=monthViewMode(list)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-listview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="/ucalendar/appvar[key='weekViewMode']/value='list'">
                      <a href="{$setup}?setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-calview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=weekViewMode(list)" title="toggle list/calendar view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-listview.gif" width="46" height="20" border="0" alt="toggle list/calendar view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rightCell">
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Year' or
                                (/ucalendar/periodname='Month' and
                                (/ucalendar/appvar[key='monthViewMode']/value='cal' or
                                 count(/ucalendar/appvar[key='monthViewMode'])=0)) or
                                (/ucalendar/periodname='Week' and
                                (/ucalendar/appvar[key='weekViewMode']/value='cal' or
                                 count(/ucalendar/appvar[key='weekViewMode'])=0))">
                  <xsl:choose>
                    <xsl:when test="/ucalendar/appvar[key='summaryMode']/value='details'">
                      <img src="{$resourcesRoot}/images/rensselaer/std-button-summary-off.gif" width="67" height="20" border="0" alt="only summaries of events supported in this view"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <img src="{$resourcesRoot}/images/rensselaer/std-button-details-off.gif" width="67" height="20" border="0" alt="only summaries of events supported in this view"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="/ucalendar/appvar[key='summaryMode']/value='details'">
                      <a href="{$setup}?setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-summary.gif" width="67" height="20" border="0" alt="toggle summary/detailed view"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$setup}?setappvar=summaryMode(details)" title="toggle summary/detailed view">
                        <img src="{$resourcesRoot}/images/rensselaer/std-button-details.gif" width="67" height="20" border="0" alt="toggle summary/detailed view"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setView}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setView}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setView}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setView}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/rensselaer/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="centerCell">
                &#160;<!--<a href="http://www.rpi.edu/dept/cct/apps/pubeventsxml/calendarfeatures.html">login</a>-->
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
          <a href="{$setView}?date={$prevdate}"><img src="{$resourcesRoot}/images/rensselaer/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$setView}?date={$nextdate}"><img src="{$resourcesRoot}/images/rensselaer/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/ucalendar/periodname='Day'">
              <xsl:value-of select="substring(/ucalendar/eventscalendar/year/month/week/day/name,1,3)"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/ucalendar/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/ucalendar/periodname='Week' or /ucalendar/periodname=''">
              Week of <xsl:value-of select="/ucalendar/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/ucalendar/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/ucalendar/periodname='Month'">
              <xsl:value-of select="/ucalendar/eventscalendar/year/month/longname"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="get" action="{$setView}">
             <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <xsl:if test="/ucalendar/periodname!='Year'">
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
                  <xsl:if test="/ucalendar/periodname!='Month'">
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
                  </xsl:if>
                </xsl:if>
                <td>
                  <xsl:variable name="temp" select="/ucalendar/yearvalues/start"/>
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
          <a href="{$setView}?viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/images/rensselaer/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
        </td>
        <!--
        <td class="rightCell">
          <form method="post" action="{$selectCalendar}">
            <select name="calId" onChange="submit()" >
              <option>select a calendar</option>
              <xsl:for-each select="/ucalendar/calendars/calendar">
                <xsl:variable name="id" select="id"/>
                <xsl:choose>
                  <xsl:when test="title=/ucalendar/title">
                    <option value="{$id}" selected="selected"><xsl:value-of select="title"/></option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{$id}"><xsl:value-of select="title"/></option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </form>
          <span class="calLinks"><a href="{$selectCalendar}?calId=">show all</a> | <a href="{$showCals}">calendar list</a></span>
        </td> -->
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="userBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="userBarTable">
       <tr>
         <td class="leftCell">
           Logged in as:
           <xsl:text> </xsl:text>
           <strong><xsl:value-of select="/ucalendar/userid"/></strong>
           <xsl:text> </xsl:text>
           <span class="logout"><a href="{$setup}?logout=true">logout</a></span>
           <!--<xsl:choose>
             <xsl:when test="/ucalendar/title!=''">
               Calendar: <xsl:value-of select="/ucalendar/title"/>
               <span class="link">[<a href="{$selectCalendar}?calId=">clear</a>]</span>
             </xsl:when>
             <xsl:when test="/ucalendar/search!=''">
               Current search: <xsl:value-of select="/ucalendar/search"/>
               <span class="link">[<a href="{$selectCalendar}?calId=">clear</a>]</span>
             </xsl:when>
             <xsl:otherwise>
               Current calendar: All
             </xsl:otherwise>
           </xsl:choose> -->
         </td>
         <td class="rightCell">
           <a href="{$initEvent}">Add Event</a> |
           <a href="{$manageLocations}">Manage Locations</a> |
           <a href="{$showCals}">Manage Subscriptions</a>
           <!-- <form name="calForm" method="get" action="{$selectCalendar}">Search: <input type="text" name="searchString" size="30" value=""/><input type="submit" value="go"/></form> -->
         </td>
       </tr>
    </table>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <table id="listTable" border="0" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="count(/ucalendar/eventscalendar/year/month/week/day/event)=0">
          <tr>
            <td class="noEventsCell">
              There are no events posted
              <xsl:choose>
                <xsl:when test="/ucalendar/periodname='Day'">
                  today<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
                </xsl:when>
                <xsl:when test="/ucalendar/periodname='Month'">
                  this month<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
                </xsl:when>
                <xsl:otherwise>
                  this week<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/ucalendar/eventscalendar/year/month/week/day[count(event)!=0]">
            <xsl:if test="/ucalendar/periodname='Week' or /ucalendar/periodname='Month' or /ucalendar/periodname=''">
              <tr>
                <td colspan="6" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <a href="{$setView}?viewType=dayView&amp;date={$date}">
                     <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                   </a>
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <tr>
                <xsl:variable name="dateRangeStyle">
                  <xsl:choose>
                    <xsl:when test="(start/hour24 = '0') and (end/hour24 = '0')">dateRangeCrossDay</xsl:when>
                    <xsl:when test="start/hour24 &lt; 6">dateRangeEarlyMorning</xsl:when>
                    <xsl:when test="start/hour24 &lt; 12">dateRangeMorning</xsl:when>
                    <xsl:when test="start/hour24 &lt; 18">dateRangeAfternoon</xsl:when>
                    <xsl:otherwise>dateRangeEvening</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <td class="{$dateRangeStyle}" style="text-align:right;">
                  <xsl:choose>
                    <xsl:when test="start/time!=''">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="parent::day/shortdate != start/shortdate">
                          <span class="littleArrow">&#171;</span>&#160;
                          <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="start/time"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        All day
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="{$dateRangeStyle}" style="text-align:center;padding:0em;">
                  <xsl:choose>
                    <xsl:when test="end/time!=''">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </xsl:when>
                    <xsl:otherwise>
                      &#160;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="{$dateRangeStyle}" style="text-align:left;">
                  <xsl:choose>
                    <xsl:when  test="end/time!=''">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="parent::day/shortdate != end/shortdate">
                          <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                          &#160;<span class="littleArrow">&#187;</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/time"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      &#160;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <xsl:variable name="descriptionClass">
                  <xsl:choose>
                    <xsl:when test="contains(summary,'CANCELLED')">description cancelled</xsl:when>
                    <xsl:otherwise>description</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <td class="{$descriptionClass}">
                  <xsl:choose>
                    <xsl:when test="/ucalendar/appvar[key='summaryMode']/value='details'">
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
                <td class="eventLinks">
                  <xsl:call-template name="eventLinks"/>
                </td>
                <td class="smallIcon">
                  <xsl:variable name="icalName" select="concat($id,'.ics')"/>
                  <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$icalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
                    <img src="{$resourcesRoot}/images/rensselaer/std-ical-icon-small.gif" width="12" height="16" border="0" align="left" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <xsl:template name="eventLinks">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:choose>
      <xsl:when test="kind='0'">
        <a href="{$editEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">Edit</a> |
        <xsl:choose>
          <xsl:when test="recurring=true">
            <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Delete All</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Delete</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="kind='1'">
        <xsl:choose>
          <xsl:when test="recurring=true">
            <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}">Remove All</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Remove</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$showCals}">Subscription</a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/ucalendar/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each select="/ucalendar/eventscalendar/year/month/week/day">
          <xsl:variable name="dayPos" select="position()"/>
          <xsl:if test="filler='false'">
            <td>
              <xsl:variable name="dayDate" select="date"/>
              <a href="{$initEvent}?date={$dayDate}" class="gridAdd">[add]</a>
              <a href="{$setView}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
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
        <xsl:for-each select="/ucalendar/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="/ucalendar/eventscalendar/year/month/week">
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
                  <a href="{$initEvent}?date={$dayDate}" class="gridAdd">[add]</a>
                  <a href="{$setView}?viewType=dayView&amp;date={$dayDate}" class="dayLink">
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
        <xsl:when test="contains(summary,'CANCELLED')">eventCancelled</xsl:when>
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
          Type:
          <xsl:choose>
            <xsl:when test="kind='0'">
              personal event, editable
            </xsl:when>
            <xsl:when test="kind='1'">
              public event
            </xsl:when>
            <xsl:otherwise>
              subscription
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </a>
    </li>
  </xsl:template>

  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <table id="yearCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[position() &lt;= 3]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[(position() &gt; 3) and (position() &lt;= 6)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[(position() &gt; 6) and (position() &lt;= 9)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/ucalendar/eventscalendar/year/month[position() &gt; 9]"/>
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
            <a href="{$setView}?viewType=monthView&amp;date={$firstDayOfMonth}">
              <xsl:value-of select="longname"/>
            </a>
          </td>
        </tr>
        <tr>
          <th>&#160;</th>
          <xsl:for-each select="/ucalendar/shortdaynames/val">
            <th><xsl:value-of select="."/></th>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="week">
          <tr>
            <td class="weekCell">
              <xsl:variable name="firstDayOfWeek" select="day/date"/>
              <a href="{$setView}?viewType=weekView&amp;date={$firstDayOfWeek}">
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
                    <a href="{$setView}?viewType=dayView&amp;date={$dayDate}">
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

  <!--==== CALENDAR LISTING / MANAGE SUBSCRIPTIONS ====-->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(/ucalendar/calendars/calendar)"/>
    <form name="subscriptionForm" method="post" action="{$subscribe}" id="subscriptions">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="calPageTable" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2">
            Calendar Subscriptions
          </th>
        </tr>
        <tr>
          <td colspan="2" class="infoCell">
            Subscribe to these calendars by checking the boxes, then click the Submit button &#62;&#62;&#160;
            <input name="submit" type="submit" value="Submit"/>
          </td>
        </tr>
        <tr>
          <td class="leftCell">
            <xsl:apply-templates select="calendar[position() &lt;= floor($topLevelCalCount div 2)]" mode="fullList"/>
          </td>
          <td>
            <xsl:apply-templates select="calendar[position() &gt; floor($topLevelCalCount div 2)]" mode="fullList"/>
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

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <table id="commonTable" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="3" id="commonHeader">
          <div id="eventActions">
            <xsl:choose>
              <xsl:when test="kind='0'">
                <a href="{$editEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                  Edit Event
                </a> |
                <xsl:choose>
                  <xsl:when test="recurring=true">
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}">
                      Delete All (recurring)
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                      Delete Event
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="kind='1'">
                <xsl:choose>
                  <xsl:when test="recurring=true">
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;confirmationid={$confId}">
                      Remove All (recurring)
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                      Remove
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$showCals}">
                  Manage Subscriptions
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <xsl:choose>
            <xsl:when test="kind='0'">
              Private Event
            </xsl:when>
            <xsl:when test="kind='1'">
              Public Event
            </xsl:when>
            <xsl:otherwise>
              Public Event from Subscription
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </tr>
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
        <th class="icon" rowspan="2">
          <xsl:variable name="icalName" select="concat($id,'.ics')"/>
          <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$icalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/images/rensselaer/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
          </a><!-- <br />
          [<a href="">help</a>] -->
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
        <td colspan="3" class="fieldval">
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
        <td colspan="3" class="fieldval">
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
          <td colspan="3" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sponsor/name!='none'">
        <tr>
          <td class="fieldname">Contact:</td>
          <td colspan="3" class="fieldval">
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
              <xsl:variable name="email" select="sponsor/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}?subject={$subject}">
                <xsl:value-of select="sponsor/email"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="calendar/name!=''">
        <tr>
          <td class="fieldname">Calendar:</td>
          <td class="fieldval"><xsl:value-of select="calendar/name"/></td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

 <!--==== ADD EVENT ====-->
  <xsl:template name="addEvent">
    <form name="addEventForm" method="post" action="{$addEventUsingPage}" id="standardForm">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="commonTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2" id="commonHeader">Add Event</th>
        </tr>
        <tr>
          <td class="fieldname">
            Title/Summary:
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="/ucalendar/eventform/form/title/input/@value"/>
            <input type="text" name="newEvent.summary" size="80" value="{$title}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Start Date/Time:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/eventform/form/startdate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/starttime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            End Date/Time:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/eventform/form/enddate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/endtime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Description:</td>
          <td class="fieldval">
            <textarea name="newEvent.description" rows="10" cols="60">
              <xsl:value-of select="/ucalendar/eventform/form/description/textarea"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Location:</td>
          <td class="fieldval" align="left">
            <span class="std-text">choose: </span>
            <xsl:copy-of select="/ucalendar/eventform/form/location/locationmenu/*"/>
            <span class="std-text"> or add new: </span>
            <xsl:copy-of select="/ucalendar/eventform/form/location/locationtext/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Event Link:</td>
          <td class="fieldval">
            <xsl:variable name="link" select="/ucalendar/eventform/form/link/input/@value"/>
            <input type="text" name="newEvent.link" size="80" value="{$link}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">&#160;</td>
          <td class="fieldval">
            <input name="submit" type="submit" value="Submit Event"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="eventform">
    <form name="editEventForm" method="post" action="{$editEvent}" id="standardForm">
      <input type="hidden" name="updateEvent" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="commonTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2" id="commonHeader">
            <div id="eventActions">
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <a href="{$eventView}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                View Event
              </a> |
              <a href="{$delEvent}?subid={$subscriptionId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                Delete Event
              </a>
            </div>
            Edit Event
          </th>
        </tr>
        <tr>
          <td class="fieldname">
            Title/Summary:
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="/ucalendar/eventform/form/title/input/@value"/>
            <input type="text" name="newEvent.summary" size="80" value="{$title}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Start Date/Time:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/eventform/form/startdate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/starttime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            End Date/Time:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/eventform/form/enddate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/eventform/form/endtime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Description:
          </td>
          <td class="fieldval">
            <textarea name="newEvent.description" rows="10" cols="60">
              <xsl:value-of select="/ucalendar/eventform/form/description/textarea"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Location:
          </td>
          <td class="fieldval" align="left">
            <span class="std-text">choose </span>
            <xsl:copy-of select="/ucalendar/eventform/form/location/locationmenu/*"/>
            <span class="std-text"><span class="bold">or</span> add </span>
            <xsl:copy-of select="/ucalendar/eventform/form/location/locationtext/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Event Link:
          </td>
          <td class="fieldval">
            <xsl:variable name="link" select="/ucalendar/eventform/form/link/input/@value"/>
            <input type="text" name="newEvent.link" size="80" value="{$link}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">&#160;</td>
          <td class="fieldval">
            <input name="submit" type="submit" value="Submit Event"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

   <!--==== ALARM OPTIONS ====-->
  <xsl:template name="alarmOptions">
    <form method="get" action="{$setAlarm}" id="standardForm">
      <input type="hidden" name="updateAlarmOptions" value="true"/>
      <table id="commonTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2" id="commonHeader">Alarm options</th>
        </tr>
        <tr>
          <td class="fieldname">
            Alarm Date/Time:
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmTriggerSelectorDate/*"/>
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmdate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmtime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            or Before/After event:
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmTriggerSelectorDuration/*"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmduration/days/*"/>
            days
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmduration/hours/*"/>
            hours
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmduration/minutes/*"/>
            minutes
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmduration/seconds/*"/>
            seconds OR:
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmduration/weeks/*"/>
            weeks
            &#160;
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmDurationBefore/*"/>
            before
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmDurationAfter/*"/>
            after
            &#160;
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmDurationRelStart/*"/>
            start
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/alarmDurationRelEnd/*"/>
            end
          </td>
        </tr>
        <tr>
          <td>
            <span class="required-field" title="required">*</span>
            Email Address:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Subject:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/alarmoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Continue"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
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

  <!--==== EMAIL OPTIONS ====-->
  <xsl:template name="emailOptions">
    <form method="get" action="{$mailEvent}" id="standardForm">
      <input type="hidden" name="updateEmailOptions" value="true"/>
      <table id="commonTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2" id="commonHeader">Update email options</th>
        </tr>
        <tr>
          <td>
            <span class="required-field" title="required">*</span>
            Email Address:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/emailoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Subject:
          </td>
          <td align="left">
            <xsl:copy-of select="/ucalendar/emailoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Continue"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
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

  <!--==== MANAGE LOCATIONS ====-->
  <xsl:template name="manageLocations">
    <form name="addLocationForm" method="post" action="{$addLocation}" id="standardForm">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table border="0" id="commonTable">
        <colgroup>
          <col span="1" class="fieldname"/>
          <col span="1" class="fieldval"/>
       </colgroup>
        <tr>
          <th colspan="2" id="commonHeader">Manage Locations</th>
        </tr>
        <tr>
          <th colspan="2" class="form-header">Add Location</th>
        </tr>
        <tr>
          <td>
            Main Address:
          </td>
          <td>
            <input size="60" name="newLocation.address" type="text"/>
          </td>
        </tr>
        <tr>
          <td>
            Subaddress:
          </td>
          <td>
            <input size="60" name="newLocation.subaddress" type="text"/>
          </td>
        </tr>
        <tr>
          <td>
            Location Link:
          </td>
          <td>
            <input size="60" name="newLocation.link" type="text"/>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="plain">
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
        <tr>
          <th colspan="2" class="form-header">Edit/Delete Locations</th>
        </tr>
        <td colspan="2" class="plain">
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

  <!--==== EDIT LOCATION ====-->
  <xsl:template match="locationform">
    <form name="editLocationForm" method="post" action="{$editLocation}" id="standardForm">
      <input type="hidden" name="updateLocation" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <table id="commonTable" cellpadding="0" cellspacing="0">
        <tr>
          <th colspan="2" id="commonHeader">
            <xsl:variable name="locId" select="/ucalendar/locationform/form/id"/>
            <div id="eventActions">
              <a href="{$delLocation}?locationId={$locId}">Delete Location</a>
            </div>
            Edit Location
          </th>
        </tr>
        <tr>
          <td class="fieldname">
            <span class="required-field" title="required">*</span>
            Address:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/locationform/form/address/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Subaddress:
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/locationform/form/subaddress/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Location's URL:</td>
          <td class="fieldval">
            <xsl:copy-of select="/ucalendar/locationform/form/link/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">&#160;</td>
          <td class="fieldval">
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
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
  <!-- not currently in use -->
  <xsl:template name="selectPage">
    <!-- <xsl:choose>
      <xsl:when test="/ucalendar/appvar[key='page']">
        <xsl:choose>
          <xsl:otherwise>
            <xsl:call-template name="noPage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> -->
        <xsl:call-template name="noPage"/>
      <!--</xsl:otherwise>
    </xsl:choose>-->
  </xsl:template>

  <xsl:template name="noPage">
    <p>
      Error: there is no page with that name.  Please select a navigational
      link to continue.
    </p>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      Maintained by
      <a href="http://www.rpi.edu/dotcio/cct.html">Communication &amp; Collaboration Technologies</a>,
      <a href="http://www.rpi.edu/dotcio">Division of the Chief Information Officer</a>,
      <a href="http://www.rpi.edu">Rensselaer Polytechnic Institute</a>.<br/>
      Please
      <a href="http://j2ee.rpi.edu/swf/setup.do?target=calendarcomments">
        contact us
      </a>
      with your questions and comments.
      <!-- <a href="" class="submitPublicEvent">Submit a public event.</a> -->
    </div>
    <table id="skinSelectorTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="leftCell">
          Based on the <a href="http://www.washington.edu/ucal/">University of Washington Calendar</a>
        </td>
        <td class="rightCell">
          <form name="skinSelectorForm" method="get" action="{$setup}">
            skin selector:
            <select name="skinNameSticky" onChange="submit()">
              <option>select a skin</option>
              <option value="default">Demo Calendar</option>
              <option value="rensselaer">Rensselaer</option>
              <option value="washington">Washington</option>
            </select>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
