<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="no" media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    DEMONSTRATION CALENDAR STYLESHEET

    MainCampus Calendar Suite - Duke/Yale Skin

    This stylesheet is devoid of school branding.  It is a good
    starting point for development of a customized calendar.

    It is based on work by Duke University and Yale University.

    For detailed instructions on how to work with the XSLT
    stylesheets included with this distribution, please see the
    Bedework Design Guide at
    http://www.bedework.org/bedework/update.do?artcenterkey=24

    ===============================================================  -->
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

  <!-- ================================= -->
  <!--  DEMO PUBLIC CALENDAR STYLESHEET  -->
  <!-- ================================= -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="../../../bedework-common/default/default/errors.xsl" />
  <xsl:include href="../../../bedework-common/default/default/messages.xsl" />
  <xsl:include href="../../../bedework-common/default/default/util.xsl" />
  <xsl:include href="./strings.xsl" />

  <!-- Page subsections -->
  <xsl:include href="./defaultTheme/header.xsl" />
  <xsl:include href="./defaultTheme/footer.xsl" />
  <xsl:include href="./defaultTheme/display-events.xsl" />
  <!-- <xsl:include href="featured.xsl"/> -->

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of html resources (images, css, other html); by default this is
    set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot" />/default/default/defaultTheme</xsl:variable>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
    included stylesheets and xml fragments. These are generally
    referenced relatively (like errors.xsl and messages.xsl above);
    this variable is here for your convenience if you choose to
    reference it explicitly.  It is not used in this stylesheet, however,
    and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot" />

  <!-- Properly encoded prefixes to the application actions; use these to build
    urls; allows the application to be used without cookies or within a portal.
    These urls are rewritten in header.jsp and simply passed through for use
    here. Every url includes a query string (either ?b=de or a real query
    string) so that all links constructed in this stylesheet may begin the
    query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup" />
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection" />
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars" />
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod" />
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents" />
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView" />
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef" />
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export" />
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search" />
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next" />
  <xsl:variable name="calendar-fetchForExport" select="/bedework/urlPrefixes/calendar/fetchForExport" />
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent" />
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats/stats" />

  <!-- acheck -->
  <xsl:variable name="allGroupsAppVar">&amp;setappvar=group(all)</xsl:variable>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix" />

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate" />
  <xsl:variable name="nextdate" select="/bedework/nextdate" />
  <xsl:variable name="curdate" select="/bedework/currentdate/date" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>
          <xsl:choose>
            <xsl:when test="/bedework/page='event'">
              <xsl:value-of select="/bedework/event/summary" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$bwStr-Root-PageTitle" />
            </xsl:otherwise>
          </xsl:choose>
        </title>

        <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />

        <!-- address bar favicon -->
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />

        <!-- load css -->
        <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/fixed.css" />
        <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />

        <!-- Dependencies -->
        <xsl:text disable-output-escaping="yes">
          <![CDATA[
          <!--[if IE 6]>
            <link rel="stylesheet" type="text/css" media="screen" href="/calrsrc.MainCampus/default/default/defaultTheme/css/ie6.css"/>
          <![endif]-->

          <!--[if IE 7]>
            <link rel="stylesheet" type="text/css" media="screen" href="/calrsrc.MainCampus/default/default/defaultTheme/css/ie7.css"/>
          <![endif]-->
          ]]>
        </xsl:text>

        <!-- load javascript -->
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/yahoo-dom-event.js">&#160;</script>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/calendar-min.js">&#160;</script>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/animation-min.js">&#160;</script>
        <xsl:if test="/bedework/page='searchResult'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/catSearch.js">&#160;</script>
        </xsl:if>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/mainCampus.js">&#160;</script>
        <script type="text/javascript">
          <xsl:call-template name="jsonDataObject" />
        </script>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/ifs-calendar.js">&#160;</script>
      </head>
      <body>
        <div id="wrap">
          <div id="header">
            <xsl:call-template name="titleBar" />
            <xsl:call-template name="tabs" />
          </div>
          <xsl:if test="/bedework/error">
            <div id="errors">
              <xsl:apply-templates
                select="/bedework/error" />
            </div>
          </xsl:if>
          <div id="content">
            <xsl:choose>
              <!-- Set up the layouts for each type of display -->
              <!-- Layout for: Single Event Display-->
              <xsl:when test="/bedework/page = 'event'">
                <div id="contentSection">
                  <xsl:call-template name="display-left-column" />
                  <div class="double_center_column" id="center_column">
                    <div class="secondaryColHeader">
                      <h3>Event Information</h3>
                    </div>
                    <xsl:apply-templates select="/bedework/event" />
                    <div class="right_column" id="right_column"></div>
                  </div>
                </div>
              </xsl:when>

              <!-- Layout for: Calendar List -->
              <xsl:when test="/bedework/page='calendarList'">
                <div id="contentSection">
                  <div class="secondaryColHeader">
                    <h3>All Calendars</h3>
                  </div>
                  <xsl:apply-templates select="/bedework/calendars" />
                </div>
              </xsl:when>

              <!-- Layout for: Search Results -->
              <xsl:when test="/bedework/page='searchResult'">
                <div id="contentSection">
                  <xsl:call-template name="display-left-column" />
                </div>
                <div class="double_center_column" id="right_column">
                </div>
                <div class="double_center_column" id="center_column">
                  <xsl:call-template name="searchResult" />
                  <xsl:call-template name="advancedSearch" />
                </div>
              </xsl:when>

              <!-- Main calendar output -->
              <xsl:when test="/bedework/page='eventscalendar'">
                <xsl:choose>
                  <!-- Layout for Current Day -->
                  <!-- Here we expose the Featured Events -->
                  <xsl:when test="/bedework/periodname = 'Today' or (/bedework/periodname = 'Day' and (/bedework/now/date = /bedework/currentdate/date))">
                    <div id="contentSection">
                      <xsl:call-template name="jsDateSelectionCal" />
                      <div id="feature">
                        <xsl:apply-templates select="document('defaultTheme/data/FeaturedEvent/FeaturedEvent.xml')/system-data-structure" />
                      </div>
                      <div class="clear">&#160;</div>
                    </div>
                    <div id="contentSection">
                      <div class="left_column">
                        <xsl:call-template name="display-side-bar" />
                      </div>
                      <xsl:call-template name="groupsList" />

                      <xsl:call-template name="display-center-column" />
                      <div class="right_column" id="right_column">
                        <xsl:call-template name="ongoingEventList" />
                      </div>
                    </div>
                  </xsl:when>

                  <!-- Layout for: Day, Week, and Month (list only) -->
                  <xsl:when test="/bedework/periodname != 'Year' ">
                    <div id="contentSection">
                      <xsl:call-template name="display-left-column" />
                      <xsl:call-template name="display-center-column" />
                      <div class="right_column" id="right_column">
                        <xsl:call-template name="ongoingEventList" />
                      </div>
                    </div>
                  </xsl:when>

                  <!-- Layout for: Year -->
                  <xsl:when
                    test="bedework/periodname = 'Year'">
                    <div id="contentSection">
                      <xsl:call-template name="display-left-column" />
                      <div class="double_center_column" id="center_column">
                        <div class="secondaryColHeader">
                          <xsl:call-template name="navigation" />
                        </div>
                        <xsl:call-template name="yearView" />
                      </div>
                      <div class="right_column" id="right_column"></div>
                    </div>
                  </xsl:when>

                </xsl:choose>
              </xsl:when>

              <!-- Layout for: System Stats -->
              <xsl:when test="/bedework/page='showSysStats'">
                <xsl:call-template name="stats" />
              </xsl:when>

              <!-- page for calendar export (can optionally be replaced by
                a pop-up widget; see the calendars template) -->
              <xsl:when test="/bedework/page='displayCalendarForExport'">
                <xsl:apply-templates select="/bedework/currentCalendar" mode="export" />
              </xsl:when>

              <!-- Layout for: Catch all errors -->
              <xsl:otherwise>
                Error: <xsl:value-of select="/bedework/page" />
              </xsl:otherwise>
            </xsl:choose>

            <div class="clear">&#160;</div>
          </div>
          <!-- footer -->
          <xsl:call-template name="footer" />
        </div>

      </body>
    </html>
  </xsl:template>

  <!--======= Display Left Column ===========-->
  <xsl:template name="display-left-column">
    <div class="left_column">
      <xsl:call-template name="jsDateSelectionCal" />
      <div class="clear">&#160;</div>
      <xsl:call-template name="display-side-bar" />
    </div>
    <xsl:call-template name="groupsList" />
  </xsl:template>

  <!--======= Display Center Column ===========-->
  <xsl:template name="display-center-column">
    <div class="center_column" id="center_column">
      <div class="secondaryColHeader">
        <xsl:call-template name="navigation" />
      </div>
      <xsl:call-template name="list-view">
        <xsl:with-param name="node" select="." />
        <xsl:with-param name="suite-name">Main</xsl:with-param>
      </xsl:call-template>
    </div>
  </xsl:template>

  <!--============= Display Side Bar ======-->
  <xsl:template name="display-side-bar">
    <xsl:call-template name="viewList" />
    <div class="sideBarContainer">
      <h4>FILTER BY GROUP/ ORG/ DEPT:</h4>
      <ul class="sideLinks">
        <li>
          <a href="#"
            onClick="javascript:toggleDiv('groupListDiv'); toggleDiv('right_column'); toggleDiv('center_column');">
            Group List
          </a>
        </li>
      </ul>
      <xsl:call-template name="display-events-calendar-info" />
      <xsl:call-template name="sideLinksList" />
    </div>
  </xsl:template>

  <!--============= Display Events Calendar Info ======-->
  <xsl:template name="display-events-calendar-info">
    <h4>EVENTS CALENDAR INFO:</h4>
    <ul class="sideLinks">
      <li>
        <a href="/caladmin">Manage Events</a>
      </li>
      <li>
        <a href="/eventsubmit?setappvar=confirmed(no)">
          Submit an Event
        </a>
      </li>
      <li>
        <a href="http://calendar.duke.edu/help">Help</a>
      </li>
    </ul>
  </xsl:template>

  <!--============= System Data Structure  ======-->
  <xsl:template match="system-data-structure">

    <xsl:variable name="imageFilenameLEFT"
      select="left-image/image1/name" />
    <xsl:variable name="featureLinkLEFT"
      select="left-image/featureLink" />
    <xsl:variable name="toolTipLEFT" select="left-image/toolTip" />
    <xsl:variable name="imageFilenameCENTER"
      select="middle-image/image2/name" />
    <xsl:variable name="featureLinkCENTER"
      select="middle-image/featureLink" />
    <xsl:variable name="toolTipCENTER"
      select="middle-image/toolTip" />
    <xsl:variable name="imageFilenameRIGHT"
      select="right-image/image3/name" />
    <xsl:variable name="featureLinkRIGHT"
      select="right-image/featureLink" />
    <xsl:variable name="toolTipRIGHT" select="right-image/toolTip" />

    <xsl:choose>
      <xsl:when test="$featureLinkLEFT = ''">
        <img class="border"
          src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameLEFT}"
          alt="{$toolTipLEFT}" />
      </xsl:when>
      <xsl:otherwise>
        <a href="{$featureLinkLEFT}">
          <img class="border"
            src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameLEFT}"
            alt="{$toolTipLEFT}" />
        </a>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$featureLinkCENTER = ''">
        <img class="border"
          src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameCENTER}"
          alt="{$toolTipCENTER}" />
      </xsl:when>
      <xsl:otherwise>
        <a href="{$featureLinkCENTER}">
          <img class="border"
            src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameCENTER}"
            alt="{$toolTipCENTER}" />
        </a>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$featureLinkRIGHT = ''">
        <img
          src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameRIGHT}"
          alt="{$toolTipRIGHT}" />
      </xsl:when>
      <xsl:otherwise>
        <a href="{$featureLinkRIGHT}">
          <img
            src="{$resourcesRoot}/data/FeaturedEvent/{$imageFilenameRIGHT}"
            alt="{$toolTipRIGHT}" />
        </a>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- JavaScript Array for Calendar (might be good to turn into JSON if more properties need to be passed in)-->
  <xsl:template name="jsonDataObject">
    <!-- Month to display (to be handed in to js, so it aligns with the events beeing shown) -->
    <xsl:variable name="displayMonthYear">
      <xsl:value-of select="substring(/bedework/currentdate/date,5,2)" />
      <xsl:text>/</xsl:text>
      <xsl:value-of select="substring(/bedework/currentdate/date,0,5)" />
    </xsl:variable>
    <xsl:variable name="rangeStartMo">
      <xsl:value-of select="substring(/bedework/firstday/date,5,2)" />
    </xsl:variable>
    <xsl:variable name="rangeStartDay">
      <xsl:value-of select="substring(/bedework/firstday/date,7,2)" />
    </xsl:variable>
    <xsl:variable name="rangeStartYear">
      <xsl:value-of select="substring(/bedework/firstday/date,1,4)" />
    </xsl:variable>
    <xsl:variable name="rangeEndMo">
      <xsl:value-of select="substring(/bedework/lastday/date,5,2)" />
    </xsl:variable>
    <xsl:variable name="rangeEndDay">
      <xsl:value-of select="substring(/bedework/lastday/date,7,2)" />
    </xsl:variable>
    <xsl:variable name="rangeEndYear">
      <xsl:value-of select="substring(/bedework/lastday/date,1,4)" />
    </xsl:variable>
    navcalendar = [ "<xsl:value-of select="$displayMonthYear" />", "<xsl:value-of select="$rangeStartMo" />", "<xsl:value-of select="$rangeStartDay" />", "<xsl:value-of select="$rangeStartYear" />", "<xsl:value-of select="$rangeEndMo" />", "<xsl:value-of select="$rangeEndDay" />", "<xsl:value-of select="$rangeEndYear" />", ];
  </xsl:template>

  <!-- Date Selection Cal -->
  <xsl:template name="jsDateSelectionCal">
    <div id="cal1" class="calContainer">
      <xsl:call-template name="dateSelectForm" />
      <p>
        To view the interactive calendar, please enable
        Javascript on your browser.
      </p>
    </div>
  </xsl:template>

  <xsl:template name="ongoingEventList">
    <h3 class="secondaryColHeader">Ongoing</h3>
    <ul class="eventList">
      <xsl:for-each
        select="/bedework/eventscalendar/year/month/week/day/event[(categories/category[value|word = 'Main']) and (categories/category[value|word = 'Ongoing']) and not(categories/category[value|word = 'Local'])]">
        <xsl:sort select="start/unformatted" order="ascending"
          data-type="number" />
        <xsl:sort select="id" data-type="number" />
        <xsl:variable name="lastId" select="id" />
        <xsl:if test="not(preceding::event[id=$lastId])">
          <xsl:choose>
            <xsl:when
              test="(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (not(/bedework/appvar[key = 'category']/value) or (/bedework/appvar[key = 'category']/value = 'all'))">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:variable name="envgroup"
                select="/bedework/appvar[key = 'group']/value" />
              <xsl:variable name="cosponsor"
                select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION" />
              <xsl:choose>
                <xsl:when
                  test="/bedework/appvar[key = 'group']/value = $creator">
                  <xsl:call-template
                    name="ongoingEvent" />
                </xsl:when>
                <xsl:when
                  test="contains($cosponsor, concat($envgroup,','))">
                  <xsl:call-template
                    name="ongoingEvent" />
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:when
              test="not(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value = 'all')">
              <xsl:call-template
                name="split-for-ongoing">
                <xsl:with-param name="list">
                  <xsl:value-of
                    select="/bedework/appvar[key = 'category']/value" />
                </xsl:with-param>
                <xsl:with-param name="delimiter">
                  ~
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when
              test="(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value = 'all')">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:variable name="envgroup"
                select="/bedework/appvar[key = 'group']/value" />
              <xsl:variable name="cosponsor"
                select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION" />
              <xsl:choose>
                <xsl:when
                  test="/bedework/appvar[key = 'group']/value = $creator">
                  <xsl:call-template
                    name="split-for-ongoing">
                    <xsl:with-param name="list">
                      <xsl:value-of
                        select="/bedework/appvar[key = 'category']/value" />
                    </xsl:with-param>
                    <xsl:with-param
                      name="delimiter">
                      ~
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when
                  test="contains($cosponsor, concat($envgroup,','))">
                  <xsl:call-template
                    name="split-for-ongoing">
                    <xsl:with-param name="list">
                      <xsl:value-of
                        select="/bedework/appvar[key = 'category']/value" />
                    </xsl:with-param>
                    <xsl:with-param
                      name="delimiter">
                      ~
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="ongoingEvent" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template name="split-for-ongoing">
    <xsl:param name="list" />
    <xsl:param name="delimiter" />
    <xsl:variable name="newlist">
      <xsl:choose>
        <xsl:when test="contains($list, $delimiter)">
          <xsl:value-of select="normalize-space($list)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="concat(normalize-space($list), $delimiter)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="first"
      select="substring-before($newlist, $delimiter)" />
    <xsl:variable name="remaining"
      select="substring-after($newlist, $delimiter)" />
    <xsl:choose>
      <xsl:when test="$first = categories/category/value">
        <xsl:call-template name="ongoingEvent" />
      </xsl:when>
      <xsl:when test="$first = categories/category/word">
        <xsl:call-template name="ongoingEvent" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$remaining">
          <xsl:call-template name="split-for-ongoing">
            <xsl:with-param name="list" select="$remaining" />
            <xsl:with-param name="delimiter">
              <xsl:value-of select="$delimiter" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ongoingEvent">
    <li>
      <xsl:variable name="subscriptionId"
        select="subscription/id" />
      <xsl:variable name="calPath" select="calendar/encodedPath" />
      <xsl:variable name="guid" select="guid" />
      <xsl:variable name="recurrenceId" select="recurrenceId" />
      <xsl:variable name="statusClass">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">
            bwStatusCancelled
          </xsl:when>
          <xsl:when test="status='TENTATIVE'">
            bwStatusTentative
          </xsl:when>
          <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="status != 'CONFIRMED'">
        <xsl:value-of select="status" />
        <xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:value-of select="summary" />
      , Ends
      <xsl:value-of select="end/shortdate" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="end/time" />
      <xsl:text> |</xsl:text>
      <a
        href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
        more
      </a>
      <xsl:text>|</xsl:text>
    </li>
  </xsl:template>

  <!-- Notices List -->
  <xsl:template name="noticesList">
    <h3 class="secondaryColHeader">Notices</h3>
    <ul>
      <xsl:for-each
        select="/bedework/eventscalendar/year/month/week/day/event[categories/category/value = 'Reminder']">
        <li>
          <xsl:variable name="subscriptionId"
            select="subscription/id" />
          <xsl:variable name="calPath"
            select="calendar/encodedPath" />
          <xsl:variable name="guid" select="guid" />
          <xsl:variable name="recurrenceId"
            select="recurrenceId" />
          <xsl:variable name="statusClass">
            <xsl:choose>
              <xsl:when test="status='CANCELLED'">
                bwStatusCancelled
              </xsl:when>
              <xsl:when test="status='TENTATIVE'">
                bwStatusTentative
              </xsl:when>
              <xsl:otherwise>
                bwStatusConfirmed
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="status != 'CONFIRMED'">
            <xsl:value-of select="status" />
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="summary" />
          <xsl:text> | </xsl:text>
          <a
            href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
            more
          </a>
          <xsl:text> |</xsl:text>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- View List -->
  <xsl:template name="viewList">
    <div class="secondaryColHeader">
      <h3>Calendar Views</h3>
    </div>
    <ul class="viewList">
      <!-- <xsl:for-each select="/bedework/views/view">
        <xsl:variable name="viewName" select="name/text()"/>
        <li>
        <a href="{$setSelection}&amp;viewName={$viewName}">
        <xsl:if test="$viewName = (/bedework/selectionState/view/name)">
        <xsl:attribute name="class">current</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$viewName"/>
        </a>
        </li>
        </xsl:for-each> -->
      <li>
        <a
          href="/cal/?setappvar=category(all)&amp;setappvar=categoryclass(all)">
          <xsl:if
            test="((/bedework/appvar[key = 'categoryclass']/value = 'all') or not(/bedework/appvar[key = 'categoryclass']/value))">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          All
        </a>
      </li>
      <li>
        <!-- <a href="/cal/?setappvar=category(Academic Calendar Dates)&amp;setappvar=categoryclass(Academic Calendar Dates)">
          <xsl:if test="/bedework/appvar[key = 'categoryclass']/value = 'Academic Calendar Dates'">
          <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if> -->
        <a
          href="http://www.registrar.duke.edu/registrar/studentpages/student/academicalendars.html">
          Official Academic Calendar
        </a>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Concert/Music~ Dance Performance~ Exhibit~ Masterclass~ Movie/Film~ Reading~ Theater)&amp;setappvar=categoryclass(Arts)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Arts
        </a>
        <span id="artsClicker">+</span>
        <ul id="artsSub" style="height:0px"
          class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
              <xsl:attribute name="style">height:170px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Concert/Music)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Concert/Music'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Concert/Music
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Dance Performance)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Dance Performance'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Dance Performance
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Exhibit)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Exhibit'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Exhibit
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Masterclass)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Masterclass'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Masterclass
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Movie/Film)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Movie/Film'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Movie/Film
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Reading)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Reading'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Reading
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Theater)&amp;setappvar=categoryclass(Arts)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Theater'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Theater
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Athletics/Intramurals/Recreation~ Athletics/Varsity Sports/Men~ Athletics/Varsity Sports/Women)&amp;setappvar=categoryclass(Athletics/Recreation)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Athletics/Recreation
        </a>
        <span id="athleticsClicker">+</span>
        <ul id="athleticsSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
              <xsl:attribute name="style">height:75px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Varsity Sports/Men)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Varsity Sports/Men'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Varsity Sports/Men
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Varsity Sports/Women)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Varsity Sports/Women'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Varsity Sports/Women
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Athletics/Intramurals/Recreation)&amp;setappvar=categoryclass(Athletics/Recreation)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Athletics/Intramurals/Recreation'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Athletics/Intramurals/Recreation
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Conference/Symposium~ Lecture/Talk~ Panel/Seminar/Colloquium)&amp;setappvar=categoryclass(Lectures/Conferences)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Lectures/Conferences
        </a>
        <span id="lecturesClicker">+</span>
        <ul id="lecturesSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
              <xsl:attribute name="style">height:75px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Conference/Symposium)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Conference/Symposium'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Conference/Symposium
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Lecture/Talk)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Lecture/Talk'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Lecture/Talk
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Panel/Seminar/Colloquium)&amp;setappvar=categoryclass(Lectures/Conferences)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Panel/Seminar/Colloquium'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Panel/Seminar/Colloquium
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Religious/Spiritual)&amp;setappvar=categoryclass(Religious/Spiritual)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Religious/Spiritual'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Religious/Spiritual
        </a>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Commencement~ Founders' Day~ Holiday~ MLK~ Parents' and Family Weekend)&amp;setappvar=categoryclass(University Events)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          University Events
        </a>
        <span id="lifeClicker">+</span>
        <ul id="lifeSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
              <xsl:attribute name="style">height:135px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Commencement)&amp;setappvar=categoryclass(University Events)&amp;date=20100501&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Commencement'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Commencement
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Founders' Day)&amp;setappvar=categoryclass(University Events)&amp;date=20091001&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = &quot;category&quot;]/value = &quot;Founders' Day&quot;">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Founders' Day
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Holiday)&amp;setappvar=categoryclass(University Events)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Holiday'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Holiday
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(MLK)&amp;setappvar=categoryclass(University Events)&amp;date=20100101&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'MLK'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              MLK
            </a>
          </li>
          <li>
            <a
              href="/cal/main/setViewPeriod.do?setappvar=category(Parents' and Family Weekend)&amp;setappvar=categoryclass(University Events)&amp;date=20091023&amp;viewType=monthView">
              <xsl:if
                test="/bedework/appvar[key = &quot;category&quot;]/value = &quot;Parents' and Family Weekend&quot;">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Parents' and Family Weekend
            </a>
          </li>
        </ul>
      </li>
      <li>
        <a
          href="/cal/?setappvar=category(Workshop/Short Course)&amp;setappvar=categoryclass(Workshop/Short Course)">
          <xsl:if
            test="/bedework/appvar[key = 'categoryclass']/value = 'Workshop/Short Course'">
            <xsl:attribute name="class">current</xsl:attribute>
          </xsl:if>
          Workshop/Short Course
        </a>
      </li>
      <li>
        <div
          style="font: bold 1.2em/2 Arial, sans-serif; display:inline;">
          Other
        </div>
        <span id="otherClicker">+</span>
        <ul id="otherSub" class="subviewList">
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key = 'categoryclass']/value = 'Other'">
              <xsl:attribute name="style">height:330px</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">height:0px</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <li>
            <a
              href="/cal/?setappvar=category(Alumni/Reunion)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Alumni/Reunion'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Alumni/Reunion
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Brown Bag)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Brown Bag'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Brown Bag
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Ceremony)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Ceremony'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Ceremony
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Health/Wellness)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Health/Wellness'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Health/Wellness
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Meeting)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Meeting'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Meeting
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Orientation)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Orientation'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Orientation
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Reception)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Reception'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Reception
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Research)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Research'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Research
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Social)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Social'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Social
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Technology)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Technology'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Technology
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Tour)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Tour'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Tour
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Training)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Training'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Training
            </a>
          </li>
          <li>
            <a
              href="/cal/?setappvar=category(Volunteer/Community Service)&amp;setappvar=categoryclass(Other)">
              <xsl:if
                test="/bedework/appvar[key = 'category']/value = 'Volunteer/Community Service'">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              Volunteer/Community Service
            </a>
          </li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <!-- Groups List -->
  <xsl:template name="groupsList">
    <div style="display:none;" id="groupListDiv">
      <div class="groupHeader">
        <h3>Select a Group</h3>
        <a href="#"
          onClick="javascript:toggleDiv('groupListDiv'); toggleDiv('right_column'); toggleDiv('center_column');">
          X - Close
        </a>
      </div>
      <ul class="groupList">
        <li>
          <a href="/cal/?setappvar=group(all)">
            <xsl:if
              test="((/bedework/appvar[key = 'group']/value = 'all') or not(/bedework/appvar[key = 'group']/value))">
              <xsl:attribute name="class">current</xsl:attribute>
            </xsl:if>
            All
          </a>
        </li>
        <xsl:for-each
          select="/bedework/urlPrefixes/groups/group[ memberof/name = 'campusAdminGroups' ]">
          <xsl:variable name="eventOwner"
            select="eventOwner/text()" />
          <xsl:variable name="groupName" select="name/text()" />
          <xsl:variable name="groupDescription"
            select="description/text()" />
          <li>
            <a
              href="/cal/?setappvar=group({$eventOwner})">
              <xsl:if
                test="$eventOwner = (/bedework/appvar[key = 'group']/value)">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$groupName" />
            </a>
            <xsl:if
              test="$groupName != $groupDescription">
              <div class="groupDesc">
                <xsl:value-of
                  select="$groupDescription" />
              </div>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <!-- Side Links Navigation -->
  <xsl:template name="sideLinksList">
    <ul class="sideLinksExpand">
      <li>
        <h4>OTHER UNIVERSITY CALENDARS</h4>
        <span id="additionalUnivClicker">+</span>
        <ul id="additionalUnivSub"
          style="height:0px;overflow:hidden;">
          <li>
            <a href="http://dukehealth.org/events"
              target="_blank">
              DukeHealth.org Event Calendar
            </a>
          </li>
          <li>
            <a
              href="http://calendar.activedatax.com/ncstate/EventList.aspx"
              target="_blank">
              NC State Calendar
            </a>
          </li>
          <li>
            <a
              href="http://webevent.nccu.edu/CalendarNOW.aspx"
              target="_blank">
              NCCU Calendar
            </a>
          </li>
          <li>
            <a href="http://events.unc.edu/cal/"
              target="_blank">
              UNC Calendar
            </a>
          </li>
        </ul>
      </li>
      <li>
        <h4>OTHER LINKS</h4>
        <span id="additionalOptionsClicker">+</span>
        <ul id="additionalOptionsSub"
          style="height:0px;overflow:hidden">
          <li>
            <a href="http://www.durham-nc.com"
              target="_blank">
              Durham Visitor's Bureau Calendar
            </a>
          </li>
          <li>
            <a href="http://map.duke.edu" target="_blank">
              Duke Campus Map
            </a>
          </li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <!-- Date Navigation -->
  <xsl:template name="navigation">
    <!-- View Options -->
    <!-- There were a few hundred lines here of all sorts of complicated tests,
      if you ever need to regain different options based on combinations of date range / list vs calendar, etc.,
      review svn or a current version bedework xsl, either way it can probably be simplified a ton -->
    <xsl:if test="/bedework/periodname != 'Year'">
      <ul id="calDisplayOptions">
        <li>
          <xsl:choose>
            <xsl:when
              test="/bedework/appvar[key='summaryMode']/value='details'">
              <a
                href="{$setup}&amp;setappvar=summaryMode(summary)"
                title="toggle                   summary/detailed view">
                Summary
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a
                href="{$setup}&amp;setappvar=summaryMode(details)"
                title="toggle                   summary/detailed view">
                Details
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </ul>
      <xsl:variable name="rssCurrDate"
        select="/bedework/currentdate/date" />
      <xsl:variable name="rssGroups">
        <xsl:choose>
          <xsl:when
            test="(/bedework/appvar[key = 'group']/value) = 'all' or not(/bedework/appvar[key = 'group']/value)">
            <xsl:text>(all)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="rssCurrGroup"
              select="/bedework/appvar[key = 'group']/value" />
            <xsl:variable name="rssGroupTemplate">
              <xsl:text>(</xsl:text>
              <xsl:value-of select="$rssCurrGroup" />
              <xsl:text>)</xsl:text>
            </xsl:variable>
            <xsl:value-of select="$rssGroupTemplate" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rssCategory">
        <xsl:choose>
          <xsl:when
            test="(/bedework/appvar[key = 'category']/value = 'all') or not(/bedework/appvar[key = 'category']/value)">
            <xsl:text>all</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="rssCurrCategory"
              select="/bedework/appvar[key = 'category']/value" />
            <xsl:variable name="rssCatTemplate">
              <xsl:text />
              <xsl:value-of select="$rssCurrCategory" />
              <xsl:text />
            </xsl:variable>
            <xsl:value-of select="$rssCatTemplate" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rssViewType">
        <xsl:if test="(/bedework/periodname) = 'Day'">
          <xsl:text>dayView</xsl:text>
        </xsl:if>
        <xsl:if test="(/bedework/periodname) = 'Week'">
          <xsl:text>weekView</xsl:text>
        </xsl:if>
        <xsl:if test="(/bedework/periodname) = 'Month'">
          <xsl:text>monthView</xsl:text>
        </xsl:if>
      </xsl:variable>
      <a id="rssRequest" class="rss"
        href="/feed/calendar/{$rssViewType}/rss/{$rssGroups}/details/{$rssCategory}"
        title="RSS feed">
<!-- &amp;date={$rssCurrDate} -->
        <img src="{$resourcesRoot}/images/feed-icon-14x14.png"
          alt="RSS Feed Icon" />
      </a>
      <div id="rssPopUp" style="display:none;position:absolute">
<!-- RSS Popup window -->
        <p id="rssClose"
          onclick="this.parentNode.style.display = 'none'">
          X - Close
        </p>
        <h5 style="padding: 6px;">RSS Feed Details</h5>
        <!-- setappvar=summaryMode(details){$rssGroups}skinName=rss{$rssCategory}viewType={$rssViewType} -->
        <ul style="padding: 6px;">
          <li style="border-bottom: solid 1px #CCC;">
            Time Period: Current
            <xsl:value-of select="/bedework/periodname" />
          </li>
          <li style="border-bottom: solid 1px #CCC;">
            Group:
            <span id="rssDetailGroup">All</span>
          </li>
          <li style="border-bottom: solid 1px #CCC;">
            Calendar Categories:
            <span id="rssDetailCategory">All</span>
          </li>
        </ul>
        <p style="padding: 6px;">
          To subscribe to an RSS feed of your current calendar
          view, copy and paste the entire URL below into your
          preferred RSS reader.
        </p>
        <p style="padding: 6px;">
          <strong>Your RSS URL:</strong>
        </p>
        <input id="rssValue" size="35" type="text" value="" />
        <ul style="padding: 6px;">
          <li>
            <a href="/feed/list/30">
              Click here for 30-day feed of events
            </a>
          </li>
          <li>
            <a href="/feed/list/60">
              Click here for 60-day feed of events
            </a>
          </li>
          <li>
            <a href="/feed/list/90">
              Click here for 90-day feed of events
            </a>
          </li>
        </ul>
      </div>
    </xsl:if>
    <a id="prevViewPeriod"
      href="{$setViewPeriod}&amp;date={$prevdate}">
      «
    </a>
    <h3>
      <xsl:choose>
        <xsl:when test="/bedework/periodname='Year'">
          <xsl:value-of
            select="substring(/bedework/firstday/date,1,4)" />
        </xsl:when>
        <xsl:when test="/bedework/periodname='Month'">
          <xsl:value-of select="/bedework/firstday/monthname" />
          ,
          <xsl:value-of
            select="substring(/bedework/firstday/date,1,4)" />
        </xsl:when>
        <xsl:when test="/bedework/periodname='Week'">
          Week of
          <xsl:value-of
            select="substring-after(/bedework/firstday/longdate,', ')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/bedework/firstday/longdate" />
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <a id="nextViewPeriod"
      href="{$setViewPeriod}&amp;date={$nextdate}">
      »
    </a>
  </xsl:template>
  <xsl:template name="searchBar">SEARCH BAR</xsl:template>
  <!--==== SINGLE EVENT ====-->
  <!-- I am going to modify this quite a bit. I don't think we need 300+ lines of code ot print out an event,
    but may want to compare this to the original if things get wonky -->
  <xsl:template match="event">
    <xsl:variable name="subscriptionId" select="subscription/id" />
    <xsl:variable name="calPath" select="calendar/encodedPath" />
    <xsl:variable name="guid" select="guid" />
    <xsl:variable name="guidEsc" select="translate(guid, '.', '_')" />
    <xsl:variable name="recurrenceId" select="recurrenceId" />
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">
          bwStatusCancelled
        </xsl:when>
        <xsl:when test="status='TENTATIVE'">
          bwStatusTentative
        </xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="singleEvent">

      <h2 class="{$statusClass} eventTitle">
        <xsl:variable name="gStartdate" select="start/utcdate" />
        <xsl:variable name="gLocation"
          select="location/address" />
        <xsl:variable name="gEnddate" select="end/utcdate" />
        <xsl:variable name="gText" select="summary" />
        <xsl:variable name="gDetails" select="summary" />
        <a class="eventIcons"
          href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
          <img title="Add to Google Calendar"
            src="{$resourcesRoot}/images/gcal.gif"
            alt="Add to Google Calendar" />
        </a>
        <xsl:choose>
          <xsl:when test="string-length($recurrenceId)">
            <a class="eventIcons"
              href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/{$subscriptionId}/Public/{$recurrenceId}/{$guidEsc}">
              <img title="Add to Facebook"
                src="{$resourcesRoot}/images/Facebook_Badge.gif"
                alt="Add to Facebook" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a class="eventIcons"
              href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/{$subscriptionId}/Public/0/{$guidEsc}">
              <img title="Add to Facebook"
                src="{$resourcesRoot}/images/Facebook_Badge.gif"
                alt="Add to Facebook" />
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="eventIcalName"
          select="concat($guid,'.ics')" />
        <a class="eventIcons"
          href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}"
          title="Download .ics file for import to other calendars">
          <img src="{$resourcesRoot}/images/std-ical_icon.gif"
            alt="Download this event" />
        </a>
        <xsl:if test="status='CANCELLED'">CANCELLED:</xsl:if>
        <xsl:if test="summary != ''">
          <xsl:variable name="summary" select="summary" />
          <xsl:value-of select="$summary" />
        </xsl:if>
      </h2>

      <span class="eventWhen">
        <br />
        <span class="infoTitle">When:</span>
        <xsl:value-of select="start/dayname" />
        ,
        <xsl:value-of select="start/longdate" />
        <xsl:text> </xsl:text>
        <xsl:if test="start/allday = 'false'">
          <span class="time">
            <xsl:value-of select="start/time" />
          </span>
        </xsl:if>
        <xsl:if
          test="(end/longdate != start/longdate) or ((end/longdate = start/longdate) and (end/time != start/time))">
          -
        </xsl:if>
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="substring(end/dayname,1,3)" />
          ,
          <xsl:value-of select="end/longdate" />
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="start/allday = 'true'">
            <span class="time">
              <em>(All day)</em>
            </span>
          </xsl:when>
          <xsl:when test="end/longdate != start/longdate">
            <span class="time">
              <xsl:value-of select="end/time" />
            </span>
          </xsl:when>
          <xsl:when test="end/time != start/time">
            <span class="time">
              <xsl:value-of select="end/time" />
            </span>
          </xsl:when>
        </xsl:choose>
      </span>

      <span class="eventWhere">
        <span class="infoTitle">Where:</span>
        <xsl:choose>
          <xsl:when test="location/link=''">
            <xsl:value-of select="location/address" />
            <xsl:text> </xsl:text>
            <xsl:if test="location/subaddress!=''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="location/subaddress" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="locationLink"
              select="location/link" />
            <a href="{$locationLink}">
              <xsl:value-of select="location/address" />
              <xsl:if test="location/subaddress!=''">
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="location/subaddress" />
              </xsl:if>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </span>

      <xsl:if test="cost!=''">
        <span class="eventCost">
          <span class="infoTitle">Cost:</span>
          <xsl:value-of select="cost" />
        </span>
      </xsl:if>

      <span class="eventLink">
        <xsl:if test="link != ''">
          <xsl:variable name="link" select="link" />
          <span class="infoTitle">
            <a href="{$link}">More Info</a>
          </span>
        </xsl:if>
      </span>

      <br />
      <xsl:if
        test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
        <xsl:variable name="bwImage">
          <xsl:value-of
            select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" />
        </xsl:variable>
        <img src="{$bwImage}" class="bwEventImage" />
      </xsl:if>
      <span class="eventDescription">
        <span class="infoTitle">Description:</span>
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="description" />
          <xsl:with-param name="pattern" select="'&#xA;'" />
          <xsl:with-param name="replacement"></xsl:with-param>
        </xsl:call-template>
      </span>
      <br />

      <!--   <span class="eventListingCal">
        <xsl:if test="calendar/path!=''">
        Calendar:
        <xsl:variable name="calUrl" select="calendar/encodedPath"/>
        <a href="{$setSelection}&amp;calUrl={$calUrl}">
        <xsl:value-of select="calendar/name"/>
        </a>
        </xsl:if>
        </span>-->

      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <span class="eventStatus">
          <span class="infoTitle">Status:</span>
          <xsl:value-of select="status" />
        </span>
      </xsl:if>
      <xsl:choose>
        <xsl:when
          test="xproperties/X-BEDEWORK-CS/values/text != ''">
          <span class="eventContact">
            <span class="infoTitle">Co-sponsors:</span>
            <xsl:if test="creator != ''">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:value-of
                select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name" />
            </xsl:if>
            <xsl:value-of disable-output-escaping="yes"
              select="xproperties/X-BEDEWORK-CS/values/text" />
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span class="eventContact">
            <span class="infoTitle">Sponsor:</span>
            <xsl:if test="creator != ''">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:value-of
                select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name" />
            </xsl:if>
            <xsl:value-of disable-output-escaping="yes"
              select="xproperties/X-BEDEWORK-CS/values/text" />
          </span>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="contact/name!='None'">
        <span class="eventContact">
          <span class="infoTitle">Contact Information:</span>
          <xsl:choose>
            <xsl:when test="contact/link=''">
              <xsl:value-of select="contact/name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="sponsorLink"
                select="contact/link" />
              <a href="{$sponsorLink}">
                <xsl:value-of select="contact/name" />
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="contact/phone!=''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="contact/phone" />
          </xsl:if>
          <xsl:if test="contact/link!=''">
            <xsl:text> </xsl:text>
            <xsl:variable name="contactLink"
              select="contact/link" />
            <a href="{$contactLink}">
              <xsl:value-of select="$contactLink" />
            </a>
          </xsl:if>
        </span>
      </xsl:if>
      <xsl:if
        test="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/values/text != ''">
        <span class="eventContact">
          <span class="infoTitle">Contact Information:</span>
          <xsl:value-of
            select="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/values/text" />
          <xsl:if
            test="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/parameters/X-BEDEWORK-PARAM-EMAIL != ''">
            <xsl:variable name="emailAddress"
              select="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/parameters/X-BEDEWORK-PARAM-EMAIL" />
            <a href="mailto:{$emailAddress}">E-mail</a>
          </xsl:if>
        </span>
      </xsl:if>
      <xsl:if test="categories[1]/category">
        <span class="eventCategories">
          <span class="infoTitle">Categories:</span>
          <xsl:for-each
            select="categories[1]/category[(word != 'Local') and (word != 'Main') and (word != 'Student') and (word != 'calCrossPublish')]">
            <xsl:value-of select="word" />
            <xsl:if test="position() != last()">,</xsl:if>
          </xsl:for-each>
        </span>
      </xsl:if>

      <xsl:if test="comments/comment">
        <span class="eventComments">
          <span class="infoTitle">Comments:</span>
          <xsl:for-each select="comments/comment">
            <p>
              <xsl:value-of select="value" />
            </p>
          </xsl:for-each>
        </span>
      </xsl:if>
    </div>

  </xsl:template>

  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekViewCal">
    <table id="monthCalendarTable">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading">
            <xsl:value-of select="." />
          </th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each
          select="/bedework/eventscalendar/year/month/week/day">
          <xsl:if test="filler='false'">
            <xsl:call-template
              name="display-month-calendar" />
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>


  <!--==== MONTH CALENDAR VIEW ====-->
  <xsl:template name="monthView">
    <table id="monthCalendarTable">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading">
            <xsl:value-of select="." />
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each
        select="/bedework/eventscalendar/year/month/week">
        <tr>
          <xsl:for-each select="day">
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template
                  name="display-month-calendar" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--== EVENTS IN THE CALENDAR GRID ==-->
  <xsl:template match="event" mode="calendarLayout">
    <xsl:param name="dayPos" />
    <xsl:variable name="subscriptionId" select="subscription/id" />
    <xsl:variable name="calPath" select="calendar/encodedPath" />
    <xsl:variable name="guid" select="guid" />
    <xsl:variable name="recurrenceId" select="recurrenceId" />
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">
          eventCancelled
        </xsl:when>
        <xsl:when test="status='TENTATIVE'">
          eventTentative
        </xsl:when>
        <!-- Default alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">
          eventLinkA
        </xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Subscription styles.
      These are set in the add/modify subscription forms in the admin client;
      if present, these override the background-color set by eventClass. The
      subscription styles should not be used for cancelled events (tentative is ok). -->
    <xsl:variable name="subscriptionClass">
      <xsl:if
        test="status != 'CANCELLED' and                     subscription/subStyle != '' and         subscription/subStyle != 'default'">
        <xsl:value-of select="subscription/subStyle" />
      </xsl:if>
    </xsl:variable>
    <li>
      <a
        href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"
        class="{$eventClass} {$subscriptionClass}">
        <xsl:if test="status='CANCELLED'">CANCELLED:</xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            (cont)
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time" />
            :
          </xsl:when>
          <xsl:otherwise>All day:</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="summary" />
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">
              eventTipReverse
            </xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <xsl:if test="status='CANCELLED'">
            <span class="eventTipStatusCancelled">
              CANCELLED
            </span>
          </xsl:if>
          <xsl:if test="status='TENTATIVE'">
            <span class="eventTipStatusTentative">
              TENTATIVE
            </span>
          </xsl:if>
          <strong>
            <xsl:value-of select="summary" />
          </strong>
          <br />
          Time:
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              All day
            </xsl:when>
            <xsl:otherwise>
              <xsl:if
                test="start/shortdate != ../shortdate">
                <xsl:value-of select="start/month" />
                /
                <xsl:value-of select="start/day" />
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="start/time" />
              <xsl:if
                test="(start/time != end/time) or (start/shortdate != end/shortdate)">
                -
                <xsl:if
                  test="end/shortdate != ../shortdate">
                  <xsl:value-of select="end/month" />
                  /
                  <xsl:value-of select="end/day" />
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="end/time" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          <br />
          <xsl:if test="location/address">
            Location:
            <xsl:value-of select="location/address" />
            <br />
          </xsl:if>
          Calendar:
          <xsl:value-of select="calendar/name" />
        </span>
      </a>
    </li>
  </xsl:template>


  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <div class="yearMonthRow">
      <xsl:apply-templates
        select="/bedework/eventscalendar/year/month[position() &lt;= 4]" />
    </div>
    <div class="yearMonthRow">
      <xsl:apply-templates
        select="/bedework/eventscalendar/year/month[(position() &gt; 4) and (position() &lt;= 8)]" />
    </div>
    <div class="yearMonthRow">
      <xsl:apply-templates
        select="/bedework/eventscalendar/year/month[position() &gt; 8]" />
    </div>
  </xsl:template>
  <!-- year view month tables -->
  <xsl:template match="month">
    <table class="yearViewMonthTable" cellspacing="0"
      cellpadding="0">
      <tr>
        <td colspan="7" class="monthName">
          <xsl:variable name="firstDayOfMonth"
            select="week/day/date" />
          <a
            href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$firstDayOfMonth}">
            <xsl:value-of select="longname" />
          </a>
        </td>
      </tr>
      <tr>
        <!-- Uhh... skipping the week numbers
          <th>&#160;</th>
        -->
        <xsl:for-each select="/bedework/shortdaynames/val">
          <th>
            <xsl:value-of select="." />
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="week">
        <tr>
          <!-- Uhh... skipping the week numbers
            <td class="weekCell">
            <xsl:variable name="firstDayOfWeek" select="day/date"/>

            <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$firstDayOfWeek}">
            me<xsl:value-of select="value"/>
            </a>

            </td>-->
          <xsl:for-each select="day">
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:if
                    test="/bedework/now/date = date">
                    <xsl:attribute name="class">today</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate"
                    select="date" />
                  <a
                    href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}">
                    <xsl:attribute name="class">today</xsl:attribute>
                    <xsl:value-of select="value" />
                  </a>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--==== CALENDARS ====-->
  <!-- list of available calendars -->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount"
      select="count(calendar/calendar)" />
    <ul class="calendarTree">
      <li>
        <a class="breadcrumb" href="/cal/">
          « Return to Main Calendar
        </a>
      </li>
      <xsl:apply-templates select="calendar/calendar"
        mode="calTree" />
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">
          folder
        </xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url" select="encodedPath" />
    <li class="{$itemClass}">
      <a href="{$setSelection}&amp;calUrl={$url}"
        title="view calendar">
        <xsl:value-of select="name" />
      </a>
      <xsl:if test="calendarCollection='true'">
        <xsl:variable name="calPath" select="path" />
        <span class="exportCalLink">
          <a
            href="{$calendar-fetchForExport}&amp;calPath={$calPath}"
            title="export calendar as iCal">
            <img
              src="{$resourcesRoot}/images/calIconExport-sm.gif"
              alt="export calendar" />
          </a>
        </span>
      </xsl:if>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar"
            mode="calTree" />
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <h2 class="bwStatusConfirmed">Export Calendar</h2>
    <div id="export">
      <p>
        <strong>Calendar to export:</strong>
      </p>
      <div class="indent">
        Name:
        <strong>
          <em>
            <xsl:value-of select="name" />
          </em>
        </strong>
        <br />
        Path:
        <xsl:value-of select="path" />
      </div>
      <p>
        <strong>Event date limits:</strong>
      </p>
      <form name="exportCalendarForm" id="exportCalendarForm"
        action="{$export}" method="post">
        <input type="hidden" name="calPath">
          <xsl:attribute name="value">
            <xsl:value-of select="path" />
          </xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year"
          value="" />
        <input type="hidden" name="eventStartDate.month"
          value="" />
        <input type="hidden" name="eventStartDate.day" value="" />
        <input type="hidden" name="eventEndDate.year" value="" />
        <input type="hidden" name="eventEndDate.month" value="" />
        <input type="hidden" name="eventEndDate.day" value="" />
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no" />
        <input type="hidden" name="skinName" value="ical" />
        <input type="hidden" name="contentType"
          value="text/calendar" />
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of
              select="name" />.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" name="dateLimits" value="active"
          checked="checked"
          onclick="changeClass('exportDateRange','invisible')" />
        today forward
        <input type="radio" name="dateLimits" value="none"
          onclick="changeClass('exportDateRange','invisible')" />
        all dates
        <input type="radio" name="dateLimits" value="limited"
          onclick="changeClass('exportDateRange','visible')" />
        date range
        <div id="exportDateRange" class="invisible">
          Start:
          <div dojoType="dropdowndatepicker"
            formatLength="medium" saveFormat="yyyyMMdd"
            id="bwExportCalendarWidgetStartDate">
            <xsl:text> </xsl:text>
          </div>
          Ends
          <div dojoType="dropdowndatepicker"
            formatLength="medium" saveFormat="yyyyMMdd"
            id="bwExportCalendarWidgetEndDate">
            <xsl:text> </xsl:text>
          </div>
        </div>
        <p>
          <input type="submit" value="export"
            class="bwWidgetSubmit" onclick="fillExportFields(this.form)" />
        </p>
      </form>
    </div>
  </xsl:template>

  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <div class="secondaryColHeader">
      <h3>Search Results</h3>
    </div>

    <!-- <xsl:if test="/bedework/searchResults/numPages &gt; 1">
      <span class="resultPages">
      <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
      <xsl:if test="/bedework/searchResults/curPage != 1">
      <xsl:variable name="prevPage" select="number($curPage) - 1"/>
      <a href="{$search-next}&amp;pageNum={$prevPage}">&#171;</a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:call-template name="searchResultPageNav">
      <xsl:with-param name="page">
      <xsl:choose>
      <xsl:when test="number($curPage) - 10 &lt; 1">1</xsl:when>
      <xsl:otherwise>
      <xsl:value-of select="number($curPage) - 6"/>
      </xsl:otherwise>
      </xsl:choose>
      </xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:choose>
      <xsl:when test="$curPage != /bedework/searchResults/numPages">
      <xsl:variable name="nextPage" select="number($curPage) + 1"/>
      <a href="{$search-next}&amp;pageNum={$nextPage}">&#187;</a></xsl:when>
      <xsl:otherwise>
      <span class="hidden">&#171;</span>
      </xsl:otherwise>
      </xsl:choose>
      </span>
      </xsl:if> -->

    <xsl:if test="/bedework/searchResults/curPage &lt; 2">
      <span class="numReturnedResults">
        <xsl:value-of
          select="/bedework/searchResults/resultSize" />
        <xsl:text> result</xsl:text>
        <xsl:if
          test="/bedework/searchResults/resultSize != 1">
          s
        </xsl:if>
        <xsl:text> returned for: </xsl:text>
        <em>
          <xsl:value-of
            select="/bedework/searchResults/query" />
        </em>
      </span>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/searchResult">
      <table id="searchTable" cellpadding="0" cellspacing="0"
        width="100%">
        <tr>
          <th class="search_relevance">Rank</th>
          <th class="search_date">Date</th>
          <th class="search_summary">Summary</th>
          <th class="search_location">Location</th>
        </tr>
        <xsl:for-each
          select="/bedework/searchResults/searchResult[not(event/categories/category/value = 'Local')]">
          <xsl:if test="event/summary">
            <xsl:variable name="subscriptionId"
              select="event/subscription/id" />
            <xsl:variable name="calPath"
              select="event/calendar/encodedPath" />
            <xsl:variable name="guid" select="event/guid" />
            <xsl:variable name="recurrenceId"
              select="event/recurrenceId" />
            <tr>
              <td class="search_relevance">
                <xsl:choose>
                  <xsl:when
                    test="contains(score,'E')">
                    1%
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="ceiling(number(score)*100)" />
                    %
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="search_date">
                <xsl:value-of
                  select="event/start/shortdate" />
                <xsl:text> </xsl:text>
              </td>
              <td class="search_summary">
                <a
                  href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of
                    select="event/summary" />
                </a>
              </td>
              <td class="search_location">
                <xsl:value-of
                  select="event/location/address" />
              </td>
            </tr>
          </xsl:if>
        </xsl:for-each>
      </table>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/numPages &gt; 1">
      <span class="resultPages" id="resultsBottom">
        Page(s):
        <xsl:variable name="curPage"
          select="/bedework/searchResults/curPage" />
        <xsl:if test="/bedework/searchResults/curPage != 1">
          <xsl:variable name="prevPage"
            select="number($curPage) - 1" />
          <a href="{$search-next}&amp;pageNum={$prevPage}">
            «
          </a>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:call-template name="searchResultPageNav">
          <xsl:with-param name="page">
            <xsl:choose>
              <xsl:when
                test="number($curPage) - 10 &lt; 1">
                1
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="number($curPage) - 6" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when
            test="$curPage != /bedework/searchResults/numPages">
            <xsl:variable name="nextPage"
              select="number($curPage) + 1" />
            <a
              href="{$search-next}&amp;pageNum={$nextPage}">
              »
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span class="hidden">«</span>
            <!-- occupy the space to keep the navigation from moving around -->
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="advancedSearch">
    <div id="advSearch">
      <h3>Advanced Search</h3>
      <form id="advSearchForm" name="searchForm"
        onsubmit="return initCat()" method="post" action="{$search}">
        Search:
        <input type="text" name="query" size="40" value="" />
        <!--          <xsl:attribute name="value">
          <xsl:value-of select="/bedework/searchResults/query"/>
          </xsl:attribute>
          </input>-->
        <br />
        <label>Limit by:</label>
        <br />
        <xsl:choose>
          <xsl:when
            test="/bedework/searchResults/searchLimits = 'beforeToday'">
            <input type="radio" name="searchLimits"
              value="fromToday" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" checked="checked" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" />
            All dates
            <br />
          </xsl:when>
          <xsl:when
            test="/bedework/searchResults/searchLimits = 'none'">
            <input type="radio" name="searchLimits"
              value="fromToday" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" checked="checked" />
            All dates
            <br />
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="searchLimits"
              value="fromToday" checked="checked" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" />
            All dates
            <br />
          </xsl:otherwise>
        </xsl:choose>

        <input type="submit" name="submit" value="Search" />

        <div id="searchCats">
          <h4>Select Categories to Search (Optional)</h4>
          <p>
            A search term is not required if at least one
            category is selected.
          </p>
          <xsl:variable name="catCount"
            select="count(/bedework/categories/category)" />
          <table>
            <tr>
              <td>
                <ul>
                  <xsl:for-each
                    select="/bedework/categories/category[(position() &lt;= ceiling($catCount div 2)) and (keyword != 'Local') and (creator != 'agrp_public-user') and (keyword != 'Main') and (keyword != 'Student') and (keyword != 'calCrossPublish')]">
                    <xsl:variable name="currId"
                      select="keyword" />
                    <li>
                      <p>
                        <input type="checkbox"
                          name="categoryKey" value="{$currId}" />
                        <xsl:value-of
                          select="keyword" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
              <td>
                <ul>
                  <xsl:for-each
                    select="/bedework/categories/category[(position() &gt; ceiling($catCount div 2)) and (keyword != 'Local') and (creator != 'agrp_public-user') and (keyword != 'Main') and (keyword != 'Student') and (keyword != 'calCrossPublish')]">
                    <xsl:variable name="currId2"
                      select="keyword" />
                    <li>
                      <p>
                        <input type="checkbox"
                          name="categoryKey" value="{$currId2}" />
                        <xsl:value-of
                          select="keyword" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
          </table>
        </div>
        <input type="submit" name="submit" value="Search" />
      </form>
    </div>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage"
      select="/bedework/searchResults/curPage" />
    <xsl:variable name="numPages"
      select="/bedework/searchResults/numPages" />
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when
          test="number($curPage) + 6 &gt; number($numPages)">
          <xsl:value-of select="$numPages" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($curPage) + 6" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <span class="current">
          <xsl:value-of select="$page" />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
      <xsl:call-template name="searchResultPageNav">
        <xsl:with-param name="page" select="number($page)+1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--==== Display Month Calendar  ====-->
  <xsl:template name="display-month-calendar">
    <xsl:variable name="dayPos" select="position()" />
    <td>
      <xsl:if test="/bedework/now/date = date">
        <xsl:attribute name="class">today</xsl:attribute>
      </xsl:if>
      <xsl:variable name="dayDate" select="date" />
      <a
        href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}"
        class="dayLink">
        <xsl:value-of select="value" />
      </a>
      <xsl:if test="event">
        <ul>
          <xsl:apply-templates select="event"
            mode="calendarLayout">
            <xsl:with-param name="dayPos" select="$dayPos" />
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </td>
  </xsl:template>


  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->
  <xsl:template name="stats">
    <div id="stats">
      <h2>System Statistics</h2>
      <p>Stats collection:</p>
      <ul>
        <li>
          <a href="{$stats}&amp;enable=yes">enable</a>
          |
          <a href="{$stats}&amp;disable=yes">disable</a>
        </li>
        <li>
          <a href="{$stats}&amp;fetch=yes">
            fetch statistics
          </a>
        </li>
        <li>
          <a href="{$stats}&amp;dump=yes">
            dump stats to log
          </a>
        </li>
      </ul>
      <table id="statsTable" cellpadding="0">
        <xsl:for-each select="/bedework/sysStats/*">
          <xsl:choose>
            <xsl:when test="name(.) = 'header'">
              <tr>
                <th colspan="2">
                  <xsl:value-of select="." />
                </th>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td class="label">
                  <xsl:value-of select="label" />
                </td>
                <td class="value">
                  <xsl:value-of select="value" />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
