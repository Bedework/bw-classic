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

  <!-- ========================================================= -->
  <!--         PUBLIC EVENTS SUBMISSION CALENDAR STYLESHEET      -->
  <!-- ========================================================= -->

  <!-- **********************************************************************
    Copyright 2007 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

  <xsl:variable name="submissionsRootEncoded" select="/bedework/submissionsRoot/encoded"/>
  <xsl:variable name="submissionsRootUnencoded" select="/bedework/submissionsRoot/unencoded"/>

  <!-- main -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="initEvent" select="/bedework/urlPrefixes/event/initEvent"/>
  <xsl:variable name="initPendingEvents" select="/bedework/urlPrefixes/event/initPendingEvents"/>
  <xsl:variable name="addEvent" select="/bedework/urlPrefixes/event/addEvent"/>
  <xsl:variable name="editEvent" select="/bedework/urlPrefixes/event/editEvent"/>
  <xsl:variable name="gotoEditEvent" select="/bedework/urlPrefixes/event/gotoEditEvent"/>
  <xsl:variable name="updateEvent" select="/bedework/urlPrefixes/event/updateEvent"/>
  <xsl:variable name="delEvent" select="/bedework/urlPrefixes/event/delEvent"/>
  <xsl:variable name="initUpload" select="/bedework/urlPrefixes/misc/initUpload/a/@href"/>
  <xsl:variable name="upload" select="/bedework/urlPrefixes/misc/upload/a/@href"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!-- the following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals. -->
  <xsl:variable name="portalFriendly">false</xsl:variable>

 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:call-template name="headSection"/>
      </head>
      <body>
        <xsl:choose>
          <xsl:when test="/bedework/page = 'addEvent'">
            <xsl:attribute name="onload">focusElement('bwEventTitle');</xsl:attribute>
          </xsl:when>
          <xsl:when test="/bedework/page = 'editEvent'">
            <xsl:attribute name="onload">initRXDates();initXProperties();</xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <div id="bedework"><!-- main wrapper div -->
          <xsl:call-template name="header"/>
          <xsl:call-template name="messagesAndErrors"/>
          <xsl:call-template name="menuTabs"/>
          <div id="bodyContent">
            <xsl:choose>
              <xsl:when test="/bedework/page='addEvent'">
                <xsl:apply-templates select="/bedework/formElements" mode="addEvent"/>
              </xsl:when>
              <xsl:when test="/bedework/page='eventList'">
                <xsl:call-template name="eventList"/>
              </xsl:when>
              <xsl:when test="/bedework/page='editEvent'">
                <xsl:apply-templates select="/bedework/formElements" mode="editEvent"/>
              </xsl:when>
              <xsl:when test="/bedework/page='upload'">
                <xsl:call-template name="upload" />
              </xsl:when>
              <xsl:otherwise>
                <!-- home / entrance screen -->
                <xsl:call-template name="home"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <!-- footer -->
          <xsl:call-template name="footer"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--==== HEAD SECTION  ====-->
  <xsl:template name="headSection">
    <title>Bedework: Submit a Public Event</title>
    <meta name="robots" content="noindex,nofollow"/>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
    <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
    <!-- note: the non-breaking spaces in the script bodies below are to avoid
         losing the script closing tags (which avoids browser problems) -->
    <script type="text/javascript" src="{$resourcesRoot}/resources/bedework.js">&#160;</script>
    <xsl:if test="/bedework/page='addEvent' or /bedework/page='editEvent'">
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
        </xsl:otherwise>
      </xsl:choose>
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkEventForm.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/resources/bedeworkXProperties.js">&#160;</script>
    </xsl:if>
    <script type="text/javascript">
      <xsl:comment>
      function focusElement(id) {
      // focuses element by id
        document.getElementById(id).focus();
      }
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
      <!-- set the page heading: -->
      <h1>
        Bedework Public Event Submission
      </h1>
    </div>
    <div id="statusBar">
      logged in as
          <xsl:text> </xsl:text>
          <strong><xsl:value-of select="/bedework/userid"/></strong>
          <xsl:text> </xsl:text>
          <span class="logout"><a href="{$setup}&amp;logout=true">logout</a></span>
    </div>
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

  <!--==== MENUTABS ====-->
  <xsl:template name="menuTabs">
    <ul id="menuTabs">
      <xsl:choose>
        <xsl:when test="/bedework/page='home'">
          <li class="selected">Overview</li>
          <li><a href="{$initEvent}">Add Event</a></li>
          <li><a href="{$initPendingEvents}&amp;calPath={$submissionsRootEncoded}&amp;listAllEvents=true">My Pending Events</a></li>
        </xsl:when>
        <xsl:when test="/bedework/page='eventList'">
          <li><a href="{$setup}">Overview</a></li>
          <li><a href="{$initEvent}">Add Event</a></li>
          <li class="selected">My Pending Events</li>
        </xsl:when>
        <xsl:otherwise>
          <li><a href="{$setup}">Overview</a></li>
          <li class="selected">Add Event</li>
          <li><a href="{$initPendingEvents}&amp;calPath={$submissionsRootEncoded}&amp;listAllEvents=true">My Pending Events</a></li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <!--==== HOME ====-->
  <xsl:template name="home">
    <div class="navButtons navBox">
      <a href="{$initEvent}">start
        <img alt="previous"
          src="{$resourcesRoot}/resources/arrowRight.gif"
          width="13"
          height="13"
          border="0"/>
      </a>
    </div>
    <h1>Entering Events</h1>
    <ol id="introduction">
      <li>
        Before submitting a public event, <a href="/cal">see if it has already been
        entered</a>. It is possible that an event may be created under a
        different title than you'd expect.
      </li>
      <li>
        Make your titles descriptive: rather than
        "Lecture" use "Music Lecture Series: 'Uses of the
        Neapolitan Chord'". "Cinema Club" would also be too vague,
        while "Cinema Club: 'Citizen Kane'" is better. Bear in
        mind that your event will "share the stage" with other events
        in the calendar - try to be as clear as possible when
        thinking of titles. Express not only what the event is, but
        (briefly) what it's about. Elaborate on the event in the
        description field, but try not to repeat the same
        information.  Try to think like a user when suggesting an event:
        use language that will explain your event to someone who knows
        absolutely nothing about it.
      </li>
      <li>
        Do not include locations and times in the description
        field (unless it is to add extra information not already
        displayed).
      </li>
    </ol>
  </xsl:template>

  <!--==== ADD EVENT ====-->
  <xsl:template match="formElements" mode="addEvent">
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$addEvent}" id="standardForm" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}');">
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="formElements" mode="editEvent">
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$updateEvent}" id="standardForm" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}');">
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
    <!-- comment field to hold the user's suggestions:  -->
    <input type="hidden" name="xbwsubmitcomment" id="bwEventComment" value=""/>

      <!-- event info for edit event -->
      <xsl:if test="/bedework/creating != 'true'">

        <table class="common" cellspacing="0">
          <tr>
            <th colspan="2" class="commonHeader">
              <div id="eventActions">
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
              <xsl:variable name="entityType">
                <xsl:choose>
                  <xsl:when test="entityType = '2'">Task</xsl:when>
                  <xsl:when test="scheduleMethod = '2'">Meeting</xsl:when>
                  <xsl:otherwise>Event</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="form/recurringEntity='true' or recurrenceId != ''">
                Recurring
              </xsl:if>
              <xsl:choose>
                <xsl:when test="form">
                  <!-- just a placeholder: need to add owner to the jsp -->
                  Personal <xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:when test="public = 'true'">
                  Public <xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entityType"/> (<xsl:value-of select="calendar/owner"/>)
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="form/recurringEntity='true' and recurrenceId = ''">
                <xsl:text> </xsl:text>
                <em>(recurrence master)</em>
              </xsl:if>
            </th>
          </tr>
        </table>
      </xsl:if>

    <div id="instructions">
      <div id="bwHelp-Details">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');hide('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details');"
             onclick="return validateStep1();">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
        <strong>Step 1:</strong> Enter Event Details. <em>Optional fields are italicized.</em>
      </div>
      <div id="bwHelp-Location" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');"
             onclick="return validateStep2();">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
        <strong>Step 2:</strong> Select Location.
      </div>
      <div id="bwHelp-Contact" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwEventTab-Categories','bwHelp-Categories','bwBottomNav-Categories'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');"
             onclick="return validateStep3();">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
        <strong>Step 3:</strong> Select Contact.
      </div>
      <div id="bwHelp-Categories" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); ">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
        <strong>Step 4:</strong> Select Categories. <em>Optional.</em>
      </div>
      <div id="bwHelp-Review" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); hide('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); ">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a>
          <span class="hidden">
            <!-- this is here just to take up the appropriate space  -->
            <xsl:text> </xsl:text>| next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </span>
        </div>
        <strong>Step 5:</strong> Add Comments. <em>Optional.</em>
      </div>
    </div>

    <div id="eventFormContent">
      <!-- Basic tab -->
      <!-- ============== -->
      <!-- this tab is visible by default -->
      <div id="bwEventTab-Details">
        <table cellspacing="0" class="common">
          <!-- Calendar -->
          <!-- ======== -->
          <xsl:variable name="submissionCalendars">
            <xsl:value-of select="count(/bedework/myCalendars//calendar[calType='1'])"/>
          </xsl:variable>
          <tr>
            <xsl:if test="$submissionCalendars = 1">
              <xsl:attribute name="class">invisible</xsl:attribute>
              <!-- hide this row altogether if there is only one calendar; if you want the calendar
                   path displayed, comment out this xsl:if. -->
            </xsl:if>
            <td class="fieldname">
              Calendar:
            </td>
            <td class="fieldval">
              <xsl:choose>
                <xsl:when test="$submissionCalendars = 1">
                  <!-- there is only 1 writable calendar, just send a hidden field -->
                  <xsl:variable name="newCalPath"><xsl:value-of select="/bedework/myCalendars//calendar[calType='1']/path"/></xsl:variable>
                  <input type="hidden" name="newCalPath" value="{$newCalPath}"/>
                  <span id="bwEventCalDisplay">
                    <xsl:value-of select="$newCalPath"/>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <select name="newCalPath" id="bwNewCalPathField">
                    <xsl:for-each select="/bedework/myCalendars//calendar[calType='1']">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                        <xsl:value-of select="substring-after(substring-after(path,/bedework/submissionsRoot/unencoded),'/')"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <!--  Summary (title) of event  -->
          <!--  ========================= -->
          <tr>
            <td class="fieldname">
              Title:
            </td>
            <td class="fieldval">
              <div id="bwEventTitleNotice" class="invisible">You must include a title.</div> <!-- a holder for validation notes -->
              <xsl:variable name="title" select="form/title/input/@value"/>
              <input type="text" name="summary" size="80" value="{$title}" id="bwEventTitle"/>
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
              all day

              <!-- HIDE floating event: no timezone (and not UTC)
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
              floating -->

              <!-- HIDE store time as coordinated universal time (UTC)
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
              store as UTC-->

              <br/>
              <div class="dateStartEndBox">
                <strong>Start:</strong>
                <div class="dateFields">
                  <span class="startDateLabel">Date </span>
                  <xsl:choose>
                    <xsl:when test="$portalFriendly = 'true'">
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
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/resources/');
                        </xsl:comment>
                      </script>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetStartDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                      <xsl:text> </xsl:text>
                      </span -->
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
                <strong>
                  <xsl:choose>
                    <xsl:when test="form/entityType = '2'">Due:</xsl:when>
                    <xsl:otherwise>End:</xsl:otherwise>
                  </xsl:choose>
                </strong>
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
                    <xsl:choose>
                      <xsl:when test="$portalFriendly = 'true'">
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
                        <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                          endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/resources/');
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
                  This
                  <xsl:choose>
                    <xsl:when test="form/entityType = '2'">task</xsl:when>
                    <xsl:otherwise>event</xsl:otherwise>
                  </xsl:choose>
                  has no duration / end date
                </div>
              </div>
            </td>
          </tr>

          <!--  Description  -->
          <tr>
            <td class="fieldname">Description:</td>
            <td class="fieldval">
              <div id="bwEventDescNotice" class="invisible">You must include a description.</div> <!-- a holder for validation notes -->
              <xsl:choose>
                <xsl:when test="normalize-space(form/desc/textarea) = ''">
                  <textarea name="description" cols="60" rows="4" id="bwEventDesc">
                    <xsl:text> </xsl:text>
                  </textarea>
                  <!-- keep this space to avoid browser
                  rendering errors when the text area is empty -->
                </xsl:when>
                <xsl:otherwise>
                  <textarea name="description" cols="60" rows="4" id="bwEventDesc">
                    <xsl:value-of select="form/desc/textarea"/>
                  </textarea>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <!--  Status  -->
          <tr>
            <td class="fieldname">
              Status:
            </td>
            <td class="fieldval">
              <input type="radio" name="eventStatus" value="CONFIRMED">
                <xsl:if test="form/status = 'CONFIRMED' or /bedework/creating = 'true' or form/status = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              confirmed
              <input type="radio" name="eventStatus" value="TENTATIVE">
                <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              tentative
              <input type="radio" name="eventStatus" value="CANCELLED">
                <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              cancelled
            </td>
          </tr>
          <!-- Cost -->
          <tr>
            <td class="fieldname"><em>Cost:</em></td>
            <td class="fieldval">
              <input type="text" name="event.cost" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/cost/input/@value"/></xsl:attribute>
              </input>
              <span class="note"> optional: if any, and place to purchase tickets</span>
            </td>
          </tr>
          <!--  Link (url associated with event)  -->
          <tr>
            <td class="fieldname"><em>Event URL:</em></td>
            <td class="fieldval">
              <input type="text" name="event.link" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
              </input>
              <span class="note"> optional: for more information about the event</span>
            </td>
          </tr>
          <!-- Image Url -->
          <tr>
            <td class="fieldname"><em>Image URL:</em></td>
            <td class="fieldval">
              <input type="text" name="xBwImageHolder" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:attribute>
              </input>
              <xsl:text> </xsl:text>
              <span class="note"> optional: to include an image with the event description</span>
            </td>
          </tr>
        </table>
      </div>

      <!-- Location tab -->
      <!-- ============== -->
      <div id="bwEventTab-Location" class="invisible">
        <div id="bwLocationUidNotice" class="invisible">You must either select a location or suggest one below.</div>
        <div class="mainForm">
          <span id="eventFormLocationList">
            <select name="locationUid" class="bigSelect" id="bwLocationUid">
              <option value="">select an existing location...</option>
              <xsl:copy-of select="form/location/locationmenu/select/*"/>
            </select>
          </span>
        </div>
        <p class="subFormMessage">
          Didn't find the location?  Suggest a new one:
        </p>
        <div class="subForm">
          <p>
            <label for="commentLocationAddress">Address: </label>
            <input type="text" name="commentLocationAddress" id="bwCommentLocationAddress">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text"/></xsl:attribute>
            </input>
          </p>
          <p>
            <label for="commentLocationSubaddress"><em>Sub-address:</em> </label>
            <input type="text" name="commentLocationSubaddress" id="commentLocationSubaddress">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-SUBADDRESS']"/></xsl:attribute>
            </input>
            <span class="note"> optional</span>
          </p>
          <p>
            <label for="commentLocationURL"><em>URL:</em> </label>
            <input type="text" name="commentLocationURL" id="commentLocationURL">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:attribute>
            </input>
            <span class="note"> optional</span>
          </p>
        </div>
      </div>

      <!-- Contact tab -->
      <!-- ============== -->
      <div id="bwEventTab-Contact" class="invisible">
        <div id="bwContactUidNotice" class="invisible">You must either select a contact or suggest one below.</div>
        <div class="mainForm">
          <select name="contactUid" id="bwContactUid" class="bigSelect">
            <option value="">
              select an existing contact...
            </option>
            <xsl:copy-of select="form/contact/all/select/*"/>
          </select>
        </div>
        <p class="subFormMessage">
          Didn't find the contact you need?  Suggest a new one:
        </p>
        <div class="subForm">
          <p>
            <label for="commentContactName">Organization Name: </label>
            <input type="text" name="commentContactName" id="bwCommentContactName" size="40">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/values/text"/></xsl:attribute>
            </input>
            <span class="note"> Please limit contacts to organizations, not individuals.</span>
          </p>
          <p>
            <label for="commentContactPhone"><em>Phone:</em> </label>
            <input type="text" name="commentContactPhone">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-PHONE']"/></xsl:attribute>
            </input>
            <span class="note"> optional</span>
          </p>
          <p>
            <label for="commentContactURL"><em>URL:</em> </label>
            <input type="text" name="commentContactURL">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:attribute>
            </input>
            <span class="note"> optional</span>
          </p>
          <p>
            <label for="commentContactEmail"><em>Email:</em> </label>
            <input type="text" name="commentContactEmail">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-EMAIL']"/></xsl:attribute>
            </input>
            <span class="note"> optional</span>
          </p>
        </div>
      </div>

      <!-- Categories tab -->
      <!-- ============== -->
      <div id="bwEventTab-Categories" class="invisible">
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
                      <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:value-of select="keyword"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                    <input type="checkbox" name="categoryKey">
                      <xsl:attribute name="value"><xsl:value-of select="keyword"/></xsl:attribute>
                      <xsl:if test="keyword = ../../current//category/keyword"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:value-of select="keyword"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
              </tr>
            </table>
          </xsl:otherwise>
        </xsl:choose>
        <p class="subFormMessage">
          Didn't find the category you want?  Suggest a new one:
        </p>
        <div class="subForm">
          <p>
            <label for="commentCategories">Category suggestion: </label>
            <input type="text" name="commentCategories" size="30">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text"/></xsl:attribute>
            </input>
          </p>
        </div>
      </div>

      <!--   Review tab   -->
      <!-- ============== -->
      <div id="bwEventTab-Review" class="invisible">
        <!--  <table id="bwEventSubmitReview" class="common">
          <tr>
            <th colspan="2">Event Details</th>
          </tr>-->
          <!-- the form elements will be inserted here -->
        <!-- </table>-->
        <div id="bwCommentNotes">
          Please supply any final notes or instructions regarding your event:<br/>
          <!-- note: don't remove the #160 from the textarea or browsers will see it as a closed tag when empty -->
          <textarea name="commentNotes" cols="60" rows="4"><!--
           --><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text"/>&#160;<!--
           --></textarea>
        </div>
        <div class="eventSubmitButtons">
          <input name="submit" class="submit" type="submit" value="submit for approval"/>
          <input name="cancelled" type="submit" value="cancel"/>
        </div>
      </div>
    </div>

    <div id="bwBottomNav">
      <div id="bwBottomNav-Details">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details');">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Location" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Contact" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwEventTab-Categories','bwHelp-Categories','bwBottomNav-Categories'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');">
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Categories" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a> |
          <a href="javascript:show('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <!-- displayReview('standardForm','bwEventSubmitReview',1) -->
            next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Review" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); hide('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); ">
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowLeft.gif"
              width="13"
              height="13"
              border="0"/>
          previous</a>
          <span class="hidden">
            <xsl:text> </xsl:text>| next
            <img alt="previous"
              src="{$resourcesRoot}/resources/arrowRight.gif"
              width="13"
              height="13"
              border="0"/>
          </span>
        </div>
      </div>
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

  <!--++++++++++++++++++ Events ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <h1>Pending Events</h1>
    <p>
      The events below are waiting to be published by a
      calendar administrator.  You may edit or delete the
      events until they have been accepted.  Once your
      event is picked up, you
      will no longer see it in your list.
    </p>
    <xsl:call-template name="eventListCommon"/>
  </xsl:template>

  <xsl:template name="eventListCommon">
    <table id="commonListTable">
      <tr>
        <th>Title</th>
        <!-- <th>Submitted</th> -->
        <th>Start</th>
        <th>End</th>
        <th>Categories</th>
        <th>Description</th>
      </tr>

      <xsl:for-each select="/bedework/events/event">
        <xsl:variable name="subscriptionId" select="subscription/id"/>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="guid" select="guid"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <tr>
          <td>
            <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:choose>
                <xsl:when test="summary != ''">
                  <xsl:value-of select="summary"/>
                </xsl:when>
                <xsl:otherwise>
                  <em>no title</em>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <!-- need to output created date
          <td class="date">
            <xsl:value-of select="end/longdate"/>
          </td> -->
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
          <td>
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><br/>
            </xsl:for-each>
          </td>
          <td>
            <xsl:value-of select="description"/>
            <xsl:if test="recurring = 'true' or recurrenceId != ''">
              <div class="recurrenceEditLinks">
                Recurring event.
                Edit:
                <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}">
                  master
                </a> |
                <a href="{$editEvent}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  instance
                </a>
              </div>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
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
            <input type="hidden" name="newCalPath" id="bwNewCalPathField" value=""/>
            <span id="bwEventCalDisplay">
              <em>default calendar</em>
            </span>
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

  <!--==== UTILITY TEMPLATES ====-->

  <!-- time formatter (should be extended as needed) -->
  <xsl:template name="timeFormatter">
    <xsl:param name="timeString"/><!-- required -->
    <xsl:param name="showMinutes">yes</xsl:param>
    <xsl:param name="showAmPm">yes</xsl:param>
    <xsl:param name="hour24">no</xsl:param>
    <xsl:variable name="hour" select="number(substring($timeString,1,2))"/>
    <xsl:variable name="minutes" select="substring($timeString,3,2)"/>
    <xsl:variable name="AmPm">
      <xsl:choose>
        <xsl:when test="$hour &lt; 12">AM</xsl:when>
        <xsl:otherwise>PM</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="hour24 = 'yes'">
        <xsl:value-of select="$hour"/><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$hour = 0">12</xsl:when>
          <xsl:when test="$hour &lt; 13"><xsl:value-of select="$hour"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$hour - 12"/></xsl:otherwise>
        </xsl:choose><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
        <xsl:if test="$showAmPm = 'yes'">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$AmPm"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      Based on the <a href="http://www.bedework.org/">Bedework Calendar System</a>
    </div>
    <div id="subfoot">
      <a href="http://www.bedework.org/">Bedework Website</a> |
      <a href="?noxslt=yes">show XML</a> |
      <a href="?refreshXslt=yes">refresh XSLT</a>
    </div>
  </xsl:template>

  <!--==== Utility Templates ====-->

  <xsl:template name="escapeApos">
    <xsl:param name="str"/>
    <xsl:variable name="apos" select='"&apos;"'/>
    <xsl:choose>
      <xsl:when test="contains($str, $apos)">
         <xsl:value-of select="substring-before($str, $apos)" />
         <xsl:text>\'</xsl:text>
         <xsl:call-template name="escapeApos">
            <xsl:with-param name="str" select="substring-after($str, $apos)" />
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$str" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

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
</xsl:stylesheet>
