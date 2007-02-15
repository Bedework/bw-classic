<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="xhtml"
  indent="no"
  media-type="text/html"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  standalone="yes"
  omit-xml-declaration="yes"/>

  <!-- ========================================= -->
  <!--       PERSONAL CALENDAR STYLESHEET        -->
  <!-- ========================================= -->

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

  <!-- DEFINE INCLUDES -->
  <xsl:include href="/bedework-common/default/default/errors.xsl"/>
  <xsl:include href="/bedework-common/default/default/messages.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the personal calendar
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot">https://mywebserver.edu/myresourcesdir</xsl:variable>
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
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <!-- main -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/main/showPage"/>
  <!-- events -->
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="initEvent" select="/bedework/urlPrefixes/event/initEvent"/>
  <xsl:variable name="addEvent" select="/bedework/urlPrefixes/event/addEvent"/>
  <xsl:variable name="event-addEventRefComplete" select="/bedework/urlPrefixes/event/addEventRefComplete/a/@href"/>
  <xsl:variable name="event-showAccess" select="/bedework/urlPrefixes/event/showAccess/a/@href"/>
  <xsl:variable name="event-setAccess" select="/bedework/urlPrefixes/event/setAccess/a/@href"/>
  <xsl:variable name="event-selectCalForEvent" select="/bedework/urlPrefixes/event/selectCalForEvent/a/@href"/>
  <xsl:variable name="event-showRdates" select="/bedework/urlPrefixes/event/showRdates"/>
  <xsl:variable name="event-showExdates" select="/bedework/urlPrefixes/event/showExdates"/>
  <xsl:variable name="event-setRdate" select="/bedework/urlPrefixes/event/setRdate"/>
  <xsl:variable name="event-attendeesForEvent" select="/bedework/urlPrefixes/event/attendeesForEvent/a/@href"/>
  <xsl:variable name="event-showAttendeesForEvent" select="/bedework/urlPrefixes/event/showAttendeesForEvent/a/@href"/>
  <xsl:variable name="editEvent" select="/bedework/urlPrefixes/event/editEvent"/>
  <xsl:variable name="updateEvent" select="/bedework/urlPrefixes/event/updateEvent"/>
  <xsl:variable name="delEvent" select="/bedework/urlPrefixes/event/delEvent"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <!-- locations -->
  <xsl:variable name="location-initAdd" select="/bedework/urlPrefixes/location/initAdd/a/@href"/>
  <xsl:variable name="location-initUpdate" select="/bedework/urlPrefixes/location/initUpdate/a/@href"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedework/urlPrefixes/location/fetchForUpdate/a/@href"/>
  <xsl:variable name="location-update" select="/bedework/urlPrefixes/location/update/a/@href"/>
  <xsl:variable name="location-delete" select="/bedework/urlPrefixes/location/delete/a/@href"/>
  <!-- categories -->
  <xsl:variable name="category-initAdd" select="/bedework/urlPrefixes/category/initAdd/a/@href"/>
  <xsl:variable name="category-initUpdate" select="/bedework/urlPrefixes/category/initUpdate/a/@href"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedework/urlPrefixes/category/fetchForUpdate/a/@href"/>
  <xsl:variable name="category-update" select="/bedework/urlPrefixes/category/update/a/@href"/>
  <xsl:variable name="category-delete" select="/bedework/urlPrefixes/category/delete/a/@href"/>
  <!-- calendars -->
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars"/>
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch/a/@href"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions/a/@href"/>
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd/a/@href"/>
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate/a/@href"/>
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update/a/@href"/>
  <xsl:variable name="calendar-setAccess" select="/bedework/urlPrefixes/calendar/setAccess/a/@href"/>
  <xsl:variable name="calendar-trash" select="/bedework/urlPrefixes/calendar/trash/a/@href"/>
  <xsl:variable name="calendar-emptyTrash" select="/bedework/urlPrefixes/calendar/emptyTrash/a/@href"/>
  <xsl:variable name="calendar-listForExport" select="/bedework/urlPrefixes/calendar/listForExport/a/@href"/>
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-addSubByUri" select="/bedework/urlPrefixes/subscriptions/addSubByUri/a/@href"/>
  <xsl:variable name="subscriptions-subscribeByUri" select="/bedework/urlPrefixes/subscriptions/subscribeByUri/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedework/urlPrefixes/subscriptions/subscribe/a/@href"/>
  <!-- preferences -->
  <xsl:variable name="prefs-fetchForUpdate" select="/bedework/urlPrefixes/prefs/fetchForUpdate/a/@href"/>
  <xsl:variable name="prefs-update" select="/bedework/urlPrefixes/prefs/update/a/@href"/>
  <xsl:variable name="prefs-fetchSchedulingForUpdate" select="/bedework/urlPrefixes/prefs/fetchSchedulingForUpdate/a/@href"/>
  <xsl:variable name="prefs-setAccess" select="/bedework/urlPrefixes/prefs/setAccess/a/@href"/>
  <!-- scheduling -->
  <xsl:variable name="showInbox" select="/bedework/urlPrefixes/schedule/showInbox/a/@href"/>
  <xsl:variable name="showOutbox" select="/bedework/urlPrefixes/schedule/showOutbox/a/@href"/>
  <xsl:variable name="schedule-initAttendeeRespond" select="/bedework/urlPrefixes/schedule/initAttendeeRespond/a/@href"/>
  <xsl:variable name="schedule-attendeeRespond" select="/bedework/urlPrefixes/schedule/attendeeRespond/a/@href"/>
  <xsl:variable name="schedule-initAttendeeReply" select="/bedework/urlPrefixes/schedule/initAttendeeReply/a/@href"/>
  <xsl:variable name="schedule-processAttendeeReply" select="/bedework/urlPrefixes/schedule/processAttendeeReply/a/@href"/>
  <!-- misc (mostly import and export) -->
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export/a/@href"/>
  <xsl:variable name="initUpload" select="/bedework/urlPrefixes/misc/initUpload/a/@href"/>
  <xsl:variable name="upload" select="/bedework/urlPrefixes/misc/upload/a/@href"/>
  <!-- search -->
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <!-- mail -->
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  <!-- alarm -->
  <xsl:variable name="initEventAlarm" select="/bedework/urlPrefixes/alarm/initEventAlarm"/>
  <xsl:variable name="setAlarm" select="/bedework/urlPrefixes/alarm/setAlarm"/>
  <!-- free/busy -->
  <xsl:variable name="freeBusy-fetch" select="/bedework/urlPrefixes/freeBusy/fetch/a/@href"/>
  <xsl:variable name="freeBusy-setAccess" select="/bedework/urlPrefixes/freeBusy/setAccess/a/@href"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
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
      <xsl:variable name="inboxNumActive" select="/bedework/inboxState/numActive"/>
      <xsl:variable name="inboxChanged" select="/bedework/inboxState/changed"/>
      <body onload="checkStatus({$inboxNumActive},{$inboxChanged},'{$showInbox}')">
      <xsl:choose>
        <xsl:when test="/bedework/page='selectCalForEvent'">
          <xsl:call-template name="selectCalForEvent"/>
        </xsl:when>
        <xsl:when test="/bedework/page='rdates'">
          <xsl:call-template name="rdates"/>
        </xsl:when>
        <xsl:when test="/bedework/page='attendees'">
          <xsl:call-template name="attendees"/>
        </xsl:when>
        <xsl:when test="/bedework/page='eventAccess'">
          <xsl:call-template name="messagesAndErrors"/>
          <xsl:apply-templates select="/bedework/eventAccess"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="headBar"/>
            <xsl:call-template name="messagesAndErrors"/>
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
                  <xsl:call-template name="utilBar"/>
                  <xsl:choose>
                    <xsl:when test="/bedework/page='event'">
                      <!-- show an event -->
                      <xsl:apply-templates select="/bedework/event"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='addEvent'">
                      <xsl:apply-templates select="/bedework/formElements" mode="addEvent"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='editEvent'">
                      <xsl:apply-templates select="/bedework/formElements" mode="editEvent"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='addEventRef'">
                      <xsl:apply-templates select="/bedework/event" mode="addEventRef"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='alarmOptions'">
                      <xsl:call-template name="alarmOptions" />
                    </xsl:when>
                    <xsl:when test="/bedework/page='upload'">
                      <xsl:call-template name="upload" />
                    </xsl:when>
                    <xsl:when test="/bedework/page='categoryList'">
                      <xsl:call-template name="categoryList"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='modCategory'">
                      <xsl:call-template name="modCategory"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='deleteCategoryConfirm'">
                      <xsl:call-template name="deleteCategoryConfirm"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='locationList'">
                      <xsl:call-template name="locationList" />
                    </xsl:when>
                    <xsl:when test="/bedework/page='modLocation'">
                      <xsl:call-template name="modLocation"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='deleteLocationConfirm'">
                      <xsl:call-template name="deleteLocationConfirm"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='subscriptions' or
                                    /bedework/page='modSubscription' or
                                    /bedework/page='addSubByUri'">
                      <xsl:apply-templates select="/bedework/subscriptions"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='calendarList' or
                                    /bedework/page='calendarDescriptions' or
                                    /bedework/page='displayCalendar' or
                                    /bedework/page='modCalendar' or
                                    /bedework/page='deleteCalendarConfirm' or
                                    /bedework/page='calendarReferenced'">
                      <xsl:apply-templates select="/bedework/calendars" mode="manageCalendars"/>
                    </xsl:when>
                     <xsl:when test="/bedework/page='calendarListForExport'">
                      <xsl:apply-templates select="/bedework/calendars" mode="exportCalendars"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='freeBusy'">
                      <xsl:apply-templates select="/bedework/freebusy"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='modPrefs'">
                      <xsl:apply-templates select="/bedework/prefs"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='modSchedulingPrefs'">
                      <xsl:apply-templates select="/bedework/schPrefs"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='inbox'">
                      <xsl:apply-templates select="/bedework/inbox"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='outbox'">
                      <xsl:apply-templates select="/bedework/outbox"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='attendeeRespond'">
                      <xsl:apply-templates select="/bedework/formElements" mode="attendeeRespond"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='attendeeReply'">
                      <xsl:apply-templates select="/bedework/event" mode="attendeeReply"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='searchResult'">
                      <xsl:call-template name="searchResult"/>
                    </xsl:when>
                    <xsl:when test="/bedework/page='other'">
                      <!-- show an arbitrary page -->
                      <xsl:call-template name="selectPage"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- otherwise, show the eventsCalendar -->
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
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <!--==== HEAD SECTION  ====-->

  <xsl:template name="headSection">
    <title>Bedework: Personal Calendar Client</title>
    <meta name="robots" content="noindex,nofollow"/>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
    <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
    <link rel="stylesheet" href="{$resourcesRoot}/default/default/subColors.css"/>
    <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/default/default/print.css" />
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
    <!-- note: the non-breaking spaces in the script bodies below are to avoid
         losing the script closing tags (which avoids browser problems) -->
    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='addEventRef' or
                  /bedework/page='editEvent' or
                  /bedework/page='selectCalForEvent' or
                  /bedework/page='rdates' or
                  /bedework/page='upload' or
                  /bedework/page='addSubByUri' or
                  /bedework/page='modPrefs' or
                  /bedework/page='calendarListForExport' or
                  /bedework/page='attendeeRespond' or
                  /bedework/page='modSchedulingPrefs' or
                  /bedework/page='modCalendar' or
                  /bedework/page='eventAccess'">
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
    </xsl:if>
    <xsl:if test="/bedework/page='modSchedulingPrefs'">
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkPrefs.js">&#160;</script>
    </xsl:if>
    <xsl:if test="/bedework/page='modCalendar' or
                  /bedework/page='eventAccess'">
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkAccess.js">&#160;</script>
    </xsl:if>
    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='editEvent' or
                  /bedework/page='rdates' or
                  /bedework/page='calendarListForExport'">
      <script type="text/javascript" src="{$resourcesRoot}/resources/bwClock.js">&#160;</script>
      <link rel="stylesheet" href="{$resourcesRoot}/resources/bwClock.css"/>
      <script type="text/javascript" src="/bedework-common/javascript/dojo/dojo.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkEventForm.js">&#160;</script>
    </xsl:if>
    <script type="text/javascript">
      <xsl:comment>
      <![CDATA[
      // Check status of inbox and outbox and alert user appropriately.
      // Just take care of inbox for now.
      function checkStatus(inboxCount,changed,url) {
        if (inboxCount && changed) {
        alert("You have " + inboxCount + " pending meeting requests.");
        window.location.replace(url);
        }
      }
      ]]>
      </xsl:comment>
    </script>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="messagesAndErrors">
    <xsl:if test="/bedework/message">
      <ul id="messages">
        <xsl:for-each select="/bedework/message">
          <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <xsl:if test="/bedework/error">
      <ul id="errors">
        <xsl:for-each select="/bedework/error">
          <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>


  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="/bedework/"><img src="{$resourcesRoot}/resources/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
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
    <table id="curDateRangeTable"  cellspacing="0">
      <tr>
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
          <a class="rss" href="{$setup}&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="sideBar">
    <h3>
      <!--<img alt="manage views" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/>-->
      views
    </h3>
    <ul id="myViews">
      <xsl:choose>
        <xsl:when test="/bedework/views/view">
          <xsl:for-each select="/bedework/views/view">
            <xsl:variable name="viewName" select="name"/>
            <xsl:choose>
              <xsl:when test="/bedework/selectionState/selectionType = 'view'
                              and name=/bedework/selectionState/view/name">
                <li class="selected"><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:when>
              <xsl:otherwise>
                <li><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no views</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>

    <h3>
      <a href="{$calendar-fetch}">
        <img alt="manage calendars" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/> calendars
      </a>
    </h3>
    <!-- normal calendars -->
    <ul class="calendarTree">
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType &lt; 2]" mode="myCalendars"/>
    </ul>
    <!-- special calendars: inbox, outbox, and trash -->
    <ul class="calendarTree">
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 5]" mode="mySpecialCalendars"/> <!-- inbox -->
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 6]" mode="mySpecialCalendars"/> <!-- outbox -->
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 2]" mode="mySpecialCalendars"/> <!-- trash -->
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 3]" mode="mySpecialCalendars"/> <!-- deleted -->
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
      <li><a href="{$category-initUpdate}">Manage Categories</a></li>
      <li><a href="{$location-initUpdate}">Manage Locations</a></li>
      <li><a href="{$prefs-fetchForUpdate}">Preferences</a></li>
      <li><a href="{$initUpload}" title="upload event">Upload iCAL</a></li>
      <li><a href="{$calendar-listForExport}" title="upload event">Export Calendars</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/bedework/page='eventscalendar' or /bedework/page='freeBusy'">
        <xsl:variable name="navAction">
          <xsl:choose>
            <xsl:when test="/bedework/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <table cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  <a href="{$navAction}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-on.gif" width="90" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="90" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                  <a href="{$navAction}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Month'">
                  <a href="{$navAction}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <!-- don't allow switching to year for free busy view, so only use setViewPeriod action -->
                <xsl:when test="/bedework/periodname='Year'">
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rightCell">
              logged in as
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}&amp;logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="rightCell">
              logged in as
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}&amp;logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="navigation">
    <xsl:variable name="navAction">
      <xsl:choose>
        <xsl:when test="/bedework/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$navAction}&amp;date={$prevdate}"><img src="{$resourcesRoot}/resources/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$navAction}&amp;date={$nextdate}"><img src="{$resourcesRoot}/resources/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
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
          <a href="{$navAction}&amp;viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/resources/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="post" action="{$navAction}">
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
               <a href="{$initEvent}&amp;startdate={$date}" title="add event">
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

           <!-- search -->
           <xsl:if test="/bedework/page!='searchResult'">
             <form name="searchForm" method="post" action="{$search}">
               Search:
               <input type="text" name="query" size="15">
                 <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
               </input>
               <input type="submit" name="submit" value="go"/>
             </form>
           </xsl:if>

           <!-- show free / busy -->
           <xsl:choose>
             <xsl:when test="/bedework/periodname!='Year'">
               <xsl:choose>
                 <xsl:when test="/bedework/page='freeBusy'">
                   <a href="{$setViewPeriod}&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-button-events.gif" width="70" height="21" border="0" alt="show events"/></a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$freeBusy-fetch}&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-button-freebusy.gif" width="70" height="21" border="0" alt="show free/busy"/></a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <img src="{$resourcesRoot}/resources/std-button-freebusy-off.gif" width="70" height="21" border="0" alt="show free/busy"/>
             </xsl:otherwise>
           </xsl:choose>

           <!-- toggle list / calendar view -->
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
                   <a href="{$setup}&amp;setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=monthViewMode(list)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <xsl:choose>
                 <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                   <a href="{$setup}&amp;setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=weekViewMode(list)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:otherwise>
           </xsl:choose>

           <!-- summary / detailed mode toggle -->
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
                   <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                     <img src="{$resourcesRoot}/resources/std-button-summary.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=summaryMode(details)" title="toggle summary/detailed view">
                     <img src="{$resourcesRoot}/resources/std-button-details.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:otherwise>
           </xsl:choose>

           <!-- refresh button -->
           <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
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
              No events to display.
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[event]">
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="6" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <a href="{$initEvent}&amp;startdate={$date}" class="listAdd">
                     add event
                   </a>
                   <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
                     <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                   </a>
                 </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
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
                  <xsl:when test="start/shortdate = end/shortdate and
                                  start/time = end/time">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="start/time"/>
                      </a>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                    <xsl:when test="status='CANCELLED'">description bwStatusCancelled</xsl:when>
                    <xsl:when test="status='TENTATIVE'">description bwStatusTentative</xsl:when>
                    <xsl:otherwise>description</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="subStyle" select="subscription/subStyle"/>
                <td class="{$descriptionClass} {$subStyle}">
                  <xsl:if test="status='CANCELLED'"><strong>CANCELLED: </strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:choose>
                          <xsl:when test="summary = ''">
                            <em>no title</em>
                          </xsl:when>
                          <xsl:otherwise>
                            <strong>
                              <xsl:value-of select="summary"/>:
                            </strong>
                          </xsl:otherwise>
                        </xsl:choose>
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
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:choose>
                          <xsl:when test="summary = ''">
                            <em>no title</em>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="summary"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="eventLinks">
                  <xsl:call-template name="eventLinks"/>
                </td>
                <td class="smallIcon">
                  <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
                  <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
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
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
      <xsl:choose>
        <xsl:when test="recurring='true' or recurrenceId != ''">
          Edit:
          <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">master</a>,
          <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="edit instance (recurring event)">instance</a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit event">
            Edit
          </a>
          |
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="not(currentAccess/current-user-privilege-set/privilege/write-content)">
      <xsl:choose>
        <xsl:when test="recurring='true' or recurrenceId != ''">
          Link:
          <a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="add master event reference to a calendar">master</a>,
          <a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="add event reference to a calendar">instance</a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="add event reference to a calendar">
            Link
          </a>
          |
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="subscription and owner != /bedework/userid">
      <xsl:variable name="subname" select="subscription/name"/>
      <a href="{$subscriptions-fetchForUpdate}&amp;subname={$subname}" title="manage/view subscription">
        Subscription
      </a>
      |
    </xsl:if>
    <xsl:choose>
      <xsl:when test="recurring='true' or recurrenceId != ''">
        Delete:
        <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="delete master (recurring event)">all</a>,
        <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete instance (recurring event)">instance</a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete event">
          Delete
        </a>
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
              <xsl:if test="/bedework/now/date = date">
                <xsl:attribute name="class">today</xsl:attribute>
              </xsl:if>
              <xsl:variable name="dayDate" select="date"/>
              <a href="{$initEvent}&amp;startdate={$dayDate}" class="gridAdd" title="add event">
                <img src="{$resourcesRoot}/resources/addEvent-forGrid-icon.gif" width="9" height="10" border="0" alt="add event"/>
              </a>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink" title="go to day">
                <xsl:value-of select="value"/>
              </a>
              <xsl:if test="event">
                <ul>
                  <xsl:apply-templates select="event" mode="calendarLayout">
                    <xsl:with-param name="dayPos" select="$dayPos"/>
                  </xsl:apply-templates>
                </ul>
              </xsl:if>
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
                  <xsl:if test="/bedework/now/date = date">
                    <xsl:attribute name="class">today</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate" select="date"/>
                  <a href="{$initEvent}&amp;startdate={$dayDate}" class="gridAdd" title="add event">
                    <img src="{$resourcesRoot}/resources/addEvent-forGrid-icon.gif" width="10" height="10" border="0" alt="add event"/>
                  </a>
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink" title="go to day">
                    <xsl:value-of select="value"/>
                  </a>
                  <xsl:if test="event">
                    <ul>
                      <xsl:apply-templates select="event" mode="calendarLayout">
                        <xsl:with-param name="dayPos" select="$dayPos"/>
                      </xsl:apply-templates>
                    </ul>
                  </xsl:if>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--== EVENTS IN THE CALENDAR GRID ==-->
  <xsl:template match="event" mode="calendarLayout">
    <xsl:param name="dayPos"/>
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventRootClass">
      <xsl:choose>
        <!-- Otherwise: Alternating colors for all standard events -->
        <xsl:when test="position() = 1">event firstEvent</xsl:when>
        <xsl:otherwise>event</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <!-- Otherwise: Alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- User defined subscription styles.
         These are set in the add/modify subscription forms which
         rely (in this stylesheet) on subColors.css; if present, these
         override the background-color set by eventClass. User styles should
         not be used for cancelled events (tentative is ok). -->
    <xsl:variable name="subscriptionClass">
      <xsl:if test="status != 'CANCELLED' and
                    subscription/subStyle != '' and
                    subscription/subStyle != 'default'"><xsl:value-of select="subscription/subStyle"/></xsl:if>
    </xsl:variable>
    <li>
      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"
        class="{$eventRootClass} {$eventClass} {$subscriptionClass}">
        <xsl:if test="status='CANCELLED'">CANCELLED: </xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            (cont)
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            all day:
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="summary = ''">
            <em>no title</em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="summary"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled">CANCELLED</span></xsl:if>
          <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative">TENTATIVE</span></xsl:if>
          <xsl:choose>
            <xsl:when test="summary = ''">
              <em>no title</em>
            </xsl:when>
            <xsl:otherwise>
              <strong><xsl:value-of select="summary"/></strong><br/>
            </xsl:otherwise>
          </xsl:choose>
          Time:
          <xsl:choose>
            <xsl:when test="start/allday = 'false'">
              <xsl:value-of select="start/time"/>
              <xsl:if test="start/time != end/time">
                - <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              all day
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            Location: <xsl:value-of select="location/address"/><br/>
          </xsl:if>
          Calendar:
          <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
          <xsl:choose>
            <xsl:when test="contains(calendar/path,$userPath)">
              <xsl:value-of select="substring-after(calendar/path,$userPath)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="calendar/path"/>
            </xsl:otherwise>
          </xsl:choose><br/>
          Type:
          <xsl:if test="recurring='true' or recurrenceId != ''">
            recurring
          </xsl:if>
          <xsl:choose>
            <xsl:when test="owner = /bedework/userid">
              personal event
            </xsl:when>
            <xsl:when test="public = 'true'">
              public event
            </xsl:when>
            <xsl:otherwise>
              event (<xsl:value-of select="calendar/owner"/>)
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
            <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$firstDayOfMonth}">
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
              <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$firstDayOfWeek}">
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
                    <xsl:if test="/bedework/now/date = date">
                      <xsl:attribute name="class">today</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="dayDate" select="date"/>
                    <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}">
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
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2 class="{$statusClass}">
      <xsl:if test="status='CANCELLED'">CANCELLED: </xsl:if>
      <xsl:choose>
        <xsl:when test="link != ''">
          <xsl:variable name="link" select="link"/>
          <a href="{$link}">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:when test="summary = ''">
          Event <em>(no title)</em>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <table class="common" cellspacing="0">
      <tr>
        <th colspan="2" class="commonHeader">
          <div id="eventActions">
            <!-- download -->
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
              <img src="{$resourcesRoot}/resources/std-icalDownload-icon-small.gif" width="12" height="16" border="0" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
              Download
            </a>
            <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
              |
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <img src="{$resourcesRoot}/resources/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit master"/>
                  Edit:
                  <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">master</a>,<a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="edit instance (recurring event)">instance</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit event">
                    <img src="{$resourcesRoot}/resources/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit"/>
                    Edit
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="not(currentAccess/current-user-privilege-set/privilege/write-content)">
              |
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <img src="{$resourcesRoot}/resources/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                  Link:
                  <a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="add master event reference to a calendar">master</a>,<a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="add event reference to a calendar">instance</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$addEventRef}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="add event reference to a calendar">
                    <img src="{$resourcesRoot}/resources/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                    Link
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="subscription and owner != /bedework/userid">
              |
              <xsl:variable name="subname" select="subscription/name"/>
              <a href="{$subscriptions-fetchForUpdate}&amp;subname={$subname}" title="manage/view subscription">
                <img src="{$resourcesRoot}/resources/std-ical_iconSubsDkGray.gif" width="12" height="16" border="0" alt="manage/view subscription"/>
                Subscription
              </a>
            </xsl:if>
            |
            <xsl:choose>
              <xsl:when test="recurring='true' or recurrenceId != ''">
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                Delete:
                <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="delete master (recurring event)">all</a>,<a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete instance (recurring event)">instance</a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete event">
                  <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                  Delete
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <!-- Display type of event -->
          <xsl:if test="recurring='true' or recurrenceId != ''">
            Recurring
          </xsl:if>
          <xsl:choose>
            <xsl:when test="owner = /bedework/userid">
              Personal Event
            </xsl:when>
            <xsl:when test="public = 'true'">
              Public Event
            </xsl:when>
            <xsl:otherwise>
              Event (<xsl:value-of select="calendar/owner"/>)
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="recurring='true' and recurrenceId = ''">
            <em>(recurrence master)</em>
          </xsl:if>
        </th>
      </tr>
      <tr>
        <td class="fieldname">When:</td>
        <td class="fieldval">
          <!-- always display local time -->
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <xsl:if test="start/allday = 'false'">
            <span class="time"><xsl:value-of select="start/time"/></span>
          </xsl:if>
          <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate">
            <xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <span class="time"><em>(all day)</em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
          <!-- if timezones are not local, or if floating add labels: -->
          <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
            <xsl:text> </xsl:text>
            --
            <strong>
              <xsl:choose>
                <xsl:when test="start/floating = 'true'">
                  Floating time
                </xsl:when>
                <xsl:otherwise>
                  Local time
                </xsl:otherwise>
              </xsl:choose>
            </strong>
            <br/>
          </xsl:if>
          <!-- display in timezone if not local or floating time) -->
          <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
            <xsl:choose>
              <xsl:when test="start/timezone/id != end/timezone/id">
                <!-- need to display both timezones if they differ from start to end -->
                <table border="0" cellspacing="0" id="tztable">
                  <tr>
                    <td>
                      <strong>Start:</strong>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="start/timezone/islocal='true'">
                          <xsl:value-of select="start/dayname"/>,
                          <xsl:value-of select="start/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="start/timezone/dayname"/>,
                          <xsl:value-of select="start/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="start/timezone/id"/></strong>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <strong>End:</strong>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="end/timezone/islocal='true'">
                          <xsl:value-of select="end/dayname"/>,
                          <xsl:value-of select="end/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/timezone/dayname"/>,
                          <xsl:value-of select="end/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="end/timezone/id"/></strong>
                    </td>
                  </tr>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <!-- otherwise, timezones are the same: display as a single line  -->
                <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
                <xsl:if test="start/allday = 'false'">
                  <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                </xsl:if>
                <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                              ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
                <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                  <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/allday = 'true'">
                    <span class="time"><em>(all day)</em></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/time != start/timezone/time">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
                --
                <strong><xsl:value-of select="start/timezone/id"/></strong>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </td>
        <!--<th class="icon" rowspan="2">
          <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
          <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/resources/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
          </a>
        </th>-->
      </tr>
      <tr>
        <td class="fieldname">Where:</td>
        <td class="fieldval">
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
        <td class="fieldval">
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname">Status:</td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="organizer">
        <tr>
          <td class="fieldname">Organizer:</td>
          <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
          <td class="fieldval">
            <strong>
              <a href="{$organizerUri}">
                <xsl:choose>
                  <xsl:when test="organizer/cn != ''">
                    <xsl:value-of select="organizer/cn"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="organizer/organizerUri"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </strong>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="attendee">
        <tr>
          <td class="fieldname">Attendees:</td>
          <td class="fieldval">
            <table id="attendees" cellspacing="0">
              <tr>
                <th>attendee</th>
                <th>role</th>
                <th>status</th>
              </tr>
              <xsl:for-each select="attendee">
                <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
                <tr>
                  <td>
                    <xsl:variable name="attendeeUri" select="attendeeUri"/>
                    <a href="{$attendeeUri}">
                      <xsl:choose>
                        <xsl:when test="cn != ''">
                          <xsl:value-of select="cn"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="attendeeUri"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </a>
                  </td>
                  <td class="role">
                    <xsl:value-of select="role"/>
                  </td>
                  <td class="status">
                    <xsl:value-of select="partstat"/>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="recipient">
        <tr>
          <td class="fieldname">Recipients:</td>
          <td class="fieldval">
            <table id="attendees" cellspacing="0">
              <tr>
                <th>recipient</th>
              </tr>
              <xsl:for-each select="recipient">
                <tr>
                  <td>
                    <xsl:variable name="recipientUri" select="."/>
                    <a href="{$recipientUri}">
                      <xsl:value-of select="."/>
                    </a>
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
          <td class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname">See:</td>
          <td class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="contact/name!='none'">
        <tr>
          <td class="fieldname">Contact:</td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="contact/link=''">
                <xsl:value-of select="contact/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="contact/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="contact/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="contact/phone!=''">
              <br /><xsl:value-of select="contact/phone"/>
            </xsl:if>
            <xsl:if test="contact/email!=''">
              <br />
              <xsl:variable name="email" select="contact/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}&amp;subject={$subject}">
                <xsl:value-of select="contact/email"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="calendar/path!=''">
        <tr>
          <td class="fieldname">Calendar:</td>
          <td class="fieldval">
            <xsl:variable name="calUrl" select="calendar/encodedPath"/>
            <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
            <a href="{$setSelection}&amp;calUrl={$calUrl}">
              <xsl:choose>
                <xsl:when test="contains(calendar/path,$userPath)">
                  <xsl:value-of select="substring-after(calendar/path,$userPath)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="calendar/path"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="categories/category">
        <tr>
          <td class="fieldname">Categories:</td>
          <td class="fieldval">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
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
  <xsl:template match="formElements" mode="addEvent">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$addEvent}" id="standardForm" onsubmit="setEventFields(this)">
      <h2>
        <span class="formButtons">
          <input name="submit" type="submit" value="save event"/>
          <input name="cancelled" type="submit" value="cancel"/>
        </span>
        Add Event
      </h2>
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="formElements" mode="editEvent">
    <xsl:variable name="subscriptionId" select="subscriptionId"/>
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$updateEvent}" id="standardForm" onsubmit="setEventFields(this)">
      <h2>
        <span class="formButtons">
          <input name="submit" type="submit" value="save event"/>
          <input name="cancelled" type="submit" value="cancel"/>
        </span>
        Edit Event
      </h2>
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>


  <!--==== ADD and EDIT EVENT FORM ====-->
  <xsl:template match="formElements" mode="eventForm">
    <xsl:variable name="subscriptionId" select="subscriptionId"/>
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <input type="hidden" name="endType" value="date"/>

      <!-- event info for edit event -->
      <xsl:if test="/bedework/creating != 'true'">
        <table class="common" cellspacing="0">
          <tr>
            <th colspan="2" class="commonHeader">
              <div id="eventActions">
                <xsl:if test="not(form/recurringEntity = 'true' and recurrenceId = '')">
                  <!-- don't display if a master recurring event (because the master can't be viewed) -->
                  <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                    <img src="{$resourcesRoot}/resources/glassFill-icon-viewGray.gif" width="13" height="13" border="0" alt="view"/>
                    View
                  </a>
                    |
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="recurrenceId != ''">
                    <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                    Delete:
                    <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="delete master (recurring event)">all</a>,
                    <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete instance (recurring event)">instance</a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete event">
                      <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                      Delete
                      <xsl:if test="form/recurringEntity='true'">
                        all
                      </xsl:if>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <!-- Display type of event -->
              <xsl:if test="form/recurringEntity='true' or recurrenceId != ''">
                Recurring
              </xsl:if>
              <xsl:choose>
                <xsl:when test="form">
                  <!-- just a placeholder: need to add owner to the jsp -->
                  Personal Event
                </xsl:when>
                <xsl:when test="public = 'true'">
                  Public Event
                </xsl:when>
                <xsl:otherwise>
                  Event (<xsl:value-of select="calendar/owner"/>)
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="form/recurringEntity='true' and recurrenceId = ''">
                <em>(recurrence master)</em>
              </xsl:if>
            </th>
          </tr>
        </table>
      </xsl:if>

      <!-- event form submenu -->
      <xsl:choose>
        <xsl:when test="/bedework/creating = 'false'">
          <a href="javascript:launchSizedWindow('{$event-showAccess}',600,700)" id="eventAccessLink">set event access</a>
        </xsl:when>
        <xsl:otherwise>
          <a href="javascript:alert('Access/sharing may be set once an event is created.\n')" id="eventAccessLink">set event access</a>
        </xsl:otherwise>
      </xsl:choose>
      <ul id="eventFormTabs" class="submenu">
        <li class="selected">
          <a href="javascript:setTab('eventFormTabs',0); show('bwEventTab-Basic'); hide('bwEventTab-Details','bwEventTab-Recurrence');">
            basic
          </a>
        </li>
        <li>
          <a href="javascript:setTab('eventFormTabs',1); show('bwEventTab-Details'); hide('bwEventTab-Basic','bwEventTab-Recurrence');">
            details
          </a>
        </li>
        <li>
          <a href="javascript:setTab('eventFormTabs',2); show('bwEventTab-Recurrence'); hide('bwEventTab-Details','bwEventTab-Basic');">
            recurrence
          </a>
        </li>
      </ul>

    <!-- Basic tab -->
    <!-- ============== -->
    <!-- this tab is visible by default -->
    <div id="bwEventTab-Basic">
      <table cellspacing="0" class="common dottedBorder">
        <!--  Calendar in which to place event  -->
        <tr>
          <td class="fieldname">
            Calendar:
          </td>
          <td class="fieldval">
            <!-- the string "user/" should not be hard coded; fix in 3.3.1 -->
            <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
            <xsl:variable name="writableCalendars">
              <xsl:value-of select="
                count(/bedework/myCalendars//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content]) +
                count(/bedework/mySubscriptions//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content and
                       (not(contains(path,$userPath)))])"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="/bedework/creating = 'true' and $writableCalendars = 1">
                <!-- there is only 1 writable calendar, so find it by looking down both trees at once -->
                <xsl:variable name="newCalPath"><xsl:value-of select="/bedework/myCalendars//calendar[calType = '1' and
                         currentAccess/current-user-privilege-set/privilege/write-content]/path"/><xsl:value-of select="/bedework/mySubscriptions//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content and
                       (not(contains(path,$userPath)))]/path"/></xsl:variable>

                <input type="hidden" name="newCalPath" value="{$newCalPath}"/>

                <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>
                <span id="bwEventCalDisplay">
                  <xsl:choose>
                    <xsl:when test="contains($newCalPath,$userFullPath)">
                      <xsl:value-of select="substring-after($newCalPath,$userFullPath)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$newCalPath"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </span>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" name="newCalPath">
                  <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                </input>

                <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>
                <span id="bwEventCalDisplay">
                  <xsl:choose>
                    <xsl:when test="contains(form/calendar/path,$userFullPath)">
                      <xsl:value-of select="substring-after(form/calendar/path,$userFullPath)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="form/calendar/path"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> </xsl:text>
                  <!-- this final text element is required to avoid an empty
                       span element which is improperly rendered in the browser -->
                </span>

                <input type="button" onclick="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" value="select calendar" class="small"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Summary (title) of event  -->
        <tr>
          <td class="fieldname">
            Title:
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="form/title/input/@value"/>
            <input type="text" name="summary" size="80" value="{$title}"/>
          </td>
        </tr>

        <!--  Date and Time -->
        <!--  ============= -->
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

            <!-- date only event: anniversary event - often interpreted as "all day event" -->
            <xsl:choose>
              <xsl:when test="form/allDay/input/@checked='checked'">
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="true" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="true" id="allDayEndDateField"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="false" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="false" id="allDayEndDateField"/>
              </xsl:otherwise>
            </xsl:choose>
            all day (anniversary)

            <!-- floating event: no timezone (and not UTC) -->
            <xsl:choose>
              <xsl:when test="form/floating/input/@checked='checked'">
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.floating" value="true" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="true" id="endFloating"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off"/>
                <input type="hidden" name="eventStartDate.floating" value="false" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="false" id="endFloating"/>
              </xsl:otherwise>
            </xsl:choose>
            floating

            <!-- store time as coordinated universal time (UTC) -->
            <xsl:choose>
              <xsl:when test="form/storeUTC/input/@checked='checked'">
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="true" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="true" id="endStoreUTC"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="false" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="false" id="endStoreUTC"/>
              </xsl:otherwise>
            </xsl:choose>
            store as UTC

            <br/>
            <div class="dateStartEndBox">
              <strong>Start:</strong>
              <div class="dateFields">
                <span class="startDateLabel">Date </span>
                <span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetStartDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                  <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                  <xsl:text> </xsl:text>
                </span>
                <input type="hidden" name="eventStartDate.year">
                  <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                </input>
                <input type="hidden" name="eventStartDate.month">
                  <xsl:attribute name="value"><xsl:value-of select="form/start/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                </input>
                <input type="hidden" name="eventStartDate.day">
                  <xsl:attribute name="value"><xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                </input>
              </div>
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <xsl:copy-of select="form/start/hour/*"/>
                  <xsl:copy-of select="form/start/minute/*"/>
                  <xsl:if test="form/start/ampm">
                    <xsl:copy-of select="form/start/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0" alt="bwClock"/></a>

                  <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1">select timezone...</option>
                    <xsl:variable name="startTzId" select="form/start/tzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$startTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </span>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>End:</strong>
              <xsl:choose>
                <xsl:when test="form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
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
                  <span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetEndDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                    <xsl:attribute name="value"><xsl:value-of select="form/end/rfc3339DateTime"/></xsl:attribute>
                    <xsl:text> </xsl:text>
                  </span>
                  <input type="hidden" name="eventEndDate.year">
                    <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/yearText/input/@value"/></xsl:attribute>
                  </input>
                  <input type="hidden" name="eventEndDate.month">
                    <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                  </input>
                  <input type="hidden" name="eventEndDate.day">
                    <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                  </input>
                </div>
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <xsl:copy-of select="form/end/dateTime/hour/*"/>
                    <xsl:copy-of select="form/end/dateTime/minute/*"/>
                    <xsl:if test="form/end/dateTime/ampm">
                      <xsl:copy-of select="form/end/dateTime/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0" alt="bwClock"/></a>

                    <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      <option value="-1">select timezone...</option>
                      <xsl:variable name="endTzId" select="form/end/dateTime/tzid"/>
                      <xsl:for-each select="/bedework/timezones/timezone">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                            <xsl:if test="$endTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:for-each>
                    </select>
                  </span>
                </div>
              </div><br/>
              <div id="clock" class="invisible">
                <xsl:call-template name="clock"/>
              </div>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
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
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="disabled"/>weeks
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/>hours
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/>minutes
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
                    <input type="radio" name="eventEndType" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                This event has no duration / end date
              </div>
            </div>
          </td>
        </tr>

        <!--  Category  -->
        <tr>
          <td class="fieldname">
            Categories:
          </td>
          <td class="fieldval" align="left">
            <xsl:variable name="catCount" select="count(form/categories/all/category)"/>
            <xsl:choose>
              <xsl:when test="not(form/categories/all/category)">
                no categories defined
              </xsl:when>
              <xsl:otherwise>
                <table cellpadding="0" id="allCategoryCheckboxes">
                  <tr>
                    <td>
                      <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                        <input type="checkbox" name="categoryKey">
                          <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                          <xsl:if test="keyword = form/categories/current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:value-of select="keyword"/>
                        </input><br/>
                      </xsl:for-each>
                    </td>
                    <td>
                      <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                        <input type="checkbox" name="categoryKey">
                          <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                          <xsl:if test="keyword = form/categories/current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:value-of select="keyword"/>
                        </input><br/>
                      </xsl:for-each>
                    </td>
                  </tr>
                </table>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </div>


    <!-- Details tab -->
    <!-- ============== -->
    <div id="bwEventTab-Details" class="invisible">
      <!--<h3>Extra Information:</h3>-->
      <table cellspacing="0" class="common dottedBorder">
        <!--  Location  -->
        <tr>
          <td class="fieldname">Location:</td>
          <td class="fieldval" align="left">
            <span class="std-text">choose: </span>
            <span id="eventFormLocationList">
              <xsl:choose>
                <xsl:when test="/bedework/creating = 'true'">
                  <select name="locationUid">
                    <option value="-1">select...</option>
                    <xsl:copy-of select="form/location/locationmenu/select/*"/>
                  </select>
                </xsl:when>
                <xsl:otherwise>
                  <select name="eventLocationUid">
                    <option value="-1">select...</option>
                    <xsl:copy-of select="form/location/locationmenu/select/*"/>
                  </select>
                </xsl:otherwise>
              </xsl:choose>
            </span>
            <span class="std-text"> or add new: </span>
            <input type="text" name="locationAddress.value" value="" />
          </td>
        </tr>
        <!--  Link (url associated with event)  -->
        <tr>
          <td class="fieldname">Event Link:</td>
          <td class="fieldval">
            <xsl:variable name="link" select="form/link/input/@value"/>
            <input type="text" name="event.link" size="80" value="{$link}"/>
          </td>
        </tr>
        <!--  Description  -->
        <tr>
          <td class="fieldname">Description:</td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="normalize-space(form/desc/textarea) = ''">
                <textarea name="description" cols="60" rows="4">
                  <xsl:text> </xsl:text>
                </textarea>
                <!-- keep this space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:when>
              <xsl:otherwise>
                <textarea name="description" cols="60" rows="4">
                  <xsl:value-of select="form/desc/textarea"/>
                </textarea>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Scheduling type  -->
        <tr>
          <td class="fieldname">
            Type:
          </td>
          <td class="fieldval">
            <!-- need data for Edit Event! -->
            <input type="radio" name="schedule" size="80" value="" checked="checked"/>my event
            <input type="radio" name="schedule" size="80" value="request"/>meeting request
            <input type="radio" name="schedule" size="80" value="publish"/>published event
          </td>
        </tr>
        <!--  Recipients and Attendees  -->
        <tr>
          <td class="fieldname">
            Recipients &amp;<br/> Attendees:
          </td>
          <td class="fieldval posrelative">
            <!--<input type="button" value="Manage recipients and attendees" onclick="changeClass('recipientsAndAttendees','shown')"/>-->
            <input type="button" value="Manage recipients and attendees" onclick="launchSizedWindow('{$event-showAttendeesForEvent}','500','400')" class="small"/>
          </td>
        </tr>
        <!--  Status  -->
        <tr>
          <td class="fieldname">
            Status:
          </td>
          <td class="fieldval">
            <input type="radio" name="event.status" value="CONFIRMED">
              <xsl:if test="form/status = 'CONFIRMED' or /bedework/creating = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            confirmed
            <input type="radio" name="event.status" value="TENTATIVE">
              <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            tentative
            <input type="radio" name="event.status" value="CANCELLED">
              <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            cancelled
          </td>
        </tr>
        <!--  Transparency  -->
        <tr>
          <td class="fieldname">
            Effects free/busy:
          </td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="form/transparency = 'TRANSPARENT'">
                <input type="radio" name="event.transparency" value="OPAQUE"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="event.transparency" value="TRANSPARENT" checked="checked"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="event.transparency" value="OPAQUE" checked="checked"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="event.transparency" value="TRANSPARENT"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </div>


    <!-- Recurrence tab -->
    <!-- ============== -->
    <div id="bwEventTab-Recurrence" class="invisible">
      <xsl:choose>
        <xsl:when test="recurrenceId != ''">
          <!-- recurrence instances can not themselves recur,
               so provide access to master event -->
          <em>This event is a recurrence instance.</em><br/>
          <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">edit master event</a>
        </xsl:when>
        <xsl:otherwise>
          <!-- has recurrenceId, so is master -->

          <div id="recurringSwitch">
            <!-- set or remove "recurring" and show or hide all recurrence fields: -->
            <input type="radio" name="recurring" value="true" onclick="swapRecurrence(this)">
              <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input> event recurs
            <input type="radio" name="recurring" value="false" onclick="swapRecurrence(this)">
              <xsl:if test="form/recurringEntity = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input> event does not recur
          </div>

          <!-- wrapper for all recurrence fields (rrules and rdates): -->
          <div id="recurrenceFields" class="invisible">
            <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

            <!-- show or hide rrules fields: -->
            <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on"/>
            <span id="rrulesSwitch">
              <xsl:choose>
                <xsl:when test="form/recurrence">
                  change recurrence rules
                </xsl:when>
                <xsl:otherwise>
                  create recurrence rules
                </xsl:otherwise>
              </xsl:choose>
            </span>
            <span id="rrulesUiSwitch" class="invisible">
              <input type="checkbox" name="rrulesUiSwitch" value="advanced" onchange="swapVisible(this,'advancedRrules')"/>
              show advanced recurrence rules
            </span>

            <xsl:if test="form/recurrence">
              <!-- Output descriptive recurrence rules information.  Probably not
                   complete yet. Replace all strings so can be
                   more easily internationalized. -->
              <div id="recurrenceInfo">
                Every
                <xsl:choose>
                  <xsl:when test="form/recurrence/interval &gt; 1">
                    <xsl:value-of select="form/recurrence/interval"/>
                  </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="form/recurrence/freq = 'HOURLY'">hour</xsl:when>
                  <xsl:when test="form/recurrence/freq = 'DAILY'">day</xsl:when>
                  <xsl:when test="form/recurrence/freq = 'WEEKLY'">week</xsl:when>
                  <xsl:when test="form/recurrence/freq = 'MONTHLY'">month</xsl:when>
                  <xsl:when test="form/recurrence/freq = 'YEARLY'">year</xsl:when>
                </xsl:choose><xsl:if test="form/recurrence/interval &gt; 1">s</xsl:if>
                <xsl:text> </xsl:text>

                <xsl:if test="form/recurrence/byday">
                  <xsl:for-each select="form/recurrence/byday/pos">
                    <xsl:if test="position() != 1"> and </xsl:if>
                    on
                    <xsl:choose>
                      <xsl:when test="@val='1'">
                        the first
                      </xsl:when>
                      <xsl:when test="@val='2'">
                        the second
                      </xsl:when>
                      <xsl:when test="@val='3'">
                        the third
                      </xsl:when>
                      <xsl:when test="@val='4'">
                        the fourth
                      </xsl:when>
                      <xsl:when test="@val='5'">
                        the fifth
                      </xsl:when>
                      <xsl:when test="@val='-1'">
                        the last
                      </xsl:when>
                      <!-- don't output "every" -->
                      <!--<xsl:otherwise>
                        every
                      </xsl:otherwise>-->
                    </xsl:choose>
                    <xsl:for-each select="day">
                      <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
                      <xsl:variable name="dayVal" select="."/>
                      <xsl:variable name="dayPos">
                        <xsl:for-each select="/bedework/recurdayvals/val">
                          <xsl:if test="node() = $dayVal"><xsl:value-of select="position()"/></xsl:if>
                        </xsl:for-each>
                      </xsl:variable>
                      <xsl:value-of select="/bedework/shortdaynames/val[position() = $dayPos]"/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:if>

                <xsl:if test="form/recurrence/bymonth">
                  in
                  <xsl:for-each select="form/recurrence/bymonth/val">
                    <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
                    <xsl:variable name="monthNum" select="number(.)"/>
                    <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </xsl:if>

                <xsl:if test="form/recurrence/bymonthday">
                  on the
                  <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                  day<xsl:if test="form/recurrence/bymonthday/val[position()=2]">s</xsl:if> of the month
                </xsl:if>

                <xsl:if test="form/recurrence/byyearday">
                  on the
                  <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                  day<xsl:if test="form/recurrence/byyearday/val[position()=2]">s</xsl:if> of the year
                </xsl:if>

                <xsl:if test="form/recurrence/byweekno">
                  in the
                  <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                  week<xsl:if test="form/recurrence/byweekno/val[position()=2]">s</xsl:if> of the year
                </xsl:if>

                repeating
                <xsl:choose>
                  <xsl:when test="form/recurrence/count = '-1'">forever</xsl:when>
                  <xsl:when test="form/recurrence/until">
                    until <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="form/recurrence/count"/>
                    time<xsl:if test="form/recurrence/count &gt; 1">s</xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:if>

            <!-- set these dynamically when form is submitted -->
            <input type="hidden" name="interval" value=""/>
            <input type="hidden" name="count" value=""/>
            <input type="hidden" name="until" value=""/>
            <input type="hidden" name="byday" value=""/>
            <input type="hidden" name="bymonthday" value=""/>
            <input type="hidden" name="bymonth" value=""/>
            <input type="hidden" name="byweekno" value=""/>
            <input type="hidden" name="byyearday" value=""/>
            <input type="hidden" name="wkst" value=""/>
            <input type="hidden" name="setpos" value=""/>

            <!-- wrapper for rrules: -->
            <table id="rrulesTable" cellspacing="0" class="invisible">
              <tr>
                <td id="recurrenceFrequency" rowspan="2">
                  <strong>Frequency:</strong><br/>
                  <input type="radio" name="freq" value="NONE" onclick="showRrules(this.value)" checked="checked"/>none<br/>
                  <!--<input type="radio" name="freq" value="HOURLY" onclick="showRrules(this.value)"/>hourly<br/>-->
                  <input type="radio" name="freq" value="DAILY" onclick="showRrules(this.value)"/>daily<br/>
                  <input type="radio" name="freq" value="WEEKLY" onclick="showRrules(this.value)"/>weekly<br/>
                  <input type="radio" name="freq" value="MONTHLY" onclick="showRrules(this.value)"/>monthly<br/>
                  <input type="radio" name="freq" value="YEARLY" onclick="showRrules(this.value)"/>yearly
                </td>
                <!-- recurrence count, until, forever -->
                <td id="recurrenceUntil">
                  <div id="noneRecurrenceRules">
                    no recurrence rules
                  </div>
                  <div id="recurrenceUntilRules" class="invisible">
                    <strong>Repeat:</strong>
                    <p>
                      <input type="radio" name="recurCountUntil" value="forever">
                        <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      forever
                      <input type="radio" name="recurCountUntil" value="count" id="recurCount">
                        <xsl:if test="form/recurring/count != '-1'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      <input type="text" value="1" size="2" name="countHolder"  onfocus="selectRecurCountUntil('recurCount')">
                        <xsl:if test="form/recurring/count and form/recurring/count != '-1'">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurring/count"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      time(s)
                      <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                        <xsl:if test="form/recurring/until">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      until
                      <span id="untilHolder">
                        <span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetUntilDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                          <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                          <xsl:text> </xsl:text>
                        </span>
                      </span>
                    </p>
                  </div>
                </td>
              </tr>
              <tr>
                <td id="advancedRrules" class="invisible">
                  <!-- hourly -->
                  <div id="hourlyRecurrenceRules" class="invisible">
                    <p>
                      <strong>Interval:</strong>
                      every
                      <input type="text" name="hourlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      hour(s)
                    </p>
                  </div>
                  <!-- daily -->
                  <div id="dailyRecurrenceRules" class="invisible">
                    <p>
                      <strong>Interval:</strong>
                      every
                      <input type="text" name="dailyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      day(s)
                    </p>
                    <p>
                      <input type="checkbox" name="swapDayMonthCheckBoxList" value="" onclick="swapVisible(this,'dayMonthCheckBoxList')"/>
                      in these months:
                      <div id="dayMonthCheckBoxList" class="invisible">
                        <xsl:for-each select="/bedework/monthlabels/val">
                          <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                          <span class="chkBoxListItem">
                            <input type="checkbox" name="dayMonths">
                              <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                            </input>
                            <xsl:value-of select="."/>
                          </span>
                          <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                        </xsl:for-each>
                      </div>
                    </p>
                    <!--<p>
                      <input type="checkbox" name="swapDaySetPos" value="" onclick="swapVisible(this,'daySetPos')"/>
                      limit to:
                      <div id="daySetPos" class="invisible">
                      </div>
                    </p>-->
                  </div>
                  <!-- weekly -->
                  <div id="weeklyRecurrenceRules" class="invisible">
                    <p>
                      <strong>Interval:</strong>
                      every
                      <input type="text" name="weeklyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      week(s) on:
                    </p>
                    <p>
                      <div id="weekRecurFields">
                        <xsl:call-template name="byDayChkBoxList">
                          <xsl:with-param name="name">byDayWeek</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </p>
                    <p class="weekRecurLinks">
                      <a href="javascript:recurSelectWeekdays('weekRecurFields')">select weekdays</a> |
                      <a href="javascript:recurSelectWeekends('weekRecurFields')">select weekends</a>
                    </p>
                    <p>
                      Week start:
                      <select name="weekWkst">
                        <xsl:for-each select="/bedework/shortdaynames/val">
                          <xsl:variable name="pos" select="position()"/>
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </p>
                  </div>
                  <!-- monthly -->
                  <div id="monthlyRecurrenceRules" class="invisible">
                    <p>
                      <strong>Interval:</strong>
                      every
                      <input type="text" name="monthlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      month(s)
                    </p>
                    <div id="monthRecurFields">
                      <div id="monthRecurFields1">
                        on
                        <select name="bymonthposPos1" width="7em" onchange="changeClass('monthRecurFields2','shown')">
                          <xsl:call-template name="recurrenceDayPosOptions"/>
                        </select>
                        <xsl:call-template name="byDayChkBoxList"/>
                      </div>
                      <xsl:call-template name="buildRecurFields">
                        <xsl:with-param name="current">2</xsl:with-param>
                        <xsl:with-param name="total">10</xsl:with-param>
                        <xsl:with-param name="name">month</xsl:with-param>
                      </xsl:call-template>
                    </div>
                    <p>
                      <input type="checkbox" name="swapMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'monthDaysCheckBoxList')"/>
                      on these days:<br/>
                      <div id="monthDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">31</xsl:with-param>
                          <xsl:with-param name="name">monthDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </p>
                  </div>
                  <!-- yearly -->
                  <div id="yearlyRecurrenceRules" class="invisible">
                    <p>
                      <strong>Interval:</strong>
                      every
                      <input type="text" name="yearlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      years(s)
                    </p>
                    <div id="yearRecurFields">
                      <div id="yearRecurFields1">
                        on
                        <select name="byyearposPos1" width="7em" onchange="changeClass('yearRecurFields2','shown')">
                          <xsl:call-template name="recurrenceDayPosOptions"/>
                        </select>
                        <xsl:call-template name="byDayChkBoxList"/>
                      </div>
                      <xsl:call-template name="buildRecurFields">
                        <xsl:with-param name="current">2</xsl:with-param>
                        <xsl:with-param name="total">10</xsl:with-param>
                        <xsl:with-param name="name">year</xsl:with-param>
                      </xsl:call-template>
                    </div>
                    <p>
                      <input type="checkbox" name="swapYearMonthCheckBoxList" value="" onclick="swapVisible(this,'yearMonthCheckBoxList')"/>
                      in these months:
                      <div id="yearMonthCheckBoxList" class="invisible">
                        <xsl:for-each select="/bedework/monthlabels/val">
                          <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                          <span class="chkBoxListItem">
                            <input type="checkbox" name="yearMonths">
                              <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                            </input>
                            <xsl:value-of select="."/>
                          </span>
                          <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                        </xsl:for-each>
                      </div>
                    </p>
                    <p>
                      <input type="checkbox" name="swapYearMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'yearMonthDaysCheckBoxList')"/>
                      on these days of the month:<br/>
                      <div id="yearMonthDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">31</xsl:with-param>
                          <xsl:with-param name="name">yearMonthDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </p>
                    <p>
                      <input type="checkbox" name="swapYearWeeksCheckBoxList" value="" onclick="swapVisible(this,'yearWeeksCheckBoxList')"/>
                      in these weeks of the year:<br/>
                      <div id="yearWeeksCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">53</xsl:with-param>
                          <xsl:with-param name="name">yearWeekBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </p>
                    <p>
                      <input type="checkbox" name="swapYearDaysCheckBoxList" value="" onclick="swapVisible(this,'yearDaysCheckBoxList')"/>
                      on these days of the year:<br/>
                      <div id="yearDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">366</xsl:with-param>
                          <xsl:with-param name="name">yearDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </p>
                    <p>
                      Week start:
                      <select name="yearWkst">
                        <xsl:for-each select="/bedework/shortdaynames/val">
                          <xsl:variable name="pos" select="position()"/>
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </p>
                  </div>
                </td>
              </tr>
            </table>
            <!-- recurrence dates (rdates) -->
            <div id="recurrenceDatesButton">
              <input type="button" value="manage recurrence &amp; exception dates" onclick="launchSizedWindow('{$event-showRdates}','560','400')"/>
            </div>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <div class="eventSubmitButtons">
      <input name="submit" type="submit" value="save event"/>
      <input name="cancelled" type="submit" value="cancel"/>
    </div>
  </xsl:template>

  <xsl:template match="val" mode="weekMonthYearNumbers">
    <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
    <xsl:value-of select="."/><xsl:choose>
      <xsl:when test="substring(., string-length(.)-1, 2) = '11' or
                      substring(., string-length(.)-1, 2) = '12' or
                      substring(., string-length(.)-1, 2) = '13'">th</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '1'">st</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '2'">nd</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '3'">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

  <xsl:template name="byDayChkBoxList">
    <xsl:param name="name"/>
    <xsl:for-each select="/bedework/shortdaynames/val">
      <xsl:variable name="pos" select="position()"/>
      <input type="checkbox">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      </input>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="buildCheckboxList">
    <xsl:param name="current"/>
    <xsl:param name="end"/>
    <xsl:param name="name"/>
    <xsl:param name="splitter">10</xsl:param>
    <span class="chkBoxListItem">
      <input type="checkbox">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$current"/></xsl:attribute>
      </input>
      <xsl:value-of select="$current"/>
    </span>
    <xsl:if test="$current mod $splitter = 0"><br/></xsl:if>
    <xsl:if test="$current = $end"><br/></xsl:if>
    <xsl:if test="$current &lt; $end">
      <xsl:call-template name="buildCheckboxList">
        <xsl:with-param name="current"><xsl:value-of select="$current + 1"/></xsl:with-param>
        <xsl:with-param name="end"><xsl:value-of select="$end"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="recurrenceDayPosOptions">
    <option value="0">none</option>
    <option value="1">the first</option>
    <option value="2">the second</option>
    <option value="3">the third</option>
    <option value="4">the fourth</option>
    <option value="5">the fifth</option>
    <option value="-1">the last</option>
    <option value="">every</option>
  </xsl:template>

  <xsl:template name="buildRecurFields">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <xsl:param name="name"/>
    <div class="invisible">
      <xsl:attribute name="id"><xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current"/></xsl:attribute>
      and
      <select width="12em">
        <xsl:attribute name="name">by<xsl:value-of select="$name"/>posPos<xsl:value-of select="$current"/></xsl:attribute>
        <xsl:if test="$current != $total">
          <xsl:attribute name="onchange">changeClass('<xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current+1"/>','shown')</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="recurrenceDayPosOptions"/>
      </select>
      <xsl:call-template name="byDayChkBoxList"/>
    </div>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildRecurFields">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="buildNumberOptions">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <option value="{$current}"><xsl:value-of select="$current"/></option>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildNumberOptions">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="clock">
    <div id="bwClock">
      <!-- Bedework 24-Hour Clock time selection widget
           used with resources/bwClock.js and resources/bwClock.css -->
      <div id="bwClockClock">
        <img id="clockMap" src="{$resourcesRoot}/resources/clockMap.gif" width="368" height="368" border="0" alt="bwClock" usemap="#bwClockMap" />
      </div>
      <div id="bwClockCover">
        &#160;
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
        <div id="bwClockSwitch">
          switch
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
        <area shape="poly" alt="minute 00:05" title="minute 00:05" coords="196,155, 209,164, 238,126, 206,107" href="javascript:bwClockUpdateDateTimeForm('minute','5')" />
        <area shape="poly" alt="minute 00:00" title="minute 00:00" coords="169,155, 196,155, 206,105, 156,105" href="javascript:bwClockUpdateDateTimeForm('minute','0')" />
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
        <area shape="poly" alt="9 AM, 0900 hour" title="9 AM, 0900 hour" coords="251,240, 232,258, 291,330, 323,301" href="javascript:bwClockUpdateDateTimeForm('hour','9')" />
        <area shape="poly" alt="8 AM, 0800 hour" title="8 AM, 0800 hour" coords="263,219, 251,239, 323,301, 349,261" href="javascript:bwClockUpdateDateTimeForm('hour','8')" />
        <area shape="poly" alt="7 AM, 0700 hour" title="7 AM, 0700 hour" coords="269,194, 263,219, 349,261, 363,212" href="javascript:bwClockUpdateDateTimeForm('hour','7')" />
        <area shape="poly" alt="6 AM, 0600 hour" title="6 AM, 0600 hour" coords="269,172, 269,193, 363,212, 363,155" href="javascript:bwClockUpdateDateTimeForm('hour','6')" />
        <area shape="poly" alt="5 AM, 0500 hour" title="5 AM, 0500 hour" coords="263,150, 269,172, 363,155, 351,109" href="javascript:bwClockUpdateDateTimeForm('hour','5')" />
        <area shape="poly" alt="4 AM, 0400 hour" title="4 AM, 0400 hour" coords="251,130, 263,150, 351,109, 325,68" href="javascript:bwClockUpdateDateTimeForm('hour','4')" />
        <area shape="poly" alt="3 AM, 0300 hour" title="3 AM, 0300 hour" coords="234,112, 251,130, 325,67, 295,37" href="javascript:bwClockUpdateDateTimeForm('hour','3')" />
        <area shape="poly" alt="2 AM, 0200 hour" title="2 AM, 0200 hour" coords="221,102, 234,112, 295,37, 247,11" href="javascript:bwClockUpdateDateTimeForm('hour','2')" />
        <area shape="poly" alt="1 AM, 0100 hour" title="1 AM, 0100 hour" coords="196,96, 221,102, 247,10, 209,-1, 201,61, 206,64, 205,74, 199,75" href="javascript:bwClockUpdateDateTimeForm('hour','1')" />
        <area shape="poly" alt="Midnight, 0000 hour" title="Midnight, 0000 hour" coords="172,96, 169,74, 161,73, 161,65, 168,63, 158,-1, 209,-1, 201,61, 200,62, 206,64, 205,74, 198,75, 196,96, 183,95" href="javascript:bwClockUpdateDateTimeForm('hour','0')" />
      </map>
    </div>
  </xsl:template>

  <xsl:template name="rdates">
    <div id="bwDialogBox">
      <form name="rdatesForm" id="rdates" action="{$event-setRdate}" method="post" onsubmit="setRdateDatetime(this)">
        <h4 id="dialogTitle">
          Recurrence and Exception Dates
        </h4>
        <div id="raContent">
          <div class="dateStartEndBox" id="rdatesFormFields">
            <div class="dateFields">
              <input name="eventRdate.date"
                     dojoType="dropdowndatepicker"
                     formatLength="medium"
                     value="today"
                     saveFormat="yyyyMMdd"
                     id="bwEventWidgeRdate"
                     iconURL="{$resourcesRoot}/resources/calIcon.gif"/>
            </div>
            <div id="rdateTimeFields" class="timeFields">
             <select name="eventRdate.hour">
                <option value="00">00</option>
                <option value="01">01</option>
                <option value="02">02</option>
                <option value="03">03</option>
                <option value="04">04</option>
                <option value="05">05</option>
                <option value="06">06</option>
                <option value="07">07</option>
                <option value="08">08</option>
                <option value="09">09</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12" selected="selected">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
                <option value="19">19</option>
                <option value="20">20</option>
                <option value="21">21</option>
                <option value="22">22</option>
                <option value="23">23</option>
              </select>
              <select name="eventRdate.minute">
                <option value="00" selected="selected">00</option>
                <option value="05">05</option>
                <option value="10">10</option>
                <option value="15">15</option>
                <option value="20">20</option>
                <option value="25">25</option>
                <option value="30">30</option>
                <option value="35">35</option>
                <option value="40">40</option>
                <option value="45">45</option>
                <option value="50">50</option>
                <option value="55">55</option>
              </select>
             <xsl:text> </xsl:text>

              <select name="tzid" id="rdateTzid" class="timezones">
                <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                <option value="-1">select timezone...</option>
                <xsl:variable name="rdateTzId" select="/bedework/rdates/tzid"/>
                <xsl:for-each select="/bedework/timezones/timezone">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                    <xsl:if test="$rdateTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                    <xsl:value-of select="name"/>
                  </option>
                </xsl:for-each>
              </select>
            </div>
            <xsl:text> </xsl:text>
            <input type="submit" value="add rdate"/>
            <br/>
            <!-- dateonly (anniversary) event: this is temporary - should be determined by the main event -->
            <input type="checkbox" name="dateOnly" id="rdateDateOnly" onclick="swapRdateAllDay(this)" value="on"/>
            all day
            <!-- floating event: no timezone (and not UTC) -->
            <input type="checkbox" name="floating" id="rdateFloating" onclick="swapRdateFloatingTime(this)" value="on"/>
            floating
            <!-- store time as coordinated universal time (UTC) -->
            <input type="checkbox" name="storeUTC" id="rdateStoreUTC" onclick="swapRdateStoreUTC(this)" value="on"/>
            store as UTC
          </div>

          <xsl:call-template name="messagesAndErrors"/>

          <table cellspacing="0" class="rdatesTable">
            <tr>
              <th colspan="2">Recurrence Dates</th>
            </tr>
            <xsl:choose>
              <xsl:when test="/bedework/rdates/rdate">
                <xsl:for-each select="/bedework/rdates/rdate">
                  <tr>
                    <td>
                      <xsl:value-of select="longdate"/>
                      <xsl:if test="allday='false'">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="time"/>
                        <xsl:if test="floating='false'">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="timezone/id"/>
                        </xsl:if>
                      </xsl:if>
                    </td>
                    <td class="trash">
                      <xsl:variable name="datetime"><xsl:value-of select="unformatted"/></xsl:variable>
                      <xsl:variable name="tzid" select="timezone/id"/>
                      <xsl:variable name="dateOnly"><xsl:if test="allday = 'true'">&amp;dateOnly=true</xsl:if></xsl:variable>
                      <xsl:variable name="floating"><xsl:if test="floating = 'true'">&amp;floating=true</xsl:if></xsl:variable>
                      <xsl:variable name="storeUTC"><xsl:if test="utc = 'true'">&amp;storeUTC=true</xsl:if></xsl:variable>
                      <a href="{$event-setRdate}&amp;datetime={$datetime}&amp;tzid={$tzid}{$dateOnly}{$floating}{$storeUTC}&amp;delete=true" title="remove">
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <tr>
                  <td colspan="2">No recurrence dates</td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>
          </table>

          <table cellspacing="0" class="rdatesTable">
            <tr>
              <th colspan="2">Exception Dates</th>
            </tr>
            <tr>
              <td colspan="2" class="note">
                exception dates are created by deleting an instance of a
                recurring event
              </td>
            </tr>
            <xsl:choose>
              <xsl:when test="/bedework/exdates/exdate">
                <xsl:for-each select="/bedework/exdates/exdate">
                  <tr>
                    <td>
                      <xsl:value-of select="longdate"/>
                      <xsl:if test="allday='false'">
                        <xsl:value-of select="time"/>
                        <xsl:if test="floating='false'">
                          <xsl:value-of select="timezone/id"/>
                        </xsl:if>
                      </xsl:if>
                    </td>
                    <td class="trash">
                      <xsl:variable name="datetime"><xsl:value-of select="unformatted"/></xsl:variable>
                      <xsl:variable name="tzid" select="timezone/id"/>
                      <xsl:variable name="dateOnly"><xsl:if test="allday = 'true'">&amp;dateOnly=true</xsl:if></xsl:variable>
                      <xsl:variable name="floating"><xsl:if test="floating = 'true'">&amp;floating=true</xsl:if></xsl:variable>
                      <xsl:variable name="storeUTC"><xsl:if test="utc = 'true'">&amp;storeUTC=true</xsl:if></xsl:variable>
                      <a href="{$event-setRdate}&amp;datetime={$datetime}&amp;tzid={$tzid}{$dateOnly}{$floating}{$storeUTC}&amp;exdelete=true" title="remove">
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <tr>
                  <td colspan="2">No exception dates</td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>
          </table>

          <input type="button" value="done" onclick="window.close()"/>
        </div>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="attendees">
    <div id="bwDialogBox">
      <form name="raForm" id="recipientsAndAttendees" action="{$event-attendeesForEvent}" method="post">
        <h4 id="dialogTitle">
          Recipients and Attendees
        </h4>
        <div id="raContent">
          <table cellspacing="0">
            <tr>
              <td>
                <input name="uri" width="40"/>
                <input type="submit" value="add" />
                <br/>
                <input type="checkbox" name="recipient" value="true" checked="checked"/> recipient
                <input type="checkbox" name="attendee" value="true" checked="checked"/> attendee
              </td>
              <td>
                Role:
                <select name="role">
                  <option value="REQ-PARTICIPANT">required participant</option>
                  <option value="OPT-PARTICIPANT">optional participant</option>
                  <option value="CHAIR">chair</option>
                  <option value="NON-PARTICIPANT">non-participant</option>
                </select><br/>
                Status:
                <select name="partstat">
                  <option value="NEEDS-ACTION">needs action</option>
                  <option value="ACCEPTED">accepted</option>
                  <option value="DECLINED">declined</option>
                  <option value="TENTATIVE">tentative</option>
                  <option value="DELEGATED">delegated</option>
                </select>
              </td>
            </tr>
          </table>

          <xsl:call-template name="messagesAndErrors"/>

          <xsl:if test="/bedework/attendees/attendee">
            <table id="attendees" class="widget" cellspacing="0">
              <tr>
                <th colspan="4">Attendees</th>
              </tr>
              <!--<tr>
                <td>attendee</td>
                <td>role</td>
                <td>status</td>
              </tr>-->
              <xsl:for-each select="/bedework/attendees/attendee">
                <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
                <xsl:variable name="attendeeUri" select="attendeeUri"/>
                <tr>
                  <td class="trash">
                    <a href="{$event-attendeesForEvent}&amp;uri={$attendeeUri}&amp;attendee=true&amp;delete=true" title="remove">
                      <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                    </a>
                  </td>
                  <td>
                    <a href="{$attendeeUri}">
                      <xsl:choose>
                        <xsl:when test="cn != ''">
                          <xsl:value-of select="cn"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="attendeeUri"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </a>
                  </td>
                  <td class="role">
                    <xsl:value-of select="role"/>
                  </td>
                  <td class="status">
                    <xsl:value-of select="partstat"/>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </xsl:if>

          <xsl:if test="/bedework/recipients/recipient">
            <table id="attendees" class="widget" cellspacing="0">
              <tr>
                <th colspan="2">Recipients</th>
              </tr>
              <xsl:for-each select="/bedework/recipients/recipient">
                <xsl:variable name="recipientUri" select="."/>
                <tr>
                  <td class="trash">
                    <a href="{$event-attendeesForEvent}&amp;uri={$recipientUri}&amp;recipient=true&amp;delete=true" title="remove">
                      <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                    </a>
                  </td>
                  <td>
                    <a href="{$recipientUri}">
                      <xsl:value-of select="."/>
                    </a>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </xsl:if>

          <input type="button" value="done" onclick="window.close()"/>
        </div>
      </form>
    </div>
  </xsl:template>

  <xsl:template match="event" mode="addEventRef">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$event-addEventRefComplete}" id="standardForm"  enctype="multipart/form-data">
      <xsl:variable name="subscriptionId" select="subscription/id"/>
      <xsl:variable name="calPath" select="calendar/path"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <input type="hidden" name="subid" value="{$subscriptionId}"/>
      <input type="hidden" name="calPath" value="{$calPath}"/>
      <input type="hidden" name="guid" value="{$guid}"/>
      <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
      <!-- newCalPath is the path to the calendar in which the reference
           should be placed.  If no value, then default calendar. -->
      <input type="hidden" name="newCalPath" value=""/>

      <h2>Add Event Reference</h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            Event:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="summary = ''">
                <em>no title</em>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="summary"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Into calendar:
          </td>
          <td align="left">
            <span id="bwEventCalDisplay">
              <em>default calendar</em>
            </span>
            <a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">[change]</a>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Affects Free/busy:
          </td>
          <td align="left">
            <input type="radio" value="OPAQUE" name="transparency"/> yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency" checked="checked"/> no <span class="note">(transparent: event status does not affect your free/busy)</span>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="Continue"/>
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template match="freebusy">
    <h2>Free / Busy</h2>
    <div id="freeBusyWho">for <xsl:value-of select="day/who"/></div>
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
            <!-- the start date for the add event link is a concat of the day's date plus the period's time (+ seconds)-->
            <xsl:variable name="startDate"><xsl:value-of select="substring(../start,1,8)"/>T<xsl:value-of select="start"/>00</xsl:variable>
            <xsl:variable name="minutes" select="length"/>
            <xsl:variable name="fbClass">
              <xsl:choose>
                <xsl:when test="fbtype = '0'">busy</xsl:when>
                <xsl:when test="fbtype = '3'">tentative</xsl:when>
                <xsl:otherwise>free</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <td class="{$fbClass}">
              <a href="{$initEvent}&amp;startdate={$startDate}&amp;minutes={$minutes}" title="{$startTime}">*</a>
            </td>
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
        <td>&#160;</td>
        <td class="tentative">*</td>
        <td>tentative</td>
        <td>&#160;</td>
        <td>
          <form name="calendarShareForm" action="{$freeBusy-fetch}">
            View user's free/busy:<br/>
            <input type="text" name="userid" size="20"/>
            <input type="submit" name="submit" value="Submit"/>
          </form>
        </td>
      </tr>
    </table>

    <div id="sharingBox">
      <xsl:variable name="calPathEncoded" select="/bedework/myCalendars/calendars/calendar/encodedPath"/>
      <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/acl" mode="currentAccess">
        <xsl:with-param name="action" select="$freeBusy-setAccess"/>
        <xsl:with-param name="calPathEncoded" select="$calPathEncoded"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" action="{$freeBusy-setAccess}" id="shareForm">
        <xsl:variable name="calPath" select="/bedework/myCalendars/calendars/calendar/path"/>
        <input type="hidden" name="calPath" value="{$calPath}"/>
        <input type="hidden" value="F" name="how"/>
        <p>
          Share my free/busy with:<br/>
          <input type="text" name="who" size="20"/>
          <input type="radio" value="user" name="whoType" checked="checked"/> user
          <input type="radio" value="group" name="whoType"/> group<br/>
          OR
          <input type="radio" value="auth" name="whoType"/> authenticated
          <input type="radio" value="other" name="whoType"/> other users<br/>
          <em>note: this will set a user or group's access to
              "read-free-busy" and any
              existing access control will be replaced.</em>
        </p>
        <input type="submit" name="submit" value="Submit"/>
      </form>
    </div>
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

  <!--+++++++++++++++ Categories ++++++++++++++++++++-->
  <xsl:template name="categoryList">
    <h2>
      Manage Categories
      <input type="button" name="return" value="Add new category" onclick="javascript:location.replace('{$category-initAdd}')" class="titleButton"/>
    </h2>
    <table class="common" id="manage" cellspacing="0">
      <tr>
        <th class="commonHeader" colspan="2">Edit/Delete Categories</th>
      </tr>
      <xsl:choose>
        <xsl:when test="/bedework/categories/category">
          <xsl:for-each select="/bedework/categories/category">
            <xsl:variable name="categoryKey" select="normalize-space(keyword)"/>
            <tr>
              <td>
                <a href="{$category-fetchForUpdate}&amp;categoryKey={$categoryKey}">
                  <xsl:value-of select="keyword"/>
                </a>
              </td>
              <td>
                <xsl:value-of select="desc"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td colspan="2">
              No categories defined
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <h2>Manage Categories</h2>
        <form action="{$category-update}" method="post">
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2">Add Category</th>
            </tr>
            <tr>
              <td class="fieldname">
                Keyword:
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname optional">
                Description:
              </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:text> </xsl:text>
                </textarea>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="addCategory" value="Add Category"/>
                <input type="submit" name="cancelled" value="cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <h2>Manage Categories</h2>
        <form action="{$category-update}" method="post">
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2">Update Category</th>
            </tr>
            <tr>
              <td class="fieldname">
            Keyword:
            </td>
              <td>
                <xsl:variable name="keyword" select="normalize-space(/bedework/currentCategory/category/keyword)"/>
                <input type="text" name="categoryWord.value" value="{$keyword}" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname optional">
            Description:
            </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedework/currentCategory/category/desc)"/>
                  <xsl:if test="normalize-space(/bedework/currentCategory/category/desc/textarea) = ''">
                    <xsl:text> </xsl:text>
                    <!-- keep this space to avoid browser
                    rendering errors when the text area is empty -->
                  </xsl:if>
                </textarea>
              </td>
            </tr>
          </table>

          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="updateCategory" value="Update Category"/>
                <input type="submit" name="cancelled" value="cancel"/>
                <input type="reset" value="Reset"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="Delete Category"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteCategoryConfirm">
    <h2>Ok to delete this category?</h2>

    <table class="common" cellspacing="0">
      <tr>
        <th class="commonHeader" colspan="2">Delete Category</th>
      </tr>
      <tr>
        <td class="fieldname">
          Keyword:
        </td>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/keyword"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname optional">
          Description:
        </td>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="deleteCategory" value="Yes: Delete Category"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars" mode="manageCalendars">
    <h2>Manage Calendars</h2>
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Calendars</h3>
          <ul class="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedework/page='calendarDescriptions' or
                              /bedework/page='displayCalendar'">
                <xsl:apply-templates select="calendar[calType &lt; 2]" mode="listForDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="calendar[calType &lt; 2]" mode="listForUpdate"/>
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

  <xsl:template match="calendar" mode="myCalendars">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                          and path = /bedework/selectionState/subscriptions/subscription/calendar/path">selected</xsl:when>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <a href="{$setSelection}&amp;calUrl={$calPath}">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="myCalendars"/>
        </ul>
      </xsl:if>
      <xsl:if test="calendarCollection='true'">
        <!-- set the start date for adding an event to the first day of the
             given period, the hour of "now", and give a duration of 60 minutes -->
        <xsl:variable name="startDate"><xsl:value-of select="/bedework/firstday/date"/>T<xsl:value-of select="substring(/bedework/now/time,1,2)"/>0000</xsl:variable>
        <!-- skip setting duration for now; this should be set in the user's prefs-->
        <!-- <a href="{$initEvent}&amp;startdate={$startDate}&amp;newCalPath={$calPath}&amp;minutes=60" class="calendarAdd" title="add event"> -->
        <a href="{$initEvent}&amp;startdate={$startDate}&amp;newCalPath={$calPath}" class="calendarAdd" title="add event">
          <img src="{$resourcesRoot}/resources/addEvent-forCals-icon.gif" width="9" height="12" border="0" alt="add event"/>
        </a>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="mySpecialCalendars">
    <!-- Trash = 2, Deleted = 3, Busy = 4, Inbox = 5, Outbox = 6  -->
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                          and path = /bedework/selectionState/subscriptions/subscription/calendar/path">selected</xsl:when>
          <xsl:when test="calType='2' or calType='3'">trash</xsl:when>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
        <xsl:choose>
          <xsl:when test="calType='5' and /bedework/inboxState/numActive != '0'">
            <strong>
              <a href="{$showInbox}">
                <xsl:value-of select="name"/>
              </a>
              <xsl:text> </xsl:text>
              (<xsl:value-of select="/bedework/inboxState/numActive"/>)
            </strong>
          </xsl:when>
          <xsl:when test="calType='6' and /bedework/outbox/numActive != '0'">
            <strong>
              <a href="{$showOutbox}">
                <xsl:value-of select="name"/>
              </a>
              <xsl:text> </xsl:text>
              (<xsl:value-of select="/bedework/outboxState/numActive"/>)
            </strong>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$setSelection}&amp;calUrl={$calPath}">
              <xsl:attribute name="title">
                <xsl:choose>
                  <xsl:when test="calType = 2">Contains items you have access to delete.</xsl:when>
                  <xsl:when test="calType = 3">Used to mask items you do not have access to truly delete, such as many subscribed events.</xsl:when>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="name"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="myCalendars"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdate">
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}" title="update">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calendarCollection='false'">
        <xsl:text> </xsl:text>
        <a href="{$calendar-initAdd}&amp;calPath={$calPath}" title="add a calendar or folder">
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
  </xsl:template>

  <xsl:template match="calendar" mode="listForDisplay">
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$calendar-fetchForDisplay}&amp;calPath={$calPath}" title="display">
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
  </xsl:template>

  <!-- the selectCalForEvent listing creates a calendar tree in a pop-up window
       from myCalendars and mySubscriptions -->
  <xsl:template name="selectCalForEvent">
    <h2>Select a calendar</h2>
    <form name="toggleCals" action="{$event-selectCalForEvent}">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='showAllCalsForEvent']/value = 'true'">
          <input type="radio" name="setappvar" value="showAllCalsForEvent(false)" onclick="submit()"/>
          show only writable calendars
          <input type="radio" name="setappvar" value="showAllCalsForEvent(true)" checked="checked" onclick="submit()"/>
          show all calendars
        </xsl:when>
        <xsl:otherwise>
          <input type="radio" name="setappvar" value="showAllCalsForEvent(false)" checked="checked" onclick="submit()"/>
          show only writable calendars
          <input type="radio" name="setappvar" value="showAllCalsForEvent(true)" onclick="submit()"/>
          show all calendars
        </xsl:otherwise>
      </xsl:choose>
    </form>
    <h4>My Calendars</h4>
    <ul class="calendarTree">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='showAllCalsForEvent']/value = 'true'">
          <xsl:choose>
            <xsl:when test="/bedework/myCalendars/calendars/calendar">
              <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar" mode="selectCalForEventCalTree"/>
            </xsl:when>
            <xsl:otherwise>
              <em>no writable calendars</em>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/bedework/myCalendars/calendars/calendar[currentAccess/current-user-privilege-set/privilege/write-content]">
              <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar[currentAccess/current-user-privilege-set/privilege/write-content]" mode="selectCalForEventCalTree"/>
            </xsl:when>
            <xsl:otherwise>
              <em>no writable calendars</em>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
    <h4>Subscribed Calendars</h4>
    <ul class="calendarTree">
      <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='showAllCalsForEvent']/value = 'true'">
          <xsl:choose>
            <xsl:when test="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]/calendars/calendar">
              <xsl:apply-templates select="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]/calendars/calendar" mode="selectCalForEventCalTree"/>
            </xsl:when>
            <xsl:otherwise>
              <em>no writable calendars</em>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]/calendars/calendar[currentAccess/current-user-privilege-set/privilege/write-content]">
              <xsl:apply-templates select="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]/calendars/calendar[currentAccess/current-user-privilege-set/privilege/write-content]" mode="selectCalForEventCalTree"/>
            </xsl:when>
            <xsl:otherwise>
              <em>no writable calendars</em>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForEventCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                          and name = /bedework/selectionState/subscriptions/subscription/calendar/name">selected</xsl:when>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
      <xsl:variable name="calDisplay">
        <xsl:choose>
          <xsl:when test="contains(path,$userPath)">
            <xsl:value-of select="substring-after(path,$userPath)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="path"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="currentAccess/current-user-privilege-set/privilege/write-content and (calendarCollection = 'true')">
          <a href="javascript:updateEventFormCalendar('{$calPath}','{$calDisplay}')">
            <strong><xsl:value-of select="name"/></strong>
          </a>
          <xsl:if test="name != $calDisplay">
            <span class="small">(<xsl:value-of select="$calDisplay"/>)</span>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar[calType &lt; 2]" mode="selectCalForEventCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3>Add Calendar / Folder</h3>
    <form name="addCalForm" action="{$calendar-update}">
      <table class="common">
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
              <xsl:if test="normalize-space(desc) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
            </textarea>
          </td>
        </tr>
        <tr>
          <th>Calendar/Folder:</th>
          <td>
            <input type="radio" value="true" name="calendarCollection" checked="checked"/> Calendar
            <input type="radio" value="false" name="calendarCollection"/> Folder
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addCalendar" value="Add Calendar/Folder"/>
            <input type="submit" name="cancelled" value="cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>

    <div id="sharingBox">
      <h3>Current Access:</h3>
      Sharing may be added to a calendar once created.
    </div>

  </xsl:template>

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:variable name="calPath" select="path"/>
    <xsl:variable name="calPathEncoded" select="encodedPath"/>
    <xsl:choose>
      <xsl:when test="calendarCollection='true'">
        <h3>Modify Calendar</h3>
      </xsl:when>
      <xsl:otherwise>
        <h3>Modify Folder</h3>
      </xsl:otherwise>
    </xsl:choose>
    <form name="modCalForm" action="{$calendar-update}">
      <table class="common">
        <tr>
          <th class="commonHeader" colspan="2">
            <xsl:value-of select="path"/>
          </th>
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
              <xsl:if test="normalize-space(desc) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
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
            <input type="submit" name="cancelled" value="cancel"/>
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
    <div id="sharingBox">
      <xsl:apply-templates select="acl" mode="currentAccess">
        <xsl:with-param name="action" select="$calendar-setAccess"/>
        <xsl:with-param name="calPathEncoded" select="$calPathEncoded"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" action="{$calendar-setAccess}" id="shareForm" onsubmit="setAccessHow(this)">
        <input type="hidden" name="calPath" value="{$calPath}"/>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="calType = '5'">inbox</xsl:when>
              <xsl:when test="calType = '6'">outbox</xsl:when>
              <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </form>
    </div>
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
      <xsl:for-each select="//calendar[calType &lt; 2]">
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
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="displayCalendar">
    <h2>Calendar Information</h2>
    <table class="common">
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
      <table class="common">
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
            <input type="submit" name="cancelled" value="cancel"/>
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

  <xsl:template match="calendars" mode="exportCalendars">
    <h2>Export Calendars as iCal</h2>
    <form name="eventForm" id="exportCalendarForm" action="{$export}" method="post">
      <input type="hidden" name="calPath" value=""/>
      <input type="hidden" name="nocache" value="no"/>
      <input type="hidden" name="skinName" value="ical"/>
      <input type="hidden" name="contentType" value="text/calendar"/>
      <input type="hidden" name="contentName" value="calendar.ics"/>

      <table class="common" cellspacing="0">
        <tr>
          <th class="commonHeader" colspan="3">
              Event date limits:
              <input type="radio" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/> today forward
              <input type="radio" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/> all dates
              <input type="radio" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/> date range
          </th>
        </tr>
        <tr id="exportDateRange" class="invisible">
          <td colspan="3" class="dates">
            <strong>Start:</strong>
            <div class="dateFields">
              <xsl:copy-of select="/bedework/formElements/form/start/month/*"/>
              <xsl:copy-of select="/bedework/formElements/form/start/day/*"/>
              <xsl:copy-of select="/bedework/formElements/form/start/yearText/*"/>
            </div>
            <script language="JavaScript" type="text/javascript">
            <xsl:comment>
              startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback',false,'<xsl:value-of select="$resourcesRoot"/>/resources/');
            </xsl:comment>
            </script>
            &#160;&#160;
            <strong>End:</strong>
            <div class="dateFields">
              <xsl:copy-of select="/bedework/formElements/form/end/month/*"/>
              <xsl:copy-of select="/bedework/formElements/form/end/day/*"/>
               <xsl:copy-of select="/bedework/formElements/form/end/yearText/*"/>
            </div>
            <script language="JavaScript" type="text/javascript">
            <xsl:comment>
              endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback',false,'<xsl:value-of select="$resourcesRoot"/>/resources/');
            </xsl:comment>
            </script>
          </td>
        </tr>
        <tr>
          <th class="borderRight">
            My Calendars
          </th>
          <th class="borderRight">
            Subscriptions (underlying calendars)
          </th>
          <th>
            Public Calendars
          </th>
        </tr>
        <tr>
          <td class="borderRight">
            <!-- My Calendars -->
            <ul class="calendarTree">
              <!-- list normal calendars first -->
              <xsl:for-each select="/bedework/myCalendars/calendars/calendar//calendar[calendarCollection='true' and calType &lt; 2]">
                <li class="calendar">
                  <xsl:variable name="calPath" select="path"/>
                  <xsl:variable name="name" select="name"/>
                  <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                    <xsl:value-of select="name"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
            <ul class="calendarTree">
              <!-- list special calendars next -->
              <xsl:for-each select="/bedework/myCalendars/calendars/calendar//calendar[calendarCollection='true' and calType &gt; 1]">
                <li class="calendar">
                  <xsl:variable name="calPath" select="path"/>
                  <xsl:variable name="name" select="name"/>
                  <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                    <xsl:value-of select="name"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </td>
          <td class="borderRight">
            <!-- My Subscriptions (underlying calendars) -->
            <ul class="calendarTree">
              <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
              <xsl:for-each select="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]">
                <xsl:choose>
                  <xsl:when test="calendarDeleted='true'">
                    <li class="deleted">
                      <xsl:value-of select="name"/><br/>
                      <em>calendar not available</em>
                    </li>
                  </xsl:when>
                  <xsl:when test="count(calendars//calendar[calendarCollection='true']) = 1">
                    <xsl:for-each select="calendars//calendar[calendarCollection='true']">
                      <li class="calendar">
                        <xsl:variable name="calPath" select="path"/>
                        <xsl:variable name="name" select="name"/>
                        <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                          <xsl:value-of select="name"/>
                        </a>
                      </li>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <li class="folder">
                      <xsl:value-of select="name"/>:
                      <xsl:if test="calendars//calendar[calendarCollection='true']">
                        <ul>
                          <xsl:for-each select="calendars//calendar[calendarCollection='true']">
                            <li class="calendar">
                              <xsl:variable name="calPath" select="path"/>
                              <xsl:variable name="name" select="name"/>
                              <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                                <xsl:value-of select="name"/>
                              </a>
                            </li>
                          </xsl:for-each>
                        </ul>
                      </xsl:if>
                    </li>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </ul>
          </td>
          <td>
            <ul class="calendarTree">
              <xsl:for-each select=".//calendar[calendarCollection='true']">
                <li class="calendar">
                  <xsl:variable name="calPath" select="path"/>
                  <xsl:variable name="name" select="name"/>
                  <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                    <xsl:value-of select="name"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
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
          <p class="smaller">
            Select a calendar below to add a <em><strong>new</strong></em>
            internal subscription. <!-- or
            <a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">
            subscribe to an external calendar</a>.-->
          </p>
          <h3>My calendars</h3>
          <ul class="calendarTree">
            <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar[calType &lt; 2]" mode="subscribe"/>
          </ul>
          <h3>Public calendars</h3>
          <ul class="calendarTree">
            <xsl:apply-templates select="/bedework/subscriptions/subscribe/calendars/calendar[calType &lt; 2]" mode="subscribe"/>
          </ul>
        </td>
        <td class="subs">
          <xsl:choose>
            <xsl:when test="/bedework/page='subscriptions'">
              <xsl:call-template name="subscriptionList"/>
            </xsl:when>
            <xsl:when test="/bedework/page='addSubByUri'">
              <xsl:call-template name="addSubByUri"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="subscription" mode="addSystemSubscription"/>
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
    <xsl:variable name="calPath" select="encodedPath"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <a href="{$subscriptions-initAdd}&amp;calPath={$calPath}">
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

  <!-- add a subscription to a user calendar by user and path; this is actually
       a subscription to an arbitrary URI (which we can expose later) -->
  <xsl:template name="addSubByUri">
    <h3>Add Subscription to User Calendar</h3>
    <p class="note">*the subsciption name must be unique</p>
    <form name="subscribeForm" action="{$subscriptions-initAdd}" onsubmit="return setSubscriptionUri(this,'bwcal:///user/')" method="post">
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">Name:</td>
          <td>
            <input type="text" value="" name="name" size="60"/>
          </td>
        </tr>
        <!-- the following would be for an arbitrary URI.  We'll add this later.
        <tr>
          <td class="fieldname">Uri:</td>
          <td>
            <input type="text" value="" name="calUri" size="60"/>
          </td>
        </tr>-->
        <tr>
          <td class="fieldname">User ID:</td>
          <td>
            <input type="hidden" value="" name="calUri"/>
            <input type="text" value="" name="userId" size="20"/>
            <span class="note">ex: janedoe</span>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Calendar path:</td>
          <td>
            <input type="text" value="" name="userPath" size="20"/>
            <span class="note">
              (optional) ex: calendar<br/>
              to subscribe to bwcal:///user/janedoe/someFolder/someCalendar, enter "someFolder/someCalendar"
            </span>
          </td>
        </tr>
        <!--<tr>
          <td class="fieldname">Display:</td>
          <td>
            <input type="radio" value="true" name="display" checked="checked"/> yes
            <input type="radio" value="false" name="display"/> no
          </td>
        </tr>-->
        <tr>
          <td class="fieldname">Affects Free/Busy:</td>
          <td>
            <input type="radio" value="true" name="affectsFreeBusy"/> yes
            <input type="radio" value="false" name="affectsFreeBusy" checked="checked"/> no
          </td>
        </tr>
        <tr>
          <td class="fieldname">Style:</td>
          <td>
            <select name="style">
              <option value="default">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="."/>
                <option value="{$subColor}" class="{$subColor}">
                  <xsl:value-of select="@name"/>
                </option>
              </xsl:for-each>
            </select>
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
            <input type="submit" name="cancelled" value="cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!-- add a subscription to a public calendar within the system -->
  <xsl:template match="subscription" mode="addSystemSubscription">
    <h3>Add New Subscription</h3>
    <p class="note">*the subsciption name must be unique</p>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="common" cellspacing="0">
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
              <xsl:variable name="calPath" select="uri"/>
              <input type="text" value="{$calPath}" name="calPath" size="60"/>
            </td>
          </tr>
        </xsl:if>
        <!--<tr>
          <td class="fieldname">Display:</td>
          <td>
            <input type="radio" value="true" name="subscription.display" checked="checked"/> yes
            <input type="radio" value="false" name="subscription.display"/> no
          </td>
        </tr>-->
        <tr>
          <td class="fieldname">Affects Free/Busy:</td>
          <td>
            <input type="radio" value="true" name="subscription.affectsFreeBusy"/> yes
            <input type="radio" value="false" name="subscription.affectsFreeBusy" checked="checked"/> no
          </td>
        </tr>
        <tr>
          <td class="fieldname">Style:</td>
          <td>
            <select name="subscription.style">
              <option value="default">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="."/>
                <option value="{$subColor}" class="{$subColor}">
                  <xsl:value-of select="@name"/>
                </option>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <!--<tr>
          <td class="fieldname">Unremovable:</td>
          <td>
            <input type="radio" value="true" name="subscription.unremoveable" size="60"/> true
            <input type="radio" value="false" name="subscription.unremoveable" size="60" checked="checked"/> false
          </td>
        </tr>-->
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addSubscription" value="Add Subscription"/>
            <input type="submit" name="cancelled" value="cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="subscription" mode="modSubscription">
    <h3>Modify Subscription</h3>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="common" cellspacing="0">
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
        <!-- <tr>
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
        </tr> -->
        <tr>
          <td class="fieldname">Affects Free/Busy:</td>
          <td>
            <xsl:choose>
              <xsl:when test="affectsFreeBusy='true'">
                <input type="radio" value="true" name="subscription.affectsFreeBusy" checked="checked"/> yes
                <input type="radio" value="false" name="subscription.affectsFreeBusy"/> no
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" value="true" name="subscription.affectsFreeBusy"/> yes
                <input type="radio" value="false" name="subscription.affectsFreeBusy" checked="checked"/> no
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Style:</td>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <select name="subscription.style">
              <option value="default">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="."/>
                <xsl:choose>
                  <xsl:when test="$subStyle = $subColor">
                    <option value="{$subColor}" class="{$subColor}" selected="selected">
                      <xsl:value-of select="@name"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{$subColor}" class="{$subColor}">
                      <xsl:value-of select="@name"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
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
            <input type="submit" name="cancelled" value="cancel"/>
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
    <table class="common" cellspacing="0">
      <tr>
        <th>Name</th>
        <th>URI</th>
        <th>Style</th>
        <!--<th>Display</th>-->
        <th>Free/Busy</th>
        <!--<th>Unremovable</th>
        <th>External</th>
        <th>Deleted?</th>-->
      </tr>
      <xsl:for-each select="subscription">
        <xsl:variable name="style" select="style"/>
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
          <td class="{$style}" style="border: none;">
            &#160; <!-- just make room and let the style show -->
          </td>
          <!-- <td class="center">
            <xsl:if test="display='true'">
              <img src="{$resourcesRoot}/resources/greenCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td> -->
          <td class="center">
            <xsl:if test="affectsFreeBusy='true'">
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
    <h4><a href="{$subscriptions-addSubByUri}">Subscribe to another user's calendar</a></h4>
  </xsl:template>

  <xsl:template match="subscription" mode="mySubscriptions">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="/bedework/selectionState/selectionType = 'subscription'
                        and /bedework/selectionState/subscriptions/subscription/name = name">selected</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <xsl:variable name="subName" select="name"/>
      <xsl:if test="style != '' and style != 'default'">
        <!-- the spacer gif approach allows us to avoid some IE misbehavior -->
        <xsl:variable name="subStyle" select="style"/>
        <img src="{$resourcesRoot}/resources/spacer.gif" width="6" height="6" alt="subscription style" class="subStyle {$subStyle}"/>
      </xsl:if>
      <a href="{$setSelection}&amp;subname={$subName}">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calendars/calendar/calendarCollection='true' and
                    calendars/calendar/currentAccess/current-user-privilege-set/privilege/write-content">
        <!-- set the start date for adding an event to the first day of the
             given period, the hour of "now", and give a duration of 60 minutes -->
        <xsl:variable name="calPath" select="calendars/calendar/encodedPath"/>
        <xsl:variable name="startDate"><xsl:value-of select="/bedework/firstday/date"/>T<xsl:value-of select="substring(/bedework/now/time,1,2)"/>0000</xsl:variable>
        <a href="{$initEvent}&amp;startdate={$startDate}&amp;newCalPath={$calPath}&amp;minutes=60" class="calendarAdd" title="add event">
          <img src="{$resourcesRoot}/resources/addEvent-forCals-icon.gif" width="9" height="12" border="0" alt="add event"/>
        </a>
      </xsl:if>
    </li>
  </xsl:template>

  <!--==== ALARM OPTIONS ====-->
  <xsl:template name="alarmOptions">
    <form method="post" action="{$setAlarm}" id="standardForm">
      <input type="hidden" name="updateAlarmOptions" value="true"/>
      <table class="common" cellspacing="0">
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
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== UPLOAD ====-->
  <xsl:template name="upload">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$upload}" id="standardForm"  enctype="multipart/form-data">
      <h2>Upload iCAL File</h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            Filename:
          </td>
          <td align="left">
            <input type="file" name="uploadFile" size="60" />
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            Into calendar:
          </td>
          <td align="left" class="padMeTop">
            <input type="hidden" name="newCalPath" value=""/>
            <span id="bwEventCalDisplay">
              <em>default calendar</em>
            </span>
            <a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">[change]</a>
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            Effects free/busy:
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" checked="checked"/> accept event's settings<br/>
            <input type="radio" value="OPAQUE" name="transparency"/> yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency"/> no <span class="note">(transparent: event status does not affect your free/busy)</span><br/>
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            Status:
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="status" checked="checked"/> accept event's status<br/>
            <input type="radio" value="CONFIRMED" name="status"/> confirmed<br/>
            <input type="radio" value="TENTATIVE" name="status"/> tentative<br/>
            <input type="radio" value="CANCELLED" name="status"/> cancelled<br/>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="Continue"/>
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== EMAIL OPTIONS ====-->
  <xsl:template name="emailOptions">
    <form method="post" action="{$mailEvent}" id="standardForm">
      <input type="hidden" name="updateEmailOptions" value="true"/>
      <table class="common" cellspacing="0">
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
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== MANAGE LOCATIONS ====-->
  <xsl:template name="locationList">
    <h2>
      Manage Locations
      <input type="button" name="return" value="Add new location" onclick="javascript:location.replace('{$location-initAdd}')" class="titleButton"/>
    </h2>
    <table class="common" id="manage" cellspacing="0">
      <tr>
        <th class="commonHeader">Edit/Delete Locations</th>
      </tr>
      <tr>
        <td>
          <xsl:if test="/bedework/locations/location">
            <ul>
              <xsl:for-each select="/bedework/locations/location">
                <xsl:sort select="."/>
                <li>
                  <xsl:variable name="uid" select="uid"/>
                  <a href="{$location-fetchForUpdate}&amp;uid={$uid}"><xsl:value-of select="address"/></a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="modLocation">
    <xsl:choose>
      <xsl:when test="/bedework/creating = 'true'">
        <form name="addLocationForm" method="post" action="{$location-update}" id="standardForm">
          <h2>Manage Locations</h2>
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2">Add Location</th>
            </tr>
            <tr>
              <td class="fieldname">
                Main Address:
              </td>
              <td>
                <input size="60" name="locationAddress.value" type="text"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                Subaddress:
              </td>
              <td>
                <input size="60" name="locationSubaddress.value" type="text"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                Location Link:
              </td>
              <td>
                <input size="60" name="location.link" type="text"/>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input name="submit" type="submit" value="Submit Location"/>
                <input name="cancelled" type="submit" value="cancel"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <form name="editLocationForm" method="post" action="{$location-update}" id="standardForm">
          <input type="hidden" name="updateLocation" value="true"/>
          <h2>Manage Locations</h2>
          <table class="common" cellspacing="0">
            <tr>
              <th colspan="2" class="commonHeader">
                Edit Location
              </th>
            </tr>
            <tr>
              <td class="fieldname">
                Main Address:
              </td>
              <td align="left">
                <input size="60" name="locationAddress.value" type="text">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/address"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                Subaddress:
              </td>
              <td align="left">
                <input size="60" name="locationSubaddress.value" type="text">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/subaddress"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                Location Link:
              </td>
              <td>
                <input size="60" name="location.link" type="text">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/link"/></xsl:attribute>
                </input>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input name="submit" type="submit" value="Submit Location"/>
                <input name="cancelled" type="submit" value="cancel"/>
                <input type="reset" value="Reset"/>
              </td>
              <td align="right">
                <xsl:variable name="uid" select="form/uid"/>
                <input type="button" name="delete" value="Delete Location"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteLocationConfirm">
    <h2>Ok to delete this location?</h2>

    <table class="common" cellspacing="0">
      <tr>
        <th class="commonHeader" colspan="2">Delete Location</th>
      </tr>
      <tr>
        <td class="fieldname">
          Main Address:
        </td>
        <td align="left">
          <xsl:value-of select="/bedework/currentLocation/address"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          Subaddress:
        </td>
        <td align="left">
          <xsl:value-of select="/bedework/currentLocation/subaddress"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          Location Link:
        </td>
        <td>
          <xsl:variable name="link" select="/bedework/currentLocation/link"/>
          <a href="{$link}"><xsl:value-of select="$link"/></a>
        </td>
      </tr>
    </table>

    <form action="{$location-delete}" method="post">
      <input type="submit" name="updateCategory" value="Yes: Delete Location"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

  <!--==== INBOX, OUTBOX, and SCHEDULING ====-->
  <xsl:template match="inbox">
    <h2 class="common">Inbox</h2>
    <table id="inbox" class="common" cellspacing="0">
      <tr>
        <th class="commonHeader">organizer</th>
        <th class="commonHeader">title</th>
        <th class="commonHeader">start</th>
        <th class="commonHeader">end</th>
        <th class="commonHeader">method</th>
        <th class="commonHeader">status</th>
      </tr>
      <xsl:for-each select="events/event">
        <xsl:variable name="subscriptionId" select="subscription/id"/>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="eventName" select="name"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <tr>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="scheduleMethod=1">publish</xsl:when>
              <xsl:when test="scheduleMethod=2">request</xsl:when>
              <xsl:when test="scheduleMethod=5">cancel</xsl:when>
              <xsl:when test="scheduleMethod=7 or scheduleMethod=8">counter</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <td>
            <xsl:if test="organizer">
              <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
              <strong>
                <a href="{$organizerUri}">
                  <xsl:choose>
                    <xsl:when test="organizer/cn != ''">
                      <xsl:value-of select="organizer/cn"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="organizer/organizerUri"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </strong>
            </xsl:if>
          </td>
          <td>
            <xsl:variable name="inboxItemAction">
              <xsl:choose>
                <xsl:when test="scheduleMethod=2"><xsl:value-of select="$schedule-initAttendeeRespond"/></xsl:when>
                <xsl:when test="scheduleMethod=3"><xsl:value-of select="$schedule-initAttendeeReply"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$schedule-initAttendeeRespond"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <a href="{$inboxItemAction}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="title"/>
            </a>
          </td>
          <td><xsl:value-of select="start/shortdate"/> <xsl:value-of select="start/time"/></td>
          <td><xsl:value-of select="end/shortdate"/> <xsl:value-of select="end/time"/></td>
          <td><xsl:apply-templates select="scheduleMethod"/></td>
          <td>
            <xsl:choose>
              <xsl:when test="scheduleState=0"><em>unprocessed</em></xsl:when>
              <xsl:otherwise>processed</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="Outbox">
    <h2>Outbox</h2>
  </xsl:template>

  <xsl:template match="scheduleMethod">
    <xsl:choose>
      <xsl:when test="node()=1">publish</xsl:when>
      <xsl:when test="node()=2">request</xsl:when>
      <xsl:when test="node()=3">reply</xsl:when>
      <xsl:when test="node()=4">add</xsl:when>
      <xsl:when test="node()=5">cancel</xsl:when>
      <xsl:when test="node()=6">refresh</xsl:when>
      <xsl:when test="node()=7">counter</xsl:when>
      <xsl:when test="node()=8">declined</xsl:when><!-- declinecounter -->
      <xsl:otherwise>unknown</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="formElements" mode="attendeeRespond">
    <xsl:variable name="subscriptionId" select="subscriptionId"/>
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$schedule-attendeeRespond}" id="standardForm">
      <input type="hidden" name="updateEvent" value="true"/>
      <input type="hidden" name="endType" value="date"/>
      <h2>Meeting Request</h2>
      <table class="common" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">
            <div id="eventActions">

            </div>
            Organizer:
            <xsl:choose>
              <xsl:when test="organizer/cn != ''">
                <xsl:value-of select="organizer/cn"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </tr>
        <tr>
          <td class="fieldname">Action:</td>
          <td class="fieldval scheduleActions">
            <input type="radio" name="method" value="REPLY" checked="checked" onclick="swapScheduleDisplay('hide');"/>reply as
            <select name="partstat">
              <option value="ACCEPTED">accepted</option>
              <option value="DECLINED">declined</option>
              <option value="TENTATIVE">tentative</option>
            </select><br/>
            <input type="radio" name="method" value="REFRESH" onclick="swapScheduleDisplay('hide');"/>refresh this event<br/>
            <input type="radio" name="method" value="DELEGATE" onclick="swapScheduleDisplay('hide');"/>delegate to
            <input type="test" name="delegate" value=""/> (uri or account)<br/>
            <input type="radio" name="method" value="COUNTER" onclick="swapScheduleDisplay('show');"/>counter (suggest a different date, time, and/or location)
          </td>
        </tr>
        <tr>
          <td class="fieldname">Comment:</td>
          <td class="fieldval scheduleActions">
            <textarea name="comment" cols="60" rows="2">
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldname">&#160;</td>
          <td class="fieldval scheduleActions">
            <input name="submit" type="submit" value="Submit"/>&#160;
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Title:
          </td>
          <td class="fieldval">
            <strong><xsl:value-of select="form/title/input/@value"/></strong>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Description:</td>
          <td class="fieldval">
            <xsl:value-of select="/bedework/formElements/form/desc/textarea"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Date &amp; Time:
          </td>
          <td class="fieldval">
            <div id="scheduleDateDisplay">
              <xsl:value-of select="form/start/month/select/option[@selected='selected']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="form/start/day/select/option[@selected='selected']"/>,
              <xsl:value-of select="form/start/yearText/input/@value"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="form/start/hour/select/option[@selected='selected']"/>:<xsl:value-of select="form/start/minute/select/option[@selected='selected']"/>
              -
              <xsl:value-of select="form/end/dateTime/month/select/option[@selected='selected']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="form/end/dateTime/day/select/option[@selected='selected']"/>,
              <xsl:value-of select="form/end/dateTime/yearText/input/@value"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="form/end/dateTime/hour/select/option[@selected='selected']"/>:<xsl:value-of select="form/end/dateTime/minute/select/option[@selected='selected']"/>
              <xsl:if test="form/allDay/input/@checked='checked'">
                <xsl:text> </xsl:text>
                (all day)
              </xsl:if>
            </div>
            <div id="scheduleDateEdit" class="invisible">
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
                <!--<script language="JavaScript" type="text/javascript">
                <xsl:comment>
                  startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback');
                </xsl:comment>
                </script>-->
                <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
                <div class="{$timeFieldsClass}" id="startTimeFields">
                  <span id="calWidgetStartTimeHider" class="show">
                    <xsl:copy-of select="form/start/hour/*"/>
                    <xsl:copy-of select="form/start/minute/*"/>
                    <xsl:if test="form/start/ampm">
                      <xsl:copy-of select="form/start/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!--<a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>-->
                  </span>
                </div>
              </div>
              <div class="dateStartEndBox">
                <strong>End:</strong>
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">
                    <input type="radio" name="eventEndType" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
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
                  <!--<script language="JavaScript" type="text/javascript">
                  <xsl:comment>
                    endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback');
                  </xsl:comment>
                  </script>-->
                  <div class="{$timeFieldsClass}" id="endTimeFields">
                    <span id="calWidgetEndTimeHider" class="show">
                      <xsl:copy-of select="form/end/dateTime/hour/*"/>
                      <xsl:copy-of select="form/end/dateTime/minute/*"/>
                      <xsl:if test="form/end/dateTime/ampm">
                        <xsl:copy-of select="form/end/dateTime/ampm/*"/>
                      </xsl:if>
                      <xsl:text> </xsl:text>
                      <!--<a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>-->
                    </span>
                  </div>
                </div><br/>
                <div id="clock" class="invisible">
                  <xsl:call-template name="clock"/>
                </div>
                <div class="dateFields">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">
                      <input type="radio" name="eventEndType" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
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
                          <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="disabled"/>weeks
                        </div>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- we are using week format -->
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                          <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                          <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/>days
                          <span id="durationHrMin" class="{$durationHrMinClass}">
                            <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                            <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/>hours
                            <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/>minutes
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
                      <input type="radio" name="eventEndType" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  This event has no duration / end date
                </div>
              </div>
            </div>
          </td>
        </tr>
        <tr>
          <td class="fieldname">Location:</td>
          <td class="fieldval" align="left">
            <div id="scheduleLocationDisplay">
              <xsl:if test="location/address = ''">
               <em>not specified</em>
              </xsl:if>
              <xsl:value-of select="location/address"/>
            </div>
            <div id="scheduleLocationEdit" class="invisible">
              <span class="std-text">choose: </span>
              <span id="eventFormLocationList">
                <select name="eventLocationUid">
                  <option value="-1">select...</option>
                  <xsl:copy-of select="/bedework/formElements/form/location/locationmenu/select/*"/>
                </select>
              </span>
              <span class="std-text"> or add new: </span>
              <input type="text" name="locationAddress.value" value="" />
            </div>
          </td>
        </tr>
        <xsl:if test="attendee">
          <tr>
            <td class="fieldname">Attendees:</td>
            <td class="fieldval">
              <table id="attendees" cellspacing="0">
                <tr>
                  <th>role</th>
                  <th>status</th>
                  <th>attendee</th>
                </tr>
                <xsl:for-each select="attendee">
                  <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                  <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
                  <tr>
                    <td class="role">
                      <xsl:value-of select="role"/>
                    </td>
                    <td class="status">
                      <xsl:value-of select="partstat"/>
                    </td>
                    <td>
                      <xsl:variable name="attendeeUri" select="attendeeUri"/>
                      <a href="{$attendeeUri}">
                        <xsl:choose>
                          <xsl:when test="cn != ''">
                            <xsl:value-of select="cn"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="substring-after(attendeeUri,'mailto:')"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname">
            Calendar:
          </td>
          <td class="fieldval">
            <xsl:variable name="newCalPath" select="/bedework/formElements/form/calendar/path"/>
            <input type="hidden" name="newCalPath" value="{$newCalPath}"/>
            <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
            <!--<span id="bwEventCalDisplay">
              <xsl:choose>
                <xsl:when test="contains(/bedework/formElements/form/calendar/path,$userPath)">
                  <xsl:value-of select="substring-after(/bedework/formElements/form/calendar/path,$userPath)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="/bedework/formElements/form/calendar/path"/>
                </xsl:otherwise>
              </xsl:choose>
            </span>-->
            <a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">copy this event to a calendar</a>
          </td>
        </tr>
        <!--  Transparency  -->
        <!--
        <tr>
          <td class="fieldname">
            Effects free/busy:
          </td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="form/transparency = 'TRANSPARENT'">
                <input type="radio" name="editEvent.transparency" value="OPAQUE"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="editEvent.transparency" value="TRANSPARENT" checked="checked"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="editEvent.transparency" value="OPAQUE" checked="checked"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="editEvent.transparency" value="TRANSPARENT"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>-->
        <xsl:if test="form/link/input/@value != ''">
          <tr>
            <td class="fieldname">See:</td>
            <td class="fieldval">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
                <xsl:value-of select="form/link/input/@value"/>
              </a>
            </td>
          </tr>
        </xsl:if>
        <!--  Status  -->
        <tr>
          <td class="fieldname">
            Status:
          </td>
          <td class="fieldval">
            <xsl:value-of select="form/status"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="event" mode="attendeeReply">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2>
      Meeting Reply
    </h2>
    <table class="common" cellspacing="0">
      <tr>
        <th colspan="2" class="commonHeader">
          <div id="eventActions">
          </div>
          Organizer:
          <xsl:choose>
            <xsl:when test="organizer/cn != ''">
              <xsl:value-of select="organizer/cn"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </tr>
      <tr>
        <td class="fieldname">
          From:
        </td>
        <td class="fieldval scheduleActions">
          <strong>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="attendee/attendeeUri"/></xsl:attribute>
              <xsl:choose>
                <xsl:when test="cn != ''">
                  <xsl:value-of select="cn"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-after(attendee/attendeeUri,'mailto:')"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </strong>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          Status:
        </td>
        <td class="fieldval scheduleActions">
          <xsl:value-of select="attendee/partstat"/>
          <xsl:if test="comments/comment">
            <p><strong>Comments:</strong></p>
            <xsl:for-each select="comment">
              <p><xsl:value-of select="."/></p>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          Action:
        </td>
        <td class="fieldval scheduleActions">
          <form name="processReply" action="{$schedule-processAttendeeReply}">
            <input type="submit" value="Accept" name="update"/>
            <input type="submit" value="cancel" name="cancelled"/>
          </form>
        </td>
      </tr>
      <tr>
        <td class="fieldname">Title:</td>
        <td class="fieldval">
          <strong>
            <xsl:choose>
              <xsl:when test="summary = ''">
                <em>no title</em>
              </xsl:when>
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
      </tr>
      <tr>
        <td class="fieldname">When:</td>
        <td class="fieldval">
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <xsl:if test="start/allday = 'false'">
            <span class="time"><xsl:value-of select="start/time"/></span>
          </xsl:if>
          <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate">
            <xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <span class="time"><em>(all day)</em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
        </td>
        <!--<th class="icon" rowspan="2">
          <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
          <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/resources/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
          </a>
        </th>-->
      </tr>
      <tr>
        <td class="fieldname">Where:</td>
        <td class="fieldval">
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
        <td class="fieldval">
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname">Status:</td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td class="fieldname filler">&#160;</td>
        <td class="fieldval">&#160;</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="event" mode="addEventRef">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$event-addEventRefComplete}" id="standardForm"  enctype="multipart/form-data">
      <xsl:variable name="subscriptionId" select="subscription/id"/>
      <xsl:variable name="calPath" select="calendar/path"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <input type="hidden" name="subid" value="{$subscriptionId}"/>
      <input type="hidden" name="calPath" value="{$calPath}"/>
      <input type="hidden" name="guid" value="{$guid}"/>
      <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
      <!-- newCalPath is the path to the calendar in which the reference
           should be placed.  If no value, then default calendar. -->
      <input type="hidden" name="newCalPath" value=""/>

      <h2>Add Event Reference</h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            Event:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="summary = ''">
                <em>no title</em>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="summary"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Into calendar:
          </td>
          <td align="left">
            <span id="bwEventCalDisplay">
              <em>default calendar</em>
            </span>
            <a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">[change]</a>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Affects Free/busy:
          </td>
          <td align="left">
            <input type="radio" value="OPAQUE" name="transparency"/> yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency" checked="checked"/> no <span class="note">(transparent: event status does not affect your free/busy)</span>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="Continue"/>
            <input name="cancelled" type="submit" value="cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== PREFERENCES ====-->
  <xsl:template match="prefs">
    <h2>Manage Preferences</h2>
    <ul class="submenu">
      <li class="selected">general</li>
      <li><a href="{$prefs-fetchSchedulingForUpdate}">scheduling/meetings</a></li>
    </ul>
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$prefs-update}" onsubmit="setWorkDays(this)">
      <table class="common">
        <tr><td colspan="2" class="fill">User settings:</td></tr>
        <tr>
          <td class="fieldname">
            User:
          </td>
          <td>
            <xsl:value-of select="user"/>
            <xsl:variable name="user" select="user"/>
            <input type="hidden" name="user" value="{$user}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Email address:
          </td>
          <td>
            <xsl:variable name="email" select="email"/>
            <input type="text" name="email" value="{$email}" size="40"/>
          </td>
        </tr>
        <tr><td colspan="2">&#160;</td></tr>
        <tr><td colspan="2" class="fill">Adding events:</td></tr>
        <!-- hide if only one calendar to select -->
        <xsl:if test="count(/bedework/myCalendars/calendars//calendar[currentAccess/current-user-privilege-set/privilege/write-content and calType = '1']) &gt; 1">
          <tr>
            <td class="fieldname">
              Default calendar:
            </td>
            <td>
              <xsl:variable name="newCalPath" select="defaultCalendar/path"/>
              <input type="hidden" name="newCalPath" value="{$newCalPath}"/>
              <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
              <span id="bwEventCalDisplay">
                <xsl:choose>
                  <xsl:when test="contains(defaultCalendar,$userPath)">
                    <xsl:value-of select="substring-after(defaultCalendar,$userPath)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="defaultCalendar"/>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
              <a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">[change]</a>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname">
            Preferred time type:
          </td>
          <td>
            <select name="hour24">
              <option value="false">
                <xsl:if test="hour24 = 'false'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                12 hour + AM/PM
              </option>
              <option value="true">
                <xsl:if test="hour24 = 'true'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                24 hour
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Preferred end date/time type:
          </td>
          <td>
            <select name="preferredEndType">
              <option value="duration">
                <xsl:if test="preferredEndType = 'duration'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                duration
              </option>
              <option value="date">
                <xsl:if test="preferredEndType = 'date'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                date/time
              </option>
            </select>
          </td>
        </tr>
        <tr><td colspan="2">&#160;</td></tr>
        <tr><td colspan="2" class="fill">Workday settings:</td></tr>
        <tr>
          <td class="fieldname">
            Workdays:
          </td>
          <td>
            <xsl:variable name="workDays" select="workDays"/>
            <input type="hidden" name="workDays" value="{$workDays}"/>
            <input type="checkbox" name="workDayIndex" value="0">
              <xsl:if test="substring(workDays,1,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Sun
            </input>
            <input type="checkbox" name="workDayIndex" value="1">
              <xsl:if test="substring(workDays,2,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Mon
            </input>
            <input type="checkbox" name="workDayIndex" value="2">
              <xsl:if test="substring(workDays,3,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Tue
            </input>
            <input type="checkbox" name="workDayIndex" value="3">
              <xsl:if test="substring(workDays,4,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Wed
            </input>
            <input type="checkbox" name="workDayIndex" value="4">
              <xsl:if test="substring(workDays,5,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Thu
            </input>
            <input type="checkbox" name="workDayIndex" value="5">
              <xsl:if test="substring(workDays,6,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Fri
            </input>
            <input type="checkbox" name="workDayIndex" value="6">
              <xsl:if test="substring(workDays,7,1) = 'W'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              Sat
            </input>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Workday start:
          </td>
          <td>
            <select name="workdayStart">
              <xsl:call-template name="buildWorkdayOptionsList">
                <xsl:with-param name="selectedVal" select="workdayStart"/>
              </xsl:call-template>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            Workday end:
          </td>
          <td>
            <xsl:variable name="workdayEnd" select="workdayEnd"/>
            <select name="workdayEnd">
              <xsl:call-template name="buildWorkdayOptionsList">
                <xsl:with-param name="selectedVal" select="workdayEnd"/>
              </xsl:call-template>
            </select>
          </td>
        </tr>
        <tr><td colspan="2">&#160;</td></tr>
        <tr><td colspan="2" class="fill">Display options:</td></tr>
        <xsl:if test="/bedework/views/view[position()=2]">
          <!-- only display if there is more than one to select -->
          <tr>
            <td class="fieldname">
              Preferred view:
            </td>
            <td>
              <xsl:variable name="preferredView" select="preferredView"/>
              <select name="preferredView">
                <xsl:for-each select="/bedework/views/view">
                  <xsl:variable name="viewName" select="name"/>
                  <xsl:choose>
                    <xsl:when test="viewName = $preferredView">
                      <option value="{$viewName}" selected="selected"><xsl:value-of select="name"/></option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$viewName}"><xsl:value-of select="name"/></option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname">
            Preferred view period:
          </td>
          <td>
            <select name="viewPeriod">
              <option value="dayView">
                <xsl:if test="preferredViewPeriod = 'dayView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                day
              </option>
              <option value="todayView">
                <xsl:if test="preferredViewPeriod = 'todayView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                today
              </option>
              <option value="weekView">
                <xsl:if test="preferredViewPeriod = 'weekView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                week
              </option>
              <option value="monthView">
                <xsl:if test="preferredViewPeriod = 'monthView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                month
              </option>
              <option value="yearView">
                <xsl:if test="preferredViewPeriod = 'yearView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                year
              </option>
            </select>
          </td>
        </tr><!-- as you add skins, update this list and set the selected flag
                 as required; hide if not in use -->
        <!--<tr>
          <td class="fieldname">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="skinName"/>
            <select name="skin">
              <option value="default">default</option>
            </select>
          </td>
        </tr> -->
        <!-- if you have skin styles, update this list and set the selected flag
                 as required; hide if not in use -->
        <!--
        <tr>
          <td class="fieldname">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="skinStyle"/>
            <select name="skinStyle">
              <option value="default">default</option>
            </select>
          </td>
        </tr> -->
        <!-- hide if not in use: -->
        <!--<tr>
          <td class="fieldname">
            Interface mode:
          </td>
          <td>
            <select name="userMode">
              <option value="0">
                <xsl:if test="userMode = 0">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                basic
              </option>
              <option value="1">
                <xsl:if test="userMode = 1">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                simple
              </option>
              <option value="3">
                <xsl:if test="userMode = 3">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                advanced
              </option>
            </select>
          </td>
        </tr>-->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="Update"/>
      <input type="reset" value="Reset"/>
      <input type="submit" name="cancelled" value="cancel"/>
    </form>
  </xsl:template>

  <xsl:template match="schPrefs">
    <h2>Manage Preferences</h2>
    <ul class="submenu">
      <li><a href="{$prefs-fetchForUpdate}">general</a></li>
      <li class="selected">scheduling/meetings</li>
    </ul>

      <table class="common" cellspacing="0">
        <tr>
          <th class="leftBorder">Can send me scheduling requests:</th>
          <th class="leftBorder">Can schedule on my behalf:</th>
        </tr>
        <tr>
          <td class="leftBorder padMe">
            <form name="prefsSetAccess1" method="post" action="{$prefs-setAccess}" onsubmit="setScheduleHow(this)">
              <xsl:call-template name="schedulingAccessForm">
                <xsl:with-param name="what">in</xsl:with-param>
              </xsl:call-template>
            </form>
            <xsl:apply-templates select="inbox/acl" mode="currentAccess">
              <xsl:with-param name="action" select="$prefs-setAccess"/>
              <xsl:with-param name="what">in</xsl:with-param>
            </xsl:apply-templates>
          </td>
          <td class="leftBorder padMe">
            <form name="prefsSetAccess2" method="post" action="{$prefs-setAccess}" onsubmit="setScheduleHow(this)">
              <xsl:call-template name="schedulingAccessForm">
                <xsl:with-param name="what">out</xsl:with-param>
              </xsl:call-template>
            </form>
            <xsl:apply-templates select="outbox/acl" mode="currentAccess">
              <xsl:with-param name="action" select="$prefs-setAccess"/>
              <xsl:with-param name="what">out</xsl:with-param>
            </xsl:apply-templates>
          </td>
        </tr>
      </table>
  </xsl:template>

  <!-- construct the workDay times options listings from minute 0 to less than
       minute 1440 (midnight inclusive); initialize the template with the currently
       selected value. Change the default value for "increment" here. minTime
       and maxTime are constants. -->
  <xsl:template name="buildWorkdayOptionsList">
    <xsl:param name="selectedVal"/>
    <xsl:param name="increment" select="number(30)"/>
    <xsl:param name="currentTime" select="number(0)"/>
    <xsl:variable name="minTime" select="number(0)"/>
    <xsl:variable name="maxTime" select="number(1440)"/>
    <xsl:if test="$currentTime &lt; $maxTime">
      <xsl:choose>
        <xsl:when test="$currentTime = $selectedVal">
          <option value="{$currentTime}" selected="selected">
            <xsl:if test="floor($currentTime div 60) &lt; 10">0</xsl:if><xsl:value-of select="floor($currentTime div 60)"/>:<xsl:if test="string-length($currentTime mod 60)=1">0</xsl:if><xsl:value-of select="$currentTime mod 60"/>
          </option>
        </xsl:when>
        <xsl:otherwise>
          <option value="{$currentTime}">
            <xsl:if test="floor($currentTime div 60) &lt; 10">0</xsl:if><xsl:value-of select="floor($currentTime div 60)"/>:<xsl:if test="string-length($currentTime mod 60)=1">0</xsl:if><xsl:value-of select="$currentTime mod 60"/>
          </option>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="buildWorkdayOptionsList">
        <xsl:with-param name="selectedVal" select="$selectedVal"/>
        <xsl:with-param name="currentTime" select="$currentTime + $increment"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!--==== ACCESS CONTROL TEMPLATES ====-->

  <xsl:template match="eventAccess">
    <xsl:variable name="calPathEncoded" select="calendar/encodedPath"/>
    <xsl:variable name="calPath" select="calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <div id="bwEventTab-Access">
      <div id="sharingBox">
        <xsl:apply-templates select="access/acl" mode="currentAccess">
          <xsl:with-param name="action" select="$event-setAccess"/>
          <xsl:with-param name="calPathEncoded" select="$calPathEncoded"/>
          <xsl:with-param name="guid" select="$guid"/>
          <xsl:with-param name="recurrenceId" select="$recurrenceId"/>
        </xsl:apply-templates>
        <form name="eventShareForm" action="{$event-setAccess}" id="shareForm" onsubmit="setAccessHow(this)">
          <input type="hidden" name="calPath" value="{$calPath}"/>
          <input type="hidden" name="guid" value="{$guid}"/>
          <input type="hidden" name="recurid" value="{$recurrenceId}"/>
          <xsl:call-template name="entityAccessForm"/>
        </form>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="schedulingAccessForm">
    <xsl:param name="what"/>
    <input type="hidden" name="what">
      <xsl:attribute name="value"><xsl:value-of select="$what"/></xsl:attribute>
    </input>
    <p>
      <input type="text" name="who" width="40"/>
      <span class="nowrap"><input type="radio" name="whoType" value="user" checked="checked"/>user</span>
      <span class="nowrap"><input type="radio" name="whoType" value="group"/>group</span>
    </p>
    <p>
      <strong>or</strong>
      <span class="nowrap"><input type="radio" name="whoType" value="owner"/>owner</span>
      <span class="nowrap"><input type="radio" name="whoType" value="auth"/>authenticated users</span>
      <span class="nowrap"><input type="radio" name="whoType" value="other"/>anyone</span>
    </p>

    <input type="hidden" name="how" value="S"/>
    <dl>
      <dt>
        <input type="checkbox" name="howSetter" value="S" checked="checked" onchange="toggleScheduleHow(this.form,this)"/>all scheduling
      </dt>
      <dd>
        <input type="checkbox" name="howSetter" value="t" checked="checked" disabled="disabled"/>scheduling requests<br/>
        <input type="checkbox" name="howSetter" value="y" checked="checked" disabled="disabled"/>scheduling replies<br/>
        <input type="checkbox" name="howSetter" value="s" checked="checked" disabled="disabled"/>free-busy requests
      </dd>
    </dl>

    <input type="submit" name="modPrefs" value="Update"/>
    <input type="reset" value="Reset"/>
    <input type="submit" name="cancelled" value="cancel"/>
  </xsl:template>

  <xsl:template name="entityAccessForm">
    <xsl:param name="type"/><!-- optional:
    currently used for inbox and outbox to conditionally
    display scheduling access -->
    <table cellpadding="0" id="shareFormTable" class="common">
      <tr>
        <th colspan="2" class="commonHeader">Add:</th>
      </tr>
      <tr>
        <td>
          <h5>Who:</h5>
          <div class="whoTypes">
            <input type="text" name="who" size="20"/><br/>
            <input type="radio" value="user" name="whoType" checked="checked"/> user
            <input type="radio" value="group" name="whoType"/> group
            <p>OR</p>
            <p>
              <input type="radio" value="auth" name="whoType"/> authenticated<br/>
              <input type="radio" value="other" name="whoType"/> other users
            </p>
          </div>
        </td>
        <td>
          <h5>
            <span id="accessRightsToggle">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>basic
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" checked="checked" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>advanced
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" checked="checked" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>basic
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>advanced
                </xsl:otherwise>
              </xsl:choose>
            </span>
            Rights:
          </h5>
          <input type="hidden" name="how" value=""/>
          <!-- Advanced Access Rights: -->
          <!-- the "how" field is set by iterating over the howItems below -->
          <table id="howTable" class="invisible" cellspacing="0">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">visible</xsl:attribute>
            </xsl:if>
            <tr>
              <th>access type</th>
              <th>allow</th>
              <th>deny</th>
            </tr>
            <tr>
              <td class="level1">
                <input type="checkbox" value="A" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/>All
              </td>
              <td>
                <input type="radio" value="A" name="A" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-A" name="A" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="R" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)" checked="checked"/> Read
              </td>
              <td>
                <input type="radio" value="R" name="R" checked="checked"/>
              </td>
              <td>
                <input type="radio" value="-R" name="R"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="r" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read ACL
              </td>
              <td>
                <input type="radio" value="r" name="r" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-r" name="r" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="P" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read current user privilege set
              </td>
              <td>
                <input type="radio" value="P" name="P" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-P" name="P" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="F" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/> read freebusy
              </td>
              <td>
                <input type="radio" value="F" name="F" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-F" name="F" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="W" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> Write
              </td>
              <td>
                <input type="radio" value="W" name="W" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-W" name="W" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="a" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write ACL
              </td>
              <td>
                <input type="radio" value="a" name="a" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-a" name="a" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="p" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write properties
              </td>
              <td>
                <input type="radio" value="p" name="p" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-p" name="p" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="c" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> write content
              </td>
              <td>
                <input type="radio" value="c" name="c" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-c" name="c" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="b" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> create (bind)
              </td>
              <td>
                <input type="radio" value="b" name="b" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-b" name="b" disabled="disabled"/>
              </td>
            </tr>
            <xsl:if test="$type = 'inbox' or $type = 'outbox'">
              <tr>
                <td class="level4">
                  <input type="checkbox" value="S" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/> schedule
                </td>
              <td>
                <input type="radio" value="S" name="S" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-S" name="S" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="t" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule request
                </td>
              <td>
                <input type="radio" value="t" name="t" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-t" name="t" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="y" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule reply
                </td>
              <td>
                <input type="radio" value="y" name="y" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-y" name="y" disabled="disabled"/>
              </td>
              </tr>
              <tr>
                <td class="level5">
                  <input type="checkbox" value="s" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> schedule free-busy
                </td>
              <td>
                <input type="radio" value="s" name="s" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-s" name="s" disabled="disabled"/>
              </td>
              </tr>
            </xsl:if>
            <tr>
              <td class="level3">
                 <input type="checkbox" value="u" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/> delete (unbind)
              </td>
              <td>
                <input type="radio" value="u" name="u" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-u" name="u" disabled="disabled"/>
              </td>
            </tr>
            <!--<tr>
              <td class="level1">
                <input type="checkbox" value="N" name="howItem" onclick="setupAccessForm(this, this.form)"/> None
              </td>
              <td>
              </td>
              <td>
              </td>
            </tr>-->
          </table>
          <!-- Simple Access Rights: -->
          <!-- the "how" field is set by getting the selected basicHowItem -->
          <ul id="howList">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">invisible</xsl:attribute>
            </xsl:if>
            <li>
              <input type="radio" value="A" name="basicHowItem"/>All
            </li>
            <li>
              <input type="radio" value="R" name="basicHowItem" checked="checked"/>Read only
            </li>
          </ul>

          <!-- below is a simplified listing using radio buttons only; keep for
               those who would like something inbetween the advanced and simple
               interfaces -->
          <!--
          <ul id="howList">
            <li><input type="radio" value="A" name="how"/> <strong>All</strong> (read, write, delete)</li>
            <li class="padTop">
              <input type="radio" value="R" name="how" checked="checked"/> <strong>Read</strong> (content, access, freebusy)
            </li>
            <li>
              <input type="radio" value="F" name="how"/> Read freebusy only
            </li>
            <li class="padTop">
              <input type="radio" value="W" name="how"/> <strong>Write and delete</strong> (content, access, properties)
            </li>
            <li>
              <input type="radio" value="c" name="how"/> Write content only
            </li>
            <li>
             <input type="radio" value="u" name="how"/> Delete only
            </li>
            <li class="padTop">
              <input type="radio" value="Rc" name="how"/> <strong>Read</strong> and <strong>Write content only</strong>
            </li>
            <li class="padTop">
              <input type="radio" value="N" name="how"/> <strong>None</strong>
            </li>
          </ul> -->
        </td>
      </tr>
    </table>
    <input type="submit" name="submit" value="Submit"/>
  </xsl:template>

  <xsl:template match="acl" mode="currentAccess">
    <xsl:param name="action"/> <!-- required -->
    <xsl:param name="calPathEncoded"/> <!-- optional (for entities) -->
    <xsl:param name="guid"/> <!-- optional (for entities) -->
    <xsl:param name="recurrenceId"/> <!-- optional (for entities) -->
    <xsl:param name="what"/> <!-- optional (for scheduling only) -->
    <h3>Current Access:</h3>
      <table class="common scheduling">
        <tr>
          <th>Entry</th>
          <th>Access</th>
          <th>Inherited from</th>
          <td></td>
        </tr>
        <xsl:for-each select="ace">
        <xsl:variable name="who">
          <xsl:choose>
            <xsl:when test="invert">
              <xsl:choose>
                <xsl:when test="invert/principal/href"><xsl:value-of select="normalize-space(invert/principal/href)"/></xsl:when>
                <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="name(invert/principal/*)"/></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="principal/href"><xsl:value-of select="normalize-space(principal/href)"/></xsl:when>
                <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="name(principal/*)"/></xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="whoType">
          <xsl:choose>
            <xsl:when test="contains($who,/bedework/syspars/userPrincipalRoot)">user</xsl:when>
            <xsl:when test="contains($who,/bedework/syspars/groupPrincipalRoot)">group</xsl:when>
            <xsl:when test="$who='authenticated'">auth</xsl:when>
            <xsl:when test="invert/principal/property/owner">other</xsl:when>
            <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
            <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="shortWho">
          <xsl:choose>
            <xsl:when test="$whoType='user'"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedework/syspars/userPrincipalRoot)),'/')"/></xsl:when>
            <xsl:when test="$whoType='group'"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedework/syspars/groupPrincipalRoot)),'/')"/></xsl:when>
            <xsl:otherwise></xsl:otherwise> <!-- if not user or group, send no who -->
          </xsl:choose>
        </xsl:variable>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="$whoType = 'user' or ($who = 'owner' and $whoType != 'other')">
                <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
              </xsl:when>
              <xsl:otherwise>
                <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="$whoType = 'other'">
                anyone (other)
              </xsl:when>
              <xsl:when test="$shortWho != ''">
                <xsl:value-of select="$shortWho"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$who"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="acls">
            <xsl:if test="grant">
              grant:
              <span class="grant">
                <xsl:for-each select="grant/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span><br/>
            </xsl:if>
            <xsl:if test="deny">
              deny:
              <span class="deny">
                <xsl:for-each select="deny/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span>
            </xsl:if>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="inherited">
                <xsl:value-of select="inherited/href"/>
              </xsl:when>
              <xsl:otherwise>
                local
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:if test="not(inherited)">
              <a href="{$action}&amp;how=default&amp;what={$what}&amp;who={$shortWho}&amp;whoType={$whoType}&amp;calPath={$calPathEncoded}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="reset to default">
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="reset to default"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <h2 class="bwStatusConfirmed">
      <div id="searchFilter">
        <form name="searchForm" method="post" action="{$search}">
          Search:
          <input type="text" name="query" size="15">
            <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
          </input>
          <input type="submit" name="submit" value="go"/>
          Limit:
          <xsl:choose>
            <xsl:when test="/bedework/searchResults/searchLimits = 'beforeToday'">
              <input type="radio" name="searchLimits" value="fromToday"/>today forward
              <input type="radio" name="searchLimits" value="beforeToday" checked="checked"/>past dates
              <input type="radio" name="searchLimits" value="none"/>all dates
            </xsl:when>
            <xsl:when test="/bedework/searchResults/searchLimits = 'none'">
              <input type="radio" name="searchLimits" value="fromToday"/>today forward
              <input type="radio" name="searchLimits" value="beforeToday"/>past dates
              <input type="radio" name="searchLimits" value="none" checked="checked"/>all dates
            </xsl:when>
            <xsl:otherwise>
              <input type="radio" name="searchLimits" value="fromToday" checked="checked"/>today forward
              <input type="radio" name="searchLimits" value="beforeToday"/>past dates
              <input type="radio" name="searchLimits" value="none"/>all dates
            </xsl:otherwise>
          </xsl:choose>
        </form>
      </div>
      Search Result
    </h2>
    <table id="searchTable" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="5">
          <xsl:if test="/bedework/searchResults/numPages &gt; 1">
            <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
            <div id="searchPageForm">
              page:
              <xsl:if test="/bedework/searchResults/curPage != 1">
                <xsl:variable name="prevPage" select="number($curPage) - 1"/>
                &lt;<a href="{$search-next}&amp;pageNum={$prevPage}">prev</a>
              </xsl:if>
              <xsl:text> </xsl:text>

              <xsl:call-template name="searchResultPageNav">
                <xsl:with-param name="page">
                  <xsl:choose>
                    <xsl:when test="number($curPage) - 6 &lt; 1">1</xsl:when>
                    <xsl:otherwise><xsl:value-of select="number($curPage) - 6"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>

              <xsl:text> </xsl:text>
              <xsl:choose>
                <xsl:when test="$curPage != /bedework/searchResults/numPages">
                  <xsl:variable name="nextPage" select="number($curPage) + 1"/>
                  <a href="{$search-next}&amp;pageNum={$nextPage}">next</a>&gt;
                </xsl:when>
                <xsl:otherwise>
                  <span class="hidden">next&gt;</span><!-- occupy the space to keep the navigation from moving around -->
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:if>
          <xsl:value-of select="/bedework/searchResults/resultSize"/>
          result<xsl:if test="/bedework/searchResults/resultSize != 1">s</xsl:if> returned
          for <em><xsl:value-of select="/bedework/searchResults/query"/></em>
        </th>
      </tr>
      <xsl:if test="/bedework/searchResults/searchResult">
        <tr class="fieldNames">
          <td>
            relevance
          </td>
          <td>
            summary
          </td>
          <td>
            date &amp; time
          </td>
          <td>
            calendar
          </td>
          <td>
            location
          </td>
        </tr>
      </xsl:if>
      <xsl:for-each select="/bedework/searchResults/searchResult">
        <xsl:variable name="subscriptionId" select="event/subscription/id"/>
        <xsl:variable name="calPath" select="event/calendar/encodedPath"/>
        <xsl:variable name="guid" select="event/guid"/>
        <xsl:variable name="recurrenceId" select="event/recurrenceId"/>
        <tr>
          <td class="relevance">
            <xsl:value-of select="ceiling(number(score)*100)"/>%
            <img src="{$resourcesRoot}/resources/spacer.gif" height="4" class="searchRelevance">
              <xsl:attribute name="width"><xsl:value-of select="ceiling((number(score)*100) div 1.5)"/></xsl:attribute>
            </img>
          </td>
          <td>
            <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:choose>
                <xsl:when test="event/summary = ''">
                  <em>no title</em>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="event/summary"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <td>
            <xsl:value-of select="event/start/longdate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="event/start/time"/>
            <xsl:choose>
              <xsl:when test="event/start/longdate != event/end/longdate">
                - <xsl:value-of select="event/start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="event/end/time"/>
              </xsl:when>
              <xsl:when test="event/start/time != event/end/time">
                - <xsl:value-of select="event/end/time"/>
              </xsl:when>
            </xsl:choose>
          </td>
          <td>
            <xsl:variable name="calUrl" select="event/calendar/encodedPath"/>
            <a href="{$setSelection}&amp;calUrl={$calUrl}">
              <xsl:value-of select="event/calendar/name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="event/location/address"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
    <xsl:variable name="numPages" select="/bedework/searchResults/numPages"/>
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when test="number($curPage) + 6 &gt; number($numPages)"><xsl:value-of select="$numPages"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="number($curPage) + 6"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <xsl:value-of select="$page"/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
       <xsl:call-template name="searchResultPageNav">
         <xsl:with-param name="page" select="number($page)+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--==== SIDE CALENDAR MENU ====-->
  <xsl:template match="calendar" mode="sideList">
    <xsl:variable name="calPath" select="encodedPath"/>
    <div class="std-text">
      <a href="{$setSelection}&amp;calPath={$calPath}"><xsl:value-of select="title"/></a>
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
          <a href="http://www.bedework.org/">Bedework Website</a> |
          <a href="?noxslt=yes">show XML</a> |
          <a href="?refreshXslt=yes">refresh XSLT</a>
        </td>
        <td class="rightCell">
          <!--<form name="skinSelectForm" method="post" action="{$setup}">
            skin selector:
            <select name="skinNameSticky" onchange="submit()">
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
