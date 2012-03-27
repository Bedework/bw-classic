<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
     method="html"
     indent="no"
     media-type="text/html"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     standalone="yes"
     omit-xml-declaration="yes"/>
 <xsl:strip-space elements="*"/>

  <!-- ======================================== -->
  <!--      BEDEWORK ADMIN CLIENT STYLESHEET     -->
  <!-- ========================================= -->

  <!-- GENERATE KEYS -->
  <!-- Pick out unique categories from a collection of events
       for filtering in the manage event list. -->
  <xsl:key name="catUid" match="category" use="uid"/>

  <!-- DEFINE INCLUDES -->
  <xsl:include href="/bedework-common/default/default/util.xsl"/>
  <xsl:include href="/bedework-common/default/default/bedeworkAccess.xsl"/>
  <!-- include the language strings -->
  <xsl:include href="/bedework-common/default/default/errors.xsl"/>
  <xsl:include href="/bedework-common/default/default/messages.xsl"/>
  <xsl:include href="/bedework-common/default/default/bedeworkAccessStrings.xsl"/>
  <xsl:include href="./strings.xsl"/>
  <xsl:include href="./localeSettings.xsl" />

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the admin client
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot">https://mywebserver.edu/myresourcesdir</xsl:variable>
    -->
  <xsl:variable name="resourcesRoot" select="/bedework/browserResourceRoot"/>

  <!-- Root context of uploaded event images -->
  <xsl:variable name="bwEventImagePrefix">/pubcaldav</xsl:variable>
  
  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- Root folder of the submissions calendars used by the submissions client -->
  <xsl:variable name="submissionsRootEncoded" select="/bedework/submissionsRoot/encoded"/>
  <xsl:variable name="submissionsRootUnencoded" select="/bedework/submissionsRoot/unencoded"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       we will probably change the way we create these before long (e.g. build them
       dynamically in the xslt). -->

  <!-- primary navigation, menu tabs -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="initPendingTab" select="/bedework/urlPrefixes/initPendingTab"/>
  <xsl:variable name="showCalsuiteTab" select="/bedework/urlPrefixes/showCalsuiteTab"/>
  <xsl:variable name="showUsersTab" select="/bedework/urlPrefixes/showUsersTab"/>
  <xsl:variable name="showSystemTab" select="/bedework/urlPrefixes/showSystemTab"/>
  <xsl:variable name="logout" select="/bedework/urlPrefixes/logout"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>

  <!-- events -->
  <xsl:variable name="event-showEvent" select="/bedework/urlPrefixes/event/showEvent"/>
  <xsl:variable name="event-showModForm" select="/bedework/urlPrefixes/event/showModForm"/>
  <xsl:variable name="event-showUpdateList" select="/bedework/urlPrefixes/event/showUpdateList"/>
  <xsl:variable name="event-showDeleteConfirm" select="/bedework/urlPrefixes/event/showDeleteConfirm"/>
  <xsl:variable name="event-initAddEvent" select="/bedework/urlPrefixes/event/initAddEvent"/>
  <xsl:variable name="event-initUpdateEvent" select="/bedework/urlPrefixes/event/initUpdateEvent"/>
  <xsl:variable name="event-delete" select="/bedework/urlPrefixes/event/delete"/>
  <xsl:variable name="event-deletePending" select="/bedework/urlPrefixes/event/deletePending"/>
  <xsl:variable name="event-fetchForDisplay" select="/bedework/urlPrefixes/event/fetchForDisplay"/>
  <xsl:variable name="event-fetchForUpdate" select="/bedework/urlPrefixes/event/fetchForUpdate"/>
  <xsl:variable name="event-fetchForUpdatePending" select="/bedework/urlPrefixes/event/fetchForUpdatePending"/>
  <xsl:variable name="event-update" select="/bedework/urlPrefixes/event/update"/>
  <xsl:variable name="event-updatePending" select="/bedework/urlPrefixes/event/updatePending"/>
  <xsl:variable name="event-selectCalForEvent" select="/bedework/urlPrefixes/event/selectCalForEvent"/>
  <xsl:variable name="event-initUpload" select="/bedework/urlPrefixes/event/initUpload"/>
  <xsl:variable name="event-upload" select="/bedework/urlPrefixes/event/upload"/>
  <!-- contacts -->
  <xsl:variable name="contact-showContact" select="/bedework/urlPrefixes/contact/showContact"/>
  <xsl:variable name="contact-showReferenced" select="/bedework/urlPrefixes/contact/showReferenced"/>
  <xsl:variable name="contact-showModForm" select="/bedework/urlPrefixes/contact/showModForm"/>
  <xsl:variable name="contact-showUpdateList" select="/bedework/urlPrefixes/contact/showUpdateList"/>
  <xsl:variable name="contact-showDeleteConfirm" select="/bedework/urlPrefixes/contact/showDeleteConfirm"/>
  <xsl:variable name="contact-initAdd" select="/bedework/urlPrefixes/contact/initAdd"/>
  <xsl:variable name="contact-initUpdate" select="/bedework/urlPrefixes/contact/initUpdate"/>
  <xsl:variable name="contact-delete" select="/bedework/urlPrefixes/contact/delete"/>
  <xsl:variable name="contact-fetchForDisplay" select="/bedework/urlPrefixes/contact/fetchForDisplay"/>
  <xsl:variable name="contact-fetchForUpdate" select="/bedework/urlPrefixes/contact/fetchForUpdate"/>
  <xsl:variable name="contact-update" select="/bedework/urlPrefixes/contact/update"/>
  <!-- locations -->
  <xsl:variable name="location-showLocation" select="/bedework/urlPrefixes/location/showLocation"/>
  <xsl:variable name="location-showReferenced" select="/bedework/urlPrefixes/location/showReferenced"/>
  <xsl:variable name="location-showModForm" select="/bedework/urlPrefixes/location/showModForm"/>
  <xsl:variable name="location-showUpdateList" select="/bedework/urlPrefixes/location/showUpdateList"/>
  <xsl:variable name="location-showDeleteConfirm" select="/bedework/urlPrefixes/location/showDeleteConfirm"/>
  <xsl:variable name="location-initAdd" select="/bedework/urlPrefixes/location/initAdd"/>
  <xsl:variable name="location-initUpdate" select="/bedework/urlPrefixes/location/initUpdate"/>
  <xsl:variable name="location-delete" select="/bedework/urlPrefixes/location/delete"/>
  <xsl:variable name="location-fetchForDisplay" select="/bedework/urlPrefixes/location/fetchForDisplay"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedework/urlPrefixes/location/fetchForUpdate"/>
  <xsl:variable name="location-update" select="/bedework/urlPrefixes/location/update"/>
  <!-- categories -->
  <xsl:variable name="category-showReferenced" select="/bedework/urlPrefixes/category/showReferenced"/>
  <xsl:variable name="category-showModForm" select="/bedework/urlPrefixes/category/showModForm"/>
  <xsl:variable name="category-showUpdateList" select="/bedework/urlPrefixes/category/showUpdateList"/>
  <xsl:variable name="category-showDeleteConfirm" select="/bedework/urlPrefixes/category/showDeleteConfirm"/>
  <xsl:variable name="category-initAdd" select="/bedework/urlPrefixes/category/initAdd"/>
  <xsl:variable name="category-initUpdate" select="/bedework/urlPrefixes/category/initUpdate"/>
  <xsl:variable name="category-delete" select="/bedework/urlPrefixes/category/delete"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedework/urlPrefixes/category/fetchForUpdate"/>
  <xsl:variable name="category-update" select="/bedework/urlPrefixes/category/update"/>
  <!-- calendars -->
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions"/>
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd"/>
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate"/>
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update"/>
  <!-- <xsl:variable name="calendar-setAccess" select="/bedework/urlPrefixes/calendar/setAccess"/>-->
  <xsl:variable name="calendar-openCloseMod" select="/bedework/urlPrefixes/calendar/calOpenCloseMod"/>
  <xsl:variable name="calendar-openCloseSelect" select="/bedework/urlPrefixes/calendar/calOpenCloseSelect"/>
  <xsl:variable name="calendar-openCloseDisplay" select="/bedework/urlPrefixes/calendar/calOpenCloseDisplay"/>
  <xsl:variable name="calendar-openCloseMove" select="/bedework/urlPrefixes/calendar/calOpenCloseMove"/>
  <xsl:variable name="calendar-move" select="/bedework/urlPrefixes/calendar/move"/>
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd"/>
  <xsl:variable name="subscriptions-update" select="/bedework/urlPrefixes/subscriptions/update"/>
  <xsl:variable name="subscriptions-delete" select="/bedework/urlPrefixes/subscriptions/delete"/>
  <xsl:variable name="subscriptions-openCloseMod" select="/bedework/urlPrefixes/subscriptions/subOpenCloseMod"/>
  <!-- views -->
  <xsl:variable name="view-fetch" select="/bedework/urlPrefixes/view/fetch"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedework/urlPrefixes/view/fetchForUpdate"/>
  <xsl:variable name="view-addView" select="/bedework/urlPrefixes/view/addView"/>
  <xsl:variable name="view-update" select="/bedework/urlPrefixes/view/update"/>
  <xsl:variable name="view-remove" select="/bedework/urlPrefixes/view/remove"/>
  <!-- system -->
  <xsl:variable name="system-fetch" select="/bedework/urlPrefixes/system/fetch"/>
  <xsl:variable name="system-update" select="/bedework/urlPrefixes/system/update"/>
  <!-- calsuites -->
  <xsl:variable name="calsuite-fetch" select="/bedework/urlPrefixes/calsuite/fetch"/>
  <xsl:variable name="calsuite-fetchForUpdate" select="/bedework/urlPrefixes/calsuite/fetchForUpdate"/>
  <xsl:variable name="calsuite-add" select="/bedework/urlPrefixes/calsuite/add"/>
  <xsl:variable name="calsuite-update" select="/bedework/urlPrefixes/calsuite/update"/>
  <xsl:variable name="calsuite-showAddForm" select="/bedework/urlPrefixes/calsuite/showAddForm"/>
  <!--  <xsl:variable name="calsuite-setAccess" select="/bedework/urlPrefixes/calsuite/setAccess"/> -->
  <xsl:variable name="calsuite-fetchPrefsForUpdate" select="/bedework/urlPrefixes/calsuite/fetchPrefsForUpdate"/>
  <xsl:variable name="calsuite-updatePrefs" select="/bedework/urlPrefixes/calsuite/updatePrefs"/>
  <!-- timezones and stats -->
  <xsl:variable name="timezones-initUpload" select="/bedework/urlPrefixes/timezones/initUpload"/>
  <xsl:variable name="timezones-upload" select="/bedework/urlPrefixes/timezones/upload"/>
  <xsl:variable name="timezones-fix" select="/bedework/urlPrefixes/timezones/fix"/>
  <xsl:variable name="stats-update" select="/bedework/urlPrefixes/stats/update"/>
  <!-- authuser and prefs -->
  <xsl:variable name="authuser-showModForm" select="/bedework/urlPrefixes/authuser/showModForm"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedework/urlPrefixes/authuser/showUpdateList"/>
  <xsl:variable name="authuser-initUpdate" select="/bedework/urlPrefixes/authuser/initUpdate"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedework/urlPrefixes/authuser/fetchForUpdate"/>
  <xsl:variable name="authuser-update" select="/bedework/urlPrefixes/authuser/update"/>
  <xsl:variable name="prefs-fetchForUpdate" select="/bedework/urlPrefixes/prefs/fetchForUpdate"/>
  <xsl:variable name="prefs-update" select="/bedework/urlPrefixes/prefs/update"/>
  <!-- admin groups -->
  <xsl:variable name="admingroup-showModForm" select="/bedework/urlPrefixes/admingroup/showModForm"/>
  <xsl:variable name="admingroup-showModMembersForm" select="/bedework/urlPrefixes/admingroup/showModMembersForm"/>
  <xsl:variable name="admingroup-showUpdateList" select="/bedework/urlPrefixes/admingroup/showUpdateList"/>
  <xsl:variable name="admingroup-showChooseGroup" select="/bedework/urlPrefixes/admingroup/showChooseGroup"/>
  <xsl:variable name="admingroup-showDeleteConfirm" select="/bedework/urlPrefixes/admingroup/showDeleteConfirm"/>
  <xsl:variable name="admingroup-initAdd" select="/bedework/urlPrefixes/admingroup/initAdd"/>
  <xsl:variable name="admingroup-initUpdate" select="/bedework/urlPrefixes/admingroup/initUpdate"/>
  <xsl:variable name="admingroup-delete" select="/bedework/urlPrefixes/admingroup/delete"/>
  <xsl:variable name="admingroup-fetchUpdateList" select="/bedework/urlPrefixes/admingroup/fetchUpdateList"/>
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedework/urlPrefixes/admingroup/fetchForUpdate"/>
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedework/urlPrefixes/admingroup/fetchForUpdateMembers"/>
  <xsl:variable name="admingroup-update" select="/bedework/urlPrefixes/admingroup/update"/>
  <xsl:variable name="admingroup-updateMembers" select="/bedework/urlPrefixes/admingroup/updateMembers"/>
  <xsl:variable name="admingroup-switch" select="/bedework/urlPrefixes/admingroup/switch"/>
  <!-- filters -->
  <xsl:variable name="filter-showAddForm" select="/bedework/urlPrefixes/filter/showAddForm"/>
  <xsl:variable name="filter-add" select="/bedework/urlPrefixes/filter/add"/>
  <xsl:variable name="filter-delete" select="/bedework/urlPrefixes/filter/delete"/>


  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!-- the following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals.  -->
  <xsl:variable name="portalFriendly">false</xsl:variable>
  
	<!-- get the current date set by the user, if exists, else use now -->
	<xsl:variable name="curListDate">
	  <xsl:choose>
	    <xsl:when test="/bedework/appvar[key='curListDate']/value"><xsl:value-of select="/bedework/appvar[key='curListDate']/value"/></xsl:when>
	    <xsl:otherwise><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<!-- get the current number of days set by the user, if exists, else use default -->
  <xsl:variable name="curListDays">
    <xsl:choose>
      <xsl:when test="/bedework/appvar[key='curListDays']/value"><xsl:value-of select="/bedework/appvar[key='curListDays']/value"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="/bedework/defaultdays"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--==== MAIN TEMPLATE  ====-->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
        <link rel="stylesheet" href="/bedework-common/default/default/subColors.css"/>
        <!-- set globals that must be passed in from the XSLT -->
        <script type="text/javascript">
          <xsl:comment>
          var defaultTzid = "<xsl:value-of select="/bedework/now/defaultTzid"/>";
          var startTzid = "<xsl:value-of select="/bedework/formElements/form/start/tzid"/>";
          var endTzid = "<xsl:value-of select="/bedework/formElements/form/end/dateTime/tzid"/>";
          var resourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";
          var imagesRoot = resourcesRoot + "/resources";
          </xsl:comment>
        </script>
        <!-- load jQuery  -->
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
        <!-- Global Javascript (every page): -->
        <script type="text/javascript">
          <xsl:comment>
            $(document).ready(function(){
              // focus first visible,enabled form element:
              $(':input[type=text]:visible:enabled:first').focus();
            });
          </xsl:comment>
        </script>
        <!-- conditional javascript and css -->
        <xsl:if test="/bedework/page='modEvent' or /bedework/page='modEventPending'">
          <!-- import the internationalized strings for the javascript widgets -->
          <xsl:call-template name="bedeworkEventJsStrings"/>
          
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bwClock.js">&#160;</script>
          <link rel="stylesheet" href="/bedework-common/javascript/bedework/bwClock.css"/>
          <xsl:choose>
            <xsl:when test="$portalFriendly = 'true'">
              <script type="text/javascript" src="{$resourcesRoot}/resources/dynCalendarWidget.js">&#160;</script>
              <link rel="stylesheet" href="{$resourcesRoot}/resources/dynCalendarWidget.css"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- include the localized jQuery datepicker defaults -->
		          <xsl:call-template name="jqueryDatepickerDefaults"/>
		        
		          <!-- now setup date and time pickers -->  
              <script type="text/javascript">
                <xsl:comment>
                function bwSetupDatePickers() {
                  // startdate
                  $("#bwEventWidgetStartDate").datepicker({
                    defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
                  }).attr("readonly", "readonly");
                  $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

		              // starttime
		              $("#bwStartClock").bwTimePicker({
		                hour24: <xsl:value-of select="/bedework/hour24"/>,
		                attachToId: "calWidgetStartTimeHider",
		                hourIds: ["eventStartDateHour","eventStartDateSchedHour"],
		                minuteIds: ["eventStartDateMinute","eventStartDateSchedMinute"],
		                ampmIds: ["eventStartDateAmpm","eventStartDateSchedAmpm"],
		                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
		                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
		                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
		                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
		              });

                  // enddate
                  $("#bwEventWidgetEndDate").datepicker({
                    defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                  }).attr("readonly", "readonly");
                  $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/end/rfc3339DateTime,'T')"/>');

		              // endtime
		              $("#bwEndClock").bwTimePicker({
		                hour24: <xsl:value-of select="/bedework/hour24"/>,
		                attachToId: "calWidgetEndTimeHider",
		                hourIds: ["eventEndDateHour"],
		                minuteIds: ["eventEndDateMinute"],
		                ampmIds: ["eventEndDateAmpm"],
		                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
		                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
		                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
		                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
		              });

                  // recurrence until
                  $("#bwEventWidgetUntilDate").datepicker({
                    <xsl:choose>
                      <xsl:when test="/bedework/formElements/form/recurrence/until">
                        defaultDate: new Date(<xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(/bedework/formElements/form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,7,2)"/>),
                      </xsl:when>
                      <xsl:otherwise>
                        defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                      </xsl:otherwise>
                    </xsl:choose>
                    altField: "#bwEventUntilDate",
                    altFormat: "yymmdd"
                  }).attr("readonly", "readonly");
                  $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

                  // rdates and xdates
                  $("#bwEventWidgetRdate").datepicker({
                    defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                    dateFormat: "yymmdd"
                  }).attr("readonly", "readonly");
                  $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');
                  
		              // rdates and xdates times
		              $("#bwRecExcClock").bwTimePicker({
		                hour24: true,
		                withPadding: true,
		                attachToId: "rdateTimeFields",
		                hourIds: ["eventRdateHour"],
		                minuteIds: ["eventRdateMinute"],
		                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
		                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
		                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
		                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
		              });
                }
                </xsl:comment>
              </script>
            </xsl:otherwise>
          </xsl:choose>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkEventForm.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkXProperties.js">&#160;</script>
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
              <xsl:for-each select="/bedework/formElements/form/xproperties/node()">
                bwXProps.init("<xsl:value-of select="name()"/>",[<xsl:for-each select="parameters/node()">["<xsl:value-of select="name()"/>","<xsl:value-of select="node()"/>"]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],"<xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="values/text"/></xsl:with-param></xsl:call-template>");
              </xsl:for-each>
            }

            $(document).ready(function(){

	            <xsl:if test="/bedework/formElements/recurrenceId = ''">
                initRXDates();
              </xsl:if>
              
              <xsl:if test="/bedework/page='modEvent' or /bedework/page='modEventPending'">
                initXProperties();
                bwSetupDatePickers();
                
                // trim the event description:
                $("#description").val($.trim($("#description").val()));
                
                // limit the event description to maxPublicDescriptionLength as configured in cal.options.xml
                $("#description").keyup(function(){  
                  var maxDescLength = parseInt(<xsl:value-of select="/bedework/formElements/form/descLength"/>);  
                  var desc = $(this).val();  
                  var remainingChars = maxDescLength - desc.length;
                  if (remainingChars &lt; 0) {
                    remainingChars = 0;
                  }
                  $("#remainingChars").html(remainingChars + " <xsl:value-of select="$bwStr-AEEF-CharsRemaining"/>"); 
                  if(desc.length > maxDescLength){  
                    var truncDesc = desc.substr(0, maxDescLength);  
                    $(this).val(truncDesc); 
                  };  
                });  
                
              </xsl:if>
              
              <xsl:if test="/bedework/page='listEvents'">
                bwSetupListDatePicker();
              </xsl:if>
                            
              // If you wish to collapse specific topical areas, you can specify them here:
              // (note that this will be managed from the admin client in time)
              // $("ul.aliasTree > li:eq(4) > ul").hide();  	      
              // $("ul.aliasTree > li:eq(11) > ul").hide(); 	      
              // $("ul.aliasTree > li:eq(13) > ul").hide(); 
              $("ul.aliasTree > li > img.folderForAliasTree").attr("src", '<xsl:value-of select="$resourcesRoot"/>/resources/catExpander.gif');
              $("ul.aliasTree > li > img.folderForAliasTree").css("cursor","pointer");
              $("ul.aliasTree > li > img.folderForAliasTree").click(function(){
                $(this).next("ul.aliasTree > li > ul").slideToggle("slow");
              });

            });
            </xsl:comment>
          </script>
        </xsl:if>
        <xsl:if test="/bedework/page='eventList'">
          <!-- include the localized jQuery datepicker defaults -->
          <xsl:call-template name="jqueryDatepickerDefaults"/>
          
          <!-- now setup date and time pickers -->  
          <script type="text/javascript">
            <xsl:comment>
            $(document).ready(function(){
              // startdate for list
              $("#bwListWidgetStartDate").datepicker({
                defaultDate: new Date(<xsl:value-of select="substring(/bedework/now/date,1,4)"/>, <xsl:value-of select="number(substring(/bedework/now/date,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/now/date,7,2)"/>)
              });
              $("#bwListWidgetStartDate").val('<xsl:value-of select="$curListDate"/>');
            });
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
          <xsl:if test="/bedework/calSuite/acl/ace">
            <script type="text/javascript">
              <xsl:apply-templates select="/bedework/calSuite/acl/ace" mode="initJS"/>
            </script>
          </xsl:if>
        </xsl:if>
        <xsl:if test="/bedework/page='calSuitePrefs'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkPrefs.js">&#160;</script>
        </xsl:if>
        <xsl:if test="/bedework/page='upload' or
                      /bedework/page='selectCalForEvent' or
                      /bedework/page='deleteEventConfirmPending' or
                      /bedework/page='addFilter' or
                      /bedework/page='calSuitePrefs' or
                      /bedework/page='eventList'">
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
          <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkEventForm.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">&#160;</script>
        </xsl:if>
        <xsl:if test="/bedework/page='calendarDescriptions' or /bedework/page='displayCalendar'">
          <link rel="stylesheet" href="{$resourcesRoot}/resources/calendarDescriptions.css"/>
        </xsl:if>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
      </head>
      <body>
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
                <xsl:when test="/bedework/page='deleteContactConfirm'">
                  <xsl:call-template name="deleteContactConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='contactReferenced'">
                  <xsl:call-template name="contactReferenced"/>
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
                <xsl:when test="/bedework/page='locationReferenced'">
                  <xsl:call-template name="locationReferenced"/>
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
                <xsl:when test="/bedework/page='categoryReferenced'">
                  <xsl:call-template name="categoryReferenced"/>
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
                                /bedework/page='modSubscription' or
                                /bedework/page='deleteSubConfirm'">
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
                  <h2><xsl:copy-of select="$bwStr-Root-NoAdminGroup"/></h2>
                  <p><xsl:copy-of select="$bwStr-Root-YourUseridNotAssigned"/></p>
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
                  <h2><xsl:copy-of select="$bwStr-Root-NoAccess"/></h2>
                  <p>
                    <xsl:copy-of select="$bwStr-Root-YouHaveNoAccess"/>
                  </p>
                  <p>
                    <a href="{$setup}"><xsl:copy-of select="$bwStr-Root-Continue"/></a>
                  </p>
                </xsl:when>
                <xsl:when test="/bedework/page='error'">
                  <h2><xsl:copy-of select="$bwStr-Root-AppError"/></h2>
                  <p><xsl:copy-of select="$bwStr-Root-AppErrorOccurred"/></p>
                  <p>
                    <a href="{$setup}"><xsl:copy-of select="$bwStr-Root-Continue"/></a>
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
        <xsl:copy-of select="$bwStr-Head-BedeworkPubEventsAdmin"/>
      </h1>
    </div>
    <xsl:call-template name="messagesAndErrors"/>
    <table id="statusBarTable">
      <tr>
        <td class="leftCell">
          <xsl:copy-of select="$bwStr-Head-CalendarSuite"/><xsl:text> </xsl:text>
          <span class="status">
            <xsl:choose>
              <xsl:when test="/bedework/currentCalSuite/name">
                <xsl:value-of select="/bedework/currentCalSuite/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$bwStr-Head-None"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
          <xsl:text> </xsl:text>
        </td>
        <xsl:if test="/bedework/userInfo/user">
          <td class="rightCell">
              <span id="groupDisplay">
                <xsl:copy-of select="$bwStr-Head-Group"/><xsl:text> </xsl:text>
                <span class="status">
                  <xsl:choose>
                    <xsl:when test="/bedework/userInfo/group">
                      <xsl:value-of select="/bedework/userInfo/group"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="$bwStr-Head-None"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="(/bedework/userInfo/group and /bedework/userInfo/oneGroup = 'false') or /bedework/userInfo/superUser = 'true'">
                  <a href="{$admingroup-switch}" class="fieldInfo"><xsl:copy-of select="$bwStr-Head-Change"/></a>
                </xsl:if>
                <xsl:text> </xsl:text>
              </span>
            <xsl:copy-of select="$bwStr-Head-LoggedInAs"/><xsl:text> </xsl:text>
            <span class="status">
              <xsl:value-of select="/bedework/userInfo/currentUser"/>
            </span>
            <xsl:text> </xsl:text>
            <a href="{$logout}" id="bwLogoutButton" class="fieldInfo"><xsl:copy-of select="$bwStr-Head-LogOut"/></a>
          </td>
        </xsl:if>
      </tr>
    </table>

    <ul id="bwAdminMenu">
      <li>
        <xsl:if test="/bedework/tab = 'main'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$setup}&amp;listAllEvents=false"><xsl:copy-of select="$bwStr-Head-MainMenu"/></a>
      </li>
      <li>
        <xsl:if test="/bedework/tab = 'pending'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$initPendingTab}&amp;calPath={$submissionsRootEncoded}&amp;listAllEvents=true"><xsl:copy-of select="$bwStr-Head-PendingEvents"/></a>
      </li>
      <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
        <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
          <li>
            <xsl:if test="/bedework/tab = 'calsuite'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$showCalsuiteTab}"><xsl:copy-of select="$bwStr-Head-CalendarSuite"/></a>
          </li>
        </xsl:if>
      </xsl:if>
      <xsl:if test="/bedework/userInfo/superUser='true'">
        <li>
          <xsl:if test="/bedework/tab = 'users'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showUsersTab}"><xsl:copy-of select="$bwStr-Head-Users"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/tab = 'system'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showSystemTab}"><xsl:copy-of select="$bwStr-Head-System"/></a>
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
          <li>
            <xsl:apply-templates select="."/>
	          <!-- Special cases for handling error conditions: -->
	          <xsl:if test="/bedework/error/id = 'org.bedework.client.error.duplicateimage'">
              <input type="checkbox" id="overwriteEventImage" onclick="setOverwriteImageField(this);"/><label for="overwriteEventImage"><xsl:copy-of select="$bwStr-AEEF-Overwrite"/></label><xsl:text> </xsl:text>
              <!-- input type="checkbox" id="reuseEventImage"/><label for="reuseEventImage">Reuse</label>-->
	          </xsl:if>
          </li>
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

    <div class="notes">
      <xsl:if test="/bedework/userInfo/superUser = 'true'">
        <p class="note">
          <xsl:copy-of select="$bwStr-MMnu-LoggedInAs"/>
        </p>
      </xsl:if>
    </div>

    <table id="mainMenu">
      <tr>
        <td>
          <a id="addEventLink" href="{$event-initAddEvent}">
            <xsl:if test="not(/bedework/currentCalSuite/name)">
              <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
            </xsl:if>
            <img src="{$resourcesRoot}/resources/bwAdminAddEventIcon.jpg" width="140" height="140" alt="Add Event" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-AddEvent"/>
          </a>
        </td>
        <td>
          <a id="addContactLink" href="{$contact-initAdd}">
            <img src="{$resourcesRoot}/resources/bwAdminAddContactIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-AddContact"/>
          </a>
        </td>
        <td>
          <a id="addLocationLink" href="{$location-initAdd}">
            <img src="{$resourcesRoot}/resources/bwAdminAddLocationIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-AddLocation"/>
          </a>
        </td>
        <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
          <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
            <!--
              Category management is a  super-user and calsuite admin feature;
              Categories underly much of the new single calendar and filtering model.-->
            <td>
              <a id="addCategoryLink" href="{$category-initAdd}">
                <img src="{$resourcesRoot}/resources/bwAdminAddCategoryIcon.jpg" width="100" height="100" alt="Add Event" border="0"/>
                <br/><xsl:copy-of select="$bwStr-MMnu-AddCategory"/>
              </a>
            </td>
          </xsl:if>
        </xsl:if>
      </tr>
      <tr>
        <td>
          <a href="{$event-initUpdateEvent}">
            <xsl:attribute name="href"><xsl:value-of select="$event-initUpdateEvent"/>&amp;start=<xsl:value-of select="$curListDate"/>&amp;days=<xsl:value-of select="$curListDays"/>&amp;limitdays=true</xsl:attribute>
            <xsl:if test="not(/bedework/currentCalSuite/name)">
              <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
            </xsl:if>
            <img src="{$resourcesRoot}/resources/bwAdminManageEventsIcon.jpg" width="100" height="73" alt="Manage Events" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-ManageEvents"/>
          </a>
        </td>
        <td>
          <a href="{$contact-initUpdate}">
            <img src="{$resourcesRoot}/resources/bwAdminManageContactsIcon.jpg" width="100" height="73" alt="Manage Contacts" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-ManageContacts"/>
          </a>
        </td>
        <td>
          <a href="{$location-initUpdate}">
            <img src="{$resourcesRoot}/resources/bwAdminManageLocsIcon.jpg" width="100" height="73" alt="Manage Locations" border="0"/>
            <br/><xsl:copy-of select="$bwStr-MMnu-ManageLocations"/>
          </a>
        </td>
        <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
          <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
            <!--
              Category management is a super-user and calsuite admin feature;
              Categories underly much of the new single calendar and filtering model.-->
            <td>
              <a href="{$category-initUpdate}">
                <img src="{$resourcesRoot}/resources/bwAdminManageCatsIcon.jpg" width="100" height="73" alt="Manage Categories" border="0"/>
                <br/><xsl:copy-of select="$bwStr-MMnu-ManageCategories"/>
              </a>
            </td>
          </xsl:if>
        </xsl:if>
      </tr>
    </table>

    <div id="mainMenuEventSearch">
      <h4 class="menuTitle"><xsl:copy-of select="$bwStr-MMnu-EventSearch"/></h4>
      <form name="searchForm" method="post" action="{$search}" id="searchForm">
        <input type="text" name="query" size="30">
          <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
        </input>
        <input type="submit" name="submit" value="{$bwStr-MMnu-Go}"/>
        <div id="searchFields">
          <xsl:copy-of select="$bwStr-MMnu-Limit"/>
          <input type="radio" name="searchLimits" value="fromToday" checked="checked"/><xsl:copy-of select="$bwStr-MMnu-TodayForward"/>
          <input type="radio" name="searchLimits" value="beforeToday"/><xsl:copy-of select="$bwStr-MMnu-PastDates"/>
          <input type="radio" name="searchLimits" value="none"/><xsl:copy-of select="$bwStr-MMnu-AddDates"/>
        </div>
      </form>
    </div>
  </xsl:template>

  <!--+++++++++++++++ Pending Events Tab ++++++++++++++++++++-->
  <xsl:template name="tabPendingEvents">
    <h2><xsl:copy-of select="$bwStr-TaPE-PendingEvents"/></h2>
    <p><xsl:copy-of select="$bwStr-TaPE-EventsAwaitingModeration"/></p>
    <xsl:call-template name="eventListCommon">
      <xsl:with-param name="pending">true</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!--+++++++++++++++ Calendar Suite Tab ++++++++++++++++++++-->
  <xsl:template name="tabCalsuite">
    <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser='true'">
      <h2>
        <xsl:copy-of select="$bwStr-TaCS-ManageCalendarSuite"/>
      </h2>

      <div id="calSuiteTitle">
        <xsl:copy-of select="$bwStr-TaCS-CalendarSuite"/><xsl:text> </xsl:text>
        <strong><xsl:value-of select="/bedework/currentCalSuite/name"/></strong>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-TaCS-Group"/><xsl:text> </xsl:text>
        <strong><xsl:value-of select="/bedework/currentCalSuite/group"/></strong>
        <xsl:text> </xsl:text>
        <a href="{$admingroup-switch}" class="fieldInfo"><xsl:copy-of select="$bwStr-TaCS-Change"/></a>
      </div>
      <ul class="adminMenu">
        <li>
          <a href="{$subscriptions-fetch}" title="subscriptions to calendars">
            <xsl:copy-of select="$bwStr-TaCS-ManageSubscriptions"/>
          </a>
        </li>
        <li>
          <a href="{$view-fetch}" title="collections of subscriptions">
            <xsl:copy-of select="$bwStr-TaCS-ManageViews"/>
          </a>
        </li>
        <li>
          <a href="{$calsuite-fetchPrefsForUpdate}" title="calendar suite defaults such as viewperiod and view">
            <xsl:copy-of select="$bwStr-TaCS-ManagePreferences"/>
          </a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ User/Group Tab ++++++++++++++++++++-->
  <xsl:template name="tabUsers">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2><xsl:copy-of select="$bwStr-TaUs-ManageUsersAndGroups"/></h2>
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
              <xsl:copy-of select="$bwStr-TaUs-ManageAdminGroups"/>
            </a>
          </li>
        </xsl:if>
        <li class="changeGroup">
          <a href="{$admingroup-switch}">
            <xsl:copy-of select="$bwStr-TaUs-ChangeGroup"/>
          </a>
        </li>
        <xsl:if test="/bedework/userInfo/userMaintOK='true'">
          <li class="user">
            <form action="{$prefs-fetchForUpdate}" method="post">
              <xsl:copy-of select="$bwStr-TaUs-EditUsersPrefs"/><br/>
              <input type="text" name="user" size="15"/>
              <input type="submit" name="getPrefs" value="{$bwStr-TaUs-Go}"/>
            </form>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ System Tab ++++++++++++++++++++-->
  <xsl:template name="tabSystem">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2><xsl:copy-of select="$bwStr-TaSy-ManageSys"/></h2>
      <ul class="adminMenu strong">
        <li class="calendar">
          <a href="{$calendar-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalsAndFolders"/>
          </a>
        </li>
        <li class="categories">
          <a href="{$category-initUpdate}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCategories"/>
          </a>
        </li>
        <li class="calsuites">
          <a href="{$calsuite-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalSuites"/>
          </a>
        </li>
        <li class="upload">
          <a href="{$event-initUpload}">
            <xsl:copy-of select="$bwStr-TaSy-UploadICalFile"/>
          </a>
        </li>
      </ul>
      <ul class="adminMenu">
        <li class="prefs">
          <a href="{$system-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageSysPrefs"/>
          </a>
        </li>
      </ul>
      <ul class="adminMenu">
        <li>
          <a href="{$filter-showAddForm}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalDAVFilters"/>
          </a>
        </li>
        <li class="timezones">
          <a href="{$timezones-fix}">
            <xsl:attribute name="title"><xsl:copy-of select="$bwStr-UpTZ-FixTZNote"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-UpTZ-FixTZ"/>
          </a>
          <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-UpTZ-RecalcUTC"/><br/>
        </li>
      </ul>
      <ul class="adminMenu">
        <li>
          <xsl:copy-of select="$bwStr-TaSy-Stats"/>
          <ul>
            <li>
              <a href="{$stats-update}&amp;fetch=yes" target="adminStats">
                <xsl:copy-of select="$bwStr-TaSy-AdminWebClient"/>
              </a>
            </li>
            <li>
              <a href="{$publicCal}/stats/stats.do?fetch=yes" target="pubStats">
                <xsl:copy-of select="$bwStr-TaSy-PublicWebClient"/>
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--++++++++++++++++++ Events ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <h2><xsl:copy-of select="$bwStr-EvLs-ManageEvents"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-EvLs-SelectEvent"/>
      <input type="button" name="return" value="{$bwStr-EvLs-PageTitle}" onclick="javascript:location.replace('{$event-initAddEvent}')"/>
    </p>

    <div id="bwEventListControls">
      <form name="calForm" id="bwManageEventListControls" method="post" action="{$event-initUpdateEvent}">
        <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
        <input id="bwListWidgetStartDate" name="start" size="10" onchange="setListDate(this.form);"/>
        <input type="hidden" name="setappvar" id="curListDateHolder"/>
        <input type="hidden" name="limitdays" value="true"/>
        <span id="daysSetterBox">
	        <label for="days"><xsl:copy-of select="$bwStr-EvLs-Days"/></label>
	        <xsl:text> </xsl:text>
	        <!-- <xsl:value-of select="/bedework/defaultdays"/> -->
          <select id="days" name="days" onchange="setListDate(this.form);">
	          <xsl:call-template name="buildListDays"/>
	        </select>
	        <input type="hidden" id="curListDaysHolder" name="setappvar"/>
	      </span>
        
        <!-- This block contains the original Show Active/All toggle.  
             Uncomment this block to use, though it can be slow if working 
             with large very large numbers of events. 
        <xsl:copy-of select="$bwStr-EvLs-Show"/>
        <xsl:copy-of select="/bedework/formElements/form/listAllSwitchFalse/*"/>
        <xsl:copy-of select="$bwStr-EvLs-Active"/>
        <xsl:copy-of select="/bedework/formElements/form/listAllSwitchTrue/*"/>
        <xsl:copy-of select="$bwStr-EvLs-All"/>
        -->
      </form>

      <form name="filterEventsForm"
            id="bwFilterEventsForm"
            action="{$event-initUpdateEvent}">
        <xsl:copy-of select="$bwStr-EvLs-FilterBy"/>
        <select name="setappvar" onchange="this.form.submit();">
          <option value="catFilter(none)"><xsl:copy-of select="$bwStr-EvLs-SelectCategory"/></option>
          <xsl:for-each select="/bedework/events//event/categories//category[generate-id() = generate-id(key('catUid',uid)[1])]">
            <xsl:variable name="uid" select="uid"/>
            <option value="catFilter({$uid})">
              <xsl:if test="/bedework/appvar[key='catFilter']/value = uid">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value"/>
            </option>
          </xsl:for-each>
        </select>
        <input type="hidden" name="start" value="{$curListDate}"/>
        <input type="hidden" name="limitdays" value="true"/>
        <xsl:if test="/bedework/appvar[key='catFilter'] and /bedework/appvar[key='catFilter']/value != 'none'">
          <input type="submit" value="{$bwStr-EvLs-ClearFilter}" onclick="this.form.setappvar.selectedIndex = 0"/>
        </xsl:if>
      </form>
    </div>
    <xsl:call-template name="eventListCommon"/>
  </xsl:template>
  
  <xsl:template name="buildListDays">
    <xsl:param name="index">1</xsl:param>
    <xsl:variable name="max" select="/bedework/maxdays"/>
    <xsl:if test="number($index) &lt; number($max)">
      <option name="listDays($index)">
        <xsl:if test="$index = $curListDays"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:value-of select="$index"/>
      </option>
      <xsl:call-template name="buildListDays">
        <xsl:with-param name="index"><xsl:value-of select="number($index)+1"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="eventListCommon">
    <xsl:param name="pending">false</xsl:param>
    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-EvLC-Title"/></th>
        <xsl:if test="$pending = 'true'">
          <th><xsl:copy-of select="$bwStr-EvLC-ClaimedBy"/></th>
        </xsl:if>
        <th><xsl:copy-of select="$bwStr-EvLC-Start"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-End"/></th>
        <th>
          <xsl:if test="$pending = 'true'"><xsl:copy-of select="$bwStr-EvLC-Suggested"/><xsl:text> </xsl:text></xsl:if>
          <xsl:copy-of select="$bwStr-EvLC-TopicalAreas"/>
        </th>
        <xsl:if test="$pending = 'false'">
          <th><xsl:copy-of select="$bwStr-EvLC-Categories"/></th>
        </xsl:if>
        <th><xsl:copy-of select="$bwStr-EvLC-Description"/></th>
      </tr>

      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='catFilter'] and /bedework/appvar[key='catFilter']/value != 'none'">
          <xsl:apply-templates select="/bedework/events/event[categories//category/uid = /bedework/appvar[key='catFilter']/value]" mode="eventListCommon">
            <xsl:with-param name="pending"><xsl:value-of select="$pending"/></xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/bedework/events/event" mode="eventListCommon">
            <xsl:with-param name="pending"><xsl:value-of select="$pending"/></xsl:with-param>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>

    </table>
  </xsl:template>

  <xsl:template match="event" mode="eventListCommon">
    <xsl:param name="pending">false</xsl:param>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <tr>
      <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
      <xsl:if test="$pending = 'true' and not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT)">
        <xsl:attribute name="class">highlight</xsl:attribute>
      </xsl:if>
      <td>
        <xsl:choose>
          <xsl:when test="$pending = 'true'">
            <xsl:choose>
              <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT and not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text = /bedework/userInfo/group)">
                <xsl:choose>
                  <xsl:when test="summary != ''">
                    <xsl:value-of select="summary"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$event-fetchForUpdatePending}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:choose>
                    <xsl:when test="summary != ''">
                      <xsl:value-of select="summary"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:choose>
                <xsl:when test="summary != ''">
                  <xsl:value-of select="summary"/>
                </xsl:when>
                <xsl:otherwise>
                  <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$pending = 'true'">
        <xsl:choose>
          <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT">
            <td>
              <xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text"/>
              <xsl:text> </xsl:text>
              (<xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/parameters/X-BEDEWORK-SUBMISSION-CLAIMANT-USER"/>)
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="unclaimed"><xsl:copy-of select="$bwStr-EvLC-Unclaimed"/></td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
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
        <xsl:choose>
          <xsl:when test="$pending = 'true'">
            <xsl:for-each select="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
              <xsl:call-template name="substring-afterLastInstanceOf">
                <xsl:with-param name="string" select="values/text"/>
                <xsl:with-param name="char">/</xsl:with-param>
              </xsl:call-template><br/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[contains(values/text,/bedework/currentCalSuite/resourcesHome)]">
              <xsl:value-of select="substring-after(values/text,/bedework/currentCalSuite/resourcesHome)"/><br/>
            </xsl:for-each>
            <xsl:if test="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
              <xsl:variable name="tagsId">bwTags-<xsl:value-of select="guid"/></xsl:variable>
              <div class="bwEventListOtherGroupTags">
                <strong><xsl:copy-of select="$bwStr-EvLC-ThisEventCrossTagged"/></strong><br/>
                <input type="checkbox" name="tagsToggle" value="" onclick="toggleVisibility('{$tagsId}','bwOtherTags')"/>
                <xsl:copy-of select="$bwStr-EvLC-ShowTagsByOtherGroups"/>
                <div id="{$tagsId}" class="invisible">
                  <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
                    <xsl:value-of select="values/text"/><br/>
                  </xsl:for-each>
                </div>
              </div>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$pending = 'false'">
        <td class="calcat">
          <xsl:for-each select="categories/category">
            <xsl:value-of select="value"/><br/>
          </xsl:for-each>
        </td>
      </xsl:if>
      <td>
        <xsl:value-of select="description"/>
        <xsl:if test="recurring = 'true' or recurrenceId != ''">
          <div class="recurrenceEditLinks">
            <xsl:copy-of select="$bwStr-EvLC-RecurringEventEdit"/>
            <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}">
              <xsl:copy-of select="$bwStr-EvLC-Master"/>
            </a> |
            <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:copy-of select="$bwStr-EvLC-Instance"/>
            </a>
          </div>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="formElements" mode="modEvent">
    <xsl:variable name="calPathEncoded" select="form/calendar/event/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/event/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventTitle" select="form/title/input/@value"/>
    <xsl:variable name="eventUrlPrefix"><xsl:value-of select="$publicCal"/>/event/eventView.do?guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:variable>
    <xsl:variable name="userPath"><xsl:value-of select="/bedework/syspars/userPrincipalRoot"/>/<xsl:value-of select="/bedework/userInfo/user"/></xsl:variable>

    <!-- Determine if the current user can edit this event.
         If canEdit is false, we will only allow tagging by topical area,
         and other fields will be disabled. -->
    <xsl:variable name="canEdit">
      <xsl:choose>
        <xsl:when test="($userPath = creator) or (/bedework/page = 'modEventPending') or (/bedework/userInfo/superUser = 'true') or (/bedework/creating = 'true')">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <h2><xsl:copy-of select="$bwStr-AEEF-EventInfo"/></h2>

    <xsl:if test="$canEdit = 'false'">
      <p><xsl:copy-of select="$bwStr-AEEF-YouMayTag"/></p>
    </xsl:if>

    <xsl:if test="/bedework/page = 'modEventPending'">
      <!-- if a submitted event has topical areas that match with 
           those in the calendar suite, convert them -->
      <script type="text/javascript">
      $(document).ready(function() {
        $("ul.aliasTree input:checked").trigger("onclick");
      });
      </script>
    
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
            '<xsl:for-each select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-ALIAS']/values/text"><xsl:call-template name="escapeApos"><xsl:with-param name="str"><xsl:call-template name="substring-afterLastInstanceOf"><xsl:with-param name="string" select="."/><xsl:with-param name="char">/</xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template><br/></xsl:for-each>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text"/></xsl:call-template>',
            '<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text"/></xsl:call-template>');
        </script>

        <div id="bwSubmittedEventCommentBlock">
          <div id="bwSubmittedBy">
            <xsl:copy-of select="$bwStr-AEEF-SubmittedBy"/>
            <xsl:variable name="submitterEmail" select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTER-EMAIL']/values/text"/>
            <a href="mailto:{$submitterEmail}?subject=[Event%20Submission] {$eventTitle}" title="Email {$submitterEmail}" class="submitter">
              <xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/>
            </a><xsl:text> </xsl:text>
            (<a href="mailto:{$submitterEmail}?subject=[Event%20Submission] {$eventTitle}" title="Email {$submitterEmail}">
              <img src="{$resourcesRoot}/resources/email.gif" border="0"/>
              <xsl:copy-of select="$bwStr-AEEF-SendMsg"/>
            </a>)
          </div>
          <h4><xsl:copy-of select="$bwStr-AEEF-CommentsFromSubmitter"/></h4>
          <a href="javascript:toggleVisibility('bwSubmittedEventComment','visible');" class="toggle"><xsl:copy-of select="$bwStr-AEEF-ShowHide"/></a>
          <a href="javascript:bwSubmitComment.launch();" class="toggle"><xsl:copy-of select="$bwStr-AEEF-PopUp"/></a>
          <div id="bwSubmittedEventComment">
            <xsl:if test="/bedework/page = 'modEvent'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            <xsl:text> </xsl:text>
          </div>
        </div>
        <script type="text/javascript">
          bwSubmitComment.display('bwSubmittedEventComment');
        </script>
      </xsl:if>
    </xsl:if>

    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userInfo/currentUser"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-For"/><xsl:text> </xsl:text><xsl:value-of select="/bedework/userInfo/group"/> (<xsl:value-of select="/bedework/userInfo/user"/>)</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" enctype="multipart/form-data" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}')">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventPending'">
          <xsl:attribute name="action"><xsl:value-of select="$event-updatePending"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="action"><xsl:value-of select="$event-update"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Set the underlying calendar; if there is more than one publishing calendar, the
           form below will test for that and allow this value to be changed.  -->
      <input type="hidden" name="newCalPath" id="newCalPath">
        <xsl:choose>
          <xsl:when test="/bedework/creating='true'">
            <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option/@value"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option[@selected]/@value"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </input>

      <!-- Setup email notification fields -->
      <input type="hidden" id="submitNotification" name="submitNotification" value="false"/>
      <!-- "from" should be a preference: hard code it for now -->
      <input type="hidden" id="snfrom" name="snfrom" value="bedework@yoursite.edu"/>
      <input type="hidden" id="snsubject" name="snsubject" value=""/>
      <input type="hidden" id="sntext" name="sntext" value=""/>

      <xsl:call-template name="submitEventButtons">
        <xsl:with-param name="eventTitle" select="$eventTitle"/>
        <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
        <xsl:with-param name="canEdit" select="$canEdit"/>
      </xsl:call-template>

      <table class="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Title"/>
          </td>
          <td>
            <input type="text" size="60" name="summary">
              <xsl:attribute name="value"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            </input>
            <xsl:if test="$canEdit = 'false'">
              <div class="bwHighlightBox">
                <strong><xsl:value-of select="form/title/input/@value"/></strong>
              </div>
            </xsl:if>
          </td>
        </tr>
<!--
        <tr>
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Type"/>
          </td>
          <td>
            <input type="radio" name="entityType" value="1"/><xsl:copy-of select="$bwStr-AEEF-Event"/>
            <input type="radio" name="entityType" value="2"/><xsl:copy-of select="$bwStr-AEEF-Deadline"/>
          </td>
        </tr>
-->
        <xsl:if test="count(form/calendar/all/select/option) &gt; 1 and
                      not(starts-with(form/calendar/path,$submissionsRootUnencoded))">
        <!-- check to see if we have more than one publishing calendar
             but disallow directly setting for pending events -->
          <tr>
            <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-Calendar"/>
            </td>
            <td>
              <xsl:if test="form/calendar/preferred/select/option">
                <!-- Display the preferred calendars by default if they exist -->
                <select name="bwPreferredCalendars" id="bwPreferredCalendars" onchange="this.form.newCalPath.value = this.value">

                  <option value="">
                    <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                  </option>
                  <xsl:for-each select="form/calendar/preferred/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          <xsl:copy-of select="$bwStr-AEEF-SubmittedEvents"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
              </xsl:if>
              <!-- hide the listing of all calendars if preferred calendars exist, otherwise show them -->
              <select name="bwAllCalendars" id="bwAllCalendars" onchange="this.form.newCalPath.value = this.value;">

                <xsl:if test="form/calendar/preferred/select/option">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <option value="">
                  <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                </option>
                <xsl:for-each select="form/calendar/all/select/option">
                  <xsl:sort select="." order="ascending"/>
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                    <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                    <xsl:choose>
                      <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                        <xsl:copy-of select="$bwStr-AEEF-SubmittedEvents"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-after(node(),'/public/')"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </option>
                </xsl:for-each>
              </select>
              <xsl:text> </xsl:text>
              <!-- allow for toggling between the preferred and all calendars listings if preferred
                   calendars exist -->
              <xsl:if test="form/calendar/preferred/select/option">
                <input type="radio" name="toggleCalendarLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredCalendars','shown');changeClass('bwAllCalendars','invisible');this.form.newCalPath.value = this.form.bwPreferredCalendars.value;"/>
                <xsl:copy-of select="$bwStr-AEEF-Preferred"/>
                <input type="radio" name="toggleCalendarLists" value="all" onclick="changeClass('bwPreferredCalendars','invisible');changeClass('bwAllCalendars','shown');this.form.newCalPath.value = this.form.bwAllCalendars.value;"/>
                <xsl:copy-of select="$bwStr-AEEF-All"/>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>

        <tr>
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-DateAndTime"/>
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
            <xsl:copy-of select="$bwStr-AEEF-AllDay"/>

            <!-- floating event: no timezone (and not UTC) -->
            <!-- let's hide it completely unless it comes in checked
                 (e.g. from import); to restore this field, remove the if  -->
            <xsl:if test="form/floating/input/@checked='checked'">
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
              <xsl:copy-of select="$bwStr-AEEF-Floating"/>
            </xsl:if>

            <!-- store time as coordinated universal time (UTC) -->
            <!-- like floating time, let's hide UTC completely unless an
                 event comes in checked; (e.g. from import);
                 to restore this field, remove the if -->
            <xsl:if test="form/storeUTC/input/@checked='checked'">
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
              <xsl:copy-of select="$bwStr-AEEF-StoreAsUTC"/>
            </xsl:if>

            <br/>
            <div class="dateStartEndBox">
              <strong><xsl:copy-of select="$bwStr-AEEF-Start"/></strong>
              <div class="dateFields">
                <span class="startDateLabel"><xsl:copy-of select="$bwStr-AEEF-Date"/><xsl:text> </xsl:text></span>
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
                    <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                    <script language="JavaScript" type="text/javascript">
                      <xsl:comment>
                      /*$("#bwEventWidgetStartDate").datepicker({
                        defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                      }).attr("readonly", "readonly");
                      $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
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
                  <select name="eventStartDate.hour" id="eventStartDateHour">
                    <xsl:copy-of select="form/start/hour/select/*"/>
                  </select>
                  <select name="eventStartDate.minute" id="eventStartDateMinute">
                    <xsl:copy-of select="form/start/minute/select/*"/>
                  </select>
                  <xsl:if test="form/start/ampm">
                    <select name="eventStartDate.ampm" id="eventStartDateAmpm">
                      <xsl:copy-of select="form/start/ampm/select/*"/>
                    </select>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0" id="bwStartClock"/>

                  <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
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
              <strong><xsl:copy-of select="$bwStr-AEEF-End"/></strong>
              <xsl:choose>
                <xsl:when test="form/end/type='E'">
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:copy-of select="$bwStr-AEEF-Date"/>
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
                      <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        /*$("#bwEventWidgetEndDate").datepicker({
                          defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                        }).attr("readonly", "readonly");
                        $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');*/
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
                    <select name="eventEndDate.hour" id="eventEndDateHour">
                      <xsl:copy-of select="form/end/dateTime/hour/select/*"/>
                    </select>
                    <select name="eventEndDate.minute" id="eventEndDateMinute">
                      <xsl:copy-of select="form/end/dateTime/minute/select/*"/>
                    </select>
                    <xsl:if test="form/start/ampm">
                      <select name="eventEndDate.ampm" id="eventEndDateAmpm">
                        <xsl:copy-of select="form/end/dateTime/ampm/select/*"/>
                      </select>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0" id="bwEndClock"/>

                    <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
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
                <xsl:copy-of select="$bwStr-AEEF-Duration"/>
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
                        <input type="text" name="eventDuration.daysStr" size="2" id="durationDays">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/days/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <input type="text" name="eventDuration.hoursStr" size="2" id="durationHours">
                            <xsl:attribute name="value"><xsl:value-of select="form/end/duration/hours/input/@value"/></xsl:attribute>
                          </input><xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" id="durationMinutes">
                            <xsl:attribute name="value"><xsl:value-of select="form/end/duration/minutes/input/@value"/></xsl:attribute>
                          </input><xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AEEF-Or"/></span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" id="durationWeeks" disabled="disabled">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/weeks/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" id="durationWeeks">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/weeks/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
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
                <xsl:copy-of select="$bwStr-AEEF-ThisEventHasNoDurationEndDate"/>
              </div>
            </div>
          </td>
        </tr>
        <xsl:if test="$canEdit = 'false'">
          <!-- admin user can't edit this, so just dispaly some useful information -->
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-DateAndTime"/>
            </td>
            <td>
              <xsl:value-of select="form/start/month/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/day/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/yearText/input/@value"/><xsl:text>, </xsl:text>
              <xsl:value-of select="form/start/hour/select/option[@selected]"/>:<xsl:value-of select="form/start/minute/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/ampm/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:if test="form/allDay/input/@checked='checked'">(all day)<xsl:text> </xsl:text></xsl:if>
              <xsl:if test="form/start/tzid != form/end/dateTime/tzid"><xsl:value-of select="form/start/tzid"/></xsl:if>
              <xsl:if test="form/start/rfc3339DateTime != form/end/rfc3339DateTime">
                -
                <xsl:if test="substring(form/start/rfc3339DateTime,1,10) != substring(form/end/rfc3339DateTime,1,10)">
                  <xsl:value-of select="form/end/dateTime/month/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/day/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/yearText/input/@value"/><xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="substring(form/start/rfc3339DateTime,12,16) != substring(form/end/rfc3339DateTime,12,16)">
                  <xsl:value-of select="form/end/dateTime/hour/select/option[@selected]"/>:<xsl:value-of select="form/end/dateTime/minute/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/ampm/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/tzid"/>
                </xsl:if>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>


        <!-- Recurrence fields -->
        <!-- ================= -->
        <tr>
          <xsl:if test="($canEdit = 'false') and (form/recurringEntity = 'false') and (recurrenceId = '')"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-RECURRANCE"/>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="recurrenceId != ''">
                <!-- recurrence instances can not themselves recur,
                     so provide access to master event -->
                <em><xsl:copy-of select="$bwStr-AEEF-ThisEventRecurrenceInstance"/></em><br/>
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-EditMaster}"><xsl:copy-of select="$bwStr-AEEF-EditMasterEvent"/></a>
              </xsl:when>
              <xsl:otherwise>
                <!-- has recurrenceId, so is master -->

	              <xsl:choose>
	                <xsl:when test="form/recurringEntity = 'false'">
		                <!-- the switch is required to turn recurrence on - maybe we can infer this instead? -->
		                <div id="recurringSwitch">
		                  <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
		                  <!-- set or remove "recurring" and show or hide all recurrence fields: -->
		                  <input type="radio" name="recurring" value="true" onclick="swapRecurrence(this)">
		                    <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
		                  </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-EventRecurs"/>
		                  <input type="radio" name="recurring" value="false" onclick="swapRecurrence(this)">
		                    <xsl:if test="form/recurringEntity = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
		                  </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-EventDoesNotRecur"/>
		                </div>
		              </xsl:when>
			            <xsl:otherwise>
			              <!-- is a recurring event; once created as such, it can no longer be made non-recurring. -->
			              <input type="hidden" name="recurring" value="true"/>
			            </xsl:otherwise>
			          </xsl:choose>

                <!-- wrapper for all recurrence fields (rrules and rdates): -->
                <div id="recurrenceFields" class="invisible">
                  <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

                  <h4>
                    <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                    <xsl:copy-of select="$bwStr-AEEF-RecurrenceRules"/>
                  </h4>
                  <!-- show or hide rrules fields when editing: -->
                  <xsl:if test="form/recurrence">
                    <span id="rrulesSwitch">
                      <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                      <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on">
                        <xsl:if test="$canEdit = 'false'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-ChangeRecurrenceRules"/>
                    </span>
                  </xsl:if>
                  <span id="rrulesUiSwitch">
                    <xsl:if test="form/recurrence">
                      <xsl:attribute name="class">invisible</xsl:attribute>
                    </xsl:if>
                    <input type="checkbox" name="rrulesUiSwitch" value="advanced" onchange="swapVisible(this,'advancedRrules')"/>
                    <xsl:copy-of select="$bwStr-AEEF-ShowAdvancedRecurrenceRules"/>
                  </span>

                  <xsl:if test="form/recurrence">
                    <!-- Output descriptive recurrence rules information.  Probably not
                         complete yet. Replace all strings so can be
                         more easily internationalized. -->
                    <div id="recurrenceInfo">
                      <xsl:copy-of select="$bwStr-AEEF-Every"/><xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/interval &gt; 1">
                          <xsl:value-of select="form/recurrence/interval"/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/freq = 'HOURLY'"><xsl:copy-of select="$bwStr-AEEF-Hour"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'DAILY'"><xsl:copy-of select="$bwStr-AEEF-Day"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'WEEKLY'"><xsl:copy-of select="$bwStr-AEEF-Week"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'MONTHLY'"><xsl:copy-of select="$bwStr-AEEF-Month"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'YEARLY'"><xsl:copy-of select="$bwStr-AEEF-Year"/><xsl:text> </xsl:text></xsl:when>
                      </xsl:choose>
                      <xsl:text> </xsl:text>

                      <xsl:if test="form/recurrence/byday">
                        <xsl:for-each select="form/recurrence/byday/pos">
                          <xsl:if test="position() != 1"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                          <xsl:copy-of select="$bwStr-AEEF-On"/>
                          <xsl:text> </xsl:text>
                          <xsl:choose>
                            <xsl:when test="@val='1'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFirst"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='2'">
                              <xsl:copy-of select="$bwStr-AEEF-TheSecond"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='3'">
                              <xsl:copy-of select="$bwStr-AEEF-TheThird"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='4'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFourth"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='5'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFifth"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='-1'">
                              <xsl:copy-of select="$bwStr-AEEF-TheLast"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <!-- don't output "every" -->
                            <!--<xsl:otherwise>
                              every
                            </xsl:otherwise>-->
                          </xsl:choose>
                          <xsl:for-each select="day">
                            <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
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
                        <xsl:copy-of select="$bwStr-AEEF-In"/>
                        <xsl:for-each select="form/recurrence/bymonth/val">
                          <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                          <xsl:variable name="monthNum" select="number(.)"/>
                          <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                          <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                      </xsl:if>

                      <xsl:if test="form/recurrence/bymonthday">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-DayOfTheMonth"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:if test="form/recurrence/byyearday">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-DayOfTheYear"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:if test="form/recurrence/byweekno">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-InThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-WeekOfTheYear"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:copy-of select="$bwStr-AEEF-Repeating"/>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/count = '-1'"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Forever"/></xsl:when>
                        <xsl:when test="form/recurrence/until">
                          <xsl:text> </xsl:text>
                          <xsl:copy-of select="$bwStr-AEEF-Until"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="form/recurrence/count"/>
                          <xsl:text> </xsl:text>
                          <xsl:copy-of select="$bwStr-AEEF-Times"/>
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
                        <em><xsl:copy-of select="$bwStr-AEEF-Frequency"/></em><br/>
                        <input type="radio" name="freq" value="NONE" onclick="showRrules(this.value)" checked="checked"/><xsl:copy-of select="$bwStr-AEEF-None"/><br/>
                        <!--<input type="radio" name="freq" value="HOURLY" onclick="showRrules(this.value)"/>hourly<br/>-->
                        <input type="radio" name="freq" value="DAILY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Daily"/><br/>
                        <input type="radio" name="freq" value="WEEKLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Weekly"/><br/>
                        <input type="radio" name="freq" value="MONTHLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Monthly"/><br/>
                        <input type="radio" name="freq" value="YEARLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Yearly"/>
                      </td>
                      <!-- recurrence count, until, forever -->
                      <td id="recurrenceUntil">
                        <div id="noneRecurrenceRules">
                          <xsl:copy-of select="$bwStr-AEEF-NoRecurrenceRules"/>
                        </div>
                        <div id="recurrenceUntilRules" class="invisible">
                          <em><xsl:copy-of select="$bwStr-AEEF-Repeat"/></em>
                          <p>
                            <input type="radio" name="recurCountUntil" value="forever">
                              <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Forever"/>
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
                            <xsl:copy-of select="$bwStr-AEEF-Time"/>
                            <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                              <xsl:if test="form/recurring/until">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Until"/>
                            <span id="untilHolder">
                              <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                              <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
                              <script language="JavaScript" type="text/javascript">
                                <xsl:comment>
                                /*$("#bwEventWidgetUntilDate").datepicker({
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
                                $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
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
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="hourlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Hour"/>
                          </p>
                        </div>
                        <!-- daily -->
                        <div id="dailyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="dailyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Day"/>
                          </p>
                          <p>
                            <input type="checkbox" name="swapDayMonthCheckBoxList" value="" onclick="swapVisible(this,'dayMonthCheckBoxList')"/>
                            <xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/>
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
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="weeklyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-WeekOn"/>
                          </p>
                          <p>
                            <div id="weekRecurFields">
                              <xsl:call-template name="byDayChkBoxList">
                                <xsl:with-param name="name">byDayWeek</xsl:with-param>
                              </xsl:call-template>
                            </div>
                          </p>
                          <p class="weekRecurLinks">
                            <a href="javascript:recurSelectWeekdays('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekdays"/></a> |
                            <a href="javascript:recurSelectWeekends('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekends"/></a>
                          </p>
                          <p>
                            <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
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
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="monthlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Month"/>
                          </p>
                          <div id="monthRecurFields">
                            <div id="monthRecurFields1">
                              <xsl:copy-of select="$bwStr-AEEF-On"/>
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
                            <xsl:copy-of select="$bwStr-AEEF-OnTheseDays"/><br/>
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
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="yearlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                           <xsl:copy-of select="$bwStr-AEEF-Year"/>
                          </p>
                          <div id="yearRecurFields">
                            <div id="yearRecurFields1">
                              <xsl:copy-of select="$bwStr-AEEF-On"/>
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
                            <xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/>
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
                            <xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheMonth"/><br/>
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
                            <xsl:copy-of select="$bwStr-AEEF-InTheseWeeksOfTheYear"/><br/>
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
                            <xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheYear"/><br/>
                            <div id="yearDaysCheckBoxList" class="invisible">
                              <xsl:call-template name="buildCheckboxList">
                                <xsl:with-param name="current">1</xsl:with-param>
                                <xsl:with-param name="end">366</xsl:with-param>
                                <xsl:with-param name="name">yearDayBoxes</xsl:with-param>
                              </xsl:call-template>
                            </div>
                          </p>
                          <p>
                            <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
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
                    <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                    <xsl:copy-of select="$bwStr-AEEF-RecurrenceAndExceptionDates"/>
                  </h4>
                  <div id="raContent">
                      <div class="dateStartEndBox" id="rdatesFormFields">
                        <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
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
                            /*$("#bwEventWidgetRdate").datepicker({
                              defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                              dateFormat: "yymmdd"
                            }).attr("readonly", "readonly");
                            $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                            </xsl:comment>
                          </script>
                        </div>
                        <div id="rdateTimeFields" class="timeFields">
                         <select name="eventRdate.hour" id="eventRdateHour">
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
                          <select name="eventRdate.minute" id="eventRdateMinute">
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
                         <img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0" alt="bwClock" id="bwRecExcClock"/>

                        <select name="tzid" id="rdateTzid" class="timezones">
                          <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                          <option value=""><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
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
                      <span>
                        <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                        <input type="button" name="rdate" value="{$bwStr-AEEF-AddRecurance}" onclick="bwRdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>
                        <!-- input type="button" name="exdate" value="add exception" onclick="bwExdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/-->
                      </span>
                      <br class="clear"/>

                      <input type="hidden" name="rdates" value="" id="bwRdatesField" />
                      <!-- if there are no recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdatesNone">
                        <tr><th><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th></tr>
                        <tr><td><xsl:copy-of select="$bwStr-AEEF-NoRecurrenceDates"/></td></tr>
                      </table>

                      <!-- if there are recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdates">
                        <tr>
                          <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th>
                        </tr>
                        <tr class="colNames">
                          <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TIME"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                          <td></td>
                        </tr>
                      </table>

                      <input type="hidden" name="exdates" value="" id="bwExdatesField" />
                      <!-- if there are no exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdatesNone">
                        <tr><th><xsl:copy-of select="$bwStr-AEEF-ExceptionDates"/></th></tr>
                        <tr><td><xsl:copy-of select="$bwStr-AEEF-NoExceptionDates"/></td></tr>
                      </table>

                      <!-- if there are exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdates">
                        <tr>
                          <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-NoExceptionDates"/></th>
                        </tr>
                        <tr class="colNames">
                          <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                        <td><xsl:copy-of select="$bwStr-AEEF-TIME"/></td>
                        <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                          <td></td>
                        </tr>
                      </table>
                      <p>
                        <xsl:copy-of select="$bwStr-AEEF-ExceptionDatesMayBeCreated"/>
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
            <xsl:copy-of select="$bwStr-AEEF-Status"/>
          </td>
          <td>
            <span>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <input type="radio" name="eventStatus" value="CONFIRMED" checked="checked">
                <xsl:if test="form/status = 'CONFIRMED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:copy-of select="$bwStr-AEEF-Confirmed"/>
              <input type="radio" name="eventStatus" value="TENTATIVE">
                <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:copy-of select="$bwStr-AEEF-Tentative"/>
              <input type="radio" name="eventStatus" value="CANCELLED">
                <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:copy-of select="$bwStr-AEEF-Canceled"/>
            </span>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/status"/>
            </xsl:if>
          </td>
        </tr>
        <!--  Transparency  -->
        <!-- let's not set this in the public client, and let the defaults hold
        <tr>
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-AffectsFreeBusy"/>
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="OPAQUE" name="transparency">
              <xsl:if test="form/transparency = 'OPAQUE' or not(form/transparency)"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-YesOpaque"/>

            <input type="radio" value="TRANSPARENT" name="transparency">
              <xsl:if test="form/transparency = 'TRANSPARENT'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-NoTransparent"/>
          </td>
        </tr> -->
        <!--  Description  -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Description"/>
          </td>
          <td>
            <textarea name="description" id="description" cols="80" rows="8" placeholder="{$bwStr-AEEF-EnterPertientInfo}">
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <xsl:value-of select="form/desc/textarea"/>
              <xsl:if test="form/desc/textarea = ''"><xsl:text> </xsl:text></xsl:if>
            </textarea>
            <div class="fieldInfo">
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <span class="maxCharNotice"><xsl:value-of select="form/descLength"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-CharsMax"/></span>
              <span id="remainingChars">&#160;</span>
            </div>
            <xsl:if test="$canEdit = 'false'">
              <div class="bwHighlightBox">
                <xsl:value-of select="form/desc/textarea"/>
              </div>
            </xsl:if>
          </td>
        </tr>
        <!-- Cost -->
        <tr class="optional">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Cost"/>
          </td>
          <td>
            <input type="text" size="80" name="eventCost" placeholder="{$bwStr-AEEF-OptionalPlaceToPurchaseTicks}">
              <xsl:attribute name="value"><xsl:value-of select="form/cost/input/@value"/></xsl:attribute>
            </input>
          </td>
        </tr>
        <!-- Url -->
        <tr class="optional">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-EventURL"/>
          </td>
          <td>
            <input type="text" name="eventLink" size="80" placeholder="{$bwStr-AEEF-OptionalMoreEventInfo}">
              <xsl:attribute name="value"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
              <!-- xsl:if test="$canEdit = 'false'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if-->
            </input>
          </td>
        </tr>
        <!-- Image Url -->
        <tr class="optional" id="bwImageUrl">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Image"/>
          </td>
          <td>
            <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-IMAGE'] or form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']">
              <xsl:variable name="imgPrefix">
                <xsl:choose>
                  <xsl:when test="starts-with(form/xproperties/node()[name()='X-BEDEWORK-IMAGE'],'http')"></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="imgThumbPrefix">
                <xsl:choose>
                  <xsl:when test="starts-with(form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE'],'http')"></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div id="eventFormImage">
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']">
                  <img>
                    <xsl:attribute name="src"><xsl:value-of select="$imgPrefix"/><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']"/></xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
                  </img>
                </xsl:if>
		            <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']">
		              <img>
		                <xsl:attribute name="src"><xsl:value-of select="$imgThumbPrefix"/><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']"/></xsl:attribute>
		                <xsl:attribute name="alt"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
		              </img>
		            </xsl:if>
	            </div>
	          </xsl:if>
            <label class="interiorLabel" for="xBwImageHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageURL"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageHolder" id="xBwImageHolder" value="" size="60" placeholder="{$bwStr-AEEF-OptionalEventImage}">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <br/>
            <label class="interiorLabel" for="xBwImageThumbHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageThumbURL"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageThumbHolder" id="xBwImageThumbHolder" value="" size="60" placeholder="{$bwStr-AEEF-OptionalEventThumbImage}">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <xsl:if test="/bedework/imageUploadDirectory">
	            <br/>
	            <label class="interiorLabel" for="eventImageUpload">
	              <xsl:copy-of select="$bwStr-AEEF-ImageUpload"/>
	            </label>
	            <xsl:text> </xsl:text>
	            <input type="file" name="eventImageUpload" id="eventImageUpload" size="45"/>
	            <input type="checkbox" name="replaceImage" id="replaceImage" value="true"/><label for="replaceImage"><xsl:copy-of select="$bwStr-AEEF-Overwrite"/></label>
	            <!-- button name="eventImageUseExisting" id="eventImageUseExisting"><xsl:copy-of select="$bwStr-AEEF-UseExisting"/></button--><br/>
	            <div class="fieldInfoAlone">
	              <xsl:copy-of select="$bwStr-AEEF-OptionalImageUpload"/><br/>
	              <xsl:if test="/bedework/creating = 'false' and form/xproperties/node()[name()='X-BEDEWORK-IMAGE']">
	                <button id="eventImageRemoveButton" onclick="removeEventImage(this.form.xBwImageHolder,this.form.xBwImageThumbHolder);return false;"><xsl:copy-of select="$bwStr-AEEF-RemoveImages"/></button>
	              </xsl:if>
	            </div>
	          </xsl:if>
          </td>
        </tr>
        <!-- Location -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Location"/>
          </td>
          <td>
            <span>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <xsl:if test="form/location/preferred/select/option">
                <select name="prefLocationId" id="bwPreferredLocationList">
                  <option value="">
                    <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                  </option>
                  <xsl:copy-of select="form/location/preferred/select/*"/>
                </select>
              </xsl:if>
              <select name="allLocationId" id="bwAllLocationList">
                <xsl:if test="form/location/preferred/select/option">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <option value="">
                  <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                </option>
                <xsl:copy-of select="form/location/all/select/*"/>
              </select>
              <xsl:text> </xsl:text>
              <!-- allow for toggling between the preferred and all location listings if preferred
                   locations exist -->
              <xsl:if test="form/location/preferred/select/option">
                <input type="radio" name="toggleLocationLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredLocationList','shown');changeClass('bwAllLocationList','invisible');"/>
                <xsl:copy-of select="$bwStr-AEEF-Preferred"/>
                <input type="radio" name="toggleLocationLists" value="all" onclick="changeClass('bwPreferredLocationList','invisible');changeClass('bwAllLocationList','shown');"/>
                <xsl:copy-of select="$bwStr-AEEF-All"/>
              </xsl:if>
            </span>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/location/all/select/option[@selected]"/>
            </xsl:if>
          </td>
        </tr>

        <xsl:if test="form/location/address and $canEdit = 'true'">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text">
                <span class="bold"><xsl:copy-of select="$bwStr-AEEF-Or"/></span><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Add"/></span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-Address"/>
            </td>
            <td>
              <xsl:variable name="addressFieldName" select="form/location/address/input/@name"/>
              <xsl:variable name="calLocations">
                <xsl:for-each select="form/location/all/select/option">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <input type="text" size="30" name="{$addressFieldName}" autocomplete="off" onfocus="autoComplete(this,event,new Array({$calLocations}));"/>
              <div class="fieldInfo">
                <xsl:copy-of select="$bwStr-AEEF-IncludeRoom"/>
              </div>
            </td>
          </tr>
          <tr class="optional">
            <td>
              <span class="std-text"><xsl:copy-of select="$bwStr-AEEF-LocationURL"/></span>
            </td>
            <td>
              <xsl:copy-of select="form/location/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-OptionalLocaleInfo"/></span>
            </td>
          </tr>
        </xsl:if>

        <!-- Contact -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Contact"/>
          </td>
          <td>
            <span>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <xsl:if test="form/contact/preferred/select/option">
                <select name="prefContactId" id="bwPreferredContactList">
                  <option value="">
                    <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                  </option>option>
                  <xsl:copy-of select="form/contact/preferred/select/*"/>
                </select>
              </xsl:if>
              <select name="allContactId" id="bwAllContactList">
                <xsl:if test="form/contact/preferred/select/option">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <option value="">
                  <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                </option>
                <xsl:copy-of select="form/contact/all/select/*"/>
              </select>
              <xsl:text> </xsl:text>
              <!-- allow for toggling between the preferred and all contacts listings if preferred
                   contacts exist -->
              <xsl:if test="form/contact/preferred/select/option">
                <input type="radio" name="toggleContactLists" value="preferred" checked="checked" onclick="changeClass('bwPreferredContactList','shown');changeClass('bwAllContactList','invisible');"/>
                <xsl:copy-of select="$bwStr-AEEF-Preferred"/>
                <input type="radio" name="toggleContactLists" value="all" onclick="changeClass('bwPreferredContactList','invisible');changeClass('bwAllContactList','shown');"/>
                <xsl:copy-of select="$bwStr-AEEF-All"/>
              </xsl:if>
            </span>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/contact/all/select/option[@selected]"/>
            </xsl:if>
          </td>
        </tr>

        <xsl:if test="$canEdit = 'false'">
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-Creator"/>
            </td>
            <td>
              <xsl:call-template name="substring-afterLastInstanceOf">
                <xsl:with-param name="string" select="creator"/>
                <xsl:with-param name="char">/</xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>

        <!-- Topical area  -->
        <!-- By selecting one or more of these, appropriate categories will be set on the event -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-TopicalArea"/>
          </td>
          <td>
            <ul class="aliasTree">
              <xsl:apply-templates select="form/subscriptions/calsuite/calendars/calendar/calendar[isTopicalArea = 'true']" mode="showEventFormAliases">
                <xsl:with-param name="root">false</xsl:with-param>
              </xsl:apply-templates>
            </ul>
          </td>
        </tr>

        <!--  Category  -->
        <!--
          direct setting of categories is deprecated; if you want to reenable, uncomment this block - but
          be forwarned that this will have peculiar consequences if using the submissions client
          -->
        <!--
        <tr>
          <td class="fieldName">
            Categories:
          </td>
          <td>
            <a href="javascript:toggleVisibility('bwEventCategories','visible')">
              show/hide categories
            </a>
            <div id="bwEventCategories" class="invisible">
              <xsl:if test="form/categories/preferred/category and /bedework/creating='true'">
                <input type="radio" name="categoryCheckboxes" value="preferred" checked="checked" onclick="changeClass('preferredCategoryCheckboxes','shown');changeClass('allCategoryCheckboxes','invisible');"/>preferred
                <input type="radio" name="categoryCheckboxes" value="all" onclick="changeClass('preferredCategoryCheckboxes','invisible');changeClass('allCategoryCheckboxes','shown')"/>all<br/>
                <table cellpadding="0" id="preferredCategoryCheckboxes">
                  <tr>
                    <xsl:variable name="catCount" select="count(form/categories/preferred/category)"/>
                    <td>
                      <xsl:for-each select="form/categories/preferred/category[position() &lt;= ceiling($catCount div 2)]">
                        <xsl:sort select="value" order="ascending"/>
                        <input type="checkbox" name="catUid">
                          <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="id">pref-<xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="uid"/>','all-<xsl:value-of select="uid"/>')</xsl:attribute>
                          <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="value"/>
                        </input><br/>
                      </xsl:for-each>
                    </td>
                    <td>
                      <xsl:for-each select="form/categories/preferred/category[position() &gt; ceiling($catCount div 2)]">
                        <xsl:sort select="value" order="ascending"/>
                        <input type="checkbox" name="catUid">
                          <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="id">pref-<xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="onchange">setCatChBx('pref-<xsl:value-of select="uid"/>','all-<xsl:value-of select="uid"/>')</xsl:attribute>
                          <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="value"/>
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
                      <input type="checkbox" name="catUid">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <xsl:if test="/bedework/creating='true'">
                          <xsl:attribute name="id">all-<xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="uid"/>','pref-<xsl:value-of select="uid"/>')</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="uid = ../../current//category/uid">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                          <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:if>
                        <xsl:value-of select="value"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                  <td>
                    <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                      <input type="checkbox" name="catUid">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <xsl:if test="/bedework/creating='true'">
                          <xsl:attribute name="id">all-<xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:attribute name="onchange">setCatChBx('all-<xsl:value-of select="uid"/>','pref-<xsl:value-of select="uid"/>')</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="uid = ../../current//category/uid">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                          <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:if>
                        <xsl:value-of select="value"/>
                      </input><br/>
                    </xsl:for-each>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        -->
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

        <xsl:if test="form/contact/name and $canEdit = 'true'">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text">
                <span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactName"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/name/*"/>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactPhone"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/phone/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactURL"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactEmail"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/email/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span> test
              <div id="contactEmailAlert">&#160;</div> <!-- space for email warning -->
            </td>
          </tr>
        </xsl:if>
      </table>
      <xsl:if test="not(starts-with(form/calendar/event/path,$submissionsRootUnencoded))">
        <!-- don't create two instances of the submit buttons on pending events;
             the publishing buttons require numerous unique ids -->
        <xsl:call-template name="submitEventButtons">
          <xsl:with-param name="eventTitle" select="$eventTitle"/>
          <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
          <xsl:with-param name="canEdit" select="$canEdit"/>
        </xsl:call-template>
      </xsl:if>
    </form>
  </xsl:template>

  <xsl:template match="calendar" mode="showEventFormAliases">
    <xsl:param name="root">false</xsl:param>
    <li>
      <xsl:if test="$root != 'true'">
        <!-- hide the root calendar. -->
        <xsl:choose>
          <xsl:when test="calType = '7' or calType = '8'">
            <!-- we've hit an unresolvable alias; stop descending -->
            <input type="checkbox" name="forDiplayOnly" disabled="disabled"/>
            <em><xsl:value-of select="summary"/>?</em>
          </xsl:when>
          <xsl:when test="calType = '0'">
            <!-- no direct selecting of folders or folder aliases: we only want users to select the
                 underlying calendar aliases -->
            <img src="{$resourcesRoot}/resources/catIcon.gif" width="13" height="13" alt="folder" class="folderForAliasTree" border="0"/>
            <xsl:value-of select="summary"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="virtualPath">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:variable>
            <xsl:variable name="displayName" select="summary"/>
            <input type="checkbox" name="alias" onclick="toggleBedeworkXProperty('X-BEDEWORK-ALIAS','{$displayName}','{$virtualPath}',this.checked)">
              <xsl:attribute name="value"><xsl:value-of select="$virtualPath"/></xsl:attribute>
              <xsl:if test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-ALIAS/values/text"><xsl:attribute name="checked"><xsl:value-of select="checked"/></xsl:attribute></xsl:if>
              <xsl:if test="path = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text"><xsl:attribute name="checked"><xsl:value-of select="checked"/></xsl:attribute></xsl:if>
              <xsl:if test="/bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text = substring-after(aliasUri,'bwcal://')"><xsl:attribute name="checked"><xsl:value-of select="checked"/></xsl:attribute></xsl:if>
            </input>
            <xsl:choose>
              <xsl:when test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-ALIAS/values/text">
                <strong><xsl:value-of select="summary"/></strong>
              </xsl:when>
              <xsl:when test="path = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text">
                <strong><xsl:value-of select="summary"/></strong>
              </xsl:when>
              <xsl:when test="/bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text = substring-after(aliasUri,'bwcal://')">
                <strong><xsl:value-of select="summary"/></strong>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="summary"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <!-- Return topical areas and all underlying calendars.
           Check for topical areas only if the subscription is owned by the calendar suite:
           If the subscription points out to a calendar or folder in another tree,
           return the branch regardless of the topical area setting.  -->
      <xsl:if test="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]">
        <ul>
          <xsl:apply-templates select="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]" mode="showEventFormAliases"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="submitEventButtons">
    <xsl:param name="eventTitle"/>
    <xsl:param name="eventUrlPrefix"/>
    <xsl:param name="canEdit"/>
    <div class="submitBox">
      <xsl:choose>
        <!-- xsl:when test="starts-with(form/calendar/event/path,$submissionsRootUnencoded)"-->
        <xsl:when test="/bedework/page = 'modEventPending'">
          <div class="right">
            <input type="submit" name="delete" value="{$bwStr-SEBu-DeleteEvent}"/>
          </div>
          <!-- no need for a publish box in the single calendar model unless we have more than one calendar; -->
          <xsl:choose>
            <xsl:when test="count(form/calendar/all/select/option) &gt; 1"><!-- test for the presence of more than one publishing calendar -->
              <div id="publishBox" class="invisible">
                <div id="publishBoxCloseButton">
                  <a href="javascript:resetPublishBox('calendarId')">
                    <img src="{$resourcesRoot}/resources/closeIcon.gif" width="20" height="20" alt="close" border="0"/>
                  </a>
                </div>
                <strong><xsl:copy-of select="$bwStr-SEBu-SelectPublishCalendar"/></strong><br/>
                <select name="calendarId" id="calendarId" onchange="this.form.newCalPath.value = this.value;">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                    <xsl:copy-of select="$bwStr-SEBu-Select"/>
                  </option>
                  <xsl:for-each select="form/calendar/all/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          <xsl:copy-of select="$bwStr-SEBu-SubmittedEvents"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
                <input type="submit" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}">
                  <xsl:attribute name="onclick">doPublishEvent(this.form.newCalPath.value,'<xsl:value-of select="$eventTitle"/>','<xsl:value-of select="$eventUrlPrefix"/>',this.form);changeClass('publishBox','invisible');</xsl:attribute>
                </input>
                <xsl:if test="$portalFriendly = 'false'">
                  <br/>
                  <span id="calDescriptionsLink">
                    <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')"><xsl:copy-of select="$bwStr-SEBu-CalendarDescriptions"/></a>
                  </span>
                </xsl:if>
              </div>
              <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-UpdateEvent}"/>
              <input type="button" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}" onclick="changeClass('publishBox','visible')"/>
              <input type="submit" name="cancelled" value="{$bwStr-SEBu-Cancel}"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- we are using the single calendar model for public events -->
              <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-UpdateEvent}"/>
              <input type="submit" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}">
                <xsl:attribute name="onclick">doPublishEvent('<xsl:value-of select="form/calendar/all/select/option/@value"/>','<xsl:value-of select="$eventTitle"/>','<xsl:value-of select="$eventUrlPrefix"/>',this.form);</xsl:attribute>
              </input>
              <input type="submit" name="cancelled" value="{$bwStr-SEBu-Cancel}"/>
            </xsl:otherwise>
          </xsl:choose>
          <span class="claimButtons">
            <xsl:choose>
              <xsl:when test="form/xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text = /bedework/userInfo/group">
                <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-ReleaseEvent}" onclick="releasePendingEvent();"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-ClaimEvent}">
                  <xsl:attribute name="onclick">claimPendingEvent('<xsl:value-of select="/bedework/userInfo/group"/>','<xsl:value-of select="/bedework/userInfo/currentUser"/>');</xsl:attribute>
                </input>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/bedework/creating='true'">
              <input type="submit" name="addEvent" value="{$bwStr-SEBu-AddEvent}"/>
              <input type="submit" name="cancelled" value="{$bwStr-SEBu-Cancel}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$canEdit = 'true'">
                <div class="right">
                  <input type="submit" name="delete" value="{$bwStr-SEBu-DeleteEvent}"/>
                </div>
              </xsl:if>
              <input type="submit" name="updateEvent" value="{$bwStr-SEBu-UpdateEvent}"/>
              <input type="submit" name="cancelled" value="{$bwStr-SEBu-Cancel}"/>
              <xsl:if test="form/recurringEntity != 'true' and recurrenceId = '' and $canEdit = 'true'">
                <!-- cannot duplicate recurring events for now -->
                <input type="submit" name="copy" value="{$bwStr-SEBu-CopyEvent}"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
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
    <option value="0"><xsl:copy-of select="$bwStr-RCPO-None"/></option>
    <option value="1"><xsl:copy-of select="$bwStr-RCPO-TheFirst"/></option>
    <option value="2"><xsl:copy-of select="$bwStr-RCPO-TheSecond"/></option>
    <option value="3"><xsl:copy-of select="$bwStr-RCPO-TheThird"/></option>
    <option value="4"><xsl:copy-of select="$bwStr-RCPO-TheFourth"/></option>
    <option value="5"><xsl:copy-of select="$bwStr-RCPO-TheFifth"/></option>
    <option value="-1"><xsl:copy-of select="$bwStr-RCPO-TheLast"/></option>
    <option value=""><xsl:copy-of select="$bwStr-RCPO-Every"/></option>
  </xsl:template>

  <xsl:template name="buildRecurFields">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <xsl:param name="name"/>
    <div class="invisible">
      <xsl:attribute name="id"><xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current"/></xsl:attribute>
      <xsl:copy-of select="$bwStr-BuRF-And"/>
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
          <xsl:copy-of select="$bwStr-Cloc-Bedework24HourClock"/>
        </h2>
        <div id="bwClockDateTypeIndicator">
          <xsl:copy-of select="$bwStr-Cloc-Type"/>
        </div>
        <div id="bwClockTime">
          <xsl:copy-of select="$bwStr-Cloc-SelectTime"/>
        </div>
        <div id="bwClockSwitch">
          <xsl:copy-of select="$bwStr-Cloc-Switch"/>
        </div>
        <div id="bwClockCloseText">
          <xsl:copy-of select="$bwStr-Cloc-Close"/>
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
        <h2><xsl:copy-of select="$bwStr-DsEv-OkayToDelete"/></h2>

        <xsl:if test="/bedework/page='deleteEventConfirm'">
          <p style="width: 400px;"><xsl:copy-of select="$bwStr-DsEv-NoteDontEncourageDeletes"/></p>
        </xsl:if>

        <xsl:variable name="eventDatesForEmail">
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text><!--
       --><xsl:if test="start/allday = 'false'"><xsl:value-of select="start/time"/></xsl:if><!--
       --><xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if><!--
       --><xsl:if test="end/longdate != start/longdate"><xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text></xsl:if><!--
       --><xsl:choose>
            <xsl:when test="start/allday = 'true'"><xsl:copy-of select="$bwStr-DsEv-AllDay"/></xsl:when>
            <xsl:when test="end/longdate != start/longdate"><xsl:value-of select="end/time"/></xsl:when>
            <xsl:when test="end/time != start/time"><xsl:value-of select="end/time"/></xsl:when>
          </xsl:choose><!--
     --></xsl:variable>

        <div id="confirmButtons">
          <form method="post">
            <xsl:choose>
              <xsl:when test="/bedework/page = 'deleteEventConfirmPending'">
                <xsl:attribute name="action"><xsl:value-of select="$event-deletePending"/></xsl:attribute>
                <xsl:attribute name="onsubmit">doRejectEvent(this,'<xsl:value-of select="summary"/>','<xsl:value-of select="$eventDatesForEmail"/>');</xsl:attribute>
                <!-- Setup email notification fields -->
                <input type="hidden" id="submitNotification" name="submitNotification" value="true"/>
                <!-- "from" should be a preference: hard code it for now -->
                <input type="hidden" id="snfrom" name="snfrom" value="bedework@yoursite.edu"/>
                <input type="hidden" id="snsubject" name="snsubject" value=""/>
                <input type="hidden" id="sntext" name="sntext" value=""/>
                <div id="bwEmailBox">
                  <p>
                    <strong><xsl:copy-of select="$bwStr-DsEv-YouDeletingPending"/></strong><br/>
                    <input type="checkbox" name="notifyFlag" checked="checked" onclick="toggleVisibility('bwRejectEventReasonBox','visible');"/>
                    <xsl:copy-of select="$bwStr-DsEv-SendNotification"/>
                  </p>
                  <div id="bwRejectEventReasonBox">
                    <p><xsl:copy-of select="$bwStr-DsEv-Reason"/><br/>
                      <textarea name="reason" rows="4" cols="60">
                        <xsl:text> </xsl:text>
                      </textarea>
                    </p>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="action"><xsl:value-of select="$event-delete"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="delete" value="{$bwStr-DsEv-YesDeleteEvent}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DsEv-Cancel}"/>
            <input type="hidden" name="calPath" value="{$calPath}"/>
            <input type="hidden" name="guid" value="{$guid}"/>
            <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
          </form>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-DsEv-EventInfo"/></h2>
      </xsl:otherwise>
    </xsl:choose>

    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Title"/>
        </th>
        <td>
          <strong><xsl:value-of select="summary"/></strong>
        </td>
      </tr>

      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-When"/>
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
              <span class="time"><em><xsl:copy-of select="$bwStr-DsEv-AllDay"/></em></span>
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
          <xsl:copy-of select="$bwStr-DsEv-TopicalAreas"/>
        </th>
        <td>
           <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
             <xsl:call-template name="substring-afterLastInstanceOf">
               <xsl:with-param name="string" select="values/text"/>
               <xsl:with-param name="char">/</xsl:with-param>
             </xsl:call-template><br/>
           </xsl:for-each>
        </td>
      </tr>

      <!--  Description  -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Description"/>
        </th>
        <td>
          <xsl:value-of select="description"/>
        </td>
      </tr>
      <!-- Cost -->
      <tr class="optional">
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Price"/>
        </th>
        <td>
          <xsl:value-of select="cost"/>
        </td>
      </tr>
      <!-- Url -->
      <tr class="optional">
        <th>
          <xsl:copy-of select="$bwStr-DsEv-URL"/>
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
          <xsl:copy-of select="$bwStr-DsEv-Location"/>
        </th>
        <td>
          <xsl:value-of select="location/address"/><br/>
          <xsl:value-of select="location/subaddress"/>
        </td>
      </tr>

      <!-- Contact -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Contact"/>
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
          <xsl:copy-of select="$bwStr-DsEv-Owner"/>
        </th>
        <td>
          <strong><xsl:value-of select="creator"/></strong>
        </td>
      </tr>

      <!-- Submitter -->
      <xsl:if test="xproperties/X-BEDEWORK-SUBMITTEDBY">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-DsEv-Submitter"/>
          </th>
          <td>
            <strong><xsl:value-of select="xproperties/X-BEDEWORK-SUBMITTEDBY/values/text"/></strong>
          </td>
        </tr>
      </xsl:if>

      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Calendar"/>
        </th>
        <td>
          <xsl:value-of select="calendar/path"/>
        </td>
      </tr>

      <!--  Categories  -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Categories"/>
        </th>
        <td>
          <xsl:for-each select="categories/category">
            <xsl:value-of select="word"/><br/>
          </xsl:for-each>
        </td>
      </tr>

    </table>

    <xsl:if test="/bedework/page != 'deleteEventConfirmPending'">
      <p>
        <xsl:variable name="userPath"><xsl:value-of select="/bedework/syspars/userPrincipalRoot"/>/<xsl:value-of select="/bedework/userInfo/user"/></xsl:variable>
        <input type="button" name="return" onclick="javascript:location.replace('{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')">
          <xsl:choose>
            <xsl:when test="$userPath = creator or /bedework/userInfo/superUser = 'true'">
              <xsl:attribute name="value">Edit event</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="value"><xsl:copy-of select="$bwStr-DsEv-TagEvent"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </input>
        <input type="button" name="return" value="Back" onclick="javascript:history.back()"/>
     </p>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ Contacts ++++++++++++++++++++-->
  <xsl:template name="contactList">
    <h2><xsl:copy-of select="$bwStr-Cont-ManageContacts"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-Cont-SelectContact"/>
      <input type="button" name="return" value="{$bwStr-Cont-AddNewContact}" onclick="javascript:location.replace('{$contact-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-Cont-Name"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-Phone"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-Email"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-URL"/></th>
      </tr>

      <xsl:for-each select="/bedework/contacts/contact">
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
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
      <h2><xsl:copy-of select="$bwStr-MdCo-ContactInfo"/></h2>

      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MdCo-ContactName"/>
          </td>
          <td>
            <input type="text" name="contactName.value" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/name/input/@value"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-ContactName-Placeholder"/></span>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MdCo-ContactPhone"/>
          </td>
          <td>
            <input type="text" name="contact.phone" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/phone/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MdCo-ContactPhone-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <xsl:copy-of select="$bwStr-MdCo-ContactURL"/>
          </td>
          <td>
            <input type="text" name="contact.link" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/link/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MdCo-ContactURL-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <xsl:copy-of select="$bwStr-MdCo-ContactEmail"/>
          </td>
          <td>
            <input type="text" name="contact.email" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/email/input/@value"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <xsl:choose>
          <xsl:when test="/bedework/creating='true'">
            <input type="submit" name="addContact" value="{$bwStr-DCoC-AddContact}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DCoC-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateContact" value="{$bwStr-DCoC-UpdateContact}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DCoC-Cancel}"/>
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-DCoC-DeleteContact}"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="deleteContactConfirm">
    <h2><xsl:copy-of select="$bwStr-DCoC-OKToDelete"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Name"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/name" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Phone"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/phone" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Email"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/email" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-URL"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/link" />
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="contactReferenced">
    <h2><xsl:copy-of select="$bwStr-DCoR-ContactInUse"/></h2>

    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Name"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/name" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Phone"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/phone" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Email"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/email" />
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-URL"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/link" />
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DCoR-ContactInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DCoR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the contact -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DCoR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the contact -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DCoR-Events"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>

  </xsl:template>

   <!--+++++++++++++++ Locations ++++++++++++++++++++-->
  <xsl:template name="locationList">
    <h2><xsl:copy-of select="$bwStr-LoLi-ManageLocations"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-LoLi-SelectLocationToUpdate"/>
      <input type="button" name="return" value="{$bwStr-LoLi-AddNewLocation}" onclick="javascript:location.replace('{$location-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-LoLi-Address"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-SubAddress"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-URL"/></th>
      </tr>

      <xsl:for-each select="/bedework/locations/location">
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
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
        <h2><xsl:copy-of select="$bwStr-MoLo-AddLocation"/></h2>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoLo-UpdateLocation"/></h2>
      </xsl:otherwise>
    </xsl:choose>

    <form action="{$location-update}" method="post">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoLo-Address"/>
          </td>
          <td>
            <input type="text" name="locationAddress.value" size="80">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/address/input/@value"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Address-Placeholder"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <xsl:copy-of select="$bwStr-MoLo-SubAddress"/>
          </td>
          <td>
            <input type="text" name="locationSubaddress.value" size="80">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subaddress/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubAddress-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <xsl:copy-of select="$bwStr-MoLo-LocationURL"/>
          </td>
          <td>
            <input type="text" name="location.link" size="80">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/link/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-LocationURL-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <xsl:choose>
          <xsl:when test="/bedework/creating='true'">
            <input type="submit" name="addLocation" value="{$bwStr-MoLo-AddLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateLocation" value="{$bwStr-MoLo-UpdateLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-MoLo-DeleteLocation}"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="deleteLocationConfirm">
    <h2><xsl:copy-of select="$bwStr-DeLC-OkDeleteLocation"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
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

  <xsl:template name="locationReferenced">
    <h2><xsl:copy-of select="$bwStr-DeLR-LocationInUse"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DeLR-LocationInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DeLR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Events"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>


  <!--+++++++++++++++ Categories ++++++++++++++++++++-->
  <xsl:template name="categoryList">
    <h2><xsl:copy-of select="$bwStr-CtgL-ManageCategories"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-CtgL-SelectCategory"/>
      <input type="button" name="return" value="{$bwStr-CtgL-AddNewCategory}" onclick="javascript:location.replace('{$category-initAdd}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CtgL-Keyword"/></th>
        <th><xsl:copy-of select="$bwStr-CtgL-Description"/></th>
      </tr>

      <xsl:for-each select="/bedework/categories/category">
        <xsl:variable name="catUid" select="uid"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <a href="{$category-fetchForUpdate}&amp;catUid={$catUid}">
              <xsl:value-of select="value"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <h2><xsl:copy-of select="$bwStr-MoCa-AddCategory"/></h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoCa-Keyword"/>
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40"/>
              </td>
            </tr>
            <tr class="optional">
              <td>
                <xsl:copy-of select="$bwStr-MoCa-Description"/>
              </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:text> </xsl:text>
                </textarea>
              </td>
            </tr>
          </table>
          <div class="submitBox">
            <input type="submit" name="addCategory" value="{$bwStr-MoCa-AddCategory}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoCa-Cancel}"/>
          </div>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoCa-UpdateCategory"/></h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoCa-Keyword"/>
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="normalize-space(/bedework/currentCategory/category/value)"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr class="optional">
              <td>
                <xsl:copy-of select="$bwStr-MoCa-Description"/>
              </td>
              <td>
                <textarea name="categoryDesc.value" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedework/currentCategory/category/description)"/>
                  <xsl:if test="/bedework/currentCategory/category/description = ''"><xsl:text> </xsl:text></xsl:if>
                </textarea>
              </td>
            </tr>
          </table>

          <div class="submitBox">
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-MoCa-DeleteCategory}"/>
            </div>
            <input type="submit" name="updateCategory" value="{$bwStr-MoCa-UpdateCategory}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoCa-Cancel}"/>
          </div>
        </form>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <xsl:template name="deleteCategoryConfirm">
    <h2><xsl:copy-of select="$bwStr-DeCC-CategoryDeleteOK"/></h2>


    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Keyword"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/value"/>
        </td>
      </tr>
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Description"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="updateCategory" value="{$bwStr-DeCC-YesDelete}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DeCC-NoCancel}"/>
    </form>
  </xsl:template>

  <xsl:template name="categoryReferenced">
    <h2><xsl:copy-of select="$bwStr-DeCR-CategoryInUse"/></h2>


    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Keyword"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/value"/>
        </td>
      </tr>
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Description"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DeCR-CategoryInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DeCR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the category -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DeCR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the category -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DeCR-Events"/></h4>
          <p><em><xsl:copy-of select="$bwStr-DeCR-EventsNote"/></em></p>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>

  </xsl:template>

  <!-- form used for selecting categories in calendar and pref forms -->
  <xsl:template name="categorySelectionWidget">
    <!-- show the selected categories -->
    <ul class="catlist">
      <xsl:for-each select="/bedework/categories/current/category">
        <xsl:sort select="value" order="ascending"/>
        <li>
          <input type="checkbox" name="catUid" checked="checked">
            <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
          </input>
          <xsl:value-of select="value"/>
        </li>
      </xsl:for-each>
    </ul>
    <a href="javascript:toggleVisibility('calCategories','visible')">
      <xsl:copy-of select="$bwStr-CaSW-ShowHideUnusedCategories"/>
    </a>
    <div id="calCategories" class="invisible">
      <ul class="catlist">
        <xsl:for-each select="/bedework/categories/all/category">
          <xsl:sort select="value" order="ascending"/>
          <!-- don't duplicate the selected categories -->
          <xsl:if test="not(uid = ../../current//category/uid)">
            <li>
              <input type="checkbox" name="catUid">
                <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
              </input>
              <xsl:value-of select="value"/>
            </li>
          </xsl:if>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

<!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <xsl:template match="calendars" mode="calendarCommon">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h2><xsl:copy-of select="$bwStr-Cals-Collections"/></h2>
          <form name="getCollection" id="bwGetCollectionForm" action="{$calendar-fetchForUpdate}">
            <xsl:copy-of select="$bwStr-Cals-SelectByPath"/><br/>
            <input type="text" size="15" name="calPath"/>
            <input type="submit" value="{$bwStr-Cals-Go}"/>
          </form>
          <h4 class="calendarTreeTitle"><xsl:copy-of select="$bwStr-Cals-PublicTree"/></h4>
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
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown</xsl:when>
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
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="calType = '0' and isSubscription = 'false'">
        <xsl:text> </xsl:text>
        <a href="{$calendar-initAdd}&amp;calPath={$calPath}" title="{$bwStr-Cals-Add}">
          <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="{$bwStr-Cals-Add}" border="0"/>
        </a>
      </xsl:if>
      <xsl:if test="calendar and isSubscription='false'">
        <ul>
          <xsl:apply-templates select="calendar" mode="listForUpdate">
            <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
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
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown</xsl:when>
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
        <xsl:if test="lastRefreshStatus &gt;= 300">
          <xsl:attribute name="title">
            <xsl:call-template name="httpStatusCodes">
              <xsl:with-param name="code"><xsl:value-of  select="lastRefreshStatus"/></xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="summary"/>
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
          <xsl:value-of select="summary"/>
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
    <h3><xsl:copy-of select="$bwStr-CuCa-AddCalFileOrSub"/></h3>
    <p class="note"><xsl:copy-of select="$bwStr-CuCa-NoteAccessSet"/></p>
    <form name="addCalForm" method="post" action="{$calendar-update}" onsubmit="setCatFilters(this);return setCalendarAlias(this);">
      <table class="common">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" size="40" onblur="setCalSummary(this.value, this.form['calendar.summary']);"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
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
        <!-- For now, colors need to be set in the calendar suite stylesheet. -->
        <!-- tr>
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
        </tr-->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Filter"/></th>
          <td>
            <input type="hidden" name="fexpr" value=""/>
            <button type="button" onclick="toggleVisibility('filterCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesFiltering"/>
            </button>
            <div id="filterCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="filterCatUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:value-of select="value"/>
                    </input>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Categories"/></th>
          <td>
            <button type="button" onclick="toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesAutoTagging"/>
            </button>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="catUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="value"/>
                    </input>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Type"/></th>
          <td>
            <!-- we will set the value of "calendarCollection on submit.
                 Value is false only for folders, so we default it to true here.  -->
            <input type="hidden" value="true" name="calendarCollection"/>
            <!-- type is defaulted to calendar.  It is changed when a typeSwitch is clicked. -->
            <input type="hidden" value="calendar" name="type" id="bwCalType"/>
            <input type="radio" value="{$bwStr-CuCa-Calendar}" name="typeSwitch" checked="checked" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Calendar
            <input type="radio" value="{$bwStr-CuCa-Folder}" name="typeSwitch" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Folder
            <input type="radio" value="{$bwStr-CuCa-Subscription}" name="typeSwitch" onclick="changeClass('subscriptionTypes','visible');setField('bwCalType',this.value);"/> Subscription
          </td>
        </tr>
      </table>

      <div id="subscriptionTypes" class="invisible">
        <h4><xsl:copy-of select="$bwStr-CuCa-SubscriptionURL"/></h4>
        <input type="hidden" value="publicTree" name="subType" id="bwSubType"/>
        <div id="subscriptionTypeExternal">
          <table class="common" id="subscriptionTypes">
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-URLToCalendar"/></th>
              <td>
                <input type="text" name="aliasUri" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-ID"/></th>
              <td>
                <input type="text" name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-Password"/></th>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
          </table>
          <p class="note">
            <xsl:copy-of select="$bwStr-CuCa-NoteAliasCanBeAdded"/><br/>
            bwcal://[path], e.g. bwcal:///public/cals/MainCal
          </p>
        </div>
      </div>

      <!-- div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div-->

      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="{$bwStr-CuCa-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:variable name="calPath" select="path"/>
    <xsl:variable name="calPathEncoded" select="encodedPath"/>

    <form name="modCalForm" method="post" onsubmit="setCatFilters(this)">
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
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifySubscription"/></h3>
          <input type="hidden" value="true" name="calendarCollection"/>
        </xsl:when>
        <xsl:when test="calType = '0'">
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifyFolder"/></h3>
          <input type="hidden" value="false" name="calendarCollection"/>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifyCalendar"/></h3>
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
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
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
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <xsl:if test="/bedework/page = 'modSubscription'">
          <tr>
            <th><xsl:copy-of select="$bwStr-CuCa-TopicalArea"/></th>
            <td>
              <input type="radio" name="calendar.isTopicalArea" value="true">
                <xsl:if test="isTopicalArea = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-True"/>
              <input type="radio" name="calendar.isTopicalArea" value="false">
                <xsl:if test="isTopicalArea = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-False"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
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
        <!-- For now, colors need to be set in the calendar suite stylesheet. -->
        <!-- tr>
          <th>Color:</th>
          <td>
            <input type="text" name="calendar.color" value="" size="40">
              <xsl:attribute name="value"><xsl:value-of select="color"/></xsl:attribute>
            </input>
          </td>
        </tr-->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Display"/></th>
          <td>
            <input type="checkbox" name="calendar.display" size="40">
              <xsl:if test="display = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-DisplayItemsInCollection"/>
          </td>
        </tr>
        <tr>
          <xsl:if test="disabled = 'true'">
            <xsl:attribute name="class">disabled</xsl:attribute>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-CuCa-Disabled"/></th>
          <td>
            <input type="radio" name="calendar.disabled" value="false">
              <xsl:if test="disabled = 'false'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-CuCa-EnabledLabel"/>
            <input type="radio" name="calendar.disabled" value="true">
              <xsl:if test="disabled = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-CuCa-DisabledLabel"/>
            <xsl:if test="disabled = 'true'">
              <span class="disabledNote">
                <xsl:copy-of select="$bwStr-CuCa-ItemIsInaccessible"/>
              </span>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Filter"/></th>
          <td>
            <input type="hidden" name="fexpr" value=""/>
            <xsl:variable name="filterUids" select="substring-before(substring-after(filterExpr,'catuid=('),')')"/>

            <!-- show the selected category filters -->
            <xsl:if test="$filterUids != ''">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <xsl:if test="contains($filterUids,uid)">
                    <li>
                      <input type="checkbox" name="filterCatUid" checked="checked">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <xsl:value-of select="value"/>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </xsl:if>

            <!-- <xsl:value-of select="filterExpr"/><xsl:if test="filterExpr !=''"><br/></xsl:if>
            <xsl:value-of select="$filterUids"/>-->

            <button type="button" onclick="toggleVisibility('filterCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesFiltering"/>
            </button>

            <div id="filterCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <!-- don't duplicate the selected filters -->
                  <xsl:if test="not(contains($filterUids,uid))">
                    <li>
                      <input type="checkbox" name="filterCatUid">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <xsl:value-of select="value"/>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Categories"/></th>
          <td>
            <!-- show the selected categories -->
            <ul class="catlist">
              <xsl:for-each select="/bedework/categories/current/category">
                <xsl:sort select="value" order="ascending"/>
                <li>
                  <input type="checkbox" name="catUid" checked="checked">
                    <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                    <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="value"/>
                  </input>
                </li>
              </xsl:for-each>
            </ul>
            <button type="button" onclick="toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesAutoTagging"/>
            </button>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <!-- don't duplicate the selected categories -->
                  <xsl:if test="not(uid = ../../current//category/uid)">
                    <li>
                      <input type="checkbox" name="catUid">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      </input>
                      <xsl:value-of select="value"/>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <xsl:if test="isSubscription = 'true'">
          <tr>
            <th><xsl:copy-of select="$bwStr-CuCa-URL"/></th>
            <td>
              <input name="aliasUri" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="aliasUri"/></xsl:attribute>
              </input>
            </td>
          </tr>
          <xsl:if test="externalSub = 'true'">
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-ID"/></th>
              <td>
                <input name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-Password"/></th>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
      </table>

      <div id="sharingBox">
        <h3><xsl:copy-of select="$bwStr-CuCa-CurrentAccess"/></h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <div class="submitBox">
        <div class="right">
          <xsl:choose>
            <xsl:when test="isSubscription='true'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-RemoveSubscription}"/>
            </xsl:when>
            <xsl:when test="calType = '0'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteFolder}"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteCalendar}"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <xsl:choose>
          <xsl:when test="isSubscription='true'">
            <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateSubscription}"/>
          </xsl:when>
          <xsl:when test="calType = '0'">
            <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateFolder}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateCalendar}"/>
          </xsl:otherwise>
        </xsl:choose>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
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
    <h3><xsl:copy-of select="$bwStr-CaLi-ManageCalendarsAndFolders"/></h3>
    <ul>

      <li><xsl:copy-of select="$bwStr-CaLi-SelectItemFromPublicTree"/></li>
      <li><xsl:copy-of select="$bwStr-CaLi-SelectThe"/>
      <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="true" border="0"/>
      <xsl:copy-of select="$bwStr-CaLi-IconToAdd"/>
        <ul>
          <li><xsl:copy-of select="$bwStr-CaLi-FoldersMayContain"/></li>
          <li><xsl:copy-of select="$bwStr-CaLi-CalendarsMayContain"/></li>
        </ul>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-CaLi-RetrieveCalendar"/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="calendarDescriptions">
    <h2><xsl:copy-of select="$bwStr-CaLD-CalendarInfo"/></h2>
    <ul>
      <li><xsl:copy-of select="$bwStr-CaLD-SelectItemFromCalendarTree"/></li>
    </ul>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="displayCalendar">
    <h2><xsl:copy-of select="$bwStr-CaLD-CalendarInfo"/></h2>
    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Name"/></th>
        <td>
          <xsl:value-of select="name"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Path"/></th>
        <td>
          <xsl:value-of select="path"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Summary"/></th>
        <td>
          <xsl:value-of select="summary"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Description"/></th>
        <td>
          <xsl:value-of select="desc"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="deleteCalendarConfirm">
    <xsl:choose>
      <xsl:when test="isSubscription = 'true'">
        <h3><xsl:copy-of select="$bwStr-CuCa-RemoveSubscription"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingSubscriptionRemoved"/>
        </p>
      </xsl:when>
      <xsl:when test="calType = '0'">
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteFolder"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingFolderDeleted"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteCalendar"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingCalendarDeleted"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" action="{$calendar-delete}" method="post">
      <input type="hidden" name="deleteContent" value="true"/>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Path"/></th>
          <td>
            <xsl:value-of select="path"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:value-of select="summary"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <div class="right">
          <xsl:choose>
            <xsl:when test="isSubscription = 'true'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesRemoveSubscription}"/>
            </xsl:when>
            <xsl:when test="calType = '0'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteFolder}"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteCalendar}"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <!-- the selectCalForEvent listing creates a calendar tree in a pop-up window -->
  <xsl:template name="selectCalForEvent">
    <div id="calTreeBlock">
      <h2><xsl:copy-of select="$bwStr-SCFE-SelectCal"/></h2>
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
      <h4><xsl:copy-of select="$bwStr-SCFE-Calendars"/></h4>
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
        <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-Cals-Calendar"/></xsl:otherwise>
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
              <xsl:value-of select="summary"/>
            </strong>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
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
          <h3><xsl:copy-of select="$bwStr-CaMv-MoveCalendar"/></h3>

          <table class="eventFormTable">
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-CurrentPath"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/path"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Name"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/name"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-MailingListID"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/mailListId"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Summary"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/summary"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Description"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/desc"/>
              </td>
            </tr>
          </table>
        </td>
        <td class="bwCalsForMove">
          <p><xsl:copy-of select="$bwStr-CaMv-SelectNewParentFolder"/></p>
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
      <span class="nowrap"><input type="radio" name="whoType" value="user" checked="checked"/><xsl:copy-of select="$bwStr-ScAF-User"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="group"/><xsl:copy-of select="$bwStr-ScAF-Group"/></span>
    </p>
    <p>
      <strong><xsl:copy-of select="$bwStr-ScAF-Or"/></strong>
      <span class="nowrap"><input type="radio" name="whoType" value="owner"/><xsl:copy-of select="$bwStr-ScAF-Owner"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="auth"/><xsl:copy-of select="$bwStr-ScAF-AuthenticatedUsers"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="other"/><xsl:copy-of select="$bwStr-ScAF-Anyone"/></span>
    </p>

    <input type="hidden" name="how" value="S"/>
    <dl>
      <dt>
        <input type="checkbox" name="howSetter" value="S" checked="checked" onchange="toggleScheduleHow(this.form,this)"/><xsl:copy-of select="$bwStr-ScAF-AllScheduling"/>
      </dt>
      <dd>
        <input type="checkbox" name="howSetter" value="t" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedReqs"/><br/>
        <input type="checkbox" name="howSetter" value="y" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedReplies"/><br/>
        <input type="checkbox" name="howSetter" value="s" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-FreeBusyReqs"/>
      </dd>
    </dl>

    <input type="submit" name="modPrefs" value="{$bwStr-ScAF-Update}"/>
    <input type="submit" name="cancelled" value="{$bwStr-ScAF-Cancel}"/>
  </xsl:template>

  <xsl:template match="acl" mode="currentAccess">
    <xsl:param name="action"/> <!-- required -->
    <xsl:param name="calPathEncoded"/> <!-- optional (for entities) -->
    <xsl:param name="guid"/> <!-- optional (for entities) -->
    <xsl:param name="recurrenceId"/> <!-- optional (for entities) -->
    <xsl:param name="what"/> <!-- optional (for scheduling only) -->
    <xsl:param name="calSuiteName"/> <!-- optional (for calendar suites only) -->
    <h3><xsl:copy-of select="$bwStr-ACLs-CurrentAccess"/></h3>
      <table class="common scheduling">
        <tr>
          <th><xsl:copy-of select="$bwStr-ACLs-Entry"/></th>
          <th><xsl:copy-of select="$bwStr-ACLs-Access"/></th>
          <th><xsl:copy-of select="$bwStr-ACLs-InheritedFrom"/></th>
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
            <xsl:when test="contains($who,/bedework/syspars/userPrincipalRoot)"><xsl:copy-of select="$bwStr-ACLs-User"/></xsl:when>
            <xsl:when test="contains($who,/bedework/syspars/groupPrincipalRoot)"><xsl:copy-of select="$bwStr-ACLs-Group"/></xsl:when>
            <xsl:when test="$who='authenticated'"><xsl:copy-of select="$bwStr-ACLs-Auth"/></xsl:when>
            <xsl:when test="$who='unauthenticated'"><xsl:copy-of select="$bwStr-ACLs-UnAuth"/></xsl:when>
            <xsl:when test="$who='all'"><xsl:copy-of select="$bwStr-ACLs-All"/></xsl:when>
            <xsl:when test="invert/principal/property/owner"><xsl:copy-of select="$bwStr-ACLs-Other"/></xsl:when>
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
                <xsl:copy-of select="$bwStr-ACLs-Anyone"/>
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
              <xsl:copy-of select="$bwStr-ACLs-Grant"/>
              <span class="grant">
                <xsl:for-each select="grant/privilege/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span><br/>
            </xsl:if>
            <xsl:if test="deny">
              <xsl:copy-of select="$bwStr-ACLs-Deny"/>
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
                <xsl:copy-of select="$bwStr-ACLs-Local"/>
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

      calType 7 and 8 will only be returned when a link to an alias is broken.
      The system will instead return the underlying calendar type (down the tree).
      Check the isSubscription flag to see if a collection is an alias and set
      icons etc. based on that + the underlying calType.
  -->

  <xsl:template match="calendars" mode="subscriptions">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3><xsl:copy-of select="$bwStr-Subs-Subscriptions"/></h3>
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
            <xsl:when test="/bedework/page='deleteSubConfirm'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="deleteSubConfirm"/>
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
    <h3><xsl:copy-of select="$bwStr-Subs-ManagingSubscriptions"/></h3>
    <ul>
      <li>
        <xsl:copy-of select="$bwStr-Subs-SelectAnItem"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-Subs-SelectThe"/>
        <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="true" border="0"/>
        <xsl:copy-of select="$bwStr-Subs-IconToAdd"/>
      </li>
    </ul>
    <xsl:copy-of select="$bwStr-Subs-TopicalAreasNote"/>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdateSubscription">
    <xsl:param name="root">false</xsl:param>
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown</xsl:when>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
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
          <xsl:if test="lastRefreshStatus &gt;= 300">
            <xsl:attribute name="title">
              <xsl:call-template name="httpStatusCodes">
                <xsl:with-param name="code"><xsl:value-of  select="lastRefreshStatus"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
            <xsl:value-of select="summary"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calType = '0' and isSubscription='false'">
        <xsl:text> </xsl:text>
        <a href="{$subscriptions-initAdd}&amp;calPath={$calPath}" title="{$bwStr-Cals-AddSubscription}">
          <img src="{$resourcesRoot}/resources/calAddIcon.gif" width="13" height="13" alt="{$bwStr-Cals-AddSubscription}" border="0"/>
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
    <h3><xsl:copy-of select="$bwStr-CuCa-AddSubscription"/></h3>
    <p class="note"><xsl:copy-of select="$bwStr-CuCa-AccessNote"/></p>
    <form name="addCalForm" method="post" action="{$subscriptions-update}" onsubmit="setCatFilters(this);return setCalendarAlias(this);">
      <table class="common">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" size="40"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-TopicalArea"/></th>
          <td>
            <input type="radio" name="calendar.isTopicalArea" value="true" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-True"/>
            <input type="radio" name="calendar.isTopicalArea" value="false"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-False"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
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
        <!-- For now, colors need to be set in the calendar suite stylesheet. -->
        <!-- tr>
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
        </tr-->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Filter"/></th>
          <td>
            <input type="hidden" name="fexpr" value=""/>
            <button type="button" onclick="toggleVisibility('filterCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesFiltering"/>
            </button>
            <div id="filterCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="filterCatUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:value-of select="value"/>
                    </input>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Categories"/></th>
          <td>
            <button type="button" onclick="toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesAutoTagging"/>
            </button>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="catUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="value"/>
                    </input>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Type"/></th>
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
            <input type="radio" name="subTypeSwitch" value="folder" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','invisible');setField('bwType',this.value);"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-FOLDER"/>
            <input type="radio" name="subTypeSwitch" value="public" checked="checked" onclick="changeClass('subscriptionTypePublic','visible');changeClass('subscriptionTypeExternal','invisible');setField('bwSubType',this.value);"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-PublicAlias"/>
            <input type="radio" name="subTypeSwitch" value="external" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','visible');setField('bwSubType',this.value);"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-URL"/>

              <div id="subscriptionTypePublic">
                <input type="hidden" value="" name="publicAliasHolder" id="publicAliasHolder"/>
                <div id="bwPublicCalDisplay">
                  <button type="button" onclick="showPublicCalAliasTree();"><xsl:copy-of select="$bwStr-CuCa-SelectPublicCalOrFolder"/></button>
                </div>
                <ul id="publicSubscriptionTree" class="invisible">
                  <xsl:apply-templates select="/bedework/publicCalendars/calendar" mode="selectCalForPublicAliasCalTree"/>
                </ul>
              </div>

              <div class="invisible" id="subscriptionTypeExternal">
                <table class="common">
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-URLToCalendar"/></th>
                    <td>
                      <input type="text" name="aliasUriHolder" id="aliasUriHolder" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-ID"/></th>
                    <td>
                      <input type="text" name="remoteId" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-Password"/></th>
                    <td>
                      <input type="password" name="remotePw" value="" size="40"/>
                    </td>
                  </tr>
                </table>
              </div>

          </td>
        </tr>
      </table>
      <!-- div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div-->

      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="{$bwStr-CuCa-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>

  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForPublicAliasCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt; 300">unknown</xsl:when>
          <xsl:when test="name='Trash'"><xsl:copy-of select="$bwStr-Cals-Trash"/></xsl:when>
          <xsl:when test="isSubscription = 'true'"><xsl:copy-of select="$bwStr-Cals-Alias"/></xsl:when>
          <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
          <xsl:otherwise><xsl:copy-of select="$bwStr-Cals-Calendar"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:variable name="calendarCollection" select="calendarCollection"/>
      <xsl:choose>
        <xsl:when test="canAlias = 'true'">
          <a href="javascript:updatePublicCalendarAlias('{$calPath}','{$calDisplay}','bw-{$calPath}','{$calendarCollection}')" id="bw-{$calPath}">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="selectCalForPublicAliasCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="deleteSubConfirm">
    <xsl:choose>
      <xsl:when test="isSubscription = 'true'">
        <h3><xsl:copy-of select="$bwStr-CuCa-RemoveSubscription"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingSubscriptionRemoved"/>
        </p>
      </xsl:when>
      <xsl:when test="calType = '0'">
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteFolder"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingFolderDeleted"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteCalendar"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingCalendarDeleted"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" action="{$subscriptions-delete}" method="post">
      <input type="hidden" name="deleteContent" value="true"/>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Path"/></th>
          <td>
            <xsl:value-of select="path"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:value-of select="summary"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <div class="right">
          <xsl:choose>
            <xsl:when test="isSubscription = 'true'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesRemoveSubscription}"/>
            </xsl:when>
            <xsl:when test="calType = '0'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteFolder}"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteCalendar}"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Views ++++++++++++++++++++-->
  <xsl:template match="views" mode="viewList">
    <!-- fix this: /user/ should be parameterized not hard-coded here -->
    <xsl:variable name="userPath">/user/<xsl:value-of select="/bedework/userInfo/user"/>/</xsl:variable>

    <h2><xsl:copy-of select="$bwStr-View-ManageViews"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-View-ViewsAreNamedAggr"/>
    </p>

    <h4><xsl:copy-of select="$bwStr-View-AddNewView"/></h4>
    <form name="addView" action="{$view-addView}" method="post">
      <input type="text" name="name" size="60"/>
      <input type="submit" value="add view" name="addview"/>
    </form>

    <h4><xsl:copy-of select="$bwStr-View-Views"/></h4>
    <table id="commonListTable" class="viewsTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-View-Name"/></th>
        <th><xsl:copy-of select="$bwStr-View-IncludedSubscriptions"/></th>
      </tr>

      <xsl:for-each select="view">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:variable name="viewName" select="name"/>
            <a href="{$view-fetchForUpdate}&amp;name={$viewName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:for-each select="path">
              <xsl:sort select="substring-after(.,$userPath)" order="ascending" case-order="upper-first"/>
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

    <h2><xsl:copy-of select="$bwStr-ModV-UpdateView"/></h2>

    <ul class="note">
      <li>
        <xsl:copy-of select="$bwStr-ModV-InSomeConfigs"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-DeletingAView"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-ToSeeUnderlying"/><xsl:text> </xsl:text>
        "<a href="{$subscriptions-fetch}" title="subscriptions to calendars"><xsl:copy-of select="$bwStr-ModV-ManageSubscriptions"/></a>"<xsl:text> </xsl:text><xsl:copy-of select="$bwStr-ModV-Tree"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-IfYouInclude"/>
      </li>
    </ul>

    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
    <table id="viewsTable">
      <tr>
        <td class="subs">
          <h3><xsl:copy-of select="$bwStr-ModV-AvailableSubscriptions"/></h3>

          <table class="subscriptionsListSubs">
            <xsl:for-each select="/bedework/calendars/calendar//calendar[isSubscription = 'true' or calType = '0']">
              <xsl:sort select="substring-after(path, $userPath)" order="ascending" case-order="upper-first"/>
              <xsl:if test="not(/bedework/currentView//path = path)">
                <tr>
                  <td>
                    <xsl:if test="calType = '0' and isSubscription = 'false'">
                      <!-- display a folder icon for local folders... -->
                      <img src="{$resourcesRoot}/resources/catIcon.gif"
                          width="13" height="13" border="0"
                          alt="folder"/>
                      <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="substring-after(path, $userPath)"/>
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
            <!-- extra row to keep the code valid if above rows are empty -->
            <tr><td>&#160;</td></tr>
          </table>
        </td>
        <td class="view">
          <h3><xsl:copy-of select="$bwStr-ModV-ActiveSubscriptions"/></h3>
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
            <!-- extra row to keep the code valid if above rows are empty -->
            <tr><td>&#160;</td></tr>
          </table>
        </td>
      </tr>
    </table>

    <div class="submitBox">
      <div class="right">
        <form name="deleteViewForm" action="{$view-fetchForUpdate}" method="post">
          <input type="submit" name="deleteButton" value="{$bwStr-ModV-DeleteView}"/>
          <input type="hidden" name="name" value="{$viewName}"/>
          <input type="hidden" name="delete" value="yes"/>
        </form>
      </div>
      <input type="button" name="return" value="{$bwStr-ModV-ReturnToViewsListing}" onclick="javascript:location.replace('{$view-fetch}')"/>
    </div>
  </xsl:template>

  <xsl:template name="deleteViewConfirm">
    <h2><xsl:copy-of select="$bwStr-DeVC-RemoveView"/></h2>

    <p>
      <xsl:copy-of select="$bwStr-DeVC-TheView"/><xsl:text> </xsl:text><strong><xsl:value-of select="/bedework/currentView/name"/></strong><xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-DeVC-WillBeRemoved"/>
    </p>
    <p class="note">
      <xsl:copy-of select="$bwStr-DeVC-BeForewarned"/>
    </p>

    <p><xsl:copy-of select="$bwStr-DeVC-Continue"/></p>

    <form name="removeView" action="{$view-remove}" method="post">
      <input type="hidden" name="name">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/currentView/name"/></xsl:attribute>
      </input>
      <input type="submit" name="delete" value="{$bwStr-DeVC-YesRemoveView}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DeVC-Cancel}"/>
    </form>

  </xsl:template>

  <!--==== UPLOAD ====-->
  <xsl:template name="upload">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying includes.js -->
    <form name="eventForm" method="post" action="{$event-upload}" id="standardForm" enctype="multipart/form-data">
      <h2><xsl:copy-of select="$bwStr-Upld-UploadICalFile"/></h2>
      <table class="common2" cellspacing="0">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-Filename"/>
          </th>
          <td align="left">
            <input type="file" name="uploadFile" size="60" />
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-IntoCalendar"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="hidden" name="newCalPath" value=""/>
            <span id="bwEventCalDisplay">
              <xsl:copy-of select="$bwStr-Upld-NoneSelected"/>
            </span>
            <xsl:text> </xsl:text>
            [<a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small"><xsl:copy-of select="$bwStr-Upld-Change"/></a>]
          </td>
        </tr>
        <tr>
          <th >
            <xsl:copy-of select="$bwStr-Upld-AffectsFreeBusy"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-AcceptEventsSettings"/><br/>
            <input type="radio" value="OPAQUE" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Yes"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Opaque"/></span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Transparent"/></span><br/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-Status"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="status" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-AcceptEventsStatus"/><br/>
            <input type="radio" value="CONFIRMED" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Confirmed"/><br/>
            <input type="radio" value="TENTATIVE" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Tentative"/><br/>
            <input type="radio" value="CANCELLED" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Canceled"/><br/>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input name="submit" type="submit" value="{$bwStr-Upld-Continue}"/>
        <input name="cancelled" type="submit" value="{$bwStr-Upld-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <!--+++++++++++++++ System Parameters (preferences) ++++++++++++++++++++-->
  <xsl:template name="modSyspars">
    <h2><xsl:copy-of select="$bwStr-MdSP-ManageSysParams"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-MdSP-DoNotChangeUnless"/>
    </p>
    <form name="systemParamsForm" action="{$system-update}" method="post">
      <table class="eventFormTable params">
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SystemName"/></th>
          <td>
            <xsl:variable name="sysname" select="/bedework/system/name"/>
            <xsl:value-of select="$sysname"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SystemNameCannotBeChanged"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultTimezone"/></th>
          <td>
            <xsl:variable name="tzid" select="/bedework/system/tzid"/>

            <select name="tzid">
              <option value="-1"><xsl:copy-of select="$bwStr-MdSP-SelectTimeZone"/></option>
              <xsl:for-each select="/bedework/timezones/timezone">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                  <xsl:if test="/bedework/system/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="name"/>
                </option>
              </xsl:for-each>
            </select>

            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultNormallyLocal"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SuperUsers"/></th>
          <td>
            <xsl:variable name="rootUsers" select="/bedework/system/rootUsers"/>
            <input value="{$rootUsers}" name="rootUsers" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-CommaSeparatedList"/>
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
          <th><xsl:copy-of select="$bwStr-MdSP-SystemID"/></th>
          <td>
            <xsl:variable name="systemid" select="/bedework/system/systemid"/>
            <xsl:value-of select="$systemid"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SystemIDNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultFBPeriod"/></th>
          <td>
            <xsl:variable name="defaultFBPeriod" select="/bedework/system/defaultFBPeriod"/>
            <input value="{$defaultFBPeriod}" name="defaultFBPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultFBPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxFBPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/maxFBPeriod"/>
            <input value="{$systemp}" name="maxFBPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxFBPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultWebCalPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/defaultWebCalPeriod"/>
            <input value="{$systemp}" name="defaultWebCalPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultWebCalPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxWebCalPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/maxWebCalPeriod"/>
            <input value="{$systemp}" name="maxWebCalPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxWebCalPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-PubCalendarRoot"/></th>
          <td>
            <xsl:variable name="publicCalendarRoot" select="/bedework/system/publicCalendarRoot"/>
            <xsl:value-of select="$publicCalendarRoot"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-PubCalendarRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserCalendarRoot"/></th>
          <td>
            <xsl:variable name="userCalendarRoot" select="/bedework/system/userCalendarRoot"/>
            <xsl:value-of select="$userCalendarRoot"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserCalendarRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="userDefaultCalendar" select="/bedework/system/userDefaultCalendar"/>
            <input value="{$userDefaultCalendar}" name="userDefaultCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-TrashCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="defaultTrashCalendar" select="/bedework/system/defaultTrashCalendar"/>
            <input value="{$defaultTrashCalendar}" name="defaultTrashCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-TrashCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserInboxDefaultName"/></th>
          <td>
            <xsl:variable name="userInbox" select="/bedework/system/userInbox"/>
            <input value="{$userInbox}" name="userInbox" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-InboxNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserOutboxDefaultName"/></th>
          <td>
            <xsl:variable name="userOutbox" select="/bedework/system/userOutbox"/>
            <input value="{$userOutbox}" name="userOutbox" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserOutboxDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserDeletedCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="deletedCalendar" select="/bedework/system/deletedCalendar"/>
            <input value="{$deletedCalendar}" name="deletedCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserDeletedCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserBusyCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="busyCalendar" select="/bedework/system/busyCalendar"/>
            <input value="{$busyCalendar}" name="busyCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserBusyCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultUserViewName"/></th>
          <td>
            <xsl:variable name="defaultViewName" select="/bedework/system/defaultUserViewName"/>
            <input value="{$defaultViewName}" name="defaultUserViewName" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultUserViewNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxAttendees"/></th>
          <td>
            <xsl:variable name="maxAttendees" select="/bedework/system/maxAttendees"/>
            <input value="{$maxAttendees}" name="maxAttendees" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxAttendeesNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-HTTPConnectionsPerUser"/></th>
          <td>
            <xsl:variable name="httpPerUser" select="/bedework/system/httpConnectionsPerUser"/>
            <input value="{$httpPerUser}" name="httpConnectionsPerUser" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-HTTPConnectionsPerHost"/></th>
          <td>
            <xsl:variable name="httpPerHost" select="/bedework/system/httpConnectionsPerHost"/>
            <input value="{$httpPerHost}" name="httpConnectionsPerHost" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-TotalHTTPConnections"/></th>
          <td>
            <xsl:variable name="httpTotal" select="/bedework/system/httpConnections"/>
            <input value="{$httpTotal}" name="httpConnections" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxLengthPubEventDesc"/></th>
          <td>
            <xsl:variable name="maxPublicDescriptionLength" select="/bedework/system/maxPublicDescriptionLength"/>
            <input value="{$maxPublicDescriptionLength}" name="maxPublicDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxLengthUserEventDesc"/></th>
          <td>
            <xsl:variable name="maxUserDescriptionLength" select="/bedework/system/maxUserDescriptionLength"/>
            <input value="{$maxUserDescriptionLength}" name="maxUserDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxSizeUserEntity"/></th>
          <td>
            <xsl:variable name="maxUserEntitySize" select="/bedework/system/maxUserEntitySize"/>
            <input value="{$maxUserEntitySize}" name="maxUserEntitySize" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultUserQuota"/></th>
          <td>
            <xsl:variable name="defaultUserQuota" select="/bedework/system/defaultUserQuota"/>
            <input value="{$defaultUserQuota}" name="defaultUserQuota" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxRecurringInstances"/></th>
          <td>
            <xsl:variable name="maxInstances" select="/bedework/system/maxInstances"/>
            <input value="{$maxInstances}" name="maxInstances" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxRecurringInstancesNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxRecurringYears"/></th>
          <td>
            <xsl:variable name="maxYears" select="/bedework/system/maxYears"/>
            <input value="{$maxYears}" name="maxYears" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxRecurringYearsNotes"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserAuthClass"/></th>
          <td>
            <xsl:variable name="userauthClass" select="/bedework/system/userauthClass"/>
            <input value="{$userauthClass}" name="userauthClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserAuthClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MailerClass"/></th>
          <td>
            <xsl:variable name="mailerClass" select="/bedework/system/mailerClass"/>
            <input value="{$mailerClass}" name="mailerClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MailerClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-AdminGroupsClass"/></th>
          <td>
            <xsl:variable name="admingroupsClass" select="/bedework/system/admingroupsClass"/>
            <input value="{$admingroupsClass}" name="admingroupsClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-AdminGroupsClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserGroupsClass"/></th>
          <td>
            <xsl:variable name="usergroupsClass" select="/bedework/system/usergroupsClass"/>
            <input value="{$usergroupsClass}" name="usergroupsClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserGroupsClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DirBrowseDisallowd"/></th>
          <td>
            <xsl:variable name="directoryBrowsingDisallowed" select="/bedework/system/directoryBrowsingDisallowed"/>
            <input value="{$directoryBrowsingDisallowed}" name="directoryBrowsingDisallowed" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DirBrowseDisallowedNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-IndexRoot"/></th>
          <td>
            <xsl:variable name="indexRoot" select="/bedework/system/indexRoot"/>
            <input value="{$indexRoot}" name="indexRoot" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-IndexRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SupportedLocales"/></th>
          <td>
            <xsl:variable name="localeList" select="/bedework/system/localeList"/>
            <input value="{$localeList}" name="localeList" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-ListOfSupportedLocales"/>
            </div>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input type="submit" name="updateSystemParams" value="{$bwStr-MdSP-Update}"/>
        <input type="submit" name="cancelled" value="{$bwStr-MdSP-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Calendar Suites (calsuite) ++++++++++++++++++++-->
  <xsl:template match="calSuites" mode="calSuiteList">
    <h2><xsl:copy-of select="$bwStr-CalS-ManageCalendarSuites"/></h2>

    <p>
      <input type="button" name="addSuite" value="{$bwStr-CalS-AddCalendarSuite}" onclick="javascript:location.replace('{$calsuite-showAddForm}')"/>
      <input type="button" name="switchGroup" value="{$bwStr-CalS-SwitchGroup}" onclick="javascript:location.replace('{$admingroup-switch}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CalS-Name"/></th>
        <th><xsl:copy-of select="$bwStr-CalS-AssociatedGroup"/></th>
      </tr>
      <xsl:for-each select="calSuite">
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
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
    <h2><xsl:copy-of select="$bwStr-AdCS-AddCalSuite"/></h2>
    <form name="calSuiteForm" action="{$calsuite-add}" method="post">
      <input type="hidden" name="calPath" value="/public" size="20"/>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-AdCS-Name"/></th>
          <td>
            <input type="text" name="name" size="20"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-AdCS-NameCalSuite"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-AdCS-Group"/></th>
          <td>
            <input type="text" name="groupName" size="20"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-AdCS-NameAdminGroup"/>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input type="submit" name="updateCalSuite" value="{$bwStr-AdCS-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-AdCS-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template match="calSuite" name="modCalSuite">
    <h2><xsl:copy-of select="$bwStr-CalS-ModifyCalendarSuite"/></h2>
    <xsl:variable name="calSuiteName" select="name"/>
    <form name="calSuiteForm" action="{$calsuite-update}" method="post">
      <input type="hidden" name="calPath" size="20">
        <xsl:attribute name="value"><xsl:variable name="calPath" select="calPath"/></xsl:attribute>
      </input>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-CalS-NameColon"/></th>
          <td>
            <xsl:value-of select="$calSuiteName"/>
          </td>
          <!--
          <td>
            <p class="note">
              <xsl:copy-of select="$bwStr-CalS-NameOfCalendarSuite"/>
            </p>
          </td>
          -->
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CalS-Group"/></th>
          <td>
            <xsl:value-of select="group"/>
          </td>
          <!--
          <td>
            <p class="note">
              <xsl:copy-of select="$bwStr-CalS-NameOfAdminGroup"/>
            </p>
          </td>
          -->
        </tr>
      </table>

      <div id="sharingBox">
        <h3><xsl:copy-of select="$bwStr-CalS-CurrentAccess"/></h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <div class="submitBox">
        <div class="right">
          <input type="submit" name="delete" value="{$bwStr-CalS-DeleteCalendarSuite}"/>
        </div>
        <input type="submit" name="updateCalSuite" value="{$bwStr-CalS-Update}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CalS-Cancel}"/>
      </div>
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
    <h2><xsl:copy-of select="$bwStr-CSPf-EditCalSuitePrefs"/></h2>
    <form name="userPrefsForm" method="post" action="{$calsuite-updatePrefs}" onsubmit="checkPrefCategories(this);">
      <table class="common2">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-CalSuite"/>
          </th>
          <td>
            <xsl:value-of select="/bedework/currentCalSuite/name"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-PreferredView"/>
          </th>
          <td>
            <xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-DefaultViewMode"/>
          </th>
          <td>
            <select name="defaultViewMode">
              <option value="daily">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'daily'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeDaily"/>
              </option>
              <option value="list">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'list'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeList"/>
              </option>
              <option value="grid">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'grid'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeGrid"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-PreferredViewPeriod"/>
          </th>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
            <select name="viewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Day"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView"><xsl:copy-of select="$bwStr-CSPf-Day"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Today"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView"><xsl:copy-of select="$bwStr-CSPf-Today"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Week"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView"><xsl:copy-of select="$bwStr-CSPf-Week"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Month"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView"><xsl:copy-of select="$bwStr-CSPf-Month"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Year"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView"><xsl:copy-of select="$bwStr-CSPf-Year"/></option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CSPf-DefaultCategories"/></th>
          <td>
            <!-- show the selected categories -->
            <ul class="catlist">
              <xsl:for-each select="/bedework/categories/current/category">
                <xsl:sort select="value" order="ascending"/>
                <li>
                  <input type="checkbox" name="defaultCategory" checked="checked">
                    <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                    <xsl:value-of select="value"/>
                  </input>
                </li>
              </xsl:for-each>
            </ul>
            <a href="javascript:toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CSPf-ShowHideUnusedCategories"/>
            </a>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <!-- don't duplicate the selected categories -->
                  <xsl:if test="not(uid = ../../current//category/uid)">
                    <li>
                      <input type="checkbox" name="defaultCategory">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <xsl:value-of select="value"/>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-PreferredTimeType"/>
          </th>
          <td>
            <select name="hour24">
              <option value="false">
                <xsl:if test="/bedework/prefs/hour24 = 'false'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-12Hour"/>
              </option>
              <option value="true">
                <xsl:if test="/bedework/prefs/hour24 = 'true'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-24Hour"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-PreferredEndDateTimeType"/>
          </th>
          <td>
            <select name="preferredEndType">
              <option value="duration">
                <xsl:if test="/bedework/prefs/preferredEndType = 'duration'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-Duration"/>
              </option>
              <option value="date">
                <xsl:if test="/bedework/prefs/preferredEndType = 'date'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DateTime"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-DefaultTimezone"/>
          </th>
          <td>
            <xsl:variable name="tzid" select="/bedework/prefs/tzid"/>

            <select name="defaultTzid" id="defaultTzid">
              <option value="-1"><xsl:copy-of select="$bwStr-CSPf-SelectTimezone"/></option>
            </select>

          </td>
        </tr>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
	        <tr>
	          <th>
	            <xsl:copy-of select="$bwStr-CSPf-DefaultImageDirectory"/>
	          </th>
	          <td>
	            <input type="text" name="defaultImageDirectory" value="" size="40">
	              <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/defaultImageDirectory"/></xsl:attribute>
	            </input>
	          </td>
	        </tr>
	        <tr>
            <th>
              <xsl:copy-of select="$bwStr-CSPf-MaxEntitySize"/>
            </th>
            <td>
              <input type="text" name="maxEntitySize" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/maxEntitySize"/></xsl:attribute>
              </input>
            </td>
          </tr>
	    </xsl:if>
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

      <input type="submit" name="modPrefs" value="{$bwStr-CSPf-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-CSPf-Cancel}"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2><xsl:copy-of select="$bwStr-UpTZ-ManageTZ"/></h2>

    <form name="peForm" method="post" action="{$timezones-upload}" enctype="multipart/form-data">
      <input type="file" name="uploadFile" size="40" value=""/>
      <input type="submit" name="doUpload" value="{$bwStr-UpTZ-UploadTZ}"/>
      <input type="submit" name="cancelled" value="{$bwStr-UpTZ-Cancel}"/>
    </form>

    <p>
      <a href="{$timezones-fix}"><xsl:copy-of select="$bwStr-UpTZ-FixTZ"/></a>
      <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-UpTZ-RecalcUTC"/><br/>
      <span class="note"><xsl:copy-of select="$bwStr-UpTZ-FixTZNote"/></span>
    </p>

  </xsl:template>

  <!--+++++++++++++++ Authuser ++++++++++++++++++++-->
  <xsl:template name="authUserList">
    <h2><xsl:copy-of select="$bwStr-AuUL-ModifyAdministrators"/></h2>

    <div id="authUserInputForms">
      <form name="getUserRolesForm" action="{$authuser-fetchForUpdate}" method="post">
        <xsl:copy-of select="$bwStr-AuUL-EditAdminRoles"/><xsl:text> </xsl:text><input type="text" name="editAuthUserId" size="20"/>
        <input type="submit" value="{$bwStr-AuUL-Go}" name="submit"/>
      </form>
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-AuUL-UserID"/></th>
        <th><xsl:copy-of select="$bwStr-AuUL-Roles"/></th>
        <th></th>
      </tr>

      <xsl:for-each select="/bedework/authUsers/authUser">
        <!--<xsl:sort select="account" order="ascending" case-order="upper-first"/>-->
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
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
              <xsl:copy-of select="$bwStr-AuUL-Edit"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAuthUser">
    <h2><xsl:copy-of select="$bwStr-MoAU-UpdateAdmin"/></h2>
    <xsl:variable name="modAuthUserAction" select="/bedework/formElements/form/@action"/>
    <form action="{$modAuthUserAction}" method="post">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-Account"/>
          </td>
          <td>
            <xsl:value-of select="/bedework/formElements/form/account"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-PublicEvents"/>
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

      <input type="submit" name="modAuthUser" value="{$bwStr-MoAU-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-MoAU-Cancel}"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ User Prefs ++++++++++++++++++++-->
  <xsl:template name="modPrefs">
    <h2><xsl:copy-of select="$bwStr-MoPr-EditUserPrefs"/></h2>
    <form name="userPrefsForm" method="post" action="{$prefs-update}">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-User"/>
          </td>
          <td>
            <xsl:value-of select="/bedework/prefs/user"/>
            <xsl:variable name="user" select="/bedework/prefs/user"/>
            <input type="hidden" name="user" value="{$user}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-PreferredView"/>
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-PreferredViewPeriod"/>
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
            <select name="viewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Day"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView"><xsl:copy-of select="$bwStr-MoPr-Day"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Today"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView"><xsl:copy-of select="$bwStr-MoPr-Today"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Week"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView"><xsl:copy-of select="$bwStr-MoPr-Week"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Month"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView"><xsl:copy-of select="$bwStr-MoPr-Month"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Year"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView"><xsl:copy-of select="$bwStr-MoPr-Year"/></option>
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

      <input type="submit" name="modPrefs" value="{$bwStr-MoPr-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-MoPr-Cancel}"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Admin Groups ++++++++++++++++++++-->
  <xsl:template name="listAdminGroups">
    <h2><xsl:copy-of select="$bwStr-LsAG-ModifyGroups"/></h2>
    <form name="adminGroupMembersForm" method="post" action="{$admingroup-initUpdate}">
      <xsl:choose>
        <xsl:when test="/bedework/groups/showMembers='true'">
          <input type="radio" name="showAgMembers" value="false" onclick="document.adminGroupMembersForm.submit();"/>
          <xsl:copy-of select="$bwStr-LsAG-HideMembers"/>
          <input type="radio" name="showAgMembers" value="true" checked="checked" onclick="document.adminGroupMembersForm.submit();"/>
          <xsl:copy-of select="$bwStr-LsAG-ShowMembers"/>
        </xsl:when>
        <xsl:otherwise>
          <input type="radio" name="showAgMembers" value="false" checked="checked" onclick="document.adminGroupMembersForm.submit();"/>
          <xsl:copy-of select="$bwStr-LsAG-HideMembers"/>
          <input type="radio" name="showAgMembers" value="true" onclick="document.adminGroupMembersForm.submit();"/>
          <xsl:copy-of select="$bwStr-LsAG-ShowMembers"/>
        </xsl:otherwise>
      </xsl:choose>
    </form>

    <p><xsl:copy-of select="$bwStr-LsAG-SelectGroupName"/></p>
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="{$bwStr-LsAG-AddNewGroup}"/>
    </p>
    <div class="notes">
      <p class="note">
       <xsl:copy-of select="$bwStr-LsAG-HighlightedRowsNote"/>
      </p>
    </div>
    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-LsAG-Name"/></th>
        <xsl:if test="/bedework/groups/showMembers='true'">
          <th><xsl:copy-of select="$bwStr-LsAG-Members"/></th>
        </xsl:if>
        <th><xsl:copy-of select="$bwStr-LsAG-ManageMembership"/></th>
        <th><xsl:copy-of select="$bwStr-LsAG-CalendarSuite"/></th>
        <th><xsl:copy-of select="$bwStr-LsAG-Description"/></th>
      </tr>
      <xsl:for-each select="/bedework/groups/group">
        <xsl:sort select="name" order="ascending" case-order="lower-first"/>
        <xsl:variable name="groupName" select="name"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <xsl:if test="name = /bedework/calSuites//calSuite/group">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdate}&amp;adminGroupName={$groupName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <xsl:if test="/bedework/groups/showMembers='true'">
            <td class="memberList">
              <xsl:for-each select="members/member/account">
                <xsl:value-of select="."/><br/>
              </xsl:for-each>
            </td>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdateMembers}&amp;adminGroupName={$groupName}"><xsl:copy-of select="$bwStr-LsAG-Membership"/></a>
          </td>
          <td>
            <xsl:for-each select="/bedework/calSuites/calSuite">
              <xsl:if test="group = $groupName">
                <xsl:value-of select="name"/>
              </xsl:if>
            </xsl:for-each>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initAdd}')" value="{$bwStr-LsAG-AddNewGroup}"/>
    </p>
  </xsl:template>

  <xsl:template match="groups" mode="chooseGroup">
    <h2><xsl:copy-of select="$bwStr-Grps-ChooseAdminGroup"/></h2>

    <xsl:variable name="userInCalSuiteGroup">
      <xsl:choose>
        <xsl:when test="/bedework/calSuites//calSuite/group = .//group/name">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="notes">
      <xsl:if test="$userInCalSuiteGroup = 'true'">
        <p class="note">
         <xsl:copy-of select="$bwStr-Grps-HighlightedRowsNote"/>
        </p>
      </xsl:if>
      <!--
      <xsl:if test="/bedework/userInfo/superUser = 'true'">
        <p class="note"><xsl:copy-of select="$bwStr-Grps-Superuser"/></p>
      </xsl:if>
      -->
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-Grps-Name"/></th>
        <th><xsl:copy-of select="$bwStr-Grps-Description"/></th>
        <xsl:if test="$userInCalSuiteGroup = 'true'">
          <th><xsl:copy-of select="$bwStr-Grps-CalendarSuite"/></th>
        </xsl:if>
      </tr>

      <xsl:for-each select="group">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <xsl:variable name="admGroupName" select="name"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
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
  </xsl:template>

  <xsl:template name="modAdminGroup">
    <xsl:choose>
      <xsl:when test="/bedework/creating = 'true'">
        <h2><xsl:copy-of select="$bwStr-MoAG-AddGroup"/></h2>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoAG-ModifyGroup"/></h2>
      </xsl:otherwise>
    </xsl:choose>
    <form name="peForm" method="post" action="{$admingroup-update}">
      <table id="adminGroupFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAG-Name"/>
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
            <xsl:copy-of select="$bwStr-MoAG-Description"/>
          </td>
          <td>
            <textarea name="updAdminGroup.description" cols="50" rows="3">
              <xsl:value-of select="/bedework/formElements/form/desc/textarea"/>
              <xsl:if test="normalize-space(/bedework/formElements/form/desc/textarea) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAG-GroupOwner"/>
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/groupOwner/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAG-EventsOwner"/>
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
      <div class="submitBox">
        <div class="right">
          <xsl:if test="/bedework/creating = 'false'">
            <input type="submit" name="delete" value="{$bwStr-MoAG-Delete}"/>
          </xsl:if>
        </div>
        <xsl:choose>
          <xsl:when test="/bedework/creating = 'true'">
            <input type="submit" name="updateAdminGroup" value="{$bwStr-MoAG-AddAdminGroup}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoAG-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateAdminGroup" value="{$bwStr-MoAG-UpdateAdminGroup}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoAG-Cancel}"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="modAdminGroupMembers">
    <h2><xsl:copy-of select="$bwStr-MAGM-UpdateGroupMembership"/></h2>
    <p><xsl:copy-of select="$bwStr-MAGM-EnterUserID"/></p>

    <form name="adminGroupMembersForm" method="post" action="{$admingroup-updateMembers}">
      <p><xsl:copy-of select="$bwStr-MAGM-AddMember"/>
        <input type="text" name="updGroupMember" size="15"/>
        <input type="radio" value="user" name="kind" checked="checked"/><xsl:copy-of select="$bwStr-MAGM-User"/>
        <input type="radio" value="group" name="kind"/><xsl:copy-of select="$bwStr-MAGM-Group"/>
        <input type="submit" name="addGroupMember" value="{$bwStr-MAGM-Add}"/>
      </p>
    </form>
    <p>
      <input type="button" name="return" onclick="javascript:location.replace('{$admingroup-initUpdate}')" value="{$bwStr-MAGM-ReturnToAdminGroupLS}"/>
    </p>

    <table id="adminGroupFormTable">
      <tr>
        <td class="fieldName">
          <xsl:copy-of select="$bwStr-MAGM-Name"/>
        </td>
        <td>
          <xsl:value-of select="/bedework/adminGroup/name"/>
        </td>
      </tr>
      <tr>
        <td class="fieldName">
          <xsl:copy-of select="$bwStr-MAGM-Members"/>
        </td>
        <td>
          <table id="memberAccountList">
            <xsl:for-each select="/bedework/adminGroup/members/member">
              <xsl:choose>
                <xsl:when test="kind='1'"><!-- kind = user -->
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="{$bwStr-MAGM-User}"/>
                    </td>
                    <td>
                      <xsl:value-of select="account"/>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                      <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user" title="{$bwStr-MAGM-Remove}">
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-MAGM-Remove}"/>
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
                      <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=group" title="{$bwStr-MAGM-Remove}">
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-MAGM-Remove}"/>
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
      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="{$bwStr-MAGM-User}"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MAGM-User"/>,
      <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="{$bwStr-MAGM-Group}"/>
      <xsl:text> </xsl:text>
      <strong><xsl:copy-of select="$bwStr-MAGM-Group"/></strong>
    </p>
  </xsl:template>

  <xsl:template name="deleteAdminGroupConfirm">
    <h2><xsl:copy-of select="$bwStr-DAGC-DeleteAdminGroup"/></h2>
    <p><xsl:copy-of select="$bwStr-DAGC-GroupWillBeDeleted"/></p>
    <p>
      <strong>
        <xsl:value-of select="/bedework/groups/group/name"/>
      </strong>:
      <xsl:value-of select="/bedework/groups/group/desc"/>
    </p>
    <form name="adminGroupDelete" method="post" action="{$admingroup-delete}">
      <input type="submit" name="removeAdminGroupOK" value="{$bwStr-DAGC-YesDelete}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DAGC-NoCancel}"/>
    </form>
  </xsl:template>

  <!--+++++++++++++++ Filters ++++++++++++++++++++-->
  <xsl:template name="addFilter">
    <h2><xsl:copy-of select="$bwStr-AdFi-AddNameCalDAVFilter"/><xsl:text> </xsl:text>(<a href="http://bedework.org/trac/bedework/wiki/Bedework/DevDocs/Filters"><xsl:copy-of select="$bwStr-AdFi-Examples"/></a>)</h2>
    <form name="peForm" method="post" action="{$filter-add}">
      <table id="addFilterFormTable" class="eventFormTable">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-Name"/>
          </th>
          <td>
            <input type="text" name="name" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-Description"/>
          </th>
          <td>
            <input type="text" name="desc" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-FilterDefinition"/>
          </th>
          <td>
            <textarea name="def" rows="30" cols="80">
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td>
          </td>
          <td>
            <input type="submit" name="add" value="{$bwStr-AdFi-AddFilter}"/>
            <input type="submit" name="cancelled" value="{$bwStr-AdFi-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
    <xsl:if test="/bedework/filters/filter">
      <h2><xsl:copy-of select="$bwStr-AdFi-CurrentFilters"/></h2>
      <table id="filterTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-AdFi-FilterName"/></th>
          <th><xsl:copy-of select="$bwStr-AdFi-DescriptionDefinition"/></th>
          <th><xsl:copy-of select="$bwStr-AdFi-Delete"/></th>
        </tr>
        <xsl:for-each select="/bedework/filters/filter">
          <xsl:variable name="filterName" select="name"/>
          <tr>
            <td><xsl:value-of select="$filterName"/></td>
            <td>
              <xsl:if test="description != ''"><xsl:value-of select="description"/><br/></xsl:if>
              <a href="javascript:toggleVisibility('bwfilter-{$filterName}','filterdef')">
                <xsl:copy-of select="$bwStr-AdFi-ShowHideFilterDef"/>
              </a>
              <div id="bwfilter-{$filterName}" class="invisible">
                <xsl:value-of select="definition"/>
              </div>
            </td>
            <td>
              <a href="{$filter-delete}&amp;name={$filterName}" title="{$bwStr-AdFi-DeleteFilter}">
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-AdFi-DeleteFilter}"/>
              </a>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->

  <xsl:template match="sysStats" mode="showSysStats">
    <h2><xsl:copy-of select="$bwStr-SysS-SystemStatistics"/></h2>

    <p>
      <xsl:copy-of select="$bwStr-SysS-StatsCollection"/>
    </p>
    <ul>
      <li>
        <a href="{$stats-update}&amp;enable=yes"><xsl:copy-of select="$bwStr-SysS-Enable"/></a> |
        <a href="{$stats-update}&amp;disable=yes"><xsl:copy-of select="$bwStr-SysS-Disable"/></a>
      </li>
      <li>
        <a href="{$stats-update}&amp;fetch=yes"><xsl:copy-of select="$bwStr-SysS-FetchRefreshStats"/></a>
      </li>
      <li>
        <a href="{$stats-update}&amp;dump=yes"><xsl:copy-of select="$bwStr-SysS-DumpStatsToLog"/></a>
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
          <xsl:copy-of select="$bwStr-Srch-Search"/>Search:
          <input type="text" name="query" size="15">
            <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
          </input>
          <input type="submit" name="submit" value="{$bwStr-Srch-Go}"/>
          <xsl:copy-of select="$bwStr-Srch-Limit"/>
          <xsl:choose>
            <xsl:when test="/bedework/searchResults/searchLimits = 'beforeToday'">
              <input type="radio" name="searchLimits" value="fromToday"/><xsl:copy-of select="$bwStr-Srch-TodayForward"/>
              <input type="radio" name="searchLimits" value="beforeToday" checked="checked"/><xsl:copy-of select="$bwStr-Srch-PastDates"/>
              <input type="radio" name="searchLimits" value="none"/><xsl:copy-of select="$bwStr-Srch-AllDates"/>
            </xsl:when>
            <xsl:when test="/bedework/searchResults/searchLimits = 'none'">
              <input type="radio" name="searchLimits" value="fromToday"/><xsl:copy-of select="$bwStr-Srch-TodayForward"/>
              <input type="radio" name="searchLimits" value="beforeToday"/><xsl:copy-of select="$bwStr-Srch-PastDates"/>
              <input type="radio" name="searchLimits" value="none" checked="checked"/><xsl:copy-of select="$bwStr-Srch-AllDates"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="radio" name="searchLimits" value="fromToday" checked="checked"/><xsl:copy-of select="$bwStr-Srch-TodayForward"/>
              <input type="radio" name="searchLimits" value="beforeToday"/><xsl:copy-of select="$bwStr-Srch-PastDates"/>
              <input type="radio" name="searchLimits" value="none"/><xsl:copy-of select="$bwStr-Srch-AllDates"/>
            </xsl:otherwise>
          </xsl:choose>
        </form>
      </div>
      <xsl:copy-of select="$bwStr-Srch-SearchResult"/>
    </h2>
    <table id="searchTable" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="5">
          <xsl:if test="/bedework/searchResults/numPages &gt; 1">
            <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
            <div id="searchPageForm">
              <xsl:copy-of select="$bwStr-Srch-Page"/>
              <xsl:if test="/bedework/searchResults/curPage != 1">
                <xsl:variable name="prevPage" select="number($curPage) - 1"/>
                &lt;<a href="{$search-next}&amp;pageNum={$prevPage}"><xsl:copy-of select="$bwStr-Srch-Prev"/></a>
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
                  <a href="{$search-next}&amp;pageNum={$nextPage}"><xsl:copy-of select="$bwStr-Srch-Next"/></a>&gt;
                </xsl:when>
                <xsl:otherwise>
                  <span class="hidden"><xsl:copy-of select="$bwStr-Srch-Next"/>&gt;</span><!-- occupy the space to keep the navigation from moving around -->
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:if>
          <xsl:value-of select="/bedework/searchResults/resultSize"/>
          <xsl:copy-of select="$bwStr-Srch-ResultReturnedFor"/><xsl:text> </xsl:text><em><xsl:value-of select="/bedework/searchResults/query"/></em>
        </th>
      </tr>
      <xsl:if test="/bedework/searchResults/searchResult">
        <tr class="fieldNames">
          <td>
            <xsl:copy-of select="$bwStr-Srch-Relevance"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-Srch-Title"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-Srch-DateAndTime"/>
          </td>
          <!-- <td>
            topical areas
          </td>-->
          <td>
            <xsl:copy-of select="$bwStr-Srch-Location"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:for-each select="/bedework/searchResults/searchResult">
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
            <a href="{$event-fetchForDisplay}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="event/summary"/>
              <xsl:if test="event/summary = ''"><em><xsl:copy-of select="$bwStr-Srch-NoTitle"/></em></xsl:if>
            </a>
          </td>
          <td>
            <xsl:value-of select="event/start/longdate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="event/start/time"/>
            <xsl:choose>
              <xsl:when test="event/start/longdate != event/end/longdate">
                - <xsl:value-of select="event/end/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="event/end/time"/>
              </xsl:when>
              <xsl:when test="event/start/time != event/end/time">
                - <xsl:value-of select="event/end/time"/>
              </xsl:when>
            </xsl:choose>
          </td>
          <!--
          <td>
            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
              <xsl:call-template name="substring-afterLastInstanceOf">
                <xsl:with-param name="string" select="values/text"/>
                <xsl:with-param name="char">/</xsl:with-param>
              </xsl:call-template><br/>
            </xsl:for-each>
          </td>-->
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
      <a href="http://www.jasig.org/bedework"><xsl:copy-of select="$bwStr-Foot-BedeworkWebsite"/></a> |
      <!-- Enable the following two items when debugging skins only -->
      <a href="?noxslt=yes"><xsl:copy-of select="$bwStr-Foot-ShowXML"/></a> |
      <a href="?refreshXslt=yes"><xsl:copy-of select="$bwStr-Foot-RefreshXSLT"/></a>
    </div>
  </xsl:template>

</xsl:stylesheet>
