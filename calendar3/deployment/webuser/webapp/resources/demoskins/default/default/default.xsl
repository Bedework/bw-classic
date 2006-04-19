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
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/setViewPeriod"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/eventView"/>
  <xsl:variable name="initEvent" select="/bedework/urlPrefixes/initEvent"/>
  <xsl:variable name="addEvent" select="/bedework/urlPrefixes/addEvent"/>
  <xsl:variable name="addEventUsingPage" select="/bedework/urlPrefixes/addEventUsingPage"/>
  <xsl:variable name="editEvent" select="/bedework/urlPrefixes/editEvent"/>
  <xsl:variable name="delEvent" select="/bedework/urlPrefixes/delEvent"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/export"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mailEvent"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/showPage"/>
  <xsl:variable name="manageLocations" select="/bedework/urlPrefixes/manageLocations"/>
  <xsl:variable name="addLocation" select="/bedework/urlPrefixes/addLocation"/>
  <xsl:variable name="editLocation" select="/bedework/urlPrefixes/editLocation"/>
  <xsl:variable name="delLocation" select="/bedework/urlPrefixes/delLocation"/>
  <xsl:variable name="initEventAlarm" select="/bedework/urlPrefixes/initEventAlarm"/>
  <xsl:variable name="setAlarm" select="/bedework/urlPrefixes/setAlarm"/>
  <xsl:variable name="initUpload" select="/bedework/urlPrefixes/initUpload"/>
  <xsl:variable name="upload" select="/bedework/urlPrefixes/upload"/>
  <xsl:variable name="getFreeBusy" select="/bedework/urlPrefixes/getFreeBusy/a/@href"/>
  <!-- calendars -->
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/fetchPublicCalendars"/>
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch/a/@href"/><!-- used -->
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions/a/@href"/><!-- used -->
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update/a/@href"/><!-- used -->
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedework/urlPrefixes/subscriptions/subscribe/a/@href"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/> -->

  <!-- Other generally useful global variables -->
  <xsl:variable name="confId" select="/bedework/confirmationid"/>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>

 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:call-template name="headSection"/>
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/bedework/message">
          <div id="messages">
            <xsl:apply-templates select="/bedework/message"/>
          </div>
        </xsl:if>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <table id="bodyBlock" cellspacing="0">
          <tr>
            <xsl:choose>
              <xsl:when test="/bedework/appvar[key='sidebar']/value='closed'">
                <td id="sideBarClosed">
                  <img src="{$resourcesRoot}/resources/spacer.gif" width="1" height="1" border="0" alt="*"/>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td id="sideBar">
                  <xsl:call-template name="sideBar"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
            <td id="bodyContent">
              <xsl:call-template name="tabs"/>
              <xsl:call-template name="navigation"/>
              <xsl:choose>
                <xsl:when test="/bedework/page='event'">
                  <!-- show an event -->
                  <xsl:apply-templates select="/bedework/event"/>
                </xsl:when>
                <xsl:when test="/bedework/page='addEvent'">
                  <xsl:call-template name="addEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='editEvent'">
                  <!-- edit an event -->
                  <xsl:apply-templates select="/bedework/formElements" mode="editEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='alarmOptions'">
                  <xsl:call-template name="alarmOptions" />
                </xsl:when>
                <xsl:when test="/bedework/page='upload'">
                  <xsl:call-template name="upload" />
                </xsl:when>
                <xsl:when test="/bedework/page='manageLocations'">
                  <xsl:call-template name="manageLocations" />
                </xsl:when>
                <xsl:when test="/bedework/page='editLocation'">
                  <!-- edit an event -->
                  <xsl:apply-templates select="/bedework/formElements" mode="editLocation"/>
                </xsl:when>
                <xsl:when test="/bedework/page='subscriptions' or /bedework/page='modSubscription'">
                  <xsl:apply-templates select="/bedework/subscriptions"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calendarList' or
                                /bedework/page='calendarDescriptions' or
                                /bedework/page='displayCalendar' or
                                /bedework/page='modCalendar' or
                                /bedework/page='deleteCalendarConfirm' or
                                /bedework/page='calendarReferenced'">
                  <xsl:apply-templates select="/bedework/calendars"/>
                </xsl:when>
                <xsl:when test="/bedework/page='freeBusy'">
                  <xsl:apply-templates select="/bedework/freebusy"/>
                </xsl:when>
                <xsl:when test="/bedework/page='other'">
                  <!-- show an arbitrary page -->
                  <xsl:call-template name="selectPage"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- otherwise, show the eventsCalendar -->
                  <xsl:call-template name="utilBar"/>
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
            </td>
          </tr>
        </table>
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==== HEAD SECTION  ====-->

  <xsl:template name="headSection">
    <title>Bedework: Personal Calendar Client</title>
    <meta name="robots" content="noindex,nofollow"/>
    <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
    <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/default/default/print.css" />
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
    <xsl:if test="/bedework/page='addEvent' or /bedework/page='editEvent'">
      <script type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
      <script type="text/javascript" src="{$resourcesRoot}/resources/bwClock.js"></script>
      <link rel="stylesheet" href="{$resourcesRoot}/resources/bwClock.css"/>
      <script type="text/javascript" src="{$resourcesRoot}/resources/dynCalendarWidget.js"></script>
      <link rel="stylesheet" href="{$resourcesRoot}/resources/dynCalendarWidget.css"/>
      <script type="text/javascript" src="{$resourcesRoot}/resources/browserSniffer.js"></script>
    </xsl:if>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="http://www.bedework.org/"><img src="{$resourcesRoot}/resources/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
          <h2>Personal Calendar</h2>
          <a href="{$publicCal}">Public Calendar</a> |
          <a href="http://www.yourschoolhere.edu">School Home</a> |
          <a href="http://www.bedework.org/">Other Link</a> |
          <a href="http://helpdesk.rpi.edu/update.do?catcenterkey=51">
            Example Calendar Help
          </a>
        </td>
      </tr>
    </table>
    <!--<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="50%"><img alt="" src="{$resourcesRoot}/resources/metacal-topBorder.gif" width="100%" height="23" border="0"/></td>
        <td><img src="{$resourcesRoot}/resources/metacal-topTitlePersonal.gif" width="221" height="23" border="0" alt="Bedework Personal Events Calendar"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/resources/metacal-topBorder.gif" width="100%" height="23" border="0"/></td>
      </tr>
    </table>-->
    <table id="curDateRangeTable"  cellspacing="0">
      <td class="sideBarOpenCloseIcon">
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='sidebar']/value='closed'">
            <a href="?setappvar=sidebar(opened)">
              <img alt="open sidebar" src="{$resourcesRoot}/resources/sideBarArrowOpen.gif" width="21" height="16" border="0" align="left"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="?setappvar=sidebar(closed)">
              <img alt="close sidebar" src="{$resourcesRoot}/resources/sideBarArrowClose.gif" width="21" height="16" border="0" align="left"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="date">
        <xsl:value-of select="/bedework/firstday/longdate"/>
        <xsl:if test="/bedework/periodname!='Day'">
          -
          <xsl:value-of select="/bedework/lastday/longdate"/>
        </xsl:if>
      </td>
      <td class="rssPrint">
        <a href="javascript:window.print()" title="print this view">
          <img alt="print this view" src="{$resourcesRoot}/resources/std-print-icon.gif" width="20" height="14" border="0"/> print
        </a>
        <a class="rss" href="{$setSelection}?calId=&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
      </td>
    </table>
  </xsl:template>

  <xsl:template name="sideBar">
    <h3>
      <img alt="manage views" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/> views
    </h3>
    <ul id="myViews">
      <xsl:choose>
        <xsl:when test="/bedework/views/view">
          <xsl:for-each select="/bedework/views/view">
            <xsl:variable name="viewName" select="name"/>
            <xsl:choose>
              <xsl:when test="/bedework/selectionState/selectionType = 'view'
                              and name=/bedework/selectionState/view/name">
                <li class="selected"><a href="{$setSelection}?viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:when>
              <xsl:otherwise>
                <li><a href="{$setSelection}?viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no subscriptions</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>

    <h3>
      <a href="{$calendar-fetch}">
        <img alt="manage calendars" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/> calendars
      </a>
    </h3>
    <ul class="calendarTree">
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar" mode="myCalendars"/>
    </ul>

    <h3>
      <a href="{$subscriptions-fetch}" title="manage subscriptions">
        <img alt="manage subscriptions" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/>
        subscriptions
      </a>
    </h3>
    <ul class="calendarTree">
      <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]">
          <xsl:apply-templates select="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]" mode="mySubscriptions"/>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no subscriptions</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>

    <h3>options</h3>
    <ul id="sideBarMenu">
      <li><a href="{$getFreeBusy}">Show Free/Busy</a></li>
      <li><a href="{$manageLocations}">Manage Locations</a></li>
      <li>Preferences</li>
    </ul>
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/bedework/page='eventscalendar'">
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-on.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                  <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Month'">
                  <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Year'">
                  <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rightCell">
              welcome
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}?logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setViewPeriod}?viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}?viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="rightCell">
              welcome
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}?logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="navigation">
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$setViewPeriod}?date={$prevdate}"><img src="{$resourcesRoot}/resources/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$setViewPeriod}?date={$nextdate}"><img src="{$resourcesRoot}/resources/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Year'">
              <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:value-of select="/bedework/firstday/monthname"/>, <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Week'">
              Week of <xsl:value-of select="substring-after(/bedework/firstday/longdate,', ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/firstday/longdate"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="todayButton">
          <a href="{$setViewPeriod}?viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/resources/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
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
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="utilBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="utilBarTable">
       <tr>
         <td class="leftCell">
           <xsl:choose>
             <xsl:when test="/bedework/periodname = 'day'">
               <xsl:variable name="date" select="/bedework/firstday/date"/>
               <a href="{$initEvent}?date={$date}" title="add event">
                  <img src="{$resourcesRoot}/resources/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="add event"/>
                  add event
               </a>
             </xsl:when>
             <xsl:otherwise>
               <a href="{$initEvent}" title="add event">
                  <img src="{$resourcesRoot}/resources/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="add event"/>
                  add event
               </a>
             </xsl:otherwise>
           </xsl:choose>
           <a href="{$initUpload}" title="upload event">
              <img src="{$resourcesRoot}/resources/std-icalUpload-icon-small.gif" width="12" height="16" border="0" alt="upload event"/>
              upload
           </a>
         </td>
         <td class="rightCell">
           <xsl:choose>
            <xsl:when test="/bedework/periodname='Day'">
              <img src="{$resourcesRoot}/resources/std-button-listview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Year'">
              <img src="{$resourcesRoot}/resources/std-button-calview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                  <a href="{$setup}?setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                    <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setup}?setappvar=monthViewMode(list)" title="toggle list/calendar view">
                    <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                  <a href="{$setup}?setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                    <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setup}?setappvar=weekViewMode(list)" title="toggle list/calendar view">
                    <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
           <xsl:choose>
              <xsl:when test="/bedework/periodname='Year' or
                              (/bedework/periodname='Month' and
                              (/bedework/appvar[key='monthViewMode']/value='cal' or
                               not(/bedework/appvar[key='monthViewMode']))) or
                              (/bedework/periodname='Week' and
                              (/bedework/appvar[key='weekViewMode']/value='cal' or
                               not(/bedework/appvar[key='weekViewMode'])))">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                    <img src="{$resourcesRoot}/resources/std-button-summary-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <img src="{$resourcesRoot}/resources/std-button-details-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                    <a href="{$setup}?setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                      <img src="{$resourcesRoot}/resources/std-button-summary.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}?setappvar=summaryMode(details)" title="toggle summary/detailed view">
                      <img src="{$resourcesRoot}/resources/std-button-details.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <a href="setup.do"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
         </td>
       </tr>
    </table>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <table id="listTable" border="0" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
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
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[event]">
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="6" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <a href="{$initEvent}?date={$date}" class="listAdd">
                     add event
                   </a>
                   <a href="{$setViewPeriod}?viewType=dayView&amp;date={$date}">
                     <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                   </a>
                 </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="calendarId" select="calendar/id"/>
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
                      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="summary"/>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="eventLinks">
                  <xsl:call-template name="eventLinks"/>
                </td>
                <td class="smallIcon">
                  <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                  <a href="{$export}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
                    <img src="{$resourcesRoot}/resources/std-ical_icon_small.gif" width="12" height="16" border="0" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
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
          <xsl:variable name="calendarId" select="calendar/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:choose>
      <xsl:when test="isAnnotation">
        <xsl:choose>
          <xsl:when test="recurring=true">
            <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;confirmationid={$confId}">Remove All</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Remove</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="calendar/owner = /bedework/userid">
        <a href="{$editEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">Edit</a> |
        <xsl:choose>
          <xsl:when test="recurring=true">
            <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Delete All</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">Delete</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$subscriptions-fetch}">Subscription</a>
      </xsl:otherwise>
    </xsl:choose>
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
              <a href="{$initEvent}?date={$dayDate}" class="gridAdd" title="add event">
                <img src="{$resourcesRoot}/resources/addEvent-forGrid-icon.gif" width="10" height="10" border="0" alt="add event"/>
              </a>
              <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}" class="dayLink" title="go to day">
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
                  <a href="{$initEvent}?date={$dayDate}" class="gridAdd" title="add event">
                    <img src="{$resourcesRoot}/resources/addEvent-forGrid-icon.gif" width="10" height="10" border="0" alt="add event"/>
                  </a>
                  <a href="{$setViewPeriod}?viewType=dayView&amp;date={$dayDate}" class="dayLink" title="go to day">
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
    <xsl:variable name="calendarId" select="calendar/id"/>
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
      <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass}">
        <xsl:value-of select="summary"/>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <strong><xsl:value-of select="summary"/></strong><br/>
          Time:
          <xsl:choose>
            <xsl:when test="start/allday = 'false'">
              <xsl:value-of select="start/time"/>
               - <xsl:value-of select="end/time"/>
            </xsl:when>
            <xsl:otherwise>
              all day
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            Location: <xsl:value-of select="location/address"/><br/>
          </xsl:if>
          Calendar: <xsl:value-of select="calendar/name"/>
          Type:
          <xsl:choose>
            <xsl:when test="isAnnotation">
              public event
            </xsl:when>
            <xsl:when test="calendar/owner = /bedework/userid">
              personal event, editable
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

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calendarId" select="calendar/id"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <h2>
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
    </h2>
    <table id="commonTable" cellspacing="0">
      <tr>
        <th colspan="3" class="commonHeader">
          <div id="eventActions">
            <xsl:choose>
              <xsl:when test="isAnnotation">
                <xsl:choose>
                  <xsl:when test="recurring=true">
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;confirmationid={$confId}">
                      Remove All (recurring)
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                      Remove
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="calendar/owner = /bedework/userid">
                <a href="{$editEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                  Edit Event
                </a> |
                <xsl:choose>
                  <xsl:when test="recurring=true">
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;confirmationid={$confId}">
                      Delete All (recurring)
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                      Delete Event
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$subscriptions-fetch}">
                  Manage Subscriptions
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <xsl:choose>
            <xsl:when test="isAnnotation">
              Public Event
            </xsl:when>
            <xsl:when test="calendar/owner = /bedework/userid">
              Personal Event
            </xsl:when>
            <xsl:otherwise>
              Public Event from Subscription
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </tr>
      <!--<tr>
        <td class="fieldname">Title:</td>
        <td class="fieldval">
          <strong>
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
          </strong>
        </td>
      </tr>-->
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
        <th class="icon" rowspan="2">
          <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
          <a href="{$export}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/resources/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
          </a><!-- <br />
          [<a href="">help</a>] -->
        </th>
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
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="organizer">
        <tr>
          <td class="fieldname">Organizer:</td>
          <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
          <td colspan="2" class="fieldval">
            <strong>
              <a href="{$organizerUri}">
                <xsl:value-of select="organizer/cn"/>
              </a>
            </strong>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="attendee">
        <tr>
          <td class="fieldname">Attendees:</td>
          <td colspan="3" class="fieldval">
            <table id="attendees" cellspacing="0">
              <tr>
                <th>role</th>
                <th>status</th>
                <th>attendee</th>
              </tr>
              <xsl:for-each select="attendee">
                <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                <tr>
                  <td class="role">
                    <xsl:value-of select="role"/>
                  </td>
                  <td class="status">
                    <xsl:value-of select="partstat"/>
                  </td>
                  <td>
                    <xsl:variable name="attendeeUri" select="attendeeUri"/>
                    <a href="{$attendeeUri}"><xsl:value-of select="cn"/></a>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </td>
        </tr>
      </xsl:if>
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
          <td class="fieldval">
            <xsl:variable name="calUrl" select="calendar/path"/>
            <a href="{$setSelection}?calUrl={$calUrl}">
              <xsl:value-of select="calendar/name"/>
            </a>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td class="fieldname filler">&#160;</td>
        <td class="fieldval">&#160;</td>
      </tr>
    </table>
  </xsl:template>

 <!--==== ADD EVENT ====-->
  <xsl:template name="addEvent">
    <form name="eventForm" method="post" action="{$addEventUsingPage}" id="standardForm">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <input type="hidden" name="endType" value="date"/>
      <h2>Add Event</h2>
      <table id="commonTable" cellspacing="0">
        <tr>
          <td class="fieldname">
            Title:
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="/bedework/formElements/form/title/input/@value"/>
            <input type="text" name="newEvent.summary" size="80" value="{$title}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Calendar:
          </td>
          <td class="fieldval">
            <select name="calendarId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="/bedework/formElements/form/calendar/select/*"/>
              <!--
              <xsl:for-each select="/bedework/myCalendars/calendars//calendar[calendarCollection='true']">
                <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
                  <xsl:variable name="calid" select="id"/>
                  <xsl:choose>
                    <xsl:when test="id = /bedework/formElements/calendarId">
                      <option value="{$calid}" selected="selected"><xsl:value-of select="name"/></option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$calid}"><xsl:value-of select="name"/></option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </xsl:for-each>-->
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Date &amp; Time:
          </td>
          <td class="fieldval">
            <!-- Set the timefields class for the first load of the page;
                 subsequent changes will take place using javascript without a
                 page reload. -->
            <xsl:variable name="timeFieldsClass">
              <xsl:choose>
                <xsl:when test="/bedework/formElements/form/allDay/input/@checked='checked'">invisible</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="/bedework/formElements/form/allDay/input/@checked='checked'">
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="on" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="on" id="allDayEndDateField"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField"/>
              </xsl:otherwise>
            </xsl:choose>
            all day event<br/>
            <div class="dateStartEndBox">
              <strong>Start:</strong>
              <div class="dateFields">
                <span class="startDateLabel">Date </span>
                <xsl:copy-of select="/bedework/formElements/form/start/month/*"/>
                <xsl:copy-of select="/bedework/formElements/form/start/day/*"/>
                <xsl:choose>
                  <xsl:when test="/bedework/creating = 'true'">
                    <xsl:copy-of select="/bedework/formElements/form/start/year/*"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="/bedework/formElements/form/start/yearText/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <script language="JavaScript" type="text/javascript">
              <xsl:comment>
                startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', 'startDateCalWidgetCallback');
              </xsl:comment>
              </script>
              <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <xsl:copy-of select="/bedework/formElements/form/start/hour/*"/>
                  <xsl:copy-of select="/bedework/formElements/form/start/minute/*"/>
                  <xsl:if test="/bedework/formElements/form/start/ampm">
                    <xsl:copy-of select="/bedework/formElements/form/start/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                </span>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>End:</strong>
              <xsl:choose>
                <xsl:when test="/bedework/formElements/form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              Date
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="/bedework/formElements/form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>invisible</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:copy-of select="/bedework/formElements/form/end/dateTime/month/*"/>
                  <xsl:copy-of select="/bedework/formElements/form/end/dateTime/day/*"/>
                  <xsl:choose>
                    <xsl:when test="/bedework/creating = 'true'">
                      <xsl:copy-of select="/bedework/formElements/form/end/dateTime/year/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="/bedework/formElements/form/end/dateTime/yearText/*"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <script language="JavaScript" type="text/javascript">
                <xsl:comment>
                  endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback');
                </xsl:comment>
                </script>
                <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <xsl:copy-of select="/bedework/formElements/form/end/dateTime/hour/*"/>
                    <xsl:copy-of select="/bedework/formElements/form/end/dateTime/minute/*"/>
                    <xsl:if test="/bedework/formElements/form/end/dateTime/ampm">
                      <xsl:copy-of select="/bedework/formElements/form/end/dateTime/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                  </span>
                </div>
              </div><br/>
              <div id="clock" class="invisible">
                <xsl:call-template name="clock"/>
              </div>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="/bedework/formElements/form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                Duration
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="/bedework/formElements/form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="durationHrMinClass">
                  <xsl:choose>
                    <xsl:when test="/bedework/formElements/form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>shown</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <xsl:choose>
                    <xsl:when test="/bedework/formElements/form/end/duration/weeks/input/@value = '0'">
                    <!-- we are using day, hour, minute format -->
                    <!-- must send either no week value or week value of 0 (zero) -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                        <xsl:variable name="daysStr" select="/bedework/formElements/form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="/bedework/formElements/form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/>hours
                          <xsl:variable name="minutesStr" select="/bedework/formElements/form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <xsl:variable name="weeksStr" select="/bedework/formElements/form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="true"/>weeks
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="/bedework/formElements/form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="true"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="/bedework/formElements/form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="true"/>hours
                          <xsl:variable name="minutesStr" select="/bedework/formElements/form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="true"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <xsl:variable name="weeksStr" select="/bedework/formElements/form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/>weeks
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div><br/>
              <div class="dateFields" id="noDuration">
                <xsl:choose>
                  <xsl:when test="/bedework/formElements/form/end/type='N'">
                    <input type="radio" name="eventEndType" value="N" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="N" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                This event has no duration / end date
              </div>
            </div>
          </td>
        </tr>
        <!--  Status  -->
        <tr>
          <td class="fieldname">
            Status:
          </td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="/bedework/formElements/form/status = 'TENTATIVE'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE" checked="checked"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:when>
              <xsl:when test="/bedework/formElements/form/status = 'CANCELLED'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED" checked="checked"/>cancelled
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="event.status" value="CONFIRMED" checked="checked"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Description:</td>
          <td class="fieldval">
            <textarea name="newEvent.description" cols="60" rows="4">
              <xsl:value-of select="/bedework/formElements/form/desc/textarea"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Location:</td>
          <td class="fieldval" align="left">
            <span class="std-text">choose: </span>
            <span id="eventFormLocationList">
              <select name="locationId">
                <option value="-1">select...</option>
                <xsl:copy-of select="/bedework/formElements/form/location/locationmenu/select/*"/>
              </select>
            </span>
            <span class="std-text"> or add new: </span>
            <input type="text" name="newLocation.address" value="" />
          </td>
        </tr>
        <tr>
          <td class="fieldname">Event Link:</td>
          <td class="fieldval">
            <xsl:variable name="link" select="/bedework/formElements/form/link/input/@value"/>
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

  <xsl:template name="clock">
    <div id="bwClock">
      <!-- Bedework 24-Hour Clock time selection widget
           used with resources/bwClock.js and resources/bwClock.css -->
      <div id="bwClockClock">
        <img id="clockMap" src="{$resourcesRoot}/resources/clockMap.gif" width="368" height="368" border="0" alt="" usemap="#bwClockMap" />
      </div>
      <div id="bwClockCover">
        <!-- this is a special effect div used simply to cover the pixelated edge
             where the clock meets the clock box title -->
      </div>
      <div id="bwClockBox">
        <h2>
          Bedework 24-Hour Clock
        </h2>
        <div id="bwClockDateTypeIndicator">
          type
        </div>
        <div id="bwClockTime">
          select time
        </div>
        <div id="bwClockCloseText">
          close
        </div>
        <div id="bwClockCloseButton">
          <a href="javascript:bwClockClose();">X</a>
        </div>
      </div>
      <map name="bwClockMap" id="bwClockMap">
        <area shape="rect" alt="close clock" title="close clock" coords="160,167, 200,200" href="javascript:bwClockClose()"/>
        <area shape="poly" alt="minute 00:55" title="minute 00:55" coords="156,164, 169,155, 156,107, 123,128" href="javascript:bwClockUpdateDateTimeForm('minute','55')" />
        <area shape="poly" alt="minute 00:50" title="minute 00:50" coords="150,175, 156,164, 123,128, 103,161" href="javascript:bwClockUpdateDateTimeForm('minute','50')" />
        <area shape="poly" alt="minute 00:45" title="minute 00:45" coords="150,191, 150,175, 103,161, 103,206" href="javascript:bwClockUpdateDateTimeForm('minute','45')" />
        <area shape="poly" alt="minute 00:40" title="minute 00:40" coords="158,208, 150,191, 105,206, 123,237" href="javascript:bwClockUpdateDateTimeForm('minute','40')" />
        <area shape="poly" alt="minute 00:35" title="minute 00:35" coords="171,218, 158,208, 123,238, 158,261" href="javascript:bwClockUpdateDateTimeForm('minute','35')" />
        <area shape="poly" alt="minute 00:30" title="minute 00:30" coords="193,218, 172,218, 158,263, 209,263" href="javascript:bwClockUpdateDateTimeForm('minute','30')" />
        <area shape="poly" alt="minute 00:25" title="minute 00:25" coords="209,210, 193,218, 209,261, 241,240" href="javascript:bwClockUpdateDateTimeForm('minute','25')" />
        <area shape="poly" alt="minute 00:20" title="minute 00:20" coords="216,196, 209,210, 241,240, 261,206" href="javascript:bwClockUpdateDateTimeForm('minute','20')" />
        <area shape="poly" alt="minute 00:15" title="minute 00:15" coords="216,178, 216,196, 261,206, 261,159" href="javascript:bwClockUpdateDateTimeForm('minute','15')" />
        <area shape="poly" alt="minute 00:10" title="minute 00:10" coords="209,164, 216,178, 261,159, 240,126" href="javascript:bwClockUpdateDateTimeForm('minute','10')" />
        <area shape="poly" alt="minute 00:05" title="minute 00:05" coords="196,155, 209,164, 238,126, 206,107" href="javascript:bwClockUpdateDateTimeForm('minute','05')" />
        <area shape="poly" alt="minute 00:00" title="minute 00:00" coords="169,155, 196,155, 206,105, 156,105" href="javascript:bwClockUpdateDateTimeForm('minute','00')" />
        <area shape="poly" alt="11 PM, 2300 hour" title="11 PM, 2300 hour" coords="150,102, 172,96, 158,1, 114,14" href="javascript:bwClockUpdateDateTimeForm('hour','23')" />
        <area shape="poly" alt="10 PM, 2200 hour" title="10 PM, 2200 hour" coords="131,114, 150,102, 114,14, 74,36" href="javascript:bwClockUpdateDateTimeForm('hour','22')" />
        <area shape="poly" alt="9 PM, 2100 hour" title="9 PM, 2100 hour" coords="111,132, 131,114, 74,36, 40,69" href="javascript:bwClockUpdateDateTimeForm('hour','21')" />
        <area shape="poly" alt="8 PM, 2000 hour" title="8 PM, 2000 hour" coords="101,149, 111,132, 40,69, 15,113" href="javascript:bwClockUpdateDateTimeForm('hour','20')" />
        <area shape="poly" alt="7 PM, 1900 hour" title="7 PM, 1900 hour" coords="95,170, 101,149, 15,113, 1,159" href="javascript:bwClockUpdateDateTimeForm('hour','19')" />
        <area shape="poly" alt="6 PM, 1800 hour" title="6 PM, 1800 hour" coords="95,196, 95,170, 0,159, 0,204" href="javascript:bwClockUpdateDateTimeForm('hour','18')" />
        <area shape="poly" alt="5 PM, 1700 hour" title="5 PM, 1700 hour" coords="103,225, 95,196, 1,205, 16,256" href="javascript:bwClockUpdateDateTimeForm('hour','17')" />
        <area shape="poly" alt="4 PM, 1600 hour" title="4 PM, 1600 hour" coords="116,245, 103,225, 16,256, 41,298" href="javascript:bwClockUpdateDateTimeForm('hour','16')" />
        <area shape="poly" alt="3 PM, 1500 hour" title="3 PM, 1500 hour" coords="134,259, 117,245, 41,298, 76,332" href="javascript:bwClockUpdateDateTimeForm('hour','15')" />
        <area shape="poly" alt="2 PM, 1400 hour" title="2 PM, 1400 hour" coords="150,268, 134,259, 76,333, 121,355" href="javascript:bwClockUpdateDateTimeForm('hour','14')" />
        <area shape="poly" alt="1 PM, 1300 hour" title="1 PM, 1300 hour" coords="169,273, 150,268, 120,356, 165,365" href="javascript:bwClockUpdateDateTimeForm('hour','13')" />
        <area shape="poly" alt="Noon, 1200 hour" title="Noon, 1200 hour" coords="193,273, 169,273, 165,365, 210,364" href="javascript:bwClockUpdateDateTimeForm('hour','12')" />
        <area shape="poly" alt="11 AM, 1100 hour" title="11 AM, 1100 hour" coords="214,270, 193,273, 210,363, 252,352" href="javascript:bwClockUpdateDateTimeForm('hour','11')" />
        <area shape="poly" alt="10 AM, 1000 hour" title="10 AM, 1000 hour" coords="232,259, 214,270, 252,352, 291,330" href="javascript:bwClockUpdateDateTimeForm('hour','10')" />
        <area shape="poly" alt="9 AM, 0900 hour" title="9 AM, 0900 hour" coords="251,240, 232,258, 291,330, 323,301" href="javascript:bwClockUpdateDateTimeForm('hour','09')" />
        <area shape="poly" alt="8 AM, 0800 hour" title="8 AM, 0800 hour" coords="263,219, 251,239, 323,301, 349,261" href="javascript:bwClockUpdateDateTimeForm('hour','08')" />
        <area shape="poly" alt="7 AM, 0700 hour" title="7 AM, 0700 hour" coords="269,194, 263,219, 349,261, 363,212" href="javascript:bwClockUpdateDateTimeForm('hour','07')" />
        <area shape="poly" alt="6 AM, 0600 hour" title="6 AM, 0600 hour" coords="269,172, 269,193, 363,212, 363,155" href="javascript:bwClockUpdateDateTimeForm('hour','06')" />
        <area shape="poly" alt="5 AM, 0500 hour" title="5 AM, 0500 hour" coords="263,150, 269,172, 363,155, 351,109" href="javascript:bwClockUpdateDateTimeForm('hour','05')" />
        <area shape="poly" alt="4 AM, 0400 hour" title="4 AM, 0400 hour" coords="251,130, 263,150, 351,109, 325,68" href="javascript:bwClockUpdateDateTimeForm('hour','04')" />
        <area shape="poly" alt="3 AM, 0300 hour" title="3 AM, 0300 hour" coords="234,112, 251,130, 325,67, 295,37" href="javascript:bwClockUpdateDateTimeForm('hour','03')" />
        <area shape="poly" alt="2 AM, 0200 hour" title="2 AM, 0200 hour" coords="221,102, 234,112, 295,37, 247,11" href="javascript:bwClockUpdateDateTimeForm('hour','02')" />
        <area shape="poly" alt="1 AM, 0100 hour" title="1 AM, 0100 hour" coords="196,96, 221,102, 247,10, 209,-1, 201,61, 206,64, 205,74, 199,75" href="javascript:bwClockUpdateDateTimeForm('hour','01')" />
        <area shape="poly" alt="Midnight, 0000 hour" title="Midnight, 0000 hour" coords="172,96, 169,74, 161,73, 161,65, 168,63, 158,-1, 209,-1, 201,61, 200,62, 206,64, 205,74, 198,75, 196,96, 183,95" href="javascript:bwClockUpdateDateTimeForm('hour','00')" />
      </map>
    </div>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="formElements" mode="editEvent">
    <form name="eventForm" method="post" action="{$editEvent}" id="standardForm">
      <input type="hidden" name="updateEvent" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <input type="hidden" name="endType" value="date"/>
      <h2>Edit Event</h2>
      <table id="commonTable" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">
            <div id="eventActions">
              <xsl:variable name="subscriptionId" select="subscriptionId"/>
              <xsl:variable name="calendarId" select="calendarId"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <a href="{$eventView}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                View Event
              </a> |
              <a href="{$delEvent}?subid={$subscriptionId}&amp;calid={$calendarId}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;confirmationid={$confId}">
                Delete Event
              </a>
            </div>
            Personal Event
          </th>
        </tr>
        <tr>
          <td class="fieldname">
            Title:
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="form/title/input/@value"/>
            <input type="text" name="editEvent.summary" size="80" value="{$title}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Calendar:
          </td>
          <td class="fieldval">
            <select name="calendarId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="/bedework/formElements/form/calendar/select/*"/>
              <!--
              <xsl:for-each select="/bedework/myCalendars/calendars//calendar[calendarCollection='true']">
                <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
                  <xsl:variable name="calid" select="id"/>
                  <xsl:choose>
                    <xsl:when test="id = /bedework/formElements/calendarId">
                      <option value="{$calid}" selected="selected"><xsl:value-of select="name"/></option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$calid}"><xsl:value-of select="name"/></option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </xsl:for-each>
              -->
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Date &amp; Time:
          </td>
          <td class="fieldval">
            <!-- Set the timefields class for the first load of the page;
                 subsequent changes will take place using javascript without a
                 page reload. -->
            <xsl:variable name="timeFieldsClass">
              <xsl:choose>
                <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="form/allDay/input/@checked='checked'">
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="on" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="on" id="allDayEndDateField"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField"/>
              </xsl:otherwise>
            </xsl:choose>
            all day event<br/>
            <div class="dateStartEndBox">
              <strong>Start:</strong>
              <div class="dateFields">
                <span class="startDateLabel">Date </span>
                <xsl:copy-of select="form/start/month/*"/>
                <xsl:copy-of select="form/start/day/*"/>
                <xsl:choose>
                  <xsl:when test="/bedework/creating = 'true'">
                    <xsl:copy-of select="form/start/year/*"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="form/start/yearText/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <script language="JavaScript" type="text/javascript">
              <xsl:comment>
                startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', 'startDateCalWidgetCallback');
              </xsl:comment>
              </script>
              <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <xsl:copy-of select="form/start/hour/*"/>
                  <xsl:copy-of select="form/start/minute/*"/>
                  <xsl:if test="form/start/ampm">
                    <xsl:copy-of select="form/start/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                </span>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>End:</strong>
              <xsl:choose>
                <xsl:when test="form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              Date
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>invisible</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:copy-of select="form/end/dateTime/month/*"/>
                  <xsl:copy-of select="form/end/dateTime/day/*"/>
                  <xsl:choose>
                    <xsl:when test="/bedework/creating = 'true'">
                      <xsl:copy-of select="form/end/dateTime/year/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="form/end/dateTime/yearText/*"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <script language="JavaScript" type="text/javascript">
                <xsl:comment>
                  endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback');
                </xsl:comment>
                </script>
                <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <xsl:copy-of select="form/end/dateTime/hour/*"/>
                    <xsl:copy-of select="form/end/dateTime/minute/*"/>
                    <xsl:if test="form/end/dateTime/ampm">
                      <xsl:copy-of select="form/end/dateTime/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                  </span>
                </div>
              </div><br/>
              <div id="clock" class="invisible">
                <xsl:call-template name="clock"/>
              </div>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                Duration
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="durationHrMinClass">
                  <xsl:choose>
                    <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>shown</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <xsl:choose>
                    <xsl:when test="form/end/duration/weeks/input/@value = '0'">
                    <!-- we are using day, hour, minute format -->
                    <!-- must send either no week value or week value of 0 (zero) -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/>hours
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="true"/>weeks
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="true"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="true"/>hours
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="true"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/>weeks
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div><br/>
              <div class="dateFields" id="noDuration">
                <xsl:choose>
                  <xsl:when test="form/end/type='N'">
                    <input type="radio" name="eventEndType" value="N" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="N" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                This event has no duration / end date
              </div>
            </div>
          </td>
        </tr>
        <!--  Status  -->
        <tr>
          <td class="fieldname">
            Status:
          </td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="form/status = 'TENTATIVE'">
                <input type="radio" name="editEvent.status" value="CONFIRMED"/>confirmed <input type="radio" name="editEvent.status" value="TENTATIVE" checked="checked"/>tentative <input type="radio" name="editEvent.status" value="CANCELLED"/>cancelled
              </xsl:when>
              <xsl:when test="form/status = 'CANCELLED'">
                <input type="radio" name="editEvent.status" value="CONFIRMED"/>confirmed <input type="radio" name="editEvent.status" value="TENTATIVE"/>tentative <input type="radio" name="editEvent.status" value="CANCELLED" checked="checked"/>cancelled
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="editEvent.status" value="CONFIRMED" checked="checked"/>confirmed <input type="radio" name="editEvent.status" value="TENTATIVE"/>tentative <input type="radio" name="editEvent.status" value="CANCELLED"/>cancelled
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Description:</td>
          <td class="fieldval">
            <textarea name="editEvent.description" cols="60" rows="4">
              <xsl:value-of select="/bedework/formElements/form/desc/textarea"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Location:</td>
          <td class="fieldval" align="left">
            <span class="std-text">choose: </span>
            <span id="eventFormLocationList">
              <select name="locationId">
                <option value="-1">select...</option>
                <xsl:copy-of select="/bedework/formElements/form/location/locationmenu/select/*"/>
              </select>
            </span>
            <span class="std-text"> or add new: </span>
            <input type="text" name="laddress" value="" />
          </td>
        </tr>
        <tr>
          <td class="fieldname">Event Link:</td>
          <td class="fieldval">
            <xsl:variable name="link" select="form/link/input/@value"/>
            <input type="text" name="editEvent.link" size="80" value="{$link}"/>
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

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template match="freebusy">
    <h2>Free / Busy</h2>
    <table id="freeBusy">
      <tr>
        <td>&#160;</td>
        <xsl:for-each select="day[position()=1]/period">
          <th>
            <xsl:choose>
              <xsl:when test="number(start) mod 200 = 0">
                <xsl:apply-templates select="start" mode="timeDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="day">
        <tr>
          <th>
            <xsl:value-of select="substring(start,1,4)"/>-<xsl:value-of select="substring(start,5,2)"/>-<xsl:value-of select="substring(start,7,2)"/>
          </th>
          <xsl:for-each select="period">
            <xsl:variable name="startTime"><xsl:apply-templates  select="start" mode="timeDisplay"/></xsl:variable>
            <xsl:choose>
              <xsl:when test="fbtype = '0'">
                <td class="busy">
                  <a href="" title="{$startTime}">*</a>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td class="free">
                  <a href="" title="{$startTime}">*</a>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>

    <table id="freeBusyKey">
      <tr>
        <td class="free">*</td>
        <td>free</td>
        <td>&#160;</td>
        <td class="busy">*</td>
        <td>busy</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="start" mode="timeDisplay">
    <xsl:choose>
      <xsl:when test="node()=0000">12am</xsl:when>
      <xsl:when test="node()=0100">1am</xsl:when>
      <xsl:when test="node()=0200">2am</xsl:when>
      <xsl:when test="node()=0300">3am</xsl:when>
      <xsl:when test="node()=0400">4am</xsl:when>
      <xsl:when test="node()=0500">5am</xsl:when>
      <xsl:when test="node()=0600">6am</xsl:when>
      <xsl:when test="node()=0700">7am</xsl:when>
      <xsl:when test="node()=0800">8am</xsl:when>
      <xsl:when test="node()=0900">9am</xsl:when>
      <xsl:when test="node()=1000">10am</xsl:when>
      <xsl:when test="node()=1100">11am</xsl:when>
      <xsl:when test="node()=1200">NOON</xsl:when>
      <xsl:when test="node()=1300">1pm</xsl:when>
      <xsl:when test="node()=1400">2pm</xsl:when>
      <xsl:when test="node()=1500">3pm</xsl:when>
      <xsl:when test="node()=1600">4pm</xsl:when>
      <xsl:when test="node()=1700">5pm</xsl:when>
      <xsl:when test="node()=1800">6pm</xsl:when>
      <xsl:when test="node()=1900">7pm</xsl:when>
      <xsl:when test="node()=2000">8pm</xsl:when>
      <xsl:when test="node()=2100">9pm</xsl:when>
      <xsl:when test="node()=2200">10pm</xsl:when>
      <xsl:when test="node()=2300">11pm</xsl:when>
      <xsl:when test="node()=2400">12am</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars">
    <h2>Manage Calendars</h2>
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Calendars</h3>
          <ul class="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedework/page='calendarDescriptions' or
                              /bedework/page='displayCalendar'">
                <xsl:apply-templates select="calendar" mode="listForDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="calendar" mode="listForUpdate"/>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedework/page='calendarList' or
                            /bedework/page='calendarReferenced'">
              <xsl:call-template name="calendarList"/>
            </xsl:when>
            <xsl:when test="/bedework/page='calendarDescriptions'">
              <xsl:call-template name="calendarDescriptions"/>
            </xsl:when>
            <xsl:when test="/bedework/page='displayCalendar'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="displayCalendar"/>
            </xsl:when>
            <xsl:when test="/bedework/page='deleteCalendarConfirm'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="deleteCalendarConfirm"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="addCalendar"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/currentCalendar" mode="modCalendar"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdate">
    <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
      <xsl:variable name="id" select="id"/>
      <xsl:variable name="itemClass">
        <xsl:choose>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <li class="{$itemClass}">
        <a href="{$calendar-fetchForUpdate}&amp;calId={$id}" title="update">
          <xsl:value-of select="name"/>
        </a>
        <xsl:if test="calendarCollection='false'">
          <xsl:text> </xsl:text>
          <a href="{$calendar-initAdd}&amp;calId={$id}" title="add a calendar or folder">
            <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="add a calendar or folder" border="0"/>
          </a>
        </xsl:if>
        <xsl:if test="calendar">
          <ul>
            <xsl:apply-templates select="calendar" mode="listForUpdate">
              <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>-->
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="calendar" mode="listForDisplay">
    <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
      <xsl:variable name="id" select="id"/>
      <xsl:variable name="itemClass">
        <xsl:choose>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <li class="{$itemClass}">
        <a href="{$calendar-fetchForDisplay}&amp;calId={$id}" title="display">
          <xsl:value-of select="name"/>
        </a>
        <xsl:if test="calendar">
          <ul>
            <xsl:apply-templates select="calendar" mode="listForDisplay">
              <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>-->
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3>Add Calendar / Folder</h3>
    <form name="addCalForm" action="{$calendar-update}">
      <table id="commonTable">
        <tr>
          <th>Name:</th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" size="40"/>
          </td>
        </tr>
        <tr>
          <th>Summary:</th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr>
          <th>Description:</th>
          <td>
            <textarea name="calendar.description" cols="40" rows="4">
              <xsl:value-of select="desc"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <th>Calendar/Folder:</th>
          <td>
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="radio" value="true" name="calendarCollection" checked="checked"/> Calendar
                <input type="radio" value="false" name="calendarCollection"/> Folder
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" value="true" name="calendarCollection"/> Calendar
                <input type="radio" value="false" name="calendarCollection" checked="checked"/> Folder
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addCalendar" value="Add Calendar/Folder"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:choose>
      <xsl:when test="calendarCollection='true'">
        <h3>Modify Calendar</h3>
      </xsl:when>
      <xsl:otherwise>
        <h3>Modify Folder</h3>
      </xsl:otherwise>
    </xsl:choose>
    <form name="modCalForm" action="{$calendar-update}">
      <table id="commonTable">
        <tr>
          <th>Path:</th>
          <td>
            <xsl:value-of select="path"/>
          </td>
        </tr>
        <tr>
          <th>Name:</th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <tr>
          <th>Mailing List ID:</th>
          <td>
            <xsl:value-of select="mailListId"/>
          </td>
        </tr>
        <tr>
          <th>Summary:</th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr>
          <th>Description:</th>
          <td>
            <textarea name="calendar.description" cols="40" rows="4">
              <xsl:value-of select="desc"/>
            </textarea>
          </td>
        </tr>
        <tr>
          <th>Calendar/Folder:</th>
          <td>
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="radio" value="true" name="calendarCollection" checked="checked"/> Calendar
                <input type="radio" value="false" name="calendarCollection"/> Folder
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" value="true" name="calendarCollection"/> Calendar
                <input type="radio" value="false" name="calendarCollection" checked="checked"/> Folder
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="submit" name="updateCalendar" value="Update Calendar"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateCalendar" value="Update Folder"/>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Reset"/>
          </td>
          <td align="right">
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="submit" name="delete" value="Delete Calendar"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="delete" value="Delete Folder"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="calendarList">
    <h3>Managing Calendars</h3>
    <ul>
      <li>Select an item from the calendar list on the left to modify
      a calendar or folder.</li>
      <li>Select the
      <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="true" border="0"/>
      icon to add a new calendar or folder to the tree.
        <ul>
          <li>Folders may only contain calendars and subfolders.</li>
          <li>Calendars may only contain events (and other calendar items).</li>
          <li>
            If a calendar is empty, it may be converted to a folder and vice
            versa.  If a calendar or folder are not empty, it may not be
            converted.
          </li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="calendarDescriptions">
    <h2>Calendar Information</h2>
    <ul>
      <li>Select an item from the calendar tree on the left to view all information
      about that calendar or folder.  The tree on the left represents the calendar
      heirarchy.</li>
    </ul>

    <p><strong>All Calendar Descriptions:</strong></p>
    <table id="flatCalendarDescriptions" cellspacing="0">
      <tr>
        <th>Name</th>
        <th>Description</th>
      </tr>
      <xsl:for-each select="//calendar">
        <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
          <xsl:variable name="descClass">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">even</xsl:when>
              <xsl:otherwise>odd</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr class="{$descClass}">
            <td>
              <xsl:value-of select="name"/>
            </td>
            <td>
              <xsl:value-of select="desc"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="displayCalendar">
    <h2>Calendar Information</h2>
    <table id="commonTable">
      <tr>
        <th>Name:</th>
        <td>
          <xsl:value-of select="name"/>
        </td>
      </tr>
      <tr>
        <th>Path:</th>
        <td>
          <xsl:value-of select="path"/>
        </td>
      </tr>
      <tr>
        <th>Summary:</th>
        <td>
          <xsl:value-of select="summary"/>
        </td>
      </tr>
      <tr>
        <th>Description:</th>
        <td>
          <xsl:value-of select="desc"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="deleteCalendarConfirm">
    <xsl:choose>
      <xsl:when test="calendarCollection='true'">
        <h3>Delete Calendar</h3>
        <p>
          The following calendar will be deleted.  Continue?
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3>Delete Folder</h3>
        <p>
          The following folder <em>and all its contents</em> will be deleted.
          Continue?
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" action="{$calendar-delete}">
      <table id="commonTable">
        <tr>
          <th>Path:</th>
          <td>
            <xsl:value-of select="path"/>
          </td>
        </tr>
        <tr>
          <th>Name:</th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <tr>
          <th>Summary:</th>
          <td>
            <xsl:value-of select="summary"/>
          </td>
        </tr>
        <tr>
          <th>Description:</th>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="cancelled" value="Cancel"/>
          </td>
          <td align="right">
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="submit" name="delete" value="Yes: Delete Calendar!"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="delete" value="Yes: Delete Folder!"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <!--+++++++++++++++ Subscriptions ++++++++++++++++++++-->
  <xsl:template match="subscriptions">
    <h2>Manage Subscriptions</h2>
    <table id="subsTable">
      <tr>
        <td class="cals">
          <h3>Public calendars</h3>
          <p class="smaller">
            Select a calendar below to add a <em><strong>new</strong></em>
            internal subscription. <!-- or
            <a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">
            subscribe to an external calendar</a>.-->
          </p>
          <ul class="calendarTree">
            <xsl:apply-templates select="/bedework/subscriptions/subscribe/calendars/calendar" mode="subscribe"/>
          </ul>
        </td>
        <td class="subs">
          <xsl:choose>
            <xsl:when test="/bedework/page='subscriptions'">
              <xsl:call-template name="subscriptionList"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="subscription" mode="addSubscription"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="subscription" mode="modSubscription"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="subscribe">
    <xsl:variable name="id" select="id"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <a href="{$subscriptions-initAdd}&amp;calId={$id}">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="subscribe">
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>-->
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="myCalendars">
    <!-- supress Inbox and Outbox for the moment -->
    <xsl:if test="(name != 'Inbox') and (name != 'Outbox')">
      <xsl:variable name="id" select="id"/>
      <xsl:variable name="itemClass">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                          and name = /bedework/selectionState/subscriptions/subscription/calendar/name">selected</xsl:when>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <li class="{$itemClass}">
        <xsl:variable name="url" select="path"/>
        <a href="{$setSelection}?calUrl={$url}">
          <xsl:value-of select="name"/>
        </a>
        <xsl:if test="calendar">
          <ul>
            <xsl:apply-templates select="calendar" mode="myCalendars"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="subscription" mode="addSubscription">
    <h3>Add New Subscription</h3>
    <p class="note">*the subsciption name must be unique</p>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table id="commonTable" cellspacing="0">
        <tr>
          <td class="fieldname">Name:</td>
          <td>
            <xsl:variable name="subName" select="name"/>
            <input type="text" value="{$subName}" name="subscription.name" size="60"/>
          </td>
        </tr>
        <xsl:if test="internal='false'">
          <tr>
            <td class="fieldname">Uri:</td>
            <td>
              <xsl:variable name="subUri" select="uri"/>
              <input type="text" value="{$subUri}" name="subscription.uri" size="60"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname">Display:</td>
          <td>
            <input type="radio" value="true" name="subscription.display" checked="checked"/> yes
            <input type="radio" value="false" name="subscription.display"/> no
          </td>
        </tr>
        <tr>
          <td class="fieldname">Style:</td>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input type="text" value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
        <!--<tr>
          <td class="fieldname">Unremovable:</td>
          <td>
            <input type="radio" value="true" name="unremoveable" size="60"/> true
            <input type="radio" value="false" name="unremoveable" size="60" checked="checked"/> false
          </td>
        </tr>-->
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addSubscription" value="Add Subscription"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="subscription" mode="modSubscription">
    <h3>Modify Subscription</h3>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table id="commonTable" cellspacing="0">
        <tr>
          <td class="fieldname">Name:</td>
          <td>
            <xsl:value-of select="name"/>
            <xsl:variable name="subName" select="name"/>
            <input type="hidden" value="{$subName}" name="name"/>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="internal='false'">
            <tr>
              <td class="fieldname">Uri:</td>
              <td>
                <xsl:variable name="subUri" select="uri"/>
                <input type="text" value="{$subUri}" name="subscription.uri" size="60"/>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td class="fieldname">Uri:</td>
              <td>
                <xsl:value-of select="uri"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
        <tr>
          <td class="fieldname">Display:</td>
          <td>
            <xsl:choose>
              <xsl:when test="display='true'">
                <input type="radio" value="true" name="subscription.display" checked="checked"/> yes
                <input type="radio" value="false" name="subscription.display"/> no
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" value="true" name="subscription.display"/> yes
                <input type="radio" value="false" name="subscription.display" checked="checked"/> no
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Style:</td>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input type="text" value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
        <!--<tr>
          <td class="fieldname">Unremovable:</td>
          <td>
            <xsl:choose>
              <xsl:when test="unremoveable='true'">
                <input type="radio" value="true" name="unremoveable" size="60" checked="checked"/> true
                <input type="radio" value="false" name="unremoveable" size="60"/> false
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" value="true" name="unremoveable" size="60"/> true
                <input type="radio" value="false" name="unremoveable" size="60" checked="checked"/> false
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>-->
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateSubscription" value="Update Subscription"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Reset"/>
          </td>
          <td align="right">
            <input type="submit" name="delete" value="Delete Subscription"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="subscriptionList">
    <h3>Current subscriptions</h3>
    <table id="commonTable" cellspacing="0">
      <tr>
        <th>Name</th>
        <th>URI</th>
        <th>Style</th>
        <th>Display</th>
        <!--<th>Unremovable</th>
        <th>External</th>
        <th>Deleted?</th>-->
      </tr>
      <xsl:for-each select="subscription">
        <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
        <tr>
          <td>
            <xsl:variable name="subname" select="name"/>
            <a href="{$subscriptions-fetchForUpdate}&amp;subname={$subname}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="uri"/>
          </td>
          <td>
            <xsl:value-of select="style"/>
          </td>
          <td class="center">
            <xsl:if test="display='true'">
              <img src="{$resourcesRoot}/resources/greenCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>
          <!--<td class="center">
            <xsl:if test="unremoveable='true'">
              <img src="{$resourcesRoot}/resources/redCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>
          <td class="center">
            <xsl:if test="internal='false'">
              <img src="{$resourcesRoot}/resources/greenCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>
          <td class="center">
            <xsl:if test="calendarDeleted='true'">
              <img src="{$resourcesRoot}/resources/redCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>-->
        </tr>
      </xsl:for-each>
    </table>
    <!--<h4><a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">Subscribe to a remote calendar</a> (by URI)</h4>-->
  </xsl:template>

  <xsl:template match="subscription" mode="mySubscriptions">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                        and name = /bedework/selectionState/subscriptions/subscription/calendar/name">selected</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <xsl:variable name="subUri" select="uri"/>
      <a href="{$setSelection}?calUrl={$subUri}">
        <xsl:value-of select="name"/>
      </a>
    </li>
  </xsl:template>

  <!--==== ALARM OPTIONS ====-->
  <xsl:template name="alarmOptions">
    <form method="get" action="{$setAlarm}" id="standardForm">
      <input type="hidden" name="updateAlarmOptions" value="true"/>
      <table id="commonTable" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">Alarm options</th>
        </tr>
        <tr>
          <td class="fieldname">
            Alarm Date/Time:
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmTriggerSelectorDate/*"/>
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmdate/*"/>
            <span class="std-text">at  </span>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmtime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            or Before/After event:
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmTriggerSelectorDuration/*"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/days/*"/>
            days
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/hours/*"/>
            hours
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/minutes/*"/>
            minutes
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/seconds/*"/>
            seconds OR:
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/weeks/*"/>
            weeks
            &#160;
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationBefore/*"/>
            before
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationAfter/*"/>
            after
            &#160;
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationRelStart/*"/>
            start
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationRelEnd/*"/>
            end
          </td>
        </tr>
        <tr>
          <td>
            Email Address:
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Subject:
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Continue"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== UPLOAD ====-->
  <xsl:template name="upload">
    <form method="post" action="{$upload}" id="standardForm"  enctype="multipart/form-data">
      <h2>Upload iCAL File</h2>
      <table id="commonTable" cellspacing="0">
        <tr>
          <td class="fieldname">
            Filename:
          </td>
          <td align="left">
            <input type="file" name="uploadFile" size="80" />
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Continue"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== EMAIL OPTIONS ====-->
  <xsl:template name="emailOptions">
    <form method="get" action="{$mailEvent}" id="standardForm">
      <input type="hidden" name="updateEmailOptions" value="true"/>
      <table id="commonTable" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">Update email options</th>
        </tr>
        <tr>
          <td>

            Email Address:
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/emailoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            Subject:
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/emailoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="Continue"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== MANAGE LOCATIONS ====-->
  <xsl:template name="manageLocations">
    <form name="addLocationForm" method="post" action="{$addLocation}" id="standardForm">
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <h2>Manage Locations</h2>
      <table id="commonTable" cellspacing="0">
        <tr>
          <th class="commonHeader" colspan="2">Add Location</th>
        </tr>
        <tr>
          <td class="fieldname">
            Main Address:
          </td>
          <td>
            <input size="60" name="newLocation.address" type="text"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Subaddress:
          </td>
          <td>
            <input size="60" name="newLocation.subaddress" type="text"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Location Link:
          </td>
          <td>
            <input size="60" name="newLocation.link" type="text"/>
          </td>
        </tr>
        <tr>
          <td></td>
          <td class="padMe">
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
        <tr>
          <th class="commonHeader" colspan="2">Edit/Delete Locations</th>
        </tr>
        <td colspan="2" class="plain">
          <ul>
            <xsl:for-each select="/bedework/formElements/form/location/locationmenu/select/option[@value>'3']">
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
  <xsl:template match="formElements" mode="editLocation">
    <form name="editLocationForm" method="post" action="{$editLocation}" id="standardForm">
      <input type="hidden" name="updateLocation" value="true"/>
      <input type="hidden" name="confirmationid" value="{$confId}"/>
      <h2>Manage Locations</h2>
      <table id="commonTable" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">
            <xsl:variable name="locId" select="form/id"/>
            <div id="eventActions">
              <a href="{$delLocation}?locationId={$locId}">Delete Location</a>
            </div>
            Edit Location
          </th>
        </tr>
        <tr>
          <td class="fieldname">
            Address:
          </td>
          <td align="left">
            <xsl:copy-of select="form/address/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Subaddress:
          </td>
          <td align="left">
            <xsl:copy-of select="form/subaddress/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Location's URL:
          </td>
          <td>
            <xsl:copy-of select="form/link/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td class="padMe">
            <input name="submit" type="submit" value="Submit Location"/>&#160;
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== SIDE CALENDAR MENU ====-->
  <xsl:template match="calendar" mode="sideList">
    <xsl:variable name="id" select="id"/>
    <div class="std-text">
      <a href="{$setSelection}?calId={$id}"><xsl:value-of select="title"/></a>
    </div>
  </xsl:template>

  <!--==== STAND-ALONE PAGES ====-->
  <!-- not currently in use -->
  <xsl:template name="selectPage">
    <!-- <xsl:choose>
      <xsl:when test="/bedework/appvar[key='page']">
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

  <!--==== UTILITY TEMPLATES ====-->

  <!-- search and replace template taken from
       http://www.biglist.com/lists/xsl-list/archives/200211/msg00337.html -->
  <xsl:template name="replace">
    <xsl:param name="string" select="''"/>
    <xsl:param name="pattern" select="''"/>
    <xsl:param name="replacement" select="''"/>
    <xsl:choose>
      <xsl:when test="$pattern != '' and $string != '' and contains($string, $pattern)">
        <xsl:value-of select="substring-before($string, $pattern)"/>
        <xsl:copy-of select="$replacement"/>
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
          <xsl:with-param name="replacement" select="$replacement"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      Demonstration calendar; place footer information here.
    </div>
    <table id="skinSelectorTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="leftCell">
          <a href="http://www.bedework.org/">Bedework Calendar</a> |
          <a href="?noxslt=yes">show XML</a> |
          <a href="?refreshXslt=yes">refresh XSLT</a>
        </td>
        <td class="rightCell">
          <!--<form name="skinSelectForm" method="get" action="{$setup}">
            skin selector:
            <select name="skinNameSticky" onChange="submit()">
              <option>select a skin</option>
              <option value="default">Demo Calendar</option>
              <option value="rensselaer">Rensselaer</option>
              <option value="washington">Washington</option>
            </select>
          </form>-->
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
