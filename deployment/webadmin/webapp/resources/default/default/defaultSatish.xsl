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
  <xsl:variable name="timezones-showUpload" select="/bedeworkadmin/urlPrefixes/timezones/showUpload/a/@href"/>
  <xsl:variable name="timezones-initUpload" select="/bedeworkadmin/urlPrefixes/timezones/initUpload/a/@href"/>
  <xsl:variable name="timezones-upload" select="/bedeworkadmin/urlPrefixes/timezones/upload/a/@href"/>
  <xsl:variable name="calendar-showCalendar" select="/bedeworkadmin/urlPrefixes/calendar/showCalendar/a/@href"/>
  <xsl:variable name="calendar-showReferenced" select="/bedeworkadmin/urlPrefixes/calendar/showReferenced/a/@href"/>
  <xsl:variable name="calendar-showModForm" select="/bedeworkadmin/urlPrefixes/calendar/showModForm/a/@href"/>
  <xsl:variable name="calendar-showUpdateList" select="/bedeworkadmin/urlPrefixes/calendar/showUpdateList/a/@href"/>
  <xsl:variable name="calendar-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/calendar/showDeleteConfirm/a/@href"/>
  <xsl:variable name="calendar-initAdd" select="/bedeworkadmin/urlPrefixes/calendar/initAdd/a/@href"/>
  <xsl:variable name="calendar-initUpdate" select="/bedeworkadmin/urlPrefixes/calendar/initUpdate/a/@href"/><!-- used -->
  <xsl:variable name="calendar-delete" select="/bedeworkadmin/urlPrefixes/calendar/delete/a/@href"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedeworkadmin/urlPrefixes/calendar/fetchForDisplay/a/@href"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/calendar/fetchForUpdate/a/@href"/>
  <xsl:variable name="calendar-update" select="/bedeworkadmin/urlPrefixes/calendar/update/a/@href"/>
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
  <xsl:variable name="keyword-showReferenced" select="/bedeworkadmin/urlPrefixes/keyword/showReferenced/a/@href"/>
  <xsl:variable name="keyword-showModForm" select="/bedeworkadmin/urlPrefixes/keyword/showModForm/a/@href"/>
  <xsl:variable name="keyword-showUpdateList" select="/bedeworkadmin/urlPrefixes/keyword/showUpdateList/a/@href"/>
  <xsl:variable name="keyword-showDeleteConfirm" select="/bedeworkadmin/urlPrefixes/keyword/showDeleteConfirm/a/@href"/>
  <xsl:variable name="keyword-initAdd" select="/bedeworkadmin/urlPrefixes/keyword/initAdd/a/@href"/>
  <xsl:variable name="keyword-initUpdate" select="/bedeworkadmin/urlPrefixes/keyword/initUpdate/a/@href"/>
  <xsl:variable name="keyword-delete" select="/bedeworkadmin/urlPrefixes/keyword/delete/a/@href"/>
  <xsl:variable name="keyword-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/keyword/fetchForUpdate/a/@href"/>
  <xsl:variable name="keyword-update" select="/bedeworkadmin/urlPrefixes/keyword/update/a/@href"/>
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
  <xsl:variable name="admingroup-initUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/initUpdate/a/@href"/>
  <xsl:variable name="admingroup-delete" select="/bedeworkadmin/urlPrefixes/admingroup/delete/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdate/a/@href"/>
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/fetchForUpdateMembers/a/@href"/>
  <xsl:variable name="admingroup-update" select="/bedeworkadmin/urlPrefixes/admingroup/update/a/@href"/>
  <xsl:variable name="admingroup-updateMembers" select="/bedeworkadmin/urlPrefixes/admingroup/updateMembers/a/@href"/>
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
          <script language="JavaScript" type="text/javascript" src="{$resourcesRoot}/default/default/includes.js"></script>
          <script language="JavaScript" type="text/javascript">
    var location = new Array(<xsl:for-each select="/bedeworkadmin/formElements/location/all/select/option">'<xsl:value-of select="."/>'<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>);
    </script>
        </xsl:if>
        <!--<link rel="icon" type="image/ico" href="{}/favicon.ico" />-->

  <script type='text/javascript' src="{$resourcesRoot}/default/default/AutoComplete.js"></script>
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
            <xsl:when test="/bedeworkadmin/page='listAuthUser'">
              <xsl:call-template name="listAuthUser"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modAuthUser'">
              <xsl:call-template name="modAuthUser"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='chooseGroup'">
              <xsl:apply-templates select="/bedeworkadmin/groups" mode="chooseGroup"/>
            </xsl:when>
            <xsl:when test="/bedeworkadmin/page='modAdminGroup'">
              <xsl:apply-templates select="/bedeworkadmin/groups" mode="chooseGroup"/>
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
              <!-- otherwise, show the mainMenu -->
              <em>(<xsl:value-of select="/bedeworkadmin/page"/>)</em>
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
      <table id="adminMenuTable">
        <xsl:if test="/bedeworkadmin/userInfo/superUser='true'">
          <xsl:if test="/bedeworkadmin/userInfo/adminGroupMaintOk='true'">
            <tr>
              <th>Admin Groups</th>
              <td>
                <a href="{$admingroup-initAdd}">
                  Add
                </a>
              </td>
              <td>
                <a href="{$admingroup-initUpdate}">
                  Edit / Delete
                </a>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="/bedeworkadmin/userInfo/userMaintOK='true'">
            <tr>
              <th>Authorised Users</th>
              <td>
                <a href="{$authuser-initUpdate}" >
                  List authorised users
                </a>
              </td>
            </tr>
          </xsl:if>
          <tr>
            <th>Calendars</th>
            <td>
              <a href="{$calendar-initAdd}">
                Add (all)
              </a>
            </td>
          </tr>
          <tr>
            <th>Timezones</th>
            <td>
              <a href="{$timezones-initUpload}" >
                Upload and replace system timezones
              </a>
            </td>
          </tr>
        </xsl:if>

        <tr>
          <th>Groups</th>
          <td>
            <a href="{$admingroup-switch}" >
              Choose group...
            </a>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <!--+++++++++++++++ Groups ++++++++++++++++++++-->
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
              <img src="{$resourcesRoot}/images/calIcon.gif" width="16" height="15" border="0"/>
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/hour/*"/>
                <xsl:copy-of select="/bedeworkadmin/formElements/form/start/minute/*"/>
                <xsl:if test="/bedeworkadmin/formElements/form/start/ampm">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/start/ampm/*"/>
                </xsl:if>
                <xsl:text> </xsl:text>
                <a href="javascript:launchClockMap('showClockMap.do?dateType=eventStartDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0"/></a>
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
                <img src="{$resourcesRoot}/images/calIcon.gif" width="16" height="15" border="0"/>
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/hour/*"/>
                  <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/minute/*"/>
                  <xsl:if test="/bedeworkadmin/formElements/form/end/dateTime/ampm">
                    <xsl:copy-of select="/bedeworkadmin/formElements/form/end/dateTime/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:launchClockMap('showClockMap.do?dateType=eventEndDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0"/></a>
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
            <xsl:text> </xsl:text>
            <a href="" target="_blank">Calendar Definitions</a>
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
              <xsl:copy-of select="/bedeworkadmin/formElements/form/location/address/*"/>
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
              <span class="fieldInfo">(optional)</span>
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
                <input type="reset" value="Clear" class="padRight"/>
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
                <input type="reset" value="Clear" class="padRight"/>
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

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2>Upload Timezones</h2>
    <xsl:copy-of select="/bedeworkadmin/formElements/*"/>
  </xsl:template>

  <!--+++++++++++++++ Authuser ++++++++++++++++++++-->
  <xsl:template name="listAuthUser">
    <h2>Update an authorised user</h2>

    <p>Click on the user that you would like to update:</p>

    <table id="commonListTable">
      <tr>
        <th>Userid</th>
        <th>Last Name</th>
        <th>First Name</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Dept</th>
        <th>Roles</th>
      </tr>

      <xsl:for-each select="bedeworkadmin/authUsers/authUser">
        <tr>
          <td>
            <xsl:copy-of select="account/*"/>
          </td>
          <td>
            <xsl:value-of select="lastname"/>
          </td>
          <td>
            <xsl:value-of select="firstname"/>
          </td>
          <td>
            <xsl:value-of select="phone"/>
          </td>
          <td>
            <xsl:value-of select="email"/>
          </td>
          <td>
            <xsl:value-of select="dept"/>
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
    <h2>Update Authorised User Information</h2>

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


  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="header">
    <div id="header">
     <!-- Uncomment this code and replace the following logo
          to brand your administrative interface.

      <img id="logo"
          alt="logo"
          src="{$resourcesRoot}/images/caladminlogo.gif"
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
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/std-title-space.gif"
                             width="100%" height="16" border="0"/></td>
        <td><img src="{$resourcesRoot}/images/std-title.gif" width="485" height="16"
                 border="0"
                 alt="Calendar of Events"/></td>
        <td width="50%"><img alt="" src="{$resourcesRoot}/images/std-title-space.gif"
                             width="100%" height="16" border="0"/></td>
      </tr>
    </table>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      Based on the <a href="http://www.washington.edu/ucal/">University of Washington Calendar</a>
    </div>
  </xsl:template>
</xsl:stylesheet>
