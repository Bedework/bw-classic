<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="html"
  indent="yes"
  media-type="text/html"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
  doctype-system="http://www.w3.org/TR/html4/loose.dtd"
  standalone="yes"
/>

<!-- =========================================================

        DEMONSTRATION "DEPARTMENTAL" CALENDAR STYLESHEET

     This stylesheet is for the "soe" (School of Engineering)
     calendar suite; it is an example of a departmental skin.

     This skin, along with the preferences for the Calendar
     Suite owner, differs from the main public skin (default.xsl) in the
     following ways:
       - different header, title, and footer
       - default layout = list view (rather than calendar grid)
       - different color scheme

     Otherwise, for the sake of demonstration, we've left most of the
     functionality of the public client in place.

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
  <xsl:include href="errors.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
  <xsl:variable name="resourcesRoot" select="/bedework/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/setSelection"/>
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/fetchPublicCalendars"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/setViewPeriod"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/export/a/@href"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mailEvent"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/showPage"/>
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>


  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>School of Engineering: Example Bedework Departmental Calendar Suite</title>
        <link rel="stylesheet" type="text/css" href="{$resourcesRoot}/default/default/soe.css" />
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
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='showSysStats'">
            <!-- show system stats -->
            <xsl:call-template name="stats"/>
          </xsl:when>
          <xsl:when test="/bedework/page='calendarList'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/bedework/calendars"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show the eventsCalendar -->
            <xsl:if test="/bedework/periodname!='Year'">
              <xsl:call-template name="searchBar"/>
            </xsl:if>
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <xsl:call-template name="listView"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='cal'">
                    <xsl:call-template name="weekView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="listView"/>
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
    <div id="headBar">
      <div id="bedeworkLogo">
        <a href="{$urlPrefix}">
          <img src="{$resourcesRoot}/images/soecal/soeBedeworkLogo.gif" width="296" height="69" border="0" alt="Bedework" align="right"/>
        </a>
      </div>
      <h1>Example Departmental Calendar Suite</h1>
      <!--<ul id="schoolLinks">
        <li><a href="{$privateCal}">Personal Calendar</a></li>
        <li><a href="http://www.yourschoolhere.edu">School Home</a></li>
        <li><a href="http://www.bedework.org/">Other Link</a></li>
        <li>
          <a href="http://helpdesk.rpi.edu/update.do?catcenterkey=51">
            Example Calendar Help
          </a>
        </li>
      </ul> -->
    </div>
    <!--  Turn off the date range table for this departmental view -->
    <!--<table id="curDateRangeTable"  cellspacing="0">
      <td class="sideBarOpenCloseIcon">
        &#160; -->
        <!--
        we may choose to implement calendar selection in the public calendar
        using a sidebar; leave this comment here for now.
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='sidebar']/value='closed'">
            <a href="?setappvar=sidebar(opened)">
              <img alt="open sidebar" src="{$resourcesRoot}/resources/sideBarArrowOpen.gif" width="21" height="16" border="0" align="left"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="?setappvar=sidebar(closed)">
              <img alt="close sidebar" src="{$resourcesRoot}/resources/sideBarArrowClose.gif" width="21" height="16" border="0" align="left"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>-->
      <!-- </td>
      <td class="date">
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            Event Information
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
        <a href="javascript:window.print()" title="print this view">
          <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/> print
        </a>
        <a class="rss" href="{$setSelection}&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
      </td>
    </table>-->
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/bedework/page='eventscalendar'">
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Day'">
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-day-on.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                  <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Month'">
                  <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/periodname='Year'">
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rssPrint">
              <a href="javascript:window.print()" title="print this view">
                <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/> print
              </a>
              <a class="rss" href="{$setup}&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/images/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="rssPrint">
              <a href="javascript:window.print()" title="print this view">
                <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/> print
              </a>
              <a class="rss" href="{$setSelection}&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
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
              Week of <xsl:value-of select="substring-after(/bedework/firstday/longdate,', ')"/>
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
                  <input name="submit" type="submit" value="go"/>
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
             <xsl:when test="/bedework/selectionState/selectionType = 'calendar'">
               Calendar: <xsl:value-of select="/bedework/selectionState/subscriptions/subscription/calendar/name"/>
               <span class="link">[<a href="{$setSelection}">default view</a>]</span>
             </xsl:when>
             <xsl:when test="/bedework/selectionState/selectionType = 'search'">
               Current search: <xsl:value-of select="/bedework/search"/>
               <span class="link">[<a href="{$setSelection}">default view</a>]</span>
             </xsl:when>
             <xsl:when test="/bedework/selectionState/selectionType = 'subscription'">
               Subscription: (not implemented yet)
               <span class="link">[<a href="{$setSelection}">default view</a>]</span>
             </xsl:when>
             <xsl:when test="/bedework/selectionState/selectionType = 'filter'">
               Filter: (not implemented yet)
               <span class="link">[<a href="{$setSelection}">default view</a>]</span>
             </xsl:when>
             <xsl:otherwise><!-- view -->
               View:
               <form name="selectViewForm" method="post" action="{$setSelection}">
                <select name="viewName" onChange="submit()" >
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
              <span class="calLinks"><a href="{$setSelection}">default view</a> | <a href="{$fetchPublicCalendars}">available calendars</a></span>
             </xsl:otherwise>
           </xsl:choose>
         </td>
         <td class="rightCell">
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <img src="{$resourcesRoot}/images/std-button-listview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Year'">
                <img src="{$resourcesRoot}/images/std-button-calview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                    <a href="{$setup}&amp;setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                      <img src="{$resourcesRoot}/images/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=monthViewMode(list)" title="toggle list/calendar view">
                      <img src="{$resourcesRoot}/images/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='cal'">
                    <a href="{$setup}&amp;setappvar=weekViewMode(list)" title="toggle list/calendar view">
                      <img src="{$resourcesRoot}/images/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                      <img src="{$resourcesRoot}/images/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
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
                    <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                      <img src="{$resourcesRoot}/images/std-button-summary.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$setup}&amp;setappvar=summaryMode(details)" title="toggle summary/detailed view">
                      <img src="{$resourcesRoot}/images/std-button-details.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <a href="setup.do"><img src="{$resourcesRoot}/images/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
          </td>
       </tr>
    </table>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2 class="{$statusClass}">
      <xsl:if test="status='CANCELLED'">CANCELLED: </xsl:if>
      <xsl:choose>
        <xsl:when test="link != ''">
          <xsl:variable name="link" select="link"/>
          <a href="{$link}">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <td class="fieldname">When:</td>
        <td class="fieldval">
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
        <th class="icalIcon" rowspan="2">
          <div id="eventIcons">
            <xsl:variable name="id" select="id"/>
            <xsl:variable name="subscriptionId" select="subscription/id"/>
            <xsl:variable name="calPath" select="calendar/encodedPath"/>
            <xsl:variable name="guid" select="guid"/>
            <xsl:variable name="recurrenceId" select="recurrenceId"/>
            <a href="{$privateCal}/addEventRef.do?subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="Add event to MyCalendar" target="myCalendar">
              <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
            add to my calendar</a>
            <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
            <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
              <img src="{$resourcesRoot}/images/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
             download</a>
          </div>
        </th>
      </tr>
      <tr>
        <td class="fieldname">Where:</td>
        <td class="fieldval">
          <xsl:choose>
            <xsl:when test="location/link=''">
              <xsl:value-of select="location/address"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="locationLink" select="location/link"/>
              <a href="{$locationLink}">
                <xsl:value-of select="location/address"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="location/subaddress!=''">
            <br/><xsl:value-of select="location/subaddress"/>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="fieldname">Description:</td>
        <td colspan="2" class="fieldval description">
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname">Status:</td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname">Cost:</td>
          <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname">See:</td>
          <td colspan="2" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sponsor/name!='none'">
        <tr>
          <td class="fieldname">Contact:</td>
          <td colspan="2" class="fieldval">
            <xsl:choose>
              <xsl:when test="sponsor/link=''">
                <xsl:value-of select="sponsor/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="sponsor/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="sponsor/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="sponsor/phone!=''">
              <br /><xsl:value-of select="sponsor/phone"/>
            </xsl:if>
            <!-- If you want to display email addresses, uncomment the
                 following 8 lines. -->
            <!-- <xsl:if test="sponsor/email!=''">
              <br />
              <xsl:variable name="email" select="sponsor/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}&amp;subject={$subject}">
                <xsl:value-of select="sponsor/email"/>
              </a>
            </xsl:if> -->
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td class="fieldname">Calendar:</td>
        <td class="fieldval">
          <xsl:variable name="calUrl" select="calendar/path"/>
          <a href="{$setSelection}&amp;calUrl={$calUrl}">
            <xsl:value-of select="calendar/name"/>
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
              No events to display.
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
              <xsl:variable name="subscriptionId" select="subscription/id"/>
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
                      all day
                    </td>
                  </xsl:when>
                  <xsl:when test="start/shortdate = end/shortdate and
                                  start/time = end/time">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="start/time"/>
                      </a>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="start/allday = 'true' and
                                        parent::day/shortdate = start/shortdate">
                          today
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
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                      <xsl:choose>
                        <xsl:when test="end/allday = 'true' and
                                        parent::day/shortdate = end/shortdate">
                          today
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
                    <xsl:otherwise>description</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <td class="{$descriptionClass}">
                  <xsl:if test="status='CANCELLED'"><strong>CANCELLED: </strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                          <xsl:if test="sponsor/name!='none'">
                            Contact: <xsl:value-of select="sponsor/name"/>
                          </xsl:if>
                        </em>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="summary"/>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="icons">
                  <variable name="confId" select="/bedework/confirmationid"/>
                  <a href="{$privateCal}/addEventRef.do?subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="Add event to MyCalendar" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="Add event to MyCalendar"/>
                  </a>
                  <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                  <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
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
              <ul>
                <xsl:apply-templates select="event" mode="calendarLayout">
                  <xsl:with-param name="dayPos" select="$dayPos"/>
                </xsl:apply-templates>
              </ul>
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
                  <ul>
                    <xsl:apply-templates select="event" mode="calendarLayout">
                      <xsl:with-param name="dayPos" select="$dayPos"/>
                    </xsl:apply-templates>
                  </ul>
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
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <xsl:when test="calendar/name='Holidays'">holiday</xsl:when>
        <!-- Alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass}">
        <xsl:if test="status='CANCELLED'">CANCELLED: </xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            (cont)
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            all day:
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
          <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled">CANCELLED</span></xsl:if>
          <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative">TENTATIVE</span></xsl:if>
          <strong><xsl:value-of select="summary"/></strong><br/>
          Time:
          <xsl:choose>
            <xsl:when test="start/allday = 'false'">
              <xsl:value-of select="start/time"/>
              <xsl:if test="start/time != end/time">
                - <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              all day
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            Location: <xsl:value-of select="location/address"/><br/>
          </xsl:if>
          Calendar: <xsl:value-of select="calendar/name"/>
        </span>
      </a>
    </li>
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

  <!--==== CALENDARS PAGE ====-->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(calendar/calendar)"/>
    <table id="calPageTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2">
          All Calendars
        </th>
      </tr>
      <tr>
        <td colspan="2" class="infoCell">
          Select a calendar from the list below to see only that calendar's events.
        </td>
      </tr>
      <tr>
        <td class="leftCell">
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[position() &lt;= ceiling($topLevelCalCount div 2)]" mode="calTree"/>
          </ul>
        </td>
        <td>
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar/calendar[position() &gt; ceiling($topLevelCalCount div 2)]" mode="calTree"/>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url" select="path"/>
    <li class="{$itemClass}">
      <a href="{$setSelection}&amp;calUrl={$url}"><xsl:value-of select="name"/></a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->
  <xsl:template name="stats">
    <div id="stats">
      <h2>System Statistics</h2>

      <p>
        Stats collection:
      </p>
      <ul>
        <li>
          <a href="{$stats}&amp;enable=yes">enable</a> |
          <a href="{$stats}&amp;disable=yes">disable</a>
        </li>
        <li><a href="{$stats}&amp;fetch=yes">fetch statistics</a></li>
        <li><a href="{$stats}&amp;dump=yes">dump stats to log</a></li>
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

  <!--==== UTILITY TEMPLATES ====-->

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

  <!--==== FOOTER ====-->

  <xsl:template name="footer">
    <div id="footer">
      Demonstration calendar; place footer information here.
    </div>
    <div id="subFoot">
      Based on the <a href="http://www.bedework.org/">Bedework Calendar</a> |
      <a href="?noxslt=yes">show XML</a> |
      <a href="?refreshXslt=yes">refresh XSLT</a>
    </div>
  </xsl:template>
</xsl:stylesheet>
