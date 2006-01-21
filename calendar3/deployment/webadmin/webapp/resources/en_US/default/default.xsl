<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="html"
  indent="yes"
  media-type="text/html"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
  doctype-system="http://www.w3.org/TR/html4/strict.dtd"
  standalone="yes"
  omit-xml-declaration="yes"/>
   <!-- ======================================== -->
  <!--      BEDEWORK ADMIN CLIENT STYLESHEET     -->
  <!-- ========================================= -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="errors.xsl"/>
  <xsl:include href="messages.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the admin client
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot" select="'https://mywebserver.edu/myresourcesdir'"/>
    -->
  <xsl:variable name="resourcesRoot" select="/bedeworkadmin/approot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedeworkadmin/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal. -->
  <xsl:variable name="setup" select="/bedeworkadmin/urlPrefixes/setup/a/@href"/> <!-- used -->
  <xsl:variable name="logout" select="/bedeworkadmin/urlPrefixes/logout/a/@href"/><!-- used -->
  <xsl:variable name="event-showEvent" select="/bedeworkadmin/urlPrefixes/event/showEvent/a/@href"/>
  <xsl:variable name="event-showModForm" select="/bedeworkadmin/urlPrefixes/event/showModForm/a/@href"/>
  <xsl:variable name="event-showUpdateList" select="/bedeworkadmin/urlPrefixes/event/showUpdateList/a/@href"/><!-- used -->
  <xsl:variable name="event-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/event/showDeleteConfirm/a/@href"/>
  <xsl:variable name="event-initAddEvent" select="/bedeworkadmin/urlPrefixes/event/initAddEvent/a/@href"/><!-- used -->
  <xsl:variable name="event-initUpdateEvent" select="/bedeworkadmin/urlPrefixes/event/initUpdateEvent/a/@href"/><!-- used -->
  <xsl:variable name="event-delete" select="/bedeworkadmin/urlPrefixes/event/delete/a/@href"/>
  <xsl:variable name="event-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/event/fetchForDisplay/a/@href"/>
  <xsl:variable name="event-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/event/fetchForUpdate/a/@href"/>
  <xsl:variable name="event-update" select="/bedeworkadmin/urlPrefixes/event/update/a/@href"/>
  <xsl:variable name="event-showClockMap" select="/bedeworkadmin/urlPrefixes/event/showClockMap/a/@href"/>
  <xsl:variable name="sponsor-showSponsor" select="/bedeworkadmin/urlPrefixes/sponsor/showSponsor/a/@href"/>
  <xsl:variable name="sponsor-showReferenced" select="/bedeworkadmin/urlPrefixes/sponsor/showReferenced/a/@href"/>
  <xsl:variable name="sponsor-showModForm" select="/bedeworkadmin/urlPrefixes/sponsor/showModForm/a/@href"/>
  <xsl:variable name="sponsor-showUpdateList" select="/bedeworkadmin/urlPrefixes/sponsor/showUpdateList/a/@href"/>
  <xsl:variable name="sponsor-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/sponsor/showDeleteConfirm/a/@href"/>
  <xsl:variable name="sponsor-initAdd" select="/bedeworkadmin/urlPrefixes/sponsor/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="sponsor-initUpdate" select="/bedeworkadmin/urlPrefixes/sponsor/initUpdate/a/@href"/>
  <xsl:variable name="sponsor-delete" select="/bedeworkadmin/urlPrefixes/sponsor/delete/a/@href"/>
  <xsl:variable name="sponsor-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/sponsor/fetchForDisplay/a/@href"/>
  <xsl:variable name="sponsor-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/sponsor/fetchForUpdate/a/@href"/>
  <xsl:variable name="sponsor-update" select="/bedeworkadmin/urlPrefixes/sponsor/update/a/@href"/>
  <xsl:variable name="location-showLocation" select="/bedeworkadmin/urlPrefixes/location/showLocation/a/@href"/>
  <xsl:variable name="location-showReferenced" select="/bedeworkadmin/urlPrefixes/location/showReferenced/a/@href"/>
  <xsl:variable name="location-showModForm" select="/bedeworkadmin/urlPrefixes/location/showModForm/a/@href"/>
  <xsl:variable name="location-showUpdateList" select="/bedeworkadmin/urlPrefixes/location/showUpdateList/a/@href"/>
  <xsl:variable name="location-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/location/showDeleteConfirm/a/@href"/>
  <xsl:variable name="location-initAdd" select="/bedeworkadmin/urlPrefixes/location/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="location-initUpdate" select="/bedeworkadmin/urlPrefixes/location/initUpdate/a/@href"/>
  <xsl:variable name="location-delete" select="/bedeworkadmin/urlPrefixes/location/delete/a/@href"/>
  <xsl:variable name="location-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/location/fetchForDisplay/a/@href"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/location/fetchForUpdate/a/@href"/>
  <xsl:variable name="location-update" select="/bedeworkadmin/urlPrefixes/location/update/a/@href"/>
  <!-- cals should all be good -->
  <xsl:variable name="calendar-fetch" select="/bedeworkadmin/urlPrefixes/calendar/fetch/a/@href"/><!-- used -->
  <xsl:variable name="calendar-initAdd" select="/bedeworkadmin/urlPrefixes/calendar/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="calendar-delete" select="/bedeworkadmin/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calendar/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="calendar-update" select="/bedeworkadmin/urlPrefixes/calendar/update/a/@href"/><!-- used -->
  <!-- subs and views are all good - no need to clean any of these out  -->
  <xsl:variable name="subscriptions-fetch" select="/bedeworkadmin/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedeworkadmin/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedeworkadmin/urlPrefixes/subscriptions/subscribe/a/@href"/>
  <xsl:variable name="view-fetch" select="/bedeworkadmin/urlPrefixes/view/fetch/a/@href"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/view/fetchForUpdate/a/@href"/>
  <xsl:variable name="view-addView" select="/bedeworkadmin/urlPrefixes/view/addView/a/@href"/>
  <xsl:variable name="view-update" select="/bedeworkadmin/urlPrefixes/view/update/a/@href"/>
  <!-- === -->
  <xsl:variable name="timezones-showUpload" select="/bedeworkadmin/urlPrefixes/timezones/showUpload/a/@href"/>
  <xsl:variable name="timezones-initUpload" select="/bedeworkadmin/urlPrefixes/timezones/initUpload/a/@href"/>
  <xsl:variable name="timezones-upload" select="/bedeworkadmin/urlPrefixes/timezones/upload/a/@href"/>
  <xsl:variable name="authuser-showModForm" select="/bedeworkadmin/urlPrefixes/authuser/showModForm/a/@href"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedeworkadmin/urlPrefixes/authuser/showUpdateList/a/@href"/>
  <xsl:variable name="authuser-initUpdate" select="/bedeworkadmin/urlPrefixes/authuser/initUpdate/a/@href"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/authuser/fetchForUpdate/a/@href"/>
  <xsl:variable name="authuser-update" select="/bedeworkadmin/urlPrefixes/authuser/update/a/@href"/>
  <xsl:variable name="admingroup-showModForm" select="/bedeworkadmin/urlPrefixes/admingroup/showModForm/a/@href"/>
  <xsl:variable name="admingroup-showModMembersForm" select="/bedeworkadmin/urlPrefixes/admingroup/showModMembersForm/a/@href"/>
  <xsl:variable name="admingroup-showUpdateList" select="/bedeworkadmin/urlPrefixes/admingroup/showUpdateList/a/@href"/>
  <xsl:variable name="admingroup-showChooseGroup" select="/bedeworkadmin/urlPrefixes/admingroup/showChooseGroup/a/@href"/>
  <xsl:variable name="admingroup-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/admingroup/showDeleteConfirm/a/@href"/>
  <xsl:variable name="admingroup-initAdd" select="/bedeworkadmin/urlPrefixes/admingroup/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-initUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/initUpdate/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-delete" select="/bedeworkadmin/urlPrefixes/admingroup/delete/a/@href"/>
  <xsl:variable name="admingroup-fetchUpdateList" select="/bedeworkadmin/urlPrefixes/admingroup/fetchUpdateList/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdateMembers/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-update" select="/bedeworkadmin/urlPrefixes/admingroup/update/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-updateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/updateMembers/a/@href"/><!-- used -->
  <xsl:variable name="admingroup-switch" select="/bedeworkadmin/urlPrefixes/admingroup/switch/a/@href"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedeworkadmin/urlprefix"/> -->

  <!-- Other generally useful global variables -->
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!--==== MAIN TEMPLATE  ====-->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Calendar Admin: Events Calendar Administration</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="{$resourcesRoot}/en_US/default/default.css"/>
        <xsl:if test="/bedeworkadmin/page='modEvent'">
          <script language="JavaScript" type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
          <script type='text/javascript' src="{$resourcesRoot}/resources/autoComplete.js"></script>
          <script type='text/javascript' src="{$resourcesRoot}/resources/ui.js"></script>
        </xsl:if>
        <!--<link rel="icon" type="image/ico" href="{}/favicon.ico" />-->
      </head>
      <body>
        <xsl:call-template name="header"/>
        <div id="content">
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/page='eventList'">
              <xsl:call-template name="eventList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modEvent'">
              <xsl:call-template name="modEvent"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='displayEvent'">
              <xsl:apply-templates select="/bedeworkadmin/event" mode="displayEvent"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='sponsorList'">
              <xsl:call-template name="sponsorList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modSponsor'">
              <xsl:call-template name="modSponsor"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='deleteSponsorConfirm'">
              <xsl:call-template name="deleteSponsorConfirm"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='locationList'">
              <xsl:call-template name="locationList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modLocation'">
              <xsl:call-template name="modLocation"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='deleteLocationConfirm'">
              <xsl:call-template name="deleteLocationConfirm"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='calendarList' or /bedeworkadmin/page='modCalendar' or /bedeworkadmin/page='deleteCalendarConfirm'">
              <xsl:apply-templates select="/bedeworkadmin/calendars"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='subscriptions' or /bedeworkadmin/page='modSubscription'">
              <xsl:apply-templates select="/bedeworkadmin/subscriptions"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='views'">
              <xsl:apply-templates select="/bedeworkadmin/views" mode="viewList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modView'">
              <xsl:call-template name="modView"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='authUserList'">
              <xsl:call-template name="authUserList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modAuthUser'">
              <xsl:call-template name="modAuthUser"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='chooseGroup'">
              <xsl:apply-templates select="/bedeworkadmin/groups" mode="chooseGroup"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='adminGroupList'">
              <xsl:call-template name="listAdminGroups"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modAdminGroup'">
              <xsl:call-template name="modAdminGroup"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modAdminGroupMembers'">
              <xsl:call-template name="modAdminGroupMembers"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='noGroup'">
              <h2>No administrative group</h2>
              <p>Your userid has not been assigned to an administrative group.
                Please inform your administrator.</p>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='uploadTimezones'">
              <xsl:call-template name="uploadTimezones"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='noAccess'">
              <h2>No Access</h2>
              <p>
                You have no access to the action you just attempted. If you believe
                you should have access and the problem persists, contact your
                administrator.
              </p>
              <p><a href="{$setup}">continue</a></p>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='error'">
              <h2>Application error</h2>
              <p>An application error occurred.</p>
              <p><a href="{$setup}">continue</a></p>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="mainMenu"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==============================================-->
  <!--==============================================-->
  <!--============= PAGE TEMPLATES =================-->
  <!--==============================================-->
  <!--==============================================-->

  <!--+++++++++++++++ Main Menu ++++++++++++++++++++-->
  <xsl:template name="mainMenu">
    <h2 class="menuTitle">Main Menu</h2>
    <table id="mainMenuTable">
      <tr>
        <th>Events</th>
        <td>
          <a href="{$event-initAddEvent}" >
            Add
          </a>
        </td>
        <td>
          <a href="{$event-initUpdateEvent}" >
            Edit / Delete
          </a>
        </td>
        <td>
          Event ID:
          <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
        </td>
      </tr>
      <tr>
        <th>Contacts</th>
        <td>
          <a href="{$sponsor-initAdd}" >
            Add
          </a>
        </td>
        <td>
          <a href="{$sponsor-initUpdate}" >
            Edit / Delete
          </a>
        </td>
      </tr>
      <tr>
        <th>Locations</th>
        <td>
          <a href="{$location-initAdd}" >
            Add
          </a>
        </td>
        <td>
          <a href="{$location-initUpdate}" >
            Edit / Delete
          </a>
        </td>
      </tr>
    </table>


    <!-- Content admin and super user segment of the page.
         Super user will have content admin access. -->

    <xsl:if test="/bedeworkadmin/userInfo/contentAdminUser='true'">
      <h2 class="menuTitle">Administrator's Menu</h2>
      <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
        <ul class="adminMenu">
          <li>
            <a href="{$calendar-fetch}">
              Manage calendars
            </a>
          </li>
          <li>
            <a href="{$subscriptions-fetch}">
              Manage subscriptions
            </a>
          </li>
          <li>
            <a href="{$view-fetch}">
              Manage views
            </a>
          </li>
          <li>
            <a href="{$timezones-initUpload}" >
              Upload and replace system timezones
            </a>
          </li>
        </ul>
      </xsl:if>
      <h4 class="menuTitle">User management</h4>
      <ul class="adminMenu">
        <xsl:if test="/bedeworkadmin/userInfo/userMaintOK='true'">
          <li>
            <a href="{$authuser-initUpdate}" >
              List authorised users
            </a>
          </li>
        </xsl:if>
        <xsl:if test="/bedeworkadmin/userInfo/adminGroupMaintOk='true'">
          <li>
            Admin Groups:
            <a href="{$admingroup-initAdd}">
              Add
            </a> |
            <a href="{$admingroup-initUpdate}">
              Edit / Delete
            </a>
          </li>
        </xsl:if>
        <li>
          <a href="{$admingroup-switch}" >
            Choose group...
          </a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--++++++++++++++++++ Events ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <p>Select the event that you would like to update:</p>

    <form name="peForm" method="post" action="{$event-showUpdateList}">
      <table>
        <tr>
          <td style="padding-right: 1em;">Show:</td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/listAllSwitchFalse/*"/>
            Active
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/listAllSwitchTrue/*"/>
            All
          </td>
        </tr>
      </table>
    </form>

    <table id="commonListTable">
      <tr>
        <th>Title</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/events/event">
        <tr>
          <td>
            <xsl:copy-of select="title/*"/>
          </td>
          <td class="date">
            <xsl:value-of select="start"/>
          </td>
          <td class="date">
            <xsl:value-of select="end"/>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modEvent">
    <h2>Event Information</h2>

    <xsl:variable name="modEventAction" select="/bedeworkadmin/formElements/form/@action"/>
    <form  name="peForm" method="post" action="{$modEventAction}">
      <table class="eventFormTable">
        <tr>
          <td class="fieldName">
            Title:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/title/*"/>
          </td>
        </tr>

        <tr>
          <td class="fieldName">
            Calendar**:
          </td>
          <td>
            <xsl:if test="/bedeworkadmin/formElements/form/calendar/preferred/select/option">
              <select name="prefCalendarId">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/calendar/preferred/select/*"/>
              </select>
              or Calendar (all):
            </xsl:if>
            <select name="calendarId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/calendar/all/select/*"/>
            </select>
            <xsl:text> </xsl:text>
            <a href="" target="_blank">Calendar Definitions</a>
          </td>
        </tr>

        <tr>
          <td class="fieldName">
            Date &amp; Time:
          </td>
          <td>
            <!-- Set the timefields class for the first load of the page;
                 subsequent changes will take place using javascript without a
                 page reload. -->
            <xsl:variable name="timeFieldsClass">
              <xsl:choose>
                <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">hidden</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">
                <input type="checkbox" name="eventStartDate.dateOnly" onchange="swapAllDayEvent(this)" value="on" checked="checked"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="eventStartDate.dateOnly" onchange="swapAllDayEvent(this)"/>
              </xsl:otherwise>
            </xsl:choose>
            all day event<br/>
            <div class="dateStartEndBox">
              <strong>Start:</strong>
              <div class="dateFields">
                <span class="startDateLabel">Date </span>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/month/*"/>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/day/*"/>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/year/*"/>
              </div>
              <img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/hour/*"/>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/minute/*"/>
                <xsl:if test="/bedeworkadmin/formElements/form/start/ampm">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/start/ampm/*"/>
                </xsl:if>
                <xsl:text> </xsl:text>
                <a href="javascript:launchClockMap('showClockMap.do?dateType=eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>End:</strong>
              <xsl:choose>
                <xsl:when test="/bedeworkadmin/formElements/form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','hidden');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','hidden');"/>
                </xsl:otherwise>
              </xsl:choose>
              Date
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>hidden</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/month/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/day/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/year/*"/>
                </div>
                <img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/hour/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/minute/*"/>
                  <xsl:if test="/bedeworkadmin/formElements/form/end/dateTime/ampm">
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:launchClockMap('showClockMap.do?dateType=eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                </div>
              </div><br/>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onClick="changeClass('endDateTime','hidden');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onClick="changeClass('endDateTime','hidden');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                Duration
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="/bedeworkadmin/formElements/form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>hidden</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <div class="durationBox">
                    <input type="radio" name="eventDuration.type" value="daytime" checked="checked"/>
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/duration/days/*"/>days
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/duration/hours/*"/>hours
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/duration/minutes/*"/>minutes
                  </div>
                  <span class="durationSpacerText">or</span>
                  <div class="durationBox">
                    <input type="radio" name="eventDuration.type" value="weeks"/>
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/duration/weeks/*"/>weeks
                  </div>
                </div>
              </div><br/>
              <xsl:variable name="noDurationClass">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">hidden</xsl:when>
                  <xsl:otherwise>dateFields</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$noDurationClass}" id="noDuration">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='N'">
                    <input type="radio" name="eventEndType" value="N" checked="checked" onClick="changeClass('endDateTime','hidden');changeClass('endDuration','hidden');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="N" onClick="changeClass('endDateTime','hidden');changeClass('endDuration','hidden');"/>
                  </xsl:otherwise>
                </xsl:choose>
                This event has no duration / end date
              </div>
            </div>
          </td>
        </tr>

        <!--  Category  -->
        <tr>
          <td class="fieldName">
            Category**:
          </td>
          <td>
            <xsl:if test="/bedeworkadmin/formElements/form/calendar/preferred/select/option">
              <select name="prefCategoryId">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/category/preferred/select/*"/>
              </select>
              Category (all):
            </xsl:if>
            <select name="categoryId">
              <option value="-1">
                Select:
              </option>option>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/category/all/select/*"/>
            </select>
          </td>
        </tr>

        <!--  Description  -->
        <tr>
          <td class="fieldName">
            Description:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/desc/*"/>
            <div class="fieldInfo">
              Enter all pertinent information, including the academic titles of
              all speakers and/or participants.
              <span class="maxCharNotice">(<xsl:value-of select="/bedeworkadmin/formElements/form/descLength"/> characters max.)</span>
            </div>
          </td>
        </tr>
        <!-- Cost -->
        <tr>
          <td class="optional">
            Price:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/cost/*"/>
            <xsl:text> </xsl:text>
            <span class="fieldInfo">(optional: if any, and place to purchase tickets)</span>
          </td>
        </tr>
        <!-- Url -->
        <tr>
          <td class="optional">
            URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/link/*"/>
            <xsl:text> </xsl:text>
            <span class="fieldInfo">(optional: for more information about the event)</span>
          </td>
        </tr>
        <!-- Location -->
        <tr>
          <td class="fieldName">
            Location**:
          </td>
          <td>
            <xsl:if test="/bedeworkadmin/formElements/form/location/preferred/select/option">
              <select name="prefLocationId">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/location/preferred/select/*"/>
              </select>
              or Location (all):
            </xsl:if>
            <select name="locationId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/location/all/select/*"/>
            </select>
          </td>
        </tr>

       <xsl:if test="/bedeworkadmin/formElements/form/location/address">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text"><span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Address:
            </td>
            <td>
              <xsl:variable name="addressFieldName" select="/bedeworkadmin/formElements/form/location/address/input/@name"/>
              <xsl:variable name="calLocations">
                <xsl:for-each select="/bedeworkadmin/formElements/form/location/all/select/option">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
              </xsl:variable>
              <input type="text" size="30" name="{$addressFieldName}" autocomplete="off" onfocus='autoComplete(this,event,new Array({$calLocations}));'/>
              <div class="fieldInfo">
                Please include room, building, and campus (if not Seattle).
              </div>
            </td>
          </tr>
          <tr>
            <td class="optional">
              <span class="std-text">Location URL:</span>
            </td>
            <td>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/location/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional: for information about the location)</span>
            </td>
          </tr>
        </xsl:if>

        <!-- Sponsor -->
        <tr>
          <td class="fieldName">
            Contact**:
          </td>
          <td>
            <xsl:if test="/bedeworkadmin/formElements/form/sponsor/preferred/select/option">
              <select name="prefSponsorId">
                <option value="-1">
                  Select preferred:
                </option>option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/preferred/select/*"/>
              </select>
              or Contact (all):
            </xsl:if>
            <select name="sponsorId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/all/select/*"/>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" style="padding-top: 1em;">
            <span class="fieldInfo">
              **<strong>If "preferred values" are enabled</strong>
              by your administrator, the category, location, and contact lists will
              contain only those value you've used previously.  If you don't find the value
              you need in one of these lists, use the "all" list adjacent to each
              of these fields.  The event you select from the "all" list will be added
              to your preferred list from that point on.  <strong>Note: if you don't
              find a location or contact at all, you can add a new one from the
              <a href="{$setup}">main menu</a>.</strong>
              Only administrators can create categories, however.
              To make sure you've used the
              correct category, please see the
              <a href="" target="_blank">Calendar Definitions</a>
            </span>
          </td>
        </tr>

        <xsl:if test="/bedeworkadmin/formElements/form/sponsor/name">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text"><span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Contact:
            </td>
            <td>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/name/*"/>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Contact Phone Number:
            </td>
            <td>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/phone/*"/>-
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span>
            </td>
          </tr>
          <tr>
            <td class="optional">
              Contact's URL:
            </td>
            <td>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span>
            </td>
          </tr>
          <tr>
            <td class="optional">
              Contact Email Address:
            </td>
            <td>
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/email/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span> test
              <div id="sponsorEmailAlert">&#160;</div> <!-- space for email warning -->
            </td>
          </tr>
        </xsl:if>
      </table>

      <table border="0" width="100%" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addEvent" value="Add Event" class="padRight"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateEvent" value="Update Event" class="padRight"/>
                <input type="submit" name="cancelled" value="Cancel" class="padRight"/>
                <input type="reset" value="Reset" class="padRight"/>
                <input type="submit" name="copy" value="Duplicate Event"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="Delete Event"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="event" mode="displayEvent">
    <h2>Event Information</h2>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
          ID:
        </td>
        <td>
          <xsl:value-of select="id"/>
        </td>
      </tr>

      <tr>
        <td class="fieldName">
          Title:
        </td>
        <td>
          <xsl:value-of select="title"/>
        </td>
      </tr>

      <tr>
        <td class="fieldName">
          Calendar:
        </td>
        <td>
          <xsl:value-of select="calendar"/>
        </td>
      </tr>

      <tr>
        <td class="fieldName">
          Start:
        </td>
        <td>
          <xsl:value-of select="start/year"/>-<xsl:value-of select="start/month"/>-<xsl:value-of select="start/day"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="start/allDay='true'">
              <strong>all day event</strong>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="start/hour"/>:<xsl:value-of select="start/minute"/>
              <xsl:if test="start/ampm">
                <xsl:value-of select="start/ampm"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="fieldName">
          End:
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="end/endtype = 'none'">
              <div class="dateFields" id="noDuration">
                This event has no duration / end date
              </div>
            </xsl:when>
            <xsl:when test="end/endtype = 'duration'">
              <div class="dateFields">
                <div class="hidden" id="endDuration">
                  <div class="durationBox">
                    <input type="text" name="eventDuration.daysStr" size="2" value="0" onChange="window.document.peForm.durationType[0].checked = true;"/>days
                    <input type="text" name="eventDuration.hoursStr" size="2" value="1" onChange="window.document.peForm.durationType[0].checked = true;"/>hours
                    <input type="text" name="eventDuration.minutesStr" size="2" value="0" onChange="window.document.peForm.durationType[0].checked = true;"/>minutes
                  </div>
                  <span class="durationSpacerText">or</span>
                  <div class="durationBox">
                    <input type="text" name="eventDuration.weeksStr" size="2" value="0" onChange="window.document.peForm.durationType[1].checked = true;"/>weeks
                  </div>
                </div>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="end/dateTime/year"/>-<xsl:value-of select="end/dateTime/month"/>-<xsl:value-of select="end/dateTime/day"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="end/dateTime/hour"/>:<xsl:value-of select="end/dateTime/minute"/>
              <xsl:text> </xsl:text>
              <xsl:if test="end/dateTime/ampm">
                <xsl:value-of select="end/dateTime/ampm"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>

      <!--  Category  -->
      <tr>
        <td class="fieldName">
          Category:
        </td>
        <td>
          <xsl:value-of select="category"/>
        </td>
      </tr>

      <!--  Description  -->
      <tr>
        <td class="fieldName">
          Description:
        </td>
        <td>
          <xsl:value-of select="desc"/>
        </td>
      </tr>
      <!-- Cost -->
      <tr>
        <td class="optional">
          Price:
        </td>
        <td>
          <xsl:value-of select="cost"/>
        </td>
      </tr>
      <!-- Url -->
      <tr>
        <td class="optional">
          URL:
        </td>
        <td>
          <xsl:variable name="eventLink" select="link"/>
          <a href="{$eventLink}"><xsl:value-of select="link"/></a>
        </td>
      </tr>
      <!-- Location -->
      <tr>
        <td class="fieldName">
          Location:
        </td>
        <td>
          <xsl:value-of select="location"/>
        </td>
      </tr>

      <!-- Sponsor -->
      <tr>
        <td class="fieldName">
          Contact:
        </td>
        <td>
          <xsl:value-of select="sponsor"/>
        </td>
      </tr>

      <!-- Owner -->
      <tr>
        <td class="fieldName">
          Owner:
        </td>
        <td>
          <xsl:value-of select="creator"/>
        </td>
      </tr>

    </table>


    <xsl:if test="/bedeworkadmin/canEdit = 'true' or /bedeworkadmin/userInfo/superUser = 'true'">
      <xsl:variable name="id" select="id"/>
      <h3><a href="{$event-fetchForUpdate}&amp;eventId={$id}">Edit Event</a></h3>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ Sponsors (Contacts) ++++++++++++++++++++-->
  <xsl:template name="sponsorList">
    <p>
      Select the contact you would like to update:
    </p>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Phone</th>
        <th>Email</th>
        <th>URL</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/sponsors/sponsor">
        <tr>
          <td>
            <xsl:copy-of select="name" />
          </td>
          <td>
            <xsl:value-of select="phone" />
          </td>
          <td>
            <xsl:variable name="email" select="email"/>
            <a href="mailto:{$email}">
              <xsl:value-of select="email"/>
            </a>
          </td>
          <td>
            <xsl:variable name="link" select="link" />
            <a href="{$link}" target="linktest">
              <xsl:value-of select="link" />
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modSponsor">
    <form action="{$sponsor-update}" method="post">
      <h2>Contact Information</h2>

      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Contact:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/name/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Contact Phone Number:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/phone/*"/> -
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/link/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact Email Address:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/email/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" width="100%" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addSponsor" value="Add Contact" class="padRight"/>
                <input type="submit" name="forwardto" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateSponsor" value="Update Contact" class="padRight"/>
                <input type="submit" name="forwardto" value="Cancel" class="padRight"/>
                <input type="reset" value="Reset" class="padRight"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="Delete Contact"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </table>

    </form>
  </xsl:template>

  <xsl:template name="deleteSponsorConfirm">
    <p>
      <h2>Ok to delete this contact?</h2>
      <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <td><xsl:value-of select="/bedeworkadmin/sponsor/name" /></td>
      </tr>
      <tr>
        <th>Phone</th>
        <td><xsl:value-of select="/bedeworkadmin/sponsor/phone" /></td>
      </tr>
      <tr>
        <th>Email</th>
        <td><xsl:value-of select="/bedeworkadmin/sponsor/email" /></td>
      </tr>
      <tr>
        <th>URL</th>
        <td><xsl:value-of select="/bedeworkadmin/sponsor/link" /></td>
      </tr>
    </table>
  </xsl:template>

   <!--+++++++++++++++ Locations ++++++++++++++++++++-->
  <xsl:template name="locationList">
    <p>
      Select the location that you would like to update:
    </p>

    <table id="commonListTable">
      <tr>
        <th>Address</th>
        <th>Subaddress</th>
        <th>URL</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/locations/location">
        <tr>
          <td>
            <xsl:copy-of select="address/*"/>
          </td>
          <td>
            <xsl:value-of select="subaddress"/>
          </td>
          <td>
            <xsl:variable name="link" select="link" />
            <a href="{$link}" target="linktest">
              <xsl:value-of select="link" />
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modLocation">
    <form action="{$location-update}" method="post">
      <h2>Location Information</h2>

      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Address:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/address/*"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Subaddress:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/subaddress/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Location's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/link/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" width="100%" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addLocation" value="Add Location" class="padRight"/>
                <input type="submit" name="forwardto" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateLocation" value="Update Location" class="padRight"/>
                <input type="submit" name="forwardto" value="Cancel" class="padRight"/>
                <input type="reset" value="Reset" class="padRight"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="Delete Contact"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="deleteLocationConfirm">
    <h2>Ok to delete this location?</h2>
    <xsl:copy-of select="/bedeworkadmin/formElements/*"/>

    <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Address:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/location/address/*"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Subaddress:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/location/subaddress/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Location's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/location/link/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
      </table>
  </xsl:template>

<!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Public calendars</h3>
          <ul id="calendarTree">
            <xsl:apply-templates select="calendar" mode="calendars"/>
          </ul>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/page='calendarList'">
              <xsl:call-template name="calendarList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='deleteCalendarConfirm'">
              <xsl:apply-templates select="/bedeworkadmin/currentCalendar" mode="deleteCalendarConfirm"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <xsl:apply-templates select="/bedeworkadmin/currentCalendar" mode="addCalendar"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedeworkadmin/currentCalendar" mode="modCalendar"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="calendars">
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
          <xsl:apply-templates select="calendar" mode="calendars">
            <xsl:sort select="title" order="ascending" case-order="upper-first"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3>Add Calendar / Folder</h3>
    <form name="addCalForm" action="{$calendar-update}">
      <table class="eventFormTable">
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
            <textarea name="calendar.description" width="60" height="20">
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

      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addCalendar" value="Add Calendar/Folder" class="padRight"/>
            <input type="submit" name="cancelled" value="Cancel" class="padRight"/>
            <input type="reset" value="Clear" class="padRight"/>
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
      <table class="eventFormTable">
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
            <textarea name="calendar.description" width="60" height="20">
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

      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="calendarCollection='true'">
                <input type="submit" name="updateCalendar" value="Update Calendar" class="padRight"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateCalendar" value="Update Folder" class="padRight"/>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="cancelled" value="Cancel" class="padRight"/>
            <input type="reset" value="Reset" class="padRight"/>
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
    <h3>Manage Calendars</h3>
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
      <table class="eventFormTable">
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

      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="cancelled" value="Cancel" class="padRight"/>
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
    <table id="subsTable">
      <tr>
        <td class="cals">
          <h3>Public calendars</h3>
          <p class="smaller">
            Select a calendar below to add a <em><strong>new</strong></em>
            internal subscription or
            <a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">subscribe to an external calendar</a>.
          </p>
          <ul id="calendarTree">
            <xsl:apply-templates select="/bedeworkadmin/subscriptions/subscribe/calendars/calendar" mode="subscribe"/>
          </ul>
        </td>
        <td class="subs">
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/page='subscriptions'">
              <xsl:call-template name="subscriptionList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/creating='true'">
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
            <xsl:sort select="title" order="ascending" case-order="upper-first"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="subscription" mode="addSubscription">
    <h2>Add new subscription</h2>
    <p class="note">*the subsciption name must be unique</p>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name*:</th>
          <td>
            <xsl:variable name="subName" select="name"/>
            <input value="{$subName}" name="subscription.name" size="60"/>
          </td>
        </tr>
        <xsl:if test="internal='false'">
          <tr>
            <th>Uri:</th>
            <td>
              <xsl:variable name="subUri" select="uri"/>
              <input value="{$subUri}" name="subscription.uri" size="60"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <th>Display:</th>
          <td>
            <input type="radio" value="true" name="subscription.display"/> yes
            <input type="radio" value="false" name="subscription.display" checked="checked"/> no
          </td>
        </tr>
        <tr>
          <th>Style:</th>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
      </table>
      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="addSubscription" value="Add Subscription" class="padRight"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Clear"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="subscription" mode="modSubscription">
    <h2>Modify subscription</h2>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name*:</th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="internal='false'">
            <tr>
              <th>Uri:</th>
              <td>
                <xsl:variable name="subUri" select="uri"/>
                <input value="{$subUri}" name="subscription.uri" size="60"/>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <th>Uri:</th>
              <td>
                <xsl:value-of select="uri"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
        <tr>
          <th>Display:</th>
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
          <th>Style:</th>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
      </table>
      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateSubscription" value="Update Subscription" class="padRight"/>
            <input type="submit" name="cancelled" value="Cancel" class="padRight"/>
            <input type="reset" value="Reset" class="padRight"/>
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
    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>URI</th>
        <th>Style</th>
        <th>Display</th>
        <th>External</th>
        <th>Deleted?</th>
      </tr>
      <xsl:for-each select="subscription">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
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
          <td class="center">
            <xsl:if test="internal='false'">
              <img src="{$resourcesRoot}/resources/greenCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>
          <td class="center">
            <xsl:if test="calendarDeleted='true'">
              <img src="{$resourcesRoot}/resources/redCheckIcon.gif" width="13" height="13" alt="true" border="0"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <h4><a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">Subscribe to a remote calendar</a> (by URI)</h4>
  </xsl:template>

  <!--+++++++++++++++ Views ++++++++++++++++++++-->
  <xsl:template match="views" mode="viewList">

    <h3>Add a new view</h3>
    <form name="addView" action="{$view-addView}" method="post">
      <input type="text" name="name" size="60"/>
      <input type="submit" value="add view" name="addview"/>
    </form>

    <h3>Views</h3>
    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Included subscriptions</th>
      </tr>

      <xsl:for-each select="view">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <tr>
          <td>
            <xsl:variable name="viewName" select="name"/>
            <a href="{$view-fetchForUpdate}&amp;name={$viewName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:for-each select="subscriptions/subscription">
              <xsl:value-of select="name"/>
              <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modView">
    <xsl:variable name="viewName" select="/bedeworkadmin/views/view/name"/>

    <h2>Update View</h2>

    <h3 class="viewName"><xsl:value-of select="$viewName"/></h3>
    <table id="viewsTable">
      <tr>
        <td class="subs">
          <h3>Available Subscriptions:</h3>

          <table class="subscriptionsListSubs">
            <xsl:for-each select="/bedeworkadmin/subscriptions/subscription">
              <xsl:sort select="name" order="ascending" case-order="upper-first"/>
              <xsl:if test="not(/bedeworkadmin/views/view/subscriptions/subscription/name=name)">
                <tr>
                  <td>
                    <xsl:value-of select="name"/>
                  </td>
                  <td class="arrows">
                    <xsl:variable name="subAddName" select="name"/>
                    <a href="{$view-update}&amp;name={$viewName}&amp;add={$subAddName}">
                      <img src="{$resourcesRoot}/resources/arrowRight.gif"
                        width="13" height="13" border="0"
                        alt="add subscription"/>
                    </a>
                  </td>
                </tr>
              </xsl:if>
            </xsl:for-each>
          </table>
        </td>
        <td class="view">
          <h3>Active Subscriptions:</h3>
          <table class="subscriptionsListView">
            <xsl:for-each select="/bedeworkadmin/views/view/subscriptions/subscription">
              <xsl:sort select="name" order="ascending" case-order="upper-first"/>
              <tr>
                <td class="arrows">
                  <xsl:variable name="subRemoveName" select="name"/>
                  <a href="{$view-update}&amp;name={$viewName}&amp;remove={$subRemoveName}">
                    <img src="{$resourcesRoot}/resources/arrowLeft.gif"
                        width="13" height="13" border="0"
                        alt="add subscription"/>
                  </a>
                </td>
                <td>
                  <xsl:value-of select="name"/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </table>
    <table border="0" width="100%" id="submitTable">
      <tr>
        <td>
          <input type="button" name="return" value="Return to Views Listing" class="padRight" onclick="javascript:location.replace('{$view-fetch}')"/>
        </td>
        <td align="right">
          <input type="button" name="delete" value="Delete View" onclick="{$view-fetch}"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2>Upload Timezones</h2>
    <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
  </xsl:template>

  <!--+++++++++++++++ Authuser ++++++++++++++++++++-->
  <xsl:template name="authUserList">

    <p>Click on the user that you would like to update:</p>

    <table id="commonListTable">
      <tr>
        <th>Userid</th>
        <th>Roles</th>
      </tr>

      <xsl:for-each select="bedeworkadmin/authUsers/authUser">
        <tr>
          <td>
            <xsl:copy-of select="account/*"/>
          </td>
          <td>
            <xsl:if test="publicEventUser='true'">
              publicEvent; <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="superUser='true'">
              superUser; <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="alertUser='true'">
              alert; <xsl:text> </xsl:text>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAuthUser">

    <xsl:variable name="modAuthUserAction" select="/bedeworkadmin/formElements/form/@action"/>
    <form action="{$modAuthUserAction}" method="post">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Account:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/formElements/form/account"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Alerts:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/alerts/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Public Events:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/publicEvents/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Super User:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/superUser/*"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Email:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/email/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Phone:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/phone/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Department:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/dept/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Last name:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/lastName/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            First name:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/firstName/*"/>
            <span class="fieldInfo">(optional)</span>
          </td>
        </tr>
      </table>
      <br />

      <input type="submit" name="modAuthUser" value="Update"/>
      <input type="reset" value="Reset"/>
    </form>
  </xsl:template>


  <!--+++++++++++++++ Admin Groups ++++++++++++++++++++-->

  <xsl:template name="listAdminGroups">
    <form name="adminGroupMembersForm" method="post" action="{$admingroup-initUpdate}">
      <xsl:choose>
        <xsl:when test="/bedeworkadmin/groups/showMembers='true'">
          <input type="radio" name="showAgMembers" value="false" onclick="document.adminGroupMembersForm.submit();"/>
          Hide members
          <input type="radio" name="showAgMembers" value="true" checked="checked" onclick="document.adminGroupMembersForm.submit();"/>
          Show members
        </xsl:when>
        <xsl:otherwise>
          <input type="radio" name="showAgMembers" value="false" checked="checked" onclick="document.adminGroupMembersForm.submit();"/>
          Hide members
          <input type="radio" name="showAgMembers" value="true" onclick="document.adminGroupMembersForm.submit();"/>
          Show members
        </xsl:otherwise>
      </xsl:choose>
    </form>

    <p>Click on the group name to modify the group owner or description.<br/>
    Click "add/remove members" to modify group membership.</p>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Description</th>
        <xsl:if test="/bedeworkadmin/groups/showMembers='true'">
          <th>Members</th>
        </xsl:if>
        <th></th>
      </tr>
      <xsl:for-each select="/bedeworkadmin/groups/group">
        <xsl:variable name="groupName"><xsl:copy-of select="name/*"/></xsl:variable>
        <!-- this data (groupname) apparently needs cleaning: there is %0A and other characters in it -->
        <tr>
          <td>
            <a href="{$admingroup-fetchForUpdate}&amp;adminGroupName={$groupName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
          <xsl:if test="/bedeworkadmin/groups/showMembers='true'">
            <td>
              <xsl:for-each select="members/member">
                  <xsl:value-of select="."/>&#160;
              </xsl:for-each>
            </td>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdateMembers}&amp;adminGroupName={$groupName}">Add/Remove members</a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="groups" mode="chooseGroup">
    <h2>Choose Your Administrative Group</h2>

    <table id="commonListTable">

      <tr>
        <th>Name</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="group">
        <tr>
          <td>
            <xsl:copy-of select="name"/>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAdminGroup">

    <form name="peForm" method="post" action="{$admingroup-update}">
      <table id="adminGroupFormTable">
        <tr>
          <td class="fieldName">
            Name:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/creating = 'true'">
                <xsl:copy-of select="/bedeworkadmin/formElements/form/name/*"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of  select="/bedeworkadmin/formElements/form/name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Description:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/desc/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Group owner:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/groupOwner/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Events owner:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/eventsOwner/*"/>
          </td>
        </tr>
      </table>
      <table border="0" width="100%" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/creating = 'true'">
                <input type="submit" name="updateAdminGroup" value="Add Admin Group" class="padRight"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateAdminGroup" value="Update Admin Group" class="padRight"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Reset"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td align="right">
            <input type="submit" name="delete" value="Delete"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="modAdminGroupMembers">

    <p><a href="{$admingroup-initUpdate}">return to Admin Group listing</a></p>

    <form name="adminGroupMembersForm" method="post" action="{$admingroup-updateMembers}">
      <table id="adminGroupFormTable">
        <tr>
          <td class="fieldName">
            Name:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/adminGroup/name"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Members:
          </td>
          <td>
            <xsl:for-each select="/bedeworkadmin/adminGroup/members/member">
              <xsl:value-of select="."/>&#160;
            </xsl:for-each>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Add/remove member:
          </td>
          <td>
            <input type="text" name="updGroupMember" size="15"/>
            <input type="submit" name="addGroupMember" value="Add"/>
            <input type="submit" name="removeGroupMember" value="Remove"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="header">
    <div id="header">
     <!-- Uncomment this code and replace the following logo
          to brand your administrative interface.

      <img id="logo"
          alt="logo"
          src="{$resourcesRoot}/resources/caladminlogo.gif"
          align="right"
          border="0"/> -->

      <!-- set the page heading: -->
      <h1>
        <xsl:choose>
          <xsl:when test="/bedeworkadmin/page='modEvent' or
                          /bedeworkadmin/page='eventList'">
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/creating='true'">
                Add a Public Event
              </xsl:when>
              <xsl:otherwise>
                Update a Public Event
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='displayEvent'">
            Display Event
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='sponsorList'">
            Manage Contacts
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modSponsor'">
            Update Contact Info
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='deleteSponsorConfirm'">
            Delete Contact
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='locationList'">
            Manage Locations
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modLocation'">
            Update Location
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='deleteLocationConfirm'">
            Delete Location
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='calendarList' or /bedeworkadmin/page='modCalendar'">
            Manage Calendars
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='subscriptions' or /bedeworkadmin/page='modSubscription'">
            Manage Subscriptions
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='views' or /bedeworkadmin/page='modView'">
            Manage Views
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='authUserList'">
            Manage Authorized Users
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modAuthUser'">
            Update Authorized User
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='chooseGroup'">
            Choose Administrative Group
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='adminGroupList'">
            Manage Administrative Groups
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modAdminGroup'">
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/creating = 'true'">
                Add Administrative Group
              </xsl:when>
              <xsl:otherwise>
                Update Administrative Group
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modAdminGroupMembers'">
            Update Administrative Group Members
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='noGroup'">
            No Administrative Group
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='uploadTimezones'">
            Time Zones
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='noAccess'">
            Access Denied
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='error'">
            Error
          </xsl:when>
          <xsl:otherwise>
            Bedework Calendar Administration
          </xsl:otherwise>
        </xsl:choose>
      </h1>

      <xsl:if test="/bedeworkadmin/message">
        <div id="messages">
          <p><xsl:apply-templates select="/bedeworkadmin/message"/></p>
        </div>
      </xsl:if>
      <xsl:if test="/bedeworkadmin/error">
        <div id="errors">
          <p><xsl:apply-templates select="/bedeworkadmin/error"/></p>
        </div>
      </xsl:if>

    </div>
    <table id="statusBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$setup}">Main Menu</a> |
          <a href="{$publicCal}" target="calendar">Launch Calendar</a> |
          <a href="{$logout}">Log Out</a> |
          <!-- Enable the following two items when debugging skins only -->
          <a href="?refreshXslt=yes">Refresh XSL</a> |
          <a href="?noxslt=yes">Show XML</a> (view source)
        </td>
        <xsl:if test="/bedeworkadmin/userInfo/user">
          <td class="rightCell">
            Logged in as:
            <span class="status">
              <xsl:value-of select="/bedeworkadmin/userInfo/user"/>
            </span>
            &#160;
            <xsl:if test="/bedeworkadmin/userInfo/group">
              Group:
              <span class="status">
                <xsl:value-of select="/bedeworkadmin/userInfo/group"/>
              </span>
            </xsl:if>
          </td>
        </xsl:if>
      </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="50%"><img alt="" src="{$resourcesRoot}/resources/std-title-space.gif"
                             width="100%" height="16" border="0"/></td>
        <td><img src="{$resourcesRoot}/resources/std-title.gif" width="485" height="16"
                 border="0"
                 alt="Calendar of Events"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/resources/std-title-space.gif"
                             width="100%" height="16" border="0"/></td>
      </tr>
    </table>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      <a href="http://www.bedework.org/">Bedework website</a>
    </div>
  </xsl:template>
</xsl:stylesheet>
