<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
     method="html"
     indent="no"
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
  <xsl:include href="../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/messages.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/util.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/bedeworkAccess.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the admin client
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
       we will probably change the way we create these before long (e.g. build them
       dynamically in the xslt). -->

  <xsl:variable name="submissionsRootEncoded" select="/bedework/submissionsRoot/encoded"/>
  <xsl:variable name="submissionsRootUnencoded" select="/bedework/submissionsRoot/unencoded"/>

  <!-- primary navigation, menu tabs -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup/a/@href"/>
  <xsl:variable name="initPendingTab" select="/bedework/urlPrefixes/initPendingTab/a/@href"/>
  <xsl:variable name="showCalsuiteTab" select="/bedework/urlPrefixes/showCalsuiteTab/a/@href"/>
  <xsl:variable name="showUsersTab" select="/bedework/urlPrefixes/showUsersTab/a/@href"/>
  <xsl:variable name="showSystemTab" select="/bedework/urlPrefixes/showSystemTab/a/@href"/>
  <xsl:variable name="logout" select="/bedework/urlPrefixes/logout/a/@href"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search/a/@href"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next/a/@href"/>

  <!-- events -->
  <xsl:variable name="event-showEvent" select="/bedework/urlPrefixes/event/showEvent/a/@href"/>
  <xsl:variable name="event-showModForm" select="/bedework/urlPrefixes/event/showModForm/a/@href"/>
  <xsl:variable name="event-showUpdateList" select="/bedework/urlPrefixes/event/showUpdateList/a/@href"/>
  <xsl:variable name="event-showDeleteConfirm" select="/bedework/urlPrefixes/event/showDeleteConfirm/a/@href"/>
  <xsl:variable name="event-initAddEvent" select="/bedework/urlPrefixes/event/initAddEvent/a/@href"/>
  <xsl:variable name="event-initUpdateEvent" select="/bedework/urlPrefixes/event/initUpdateEvent/a/@href"/>
  <xsl:variable name="event-delete" select="/bedework/urlPrefixes/event/delete/a/@href"/>
  <xsl:variable name="event-deletePending" select="/bedework/urlPrefixes/event/deletePending/a/@href"/>
  <xsl:variable name="event-fetchForDisplay" select="/bedework/urlPrefixes/event/fetchForDisplay/a/@href"/>
  <xsl:variable name="event-fetchForUpdate" select="/bedework/urlPrefixes/event/fetchForUpdate/a/@href"/>
  <xsl:variable name="event-fetchForUpdatePending" select="/bedework/urlPrefixes/event/fetchForUpdatePending/a/@href"/>
  <xsl:variable name="event-update" select="/bedework/urlPrefixes/event/update/a/@href"/>
  <xsl:variable name="event-updatePending" select="/bedework/urlPrefixes/event/updatePending/a/@href"/>
  <xsl:variable name="event-selectCalForEvent" select="/bedework/urlPrefixes/event/selectCalForEvent/a/@href"/>
  <xsl:variable name="event-initUpload" select="/bedework/urlPrefixes/event/initUpload/a/@href"/>
  <xsl:variable name="event-upload" select="/bedework/urlPrefixes/event/upload/a/@href"/>
  <!-- contacts -->
  <xsl:variable name="contact-showContact" select="/bedework/urlPrefixes/contact/showContact/a/@href"/>
  <xsl:variable name="contact-showReferenced" select="/bedework/urlPrefixes/contact/showReferenced/a/@href"/>
  <xsl:variable name="contact-showModForm" select="/bedework/urlPrefixes/contact/showModForm/a/@href"/>
  <xsl:variable name="contact-showUpdateList" select="/bedework/urlPrefixes/contact/showUpdateList/a/@href"/>
  <xsl:variable name="contact-showDeleteConfirm" select="/bedework/urlPrefixes/contact/showDeleteConfirm/a/@href"/>
  <xsl:variable name="contact-initAdd" select="/bedework/urlPrefixes/contact/initAdd/a/@href"/>
  <xsl:variable name="contact-initUpdate" select="/bedework/urlPrefixes/contact/initUpdate/a/@href"/>
  <xsl:variable name="contact-delete" select="/bedework/urlPrefixes/contact/delete/a/@href"/>
  <xsl:variable name="contact-fetchForDisplay" select="/bedework/urlPrefixes/contact/fetchForDisplay/a/@href"/>
  <xsl:variable name="contact-fetchForUpdate" select="/bedework/urlPrefixes/contact/fetchForUpdate/a/@href"/>
  <xsl:variable name="contact-update" select="/bedework/urlPrefixes/contact/update/a/@href"/>
  <!-- locations -->
  <xsl:variable name="location-showLocation" select="/bedework/urlPrefixes/location/showLocation/a/@href"/>
  <xsl:variable name="location-showReferenced" select="/bedework/urlPrefixes/location/showReferenced/a/@href"/>
  <xsl:variable name="location-showModForm" select="/bedework/urlPrefixes/location/showModForm/a/@href"/>
  <xsl:variable name="location-showUpdateList" select="/bedework/urlPrefixes/location/showUpdateList/a/@href"/>
  <xsl:variable name="location-showDeleteConfirm" select="/bedework/urlPrefixes/location/showDeleteConfirm/a/@href"/>
  <xsl:variable name="location-initAdd" select="/bedework/urlPrefixes/location/initAdd/a/@href"/>
  <xsl:variable name="location-initUpdate" select="/bedework/urlPrefixes/location/initUpdate/a/@href"/>
  <xsl:variable name="location-delete" select="/bedework/urlPrefixes/location/delete/a/@href"/>
  <xsl:variable name="location-fetchForDisplay" select="/bedework/urlPrefixes/location/fetchForDisplay/a/@href"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedework/urlPrefixes/location/fetchForUpdate/a/@href"/>
  <xsl:variable name="location-update" select="/bedework/urlPrefixes/location/update/a/@href"/>
  <!-- categories -->
  <xsl:variable name="category-showReferenced" select="/bedework/urlPrefixes/category/showReferenced/a/@href"/>
  <xsl:variable name="category-showModForm" select="/bedework/urlPrefixes/category/showModForm/a/@href"/>
  <xsl:variable name="category-showUpdateList" select="/bedework/urlPrefixes/category/showUpdateList/a/@href"/>
  <xsl:variable name="category-showDeleteConfirm" select="/bedework/urlPrefixes/category/showDeleteConfirm/a/@href"/>
  <xsl:variable name="category-initAdd" select="/bedework/urlPrefixes/category/initAdd/a/@href"/>
  <xsl:variable name="category-initUpdate" select="/bedework/urlPrefixes/category/initUpdate/a/@href"/>
  <xsl:variable name="category-delete" select="/bedework/urlPrefixes/category/delete/a/@href"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedework/urlPrefixes/category/fetchForUpdate/a/@href"/>
  <xsl:variable name="category-update" select="/bedework/urlPrefixes/category/update/a/@href"/>
  <!-- calendars -->
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch/a/@href"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions/a/@href"/>
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd/a/@href"/>
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate/a/@href"/>
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update/a/@href"/>
  <xsl:variable name="calendar-setAccess" select="/bedework/urlPrefixes/calendar/setAccess/a/@href"/>
  <xsl:variable name="calendar-openCloseMod" select="/bedework/urlPrefixes/calendar/calOpenCloseMod/a/@href"/>
  <xsl:variable name="calendar-openCloseSelect" select="/bedework/urlPrefixes/calendar/calOpenCloseSelect/a/@href"/>
  <xsl:variable name="calendar-openCloseDisplay" select="/bedework/urlPrefixes/calendar/calOpenCloseDisplay/a/@href"/>
  <xsl:variable name="calendar-openCloseMove" select="/bedework/urlPrefixes/calendar/calOpenCloseMove/a/@href"/>
  <xsl:variable name="calendar-move" select="/bedework/urlPrefixes/calendar/move/a/@href"/>
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch/a/@href"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate/a/@href"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd/a/@href"/>
  <xsl:variable name="subscriptions-update" select="/bedework/urlPrefixes/subscriptions/update/a/@href"/>
  <xsl:variable name="subscriptions-openCloseMod" select="/bedework/urlPrefixes/subscriptions/subOpenCloseMod/a/@href"/>
  <!-- views -->
  <xsl:variable name="view-fetch" select="/bedework/urlPrefixes/view/fetch/a/@href"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedework/urlPrefixes/view/fetchForUpdate/a/@href"/>
  <xsl:variable name="view-addView" select="/bedework/urlPrefixes/view/addView/a/@href"/>
  <xsl:variable name="view-update" select="/bedework/urlPrefixes/view/update/a/@href"/>
  <xsl:variable name="view-remove" select="/bedework/urlPrefixes/view/remove/a/@href"/>
  <!-- system -->
  <xsl:variable name="system-fetch" select="/bedework/urlPrefixes/system/fetch/a/@href"/>
  <xsl:variable name="system-update" select="/bedework/urlPrefixes/system/update/a/@href"/>
  <!-- calsuites -->
  <xsl:variable name="calsuite-fetch" select="/bedework/urlPrefixes/calsuite/fetch/a/@href"/>
  <xsl:variable name="calsuite-fetchForUpdate" select="/bedework/urlPrefixes/calsuite/fetchForUpdate/a/@href"/>
  <xsl:variable name="calsuite-add" select="/bedework/urlPrefixes/calsuite/add/a/@href"/>
  <xsl:variable name="calsuite-update" select="/bedework/urlPrefixes/calsuite/update/a/@href"/>
  <xsl:variable name="calsuite-showAddForm" select="/bedework/urlPrefixes/calsuite/showAddForm/a/@href"/>
  <xsl:variable name="calsuite-setAccess" select="/bedework/urlPrefixes/calsuite/setAccess/a/@href"/>
  <xsl:variable name="calsuite-fetchPrefsForUpdate" select="/bedework/urlPrefixes/calsuite/fetchPrefsForUpdate/a/@href"/>
  <xsl:variable name="calsuite-updatePrefs" select="/bedework/urlPrefixes/calsuite/updatePrefs/a/@href"/>
  <!-- timezones and stats -->
  <xsl:variable name="timezones-initUpload" select="/bedework/urlPrefixes/timezones/initUpload/a/@href"/>
  <xsl:variable name="timezones-upload" select="/bedework/urlPrefixes/timezones/upload/a/@href"/>
  <xsl:variable name="timezones-fix" select="/bedework/urlPrefixes/timezones/fix/a/@href"/>
  <xsl:variable name="stats-update" select="/bedework/urlPrefixes/stats/update/a/@href"/>
  <!-- authuser and prefs -->
  <xsl:variable name="authuser-showModForm" select="/bedework/urlPrefixes/authuser/showModForm/a/@href"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedework/urlPrefixes/authuser/showUpdateList/a/@href"/>
  <xsl:variable name="authuser-initUpdate" select="/bedework/urlPrefixes/authuser/initUpdate/a/@href"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedework/urlPrefixes/authuser/fetchForUpdate/a/@href"/>
  <xsl:variable name="authuser-update" select="/bedework/urlPrefixes/authuser/update/a/@href"/>
  <xsl:variable name="prefs-fetchForUpdate" select="/bedework/urlPrefixes/prefs/fetchForUpdate/a/@href"/>
  <xsl:variable name="prefs-update" select="/bedework/urlPrefixes/prefs/update/a/@href"/>
  <!-- admin groups -->
  <xsl:variable name="admingroup-showModForm" select="/bedework/urlPrefixes/admingroup/showModForm/a/@href"/>
  <xsl:variable name="admingroup-showModMembersForm" select="/bedework/urlPrefixes/admingroup/showModMembersForm/a/@href"/>
  <xsl:variable name="admingroup-showUpdateList" select="/bedework/urlPrefixes/admingroup/showUpdateList/a/@href"/>
  <xsl:variable name="admingroup-showChooseGroup" select="/bedework/urlPrefixes/admingroup/showChooseGroup/a/@href"/>
  <xsl:variable name="admingroup-showDeleteConfirm" select="/bedework/urlPrefixes/admingroup/showDeleteConfirm/a/@href"/>
  <xsl:variable name="admingroup-initAdd" select="/bedework/urlPrefixes/admingroup/initAdd/a/@href"/>
  <xsl:variable name="admingroup-initUpdate" select="/bedework/urlPrefixes/admingroup/initUpdate/a/@href"/>
  <xsl:variable name="admingroup-delete" select="/bedework/urlPrefixes/admingroup/delete/a/@href"/>
  <xsl:variable name="admingroup-fetchUpdateList" select="/bedework/urlPrefixes/admingroup/fetchUpdateList/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedework/urlPrefixes/admingroup/fetchForUpdate/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedework/urlPrefixes/admingroup/fetchForUpdateMembers/a/@href"/>
  <xsl:variable name="admingroup-update" select="/bedework/urlPrefixes/admingroup/update/a/@href"/>
  <xsl:variable name="admingroup-updateMembers" select="/bedework/urlPrefixes/admingroup/updateMembers/a/@href"/>
  <xsl:variable name="admingroup-switch" select="/bedework/urlPrefixes/admingroup/switch/a/@href"/>
  <!-- filters -->
  <xsl:variable name="filter-showAddForm" select="/bedework/urlPrefixes/filter/showAddForm/a/@href"/>
  <xsl:variable name="filter-add" select="/bedework/urlPrefixes/filter/add/a/@href"/>
  <xsl:variable name="filter-delete" select="/bedework/urlPrefixes/filter/delete/a/@href"/>


  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!-- the following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals.  -->
  <xsl:variable name="portalFriendly">false</xsl:variable>

  <!--==== MAIN TEMPLATE  ====-->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Calendar Admin: Public Events Administration</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/subColors.css"/>
        <!-- set globals that must be passed in from the XSLT -->
        <script type="text/javascript">
          <xsl:comment>
          var defaultTzid = "<xsl:value-of select="/bedework/now/defaultTzid"/>";
          var startTzid = "<xsl:value-of select="/bedework/formElements/form/start/tzid"/>";
          var endTzid = "<xsl:value-of select="/bedework/formElements/form/end/dateTime/tzid"/>";
          var resourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";
          </xsl:comment>
        </script>
        <xsl:if test="/bedework/page='modEvent' or /bedework/page='modEventPending'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bwClock.js">&#160;</script>
          <link rel="stylesheet" href="{$resourcesRoot}/resources/bwClock.css"/>
          <xsl:choose>
            <xsl:when test="$portalFriendly = 'true'">
              <script type="text/javascript" src="{$resourcesRoot}/resources/dynCalendarWidget.js">&#160;</script>
              <link rel="stylesheet" href="{$resourcesRoot}/resources/dynCalendarWidget.css"/>
            </xsl:when>
            <xsl:otherwise>
              <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.2.6.min.js">&#160;</script>
              <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.5.2.min.js">&#160;</script>
              <link rel="stylesheet" href="/bedework-common/javascript/jquery/bedeworkJqueryThemes.css"/>
              <script type="text/javascript">
                <xsl:comment>
                $.datepicker.setDefaults({
                  constrainInput: true,
                  dateFormat: "yy-mm-dd",
                  showOn: "both",
                  buttonImage: "<xsl:value-of select='$resourcesRoot'/>/resources/calIcon.gif",
                  buttonImageOnly: true,
                  gotoCurrent: true,
                  duration: ""
                });
                </xsl:comment>
              </script>
              <!-- script type="text/javascript" src="/bedework-common/javascript/dojo/dojo.js">&#160;</script-->
            </xsl:otherwise>
          </xsl:choose>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkEventForm.js">&#160;</script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkXProperties.js">&#160;</script>
          <script type="text/javascript">
            <xsl:comment>
            function initRXDates() {
              // return string values to be loaded into javascript for rdates
              <xsl:for-each select="/bedework/formElements/form/rdates/rdate">
                bwRdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
              </xsl:for-each>
              // return string values to be loaded into javascript for exdates
              <xsl:for-each select="/bedework/formElements/form/exdates/rdate">
                bwExdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
              </xsl:for-each>
            }
            function initXProperties() {
              <xsl:for-each select="/bedework/formElements/form/xproperties/node()[text()]">
                bwXProps.init('<xsl:value-of select="name()"/>',[<xsl:for-each select="parameters/node()">['<xsl:value-of select="name()"/>','<xsl:value-of select="node()"/>']<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],'<xsl:call-template name="escapeApos"><xsl:with-param name="str"><xsl:value-of select="values/text"/></xsl:with-param></xsl:call-template>');
              </xsl:for-each>
            }
            </xsl:comment>
          </script>
        </xsl:if>
        <xsl:if test="/bedework/page='modCalendar' or
                      /bedework/page='modCalSuite' or
                      /bedework/page='modSubscription'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
          <link rel="stylesheet" href="/bedework-common/default/default/bedeworkAccess.css"/>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkAccess.js">&#160;</script>
          <!-- initialize calendar acls, if present -->
          <xsl:if test="/bedework/currentCalendar/acl/ace">
            <script type="text/javascript">
              <xsl:apply-templates select="/bedework/currentCalendar/acl/ace" mode="initJS"/>
            </script>
          </xsl:if>
        </xsl:if>
        <xsl:if test="/bedework/page='upload' or /bedework/page='selectCalForEvent'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
        </xsl:if>
        <xsl:if test="/bedework/page='calendarDescriptions' or /bedework/page='displayCalendar'">
          <link rel="stylesheet" href="{$resourcesRoot}/resources/calendarDescriptions.css"/>
        </xsl:if>
        <xsl:if test="/bedework/page='addFilter'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
        </xsl:if>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
        <script language="JavaScript" type="text/javascript">
          <xsl:comment>
          <![CDATA[
          // places the cursor in the first available form element when the page is loaded
          // (if a form exists on the page)
          function focusFirstElement() {
            if (window.document.forms[0]) {
              for (i=0; i<window.document.forms[0].elements.length; i++) {
                if (window.document.forms[0].elements[i].type != "submit" &&
                    window.document.forms[0].elements[i].type != "reset" ) {
                  window.document.forms[0].elements[i].focus();
                  break;
                }
              }
            }
          }]]>
          </xsl:comment>
        </script>
      </head>
      <body>
        <xsl:choose>
          <xsl:when test="(/bedework/page='modEvent' or /bedework/page='modEventPending') and /bedework/formElements/recurrenceId=''">
            <xsl:attribute name="onload">initRXDates();initXProperties();focusFirstElement();</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="onload">focusFirstElement();</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <div id="bedework"><!-- main wrapper div to keep styles encapsulated -->
        <xsl:choose>
          <xsl:when test="/bedework/page='selectCalForEvent'">
            <xsl:call-template name="selectCalForEvent"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="header"/>
            <div id="content">
              <xsl:choose>
                <xsl:when test="/bedework/page='tabPendingEvents'">
                  <xsl:call-template name="tabPendingEvents"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabCalsuite'">
                  <xsl:call-template name="tabCalsuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabUsers'">
                  <xsl:call-template name="tabUsers"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabSystem'">
                  <xsl:call-template name="tabSystem"/>
                </xsl:when>
                <xsl:when test="/bedework/page='eventList'">
                  <xsl:call-template name="eventList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modEvent' or
                               /bedework/page='modEventPending'">
                  <xsl:apply-templates select="/bedework/formElements" mode="modEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='displayEvent' or
                                /bedework/page='deleteEventConfirm' or
                                /bedework/page='deleteEventConfirmPending'">
                  <xsl:apply-templates select="/bedework/event" mode="displayEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='contactList'">
                  <xsl:call-template name="contactList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modContact'">
                  <xsl:call-template name="modContact"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteContactConfirm' or
                                /bedework/page='contactReferenced'">
                  <xsl:call-template name="deleteContactConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='locationList'">
                  <xsl:call-template name="locationList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modLocation'">
                  <xsl:call-template name="modLocation"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteLocationConfirm'">
                  <xsl:call-template name="deleteLocationConfirm"/>
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
                <xsl:when test="/bedework/page='calendarList' or
                                /bedework/page='calendarDescriptions' or
                                /bedework/page='displayCalendar' or
                                /bedework/page='modCalendar' or
                                /bedework/page='deleteCalendarConfirm' or
                                /bedework/page='calendarReferenced'">
                  <xsl:apply-templates select="/bedework/calendars" mode="calendarCommon"/>
                </xsl:when>
                <xsl:when test="/bedework/page='moveCalendar'">
                  <xsl:call-template name="calendarMove"/>
                </xsl:when>
                <xsl:when test="/bedework/page='subscriptions' or
                                /bedework/page='modSubscription'">
                  <xsl:apply-templates select="/bedework/calendars" mode="subscriptions"/>
                </xsl:when>
                <xsl:when test="/bedework/page='views'">
                  <xsl:apply-templates select="/bedework/views" mode="viewList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modView'">
                  <xsl:call-template name="modView"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteViewConfirm'">
                  <xsl:call-template name="deleteViewConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modSyspars'">
                  <xsl:call-template name="modSyspars"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calSuiteList'">
                  <xsl:apply-templates select="/bedework/calSuites" mode="calSuiteList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='addCalSuite'">
                  <xsl:call-template name="addCalSuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modCalSuite'">
                  <xsl:apply-templates select="/bedework/calSuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calSuitePrefs'">
                  <xsl:call-template name="calSuitePrefs"/>
                </xsl:when>
                <xsl:when test="/bedework/page='authUserList'">
                  <xsl:call-template name="authUserList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAuthUser'">
                  <xsl:call-template name="modAuthUser"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modPrefs'">
                  <xsl:call-template name="modPrefs"/>
                </xsl:when>
                <xsl:when test="/bedework/page='chooseGroup'">
                  <xsl:apply-templates select="/bedework/groups" mode="chooseGroup"/>
                </xsl:when>
                <xsl:when test="/bedework/page='adminGroupList'">
                  <xsl:call-template name="listAdminGroups"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAdminGroup'">
                  <xsl:call-template name="modAdminGroup"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAdminGroupMembers'">
                  <xsl:call-template name="modAdminGroupMembers"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteAdminGroupConfirm'">
                  <xsl:call-template name="deleteAdminGroupConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='addFilter'">
                  <xsl:call-template name="addFilter"/>
                </xsl:when>
                <xsl:when test="/bedework/page='searchResult'">
                  <xsl:call-template name="searchResult"/>
                </xsl:when>
                <xsl:when test="/bedework/page='noGroup'">
                  <h2>No administrative group</h2>
                  <p>Your userid has not been assigned to an administrative group.
                    Please inform your administrator.</p>
                </xsl:when>
                <xsl:when test="/bedework/page='upload'">
                  <xsl:call-template name="upload"/>
                </xsl:when>
                <xsl:when test="/bedework/page='uploadTimezones'">
                  <xsl:call-template name="uploadTimezones"/>
                </xsl:when>
                <xsl:when test="/bedework/page='showSysStats'">
                  <xsl:apply-templates select="/bedework/sysStats" mode="showSysStats"/>
                </xsl:when>
                <xsl:when test="/bedework/page='noAccess'">
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
                <xsl:when test="/bedework/page='error'">
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
        </div>
      </body>
    </html>
  </xsl:template>


  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="header">
    <div id="header">
      <a href="/bedework/">
        <img id="logo"
            alt="logo"
            src="{$resourcesRoot}/resources/bedeworkAdminLogo.gif"
            width="217"
            height="40"
            border="0"/>
      </a>
      <h1>
        Bedework Public Events Administration
      </h1>
    </div>
    <xsl:call-template name="messagesAndErrors"/>
    <table id="statusBarTable">
      <tr>
        <td class="leftCell">
          <xsl:if test="/bedework/currentCalSuite/name">
            Calendar Suite:
            <span class="status">
              <xsl:value-of select="/bedework/currentCalSuite/name"/>
            </span>
            <xsl:text> </xsl:text>
          </xsl:if>
          <!--
          <a href="{$setup}">Home</a>
          <a href="{$publicCal}" target="calendar">Launch Calendar</a>
          -->
        </td>
        <xsl:if test="/bedework/userInfo/user">
          <td class="rightCell">
            <xsl:if test="/bedework/userInfo/group">
              <span id="groupDisplay">
                Group:
                <span class="status">
                  <xsl:value-of select="/bedework/userInfo/group"/>
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="/bedework/userInfo/oneGroup = 'false' or /bedework/userInfo/superUser = 'true'">
                  <a href="{$admingroup-switch}" class="fieldInfo">change</a>
                </xsl:if>
                <xsl:text> </xsl:text>
              </span>
            </xsl:if>
            Logged in as:
            <span class="status">
              <xsl:value-of select="/bedework/userInfo/currentUser"/>
            </span>
            <xsl:text> </xsl:text>
            <a href="{$logout}" id="bwLogoutButton" class="fieldInfo">log out</a>
          </td>
        </xsl:if>
      </tr>
    </table>

    <ul id="bwAdminMenu">
      <li>
        <xsl:if test="/bedework/tab = 'main'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$setup}&amp;listAllEvents=false">Main Menu</a>
      </li>
      <li>
        <xsl:if test="/bedework/tab = 'pending'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$initPendingTab}&amp;calPath={$submissionsRootEncoded}&amp;listAllEvents=true">Pending Events</a>
      </li>
      <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
        <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
          <li>
            <xsl:if test="/bedework/tab = 'calsuite'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$showCalsuiteTab}">Calendar Suite</a>
          </li>
        </xsl:if>
      </xsl:if>
      <xsl:if test="/bedework/userInfo/superUser='true'">
        <li>
          <xsl:if test="/bedework/tab = 'users'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showUsersTab}">Users</a>
        </li>
        <li>
          <xsl:if test="/bedework/tab = 'system'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showSystemTab}">System</a>
        </li>
      </xsl:if>
    </ul>
  </xsl:template>

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

  <!--==============================================-->
  <!--==============================================-->
  <!--============= PAGE TEMPLATES =================-->
  <!--==============================================-->
  <!--==============================================-->

  <!--+++++++++++++++ Main Menu Tab ++++++++++++++++++++-->
  <xsl:template name="mainMenu">

    <table id="mainMenu">
      <tr>
        <td>
          <a id="addEventLink" href="{$event-initAddEvent}">
            <img src="{$resourcesRoot}/resources/bwAdminAddEventIcon.jpg" width="140" height="140" alt="Add Event" border="0"/>
            <br/>Add Event
          </a>
        </td>
        <td>
          <a id="addContactLink" href="{$contact-initAdd}">
            <img src="{$resourcesRoot}/resources/bwAdminAddContactIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
            <br/>Add Contact
          </a>
        </td>
        <td>
          <a id="addLocationLink" href="{$location-initAdd}">
            <img src="{$resourcesRoot}/resources/bwAdminAddLocationIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
            <br/>Add Location
          </a>
        </td>
        <!--
          Category management is becomeing a  super-user and calsuite admin feature;
          Categories underly much of the new single calendar and filtering model.
        <td>
          <a id="addCategoryLink" href="{$category-initAdd}">
            <img src="{$resourcesRoot}/resources/bwAdminAddCategoryIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
            <br/>Add Category
          </a>
        </td> -->
      </tr>
      <tr>
        <td>
          <a href="{$event-initUpdateEvent}">
            <img src="{$resourcesRoot}/resources/bwAdminManageEventsIcon.jpg" width="100" height="73" alt="Manage Events" border="0"/>
            <br/>Manage Events
          </a>
        </td>
        <td>
          <a href="{$contact-initUpdate}">
            <img src="{$resourcesRoot}/resources/bwAdminManageContactsIcon.jpg" width="100" height="73" alt="Manage Contacts" border="0"/>
            <br/>Manage Contacts
          </a>
        </td>
        <td>
          <a href="{$location-initUpdate}">
            <img src="{$resourcesRoot}/resources/bwAdminManageLocsIcon.jpg" width="100" height="73" alt="Manage Locations" border="0"/>
            <br/>Manage Locations
          </a>
        </td>
        <!--
          Category management is becomeing a super-user and calsuite admin feature;
          Categories underly much of the new single calendar and filtering model.
        <td>
          <a href="{$category-initUpdate}">
            <img src="{$resourcesRoot}/resources/bwAdminManageCatsIcon.jpg" width="100" height="73" alt="Manage Categories" border="0"/>
            <br/>Manage Categories
          </a>
        </td> -->
      </tr>
    </table>

    <div id="mainMenuEventSearch">
      <h4 class="menuTitle">Event search:</h4>
      <form name="searchForm" method="post" action="{$search}" id="searchForm">
        <input type="text" name="query" size="30">
          <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
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
  </xsl:template>

  <!--+++++++++++++++ Pending Events Tab ++++++++++++++++++++-->
  <xsl:template name="tabPendingEvents">
    <h2>Pending Events</h2>
    <p>The following events were submitted to the calendar:</p>
    <xsl:call-template name="eventListCommon">
      <xsl:with-param name="pending">true</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!--+++++++++++++++ Calendar Suite Tab ++++++++++++++++++++-->
  <xsl:template name="tabCalsuite">
    <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser='true'">
      <h2>
        Manage Calendar Suite
      </h2>

      <div id="calSuiteTitle">
        Calendar Suite:
        <strong><xsl:value-of select="/bedework/currentCalSuite/name"/></strong>
        <xsl:text> </xsl:text>
        Group:
        <strong><xsl:value-of select="/bedework/currentCalSuite/group"/></strong>
        <xsl:text> </xsl:text>
        <a href="{$admingroup-switch}" class="fieldInfo">change</a>
      </div>
      <ul class="adminMenu">
        <li>
          <a href="{$subscriptions-fetch}" title="subscriptions to calendars">
            Manage subscriptions
          </a>
        </li>
        <li>
          <a href="{$view-fetch}" title="collections of subscriptions">
            Manage views
          </a>
        </li>
        <li>
          <a href="{$calsuite-fetchPrefsForUpdate}" title="calendar suite defaults such as viewperiod and view">
            Manage preferences
          </a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ User/Group Tab ++++++++++++++++++++-->
  <xsl:template name="tabUsers">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2>Manage Users &amp; Groups</h2>
      <ul class="adminMenu">
        <!-- deprecated (for now, likely permanent) -->
        <!-- xsl:if test="/bedework/userInfo/userMaintOK='true'">
          <li>
            <a href="{$authuser-initUpdate}">
              Manage admin roles
            </a>
          </li>
        </xsl:if-->
        <xsl:if test="/bedework/userInfo/adminGroupMaintOk='true'">
          <li class="groups">
            <a href="{$admingroup-initUpdate}">
              Manage admin groups
            </a>
          </li>
        </xsl:if>
        <li class="changeGroup">
          <a href="{$admingroup-switch}">
            Change group...
          </a>
        </li>
        <xsl:if test="/bedework/userInfo/userMaintOK='true'">
          <li class="user">
            <form action="{$prefs-fetchForUpdate}" method="post">
              Edit user preferences (enter userid):<br/>
              <input type="text" name="user" size="15"/>
              <input type="submit" name="getPrefs" value="go"/>
            </form>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ System Tab ++++++++++++++++++++-->
  <xsl:template name="tabSystem">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2>Manage System</h2>
      <ul class="adminMenu strong">
        <li class="calendar">
          <a href="{$calendar-fetch}">
            Manage calendars
          </a>
        </li>
        <li class="categories">
          <a href="{$category-initUpdate}">
            Manage categories
          </a>
        </li>
        <li class="calsuites">
          <a href="{$calsuite-fetch}">
            Manage calendar suites
          </a>
        </li>
        <li class="upload">
          <a href="{$event-initUpload}">
            Upload ical file
          </a>
        </li>
      </ul>
      <ul class="adminMenu">
        <li class="prefs">
          <a href="{$system-fetch}">
            Manage system preferences
          </a>
        </li>
        <li class="timezones">
          <a href="{$timezones-initUpload}">
            Manage system timezones
          </a>
        </li>
      </ul>
      <ul class="adminMenu">
        <li>
          Statistics:
          <ul>
            <li>
              <a href="{$stats-update}&amp;fetch=yes" target="adminStats">
                admin web client
              </a>
            </li>
            <li>
              <a href="{$publicCal}/stats/stats.do?fetch=yes" target="pubStats">
                public web client
              </a>
            </li>
          </ul>
        </li>
      </ul>
      <ul class="adminMenu">
        <li>
          <a href="{$filter-showAddForm}">
            Manage CalDAV filters
          </a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--++++++++++++++++++ Events ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <h2>Manage Events</h2>
    <p>
      Select the event that you would like to update:
      <input type="button" name="return" value="Add new event" onclick="javascript:location.replace('{$event-initAddEvent}')"/>
    </p>

    <form name="calForm" method="post" action="{$event-initUpdateEvent}">
      <table>
        <tr>
          <td style="padding-right: 1em;">Show:</td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/listAllSwitchFalse/*"/>
            Active
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/listAllSwitchTrue/*"/>
            All
          </td>
        </tr>
      </table>
    </form>

    <xsl:call-template name="eventListCommon"/>
  </xsl:template>

  <xsl:template name="eventListCommon">
    <xsl:param name="pending">false</xsl:param>
    <table id="commonListTable">
      <tr>
        <th>Title</th>
        <th>Start</th>
        <th>End</th>
        <th>Categories</th>
        <th>Calendar</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="/bedework/events/event">
        <xsl:variable name="subscriptionId" select="subscription/id"/>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="guid" select="guid"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="$pending = 'true'">
                <a href="{$event-fetchForUpdatePending}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:choose>
                    <xsl:when test="summary != ''">
                      <xsl:value-of select="summary"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <em>no title</em>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:choose>
                    <xsl:when test="summary != ''">
                      <xsl:value-of select="summary"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <em>no title</em>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="date">
            <xsl:value-of select="start/shortdate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="start/time"/>
          </td>
          <td class="date">
            <xsl:value-of select="end/shortdate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="end/time"/>
          </td>
          <td class="calcat">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><br/>
            </xsl:for-each>
          </td>
          <td>
            <xsl:value-of select="calendar/name"/>
          </td>
          <td>
            <xsl:value-of select="description"/>
            <xsl:if test="recurring = 'true' or recurrenceId != ''">
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

    <!-- if a submitted event has comments, display them -->
    <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-LOCATION' or name()='X-BEDEWORK-CONTACT' or name()='X-BEDEWORK-CATEGORIES' or name()='X-BEDEWORK-SUBMIT-COMMENT']">
      <script type="text/javascript">
        bwSubmitComment = new bwSubmitComment(
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-SUBADDRESS']"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/values/text"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-PHONE']"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-EMAIL']"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text"/></xsl:call-template>',
          '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text"/></xsl:call-template>');
      </script>

      <div id="bwSubmittedEventCommentBlock">
        <div id="bwSubmittedBy">Submitted by <xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></div>
        <h4>Comments from Submitter</h4>
        <a href="javascript:toggleVisibility('bwSubmittedEventComment','visible');" class="toggle">show/hide</a>
        <a href="javascript:bwSubmitComment.launch();" class="toggle">pop-up</a>
        <div id="bwSubmittedEventComment">
          <xsl:if test="/bedework/page = 'modEvent'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
        </div>
      </div>
      <script type="text/javascript">
        bwSubmitComment.display('bwSubmittedEventComment');
      </script>
    </xsl:if>

    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userInfo/currentUser"/> for <xsl:value-of select="/bedework/userInfo/group"/> (<xsl:value-of select="/bedework/userInfo/user"/>)</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}')">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventPending'">
          <xsl:attribute name="action"><xsl:value-of select="$event-updatePending"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="action"><xsl:value-of select="$event-update"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="submitEventButtons"/>

      <table class="eventFormTable">
        <tr>
          <td class="fieldName">
            Title:
          </td>
          <td>
            <xsl:copy-of select="form/title/*"/>
          </td>
        </tr>
        <!-- Disabling calendar selection is temporary - but we must determine if we're using
             a single calendar model (e.g. excluding submissions calendar, etc). The following value should *not* be
             hard coded, but we'll do this for the moment. -->
        <input type="hidden" name="newCalPath" value="/public/cals/MainCal"/>
        <!--
        <xsl:if test="not(starts-with(form/calendar/path,$submissionsRootUnencoded))">
          <tr>
            <td class="fieldName">
              Calendar:
              <input type="hidden" name="newCalPath" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option[@selected]/@value"/></xsl:attribute>
              </input>
            </td>
            <td>
              <xsl:if test="form/calendar/preferred/select/option">
                -  - Display the preferred calendars by default if they exist - -
                <select name="bwPreferredCalendars" id="bwPreferredCalendars" onchange="this.form.newCalPath.value = this.value">
                  <option value="">
                    Select:
                  </option>
                  <xsl:for-each select="form/calendar/preferred/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          submitted events
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
              </xsl:if>
               - - hide the listing of all calendars if preferred calendars exist, otherwise show them - -
              <select name="bwAllCalendars" id="bwAllCalendars" onchange="this.form.newCalPath.value = this.value;">
                <xsl:if test="form/calendar/preferred/select/option">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <option value="">
                  Select:
                </option>
                <xsl:for-each select="form/calendar/all/select/option">
                  <xsl:sort select="." order="ascending"/>
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                    <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                    <xsl:choose>
                      <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                        submitted events
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-after(node(),'/public/')"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </option>
                </xsl:for-each>
              </select>
              <xsl:text> </xsl:text>
               - - allow for toggling between the preferred and all calendars listings if preferred
                   calendars exist - -
              <xsl:if test="form/calendar/preferred/select/option">
                <input type="radio" name="toggleCalendarLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredCalendars','shown');changeClass('bwAllCalendars','invisible');this.form.newCalPath.value = this.form.bwPreferredCalendars.value;"/>
                preferred
                <input type="radio" name="toggleCalendarLists" value="all" onclick="changeClass('bwPreferredCalendars','invisible');changeClass('bwAllCalendars','shown');this.form.newCalPath.value = this.form.bwAllCalendars.value;"/>
                all
              </xsl:if>
              <br/>
              <span id="calDescriptionsLink">
                <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')">calendar descriptions</a>
              </span>
            </td>
          </tr>
        </xsl:if> -->

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
            all day

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
                <xsl:choose>
                  <xsl:when test="$portalFriendly = 'true'">
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
                    <script language="JavaScript" type="text/javascript">
                      <xsl:comment>
                      startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                      </xsl:comment>
                    </script>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetStartDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                      <xsl:text> </xsl:text>
                    </span-->
                    <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                    <script language="JavaScript" type="text/javascript">
                      <xsl:comment>
                      $("#bwEventWidgetStartDate").datepicker({
                        defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                      }).attr("readonly", "readonly");
                      $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
                      //alert($("#bwEventWidgetStartDate").datepicker("getDate"));
                      </xsl:comment>
                    </script>
                    <input type="hidden" name="eventStartDate.year">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.month">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.day">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
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
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
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
                  <xsl:choose>
                    <xsl:when test="$portalFriendly = 'true'">
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
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                      </xsl:comment>
                      </script>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetEndDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/rfc3339DateTime"/></xsl:attribute>
                        <xsl:text> </xsl:text>
                      </span-->
                      <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        $("#bwEventWidgetEndDate").datepicker({
                          defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                        }).attr("readonly", "readonly");
                        $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');
                        </xsl:comment>
                      </script>
                      <input type="hidden" name="eventEndDate.year">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/yearText/input/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.month">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.day">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
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
            <xsl:choose>
              <xsl:when test="recurrenceId != ''">
                <!-- recurrence instances can not themselves recur,
                     so provide access to master event -->
                <em>This event is a recurrence instance.</em><br/>
                <a href="{$event-fetchForUpdate}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">edit master event</a>
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

                  <h4>Recurrence Rules</h4>
                  <!-- show or hide rrules fields when editing: -->
                  <xsl:if test="form/recurrence">
                    <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on"/>
                    <span id="rrulesSwitch">
                      change recurrence rules
                    </span>
                  </xsl:if>
                  <span id="rrulesUiSwitch">
                    <xsl:if test="form/recurrence">
                      <xsl:attribute name="class">invisible</xsl:attribute>
                    </xsl:if>
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
                  <table id="rrulesTable" cellspacing="0">
                  <xsl:if test="form/recurrence">
                    <xsl:attribute name="class">invisible</xsl:attribute>
                  </xsl:if>
                    <tr>
                      <td id="recurrenceFrequency" rowspan="2">
                        <em>Frequency:</em><br/>
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
                          <em>Repeat:</em>
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
                              <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetUntilDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                                <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                                <xsl:text> </xsl:text>
                              </span -->
                              <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                              <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
                              <script language="JavaScript" type="text/javascript">
                                <xsl:comment>
                                $("#bwEventWidgetUntilDate").datepicker({
                                  <xsl:choose>
                                    <xsl:when test="form/recurrence/until">
                                      defaultDate: new Date(<xsl:value-of select="substring(form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(form/recurrence/until,7,2)"/>),
                                    </xsl:when>
                                    <xsl:otherwise>
                                      defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  altField: "#bwEventUntilDate",
                                  altFormat: "yymmdd"
                                }).attr("readonly", "readonly");
                                $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
                                </xsl:comment>
                              </script>
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
                            <em>Interval:</em>
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
                            <em>Interval:</em>
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
                            <em>Interval:</em>
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
                            <em>Interval:</em>
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
                            <em>Interval:</em>
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
                  <h4>
                    Recurrence and Exception Dates
                  </h4>
                  <div id="raContent">
                    <div class="dateStartEndBox" id="rdatesFormFields">
                      <!--
                      <input type="checkbox" name="dateOnly" id="rdateDateOnly" onclick="swapRdateAllDay(this)" value="true"/>
                      all day
                      <input type="checkbox" name="floating" id="rdateFloating" onclick="swapRdateFloatingTime(this)" value="true"/>
                      floating
                      store time as coordinated universal time (UTC)
                      <input type="checkbox" name="storeUTC" id="rdateStoreUTC" onclick="swapRdateStoreUTC(this)" value="true"/>
                      store as UTC<br/>-->
                      <div class="dateFields">
                        <!-- input name="eventRdate.date"
                               dojoType="dropdowndatepicker"
                               formatLength="medium"
                               value="today"
                               saveFormat="yyyyMMdd"
                               id="bwEventWidgeRdate"
                               iconURL="{$resourcesRoot}/resources/calIcon.gif"/-->
                        <input type="text" name="eventRdate.date" id="bwEventWidgetRdate" size="10"/>
                        <script language="JavaScript" type="text/javascript">
                          <xsl:comment>
                          $("#bwEventWidgetRdate").datepicker({
                            defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                            dateFormat: "yymmdd"
                          }).attr("readonly", "readonly");
                          $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
                          </xsl:comment>
                        </script>
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
                          <option value="">select timezone...</option>
                          <xsl:variable name="rdateTzId" select="/bedework/now/defaultTzid"/>
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
                      <!--bwRdates.update() accepts: date, time, allDay, floating, utc, tzid-->
                      <input type="button" name="rdate" value="add recurrence" onclick="bwRdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>
                      <input type="button" name="exdate" value="add exception" onclick="bwExdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>

                      <input type="hidden" name="rdates" value="" id="bwRdatesField" />
                      <!-- if there are no recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdatesNone">
                        <tr><th>Recurrence Dates</th></tr>
                        <tr><td>No recurrence dates</td></tr>
                      </table>

                      <!-- if there are recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdates">
                        <tr>
                          <th colspan="4">Recurrence Dates</th>
                        </tr>
                        <tr class="colNames">
                          <td>Date</td>
                          <td>Time</td>
                          <td>TZid</td>
                          <td></td>
                        </tr>
                      </table>

                      <input type="hidden" name="exdates" value="" id="bwExdatesField" />
                      <!-- if there are no exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdatesNone">
                        <tr><th>Exception Dates</th></tr>
                        <tr><td>No exception dates</td></tr>
                      </table>

                      <!-- if there are exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdates">
                        <tr>
                          <th colspan="4">Exception Dates</th>
                        </tr>
                        <tr class="colNames">
                          <td>Date</td>
                          <td>Time</td>
                          <td>TZid</td>
                          <td></td>
                        </tr>
                      </table>
                      <p>
                        Exception dates may also be created by deleting an instance
                        of a recurring event.
                      </p>
                    </div>
                  </div>
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
                <input type="radio" name="eventStatus" value="CONFIRMED"/>confirmed <input type="radio" name="eventStatus" value="TENTATIVE" checked="checked"/>tentative <input type="radio" name="eventStatus" value="CANCELLED"/>cancelled
              </xsl:when>
              <xsl:when test="form/status = 'CANCELLED'">
                <input type="radio" name="eventStatus" value="CONFIRMED"/>confirmed <input type="radio" name="eventStatus" value="TENTATIVE"/>tentative <input type="radio" name="eventStatus" value="CANCELLED" checked="checked"/>cancelled
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="eventStatus" value="CONFIRMED" checked="checked"/>confirmed <input type="radio" name="eventStatus" value="TENTATIVE"/>tentative <input type="radio" name="eventStatus" value="CANCELLED"/>cancelled
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Transparency  -->
        <tr>
          <td class="fieldName">
            Effects free/busy:
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="OPAQUE" name="transparency">
              <xsl:if test="form/transparency = 'OPAQUE'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            yes (opaque)

            <input type="radio" value="TRANSPARENT" name="transparency">
              <xsl:if test="form/transparency = 'TRANSPARENT'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            no (transparent)
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
            Cost:
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
            Event URL:
          </td>
          <td>
            <xsl:copy-of select="form/link/*"/>
            <xsl:text> </xsl:text>
            <span class="fieldInfo">(optional: for more information about the event)</span>
          </td>
        </tr>
        <!-- Image Url -->
        <tr>
          <td class="optional">
            Image URL:
          </td>
          <td>
            <input type="text" name="xBwImageHolder" value="" class="edit" size="30">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:attribute>
            </input>
            <xsl:text> </xsl:text>
            <span class="fieldInfo">(optional: to include an image with the event description)</span>
          </td>
        </tr>
        <!-- Location -->
        <tr>
          <td class="fieldName">
            Location:
          </td>
          <td>
            <xsl:if test="form/location/preferred/select/option">
              <select name="prefLocationId" id="bwPreferredLocationList">
                <option value="">
                  Select:
                </option>
                <xsl:copy-of select="form/location/preferred/select/*"/>
              </select>
            </xsl:if>
            <select name="allLocationId" id="bwAllLocationList">
              <xsl:if test="form/location/preferred/select/option">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <option value="">
                Select:
              </option>
              <xsl:copy-of select="form/location/all/select/*"/>
            </select>
            <xsl:text> </xsl:text>
            <!-- allow for toggling between the preferred and all location listings if preferred
                 locations exist -->
            <xsl:if test="form/location/preferred/select/option">
              <input type="radio" name="toggleLocationLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredLocationList','shown');changeClass('bwAllLocationList','invisible');"/>
              preferred
              <input type="radio" name="toggleLocationLists" value="all" onclick="changeClass('bwPreferredLocationList','invisible');changeClass('bwAllLocationList','shown');"/>
              all
            </xsl:if>
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
            Contact:
          </td>
          <td>
            <xsl:if test="form/contact/preferred/select/option">
              <select name="prefContactId" id="bwPreferredContactList">
                <option value="">
                  Select:
                </option>option>
                <xsl:copy-of select="form/contact/preferred/select/*"/>
              </select>
            </xsl:if>
            <select name="allContactId" id="bwAllContactList">
              <xsl:if test="form/contact/preferred/select/option">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <option value="">
                Select:
              </option>
              <xsl:copy-of select="form/contact/all/select/*"/>
            </select>
            <xsl:text> </xsl:text>
            <!-- allow for toggling between the preferred and all contacts listings if preferred
                 contacts exist -->
            <xsl:if test="form/contact/preferred/select/option">
              <input type="radio" name="toggleContactLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredContactList','shown');changeClass('bwAllContactList','invisible');"/>
              preferred
              <input type="radio" name="toggleContactLists" value="all" onclick="changeClass('bwPreferredContactList','invisible');changeClass('bwAllContactList','shown');"/>
              all
            </xsl:if>
          </td>
        </tr>

        <!-- Topical area  -->
        <!-- These are the subscriptions (aliases) where the events should show up.
             By selecting one or more of these, appropriate categories will be set on the event -->
        <tr>
          <td class="fieldName">
            Topical area:
          </td>
          <td>
            <ul class="aliasTree">
              <xsl:apply-templates select="form/subscriptions/calsuite/calendars/calendar" mode="showEventFormAliases">
                <xsl:with-param name="root">true</xsl:with-param>
              </xsl:apply-templates>
            </ul>
          </td>
        </tr>

        <!--  Category  -->
        <!--
          categories will no longer be directly set by the user; they are set
          by the back-end based on the subscriptions in the calendar suite.
          A user, therefore, tells the system where they want the event to
          show up, and the categories are set for them. -->
        <!--
        <tr>
          <td class="fieldName">
            Categories:
          </td>
          <td>
            <xsl:if test="form/categories/preferred/category and /bedework/creating='true'">
              <input type="radio" name="categoryCheckboxes" value="preferred" checked="checked" onclick="changeClass('preferredCategoryCheckboxes','shown');changeClass('allCategoryCheckboxes','invisible');"/>preferred
              <input type="radio" name="categoryCheckboxes" value="all" onclick="changeClass('preferredCategoryCheckboxes','invisible');changeClass('allCategoryCheckboxes','shown')"/>all<br/>
              <table cellpadding="0" id="preferredCategoryCheckboxes">
                <tr>
                  <xsl:variable name="catCount" select="count(form/categories/preferred/category)"/>
                  <td>
                    <xsl:for-each select="form/categories/preferred/category[position() &lt;= ceiling($catCount div 2)]">
                      <xsl:sort select="keyword" order="ascending"/>
                      <input type="checkbox" name="categoryKey">
                        <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="id">pref-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="keyword"/>','all-<xsl:value-of select="keyword"/>')</xsl:attribute>
                        <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                        <xsl:value-of select="keyword"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                  <td>
                    <xsl:for-each select="form/categories/preferred/category[position() &gt; ceiling($catCount div 2)]">
                      <xsl:sort select="keyword" order="ascending"/>
                      <input type="checkbox" name="categoryKey">
                        <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="id">pref-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="keyword"/>','all-<xsl:value-of select="keyword"/>')</xsl:attribute>
                        <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                        <xsl:value-of select="keyword"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                </tr>
              </table>
            </xsl:if>
            <table cellpadding="0" id="allCategoryCheckboxes">
              <xsl:if test="form/categories/preferred/category and /bedework/creating='true'">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <tr>
                <xsl:variable name="catCount" select="count(form/categories/all/category)"/>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="/bedework/creating='true'">
                        <xsl:attribute name="id">all-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="keyword"/>','pref-<xsl:value-of select="keyword"/>')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="keyword = ../../current//category/keyword">
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
                      <xsl:if test="/bedework/creating='true'">
                        <xsl:attribute name="id">all-<xsl:value-of select="keyword"/></xsl:attribute>
                        <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="keyword"/>','pref-<xsl:value-of select="keyword"/>')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="keyword = ../../current//category/keyword">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="keyword"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
              </tr>
            </table>
          </td>
        </tr> -->
        <!-- note -->
        <!-- let's shut this off for now - needs rewriting if we keep it at all
        <tr>
          <td colspan="2" style="padding-top: 1em;">
            <span class="fieldInfo">
              <strong>If "preferred values" are enabled</strong>
              by your administrator, the calendar, category, location, and contact lists will
              contain only those value you've used previously.  If you don't find the value
              you need in one of these lists, use the "all" list adjacent to each
              of these fields.  The event you select from the "all" list will be added
              to your preferred list from that point on.  <strong>Note: if you don't
              find a location or contact at all, you can add a new one from the
              <a href="{$setup}">main menu</a>.</strong>
              Only administrators can create calendars, however.
              To make sure you've used the
              correct calendar, please see the
              <a href="" target="_blank">Calendar Definitions</a>
            </span>
          </td>
        </tr> -->

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
      <xsl:if test="not(starts-with(form/calendar/path,$submissionsRootUnencoded))">
        <!-- don't create two instances of the submit buttons on pending events;
             the publishing buttons require numerous unique ids -->
        <xsl:call-template name="submitEventButtons"/>
      </xsl:if>
    </form>
  </xsl:template>

  <xsl:template match="calendar" mode="showEventFormAliases">
    <xsl:param name="root">false</xsl:param>
    <li>
      <xsl:if test="$root != 'true'">
        <!-- hide the root calendar. -->
        <xsl:choose>
          <xsl:when test="calType = '0'">
            <!-- no direct selecting of folders or folder aliases: we only want users to select the
                 underlying calendar aliases -->
            <!--img src="{$resourcesRoot}/resources/catIcon.gif" width="13" height="13" alt="folder" class="folderForAliasTree" border="0"/-->
            <input type="checkbox" name="forDiplayOnly" disabled="disabled"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="checkbox" name="alias">
              <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
              <xsl:if test="path = /bedework/formElements/form/xproperties//X-BEDEWORK-ALIAS/values/text"><xsl:attribute name="checked"><xsl:value-of select="checked"/></xsl:attribute></xsl:if>
            </input>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="name"/>
      </xsl:if>

      <xsl:if test="calendar[isSubscription = 'true' or calType = '0']">
        <ul>
          <xsl:apply-templates select="calendar[isSubscription = 'true' or calType = '0']" mode="showEventFormAliases"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="submitEventButtons">
    <table border="0" id="submitTable">
      <tr>
        <xsl:choose>
          <xsl:when test="starts-with(form/calendar/path,$submissionsRootUnencoded)">
            <td>
              <div id="publishBox" class="invisible">
                <div id="publishBoxCloseButton">
                  <a href="javascript:resetPublishBox('calendarId')">
                    <img src="{$resourcesRoot}/resources/closeIcon.gif" width="20" height="20" alt="close" border="0"/>
                  </a>
                </div>
                <strong>Select a calendar in which to publish this event:</strong><br/>
                <select name="calendarId" id="calendarId">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                    Select:
                  </option>
                  <xsl:for-each select="form/calendar/all/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          submitted events
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
                <input type="submit" name="publishEvent" value="Publish" onclick="changeClass('publishBox','invisible')"/>
                <xsl:if test="$portalFriendly = 'false'">
                  <br/>
                  <span id="calDescriptionsLink">
                    <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')">calendar descriptions</a>
                  </span>
                </xsl:if>
              </div>
              <input type="submit" name="updateSubmitEvent" value="Update Event"/>
              <input type="button" name="publishEvent" value="Publish Event" onclick="changeClass('publishBox','visible')"/>
              <input type="submit" name="cancel" value="Cancel"/>
            </td>
            <td align="right">
              <input type="submit" name="delete" value="Delete Event"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="/bedework/creating='true'">
                <td>
                  <input type="submit" name="addEvent" value="Add Event"/>
                  <input type="submit" name="cancelled" value="Cancel"/>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <input type="submit" name="updateEvent" value="Update Event"/>
                  <input type="submit" name="cancelled" value="Cancel"/>
                  <xsl:if test="form/recurringEntity != 'true' and recurrenceId = ''">
                    <!-- cannot duplicate recurring events for now -->
                    <input type="submit" name="copy" value="Copy Event"/>
                  </xsl:if>
                </td>
                <td align="right">
                  <input type="submit" name="delete" value="Delete Event"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </table>
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
      <xsl:variable name="hour24" select="/bedework/hour24"/><!-- true or false -->
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
        <area shape="poly" alt="11 PM, 2300 hour" title="11 PM, 2300 hour" coords="150,102, 172,96, 158,1, 114,14" href="javascript:bwClockUpdateDateTimeForm('hour','23',{$hour24})" />
        <area shape="poly" alt="10 PM, 2200 hour" title="10 PM, 2200 hour" coords="131,114, 150,102, 114,14, 74,36" href="javascript:bwClockUpdateDateTimeForm('hour','22',{$hour24})" />
        <area shape="poly" alt="9 PM, 2100 hour" title="9 PM, 2100 hour" coords="111,132, 131,114, 74,36, 40,69" href="javascript:bwClockUpdateDateTimeForm('hour','21',{$hour24})" />
        <area shape="poly" alt="8 PM, 2000 hour" title="8 PM, 2000 hour" coords="101,149, 111,132, 40,69, 15,113" href="javascript:bwClockUpdateDateTimeForm('hour','20',{$hour24})" />
        <area shape="poly" alt="7 PM, 1900 hour" title="7 PM, 1900 hour" coords="95,170, 101,149, 15,113, 1,159" href="javascript:bwClockUpdateDateTimeForm('hour','19',{$hour24})" />
        <area shape="poly" alt="6 PM, 1800 hour" title="6 PM, 1800 hour" coords="95,196, 95,170, 0,159, 0,204" href="javascript:bwClockUpdateDateTimeForm('hour','18',{$hour24})" />
        <area shape="poly" alt="5 PM, 1700 hour" title="5 PM, 1700 hour" coords="103,225, 95,196, 1,205, 16,256" href="javascript:bwClockUpdateDateTimeForm('hour','17',{$hour24})" />
        <area shape="poly" alt="4 PM, 1600 hour" title="4 PM, 1600 hour" coords="116,245, 103,225, 16,256, 41,298" href="javascript:bwClockUpdateDateTimeForm('hour','16',{$hour24})" />
        <area shape="poly" alt="3 PM, 1500 hour" title="3 PM, 1500 hour" coords="134,259, 117,245, 41,298, 76,332" href="javascript:bwClockUpdateDateTimeForm('hour','15',{$hour24})" />
        <area shape="poly" alt="2 PM, 1400 hour" title="2 PM, 1400 hour" coords="150,268, 134,259, 76,333, 121,355" href="javascript:bwClockUpdateDateTimeForm('hour','14',{$hour24})" />
        <area shape="poly" alt="1 PM, 1300 hour" title="1 PM, 1300 hour" coords="169,273, 150,268, 120,356, 165,365" href="javascript:bwClockUpdateDateTimeForm('hour','13',{$hour24})" />
        <area shape="poly" alt="Noon, 1200 hour" title="Noon, 1200 hour" coords="193,273, 169,273, 165,365, 210,364" href="javascript:bwClockUpdateDateTimeForm('hour','12',{$hour24})" />
        <area shape="poly" alt="11 AM, 1100 hour" title="11 AM, 1100 hour" coords="214,270, 193,273, 210,363, 252,352" href="javascript:bwClockUpdateDateTimeForm('hour','11',{$hour24})" />
        <area shape="poly" alt="10 AM, 1000 hour" title="10 AM, 1000 hour" coords="232,259, 214,270, 252,352, 291,330" href="javascript:bwClockUpdateDateTimeForm('hour','10',{$hour24})" />
        <area shape="poly" alt="9 AM, 0900 hour" title="9 AM, 0900 hour" coords="251,240, 232,258, 291,330, 323,301" href="javascript:bwClockUpdateDateTimeForm('hour','9',{$hour24})" />
        <area shape="poly" alt="8 AM, 0800 hour" title="8 AM, 0800 hour" coords="263,219, 251,239, 323,301, 349,261" href="javascript:bwClockUpdateDateTimeForm('hour','8',{$hour24})" />
        <area shape="poly" alt="7 AM, 0700 hour" title="7 AM, 0700 hour" coords="269,194, 263,219, 349,261, 363,212" href="javascript:bwClockUpdateDateTimeForm('hour','7',{$hour24})" />
        <area shape="poly" alt="6 AM, 0600 hour" title="6 AM, 0600 hour" coords="269,172, 269,193, 363,212, 363,155" href="javascript:bwClockUpdateDateTimeForm('hour','6',{$hour24})" />
        <area shape="poly" alt="5 AM, 0500 hour" title="5 AM, 0500 hour" coords="263,150, 269,172, 363,155, 351,109" href="javascript:bwClockUpdateDateTimeForm('hour','5',{$hour24})" />
        <area shape="poly" alt="4 AM, 0400 hour" title="4 AM, 0400 hour" coords="251,130, 263,150, 351,109, 325,68" href="javascript:bwClockUpdateDateTimeForm('hour','4',{$hour24})" />
        <area shape="poly" alt="3 AM, 0300 hour" title="3 AM, 0300 hour" coords="234,112, 251,130, 325,67, 295,37" href="javascript:bwClockUpdateDateTimeForm('hour','3',{$hour24})" />
        <area shape="poly" alt="2 AM, 0200 hour" title="2 AM, 0200 hour" coords="221,102, 234,112, 295,37, 247,11" href="javascript:bwClockUpdateDateTimeForm('hour','2',{$hour24})" />
        <area shape="poly" alt="1 AM, 0100 hour" title="1 AM, 0100 hour" coords="196,96, 221,102, 247,10, 209,-1, 201,61, 206,64, 205,74, 199,75" href="javascript:bwClockUpdateDateTimeForm('hour','1',{$hour24})" />
        <area shape="poly" alt="Midnight, 0000 hour" title="Midnight, 0000 hour" coords="172,96, 169,74, 161,73, 161,65, 168,63, 158,-1, 209,-1, 201,61, 200,62, 206,64, 205,74, 198,75, 196,96, 183,95" href="javascript:bwClockUpdateDateTimeForm('hour','0',{$hour24})" />
      </map>
    </div>
  </xsl:template>

 <xsl:template match="event" mode="displayEvent">
    <xsl:variable name="calPath" select="calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>

    <xsl:choose>
      <xsl:when test="/bedework/page='deleteEventConfirm' or /bedework/page='deleteEventConfirmPending'">
        <h2>Ok to delete this event?</h2>
        <p style="width: 400px;">Note: we do not encourage deletion of old but correct events; we prefer to keep
           old events for historical reasons.  Please remove only those events
           that are truly erroneous.</p>
        <p id="confirmButtons">
          <form method="post">
            <xsl:choose>
              <xsl:when test="/bedework/page = 'deleteEventConfirmPending'">
                <xsl:attribute name="action"><xsl:value-of select="$event-deletePending"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="action"><xsl:value-of select="$event-delete"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
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
          <xsl:variable name="contactLink" select="link"/>
          <a href="mailto:{$contactLink}"><xsl:value-of select="contact/link"/></a>
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

      <!-- Submitter -->
      <xsl:if test="xproperties/X-BEDEWORK-SUBMITTEDBY">
        <tr>
          <th>
            Submitter:
          </th>
          <td>
            <strong><xsl:value-of select="xproperties/X-BEDEWORK-SUBMITTEDBY/values/text"/></strong>
          </td>
        </tr>
      </xsl:if>

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
      <xsl:if test="/bedework/canEdit = 'true' or /bedework/userInfo/superUser = 'true'">
        <input type="button" name="return" value="Edit event" onclick="javascript:location.replace('{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')"/>
      </xsl:if>

      <input type="button" name="return" value="Back" onclick="javascript:history.back()"/>
    </p>
  </xsl:template>

  <!--+++++++++++++++ Contacts ++++++++++++++++++++-->
  <xsl:template name="contactList">
    <h2>Manage Contacts</h2>
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

      <xsl:for-each select="/bedework/contacts/contact">
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
            <xsl:copy-of select="/bedework/formElements/form/name/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Contact Phone Number:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/phone/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/link/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Contact Email Address:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/email/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedework/creating='true'">
              <td>
                <input type="submit" name="addContact" value="Add Contact"/>
                <input type="submit" name="cancelled" value="Cancel"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateContact" value="Update Contact"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <th>Name</th>
        <td>
          <xsl:value-of select="/bedework/contact/name" />
        </td>
      </tr>
      <tr>
        <th>Phone</th>
        <td>
          <xsl:value-of select="/bedework/contact/phone" />
        </td>
      </tr>
      <tr>
        <th>Email</th>
        <td>
          <xsl:value-of select="/bedework/contact/email" />
        </td>
      </tr>
      <tr>
        <th>URL</th>
        <td>
          <xsl:value-of select="/bedework/contact/link" />
        </td>
      </tr>
    </table>
  </xsl:template>

   <!--+++++++++++++++ Locations ++++++++++++++++++++-->
  <xsl:template name="locationList">
    <h2>Manage Locations</h2>
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

      <xsl:for-each select="/bedework/locations/location">
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
      <xsl:when test="/bedework/creating='true'">
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
            <xsl:copy-of select="/bedework/formElements/form/address/*"/>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Subaddress:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/subaddress/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Location's URL:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/link/*"/>
            <span class="fieldInfo"> (optional)</span>
          </td>
        </tr>
      </table>

      <table border="0" id="submitTable">
        <tr>
          <xsl:choose>
            <xsl:when test="/bedework/creating='true'">
              <td>
                <input type="submit" name="addLocation" value="Add Location"/>
                <input type="submit" name="cancelled" value="Cancel"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <input type="submit" name="updateLocation" value="Update Location"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            Address:
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr>
        <td class="optional">
            Subaddress:
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr>
        <td class="optional">
            Location's URL:
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--+++++++++++++++ Categories ++++++++++++++++++++-->
  <xsl:template name="categoryList">
    <h2>Manage Categories</h2>
    <p>
      Select the category you would like to update:
      <input type="button" name="return" value="Add new category" onclick="javascript:location.replace('{$category-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th>Keyword</th>
        <th>Description</th>
      </tr>

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
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
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
                <textarea name="categoryDesc.value" rows="3" cols="60"></textarea>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="addCategory" value="Add Category"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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
                <xsl:variable name="keyword" select="normalize-space(/bedework/currentCategory/category/keyword)"/>
                <input type="text" name="categoryWord.value" value="{$keyword}" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="optional">
            Description:
            </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedework/currentCategory/category/desc)"/>
                </textarea>
              </td>
            </tr>
          </table>

          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="updateCategory" value="Update Category"/>
                <input type="submit" name="cancelled" value="Cancel"/>
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
          <xsl:value-of select="/bedework/currentCategory/category/keyword"/>
        </td>
      </tr>
      <tr>
        <td class="optional">
          Description:
        </td>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="updateCategory" value="Yes: Delete Category"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

<!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars" mode="calendarCommon">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Public calendars</h3>
          <ul class="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedework/page='calendarDescriptions' or /bedework/page='displayCalendar'">
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
            <xsl:when test="/bedework/page='calendarList' or /bedework/page='calendarReferenced'">
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
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseMod}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/resources/minus.gif" width="9" height="9" alt="close" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseMod}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/resources/plus.gif" width="9" height="9" alt="open" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}" title="update">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calType = '0' and isSubscription = 'false'">
        <xsl:text> </xsl:text>
        <a href="{$calendar-initAdd}&amp;calPath={$calPath}" title="add a calendar or folder">
          <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="add a calendar or folder" border="0"/>
        </a>
      </xsl:if>
      <xsl:if test="calendar and isSubscription='false'">
        <ul>
          <xsl:apply-templates select="calendar" mode="listForUpdate">
            <xsl:sort select="name" order="ascending" case-order="upper-first"/>
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
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseDisplay}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/resources/minus.gif" width="9" height="9" alt="close" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseDisplay}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/resources/plus.gif" width="9" height="9" alt="open" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
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

  <xsl:template match="calendar" mode="listForMove">
    <xsl:variable name="calPath" select="encodedPath"/>
    <xsl:if test="calType = '0'">
      <li class="folder">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseMove}&amp;newCalPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/resources/minus.gif" width="9" height="9" alt="close" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseMove}&amp;newCalPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/resources/plus.gif" width="9" height="9" alt="open" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <a href="{$calendar-update}&amp;newCalPath={$calPath}" title="update">
          <xsl:value-of select="name"/>
        </a>
        <xsl:if test="calendar">
          <ul>
            <xsl:apply-templates select="calendar" mode="listForMove"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3>Add Calendar, Folder, or Subscription</h3>
    <form name="addCalForm" method="post" action="{$calendar-update}" onsubmit="setCalendarAlias(this)">
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
            <textarea name="calendar.description" cols="30" rows="4">
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
          <th>Color:</th>
          <td>
            <select name="calendar.color">
              <option value="">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="@rgb"/>
                <xsl:variable name="subColorClass" select="."/>
                <option value="{$subColor}" class="{$subColorClass}">
                  <xsl:value-of select="@name"/>
                </option>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <th>Filter Expression:</th>
          <td>
            <input type="text" name="fexpr" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>Categories:</th>
          <td>
            <a href="javascript:toggleVisibility('calCategories','visible')">
              show/hide categories
            </a>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="keyword" order="ascending"/>
                  <li>
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                    </input>
                    <xsl:value-of select="keyword"/>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th>Type:</th>
          <td>
            <!-- we will set the value of "calendarCollection on submit.
                 Value is false only for folders, so we default it to true here.  -->
            <input type="hidden" value="true" name="calendarCollection"/>
            <!-- type is defaulted to calendar.  It is changed when a typeSwitch is clicked. -->
            <input type="hidden" value="calendar" name="type" id="bwCalType"/>
            <input type="radio" value="calendar" name="typeSwitch" checked="checked" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Calendar
            <input type="radio" value="folder" name="typeSwitch" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Folder
            <input type="radio" value="subscription" name="typeSwitch" onclick="changeClass('subscriptionTypes','visible');setField('bwCalType',this.value);"/> Subscription
          </td>
        </tr>
      </table>
      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="Add"/>
        <input type="submit" name="cancelled" value="cancel"/>
      </div>
      <div id="subscriptionTypes" class="invisible">
        <h4>Subscription URL</h4>
        <div id="subscriptionTypeExternal">
          <table class="common" id="subscriptionTypes">
            <tr>
              <th>URL to calendar:</th>
              <td>
                <input type="text" name="aliasUri" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th>ID (if required):</th>
              <td>
                <input type="text" name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th>Password (if required):</th>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
          </table>
          <p>
            Note: An alias can be added to a Bedework calendar using a URL of the form:<br/>
            bwcal://[path], e.g. bwcal:///public/Arts
          </p>
        </div>
      </div>

      <div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="Add"/>
        <input type="submit" name="cancelled" value="cancel"/>
      </div>
    </form>

    <!-- div id="sharingBox">
      <h3>Current Access:</h3>
      Sharing may be added to a calendar once created.
    </div-->
  </xsl:template>

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:variable name="calPath" select="path"/>
    <xsl:variable name="calPathEncoded" select="encodedPath"/>

    <form name="modCalForm" method="post">
      <xsl:attribute name="action">
        <xsl:choose>
          <xsl:when test="/bedework/page = 'modSubscription'">
             <xsl:value-of select="$subscriptions-update"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:value-of select="$calendar-update"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="isSubscription='true'">
          <h3>Modify Subscription</h3>
          <input type="hidden" value="true" name="calendarCollection"/>
        </xsl:when>
        <xsl:when test="calType = '0'">
          <h3>Modify Folder</h3>
          <input type="hidden" value="false" name="calendarCollection"/>
        </xsl:when>
        <xsl:otherwise>
          <h3>Modify Calendar</h3>
          <input type="hidden" value="true" name="calendarCollection"/>
        </xsl:otherwise>
      </xsl:choose>
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
        <!-- tr>
          <th>Mailing List ID:</th>
          <td>
            <xsl:value-of select="mailListId"/>
          </td>
        </tr -->
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
          <th>Color:</th>
          <td>
            <input type="text" name="calendar.color" value="" size="40">
              <xsl:attribute name="value"><xsl:value-of select="color"/></xsl:attribute>
            </input>
          </td>
        </tr>
        <tr>
          <th>Filter Expression:</th>
          <td>
            <input type="text" name="fexpr" size="40">
              <xsl:attribute name="value"><xsl:value-of select="filterExpr"/></xsl:attribute>
            </input>
          </td>
        </tr>
        <tr>
          <th>Categories:</th>
          <td>
            <!-- show the selected categories -->
            <ul class="catlist">
              <xsl:for-each select="/bedework/categories/current/category">
                <xsl:sort select="keyword" order="ascending"/>
                <li>
                  <input type="checkbox" name="categoryKey" checked="checked">
                    <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                  </input>
                  <xsl:value-of select="keyword"/>
                </li>
              </xsl:for-each>
            </ul>
            <a href="javascript:toggleVisibility('calCategories','visible')">
              show/hide unused categories
            </a>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="keyword" order="ascending"/>
                  <!-- don't duplicate the selected categories -->
                  <xsl:if test="not(keyword = ../../current//category/keyword)">
                    <li>
                      <input type="checkbox" name="categoryKey">
                        <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      </input>
                      <xsl:value-of select="keyword"/>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <xsl:if test="isSubscription = 'true'">
          <tr>
            <th>URL:</th>
            <td>
              <input name="aliasUri" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="aliasUri"/></xsl:attribute>
              </input>
            </td>
          </tr>
          <xsl:if test="externalSub = 'true'">
            <tr>
              <th>Id (if required):</th>
              <td>
                <input name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th>Password (if required):</th>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
      </table>

      <div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="isSubscription='true'">
                <input type="submit" name="updateCalendar" value="Update Subscription"/>
              </xsl:when>
              <xsl:when test="calType = '0'">
                <input type="submit" name="updateCalendar" value="Update Folder"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateCalendar" value="Update Calendar"/>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="cancelled" value="cancel"/>
          </td>
          <td align="right">
            <xsl:choose>
              <xsl:when test="isSubscription='true'">
                <input type="submit" name="delete" value="Remove Subscription"/>
              </xsl:when>
              <xsl:when test="calType = '0'">
                <input type="submit" name="delete" value="Delete Folder"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="delete" value="Delete Calendar"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </form>
    <!-- div id="sharingBox">
      <xsl:apply-templates select="acl" mode="currentAccess">
        <xsl:with-param name="action" select="$calendar-setAccess"/>
        <xsl:with-param name="calPathEncoded" select="$calPathEncoded"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" method="post" action="{$calendar-setAccess}" id="shareForm" onsubmit="setAccessHow(this)">
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
    </div-->
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
      <xsl:when test="isSubscription = 'true'">
        <h3>Remove Subscription</h3>
        <p>
          The following subscription will be removed.
          Continue?
        </p>
      </xsl:when>
      <xsl:when test="calType = '0'">
        <h3>Delete Folder</h3>
        <p>
          The following folder <em>and all its contents</em> will be deleted.
          Continue?
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3>Delete Calendar</h3>
        <p>
          The following calendar will be deleted.  Continue?
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" action="{$calendar-delete}" method="post">
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
              <xsl:when test="isSubscription = 'true'">
                <input type="submit" name="delete" value="Yes: Remove Subscription!"/>
              </xsl:when>
              <xsl:when test="calType = '0'">
                <input type="submit" name="delete" value="Yes: Delete Folder!"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="delete" value="Yes: Delete Calendar!"/>
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
      <!--<form name="toggleCals" action="{$event-selectCalForEvent}" method="post">
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
      <ul class="calendarTree">
        <xsl:apply-templates select="/bedework/calendars/calendar" mode="selectCalForEventCalTree"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForEventCalTree">
    <xsl:variable name="calPath" select="path"/><!-- not the encodedPath when put in a form - otherwise it gets double encoded -->
      <xsl:variable name="calDisplay" select="path"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calType = '0'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseSelect}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/resources/minus.gif" width="9" height="9" alt="close" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseSelect}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/resources/plus.gif" width="9" height="9" alt="open" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="currentAccess/current-user-privilege-set/privilege/write-content and (calType != '0')">
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

  <xsl:template name="calendarMove">
    <table id="calendarTable">
      <tr>
        <td class="calendarContent">
          <h3>Move Calendar/Folder</h3>

          <table class="eventFormTable">
            <tr>
              <th>Current Path:</th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/path"/>
              </td>
            </tr>
            <tr>
              <th>Name:</th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/name"/>
              </td>
            </tr>
            <tr>
              <th>Mailing List ID:</th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/mailListId"/>
              </td>
            </tr>
            <tr>
              <th>Summary:</th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/summary"/>
              </td>
            </tr>
            <tr>
              <th>Description:</th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/desc"/>
              </td>
            </tr>
          </table>
        </td>
        <td class="bwCalsForMove">
          <p>Select a new parent folder:</p>
          <ul class="calendarTree">
            <xsl:apply-templates select="/bedework/calendars/calendar" mode="listForMove"/>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--==== ACCESS CONTROL TEMPLATES ====-->

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
    <input type="submit" name="cancelled" value="cancel"/>
  </xsl:template>

  <xsl:template match="acl" mode="currentAccess">
    <xsl:param name="action"/> <!-- required -->
    <xsl:param name="calPathEncoded"/> <!-- optional (for entities) -->
    <xsl:param name="guid"/> <!-- optional (for entities) -->
    <xsl:param name="recurrenceId"/> <!-- optional (for entities) -->
    <xsl:param name="what"/> <!-- optional (for scheduling only) -->
    <xsl:param name="calSuiteName"/> <!-- optional (for calendar suites only) -->
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
            <xsl:when test="$who='unauthenticated'">unauth</xsl:when>
            <xsl:when test="$who='all'">all</xsl:when>
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
                <xsl:for-each select="grant/privilege/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span><br/>
            </xsl:if>
            <xsl:if test="deny">
              deny:
              <span class="deny">
                <xsl:for-each select="deny/privilege/*">
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
              <a href="{$action}&amp;how=default&amp;what={$what}&amp;who={$shortWho}&amp;whoType={$whoType}&amp;calPath={$calPathEncoded}&amp;calSuiteName={$calSuiteName}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="reset to default">
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="reset to default"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--+++++++++++++++ Subscriptions ++++++++++++++++++++-->
  <!--
    Calendar and subscription templates depend heavily on calendar types:

    calTypes: 0 - Folder
              1 - Calendar
              2 - Trash
              3 - Deleted
              4 - Busy
              5 - Inbox
              6 - Outbox
              7 - Alias (internal - the underlying calType will be returned; check for the isSubscription property)
              8 - External subscription (internal - the underlying calType will be returned; check for the isSubscription property and check on the item's status)
              9 - Resource collection
  -->

  <xsl:template match="calendars" mode="subscriptions">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3>Subscription Tree</h3>
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar" mode="listForUpdateSubscription">
              <xsl:with-param name="root">true</xsl:with-param>
            </xsl:apply-templates>
          </ul>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedework/page='subscriptions'">
              <xsl:call-template name="subscriptionIntro"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="addSubscription"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/currentCalendar" mode="modCalendar"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="subscriptionIntro">
    <h3>Managing Subscriptions</h3>
    <ul>
      <li>Select an item from the tree on the left to modify a subscription.</li>
      <li>Select the
      <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="true" border="0"/>
      icon to add a new subscription to the tree.
      </li>
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdateSubscription">
    <xsl:param name="root">false</xsl:param>
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0' and isSubscription='false'">
         <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$subscriptions-openCloseMod}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/resources/minus.gif" width="9" height="9" alt="close" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$subscriptions-openCloseMod}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/resources/plus.gif" width="9" height="9" alt="open" border="0" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$root = 'true'">
          <!-- treat the root calendar as the root of calendar suite; don't allow edits -->
          <xsl:value-of select="/bedework/currentCalSuite/name"/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$subscriptions-fetchForUpdate}&amp;calPath={$calPath}" title="update">
            <xsl:value-of select="name"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calType = '0' and isSubscription='false'">
        <xsl:text> </xsl:text>
        <a href="{$subscriptions-initAdd}&amp;calPath={$calPath}" title="add a subscription">
          <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="add a subscription" border="0"/>
        </a>
      </xsl:if>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar[isSubscription = 'true' or calType = '0']" mode="listForUpdateSubscription"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addSubscription">
    <h3>Add Subscription</h3>
    <form name="addCalForm" method="post" action="{$subscriptions-update}" onsubmit="return setCalendarAlias(this)">
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
            <textarea name="calendar.description" cols="30" rows="4">
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
          <th>Color:</th>
          <td>
            <select name="calendar.color">
              <option value="">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="@rgb"/>
                <xsl:variable name="subColorClass" select="."/>
                <option value="{$subColor}" class="{$subColorClass}">
                  <xsl:value-of select="@name"/>
                </option>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <th>Filter Expression:</th>
          <td>
            <input type="text" name="fexpr" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>Categories:</th>
          <td>
            <a href="javascript:toggleVisibility('calCategories','visible')">
              show/hide categories
            </a>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="keyword" order="ascending"/>
                  <li>
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                    </input>
                    <xsl:value-of select="keyword"/>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th>Type:</th>
          <td>
            <!-- we will set the value of "calendarCollection" on submit.
                 Value is false only for folders, so we default it to true here. -->
            <input type="hidden" value="true" name="calendarCollection"/>

            <!-- type is defaulted to "subscription".  It is changed to "folder"
                 if subTypeSwitch is set to folder. -->
            <input type="hidden"  name="type" value="subscription" id="bwType"/>
            <input type="hidden" name="aliasUri" value=""/>

            <!-- subType is defaulted to public.  It is changed when a subTypeSwitch is clicked. -->
            <input type="hidden" value="public" name="subType" id="bwSubType"/>
            <input type="radio" name="subTypeSwitch" value="folder" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','invisible');setField('bwType',this.value);"/> Folder
            <input type="radio" name="subTypeSwitch" value="public" checked="checked" onclick="changeClass('subscriptionTypePublic','visible');changeClass('subscriptionTypeExternal','invisible');setField('bwSubType',this.value);"/> Public alias
            <input type="radio" name="subTypeSwitch" value="external" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','visible');setField('bwSubType',this.value);"/> URL

              <div id="subscriptionTypePublic">
                <input type="hidden" value="" name="publicAliasHolder" id="publicAliasHolder"/>
                <div id="bwPublicCalDisplay">
                  Select the public calendar or folder:
                </div>
                <ul id="publicSubscriptionTree" class="calendarTree">
                  <xsl:apply-templates select="/bedework/publicCalendars/calendar" mode="selectCalForPublicAliasCalTree"/>
                </ul>
              </div>

              <div class="invisible" id="subscriptionTypeExternal">
                <table class="common">
                  <tr>
                    <th>URL to calendar:</th>
                    <td>
                      <input type="text" name="aliasUriHolder" id="aliasUriHolder" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th>ID (if required):</th>
                    <td>
                      <input type="text" name="remoteId" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th>Password (if required):</th>
                    <td>
                      <input type="password" name="remotePw" value="" size="40"/>
                    </td>
                  </tr>
                </table>
              </div>

          </td>
        </tr>
      </table>

      <div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="Add"/>
        <input type="submit" name="cancelled" value="cancel"/>
      </div>
    </form>

  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForPublicAliasCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:variable name="calendarCollection" select="calendarCollection"/>
      <xsl:choose>
        <xsl:when test="canAlias = 'true'">
          <a href="javascript:updatePublicCalendarAlias('{$calPath}','{$calDisplay}','{$calendarCollection}')">
            <xsl:value-of select="name"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="selectCalForPublicAliasCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!--+++++++++++++++ Views ++++++++++++++++++++-->
  <xsl:template match="views" mode="viewList">
    <!-- fix this: /user/ should be parameterized not hard-coded here -->
    <xsl:variable name="userPath">/user/<xsl:value-of select="/bedework/userInfo/user"/>/</xsl:variable>

    <h2>Manage Views</h2>
    <p>
      Views are named aggregations of subscriptions used
      to display sets of events within a calendar suite.
    </p>

    <h4>Add a new view</h4>
    <form name="addView" action="{$view-addView}" method="post">
      <input type="text" name="name" size="60"/>
      <input type="submit" value="add view" name="addview"/>
    </form>

    <h4>Views</h4>
    <table id="commonListTable" class="viewsTable">
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
            <xsl:for-each select="path">
              <xsl:value-of select="substring-after(.,$userPath)"/>
              <xsl:if test="position()!=last()"><br/></xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modView">
    <xsl:variable name="viewName" select="/bedework/currentView/name"/>
    <!-- fix this: /user/ should be parameterized not hard-coded here -->
    <xsl:variable name="userPath">/user/<xsl:value-of select="/bedework/userInfo/user"/>/</xsl:variable>

    <h2>Update View</h2>

    <p class="note">
      Note: In some configurations, changes made here will not show up in the calendar suite until
      the cache is flushed (approx. 5 minutes) or you start a new session (e.g. clear your cookies).
      Deleting a view on a production system should be followed by a server restart to clear the cache for all users.
    </p>

    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
    <table id="viewsTable">
      <tr>
        <td class="subs">
          <h3>Available Subscriptions:</h3>

          <table class="subscriptionsListSubs">
            <xsl:for-each select="/bedework/calendars/calendar/calendar[isSubscription = 'true']">
              <xsl:sort select="name" order="ascending" case-order="upper-first"/>
              <xsl:if test="not(/bedework/currentView//path = path)">
                <tr>
                  <td>
                    <xsl:value-of select="summary"/>
                  </td>
                  <td class="arrows">
                    <xsl:variable name="subAddName" select="encodedPath"/>
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
            <xsl:for-each select="/bedework/currentView/path">
              <xsl:sort select="." order="ascending" case-order="upper-first"/>
              <tr>
                <td class="arrows">
                  <xsl:variable name="subRemoveName" select="."/>
                  <a href="{$view-update}&amp;name={$viewName}&amp;remove={$subRemoveName}">
                    <img src="{$resourcesRoot}/resources/arrowLeft.gif"
                        width="13" height="13" border="0"
                        alt="add subscription"/>
                  </a>
                </td>
                <td>
                  <xsl:value-of select="substring-after(.,$userPath)"/>
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

    <xsl:variable name="viewName" select="/bedework/views/view/name"/>
    <p>The following view will be removed. <em>Be forewarned: if caching is
    enabled, removing views from a
    production system can cause the public interface to throw errors until the
    cache is flushed (a few minutes).</em>
    </p>

    <p>Continue?</p>

    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
    <form name="removeView" action="{$view-remove}" method="post">
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
        <tr>
          <td class="fieldname padMeTop">
            Effects free/busy:
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" checked="checked"/> accept event's settings<br/>
            <input type="radio" value="OPAQUE" name="transparency"/> yes <span class="note">(opaque: event status affects free/busy)</span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency"/> no <span class="note">(transparent: event status does not affect free/busy)</span><br/>
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
            <input name="cancelled" type="submit" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--+++++++++++++++ System Parameters (preferences) ++++++++++++++++++++-->
  <xsl:template name="modSyspars">
    <h2>Manage System Preferences/Parameters</h2>
    <p>
      Do not change unless you know what you're doing.<br/>
      Changes to these parameters have wide impact on the system.
    </p>
    <form name="systemParamsForm" action="{$system-update}" method="post">
      <table class="eventFormTable params">
        <tr>
          <th>System name:</th>
          <td>
            <xsl:variable name="sysname" select="/bedework/system/name"/>
            <xsl:value-of select="$sysname"/>
            <div class="desc">
              Name for this system. Cannot be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Default timezone:</th>
          <td>
            <xsl:variable name="tzid" select="/bedework/system/tzid"/>

            <select name="tzid">
              <option value="-1">select timezone...</option>
              <xsl:for-each select="/bedework/timezones/timezone">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                  <xsl:if test="/bedework/system/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
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
          <th>Super Users:</th>
          <td>
            <xsl:variable name="rootUsers" select="/bedework/system/rootUsers"/>
            <input value="{$rootUsers}" name="rootUsers" class="wide"/>
            <div class="desc">
              Comma separated list of super users. No spaces.
            </div>
          </td>
        </tr>
        <!--<tr>
          <th>12 or 24 hour clock/time:</th>
          <td>
            <select name="">
              <option value="-1">select preference...</option>
              <option value="true">
                <xsl:if test="/bedework/system/NEEDPARAM = 'true'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                Use 24 hour clock/time
              </option>
              <option value="false">
                <xsl:if test="/bedework/system/NEEDPARAM = 'false'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                Use 12 Hour clock/time + am/pm
              </option>
            </select>
            <div class="desc">
              Affects the time fields when adding and editing events
            </div>
          </td>
        </tr>-->
        <tr>
          <th>System id:</th>
          <td>
            <xsl:variable name="systemid" select="/bedework/system/systemid"/>
            <xsl:value-of select="$systemid"/>
            <div class="desc">
              System id used when building uids and identifying users. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Public Calendar Root:</th>
          <td>
            <xsl:variable name="publicCalendarRoot" select="/bedework/system/publicCalendarRoot"/>
            <xsl:value-of select="$publicCalendarRoot"/>
            <div class="desc">
              Name for public calendars root directory. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Calendar Root:</th>
          <td>
            <xsl:variable name="userCalendarRoot" select="/bedework/system/userCalendarRoot"/>
            <xsl:value-of select="$userCalendarRoot"/>
            <div class="desc">
              Name for user calendars root directory. Should not be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Calendar Default name:</th>
          <td>
            <xsl:variable name="userDefaultCalendar" select="/bedework/system/userDefaultCalendar"/>
            <input value="{$userDefaultCalendar}" name="userDefaultCalendar" />
            <div class="desc">
              Default name for user calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Trash Calendar Default name:</th>
          <td>
            <xsl:variable name="defaultTrashCalendar" select="/bedework/system/defaultTrashCalendar"/>
            <input value="{$defaultTrashCalendar}" name="defaultTrashCalendar" />
            <div class="desc">
              Default name for user trash calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Inbox Default name:</th>
          <td>
            <xsl:variable name="userInbox" select="/bedework/system/userInbox"/>
            <input value="{$userInbox}" name="userInbox" />
            <div class="desc">
              Default name for user inbox. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Outbox Default name:</th>
          <td>
            <xsl:variable name="userOutbox" select="/bedework/system/userOutbox"/>
            <input value="{$userOutbox}" name="userOutbox" />
            <div class="desc">
              Default name for user outbox. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Deleted Calendar Default name:</th>
          <td>
            <xsl:variable name="deletedCalendar" select="/bedework/system/deletedCalendar"/>
            <input value="{$deletedCalendar}" name="deletedCalendar" />
            <div class="desc">
              Default name for user calendar used to hold deleted items. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>User Busy Calendar Default name:</th>
          <td>
            <xsl:variable name="busyCalendar" select="/bedework/system/busyCalendar"/>
            <input value="{$busyCalendar}" name="busyCalendar" />
            <div class="desc">
              Default name for user busy time calendar. Used when initialising user. Possibly can be changed.
            </div>
          </td>
        </tr>
        <tr>
          <th>Default user view name:</th>
          <td>
            <xsl:variable name="defaultViewName" select="/bedework/system/defaultUserViewName"/>
            <input value="{$defaultViewName}" name="defaultUserViewName" />
            <div class="desc">
              Name used for default view created when a new user is added
            </div>
          </td>
        </tr>
        <tr>
          <th>Http connections per user:</th>
          <td>
            <xsl:variable name="httpPerUser" select="/bedework/system/httpConnectionsPerUser"/>
            <input value="{$httpPerUser}" name="httpConnectionsPerUser" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Http connections per host:</th>
          <td>
            <xsl:variable name="httpPerHost" select="/bedework/system/httpConnectionsPerHost"/>
            <input value="{$httpPerHost}" name="httpConnectionsPerHost" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Total http connections:</th>
          <td>
            <xsl:variable name="httpTotal" select="/bedework/system/httpConnections"/>
            <input value="{$httpTotal}" name="httpConnections" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum length of public event description:</th>
          <td>
            <xsl:variable name="maxPublicDescriptionLength" select="/bedework/system/maxPublicDescriptionLength"/>
            <input value="{$maxPublicDescriptionLength}" name="maxPublicDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum length of user event description:</th>
          <td>
            <xsl:variable name="maxUserDescriptionLength" select="/bedework/system/maxUserDescriptionLength"/>
            <input value="{$maxUserDescriptionLength}" name="maxUserDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Maximum size of a user entity:</th>
          <td>
            <xsl:variable name="maxUserEntitySize" select="/bedework/system/maxUserEntitySize"/>
            <input value="{$maxUserEntitySize}" name="maxUserEntitySize" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Default user quota:</th>
          <td>
            <xsl:variable name="defaultUserQuota" select="/bedework/system/defaultUserQuota"/>
            <input value="{$defaultUserQuota}" name="defaultUserQuota" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th>Max recurring instances:</th>
          <td>
            <xsl:variable name="maxInstances" select="/bedework/system/maxInstances"/>
            <input value="{$maxInstances}" name="maxInstances" />
            <div class="desc">
              Used to limit recurring events to reasonable numbers of instances.
            </div>
          </td>
        </tr>
        <tr>
          <th>Max recurring years:</th>
          <td>
            <xsl:variable name="maxYears" select="/bedework/system/maxYears"/>
            <input value="{$maxYears}" name="maxYears" />
            <div class="desc">
              Used to limit recurring events to reasonable period of time.
            </div>
          </td>
        </tr>
        <tr>
          <th>User authorisation class:</th>
          <td>
            <xsl:variable name="userauthClass" select="/bedework/system/userauthClass"/>
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
            <xsl:variable name="mailerClass" select="/bedework/system/mailerClass"/>
            <input value="{$mailerClass}" name="mailerClass" class="wide"/>
            <div class="desc">
              Class used to mail events. Should probably only be changed on rebuild.
            </div>
          </td>
        </tr>
        <tr>
          <th>Admin groups class:</th>
          <td>
            <xsl:variable name="admingroupsClass" select="/bedework/system/admingroupsClass"/>
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
            <xsl:variable name="usergroupsClass" select="/bedework/system/usergroupsClass"/>
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
            <xsl:variable name="directoryBrowsingDisallowed" select="/bedework/system/directoryBrowsingDisallowed"/>
            <input value="{$directoryBrowsingDisallowed}" name="directoryBrowsingDisallowed" />
            <div class="desc">
              True if the server hosting the xsl disallows directory browsing.
            </div>
          </td>
        </tr>
        <tr>
          <th>Index root:</th>
          <td>
            <xsl:variable name="indexRoot" select="/bedework/system/indexRoot"/>
            <input value="{$indexRoot}" name="indexRoot" class="wide"/>
            <div class="desc">
              Root for the event indexes. Should only be changed if the indexes are moved/copied
            </div>
          </td>
        </tr>
        <tr>
          <th>Supported Locales:</th>
          <td>
            <xsl:variable name="localeList" select="/bedework/system/localeList"/>
            <input value="{$localeList}" name="localeList" class="wide"/>
            <div class="desc">
              List of supported locales. The format is rigid, comma separated list of 2 letter language, underscore, 2 letter country. No spaces.
            </div>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateSystemParams" value="Update"/>
            <input type="submit" name="cancelled" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Calendar Suites (calsuite) ++++++++++++++++++++-->
  <xsl:template match="calSuites" mode="calSuiteList">
    <h2>Manage Calendar Suites</h2>

    <p>
      <input type="button" name="addSuite" value="Add calendar suite" onclick="javascript:location.replace('{$calsuite-showAddForm}')"/>
      <input type="button" name="switchGroup" value="Switch group" onclick="javascript:location.replace('{$admingroup-switch}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Associated Group</th>
      </tr>
      <xsl:for-each select="calSuite">
        <tr>
          <td>
            <xsl:variable name="name" select="name"/>
            <a href="{$calsuite-fetchForUpdate}&amp;name={$name}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="group"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>

  </xsl:template>

  <xsl:template name="addCalSuite">
    <h2>Add Calendar Suite</h2>
    <form name="calSuiteForm" action="{$calsuite-add}" method="post">
      <input type="hidden" name="calPath" value="/public" size="20"/>
      <table class="eventFormTable">
        <tr>
          <th>Name:</th>
          <td>
            <input type="text" name="name" size="20"/>
          </td>
          <td>
            Name of your calendar suite
          </td>
        </tr>
        <tr>
          <th>Group:</th>
          <td>
            <input type="text" name="groupName" size="20"/>
          </td>
          <td>
            Name of admin group which contains event administrators and event owner to which preferences for the suite are attached
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateCalSuite" value="Add"/>
            <input type="submit" name="cancelled" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="calSuite" name="modCalSuite">
    <h2>Modify Calendar Suite</h2>
    <xsl:variable name="calSuiteName" select="name"/>
    <form name="calSuiteForm" action="{$calsuite-update}" method="post">
      <input type="hidden" name="calPath" size="20">
        <xsl:attribute name="value"><xsl:variable name="calPath" select="calPath"/></xsl:attribute>
      </input>
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
      </table>

      <div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="updateCalSuite" value="Update"/>
            <input type="submit" name="cancelled" value="Cancel"/>
          </td>
          <td align="right">
            <input type="submit" name="delete" value="Delete Calendar Suite"/>
          </td>
        </tr>
      </table>
    </form>

    <!-- div id="sharingBox">
      <xsl:apply-templates select="acl" mode="currentAccess">
        <xsl:with-param name="action" select="$calsuite-setAccess"/>
        <xsl:with-param name="calSuiteName" select="$calSuiteName"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" action="{$calsuite-setAccess}" id="shareForm" onsubmit="setAccessHow(this)" method="post">
        <input type="hidden" name="calSuiteName" value="{$calSuiteName}"/>
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
    </div-->
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
            <xsl:value-of select="/bedework/currentCalSuite/name"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view:
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view period:
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
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
        <!--
        <tr>
          <td class="fieldName">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="/bedework/prefs/skinName"/>
            <input type="text" name="skin" value="{$skinName}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="/bedework/prefs/skinStyle"/>
            <input type="text" name="skinStyle" value="{$skinStyle}" size="40"/>
          </td>
        </tr>
        -->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="Update"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2>Manage Timezones</h2>

    <form name="peForm" method="post" action="{$timezones-upload}" enctype="multipart/form-data">
      <input type="file" name="uploadFile" size="40" value=""/>
      <input type="submit" name="doUpload" value="Upload Timezones"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>

    <p>
      <a href="{$timezones-fix}">Fix Timezones</a> (recalculate UTC values)<br/>
      <span class="note">Run this to make sure no UTC values have changed due
      to this upload (e.g. DST changes).</span>
    </p>

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

      <xsl:for-each select="/bedework/authUsers/authUser">
        <!--<xsl:sort select="account" order="ascending" case-order="upper-first"/>-->
        <tr>
          <td>
            <xsl:value-of select="account"/>
          </td>
          <td>
            <xsl:if test="publicEventUser='true'">
              publicEvent; <xsl:text> </xsl:text>
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
    <xsl:variable name="modAuthUserAction" select="/bedework/formElements/form/@action"/>
    <form action="{$modAuthUserAction}" method="post">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            Account:
          </td>
          <td>
            <xsl:value-of select="/bedework/formElements/form/account"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Public Events:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/publicEvents/*"/>
          </td>
        </tr>
        <!--<tr>
          <td class="optional">
            Email:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/email/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Phone:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/phone/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Department:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/dept/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            Last name:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/lastName/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>
        <tr>
          <td class="optional">
            First name:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/firstName/*"/>
            <span class="fieldInfo"></span>
          </td>
        </tr>-->
      </table>
      <br />

      <input type="submit" name="modAuthUser" value="Update"/>
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
            <xsl:value-of select="/bedework/prefs/user"/>
            <xsl:variable name="user" select="/bedework/prefs/user"/>
            <input type="hidden" name="user" value="{$user}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view:
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Preferred view period:
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
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
        <!--
        <tr>
          <td class="fieldName">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="/bedework/prefs/skinName"/>
            <input type="text" name="skin" value="{$skinName}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="/bedework/prefs/skinStyle"/>
            <input type="text" name="skinStyle" value="{$skinStyle}" size="40"/>
          </td>
        </tr>
        -->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="Update"/>
      <input type="submit" name="cancelled" value="Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Admin Groups ++++++++++++++++++++-->
  <xsl:template name="listAdminGroups">
    <h2>Modify Groups</h2>
    <form name="adminGroupMembersForm" method="post" action="{$admingroup-initUpdate}">
      <xsl:choose>
        <xsl:when test="/bedework/groups/showMembers='true'">
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
        <th>Calendar Suite*</th>
        <xsl:if test="/bedework/groups/showMembers='true'">
          <th>Members</th>
        </xsl:if>
        <th></th>
      </tr>
      <xsl:for-each select="/bedework/groups/group">
        <xsl:sort select="name" order="ascending" case-order="lower-first"/>
        <xsl:variable name="groupName" select="name"/>
        <tr>
          <xsl:if test="name = /bedework/calSuites//calSuite/group">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdate}&amp;adminGroupName={$groupName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
          <td>
            <xsl:for-each select="/bedework/calSuites/calSuite">
              <xsl:if test="group = $groupName">
                <xsl:value-of select="name"/>
              </xsl:if>
            </xsl:for-each>
          </td>
          <xsl:if test="/bedework/groups/showMembers='true'">
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
    <p class="note">
     *Highlighted rows indicate a group to which a Calendar Suite is attached.
    </p>
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="Add a new group"/>
    </p>
  </xsl:template>

  <xsl:template match="groups" mode="chooseGroup">
    <h2>Choose Your Administrative Group</h2>

    <xsl:variable name="userInCalSuiteGroup">
      <xsl:choose>
        <xsl:when test="/bedework/calSuites//calSuite/group = .//group/name">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <table id="commonListTable">
      <tr>
        <th>Name</th>
        <th>Description</th>
        <xsl:if test="$userInCalSuiteGroup = 'true'">
          <th>Calendar Suite*</th>
        </xsl:if>
      </tr>

      <xsl:for-each select="group">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <xsl:variable name="admGroupName" select="name"/>
        <tr>
          <xsl:if test="name = /bedework/calSuites//calSuite/group">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <td>
            <a href="{$setup}&amp;adminGroupName={$admGroupName}">
              <xsl:copy-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
          <xsl:if test="$userInCalSuiteGroup = 'true'">
            <td>
              <xsl:for-each select="/bedework/calSuites/calSuite">
                <xsl:if test="group = $admGroupName">
                  <xsl:value-of select="name"/>
                </xsl:if>
              </xsl:for-each>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
    <xsl:if test="$userInCalSuiteGroup = 'true'">
      <p class="note">
       *Highlighted rows indicate a group to which a Calendar Suite is attached.
       Select one of these groups to edit attributes of the associated calendar suite.
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template name="modAdminGroup">
    <xsl:choose>
      <xsl:when test="/bedework/creating = 'true'">
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
              <xsl:when test="/bedework/creating = 'true'">
                <xsl:copy-of select="/bedework/formElements/form/name/*"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/bedework/formElements/form/name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Description:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/desc/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Group owner:
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/groupOwner/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Events owner:
          </td>
          <td>
           <xsl:choose>
              <xsl:when test="/bedework/creating = 'true'">
                <xsl:copy-of select="/bedework/formElements/form/eventsOwner/*"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/bedework/formElements/form/eventsOwner/input/@value"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="/bedework/creating = 'true'">
                <input type="submit" name="updateAdminGroup" value="Add Admin Group"/>
                <input type="submit" name="cancelled" value="Cancel"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateAdminGroup" value="Update Admin Group"/>
                <input type="submit" name="cancelled" value="Cancel"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td align="right">
            <xsl:if test="/bedework/creating = 'false'">
              <input type="submit" name="delete" value="Delete"/>
            </xsl:if>
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
          <xsl:value-of select="/bedework/adminGroup/name"/>
        </td>
      </tr>
      <tr>
        <td class="fieldName">
          Members:
        </td>
        <td>
          <table id="memberAccountList">
            <xsl:for-each select="/bedework/adminGroup/members/member">
              <xsl:choose>
                <xsl:when test="kind='1'"><!-- kind = user -->
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
        <xsl:value-of select="/bedework/groups/group/name"/>
      </strong>:
      <xsl:value-of select="/bedework/groups/group/desc"/>
    </p>
    <form name="adminGroupDelete" method="post" action="{$admingroup-delete}">
      <input type="submit" name="removeAdminGroupOK" value="Yes: Delete!"/>
      <input type="submit" name="cancelled" value="No: Cancel"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Filters ++++++++++++++++++++-->
  <xsl:template name="addFilter">
    <h2>Add a Named CalDAV Filter (<a href="http://bedework.org/trac/bedework/wiki/Bedework/DevDocs/Filters">examples</a>)</h2>
    <form name="peForm" method="post" action="{$filter-add}">
      <table id="addFilterFormTable" class="eventFormTable">
        <tr>
          <th>
            Name:
          </th>
          <td>
            <input type="text" name="name" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            Description:
          </th>
          <td>
            <input type="text" name="desc" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            Filter Definition:
          </th>
          <td>
            <textarea name="def" rows="30" cols="80"></textarea>
          </td>
        </tr>
        <tr>
          <td>
          </td>
          <td>
            <input type="submit" name="add" value="Add Filter"/>
            <input type="submit" name="cancelled" value="Cancel"/>
          </td>
        </tr>
      </table>
    </form>
    <xsl:if test="/bedework/filters/filter">
      <h2>Current Filters</h2>
      <table id="filterTable">
        <tr>
          <th>Filter Name</th>
          <th>Description/Definition</th>
          <th>Delete</th>
        </tr>
        <xsl:for-each select="/bedework/filters/filter">
          <xsl:variable name="filterName" select="name"/>
          <tr>
            <td><xsl:value-of select="$filterName"/></td>
            <td>
              <xsl:if test="description != ''"><xsl:value-of select="description"/><br/></xsl:if>
              <a href="javascript:toggleVisibility('bwfilter-{$filterName}','filterdef')">
                show/hide filter definition
              </a>
              <div id="bwfilter-{$filterName}" class="invisible">
                <xsl:value-of select="definition"/>
              </div>
            </td>
            <td>
              <a href="{$filter-delete}&amp;name={$filterName}" title="delete filter">
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="delete filter"/>
              </a>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
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
        <a href="{$stats-update}&amp;fetch=yes">fetch/refresh statistics</a>
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
                    <xsl:when test="number($curPage) - 10 &lt; 1">1</xsl:when>
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
