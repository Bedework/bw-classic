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
  <xsl:variable name="event-selectCalForEvent" select="/bedeworkadmin/urlPrefixes/event/selectCalForEvent/a/@href"/>
  <xsl:variable name="event-initUpload" select="/bedeworkadmin/urlPrefixes/event/initUpload/a/@href"/>
  <xsl:variable name="event-upload" select="/bedeworkadmin/urlPrefixes/event/upload/a/@href"/>
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
  <xsl:variable name="calendar-fetchDescriptions" select="/bedeworkadmin/urlPrefixes/calendar/fetchDescriptions/a/@href"/><!-- used -->
  <xsl:variable name="calendar-initAdd" select="/bedeworkadmin/urlPrefixes/calendar/initAdd/a/@href"/><!-- used -->
  <xsl:variable name="calendar-delete" select="/bedeworkadmin/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calendar/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="calendar-update" select="/bedeworkadmin/urlPrefixes/calendar/update/a/@href"/><!-- used -->
  <xsl:variable name="calendar-setAccess" select="/bedeworkadmin/urlPrefixes/calendar/setAccess/a/@href"/>
  <!-- all good - no need to clean any of these out  -->
  <xsl:variable name="subscriptions-fetch" select="/bedeworkadmin/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedeworkadmin/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedeworkadmin/urlPrefixes/subscriptions/subscribe/a/@href"/>
  <xsl:variable name="view-fetch" select="/bedeworkadmin/urlPrefixes/view/fetch/a/@href"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/view/fetchForUpdate/a/@href"/>
  <xsl:variable name="view-addView" select="/bedeworkadmin/urlPrefixes/view/addView/a/@href"/>
  <xsl:variable name="view-update" select="/bedeworkadmin/urlPrefixes/view/update/a/@href"/>
  <xsl:variable name="view-remove" select="/bedeworkadmin/urlPrefixes/view/remove/a/@href"/>
  <xsl:variable name="system-fetch" select="/bedeworkadmin/urlPrefixes/system/fetch/a/@href"/>
  <xsl:variable name="system-update" select="/bedeworkadmin/urlPrefixes/system/update/a/@href"/>
  <xsl:variable name="calsuite-fetch" select="/bedeworkadmin/urlPrefixes/calsuite/fetch/a/@href"/>
  <xsl:variable name="calsuite-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calsuite/fetchForUpdate/a/@href"/>
  <xsl:variable name="calsuite-add" select="/bedeworkadmin/urlPrefixes/calsuite/add/a/@href"/>
  <xsl:variable name="calsuite-update" select="/bedeworkadmin/urlPrefixes/calsuite/update/a/@href"/>
  <xsl:variable name="calsuite-showAddForm" select="/bedeworkadmin/urlPrefixes/calsuite/showAddForm/a/@href"/>
  <xsl:variable name="calsuite-setAccess" select="/bedeworkadmin/urlPrefixes/calsuite/setAccess/a/@href"/>
  <xsl:variable name="calsuite-fetchPrefsForUpdate" select="/bedeworkadmin/urlPrefixes/calsuite/fetchPrefsForUpdate/a/@href"/>
  <xsl:variable name="calsuite-updatePrefs" select="/bedeworkadmin/urlPrefixes/calsuite/updatePrefs/a/@href"/>
  <xsl:variable name="timezones-initUpload" select="/bedeworkadmin/urlPrefixes/timezones/initUpload/a/@href"/>
  <xsl:variable name="timezones-upload" select="/bedeworkadmin/urlPrefixes/timezones/upload/a/@href"/>
  <xsl:variable name="stats-update" select="/bedeworkadmin/urlPrefixes/stats/update/a/@href"/>
  <!-- === -->
  <xsl:variable name="authuser-showModForm" select="/bedeworkadmin/urlPrefixes/authuser/showModForm/a/@href"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedeworkadmin/urlPrefixes/authuser/showUpdateList/a/@href"/>
  <xsl:variable name="authuser-initUpdate" select="/bedeworkadmin/urlPrefixes/authuser/initUpdate/a/@href"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/authuser/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="authuser-update" select="/bedeworkadmin/urlPrefixes/authuser/update/a/@href"/>
  <xsl:variable name="prefs-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/prefs/fetchForUpdate/a/@href"/><!-- used -->
  <xsl:variable name="prefs-update" select="/bedeworkadmin/urlPrefixes/prefs/update/a/@href"/><!-- used -->
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
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
        <xsl:if test="/bedeworkadmin/page='modEvent'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bwClock.js"></script>
          <link rel="stylesheet" href="{$resourcesRoot}/resources/bwClock.css"/>
          <script type="text/javascript" src="{$resourcesRoot}/resources/dynCalendarWidget.js"></script>
          <link rel="stylesheet" href="{$resourcesRoot}/resources/dynCalendarWidget.css"/>
          <script type="text/javascript" src="{$resourcesRoot}/resources/browserSniffer.js"></script>
        </xsl:if>
        <xsl:if test="/bedeworkadmin/page='upload' or /bedeworkadmin/page='selectCalForEvent'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
        </xsl:if>
        <xsl:if test="/bedeworkadmin/page='calendarDescriptions' or
                      /bedeworkadmin/page='displayCalendar'">
          <link rel="stylesheet" href="{$resourcesRoot}/resources/calendarDescriptions.css"/>
        </xsl:if>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
        <script language="JavaScript" type="text/javascript">
        <xsl:comment>
        <![CDATA[
        // places the cursor in the first available form element when the page is loaded
        // (if a form exists on the page)
        function focusFirstElement() {
          if (window.document.forms[0]) {
            window.document.forms[0].elements[0].focus();
          }
        }]]>
        </xsl:comment>
      </script>
      </head>
      <body onLoad="focusFirstElement()">
        <xsl:choose>
          <xsl:when test="/bedeworkadmin/page='selectCalForEvent'">
            <xsl:call-template name="selectCalForEvent"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="header"/>
            <div id="content">
              <xsl:choose>
                <xsl:when test="/bedeworkadmin/page='eventList'">
                  <xsl:call-template name="eventList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modEvent'">
                  <xsl:call-template name="modEvent"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='displayEvent' or
                                /bedeworkadmin/page='deleteEventConfirm'">
                  <xsl:apply-templates select="/bedeworkadmin/event" mode="displayEvent"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='sponsorList'">
                  <xsl:call-template name="sponsorList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modSponsor'">
                  <xsl:call-template name="modSponsor"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='deleteSponsorConfirm' or
                                /bedeworkadmin/page='sponsorReferenced'">
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
                <xsl:when test="/bedeworkadmin/page='calendarList' or
                                /bedeworkadmin/page='calendarDescriptions' or
                                /bedeworkadmin/page='displayCalendar' or
                                /bedeworkadmin/page='modCalendar' or
                                /bedeworkadmin/page='deleteCalendarConfirm' or
                                /bedeworkadmin/page='calendarReferenced'">
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
                <xsl:when test="/bedeworkadmin/page='deleteViewConfirm'">
                  <xsl:call-template name="deleteViewConfirm"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modSyspars'">
                  <xsl:call-template name="modSyspars"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='calSuiteList'">
                  <xsl:apply-templates select="/bedeworkadmin/calSuites" mode="calSuiteList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='addCalSuite'">
                  <xsl:call-template name="addCalSuite"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modCalSuite'">
                  <xsl:apply-templates select="/bedeworkadmin/calSuite"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='calSuitePrefs'">
                  <xsl:call-template name="calSuitePrefs"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='authUserList'">
                  <xsl:call-template name="authUserList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modAuthUser'">
                  <xsl:call-template name="modAuthUser"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modPrefs'">
                  <xsl:call-template name="modPrefs"/>
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
                <xsl:when test="/bedeworkadmin/page='deleteAdminGroupConfirm'">
                  <xsl:call-template name="deleteAdminGroupConfirm"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='noGroup'">
                  <h2>No administrative group</h2>
                  <p>Your userid has not been assigned to an administrative group.
                    Please inform your administrator.</p>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='upload'">
                  <xsl:call-template name="upload"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='uploadTimezones'">
                  <xsl:call-template name="uploadTimezones"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='showSysStats'">
                  <xsl:apply-templates select="/bedeworkadmin/sysStats" mode="showSysStats"/>
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
          </xsl:otherwise>
        </xsl:choose>
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
          <a id="addEventLink" href="{$event-initAddEvent}" >
            Add
          </a>
        </td>
        <td>
          <a href="{$event-initUpdateEvent}" >
            Edit / Delete
          </a>
        </td>
        <!--
        Disable direct selection by ID; we'll need to find another way
        of quickly getting to events: search and grid views should be implemented. -->
        <!--
        <td>
          Event ID:
          <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
        </td>-->
      </tr>
      <tr>
        <th>Contacts</th>
        <td>
          <a id="addSponsorLink" href="{$sponsor-initAdd}" >
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
          <a id="addLocationLink" href="{$location-initAdd}" >
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

    <xsl:if test="/bedeworkadmin/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedeworkadmin/userInfo/superUser='true'">
      <h4 class="menuTitle">
        Manage Calendar Suite:
        <em><xsl:value-of select="/bedeworkadmin/currentCalSuite/name"/></em>
      </h4>
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
          <a href="{$calsuite-fetchPrefsForUpdate}">
            Manage preferences
          </a>
        </li>
        <li>
          <a href="{$event-initUpload}">
            Upload iCAL file
          </a>
        </li>
      </ul>
    </xsl:if>

    <xsl:if test="/bedeworkadmin/userInfo/contentAdminUser='true'">
      <h4 class="menuTitle">User management</h4>
      <ul class="adminMenu">
        <xsl:if test="/bedeworkadmin/userInfo/userMaintOK='true'">
          <li>
            <a href="{$authuser-initUpdate}" >
              Manage public event administrators
            </a>
          </li>
        </xsl:if>
        <xsl:if test="/bedeworkadmin/userInfo/adminGroupMaintOk='true'">
          <li>
            <a href="{$admingroup-initUpdate}">
              Manage admin groups
            </a>
          </li>
        </xsl:if>
        <li>
          <a href="{$admingroup-switch}">
            Choose/change group...
          </a>
        </li>
        <xsl:if test="/bedeworkadmin/userInfo/userMaintOK='true'">
          <li>
            <form action="{$prefs-fetchForUpdate}" method="post">
              Edit user preferences (enter userid): <input type="text" name="user" size="15"/>
              <input type="submit" name="getPrefs" value="go"/>
            </form>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>

    <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
      <h4 class="menuTitle">Super user features</h4>
      <ul class="adminMenu">
        <li>
          <a href="{$calsuite-fetch}">
            Manage calendar suites
          </a>
        </li>
        <li>
          <a href="{$system-fetch}">
            Manage system preferences
          </a>
        </li>
        <li>
          <a href="{$timezones-initUpload}" >
            Upload and replace system timezones
          </a>
        </li>
        <li>
          System statistics:
          <ul>
            <li>
              <a href="{$stats-update}&amp;fetch=yes">
                admin web client
              </a>
            </li>
            <li>
              <a href="{$publicCal}/stats.do" target="pubClient">
                public web client
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--++++++++++++++++++ Events ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <h2>Edit Events</h2>
    <p>
      Select the event that you would like to update:
      <input type="button" name="return" value="Add new event" onclick="javascript:location.replace('{$event-initAddEvent}')"/>
    </p>

    <form name="peForm" method="post" action="{$event-initUpdateEvent}">
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
        <th>Calendar</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/events/event">
        <xsl:variable name="subscriptionId" select="subscription/id"/>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="guid" select="guid"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <tr>
          <td>
            <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="title"/>
            </a>
          </td>
          <td class="date">
            <xsl:value-of select="start"/>
          </td>
          <td class="date">
            <xsl:value-of select="end"/>
          </td>
          <td>
            <xsl:value-of select="calendar/name"/>
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
            <span id="calDescriptionsLink"><a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')">calendar descriptions</a></span>
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
                <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">invisible</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">
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
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/month/*"/>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/day/*"/>
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/creating = 'true'">
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/start/year/*"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/start/yearText/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <script language="JavaScript" type="text/javascript">
              <xsl:comment>
                startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', 'startDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/resources/');
              </xsl:comment>
              </script>
              <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/start/hour/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/start/minute/*"/>
                  <xsl:if test="/bedeworkadmin/formElements/form/start/ampm">
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/start/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>
                </span>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>End:</strong>
              <xsl:choose>
                <xsl:when test="/bedeworkadmin/formElements/form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              Date
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>invisible</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/month/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/day/*"/>
                  <xsl:choose>
                    <xsl:when test="/bedeworkadmin/creating = 'true'">
                      <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/year/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/yearText/*"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <script language="JavaScript" type="text/javascript">
                <xsl:comment>
                  endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/resources/');
                </xsl:comment>
                </script>
                <!--<img src="{$resourcesRoot}/resources/calIcon.gif" width="16" height="15" border="0"/>-->
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/hour/*"/>
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/minute/*"/>
                    <xsl:if test="/bedeworkadmin/formElements/form/end/dateTime/ampm">
                      <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/ampm/*"/>
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
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                Duration
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="/bedeworkadmin/formElements/form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="durationHrMinClass">
                  <xsl:choose>
                    <xsl:when test="/bedeworkadmin/formElements/form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>shown</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <xsl:choose>
                    <xsl:when test="/bedeworkadmin/formElements/form/end/duration/weeks/input/@value = '0'">
                    <!-- we are using day, hour, minute format -->
                    <!-- must send either no week value or week value of 0 (zero) -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                        <xsl:variable name="daysStr" select="/bedeworkadmin/formElements/form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="/bedeworkadmin/formElements/form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/>hours
                          <xsl:variable name="minutesStr" select="/bedeworkadmin/formElements/form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <xsl:variable name="weeksStr" select="/bedeworkadmin/formElements/form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="true"/>weeks
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="/bedeworkadmin/formElements/form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="true"/>days
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="/bedeworkadmin/formElements/form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="true"/>hours
                          <xsl:variable name="minutesStr" select="/bedeworkadmin/formElements/form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="true"/>minutes
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <xsl:variable name="weeksStr" select="/bedeworkadmin/formElements/form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/>weeks
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div><br/>
              <div class="dateFields" id="noDuration">
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/formElements/form/end/type='N'">
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
          <td class="fieldName">
            Status:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/formElements/form/status = 'TENTATIVE'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE" checked="checked"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:when>
              <xsl:when test="/bedeworkadmin/formElements/form/status = 'CANCELLED'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED" checked="checked"/>cancelled
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="event.status" value="CONFIRMED" checked="checked"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Category  -->
        <!-- Hide this field for now: we will probably use it in a very different
             way now that true calendars are implemented.
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
        </tr> -->

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
              <select name="prefLocationId" id="eventFormPrefLocationList">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/location/preferred/select/*"/>
              </select>
              or Location (all):
            </xsl:if>
            <select name="locationId" id="eventFormLocationList">
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
              <select name="prefSponsorId" id="eventFormSponsorList">
                <option value="-1">
                  Select preferred:
                </option>option>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/preferred/select/*"/>
              </select>
              or Contact (all):
            </xsl:if>
            <select name="sponsorId" id="eventFormPrefSponsorList">
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
              Contact (name):
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
              <xsl:copy-of select="/bedeworkadmin/formElements/form/sponsor/phone/*"/>
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

      <table border="0" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addEvent" value="Add Event"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateEvent" value="Update Event"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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

  <xsl:template match="event" mode="displayEvent">
    <xsl:choose>
      <xsl:when test="/bedeworkadmin/page='deleteEventConfirm'">
        <h2>Ok to delete this event?</h2>
        <p style="width: 400px;">Note: we do not encourage deletion of old but correct events; we prefer to keep
           old events for historical reasons.  Please remove only those events
           that are truly erroneous.</p>
        <p id="confirmButtons">
          <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h2>Event Information</h2>
      </xsl:otherwise>
    </xsl:choose>

    <table class="eventFormTable">
      <tr>
        <th>
          ID:
        </th>
        <td>
          <xsl:value-of select="id"/>
        </td>
      </tr>

      <tr>
        <th>
          Title:
        </th>
        <td>
          <xsl:value-of select="title"/>
        </td>
      </tr>

      <tr>
        <th>
          Calendar:
        </th>
        <td>
          <xsl:value-of select="calendar"/>
        </td>
      </tr>

      <tr>
        <th>
          Start:
        </th>
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
        <th>
          End:
        </th>
        <td>
          <xsl:choose>
            <xsl:when test="end/endtype = 'none'">
              <div class="dateFields" id="noDuration">
                This event has no duration / end date
              </div>
            </xsl:when>
            <xsl:when test="end/endtype = 'duration'">
              <div class="dateFields">
                <div class="invisible" id="endDuration">
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
      <!--<tr>
        <th>
          Category:
        </th>
        <td>
          <xsl:value-of select="category"/>
        </td>
      </tr>-->

      <!--  Description  -->
      <tr>
        <th>
          Description:
        </th>
        <td>
          <xsl:value-of select="desc"/>
        </td>
      </tr>
      <!-- Cost -->
      <tr>
        <th class="optional">
          Price:
        </th>
        <td>
          <xsl:value-of select="cost"/>
        </td>
      </tr>
      <!-- Url -->
      <tr>
        <th class="optional">
          URL:
        </th>
        <td>
          <xsl:variable name="eventLink" select="link"/>
          <a href="{$eventLink}"><xsl:value-of select="link"/></a>
        </td>
      </tr>
      <!-- Location -->
      <tr>
        <th>
          Location:
        </th>
        <td>
          <xsl:value-of select="location"/>
        </td>
      </tr>

      <!-- Sponsor -->
      <tr>
        <th>
          Contact:
        </th>
        <td>
          <xsl:value-of select="sponsor"/>
        </td>
      </tr>

      <!-- Owner -->
      <tr>
        <th>
          Owner:
        </th>
        <td>
          <xsl:value-of select="creator"/>
        </td>
      </tr>

    </table>


    <!--<xsl:if test="/bedeworkadmin/canEdit = 'true' or /bedeworkadmin/userInfo/superUser = 'true'">
      <xsl:variable name="subscriptionId" select="subscription/id"/>
      <xsl:variable name="calPath" select="calendar/encodedPath"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <h3>
        <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
          Edit Event
        </a>
      </h3>
    </xsl:if>-->
  </xsl:template>

  <!--+++++++++++++++ Sponsors (Contacts) ++++++++++++++++++++-->
  <xsl:template name="sponsorList">
    <h2>Edit Contacts</h2>
    <p>
      Select the contact you would like to update:
      <input type="button" name="return" value="Add new contact" onclick="javascript:location.replace('{$sponsor-initAdd}')"/>
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
            <xsl:copy-of select="/bedeworkadmin/formElements/form/phone/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/link/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact Email Address:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/email/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addSponsor" value="Add Contact"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateSponsor" value="Update Contact"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Reset"/>
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
    <h2>Ok to delete this contact?</h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
    </p>

    <table class="eventFormTable">
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
    <h2>Edit Locations</h2>
    <p>
      Select the location that you would like to update:
      <input type="button" name="return" value="Add new location" onclick="javascript:location.replace('{$location-initAdd}')"/>
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
    <xsl:choose>
      <xsl:when test="/bedeworkadmin/creating='true'">
        <h2>Add Location</h2>
      </xsl:when>
      <xsl:otherwise>
        <h2>Update Location</h2>
      </xsl:otherwise>
    </xsl:choose>

    <form action="{$location-update}" method="post">
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
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Location's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/link/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/creating='true'">
              <td>
                <input type="submit" name="addLocation" value="Add Location"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateLocation" value="Update Location"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Reset"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="Delete Location"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="deleteLocationConfirm">
    <h2>Ok to delete this location?</h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
    </p>

    <table class="eventFormTable">
        <tr>
          <td class="fieldName">
            Address:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/location/address"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Subaddress:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/location/subaddress"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Location's URL:
          </td>
          <td>
            <xsl:variable name="link" select="/bedeworkadmin/location/link"/>
            <a href="{$link}"><xsl:value-of select="/bedeworkadmin/location/link"/></a>
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
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/page='calendarDescriptions' or
                              /bedeworkadmin/page='displayCalendar'">
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
            <xsl:when test="/bedeworkadmin/page='calendarList' or
                            /bedeworkadmin/page='calendarReferenced'">
              <xsl:call-template name="calendarList"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='calendarDescriptions'">
              <xsl:call-template name="calendarDescriptions"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='displayCalendar'">
              <xsl:apply-templates select="/bedeworkadmin/currentCalendar" mode="displayCalendar"/>
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

  <xsl:template match="calendar" mode="listForUpdate">
    <xsl:variable name="calPath" select="encodedPath"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
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
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
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
    <div id="sharingBox">
      <h3>Sharing</h3>
      Sharing may be added to a calendar once created.
    </div>
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
    <div id="sharingBox">
      <xsl:variable name="calPath" select="path"/>
      <h3>Sharing</h3>
      <table class="common">
        <tr>
          <th class="commonHeader" colspan="2">Current access:</th>
        </tr>
        <xsl:for-each select="acl/ace">
          <tr>
            <th class="thin">
              <xsl:choose>
                <xsl:when test="invert">
                  <em>Deny to
                  <xsl:choose>
                    <xsl:when test="invert/principal/href">
                      <xsl:value-of select="invert/principal/href"/>
                    </xsl:when>
                    <xsl:when test="invert/principal/property">
                      <xsl:value-of select="name(invert/principal/property/*)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="name(invert/principal/*)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  </em>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="principal/href">
                      <xsl:value-of select="principal/href"/>
                    </xsl:when>
                    <xsl:when test="principal/property">
                      <xsl:value-of select="name(principal/property/*)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="name(principal/*)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </th>
            <td>
              <xsl:for-each select="grant/node()">
                <xsl:value-of select="name(.)"/>&#160;&#160;
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </table>
      <form name="calendarShareForm" action="{$calendar-setAccess}" id="shareForm" method="post">
        <input type="hidden" name="calPath" value="{$calPath}"/>
        <table cellpadding="0" id="shareFormTable" class="common">
          <tr>
            <th colspan="2" class="commonHeader">Add:</th>
          </tr>
          <tr>
            <td>
              <h5>Who:</h5>
              <input type="text" name="who" size="20"/><br/>
              <input type="radio" value="user" name="whoType" checked="checked"/> user
              <input type="radio" value="group" name="whoType"/> group
              <p>OR</p>
              <p>
                <input type="radio" value="auth" name="whoType"/> all authorized users<br/>
                <input type="radio" value="other" name="whoType"/> other users
              </p>
            </td>
            <td>
              <h5>Rights:</h5>
              <ul id="howList">

                <!--<li>
                  <input type="radio" value="A" name="how"/> All
                  <ul>
                    <li>
                      <input type="radio" value="R" name="how" checked="checked"/> Read
                      <ul>
                        <li>
                          <input type="radio" value="r" name="how" disabled="disabled"/> Read acl
                        </li>
                        <li>
                          <input type="radio" value="P" name="how" disabled="disabled"/> Read current user privilege set
                        </li>
                        <li>
                          <input type="radio" value="f" name="how"/> Read free/busy
                        </li>
                      </ul>
                    </li>
                    <li>
                      <input type="radio" value="W" name="how"/> Write
                      <ul>
                        <li>
                          <input type="radio" value="a" name="how" disabled="disabled"/> Write acl
                        </li>
                        <li>
                          <input type="radio" value="p" name="how" disabled="disabled"/> Write properties
                        </li>
                        <li>
                          <input type="radio" value="c" name="how"/> Write content
                        </li>
                        <li>
                          <input type="radio" value="b" name="how" disabled="disabled"/> Bind (includes scheduling)
                        </li>
                        <li>
                          <input type="radio" value="u" name="how"/> Unbind (destroy)
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
                <li>
                  <input type="radio" value="N" name="how"/> None
                </li>-->

                <li><input type="radio" value="A" name="how"/> <strong>All</strong> (read, write, delete)</li>
                <li class="padTop">
                  <input type="radio" value="R" name="how" checked="checked"/> <strong>Read</strong> (content, access, freebusy)
                </li>
                <li>
                  <input type="radio" value="f" name="how"/> Read freebusy only
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
              </ul>
            </td>
          </tr>
        </table>
        <input type="submit" name="submit" value="Submit"/>
      </form>
    </div>
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
    <table class="eventFormTable">
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

  <!-- the selectCalForEvent listing creates a calendar tree in a pop-up window -->
  <xsl:template name="selectCalForEvent">
    <div id="calTreeBlock">
      <h2>Select a calendar</h2>
      <!--<form name="toggleCals" action="{$event-selectCalForEvent}">
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
      </form>-->
      <h4>Calendars</h4>
      <ul id="calendarTree">
         <xsl:apply-templates select="/bedeworkadmin/calendars/calendar" mode="selectCalForEventCalTree"/>
      </ul>
     </div>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForEventCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="calendarCollection='false'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="encodedPath"/>
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:choose>
        <xsl:when test="currentAccess/current-user-privilege-set/privilege/write-content and (calendarCollection = 'true')">
          <a href="javascript:updateEventFormCalendar('{$calPath}','{$calDisplay}')">
            <strong><xsl:value-of select="name"/></strong>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="selectCalForEventCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!--+++++++++++++++ Subscriptions ++++++++++++++++++++-->
  <xsl:template match="subscriptions">
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

  <xsl:template match="subscription" mode="addSubscription">
    <h2>Add New Subscription</h2>
    <p class="note">*the subsciption name must be unique</p>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name*:</th>
          <td>
            <xsl:variable name="subName" select="name"/>
            <input type="text" value="{$subName}" name="subscription.name" size="60"/>
          </td>
        </tr>
        <xsl:if test="internal='false'">
          <tr>
            <th>Uri:</th>
            <td>
              <xsl:variable name="subUri" select="uri"/>
              <input type="text" value="{$subUri}" name="subscription.uri" size="60"/>
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
            <input type="text" value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
        <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
          <tr>
            <th>Unremovable:</th>
            <td>
              <input type="radio" value="true" name="unremoveable" size="60"/> true
              <input type="radio" value="false" name="unremoveable" size="60" checked="checked"/> false
            </td>
          </tr>
        </xsl:if>
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
    <h2>Modify Subscription</h2>
    <form name="subscribeForm" action="{$subscriptions-subscribe}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name*:</th>
          <td>
            <xsl:value-of select="name"/>
            <xsl:variable name="subName" select="name"/>
            <input type="hidden" value="{$subName}" name="name"/>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="internal='false'">
            <tr>
              <th>Uri:</th>
              <td>
                <xsl:variable name="subUri" select="uri"/>
                <input type="text" value="{$subUri}" name="subscription.uri" size="60"/>
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
            <input type="text" value="{$subStyle}" name="subscription.style" size="60"/>
          </td>
        </tr>
        <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
          <tr>
            <th>Unremovable:</th>
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
          </tr>
        </xsl:if>
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
    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>URI</th>
        <th>Style</th>
        <th>Display</th>
        <th>Unremovable</th>
        <th>External</th>
        <th>Deleted?</th>
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
          <td class="center">
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
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <!--<h4><a href="{$subscriptions-initAdd}&amp;calUri=please enter a calendar uri">Subscribe to a remote calendar</a> (by URI)</h4>-->
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
        <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
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
    <h2>Update View</h2>
    <xsl:variable name="viewName" select="/bedeworkadmin/views/view/name"/>
    <h3 class="viewName"><xsl:value-of select="$viewName"/></h3>
    <table id="viewsTable">
      <tr>
        <td class="subs">
          <h3>Available Subscriptions:</h3>

          <table class="subscriptionsListSubs">
            <xsl:for-each select="/bedeworkadmin/subscriptions/subscription">
              <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
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
              <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
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
    <table border="0" id="submitTable">
      <tr>
        <td>
          <input type="button" name="return" value="Return to Views Listing" onclick="javascript:location.replace('{$view-fetch}')"/>
        </td>
        <td align="right">
          <form name="deleteViewForm" action="{$view-fetchForUpdate}" method="post">
            <input type="submit" name="deleteButton" value="Delete View"/>
            <input type="hidden" name="name" value="{$viewName}"/>
            <input type="hidden" name="delete" value="yes"/>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="deleteViewConfirm">
    <h2>Remove View?</h2>

    <xsl:variable name="viewName" select="/bedeworkadmin/views/view/name"/>
    <p>The following view will be removed. Continue?</p>

    <h3 class="viewName"><xsl:value-of select="$viewName"/></h3>
    <form name="removeView" action="{$view-remove}">
      <input type="hidden" name="name" value="{$viewName}"/>
      <input type="submit" name="delete" value="Yes: Remove View"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>

  </xsl:template>

  <!--==== UPLOAD ====-->
  <xsl:template name="upload">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying includes.js -->
    <form name="eventForm" method="post" action="{$event-upload}" id="standardForm"  enctype="multipart/form-data">
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
              <em>none selected</em>
            </span>
            <xsl:text> </xsl:text>
            [<a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small">change</a>]
          </td>
        </tr>
        <!--<tr>
          <td class="fieldname padMeTop">
            Effects free/busy:
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" checked="checked"/> accept event's settings<br/>
            <input type="radio" value="OPAQUE" name="transparency"/> yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency"/> no <span class="note">(transparent: event status does not affect your free/busy)</span><br/>
          </td>
        </tr>-->
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
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--+++++++++++++++ System Parameters (preferences) ++++++++++++++++++++-->
  <xsl:template name="modSyspars">
    <h2>Modify System Parameters</h2>
    <p>
      Do not change unless you know what you're doing.<br/>
      Changes to these parameters have wide impact on the system.
    </p>
    <form name="systemParamsForm" action="{$system-update}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Default timezone:</th>
          <td>
            <xsl:variable name="tzid" select="/bedeworkadmin/system/tzid"/>
            <input value="{$tzid}" name="tzid" size="20"/>
          </td>
          <td>
            Default timezone id for date/time values. This should normally be your local timezone
          </td>
        </tr>
        <tr>
          <th>Default user view name:</th>
          <td>
            <xsl:variable name="defaultViewName" select="/bedeworkadmin/system/defaultUserViewName"/>
            <input value="{$defaultViewName}" name="defaultUserViewName" size="20"/>
          </td>
          <td>
            Name used for default view created when a new user is added
          </td>
        </tr>
        <tr>
          <th>Http connections per user:</th>
          <td>
            <xsl:variable name="httpPerUser" select="/bedeworkadmin/system/httpConnectionsPerUser"/>
            <input value="{$httpPerUser}" name="httpConnectionsPerUser" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Http connections per host:</th>
          <td>
            <xsl:variable name="httpPerHost" select="/bedeworkadmin/system/httpConnectionsPerHost"/>
            <input value="{$httpPerHost}" name="httpConnectionsPerHost" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Total http connections:</th>
          <td>
            <xsl:variable name="httpTotal" select="/bedeworkadmin/system/httpConnections"/>
            <input value="{$httpTotal}" name="httpConnections" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Maximum length of public event description:</th>
          <td>
            <xsl:variable name="maxPublicDescriptionLength" select="/bedeworkadmin/system/maxPublicDescriptionLength"/>
            <input value="{$maxPublicDescriptionLength}" name="maxPublicDescriptionLength" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Maximum length of user event description:</th>
          <td>
            <xsl:variable name="maxUserDescriptionLength" select="/bedeworkadmin/system/maxUserDescriptionLength"/>
            <input value="{$maxUserDescriptionLength}" name="maxUserDescriptionLength" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Maximum size of a user entity:</th>
          <td>
            <xsl:variable name="maxUserEntitySize" select="/bedeworkadmin/system/maxUserEntitySize"/>
            <input value="{$maxUserEntitySize}" name="maxUserEntitySize" size="20"/>
          </td>
          <td>
          </td>
        </tr>
        <tr>
          <th>Default user quota:</th>
          <td>
            <xsl:variable name="defaultUserQuota" select="/bedeworkadmin/system/defaultUserQuota"/>
            <input value="{$defaultUserQuota}" name="defaultUserQuota" size="20"/>
          </td>
          <td>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateSystemParams" value="Update"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Reset"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Calendar Suites (calsuite) ++++++++++++++++++++-->
  <xsl:template match="calSuites" mode="calSuiteList">
    <h2>Manage Calendar Suites</h2>

    <h4>Calendar suites:</h4>
    <p><input type="button" name="return" value="Add calendar suite" onclick="javascript:location.replace('{$calsuite-showAddForm}')"/></p>

    <ul>
      <xsl:for-each select="calSuite">
       <li>
         <xsl:variable name="name" select="name"/>
         <a href="{$calsuite-fetchForUpdate}&amp;name={$name}">
           <xsl:value-of select="name"/>
         </a>
       </li>
      </xsl:for-each>
    </ul>

  </xsl:template>

  <xsl:template name="addCalSuite">
    <h2>Add Calendar Suite</h2>
    <form name="calSuiteForm" action="{$calsuite-add}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name:</th>
          <td>
            <input name="name" size="20"/>
          </td>
          <td>
            Name of your calendar suite
          </td>
        </tr>
        <tr>
          <th>Group:</th>
          <td>
            <input name="groupName" size="20"/>
          </td>
          <td>
            Name of admin group which contains event administrators and event owner to which preferences for the suite are attached
          </td>
        </tr>
        <tr>
          <th>Root calendar:</th>
          <td>
            <input name="calPath" size="20"/>
          </td>
          <td>
            Path of root calendar (not required if suite only consists of subscriptions and views)
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateCalSuite" value="Add"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Reset"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="calSuite" name="modCalSuite">
    <h2>Modify Calendar Suite</h2>
    <xsl:variable name="calSuiteName" select="name"/>
    <form name="calSuiteForm" action="{$calsuite-update}" method="post">
      <table class="eventFormTable">
        <tr>
          <th>Name:</th>
          <td>
            <input name="name" value="{$calSuiteName}" size="20"/>
          </td>
          <td>
            Name of your calendar suite
          </td>
        </tr>
        <tr>
          <th>Group:</th>
          <td>
            <xsl:variable name="group" select="group"/>
            <input name="groupName" value="{$group}" size="20"/>
          </td>
          <td>
            Name of admin group which contains event administrators and event owner to which preferences for the suite are attached
          </td>
        </tr>
        <tr>
          <th>Root calendar:</th>
          <td>
            <xsl:variable name="calPath" select="calPath"/>
            <input name="calPath" value="{$calPath}" size="20"/>
          </td>
          <td>
            Path of root calendar (not required if suite only consists of subscriptions and views)
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateCalSuite" value="Update"/>
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="reset" value="Reset"/>
          </td>
        </tr>
      </table>
    </form>
    <div id="sharingBox">
      <h3>Manage suite administrators</h3>
      <table class="common">
        <tr>
          <th class="commonHeader" colspan="2">Current access:</th>
        </tr>

        <xsl:for-each select="acl/ace">
          <tr>
            <th class="thin">
              <xsl:choose>
                <xsl:when test="invert">
                  <em>Deny to
                  <xsl:choose>
                    <xsl:when test="invert/principal/href">
                      <xsl:value-of select="invert/principal/href"/>
                    </xsl:when>
                    <xsl:when test="invert/principal/property">
                      <xsl:value-of select="name(invert/principal/property/*)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="name(invert/principal/*)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  </em>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="principal/href">
                      <xsl:value-of select="principal/href"/>
                    </xsl:when>
                    <xsl:when test="principal/property">
                      <xsl:value-of select="name(principal/property/*)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="name(principal/*)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </th>
            <td>
              <xsl:for-each select="grant/node()">
                <xsl:value-of select="name(.)"/>&#160;&#160;
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </table>
      <form name="calsuiteShareForm" action="{$calsuite-setAccess}" id="shareForm" method="post">
        <input type="hidden" name="calSuiteName" value="{$calSuiteName}"/>
        <input type="hidden" name="how" value="RW" />
        <p>
          Add administrator:<br/>
          <input type="text" name="who" size="20"/>
          <input type="radio" value="user" name="whoType" checked="checked"/> user
          <input type="radio" value="group" name="whoType"/> group
        </p>
        <input type="submit" name="submit" value="Submit"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="calSuitePrefs">
    <h2>Edit Calendar Suite Preferences</h2>
    <form name="userPrefsForm" method="post" action="{$calsuite-updatePrefs}">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Calendar Suite:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/currentCalSuite/name"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view:
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedeworkadmin/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view period:
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedeworkadmin/prefs/preferredViewPeriod"/>
            <select name="viewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected">day</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView">day</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected">today</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView">today</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected">week</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView">week</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected">month</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView">month</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected">year</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView">year</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="/bedeworkadmin/prefs/skinName"/>
            <input type="text" name="skin" value="{$skinName}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="/bedeworkadmin/prefs/skinStyle"/>
            <input type="text" name="skinStyle" value="{$skinStyle}" size="40"/>
          </td>
        </tr>
      </table>
      <br />

      <input type="submit" name="modPrefs" value="Update"/>
      <input type="reset" value="Reset"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2>Upload Timezones</h2>
    <form name="peForm" method="post" action="{$timezones-upload}" enctype="multipart/form-data">
      <input type="file" name="uploadFile" size="40" value=""/>
      <input type="submit" name="doUpload" value="Upload Timezones"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Authuser ++++++++++++++++++++-->
  <xsl:template name="authUserList">
    <h2>Modify Administrators</h2>

    <div id="authUserInputForms">
      <form name="getUserRolesForm" action="{$authuser-fetchForUpdate}" method="post">
        Edit admin roles by userid: <input type="text" name="editAuthUserId" size="20"/>
        <input type="submit" value="go" name="submit"/>
      </form>
    </div>

    <table id="commonListTable">
      <tr>
        <th>UserId</th>
        <th>Roles</th>
        <th></th>
      </tr>

      <xsl:for-each select="bedeworkadmin/authUsers/authUser">
        <!--<xsl:sort select="account" order="ascending" case-order="upper-first"/>-->
        <tr>
          <td>
            <xsl:value-of select="account"/>
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
          <td>
            <xsl:variable name="account" select="account"/>
            <a href="{$authuser-fetchForUpdate}&amp;editAuthUserId={$account}">
              edit
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAuthUser">
    <h2>Update Administrator</h2>
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
        <!--<tr>
          <td class="optional">
            Email:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/email/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Phone:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/phone/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Department:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/dept/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Last name:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/lastName/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            First name:
          </td>
          <td>
            <xsl:copy-of select="/bedeworkadmin/formElements/form/firstName/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>-->
      </table>
      <br />

      <input type="submit" name="modAuthUser" value="Update"/>
      <input type="reset" value="Reset"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ User Prefs ++++++++++++++++++++-->
  <xsl:template name="modPrefs">
    <h2>Edit User Preferences</h2>
    <form name="userPrefsForm" method="post" action="{$prefs-update}">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            User:
          </td>
          <td>
            <xsl:value-of select="/bedeworkadmin/prefs/user"/>
            <xsl:variable name="user" select="/bedeworkadmin/prefs/user"/>
            <input type="hidden" name="user" value="{$user}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view:
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedeworkadmin/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view period:
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedeworkadmin/prefs/preferredViewPeriod"/>
            <select name="viewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected">day</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView">day</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected">today</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView">today</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected">week</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView">week</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected">month</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView">month</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected">year</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView">year</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="/bedeworkadmin/prefs/skinName"/>
            <input type="text" name="skin" value="{$skinName}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="/bedeworkadmin/prefs/skinStyle"/>
            <input type="text" name="skinStyle" value="{$skinStyle}" size="40"/>
          </td>
        </tr>
      </table>
      <br />

      <input type="submit" name="modPrefs" value="Update"/>
      <input type="reset" value="Reset"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Admin Groups ++++++++++++++++++++-->
  <xsl:template name="listAdminGroups">
    <h2>Modify Groups</h2>
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
    <p><input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="Add a new group"/></p>
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
        <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
        <xsl:variable name="groupName" select="name"/>
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
              <xsl:for-each select="members/member/account">
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
    <p><input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="Add a new group"/></p>
  </xsl:template>

  <xsl:template match="groups" mode="chooseGroup">
    <h2>Choose Your Administrative Group</h2>

    <table id="commonListTable">

      <tr>
        <th>Name</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="group">
        <!--<xsl:sort select="name" order="ascending" case-order="upper-first"/>-->
        <tr>
          <td>
            <xsl:variable name="admGroupName" select="name"/>
            <a href="{$setup}&amp;adminGroupName={$admGroupName}">
              <xsl:copy-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAdminGroup">
    <xsl:choose>
      <xsl:when test="/bedeworkadmin/creating = 'true'">
        <h2>Add Group</h2>
      </xsl:when>
      <xsl:otherwise>
        <h2>Modify Group</h2>
      </xsl:otherwise>
    </xsl:choose>
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
      <table border="0" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/creating = 'true'">
                <input type="submit" name="updateAdminGroup" value="Add Admin Group"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateAdminGroup" value="Update Admin Group"/>
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
    <h2>Update Group Membership</h2>
    <p>Enter a userid (for user or group) and click "add" to update group membership.
    Click the trash icon to remove a user from the group.</p>

    <form name="adminGroupMembersForm" method="post" action="{$admingroup-updateMembers}">
      <p>Add member:
        <input type="text" name="updGroupMember" size="15"/>
        <input type="radio" value="user" name="kind" checked="checked"/>user
        <input type="radio" value="group" name="kind"/>group
        <input type="submit" name="addGroupMember" value="Add"/>
      </p>
    </form>
    <p><input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initUpdate}')" value="Return to Admin Group listing"/></p>

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
          <table id="memberAccountList">
            <xsl:for-each select="/bedeworkadmin/adminGroup/members/member">
              <xsl:choose>
                <xsl:when test="kind='0'"><!-- kind = user -->
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
                    </td>
                    <td>
                      <xsl:value-of select="account"/>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                        <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user" title="remove">
                          <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                        </a>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise><!-- kind = group -->
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
                    </td>
                    <td>
                      <strong><xsl:value-of select="account"/></strong>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                      <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=group" title="remove">
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                      </a>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </table>
    <p>
      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/> user,
      <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/><xsl:text> </xsl:text><strong>group</strong>
    </p>
  </xsl:template>

  <xsl:template name="deleteAdminGroupConfirm">
    <h2>Delete Admin Group?</h2>
    <p>The following group will be deleted. Continue?</p>
    <p>
      <strong><xsl:value-of select="/bedeworkadmin/groups/group/name"/></strong>:
      <xsl:value-of select="/bedeworkadmin/groups/group/desc"/>
    </p>
    <form  name="adminGroupDelete" method="post" action="{$admingroup-delete}">
      <input type="submit" name="removeAdminGroupOK" value="Yes: Delete!"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->

  <xsl:template match="sysStats" mode="showSysStats">
    <h2>System Statistics</h2>

    <p>
      Stats collection:
    </p>
    <ul>
      <li>
        <a href="{$stats-update}&amp;enable=yes">enable</a> |
        <a href="{$stats-update}&amp;disable=yes">disable</a>
      </li>
      <li><a href="{$stats-update}&amp;fetch=yes">fetch statistics</a></li>
      <li><a href="{$stats-update}&amp;dump=yes">dump stats to log</a></li>
    </ul>
    <table id="statsTable" cellpadding="0">
      <xsl:for-each select="*">
        <xsl:choose>
          <xsl:when test="name(.) = 'header'">
            <tr>
              <th colspan="2">
                <xsl:value-of select="."/>
              </th>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td class="label">
                <xsl:value-of select="label"/>
              </td>
              <td class="value">
                <xsl:value-of select="value"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="header">
    <div id="header">
      <a href="http://www.bedework.org">
        <img id="logo"
          alt="logo"
          src="{$resourcesRoot}/resources/bedeworkAdminLogo.gif"
          width="217"
          height="40"
          border="0"/>
      </a>
      <!-- set the page heading: -->
      <h1>
        <xsl:choose>
          <xsl:when test="/bedeworkadmin/page='modEvent' or
                          /bedeworkadmin/page='eventList' or
                          /bedeworkadmin/page='displayEvent'">
            Manage Events
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='sponsorList' or
                          /bedeworkadmin/page='modSponsor' or
                          /bedeworkadmin/page='deleteSponsorConfirm'">
            Manage Contacts
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='locationList' or
                          /bedeworkadmin/page='modLocation' or
                          /bedeworkadmin/page='deleteLocationConfirm'">
            Manage Locations
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='calendarList' or
                          /bedeworkadmin/page='modCalendar' or
                          /bedeworkadmin/page='calendarReferenced' or
                          /bedeworkadmin/page='deleteCalendarConfirm'">
            Manage Calendars
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='calendarDescriptions' or
                          /bedeworkadmin/page='displayCalendar'">
            Public Calendars
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='subscriptions' or
                          /bedeworkadmin/page='modSubscription'">
            Manage Subscriptions
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='views' or
                          /bedeworkadmin/page='modView'">
            Manage Views
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modSyspars'">
            Manage System Preferences
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='authUserList' or
                          /bedeworkadmin/page='modAuthUser'">
            Manage Public Events Administrators
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='chooseGroup'">
            Choose Administrative Group
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='adminGroupList' or
                          /bedeworkadmin/page='modAdminGroup' or
                          /bedeworkadmin/page='modAdminGroup' or
                          /bedeworkadmin/page='modAdminGroupMembers'">
            Manage Administrative Groups
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='noGroup'">
            No Administrative Group
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='uploadTimezones'">
            Manage Time Zones
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
          <a href="{$logout}">Log Out</a>
          <!-- Enable the following two items when debugging skins only -->
          | <a href="?refreshXslt=yes">Refresh XSL</a> |
          <a href="?noxslt=yes">Show XML</a> (view source)
        </td>
        <xsl:if test="/bedeworkadmin/userInfo/user">
          <td class="rightCell">
            <xsl:if test="/bedeworkadmin/currentCalSuite/name">
              Calendar Suite:
              <span class="status">
                <xsl:value-of select="/bedeworkadmin/currentCalSuite/name"/>
              </span>
              &#160;
            </xsl:if>
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
    <div id="titleBar">
      CALENDAR of EVENTS
    </div>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      <a href="http://www.bedework.org/">Bedework website</a>
    </div>
  </xsl:template>
</xsl:stylesheet>
