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
    Copyright 2009 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
  <xsl:include href="../../../bedework-common/default/default/errors.xsl" />
  <xsl:include href="../../../bedework-common/default/default/messages.xsl" />
  <xsl:include href="../../../bedework-common/default/default/util.xsl" />
  <xsl:include href="./strings.xsl" />

  <!-- Page subsections -->
  <xsl:include href="./defaultTheme/head.xsl" />
  <xsl:include href="./defaultTheme/header.xsl" />
  <xsl:include href="./defaultTheme/footer.xsl" />
  <xsl:include href="./defaultTheme/eventslist.xsl" />
  <xsl:include href="./defaultTheme/event.xsl" />
  <xsl:include href="./defaultTheme/views.xsl" />
  <xsl:include href="./defaultTheme/ongoing.xsl" />
  <xsl:include href="./defaultTheme/featured.xsl"/>
  <xsl:include href="./defaultTheme/groups.xsl"/>
  <xsl:include href="./defaultTheme/system-stats.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
    included stylesheets and xml fragments. These are generally
    referenced relatively (like the included files above).  -->
  <xsl:variable name="appRoot" select="/bedework/approot" />

  <!-- URL of html resources (images, css, other html);
       by default this is set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot" />/default/default/defaultTheme</xsl:variable>

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
  <xsl:variable name="feederPrefix">/feeder</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate" />
  <xsl:variable name="nextdate" select="/bedework/nextdate" />
  <xsl:variable name="curdate" select="/bedework/currentdate/date" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <xsl:call-template name="head"/>
      <body>
        <div id="wrap">
          <div id="header">
            <xsl:call-template name="titleBar" />
            <xsl:call-template name="tabs" />
          </div>
          <xsl:if test="/bedework/error">
            <div id="errors">
              <xsl:apply-templates select="/bedework/error" />
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
                        <!-- pulls in the first three images from the FeaturedEvent.xml document -->
                        <xsl:apply-templates select="document('defaultTheme/data/FeaturedEvent.xml')/featuredEvents/image[position() &lt; 4]" mode="featuredEvents" />
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
            onclick="javascript:toggleDiv('groupListDiv'); toggleDiv('right_column'); toggleDiv('center_column');">
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

</xsl:stylesheet>
