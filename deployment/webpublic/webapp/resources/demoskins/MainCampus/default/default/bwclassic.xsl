<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

<xsl:output
  method="xml"
  indent="no"
  media-type="text/html"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  standalone="yes"
  omit-xml-declaration="yes"/>

<!-- =========================================================

              DEMONSTRATION CALENDAR STYLESHEET

                  MainCampus Calendar Suite

     This stylesheet is devoid of school branding.  It is a good
     starting point for development of a customized calendar.

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
  <xsl:include href="../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/messages.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/util.xsl"/>
  <xsl:include href="./strings.xsl"/>

  <!-- Page subsections -->
  <xsl:include href="./bwclassicTheme/event.xsl" />

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
    included stylesheets and xml fragments. These are generally
    referenced relatively (like the included files above).  -->
  <xsl:variable name="appRoot" select="/bedework/approot" />

  <!-- URL of html resources (images, css, other html); by default this is
       set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot"/>/default/default/bwclassicTheme</xsl:variable>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection"/>
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod"/>
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <xsl:variable name="calendar-fetchForExport" select="/bedework/urlPrefixes/calendar/fetchForExport"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats/stats"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <title><xsl:value-of select="/bedework/event/summary"/></title>
          </xsl:when>
          <xsl:otherwise>
            <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
          </xsl:otherwise>
        </xsl:choose>
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
        <!-- load css -->
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='style']/value='red'">
            <link rel="stylesheet" href="{$resourcesRoot}/css/red.css"/>
          </xsl:when>
          <xsl:when test="/bedework/appvar[key='style']/value='green'">
            <link rel="stylesheet" href="{$resourcesRoot}/css/green.css"/>
          </xsl:when>
          <xsl:otherwise>
            <link rel="stylesheet" href="{$resourcesRoot}/css/blue.css"/>
          </xsl:otherwise>
        </xsl:choose>
        <link rel="stylesheet" href="../../../bedework-common/default/default/subColors.css"/>
        <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />
        <!-- load javascript -->
        <xsl:if test="/bedework/page='event' or /bedework/page='displayCalendarForExport'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">&#160;</script>
          <xsl:if test="/bedework/page='displayCalendarForExport'">
            <script type="text/javascript">
              <xsl:comment>
              $.datepicker.setDefaults({
                constrainInput: true,
                dateFormat: "yy-mm-dd",
                showOn: "both",
                buttonImage: "<xsl:value-of select='$resourcesRoot'/>/images/calIcon.gif",
                buttonImageOnly: true,
                gotoCurrent: true,
                duration: ""
              });
              $(document).ready(function() {
                $("#bwExportCalendarWidgetStartDate").datepicker({
                }).attr("readonly", "readonly");
                $("#bwExportCalendarWidgetEndDate").datepicker({
                }).attr("readonly", "readonly");
              });
              </xsl:comment>
            </script>
          </xsl:if>
        </xsl:if>
        <!-- address bar icon -->
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <xsl:call-template name="tabs"/>
        <xsl:call-template name="navigation"/>
        <xsl:call-template name="searchBar"/>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='eventList'">
            <!-- show a list of discrete events in a time period -->
            <xsl:apply-templates select="/bedework/events" mode="eventList"/>
          </xsl:when>
          <xsl:when test="/bedework/page='showSysStats'">
            <!-- show system stats -->
            <xsl:call-template name="stats"/>
          </xsl:when>
          <xsl:when test="/bedework/page='calendarList'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/bedework/calendars"/>
          </xsl:when>
          <xsl:when test="/bedework/page='displayCalendarForExport'">
            <!-- page for calendar export (can optionally be replaced by
                 a pop-up widget; see the calendars template) -->
            <xsl:apply-templates select="/bedework/currentCalendar" mode="export"/>
          </xsl:when>
          <xsl:when test="/bedework/page='searchResult'">
            <!-- display search results -->
            <xsl:call-template name="searchResult"/>
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
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->
  <!-- these templates are separated out for convenience and to simplify the default template -->

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="/bedework/"><img src="{$resourcesRoot}/images/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
          <h2><xsl:copy-of select="$bwStr-HdBr-PublicCalendar"/></h2>
          <a href="{$privateCal}"><xsl:copy-of select="$bwStr-HdBr-PersonalCalendar"/></a> |
          <a href="http://www.youruniversityhere.edu"><xsl:copy-of select="$bwStr-HdBr-UniversityHome"/></a> |
          <a href="http://www.bedework.org/"><xsl:copy-of select="$bwStr-HdBr-OtherLink"/></a>
        </td>
      </tr>
    </table>
    <table id="curDateRangeTable"  cellspacing="0">
      <tr>
        <td class="sideBarOpenCloseIcon">
          &#160;
          <!--
          we may choose to implement calendar selection in the public calendar
          using a sidebar; leave this comment here for now.
          <xsl:choose>
            <xsl:when test="/bedework/appvar[key='sidebar']/value='closed'">
              <a href="?setappvar=sidebar(opened)">
                <img alt="open sidebar" src="{$resourcesRoot}/images/sideBarArrowOpen.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="?setappvar=sidebar(closed)">
                <img alt="close sidebar" src="{$resourcesRoot}/images/sideBarArrowClose.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>-->
        </td>
        <td class="date">
          <xsl:choose>
            <xsl:when test="/bedework/page='event'">
              <xsl:copy-of select="$bwStr-HdBr-EventInformation"/>
            </xsl:when>
            <xsl:when test="/bedework/page='showSysStats' or
                            /bedework/page='calendars'">
              &#160;
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/firstday/longdate"/>
              <xsl:if test="/bedework/periodname!='Day'">
                -
                <xsl:value-of select="/bedework/lastday/longdate"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="rssPrint">
          <a href="javascript:window.print()" title="{$bwStr-HdBr-PrintThisView}">
            <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-HdBr-Print"/>
          </a>
          <a class="rss" href="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=rss-list&amp;days=3" title="{$bwStr-HdBr-RSSFeed}"><xsl:copy-of select="$bwStr-HdBr-RSS"/></a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="tabs">
    <div id="bwTabs">
      <ul>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Day'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Day"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Week' or /bedework/periodname=''">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Week"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Month'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if><a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Month"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Year'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if><a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Year"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventList'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if><a href="{$listEvents}"><xsl:copy-of select="$bwStr-Tabs-List"/></a>
        </li>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="navigation">
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a id="prevViewPeriod" href="{$setViewPeriod}&amp;date={$prevdate}"><img src="{$resourcesRoot}/images/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a id="nextViewPeriod" href="{$setViewPeriod}&amp;date={$nextdate}"><img src="{$resourcesRoot}/images/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Year'">
              <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:value-of select="/bedework/firstday/monthname"/>, <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Week'">
              <xsl:copy-of select="$bwStr-Navi-WeekOf"/><xsl:text> </xsl:text><xsl:value-of select="substring-after(/bedework/firstday/longdate,', ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/firstday/longdate"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="todayButton">
          <a href="{$setViewPeriod}&amp;viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/images/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="post" action="{$setViewPeriod}">
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
                  <input name="submit" type="submit" value="{$bwStr-Navi-Go}"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
        <td class="rightCell">
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="searchBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="searchBarTable">
       <tr>
         <td class="leftCell">
           <xsl:choose>
             <xsl:when test="/bedework/selectionState/selectionType = 'collections'">
               <xsl:copy-of select="$bwStr-SrcB-TopicalArea"/>
               <strong>
                 <xsl:call-template name="substring-afterLastInstanceOf">
                   <xsl:with-param name="string" select="/bedework/appvar[key='curCollection']/value"/>
                   <xsl:with-param name="char">/</xsl:with-param>
                 </xsl:call-template>
               </strong>
             </xsl:when>
             <xsl:when test="/bedework/selectionState/selectionType = 'search'">
               <xsl:copy-of select="$bwStr-SrcB-CurrentSearch"/><xsl:text> </xsl:text><xsl:value-of select="/bedework/search"/>
             </xsl:when>
             <xsl:otherwise><!-- view -->
               <xsl:copy-of select="$bwStr-SrcB-View"/>
               <form name="selectViewForm" method="post" action="{$setSelection}">
                <select name="viewName" onchange="submit()" >
                  <xsl:if test="/bedework/page = 'eventList'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                  <xsl:for-each select="/bedework/views/view">
                    <xsl:variable name="name" select="name"/>
                    <xsl:choose>
                      <xsl:when test="name=/bedework/selectionState/view/name">
                        <option value="{$name}" selected="selected"><xsl:value-of select="name"/></option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="{$name}"><xsl:value-of select="name"/></option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </select>
              </form>
             </xsl:otherwise>
           </xsl:choose>
           <span class="link"><a href="{$setSelection}"><xsl:copy-of select="$bwStr-SrcB-DefaultView"/></a> | <a href="{$fetchPublicCalendars}"><xsl:copy-of select="$bwStr-SrcB-AllTopicalAreas"/></a></span>
         </td>
         <td class="rightCell">
            <xsl:if test="/bedework/page!='searchResult'">
              <form name="searchForm" id="searchForm" method="post" action="{$search}">
                <xsl:copy-of select="$bwStr-SrcB-Search"/>
                <input type="text" name="query" size="15">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
                </input>
                <input type="submit" name="submit" value="{$bwStr-SrcB-Go}"/>
              </form>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day' or /bedework/page='eventList'">
                <img src="{$resourcesRoot}/images/std-button-listview-off.gif" width="46" height="21" border="0" alt="{$bwStr-SrcB-ToggleListCalView}"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Year'">
                <img src="{$resourcesRoot}/images/std-button-calview-off.gif" width="46" height="21" border="0" alt="{$bwStr-SrcB-ToggleListCalView}"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                    <a href="{$setup}&amp;setappvar=monthViewMode(cal)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <img src="{$resourcesRoot}/images/std-button-calview.gif" width="46" height="21" border="0" alt="{$bwStr-SrcB-ToggleListCalView}"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=monthViewMode(list)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <img src="{$resourcesRoot}/images/std-button-listview.gif" width="46" height="21" border="0" alt="{$bwStr-SrcB-ToggleListCalView}"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                    <a href="{$setup}&amp;setappvar=weekViewMode(cal)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <img src="{$resourcesRoot}/images/std-button-calview.gif" width="46" height="21" border="0"  alt="{$bwStr-SrcB-ToggleListCalView}"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=weekViewMode(list)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <img src="{$resourcesRoot}/images/std-button-listview.gif" width="46" height="21" border="0"  alt="{$bwStr-SrcB-ToggleListCalView}"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="/bedework/page = 'eventList'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                    <a href="{$listEvents}&amp;setappvar=listEventsSummaryMode(summary)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <img src="{$resourcesRoot}/images/std-button-summary.gif" width="62" height="21" border="0" alt="{$bwStr-SrcB-ToggleSummDetView}"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$listEvents}&amp;setappvar=listEventsSummaryMode(details)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <img src="{$resourcesRoot}/images/std-button-details.gif" width="62" height="21" border="0" alt="{$bwStr-SrcB-ToggleSummDetView}"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Year' or
                              (/bedework/periodname='Month' and
                              (/bedework/appvar[key='monthViewMode']/value='cal' or
                               not(/bedework/appvar[key='monthViewMode']))) or
                              (/bedework/periodname='Week' and
                              (/bedework/appvar[key='weekViewMode']/value='cal' or
                               not(/bedework/appvar[key='weekViewMode'])))">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                    <img src="{$resourcesRoot}/images/std-button-summary-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <img src="{$resourcesRoot}/images/std-button-details-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                    <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <img src="{$resourcesRoot}/images/std-button-summary.gif" width="62" height="21" border="0" alt="{$bwStr-SrcB-ToggleSummDetView}"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=summaryMode(details)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <img src="{$resourcesRoot}/images/std-button-details.gif" width="62" height="21" border="0" alt="{$bwStr-SrcB-ToggleSummDetView}"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <a href="{$setup}">
              <xsl:if test="/bedework/page='eventList'">
                <xsl:attribute name="href"><xsl:value-of select="$listEvents"/></xsl:attribute>
              </xsl:if>
              <img src="{$resourcesRoot}/images/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/>
            </a>
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
              <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[event]">
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="5" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
                     <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                   </a>
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
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
                      <xsl:copy-of select="$bwStr-LsVw-AllDay"/>
                    </td>
                  </xsl:when>
                  <xsl:when test="start/shortdate = end/shortdate and
                                  start/time = end/time">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="start/time"/>
                      </a>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="start/allday = 'true' and
                                        parent::day/shortdate = start/shortdate">
                          <xsl:copy-of select="$bwStr-LsVw-Today"/>
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
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="end/allday = 'true' and
                                        parent::day/shortdate = end/shortdate">
                          <xsl:copy-of select="$bwStr-LsVw-Today"/>
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
                    <xsl:otherwise><xsl:copy-of select="$bwStr-LsVw-Description"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- Subscription styles.
                     These are set in the add/modify subscription forms in the admin client;
                     if present, these override the background-color set by eventClass. The
                     subscription styles should not be used for canceled events (tentative is ok). -->
                <xsl:variable name="subscriptionClass">
                  <xsl:if test="status != 'CANCELLED'">
                    <xsl:apply-templates select="categories" mode="customEventColor"/>
                  </xsl:if>
                </xsl:variable>
                <td class="{$descriptionClass} {$subscriptionClass}">
                  <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <strong>
                          <xsl:value-of select="summary"/>:
                        </strong>
                        <xsl:value-of select="description"/>&#160;
                        <em>
                          <xsl:value-of select="location/address"/>
                          <xsl:if test="location/subaddress != ''">
                            , <xsl:value-of select="location/subaddress"/>
                          </xsl:if>.&#160;
                          <xsl:if test="cost!=''">
                            <xsl:value-of select="cost"/>.&#160;
                          </xsl:if>
                          <xsl:if test="contact/name!='none'">
                            <xsl:copy-of select="$bwStr-LsVw-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
                          </xsl:if>
                        </em>
                        -
                        <span class="eventSubscription">
                          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                              <xsl:call-template name="substring-afterLastInstanceOf">
                                <xsl:with-param name="string" select="values/text"/>
                                <xsl:with-param name="char">/</xsl:with-param>
                              </xsl:call-template>
                              <xsl:if test="position()!=last()">, </xsl:if>
                            </xsl:for-each>
                          </xsl:if>
                        </span>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="summary"/>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                         -
                        <span class="eventSubscription">
                          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                              <xsl:call-template name="substring-afterLastInstanceOf">
                                <xsl:with-param name="string" select="values/text"/>
                                <xsl:with-param name="char">/</xsl:with-param>
                              </xsl:call-template>
                              <xsl:if test="position()!=last()">, </xsl:if>
                            </xsl:for-each>
                          </xsl:if>
                        </span>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="icons">
                  <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                  </a>
                  <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                  <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-LsVw-DownloadEvent}">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-DownloadEvent}"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <!--==== LIST EVENTS - for listing discrete events ====-->
  <xsl:template match="events" mode="eventList">
    <h2 class="bwStatusConfirmed">
      <!-- <form name="bwListEventsForm" action="{$listEvents}" method="post">
        <input type="hidden" name="setappvar"/>-->
        <xsl:copy-of select="$bwStr-LsEv-Next7Days"/>
        <!--
        <span id="bwListEventsFormControls">
          <select name="catuid" onchange="this.form.submit();">
            <option value="">filter by category...</option>
            <xsl:for-each select="/bedework/categories/category">
              <option>
                <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                <xsl:value-of select="keyword"/>
              </option>
            </xsl:for-each>
          </select>
          <select name="days" onchange="this.form.submit();">
            <xsl:call-template name="buildListEventsDaysOptions">
              <xsl:with-param name="i">1</xsl:with-param>
              <xsl:with-param name="total">31</xsl:with-param>
            </xsl:call-template>
          </select>
        </span>
      </form>-->
    </h2>

    <div id="listEvents">
      <ul>
        <xsl:choose>
          <xsl:when test="not(event)">
            <li><xsl:copy-of select="$bwStr-LsEv-NoEventsToDisplay"/></li>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <li>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
                    <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
                  </xsl:choose>
                </xsl:attribute>

                <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsEv-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                <xsl:if test="status='TENTATIVE'"><em><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></em></xsl:if>

                <a class="title" href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of select="summary"/>
                </a><xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <xsl:if test="location/subaddress != ''">
                    , <xsl:value-of select="location/subaddress"/>
                  </xsl:if>
                </xsl:if>

                <xsl:text> </xsl:text>
                <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                  <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                </a>
                <xsl:text> </xsl:text>
                <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-LsEv-DownloadEvent}">
                  <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsEv-DownloadEvent}"/>
                </a>

                <br/>

                <xsl:value-of select="substring(start/dayname,1,3)"/>,
                <xsl:value-of select="start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:if test="start/allday != 'true'">
                  <xsl:value-of select="start/time"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/shortdate != end/shortdate">
                    -
                    <xsl:value-of select="substring(end/dayname,1,3)"/>,
                    <xsl:value-of select="end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:if test="start/allday != 'true'">
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="start/time != end/time">
                      -
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <br/>
                  <xsl:value-of select="description"/>
                  <xsl:if test="link != ''">
                    <br/>
                    <xsl:variable name="link" select="link"/>
                    <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                  </xsl:if>
                  <xsl:if test="categories/category">
                    <br/>
                    <xsl:copy-of select="$bwStr-LsEv-Categories"/>
                    <xsl:for-each select="categories/category">
                      <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                  <br/>
                  <em>
                    <xsl:if test="cost!=''">
                      <xsl:value-of select="cost"/>.&#160;
                    </xsl:if>
                    <xsl:if test="contact/name!='none'">
                      <xsl:copy-of select="$bwStr-LsEv-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
                    </xsl:if>
                  </em>
                </xsl:if>

              </li>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="buildListEventsDaysOptions">
    <xsl:param name="i">1</xsl:param>
    <xsl:param name="total">31</xsl:param>
    <xsl:param name="default">7</xsl:param>
    <xsl:variable name="selected"><xsl:value-of select="/bedework/appvar[key='listEventsDays']/value"/></xsl:variable>

    <option onclick="this.form.setappvar.value='listEventsDay({$i})'">
      <xsl:attribute name="value"><xsl:value-of select="$i"/></xsl:attribute>
      <xsl:if test="($selected != '' and $i = $selected) or ($selected = '' and $i = $default)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
      <xsl:value-of select="$i"/>
    </option>

    <xsl:if test="$i &lt; $total">
      <xsl:call-template name="buildListEventsDaysOptions">
        <xsl:with-param name="i"><xsl:value-of select="$i + 1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="default"><xsl:value-of select="$default"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>

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
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink">
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
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink">
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
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <!-- Default alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Subscription styles.
         These are set in the add/modify subscription forms in the admin client;
         if present, these override the background-color set by eventClass. The
         subscription styles should not be used for canceled events (tentative is ok). -->
    <xsl:variable name="subscriptionClass">
      <xsl:if test="status != 'CANCELLED'">
        <xsl:apply-templates select="categories" mode="customEventColor"/>
      </xsl:if>
    </xsl:variable>
    <li>
      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass} {$subscriptionClass}">
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/><xsl:text> </xsl:text></xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            <xsl:copy-of select="$bwStr-EvCG-Cont"/>
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-EvCG-AllDayColon"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="summary"/>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/></span></xsl:if>
          <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative"><xsl:copy-of select="$bwStr-EvCG-Tentative"/></span></xsl:if>
          <strong><xsl:value-of select="summary"/></strong><br/>
          <xsl:copy-of select="$bwStr-EvCG-Time"/>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <xsl:copy-of select="$bwStr-EvCG-AllDay"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="start/shortdate != ../shortdate">
                <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="start/time"/>
              <xsl:if test="(start/time != end/time) or (start/shortdate != end/shortdate)">
                -
                <xsl:if test="end/shortdate != ../shortdate">
                  <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            <xsl:copy-of select="$bwStr-EvCG-Location"/><xsl:text> </xsl:text><xsl:value-of select="location/address"/><br/>
          </xsl:if>
          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
            <xsl:copy-of select="$bwStr-EvCG-TopicalArea"/>
              <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="values/text"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="position()!=last()">, </xsl:if>
              </xsl:for-each>
          </xsl:if>
        </span>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="categories" mode="customEventColor">
    <!-- Set custom color schemes here.
         This template looks at the categories found in the event and
         returns a color class for use with the "subscriptionClass" variable.
         The classes suggested below come from bwColors.css found in the bedework-common directory. -->
    <xsl:choose>
       <!--
       <xsl:when test="category/value = 'Athletics'">bwltpurple</xsl:when>
       <xsl:when test="category/value = 'Arts'">bwltsalmon</xsl:when>
       -->
       <xsl:otherwise></xsl:otherwise> <!-- do nothing -->
    </xsl:choose>
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
                      <xsl:attribute name="class">today</xsl:attribute>
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

  <!--==== CALENDARS ====-->

  <!-- list of available calendars -->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(calendar/calendar[calType != 5 and calType != 6 and name != 'calendar'])"/>
    <table id="calPageTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2">
          <xsl:copy-of select="$bwStr-Cals-AllTopicalAreas"/>
        </th>
      </tr>
      <tr>
        <td colspan="2" class="infoCell">
          <p class="info">
            <xsl:copy-of select="$bwStr-Cals-SelectTopicalArea"/>
          </p>
        </td>
      </tr>
      <tr>
        <td class="leftCell">
          <!-- adjust the following calculations to get a balanced layout between the cells -->
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar') and (position() &lt;= ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
          </ul>
        </td>
        <td>
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar') and (position() &gt; ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Calr-Folder"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-Calr-Calendar"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <li class="{$itemClass}">
      <xsl:variable name="calPath" select="path"/>
      <a href="{$setSelection}&amp;virtualPath={$virtualPath}&amp;setappvar=curCollection({$calPath})" title="view calendar"><xsl:value-of select="name"/></a>
      <xsl:variable name="calPath" select="path"/>
      <span class="exportCalLink">
        <a href="{$calendar-fetchForExport}&amp;calPath={$calPath}&amp;virtualPath={$virtualPath}" title="export calendar as iCal">
          <img src="{$resourcesRoot}/images/calIconExport-sm.gif" width="13" height="13" alt="export calendar" border="0"/>
        </a>
      </span>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <h2 class="bwStatusConfirmed"><xsl:copy-of select="$bwStr-Cals-ExportCals"/></h2>
    <div id="export">
      <p>
        <strong><xsl:copy-of select="$bwStr-Cals-CalendarToExport"/></strong>
      </p>
      <div class="indent">
        <xsl:copy-of select="$bwStr-Cals-Name"/><xsl:text> </xsl:text><strong><em><xsl:value-of select="name"/></em></strong><br/>
        <xsl:copy-of select="$bwStr-Cals-Path"/><xsl:text> </xsl:text><xsl:value-of select="path"/>
      </div>
      <p>
        <strong><xsl:copy-of select="$bwStr-Cals-EventDateLimits"/></strong>
      </p>
      <form name="exportCalendarForm" id="exportCalendarForm" action="{$export}" method="post">
        <input type="hidden" name="calPath">
          <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year" value=""/>
        <input type="hidden" name="eventStartDate.month" value=""/>
        <input type="hidden" name="eventStartDate.day" value=""/>
        <input type="hidden" name="eventEndDate.year" value=""/>
        <input type="hidden" name="eventEndDate.month" value=""/>
        <input type="hidden" name="eventEndDate.day" value=""/>
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no"/>
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of select="name"/>.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-TodayForward"/>
        <input type="radio" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-AllDates"/>
        <input type="radio" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-DateRange"/>
        <div id="exportDateRange" class="invisible">
          <xsl:copy-of select="$bwStr-Cals-Start"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetStartDate" id="bwExportCalendarWidgetStartDate" size="10"/>
          <span id="bwExportEndField"><xsl:copy-of select="$bwStr-Cals-End"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetEndDate" id="bwExportCalendarWidgetEndDate" size="10"/></span>
        </div>
        <p><input type="submit" value="{$bwStr-Cals-Export}" class="bwWidgetSubmit" onclick="fillExportFields(this.form)"/></p>
      </form>
    </div>
  </xsl:template>

  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <h2 class="bwStatusConfirmed">
      <div id="searchFilter">
        <form name="searchForm" method="post" action="{$search}">
          <xsl:copy-of select="$bwStr-Srch-Search"/>
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
          <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Srch-ResultReturnedFor"/><xsl:text> </xsl:text><em><xsl:value-of select="/bedework/searchResults/query"/></em>
        </th>
      </tr>
      <xsl:if test="/bedework/searchResults/searchResult">
        <tr class="fieldNames">
          <td>
            <xsl:copy-of select="$bwStr-Srch-Relevance"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-Srch-Summary"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-Srch-DateAndTime"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-Srch-Calendar"/>
          </td>
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
            <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="event/summary"/>
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

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->
  <xsl:template name="stats">
    <div id="stats">
      <h2><xsl:copy-of select="$bwStr-Stat-SysStats"/></h2>

      <p>
        <xsl:copy-of select="$bwStr-Stat-StatsCollection"/>
      </p>
      <ul>
        <li>
          <a href="{$stats}&amp;enable=yes"><xsl:copy-of select="$bwStr-Stat-Enable"/></a> |
          <a href="{$stats}&amp;disable=yes"><xsl:copy-of select="$bwStr-Stat-Disable"/></a>
        </li>
        <li><a href="{$stats}&amp;fetch=yes"><xsl:copy-of select="$bwStr-Stat-FetchStats"/></a></li>
        <li><a href="{$stats}&amp;dump=yes"><xsl:copy-of select="$bwStr-Stat-DumpStats"/></a></li>
      </ul>
      <table id="statsTable" cellpadding="0">
        <xsl:for-each select="/bedework/sysStats/*">
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
    </div>
  </xsl:template>

  <!--==== FOOTER ====-->

  <xsl:template name="footer">
    <div id="footer">
      <xsl:copy-of select="$bwStr-Foot-BasedOnThe"/><xsl:text> </xsl:text><a href="http://www.bedework.org/"><xsl:copy-of select="$bwStr-Foot-BedeworkCalendarSystem"/></a>
    </div>
    <table id="skinSelectorTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="leftCell">
          <a href="http://www.bedework.org/"><xsl:copy-of select="$bwStr-Foot-BedeworkWebsite"/></a> |
          <a href="http://www.bedework.org/bedework/update.do?artcenterkey=35"><xsl:copy-of select="$bwStr-Foot-ProductionExamples"/></a> |
          <a href="?noxslt=yes"><xsl:copy-of select="$bwStr-Foot-ShowXML"/></a> |
          <a href="?refreshXslt=yes"><xsl:copy-of select="$bwStr-Foot-RefreshXSLT"/></a>
        </td>
        <td class="rightCell">
          <form name="styleSelectForm" method="get" action="{$setup}">
            <select name="setappvar" onchange="submit()">
              <option value=""><xsl:copy-of select="$bwStr-Foot-ExampleStyles"/>:</option>
              <option value="style(green)"><xsl:copy-of select="$bwStr-Foot-Green"/></option>
              <option value="style(red)"><xsl:copy-of select="$bwStr-Foot-Red"/></option>
              <option value="style(blue)"><xsl:copy-of select="$bwStr-Foot-Blue"/></option>
            </select>
          </form>
          <form name="skinSelectForm" method="post" action="{$setup}">
            <input type="hidden" name="setappvar" value="summaryMode(details)"/>
            <select name="skinPicker" onchange="window.location = this.value">
              <option value="{$setup}&amp;skinNameSticky=default"><xsl:copy-of select="$bwStr-Foot-ExampleSkins"/>:</option>
              <option value="{$setup}&amp;skinNameSticky=bwclassic">
                <xsl:copy-of select="$bwStr-Foot-BwClassic" />
              </option>
              <option value="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=rss-list&amp;days=3">
                <xsl:copy-of select="$bwStr-Foot-RSSNext3Days"/></option>
              <option value="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=js-list&amp;days=3&amp;contentType=text/javascript&amp;contentName=bedework.js">
                <xsl:copy-of select="$bwStr-Foot-JavascriptNext3Days"/></option>
              <option value="{$setViewPeriod}&amp;viewType=todayView&amp;skinName=jsToday&amp;contentType=text/javascript&amp;contentName=bedeworkToday.js">
                <xsl:copy-of select="$bwStr-Foot-JavascriptTodaysEvents"/></option>
              <option value="{$setup}&amp;browserTypeSticky=PDA">
                <xsl:copy-of select="$bwStr-Foot-ForMobileBrowsers"/></option>
              <option value="{$setViewPeriod}&amp;viewType=todayView&amp;skinName=videocal">
                <xsl:copy-of select="$bwStr-Foot-VideoFeed"/></option>
              <option value="{$setup}&amp;skinNameSticky=default">
                <xsl:copy-of select="$bwStr-Foot-ResetToCalendarDefault"/></option>
            </select>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
