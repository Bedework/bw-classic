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
   <xsl:strip-space elements="*"/>

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
  <xsl:include href="/bedework-common/default/default/errors.xsl"/>
  <xsl:include href="/bedework-common/default/default/messages.xsl"/>

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
       urls; allows the application to be used without cookies or within a portal.
       we will probably change the way we create these before long (e.g. build them
       dynamically in the xslt). -->
  <xsl:variable name="setup" select="/bedeworkadmin/urlPrefixes/setup/a/@href"/>
  <xsl:variable name="logout" select="/bedeworkadmin/urlPrefixes/logout/a/@href"/>
  <xsl:variable name="search" select="/bedeworkadmin/urlPrefixes/search/search/a/@href"/>
  <xsl:variable name="search-next" select="/bedeworkadmin/urlPrefixes/search/next/a/@href"/>
  <!-- events -->
  <xsl:variable name="event-showEvent" select="/bedeworkadmin/urlPrefixes/event/showEvent/a/@href"/>
  <xsl:variable name="event-showModForm" select="/bedeworkadmin/urlPrefixes/event/showModForm/a/@href"/>
  <xsl:variable name="event-showUpdateList" select="/bedeworkadmin/urlPrefixes/event/showUpdateList/a/@href"/>
  <xsl:variable name="event-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/event/showDeleteConfirm/a/@href"/>
  <xsl:variable name="event-initAddEvent" select="/bedeworkadmin/urlPrefixes/event/initAddEvent/a/@href"/>
  <xsl:variable name="event-initUpdateEvent" select="/bedeworkadmin/urlPrefixes/event/initUpdateEvent/a/@href"/>
  <xsl:variable name="event-delete" select="/bedeworkadmin/urlPrefixes/event/delete/a/@href"/>
  <xsl:variable name="event-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/event/fetchForDisplay/a/@href"/>
  <xsl:variable name="event-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/event/fetchForUpdate/a/@href"/>
  <xsl:variable name="event-update" select="/bedeworkadmin/urlPrefixes/event/update/a/@href"/>
  <xsl:variable name="event-selectCalForEvent" select="/bedeworkadmin/urlPrefixes/event/selectCalForEvent/a/@href"/>
  <xsl:variable name="event-initUpload" select="/bedeworkadmin/urlPrefixes/event/initUpload/a/@href"/>
  <xsl:variable name="event-upload" select="/bedeworkadmin/urlPrefixes/event/upload/a/@href"/>
  <!-- contacts -->
  <xsl:variable name="contact-showContact" select="/bedeworkadmin/urlPrefixes/contact/showContact/a/@href"/>
  <xsl:variable name="contact-showReferenced" select="/bedeworkadmin/urlPrefixes/contact/showReferenced/a/@href"/>
  <xsl:variable name="contact-showModForm" select="/bedeworkadmin/urlPrefixes/contact/showModForm/a/@href"/>
  <xsl:variable name="contact-showUpdateList" select="/bedeworkadmin/urlPrefixes/contact/showUpdateList/a/@href"/>
  <xsl:variable name="contact-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/contact/showDeleteConfirm/a/@href"/>
  <xsl:variable name="contact-initAdd" select="/bedeworkadmin/urlPrefixes/contact/initAdd/a/@href"/>
  <xsl:variable name="contact-initUpdate" select="/bedeworkadmin/urlPrefixes/contact/initUpdate/a/@href"/>
  <xsl:variable name="contact-delete" select="/bedeworkadmin/urlPrefixes/contact/delete/a/@href"/>
  <xsl:variable name="contact-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/contact/fetchForDisplay/a/@href"/>
  <xsl:variable name="contact-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/contact/fetchForUpdate/a/@href"/>
  <xsl:variable name="contact-update" select="/bedeworkadmin/urlPrefixes/contact/update/a/@href"/>
  <!-- locations -->
  <xsl:variable name="location-showLocation" select="/bedeworkadmin/urlPrefixes/location/showLocation/a/@href"/>
  <xsl:variable name="location-showReferenced" select="/bedeworkadmin/urlPrefixes/location/showReferenced/a/@href"/>
  <xsl:variable name="location-showModForm" select="/bedeworkadmin/urlPrefixes/location/showModForm/a/@href"/>
  <xsl:variable name="location-showUpdateList" select="/bedeworkadmin/urlPrefixes/location/showUpdateList/a/@href"/>
  <xsl:variable name="location-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/location/showDeleteConfirm/a/@href"/>
  <xsl:variable name="location-initAdd" select="/bedeworkadmin/urlPrefixes/location/initAdd/a/@href"/>
  <xsl:variable name="location-initUpdate" select="/bedeworkadmin/urlPrefixes/location/initUpdate/a/@href"/>
  <xsl:variable name="location-delete" select="/bedeworkadmin/urlPrefixes/location/delete/a/@href"/>
  <xsl:variable name="location-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/location/fetchForDisplay/a/@href"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/location/fetchForUpdate/a/@href"/>
  <xsl:variable name="location-update" select="/bedeworkadmin/urlPrefixes/location/update/a/@href"/>
  <!-- categories -->
  <xsl:variable name="category-showReferenced" select="/bedeworkadmin/urlPrefixes/category/showReferenced/a/@href"/>
  <xsl:variable name="category-showModForm" select="/bedeworkadmin/urlPrefixes/category/showModForm/a/@href"/>
  <xsl:variable name="category-showUpdateList" select="/bedeworkadmin/urlPrefixes/category/showUpdateList/a/@href"/>
  <xsl:variable name="category-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/category/showDeleteConfirm/a/@href"/>
  <xsl:variable name="category-initAdd" select="/bedeworkadmin/urlPrefixes/category/initAdd/a/@href"/>
  <xsl:variable name="category-initUpdate" select="/bedeworkadmin/urlPrefixes/category/initUpdate/a/@href"/>
  <xsl:variable name="category-delete" select="/bedeworkadmin/urlPrefixes/category/delete/a/@href"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/category/fetchForUpdate/a/@href"/>
  <xsl:variable name="category-update" select="/bedeworkadmin/urlPrefixes/category/update/a/@href"/>
  <!-- calendars -->
  <xsl:variable name="calendar-fetch" select="/bedeworkadmin/urlPrefixes/calendar/fetch/a/@href"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedeworkadmin/urlPrefixes/calendar/fetchDescriptions/a/@href"/>
  <xsl:variable name="calendar-initAdd" select="/bedeworkadmin/urlPrefixes/calendar/initAdd/a/@href"/>
  <xsl:variable name="calendar-delete" select="/bedeworkadmin/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calendar/fetchForUpdate/a/@href"/>
  <xsl:variable name="calendar-update" select="/bedeworkadmin/urlPrefixes/calendar/update/a/@href"/>
  <xsl:variable name="calendar-setAccess" select="/bedeworkadmin/urlPrefixes/calendar/setAccess/a/@href"/>
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedeworkadmin/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedeworkadmin/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedeworkadmin/urlPrefixes/subscriptions/subscribe/a/@href"/>
  <!-- views -->
  <xsl:variable name="view-fetch" select="/bedeworkadmin/urlPrefixes/view/fetch/a/@href"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/view/fetchForUpdate/a/@href"/>
  <xsl:variable name="view-addView" select="/bedeworkadmin/urlPrefixes/view/addView/a/@href"/>
  <xsl:variable name="view-update" select="/bedeworkadmin/urlPrefixes/view/update/a/@href"/>
  <xsl:variable name="view-remove" select="/bedeworkadmin/urlPrefixes/view/remove/a/@href"/>
  <!-- system -->
  <xsl:variable name="system-fetch" select="/bedeworkadmin/urlPrefixes/system/fetch/a/@href"/>
  <xsl:variable name="system-update" select="/bedeworkadmin/urlPrefixes/system/update/a/@href"/>
  <!-- calsuites -->
  <xsl:variable name="calsuite-fetch" select="/bedeworkadmin/urlPrefixes/calsuite/fetch/a/@href"/>
  <xsl:variable name="calsuite-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calsuite/fetchForUpdate/a/@href"/>
  <xsl:variable name="calsuite-add" select="/bedeworkadmin/urlPrefixes/calsuite/add/a/@href"/>
  <xsl:variable name="calsuite-update" select="/bedeworkadmin/urlPrefixes/calsuite/update/a/@href"/>
  <xsl:variable name="calsuite-showAddForm" select="/bedeworkadmin/urlPrefixes/calsuite/showAddForm/a/@href"/>
  <xsl:variable name="calsuite-setAccess" select="/bedeworkadmin/urlPrefixes/calsuite/setAccess/a/@href"/>
  <xsl:variable name="calsuite-fetchPrefsForUpdate" select="/bedeworkadmin/urlPrefixes/calsuite/fetchPrefsForUpdate/a/@href"/>
  <xsl:variable name="calsuite-updatePrefs" select="/bedeworkadmin/urlPrefixes/calsuite/updatePrefs/a/@href"/>
  <!-- timezones and stats -->
  <xsl:variable name="timezones-initUpload" select="/bedeworkadmin/urlPrefixes/timezones/initUpload/a/@href"/>
  <xsl:variable name="timezones-upload" select="/bedeworkadmin/urlPrefixes/timezones/upload/a/@href"/>
  <xsl:variable name="stats-update" select="/bedeworkadmin/urlPrefixes/stats/update/a/@href"/>
  <!-- authuser and prefs -->
  <xsl:variable name="authuser-showModForm" select="/bedeworkadmin/urlPrefixes/authuser/showModForm/a/@href"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedeworkadmin/urlPrefixes/authuser/showUpdateList/a/@href"/>
  <xsl:variable name="authuser-initUpdate" select="/bedeworkadmin/urlPrefixes/authuser/initUpdate/a/@href"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/authuser/fetchForUpdate/a/@href"/>
  <xsl:variable name="authuser-update" select="/bedeworkadmin/urlPrefixes/authuser/update/a/@href"/>
  <xsl:variable name="prefs-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/prefs/fetchForUpdate/a/@href"/>
  <xsl:variable name="prefs-update" select="/bedeworkadmin/urlPrefixes/prefs/update/a/@href"/>
  <!-- admin groups -->
  <xsl:variable name="admingroup-showModForm" select="/bedeworkadmin/urlPrefixes/admingroup/showModForm/a/@href"/>
  <xsl:variable name="admingroup-showModMembersForm" select="/bedeworkadmin/urlPrefixes/admingroup/showModMembersForm/a/@href"/>
  <xsl:variable name="admingroup-showUpdateList" select="/bedeworkadmin/urlPrefixes/admingroup/showUpdateList/a/@href"/>
  <xsl:variable name="admingroup-showChooseGroup" select="/bedeworkadmin/urlPrefixes/admingroup/showChooseGroup/a/@href"/>
  <xsl:variable name="admingroup-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/admingroup/showDeleteConfirm/a/@href"/>
  <xsl:variable name="admingroup-initAdd" select="/bedeworkadmin/urlPrefixes/admingroup/initAdd/a/@href"/>
  <xsl:variable name="admingroup-initUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/initUpdate/a/@href"/>
  <xsl:variable name="admingroup-delete" select="/bedeworkadmin/urlPrefixes/admingroup/delete/a/@href"/>
  <xsl:variable name="admingroup-fetchUpdateList" select="/bedeworkadmin/urlPrefixes/admingroup/fetchUpdateList/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdate/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdateMembers/a/@href"/>
  <xsl:variable name="admingroup-update" select="/bedeworkadmin/urlPrefixes/admingroup/update/a/@href"/>
  <xsl:variable name="admingroup-updateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/updateMembers/a/@href"/>
  <xsl:variable name="admingroup-switch" select="/bedeworkadmin/urlPrefixes/admingroup/switch/a/@href"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedeworkadmin/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!--==== MAIN TEMPLATE  ====-->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Calendar Admin: Events Calendar Administration</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/subColors.css"/>
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
        <xsl:if test="/bedeworkadmin/page='calendarDescriptions' or /bedeworkadmin/page='displayCalendar'">
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
                  <xsl:apply-templates select="/bedeworkadmin/formElements" mode="modEvent"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='displayEvent' or /bedeworkadmin/page='deleteEventConfirm'">
                  <xsl:apply-templates select="/bedeworkadmin/event" mode="displayEvent"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='contactList'">
                  <xsl:call-template name="contactList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modContact'">
                  <xsl:call-template name="modContact"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='deleteContactConfirm' or /bedeworkadmin/page='contactReferenced'">
                  <xsl:call-template name="deleteContactConfirm"/>
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
                <xsl:when test="/bedeworkadmin/page='categoryList'">
                  <xsl:call-template name="categoryList"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='modCategory'">
                  <xsl:call-template name="modCategory"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='deleteCategoryConfirm'">
                  <xsl:call-template name="deleteCategoryConfirm"/>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='calendarList' or /bedeworkadmin/page='calendarDescriptions' or /bedeworkadmin/page='displayCalendar' or /bedeworkadmin/page='modCalendar' or /bedeworkadmin/page='deleteCalendarConfirm' or /bedeworkadmin/page='calendarReferenced'">
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
                <xsl:when test="/bedeworkadmin/page='searchResult'">
                  <xsl:call-template name="searchResult"/>
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
                  <p>
                    <a href="{$setup}">continue</a>
                  </p>
                </xsl:when>
                <xsl:when test="/bedeworkadmin/page='error'">
                  <h2>Application error</h2>
                  <p>An application error occurred.</p>
                  <p>
                    <a href="{$setup}">continue</a>
                  </p>
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
    <div id="adminLeftColumn">
      <h2 class="menuTitle">Main Menu</h2>
      <table id="mainMenuTable">
        <tr>
          <th>Events</th>
          <td>
            <a id="addEventLink" href="{$event-initAddEvent}">
              Add
            </a>
          </td>
          <td>
            <a href="{$event-initUpdateEvent}">
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
            <a id="addContactLink" href="{$contact-initAdd}">
              Add
            </a>
          </td>
          <td>
            <a href="{$contact-initUpdate}">
              Edit / Delete
            </a>
          </td>
        </tr>
        <tr>
          <th>Locations</th>
          <td>
            <a id="addLocationLink" href="{$location-initAdd}">
              Add
            </a>
          </td>
          <td>
            <a href="{$location-initUpdate}">
              Edit / Delete
            </a>
          </td>
        </tr>
        <tr>
          <th>Categories</th>
          <td>
            <a id="addCategoryLink" href="{$category-initAdd}">
              Add
            </a>
          </td>
          <td>
            <a href="{$category-initUpdate}">
              Edit / Delete
            </a>
          </td>
        </tr>
      </table>

      <h4 class="menuTitle">Event search:</h4>
      <form name="searchForm" method="post" action="{$search}" id="searchForm">
        <input type="text" name="query" size="30">
          <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/searchResults/query"/></xsl:attribute>
        </input>
        <input type="submit" name="submit" value="go"/>
        <div id="searchFields">
          Limit:
          <input type="radio" name="searchLimits" value="fromToday" checked="checked"/>today forward
          <input type="radio" name="searchLimits" value="beforeToday"/>past dates
          <input type="radio" name="searchLimits" value="none"/>all dates
        </div>
      </form>

    </div>

    <div id="adminRightColumn">
      <xsl:if test="/bedeworkadmin/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedeworkadmin/userInfo/superUser='true'">
        <h4 class="menuTitle">
          Manage calendar suite:
          <em><xsl:value-of select="/bedeworkadmin/currentCalSuite/name"/>
          </em>
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
        <h4 class="menuTitle">Manage users:</h4>
        <ul class="adminMenu">
          <xsl:if test="/bedeworkadmin/userInfo/userMaintOK='true'">
            <li>
              <a href="{$authuser-initUpdate}">
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
                Edit user preferences (enter userid):<br/>
                <input type="text" name="user" size="15"/>
                <input type="submit" name="getPrefs" value="go"/>
              </form>
            </li>
          </xsl:if>
        </ul>
      </xsl:if>

      <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
        <h4 class="menuTitle">Super user features:</h4>
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
            <a href="{$timezones-initUpload}">
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
    </div>
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
              <xsl:value-of select="summary"/>
            </a>
          </td>
          <td class="date">
            <xsl:value-of select="start/longdate"/>,
            <xsl:value-of select="start/time"/>
          </td>
          <td class="date">
            <xsl:value-of select="end/longdate"/>,
            <xsl:value-of select="end/time"/>
          </td>
          <td>
            <xsl:value-of select="calendar/name"/>
          </td>
          <td>
            <xsl:value-of select="description"/>
            <xsl:if test="recurring = 'true'">
              <div class="recurrenceEditLinks">
                Recurring event.
                Edit:
                <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}">
                  master
                </a> |
                <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  instance
                </a>
              </div>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="formElements" mode="modEvent">
    <xsl:variable name="subscriptionId" select="subscriptionId"/>
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>

    <h2>Event Information</h2>

    <xsl:variable name="modEventAction" select="form/@action"/>
    <form name="peForm" method="post" action="{$modEventAction}" onsubmit="setRecurrence(this)">
      <table class="eventFormTable">
        <tr>
          <td class="fieldName">
            Title:
          </td>
          <td>
            <xsl:copy-of select="form/title/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Calendar:**
          </td>
          <td>
            <xsl:if test="form/calendar/preferred/select/option">
              <select name="prefCalendarId">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="form/calendar/preferred/select/*"/>
              </select>
              or Calendar (all):
            </xsl:if>
            <select name="calendarId">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="form/calendar/all/select/*"/>
            </select>
            <xsl:text> </xsl:text>
            <span id="calDescriptionsLink">
              <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')">calendar descriptions</a>
            </span>
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
            all day (anniversary)

            <!-- floating event: no timezone (and not UTC) -->
            <xsl:choose>
              <xsl:when test="form/floating/input/@checked='checked'">
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.floating" value="on" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="on" id="endFloating"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off"/>
                <input type="hidden" name="eventStartDate.floating" value="off" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="off" id="endFloating"/>
              </xsl:otherwise>
            </xsl:choose>
            floating

            <!-- store time as coordinated universal time (UTC) -->
            <xsl:choose>
              <xsl:when test="form/storeUTC/input/@checked='checked'">
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="on" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="on" id="endStoreUTC"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="off" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="off" id="endStoreUTC"/>
              </xsl:otherwise>
            </xsl:choose>
            store as UTC

            <br/>
            <div class="dateStartEndBox">
              <strong>Start:</strong>
              <div class="dateFields">
                <span class="startDateLabel">Date </span>
                <xsl:copy-of select="form/start/month/*"/>
                <xsl:copy-of select="form/start/day/*"/>
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/creating = 'true'">
                    <xsl:copy-of select="form/start/year/*"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="form/start/yearText/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <script language="JavaScript" type="text/javascript">
                <xsl:comment>
                startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
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

                  <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
                    <option value="-1">select timezone...</option>
                    <xsl:for-each select="/bedeworkadmin/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="form/start/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
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
                    <xsl:when test="/bedeworkadmin/creating = 'true'">
                      <xsl:copy-of select="form/end/dateTime/year/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="form/end/dateTime/yearText/*"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <script language="JavaScript" type="text/javascript">
                  <xsl:comment>
                  endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
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

                    <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
                      <option value="-1">select timezone...</option>
                      <xsl:for-each select="/bedeworkadmin/timezones/timezone">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                          <xsl:if test="form/end/dateTime/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:for-each>
                    </select>
                  </span>
                </div>
              </div>
              <br/>
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
              </div>
              <br/>
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
        <!-- Recurrence fields -->
        <!-- ================= -->
        <tr>
          <td class="fieldName">
            Recurrence:
          </td>
          <td>
            <!-- Output descriptive recurrence information.  Probably not
               complete yet. Replace all freq strings so can be internationalized. -->
          <xsl:if test="form/recurrence">
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
                      <xsl:for-each select="/bedeworkadmin/recurdayvals/val">
                        <xsl:if test="node() = $dayVal"><xsl:value-of select="position()"/></xsl:if>
                      </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="/bedeworkadmin/shortdaynames/val[position() = $dayPos]"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:if>

              <xsl:if test="form/recurrence/bymonth">
                in
                <xsl:for-each select="form/recurrence/bymonth/val">
                  <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
                  <xsl:variable name="monthNum" select="number(.)"/>
                  <xsl:value-of select="/bedeworkadmin/monthlabels/val[position() = $monthNum]"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </xsl:if>

              <xsl:if test="form/recurrence/bymonthday">
                on the
                <xsl:for-each select="form/recurrence/bymonthday/val">
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
                </xsl:for-each>
                day<xsl:if test="form/recurrence/bymonthday/val[position()=2]">s</xsl:if> of the month
              </xsl:if>

              <xsl:if test="form/recurrence/byyearday">
                on the
                <xsl:for-each select="form/recurrence/byyearday/val">
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
                </xsl:for-each>
                day<xsl:if test="form/recurrence/byyearday/val[position()=2]">s</xsl:if> of the year
              </xsl:if>

              <xsl:if test="form/recurrence/byweekno">
                in the
                <xsl:for-each select="form/recurrence/byweekno/val">
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
                </xsl:for-each>
                week<xsl:if test="form/recurrence/byweekno/val[position()=2]">s</xsl:if> of the year
              </xsl:if>

              repeating
              <xsl:choose>
                <xsl:when test="form/recurrence/count = '-1'">forever</xsl:when>
                <xsl:when test="form/recurrence/until">
                  <xsl:value-of select="form/recurrence/until"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="form/recurrence/count"/>
                  time<xsl:if test="form/recurrence/count &gt; 1">s</xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:if>


          <!-- recurrence rules -->
            <xsl:choose>
              <xsl:when test="recurrenceId != ''">
                <!-- recurrence instances can not themselves recur,
                     so provide access to master event -->
                <em>This event is a recurrence instance.</em><br/>
                <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">edit master event</a>
              </xsl:when>
              <xsl:otherwise>
                <!-- has recurrenceId, so is master -->
                <input type="checkbox" name="recurrenceFlag" onclick="swapRecurrence(this)" value="on"/>
                <xsl:choose>
                  <xsl:when test="/bedeworkadmin/creating = 'true'">
                    set recurrence rules
                  </xsl:when>
                  <xsl:otherwise>
                    change recurrence
                  </xsl:otherwise>
                </xsl:choose>
                <span id="recurrenceUiSwitch" class="invisible">
                  <input type="checkbox" name="recurrenceUiSwitch" value="simple" onchange="swapVisible(this,'advancedRecurrenceRules')"/>
                  show advanced recurrence rules
                </span>

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

                <div id="recurrenceFields" class="invisible">
                  <table id="recurrenceTable" cellspacing="0">
                    <tr>
                      <td class="recurrenceFrequency" rowspan="2">
                        <strong>Frequency:</strong><br/>
                        <!-- "freq" is used to determine if a recurrence should be created; test for "NONE" -->
                        <input type="radio" name="freq" value="NONE" onclick="showRecurrence(this.value)" checked="checked"/>none<br/>
                        <!--<input type="radio" name="freq" value="HOURLY" onclick="showRecurrence(this.value)"/>hourly<br/>-->
                        <input type="radio" name="freq" value="DAILY" onclick="showRecurrence(this.value)"/>daily<br/>
                        <input type="radio" name="freq" value="WEEKLY" onclick="showRecurrence(this.value)"/>weekly<br/>
                        <input type="radio" name="freq" value="MONTHLY" onclick="showRecurrence(this.value)"/>monthly<br/>
                        <input type="radio" name="freq" value="YEARLY" onclick="showRecurrence(this.value)"/>yearly
                      </td>
                      <td class="recurrenceRules">
                        <!-- none -->
                        <div id="noneRecurrenceRules">
                          <p>does not recur</p>
                        </div>
                        <span id="advancedRecurrenceRules" class="invisible">
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
                                <xsl:for-each select="/bedeworkadmin/monthlabels/val">
                                  <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                                  <span class="chkBoxListItem">
                                    <input type="checkbox" name="dayMonths">
                                      <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/monthvalues/val[position() = $pos]"/></xsl:attribute>
                                    </input>
                                    <xsl:value-of select="."/>
                                  </span>
                                  <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                                </xsl:for-each>
                              </div>
                            </p>
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
                                <xsl:for-each select="/bedeworkadmin/shortdaynames/val">
                                  <xsl:variable name="pos" select="position()"/>
                                  <option>
                                    <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/recurdayvals/val[position() = $pos]"/></xsl:attribute>
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
                                <xsl:for-each select="/bedeworkadmin/monthlabels/val">
                                  <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                                  <span class="chkBoxListItem">
                                    <input type="checkbox" name="yearMonths">
                                      <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/monthvalues/val[position() = $pos]"/></xsl:attribute>
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
                                <xsl:for-each select="/bedeworkadmin/shortdaynames/val">
                                  <xsl:variable name="pos" select="position()"/>
                                  <option>
                                    <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                                    <xsl:value-of select="."/>
                                  </option>
                                </xsl:for-each>
                              </select>
                            </p>
                          </div>
                        </span>
                      </td>
                    </tr>
                    <!-- recurrence count, until, forever -->
                    <tr>
                      <td class="recurrenceUntil">
                         <div id="recurrenceUntilRules" class="invisible">
                           <strong>Repeat:</strong>
                           <p>
                             <div class="dateFields">
                               <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                                 <xsl:if test="form/recurring/until">
                                   <xsl:attribute name="checked">checked</xsl:attribute>
                                 </xsl:if>
                               </input>
                               until
                               <select name="untilMonth" onfocus="selectRecurCountUntil('recurUntil')">
                                 <xsl:for-each select="form/start/month/select/option">
                                   <xsl:copy-of select="."/>
                                 </xsl:for-each>
                               </select>
                               <select name="untilDay" onfocus="selectRecurCountUntil('recurUntil')">
                                 <xsl:for-each select="form/start/day/select/option">
                                   <xsl:copy-of select="."/>
                                 </xsl:for-each>
                               </select>
                               <xsl:choose>
                                 <xsl:when test="/bedeworkadmin/creating = 'true'">
                                   <select name="untilYear" onfocus="selectRecurCountUntil('recurUntil')">
                                     <xsl:for-each select="form/start/year/select/option">
                                       <xsl:copy-of select="."/>
                                     </xsl:for-each>
                                   </select>
                                 </xsl:when>
                                 <xsl:otherwise>
                                   <input type="text" name="untilYear" size="4"  onfocus="selectRecurCountUntil('recurUntil')">
                                     <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                                   </input>
                                 </xsl:otherwise>
                               </xsl:choose>
                             </div>
                             <script language="JavaScript" type="text/javascript">
                             <xsl:comment>
                               untilDateDynCalWidget = new dynCalendar('untilDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'untilDateCalWidgetCallback',false,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                             </xsl:comment>
                             </script>
                           </p>
                           <p>
                             <input type="radio" name="recurCountUntil" value="forever">
                               <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                                 <xsl:attribute name="checked">checked</xsl:attribute>
                               </xsl:if>
                             </input>
                             forever
                             &#160;
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
                             times
                           </p>
                         </div>
                      </td>
                    </tr>
                  </table>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Status  -->
        <tr>
          <td class="fieldName">
            Status:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="form/status = 'TENTATIVE'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE" checked="checked"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:when>
              <xsl:when test="form/status = 'CANCELLED'">
                <input type="radio" name="event.status" value="CONFIRMED"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED" checked="checked"/>cancelled
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="event.status" value="CONFIRMED" checked="checked"/>confirmed <input type="radio" name="event.status" value="TENTATIVE"/>tentative <input type="radio" name="event.status" value="CANCELLED"/>cancelled
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Description  -->
        <tr>
          <td class="fieldName">
            Description:
          </td>
          <td>
            <xsl:copy-of select="form/desc/*"/>
            <div class="fieldInfo">
              Enter all pertinent information, including the academic titles of
              all speakers and/or participants.
              <span class="maxCharNotice">(<xsl:value-of select="form/descLength"/> characters max.)</span>
            </div>
          </td>
        </tr>
        <!-- Cost -->
        <tr>
          <td class="optional">
            Price:
          </td>
          <td>
            <xsl:copy-of select="form/cost/*"/>
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
            <xsl:copy-of select="form/link/*"/>
            <xsl:text> </xsl:text>
            <span class="fieldInfo">(optional: for more information about the event)</span>
          </td>
        </tr>
        <!-- Location -->
        <tr>
          <td class="fieldName">
            Location:**
          </td>
          <td>
            <xsl:if test="form/location/preferred/select/option">
              <select name="prefLocationId" id="eventFormPrefLocationList">
                <option value="-1">
                  Select preferred:
                </option>
                <xsl:copy-of select="form/location/preferred/select/*"/>
              </select>
              or Location (all):
            </xsl:if>
            <select name="allLocationId" id="eventFormLocationList">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="form/location/all/select/*"/>
            </select>
          </td>
        </tr>

        <xsl:if test="form/location/address">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text">
                <span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Address:
            </td>
            <td>
              <xsl:variable name="addressFieldName" select="form/location/address/input/@name"/>
              <xsl:variable name="calLocations">
                <xsl:for-each select="form/location/all/select/option">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <input type="text" size="30" name="{$addressFieldName}" autocomplete="off" onfocus="autoComplete(this,event,new Array({$calLocations}));"/>
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
              <xsl:copy-of select="form/location/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional: for information about the location)</span>
            </td>
          </tr>
        </xsl:if>

        <!-- Contact -->
        <tr>
          <td class="fieldName">
            Contact:**
          </td>
          <td>
            <xsl:if test="form/contact/preferred/select/option">
              <select name="prefContactId" id="eventFormContactList">
                <option value="-1">
                  Select preferred:
                </option>option>
                <xsl:copy-of select="form/contact/preferred/select/*"/>
              </select>
              or Contact (all):
            </xsl:if>
            <select name="allContactId" id="eventFormPrefContactList">
              <option value="-1">
                Select:
              </option>
              <xsl:copy-of select="form/contact/all/select/*"/>
            </select>
          </td>
        </tr>


        <!--  Category  -->
        <tr>
          <td class="fieldName">
            Categories:**
          </td>
          <td>
            <xsl:if test="form/categories/preferred/category and /bedeworkadmin/creating='true'">
              <input type="radio" name="categoryCheckboxes" value="preferred" checked="checked" onclick="changeClass('preferredCategoryCheckboxes','shown');changeClass('allCategoryCheckboxes','invisible');"/>show preferred
              <input type="radio" name="categoryCheckboxes" value="all" onclick="changeClass('preferredCategoryCheckboxes','invisible');changeClass('allCategoryCheckboxes','shown')"/>show all<br/>
              <table cellpadding="0" id="preferredCategoryCheckboxes">
                <tr>
                  <xsl:variable name="catCount" select="count(form/categories/preferred/category)"/>
                  <td>
                    <xsl:for-each select="form/categories/preferred/category[position() &lt;= ceiling($catCount div 2)]">
                      <input type="checkbox" name="categoryKey">
                        <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="id">pref-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="keyword"/>','all-<xsl:value-of select="keyword"/>')</xsl:attribute>
                        <xsl:if test="keyword = form/categories/current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                        <xsl:value-of select="keyword"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                  <td>
                    <xsl:for-each select="form/categories/preferred/category[position() &gt; ceiling($catCount div 2)]">
                      <input type="checkbox" name="categoryKey">
                        <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="id">pref-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="keyword"/>','all-<xsl:value-of select="keyword"/>')</xsl:attribute>
                        <xsl:if test="keyword = form/categories/current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                        <xsl:value-of select="keyword"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                </tr>
              </table>
            </xsl:if>
            <table cellpadding="0" id="allCategoryCheckboxes">
              <xsl:if test="form/categories/preferred/category and /bedeworkadmin/creating='true'">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <tr>
                <xsl:variable name="catCount" select="count(form/categories/all/category)"/>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="/bedeworkadmin/creating='true'">
                        <xsl:attribute name="id">all-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="keyword"/>','pref-<xsl:value-of select="keyword"/>')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="keyword = form/categories/current//category/keyword">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="keyword"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="/bedeworkadmin/creating='true'">
                        <xsl:attribute name="id">all-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="keyword"/>','pref-<xsl:value-of select="keyword"/>')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="keyword = form/categories/current//category/keyword">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="keyword"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <!-- note -->
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

        <xsl:if test="form/contact/name">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text">
                <span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Contact (name):
            </td>
            <td>
              <xsl:copy-of select="form/contact/name/*"/>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              Contact Phone Number:
            </td>
            <td>
              <xsl:copy-of select="form/contact/phone/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span>
            </td>
          </tr>
          <tr>
            <td class="optional">
              Contact's URL:
            </td>
            <td>
              <xsl:copy-of select="form/contact/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span>
            </td>
          </tr>
          <tr>
            <td class="optional">
              Contact Email Address:
            </td>
            <td>
              <xsl:copy-of select="form/contact/email/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo">(optional)</span> test
              <div id="contactEmailAlert">&#160;</div> <!-- space for email warning -->
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

  <xsl:template name="byDayChkBoxList">
    <xsl:param name="name"/>
    <xsl:for-each select="/bedeworkadmin/shortdaynames/val">
      <xsl:variable name="pos" select="position()"/>
      <input type="checkbox">
        <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/recurdayvals/val[position() = $pos]"/></xsl:attribute>
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
        <img id="clockMap" src="{$resourcesRoot}/resources/clockMap.gif" width="368" height="368" border="0" alt="" usemap="#bwClockMap" />
      </div>
      <div id="bwClockCover">
        <!-- this is a special effect div used simply to cover the pixelated edge
             where the clock meets the clock box title --></div>
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
    <xsl:variable name="calPath" select="calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>

    <xsl:choose>
      <xsl:when test="/bedeworkadmin/page='deleteEventConfirm'">

        <h2>Ok to delete this event?</h2>
        <p style="width: 400px;">Note: we do not encourage deletion of old but correct events; we prefer to keep
           old events for historical reasons.  Please remove only those events
           that are truly erroneous.</p>
        <p id="confirmButtons">
          <form action="{$event-delete}" method="post">
            <input type="submit" name="cancelled" value="Cancel"/>
            <input type="submit" name="delete" value="Delete"/>
            <input type="hidden" name="calPath" value="{$calPath}"/>
            <input type="hidden" name="guid" value="{$guid}"/>
            <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
          </form>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h2>Event Information</h2>
      </xsl:otherwise>
    </xsl:choose>

    <table class="eventFormTable">
      <tr>
        <th>
          Title:
        </th>
        <td>
          <strong><xsl:value-of select="summary"/></strong>
        </td>
      </tr>

      <tr>
        <th>
          When:
        </th>
        <td>
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
      </tr>

      <tr>
        <th>
          Calendar:
        </th>
        <td>
          <xsl:value-of select="calendar/path"/>
        </td>
      </tr>

      <!--  Description  -->
      <tr>
        <th>
          Description:
        </th>
        <td>
          <xsl:value-of select="description"/>
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
          <a href="{$eventLink}">
            <xsl:value-of select="link"/>
          </a>
        </td>
      </tr>

      <!-- Location -->
      <tr>
        <th>
          Location:
        </th>
        <td>
          <xsl:value-of select="location/address"/><br/>
          <xsl:value-of select="location/subaddress"/>
        </td>
      </tr>

      <!-- Contact -->
      <tr>
        <th>
          Contact:
        </th>
        <td>
          <xsl:value-of select="contact/name"/><br/>
          <xsl:value-of select="contact/phone"/><br/>
          <xsl:variable name="mailto" select="email"/>
          <a href="mailto:{$mailto}"><xsl:value-of select="email"/></a>
          <xsl:variable name="link" select="link"/>
          <a href="mailto:{$link}"><xsl:value-of select="link"/></a>
        </td>
      </tr>

      <!-- Owner -->
      <tr>
        <th>
          Owner:
        </th>
        <td>
          <strong><xsl:value-of select="creator"/></strong>
        </td>
      </tr>

      <!--  Categories  -->
      <tr>
        <th>
          Categories:
        </th>
        <td>
          <xsl:for-each select="categories/category">
            <xsl:value-of select="word"/><br/>
          </xsl:for-each>
        </td>
      </tr>

    </table>

    <p>
      <xsl:if test="/bedeworkadmin/canEdit = 'true' or /bedeworkadmin/userInfo/superUser = 'true'">
        <input type="button" name="return" value="Edit event" onclick="javascript:location.replace('{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')"/>
      </xsl:if>

      <input type="button" name="return" value="Back" onclick="javascript:history.back()"/>
    </p>
  </xsl:template>

  <!--+++++++++++++++ Contacts ++++++++++++++++++++-->
  <xsl:template name="contactList">
    <h2>Edit Contacts</h2>
    <p>
      Select the contact you would like to update:
      <input type="button" name="return" value="Add new contact" onclick="javascript:location.replace('{$contact-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Phone</th>
        <th>Email</th>
        <th>URL</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/contacts/contact">
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

  <xsl:template name="modContact">
    <form action="{$contact-update}" method="post">
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
                <input type="submit" name="addContact" value="Add Contact"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateContact" value="Update Contact"/>
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

  <xsl:template name="deleteContactConfirm">
    <h2>Ok to delete this contact?</h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <th>Name</th>
        <td>
          <xsl:value-of select="/bedeworkadmin/contact/name" />
        </td>
      </tr>
      <tr>
        <th>Phone</th>
        <td>
          <xsl:value-of select="/bedeworkadmin/contact/phone" />
        </td>
      </tr>
      <tr>
        <th>Email</th>
        <td>
          <xsl:value-of select="/bedeworkadmin/contact/email" />
        </td>
      </tr>
      <tr>
        <th>URL</th>
        <td>
          <xsl:value-of select="/bedeworkadmin/contact/link" />
        </td>
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
          <a href="{$link}">
            <xsl:value-of select="/bedeworkadmin/location/link"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--+++++++++++++++ Categories ++++++++++++++++++++-->
  <xsl:template name="categoryList">
    <h2>Edit Categories</h2>
    <p>
      Select the category you would like to update:
      <input type="button" name="return" value="Add new category" onclick="javascript:location.replace('{$category-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th>Keyword</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="/bedeworkadmin/categories/category">
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
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <xsl:choose>
      <xsl:when test="/bedeworkadmin/creating='true'">
        <h2>Add Category</h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
                Keyword:
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="optional">
                Description:
              </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                </textarea>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="addCategory" value="Add Category"/>
                <input type="submit" name="cancelled" value="Cancel"/>
                <input type="reset" value="Clear"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <h2>Update Category</h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
            Keyword:
            </td>
              <td>
                <xsl:variable name="keyword" select="normalize-space(/bedeworkadmin/currentCategory/category/keyword)"/>
                <input type="text" name="categoryWord.value" value="{$keyword}" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="optional">
            Description:
            </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedeworkadmin/currentCategory/category/desc)"/>
                </textarea>
              </td>
            </tr>
          </table>

          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="updateCategory" value="Update Category"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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


    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
          Keyword:
        </td>
        <td>
          <xsl:value-of select="/bedeworkadmin/currentCategory/category/keyword"/>
        </td>
      </tr>
      <tr>
        <td class="optional">
          Description:
        </td>
        <td>
          <xsl:value-of select="/bedeworkadmin/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="updateCategory" value="Yes: Delete Category"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

<!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Public calendars</h3>
          <ul id="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedeworkadmin/page='calendarDescriptions' or /bedeworkadmin/page='displayCalendar'">
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
            <xsl:when test="/bedeworkadmin/page='calendarList' or /bedeworkadmin/page='calendarReferenced'">
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
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>--></xsl:apply-templates>
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
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>--></xsl:apply-templates>
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
      <xsl:variable name="encodedCalPath" select="encodedPath"/>
      <xsl:if test="currentAccess/current-user-privilege-set/privilege/read-acl or /bedeworkadmin/userInfo/superUser='true'">
        <h3>Sharing</h3>
        <table class="common" id="sharing">
          <tr>
            <th class="commonHeader">Who:</th>
            <th class="commonHeader">Current access:</th>
            <th class="commonHeader">Source:</th>
          </tr>
          <xsl:for-each select="acl/ace">
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
            <tr>
            <th class="thin">
                <xsl:if test="invert">
                  Not
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)">
                    <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
                    <xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/userPrincipalRoot)),'/')"/>
                  </xsl:when>
                  <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)">
                    <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
                    <xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/groupPrincipalRoot)),'/')"/>
                  </xsl:when>
                  <xsl:when test="invert and $who='owner'">
                    <xsl:value-of select="$who"/> (other)
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$who"/>
                  </xsl:otherwise>
                </xsl:choose>
              </th>
              <td>
                <xsl:for-each select="grant/node()">
                  <xsl:value-of select="name(.)"/>&#160;&#160;
                </xsl:for-each>
                <xsl:for-each select="deny/node()">
                  <xsl:choose>
                    <xsl:when test="name(.)='all'">
                      none
                    </xsl:when>
                    <xsl:otherwise>
                      deny-<xsl:value-of select="name(.)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  &#160;&#160;
                </xsl:for-each>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="inherited">
                    inherited from:
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="$calendar-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="inherited/href"/></xsl:attribute>
                      <xsl:value-of select="inherited/href"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    local:
                    <xsl:variable name="whoType">
                      <xsl:choose>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)">user</xsl:when>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)">group</xsl:when>
                        <xsl:when test="$who='authenticated'">auth</xsl:when>
                        <xsl:when test="invert/principal/property/owner">other</xsl:when>
                        <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
                        <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="shortWho">
                      <xsl:choose>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/userPrincipalRoot)),'/')"/></xsl:when>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/groupPrincipalRoot)),'/')"/></xsl:when>
                        <xsl:otherwise></xsl:otherwise> <!-- if not user or group, send no who -->
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="invert">
                        <a href="{$calendar-setAccess}&amp;calPath={$encodedCalPath}&amp;how=default&amp;who={$shortWho}&amp;whoType={$whoType}&amp;notWho=yes">
                          reset to default
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$calendar-setAccess}&amp;calPath={$encodedCalPath}&amp;how=default&amp;who={$shortWho}&amp;whoType={$whoType}">
                          reset to default
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>

      <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-acl or /bedeworkadmin/userInfo/superUser='true'">
        <form name="calendarShareForm" action="{$calendar-setAccess}" id="shareForm" method="post">
          <input type="hidden" name="calPath" value="{$calPath}"/>
          <table cellspacing="0" id="shareFormTable" class="common">
            <tr>
              <th colspan="2" class="commonHeader">Set access:</th>
            </tr>
            <tr class="subhead">
              <th>Who:</th>
              <th>Rights:</th>
            </tr>
            <tr>
              <td>
                <input type="text" name="who" size="20"/>
                <br/>
                <input type="radio" value="user" name="whoType" checked="checked"/> user
                <input type="radio" value="group" name="whoType"/> group
                <p>OR</p>
                <p>
                  <input type="radio" value="auth" name="whoType"/> all authorized users<br/>
                  <input type="radio" value="other" name="whoType"/> other users<br/>
                  <input type="radio" value="owner" name="whoType"/> owner
                </p>
                <!-- we may never use the invert action ...it is probably
                     too confusing, and can be achieved in other ways -->
                <!--
                <p class="padTop">
                  <input type="checkbox" value="yes" name="notWho"/> invert (deny)
                </p>-->
              </td>
              <td>
                <ul id="howList">
                  <li>
                    <input type="radio" value="A" name="how"/>
                    <strong>All</strong> (read, write, delete)</li>
                  <li class="padTop">
                    <input type="radio" value="R" name="how" checked="checked"/>
                    <strong>Read</strong> (content, access, freebusy)
                  </li>
                  <li>
                    <input type="radio" value="f" name="how"/> Read freebusy only
                  </li>
                  <li class="padTop">
                    <input type="radio" value="Rc" name="how"/>
                    <strong>Read</strong> and <strong>Write content only</strong>
                  </li>
                  <li class="padTop">
                    <input type="radio" value="W" name="how"/>
                    <strong>Write and delete</strong> (content, access, properties)
                  </li>
                  <li>
                    <input type="radio" value="c" name="how"/> Write content only
                  </li>
                  <li>
                    <input type="radio" value="u" name="how"/> Delete only
                  </li>
                  <li class="padTop">
                    <input type="radio" value="N" name="how"/>
                    <strong>None</strong>
                  </li>
                  <!--
                  <li class="padTop">
                    <input type="radio" value="default" name="how"/>
                    <strong>Restore default access</strong>
                  </li>-->
                </ul>
              </td>
            </tr>
          </table>
          <input type="submit" name="submit" value="Submit"/>
        </form>
      </xsl:if>
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

    <p>
      <strong>All Calendar Descriptions:</strong>
    </p>
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
          <xsl:when test="/bedeworkadmin/appvar[key='showAllCalsForEvent']/value = 'true'">
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
      <xsl:variable name="calPath" select="path"/><!-- not the encodedPath when put in a form - otherwise it gets double encoded -->
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:choose>
        <xsl:when test="currentAccess/current-user-privilege-set/privilege/write-content and (calendarCollection = 'true')">
          <a href="javascript:updateEventFormCalendar('{$calPath}','{$calDisplay}')">
            <strong>
              <xsl:value-of select="name"/>
            </strong>
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
            Select a calendar below to add a <em><strong>new</strong>
            </em>
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
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>--></xsl:apply-templates>
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
        <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
          <tr>
            <th>Unremovable:</th>
            <td>
              <input type="radio" value="true" name="unremoveable" size="60"/> true
              <input type="radio" value="false" name="unremoveable" size="60" checked="checked"/> false
            </td>
          </tr>
        </xsl:if>
        <tr>
          <th>Style:</th>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input type="text" value="{$subStyle}" name="subscription.style" size="50"/>
            <div style="width: 400px">
              Enter a css class to style events rendered in the list and grid
              views.  Leave blank to render with the default colors, or select from
              one of the system-wide choices:
              <select name="bwColors" onchange="document.subscribeForm['subscription.style'].value = this.value">
                <option value="">default</option>
                <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                  <xsl:variable name="subColor" select="."/>
                  <option value="{$subColor}" class="{$subColor}">
                    <xsl:value-of select="@name"/>
                  </option>
                </xsl:for-each>
              </select>
              <p class="note">Note: This class is added alongside the default class used
              in the list and grid views.  It does not replace it, so create your
              style appropriately.</p>
            </div>
          </td>
        </tr>
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
        <tr>
          <th>Style:</th>
          <td>
            <xsl:variable name="subStyle" select="style"/>
            <input type="text" value="{$subStyle}" name="subscription.style" size="60"/>
            <div style="width: 400px">
              Enter a css class to style events rendered in the list and grid
              views.  Leave blank to render with the default colors, or select from
              one of the system-wide choices:
              <select name="bwColors" onchange="document.subscribeForm['subscription.style'].value = this.value">
                <option value="">default</option>
                <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                  <xsl:variable name="subColor" select="."/>
                  <option value="{$subColor}" class="{$subColor}">
                    <xsl:value-of select="@name"/>
                  </option>
                </xsl:for-each>
              </select>
              <p class="note">Note: This class is added alongside the default class used
              in the list and grid views.  It does not replace it, so create your
              style appropriately.</p>
            </div>
          </td>
        </tr>
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
    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
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

    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
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
    <form name="eventForm" method="post" action="{$event-upload}" id="standardForm" enctype="multipart/form-data">
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
    <h2>Modify System Preferences/Parameters</h2>
    <p>
      Do not change unless you know what you're doing.<br/>
      Changes to these parameters have wide impact on the system.
    </p>
    <form name="systemParamsForm" action="{$system-update}" method="post">
      <table class="eventFormTable params">
        <tr>
          <th>System name:</th>
          <td>
            <xsl:variable name="sysname" select="/bedeworkadmin/system/name"/>
            <xsl:value-of select="$sysname"/>
            <div class="desc">
              Name for this system. Cannot be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Default timezone:</th>
          <td>
            <xsl:variable name="tzid" select="/bedeworkadmin/system/tzid"/>

            <select name="tzid">
              <option value="-1">select timezone...</option>
              <xsl:for-each select="/bedeworkadmin/timezones/timezone">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                  <xsl:if test="/bedeworkadmin/system/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="name"/>
                </option>
              </xsl:for-each>
            </select>

            <div class="desc">
              Default timezone id for date/time values. This should normally be your local timezone.
            </div>
          </td>
        </tr>
        <tr>
          <th>System id:</th>
          <td>
            <xsl:variable name="systemid" select="/bedeworkadmin/system/systemid"/>
            <xsl:value-of select="$systemid"/>
            <div class="desc">
              System id used when building uids and identifying users. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Principal Root:</th>
          <td>
            <xsl:variable name="proot" select="/bedeworkadmin/system/principalRoot"/>
            <input value="{$proot}" name="principalRoot" size="0"/>
            <div class="desc">
              Used in WebDAV and CalDAV access to define root of user and group principal trees.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Principal Root:</th>
          <td>
            <xsl:variable name="uproot" select="/bedeworkadmin/system/userPrincipalRoot"/>
            <input value="{$uproot}" name="userPrincipalRoot" size="0"/>
            <div class="desc">
              Used in WebDAV and CalDAV access to define root of user principal subtree.
            </div>
          </td>
        </tr>
        <tr>
          <th>Group Principal Root:</th>
          <td>
            <xsl:variable name="gproot" select="/bedeworkadmin/system/groupPrincipalRoot"/>
            <input value="{$gproot}" name="groupPrincipalRoot" size="0"/>
            <div class="desc">
              Used in WebDAV and CalDAV access to define root of group principal subtree.
            </div>
          </td>
        </tr>
        <tr>
          <th>Public Calendar Root:</th>
          <td>
            <xsl:variable name="publicCalendarRoot" select="/bedeworkadmin/system/publicCalendarRoot"/>
            <xsl:value-of select="$publicCalendarRoot"/>
            <div class="desc">
              Name for public calendars root directory. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Calendar Root:</th>
          <td>
            <xsl:variable name="userCalendarRoot" select="/bedeworkadmin/system/userCalendarRoot"/>
            <xsl:value-of select="$userCalendarRoot"/>
            <div class="desc">
              Name for user calendars root directory. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Calendar Default name:</th>
          <td>
            <xsl:variable name="userDefaultCalendar" select="/bedeworkadmin/system/userDefaultCalendar"/>
            <input value="{$userDefaultCalendar}" name="userDefaultCalendar" />
            <div class="desc">
              Default name for user calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Trash Calendar Default name:</th>
          <td>
            <xsl:variable name="defaultTrashCalendar" select="/bedeworkadmin/system/defaultTrashCalendar"/>
            <input value="{$defaultTrashCalendar}" name="defaultTrashCalendar" />
            <div class="desc">
              Default name for user trash calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Inbox Default name:</th>
          <td>
            <xsl:variable name="userInbox" select="/bedeworkadmin/system/userInbox"/>
            <input value="{$userInbox}" name="userInbox" />
            <div class="desc">
              Default name for user inbox. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Outbox Default name:</th>
          <td>
            <xsl:variable name="userOutbox" select="/bedeworkadmin/system/userOutbox"/>
            <input value="{$userOutbox}" name="userOutbox" />
            <div class="desc">
              Default name for user outbox. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Deleted Calendar Default name:</th>
          <td>
            <xsl:variable name="deletedCalendar" select="/bedeworkadmin/system/deletedCalendar"/>
            <input value="{$deletedCalendar}" name="deletedCalendar" />
            <div class="desc">
              Default name for user calendar used to hold deleted items. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Busy Calendar Default name:</th>
          <td>
            <xsl:variable name="busyCalendar" select="/bedeworkadmin/system/busyCalendar"/>
            <input value="{$busyCalendar}" name="busyCalendar" />
            <div class="desc">
              Default name for user busy time calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Default user view name:</th>
          <td>
            <xsl:variable name="defaultViewName" select="/bedeworkadmin/system/defaultUserViewName"/>
            <input value="{$defaultViewName}" name="defaultUserViewName" />
            <div class="desc">
              Name used for default view created when a new user is added
            </div>
          </td>
        </tr>
        <tr>
          <th>Http connections per user:</th>
          <td>
            <xsl:variable name="httpPerUser" select="/bedeworkadmin/system/httpConnectionsPerUser"/>
            <input value="{$httpPerUser}" name="httpConnectionsPerUser" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Http connections per host:</th>
          <td>
            <xsl:variable name="httpPerHost" select="/bedeworkadmin/system/httpConnectionsPerHost"/>
            <input value="{$httpPerHost}" name="httpConnectionsPerHost" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Total http connections:</th>
          <td>
            <xsl:variable name="httpTotal" select="/bedeworkadmin/system/httpConnections"/>
            <input value="{$httpTotal}" name="httpConnections" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum length of public event description:</th>
          <td>
            <xsl:variable name="maxPublicDescriptionLength" select="/bedeworkadmin/system/maxPublicDescriptionLength"/>
            <input value="{$maxPublicDescriptionLength}" name="maxPublicDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum length of user event description:</th>
          <td>
            <xsl:variable name="maxUserDescriptionLength" select="/bedeworkadmin/system/maxUserDescriptionLength"/>
            <input value="{$maxUserDescriptionLength}" name="maxUserDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum size of a user entity:</th>
          <td>
            <xsl:variable name="maxUserEntitySize" select="/bedeworkadmin/system/maxUserEntitySize"/>
            <input value="{$maxUserEntitySize}" name="maxUserEntitySize" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Default user quota:</th>
          <td>
            <xsl:variable name="defaultUserQuota" select="/bedeworkadmin/system/defaultUserQuota"/>
            <input value="{$defaultUserQuota}" name="defaultUserQuota" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Max recurring instances:</th>
          <td>
            <xsl:variable name="maxInstances" select="/bedeworkadmin/system/maxInstances"/>
            <input value="{$maxInstances}" name="maxInstances" />
            <div class="desc">
              Used to limit recurring events to reasonable numbers of instances.
            </div>
          </td>
        </tr>
        <tr>
          <th>Max recurring years:</th>
          <td>
            <xsl:variable name="maxYears" select="/bedeworkadmin/system/maxYears"/>
            <input value="{$maxYears}" name="maxYears" />
            <div class="desc">
              Used to limit recurring events to reasonable period of time.
            </div>
          </td>
        </tr>
        <tr>
          <th>User authorisation class:</th>
          <td>
            <xsl:variable name="userauthClass" select="/bedeworkadmin/system/userauthClass"/>
            <input value="{$userauthClass}" name="userauthClass" class="wide"/>
            <div class="desc">
              Class used to determine authorisation (not authentication) for
              administrative users. Should probably only be changed on rebuild.
            </div>
          </td>
        </tr>
        <tr>
          <th>Mailer class:</th>
          <td>
            <xsl:variable name="mailerClass" select="/bedeworkadmin/system/mailerClass"/>
            <input value="{$mailerClass}" name="mailerClass" class="wide"/>
            <div class="desc">
              Class used to mail events. Should probably only be changed on rebuild.
            </div>
          </td>
        </tr>
        <tr>
          <th>Admin groups class:</th>
          <td>
            <xsl:variable name="admingroupsClass" select="/bedeworkadmin/system/admingroupsClass"/>
            <input value="{$admingroupsClass}" name="admingroupsClass" class="wide"/>
            <div class="desc">
              Class used to query and maintain groups for
              administrative users. Should probably only be changed on rebuild.
            </div>
          </td>
        </tr>
        <tr>
          <th>User groups class:</th>
          <td>
            <xsl:variable name="usergroupsClass" select="/bedeworkadmin/system/usergroupsClass"/>
            <input value="{$usergroupsClass}" name="usergroupsClass" class="wide"/>
            <div class="desc">
              Class used to query and maintain groups for
              non-administrative users. Should probably only be changed on rebuild.
            </div>
          </td>
        </tr>
        <tr>
          <th>Directory browsing disallowed:</th>
          <td>
            <xsl:variable name="directoryBrowsingDisallowed" select="/bedeworkadmin/system/directoryBrowsingDisallowed"/>
            <input value="{$directoryBrowsingDisallowed}" name="directoryBrowsingDisallowed" />
            <div class="desc">
              True if the server hosting the xsl disallows directory browsing.
            </div>
          </td>
        </tr>
        <tr>
          <th>Index root:</th>
          <td>
            <xsl:variable name="indexRoot" select="/bedeworkadmin/system/indexRoot"/>
            <input value="{$indexRoot}" name="indexRoot" class="wide"/>
            <div class="desc">
              Root for the event indexes. Should only be changed if the indexes are moved/copied
            </div>
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
    <p>
      <input type="button" name="return" value="Add calendar suite" onclick="javascript:location.replace('{$calsuite-showAddForm}')"/>
    </p>

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
    <!--<div id="sharingBox">
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
    </div>-->

    <div id="sharingBox">
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="encodedCalPath" select="encodedPath"/>
      <xsl:if test="currentAccess/current-user-privilege-set/privilege/read-acl or /bedeworkadmin/userInfo/superUser='true'">
        <h3>Manage suite administrators</h3>
        <table class="common" id="sharing">
          <tr>
            <th class="commonHeader">Who:</th>
            <th class="commonHeader">Current access:</th>
            <th class="commonHeader">Source:</th>
          </tr>
          <xsl:for-each select="acl/ace">
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
            <tr>
            <th class="thin">
                <xsl:if test="invert">
                  Not
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)">
                    <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
                    <xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/userPrincipalRoot)),'/')"/>
                  </xsl:when>
                  <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)">
                    <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
                    <xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/groupPrincipalRoot)),'/')"/>
                  </xsl:when>
                  <xsl:when test="invert and $who='owner'">
                    <xsl:value-of select="$who"/> (other)
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$who"/>
                  </xsl:otherwise>
                </xsl:choose>
              </th>
              <td>
                <xsl:for-each select="grant/node()">
                  <xsl:value-of select="name(.)"/>&#160;&#160;
                </xsl:for-each>
                <xsl:for-each select="deny/node()">
                  <xsl:choose>
                    <xsl:when test="name(.)='all'">
                      none
                    </xsl:when>
                    <xsl:otherwise>
                      deny-<xsl:value-of select="name(.)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  &#160;&#160;
                </xsl:for-each>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="inherited">
                    inherited from:
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="$calendar-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="inherited/href"/></xsl:attribute>
                      <xsl:value-of select="inherited/href"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    local:
                    <xsl:variable name="whoType">
                      <xsl:choose>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)">user</xsl:when>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)">group</xsl:when>
                        <xsl:when test="$who='authenticated'">auth</xsl:when>
                        <xsl:when test="invert/principal/property/owner">other</xsl:when>
                        <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
                        <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="shortWho">
                      <xsl:choose>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/userPrincipalRoot)"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/userPrincipalRoot)),'/')"/></xsl:when>
                        <xsl:when test="contains($who,/bedeworkadmin/syspars/groupPrincipalRoot)"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedeworkadmin/syspars/groupPrincipalRoot)),'/')"/></xsl:when>
                        <xsl:otherwise></xsl:otherwise> <!-- if not user or group, send no who -->
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="invert">
                        <a href="{$calsuite-setAccess}&amp;calSuiteName={$calSuiteName}&amp;how=default&amp;who={$shortWho}&amp;whoType={$whoType}&amp;notWho=yes">
                          reset to default
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$calsuite-setAccess}&amp;calSuiteName={$calSuiteName}&amp;how=default&amp;who={$shortWho}&amp;whoType={$whoType}">
                          reset to default
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>

      <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-acl or /bedeworkadmin/userInfo/superUser='true'">
        <form name="calsuiteShareForm" action="{$calsuite-setAccess}" id="shareForm" method="post">
          <input type="hidden" name="calSuiteName" value="{$calSuiteName}"/>
          <table cellspacing="0" id="shareFormTable" class="common">
            <tr>
              <th colspan="2" class="commonHeader">Set access:</th>
            </tr>
            <tr class="subhead">
              <th>Who:</th>
              <th>Rights:</th>
            </tr>
            <tr>
              <td>
                <input type="text" name="who" size="20"/>
                <br/>
                <input type="radio" value="user" name="whoType" checked="checked"/> user
                <input type="radio" value="group" name="whoType"/> group
                <p>OR</p>
                <p>
                  <input type="radio" value="auth" name="whoType"/> all authorized users<br/>
                  <input type="radio" value="other" name="whoType"/> other users<br/>
                  <input type="radio" value="owner" name="whoType"/> owner
                </p>
                <!-- we may never use the invert action ...it is probably
                     too confusing, and can be achieved in other ways -->
                <!--
                <p class="padTop">
                  <input type="checkbox" value="yes" name="notWho"/> invert (deny)
                </p>-->
              </td>
              <td>
                <ul id="howList">
                  <li>
                    <input type="radio" value="A" name="how"/>
                    <strong>All</strong> (read, write, delete)</li>
                  <li class="padTop">
                    <input type="radio" value="R" name="how"/>
                    <strong>Read</strong> (content, access, freebusy)
                  </li>
                  <li>
                    <input type="radio" value="f" name="how"/> Read freebusy only
                  </li>
                  <li class="padTop">
                    <input type="radio" value="Rc" name="how" checked="checked"/>
                    <strong>Read</strong> and <strong>Write content only</strong>
                  </li>
                  <li class="padTop">
                    <input type="radio" value="W" name="how"/>
                    <strong>Write and delete</strong> (content, access, properties)
                  </li>
                  <li>
                    <input type="radio" value="c" name="how"/> Write content only
                  </li>
                  <li>
                    <input type="radio" value="u" name="how"/> Delete only
                  </li>
                  <li class="padTop">
                    <input type="radio" value="N" name="how"/>
                    <strong>None</strong>
                  </li>
                </ul>
              </td>
            </tr>
          </table>
          <input type="submit" name="submit" value="Submit"/>
        </form>
      </xsl:if>
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
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="Add a new group"/>
    </p>
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
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="Add a new group"/>
    </p>
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
                <xsl:value-of select="/bedeworkadmin/formElements/form/name"/>
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
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initUpdate}')" value="Return to Admin Group listing"/>
    </p>

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
                      <strong>
                        <xsl:value-of select="account"/>
                      </strong>
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
      <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
      <xsl:text> </xsl:text>
      <strong>group</strong>
    </p>
  </xsl:template>

  <xsl:template name="deleteAdminGroupConfirm">
    <h2>Delete Admin Group?</h2>
    <p>The following group will be deleted. Continue?</p>
    <p>
      <strong>
        <xsl:value-of select="/bedeworkadmin/groups/group/name"/>
      </strong>:
      <xsl:value-of select="/bedeworkadmin/groups/group/desc"/>
    </p>
    <form name="adminGroupDelete" method="post" action="{$admingroup-delete}">
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
      <li>
        <a href="{$stats-update}&amp;fetch=yes">fetch statistics</a>
      </li>
      <li>
        <a href="{$stats-update}&amp;dump=yes">dump stats to log</a>
      </li>
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

  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <h2 class="bwStatusConfirmed">
      <div id="searchFilter">
        <form name="searchForm" method="post" action="{$search}">
          Search:
          <input type="text" name="query" size="15">
            <xsl:attribute name="value"><xsl:value-of select="/bedeworkadmin/searchResults/query"/></xsl:attribute>
          </input>
          <input type="submit" name="submit" value="go"/>
          Limit:
          <xsl:choose>
            <xsl:when test="/bedeworkadmin/searchResults/searchLimits = 'beforeToday'">
              <input type="radio" name="searchLimits" value="fromToday"/>today forward
              <input type="radio" name="searchLimits" value="beforeToday" checked="checked"/>past dates
              <input type="radio" name="searchLimits" value="none"/>all dates
            </xsl:when>
            <xsl:when test="/bedeworkadmin/searchResults/searchLimits = 'none'">
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
          <xsl:if test="/bedeworkadmin/searchResults/numPages &gt; 1">
            <xsl:variable name="curPage" select="/bedeworkadmin/searchResults/curPage"/>
            <div id="searchPageForm">
              page:
              <xsl:if test="/bedeworkadmin/searchResults/curPage != 1">
                <xsl:variable name="prevPage" select="number($curPage) - 1"/>
                &lt;<a href="{$search-next}&amp;pageNum={$prevPage}">prev</a>
              </xsl:if>
              <xsl:text> </xsl:text>

              <xsl:call-template name="searchResultPageNav">
                <xsl:with-param name="page">
                  <xsl:choose>
                    <xsl:when test="number($curPage) - 10 &lt; 1">1</xsl:when>
                    <xsl:otherwise><xsl:value-of select="number($curPage) - 6"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>

              <xsl:text> </xsl:text>
              <xsl:choose>
                <xsl:when test="$curPage != /bedeworkadmin/searchResults/numPages">
                  <xsl:variable name="nextPage" select="number($curPage) + 1"/>
                  <a href="{$search-next}&amp;pageNum={$nextPage}">next</a>&gt;
                </xsl:when>
                <xsl:otherwise>
                  <span class="hidden">next&gt;</span><!-- occupy the space to keep the navigation from moving around -->
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:if>
          <xsl:value-of select="/bedeworkadmin/searchResults/resultSize"/>
          result<xsl:if test="/bedeworkadmin/searchResults/resultSize != 1">s</xsl:if> returned
          for <em><xsl:value-of select="/bedeworkadmin/searchResults/query"/></em>
        </th>
      </tr>
      <xsl:if test="/bedeworkadmin/searchResults/searchResult">
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
      <xsl:for-each select="/bedeworkadmin/searchResults/searchResult">
        <xsl:variable name="subscriptionId" select="event/subscription/id"/>
        <xsl:variable name="calPath" select="event/calendar/encodedPath"/>
        <xsl:variable name="guid" select="event/guid"/>
        <xsl:variable name="recurrenceId" select="event/recurrenceId"/>
        <tr>
          <td class="relevance">
            <xsl:value-of select="ceiling(number(score)*100)"/>%
            <img src="{$resourcesRoot}/images/spacer.gif" height="4" class="searchRelevance">
              <xsl:attribute name="width"><xsl:value-of select="ceiling((number(score)*100) div 1.5)"/></xsl:attribute>
            </img>
          </td>
          <td>
            <a href="{$event-fetchForDisplay}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="event/summary"/>
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
            <xsl:value-of select="event/calendar/name"/>
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
    <xsl:variable name="curPage" select="/bedeworkadmin/searchResults/curPage"/>
    <xsl:variable name="numPages" select="/bedeworkadmin/searchResults/numPages"/>
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

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="header">
    <div id="header">
      <a href="{$urlPrefix}">
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
          <xsl:when test="/bedeworkadmin/page='modEvent' or /bedeworkadmin/page='eventList' or /bedeworkadmin/page='displayEvent'">
            Manage Events
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='contactList' or /bedeworkadmin/page='modContact' or /bedeworkadmin/page='deleteContactConfirm'">
            Manage Contacts
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='locationList' or /bedeworkadmin/page='modLocation' or /bedeworkadmin/page='deleteLocationConfirm'">
            Manage Locations
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='calendarList' or /bedeworkadmin/page='modCalendar' or /bedeworkadmin/page='calendarReferenced' or /bedeworkadmin/page='deleteCalendarConfirm'">
            Manage Calendars
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='calendarDescriptions' or /bedeworkadmin/page='displayCalendar'">
            Public Calendars
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='subscriptions' or /bedeworkadmin/page='modSubscription'">
            Manage Subscriptions
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='views' or /bedeworkadmin/page='modView'">
            Manage Views
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='modSyspars'">
            Manage System Preferences
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='authUserList' or /bedeworkadmin/page='modAuthUser'">
            Manage Public Events Administrators
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='chooseGroup'">
            Choose Administrative Group
          </xsl:when>
          <xsl:when test="/bedeworkadmin/page='adminGroupList' or /bedeworkadmin/page='modAdminGroup' or /bedeworkadmin/page='modAdminGroup' or /bedeworkadmin/page='modAdminGroupMembers'">
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
          <p>
            <xsl:apply-templates select="/bedeworkadmin/message"/>
          </p>
        </div>
      </xsl:if>
      <xsl:if test="/bedeworkadmin/error">
        <div id="errors">
          <p>
            <xsl:apply-templates select="/bedeworkadmin/error"/>
          </p>
        </div>
      </xsl:if>

    </div>
    <table id="statusBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$setup}">Main Menu</a> |
          <a href="{$publicCal}" target="calendar">Launch Calendar</a> |
          <a href="{$logout}">Log Out</a>
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
      <a href="http://www.bedework.org/">Bedework Website</a> |
      <!-- Enable the following two items when debugging skins only -->
      <a href="?noxslt=yes">show XML</a> |
      <a href="?refreshXslt=yes">refresh XSLT</a>
    </div>
  </xsl:template>
</xsl:stylesheet>
