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
  <!-- ========================================= -->
  <!--       BEDEWORK FREEBUSY AGGREGATOR        -->
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
       set to the application root, but for the personal calendar
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot">https://mywebserver.edu/myresourcesdir</xsl:variable>
    -->
  <xsl:variable name="resourcesRoot" select="/bedework-fbaggregator/approot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework-fbaggregator/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework-fbaggregator/urlPrefixes/setup"/>
  <xsl:variable name="initialise" select="/bedework-fbaggregator/urlPrefixes/initialise"/>
  <xsl:variable name="fetchFreeBusy" select="/bedework-fbaggregator/urlPrefixes/fetchFreeBusy/a/@href"/>
  <xsl:variable name="addUser" select="/bedework-fbaggregator/urlPrefixes/addUser"/>
  <xsl:variable name="getTimeZones" select="/bedework-fbaggregator/urlPrefixes/getTimeZones"/>


  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedework-fbaggregator/urlprefix"/> -->

  <!-- Other generally useful global variables -->
  <xsl:variable name="prevdate" select="/bedework-fbaggregator/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework-fbaggregator/nextdate"/>
  <xsl:variable name="curdate" select="/bedework-fbaggregator/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>

 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Bedework: Personal Calendar Client</title>
        <meta name="robots" content="noindex,nofollow"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css"/>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
        <script type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/bedework-fbaggregator/message">
          <div id="messages">
            <xsl:apply-templates select="/bedework-fbaggregator/message"/>
          </div>
        </xsl:if>
        <xsl:if test="/bedework-fbaggregator/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework-fbaggregator/error"/>
          </div>
        </xsl:if>
        <table id="bodyBlock" cellspacing="0">
          <tr>
            <td id="fbForm">
              <xsl:call-template name="fbForm"/>
            </td>
            <td id="bodyContent">
              <xsl:call-template name="tabs"/>
              <xsl:call-template name="navigation"/>
              <xsl:choose>
                <xsl:when test="/bedework-fbaggregator/page='timeZones'">
                  <xsl:call-template name="utilBar"/>
                  <xsl:apply-templates select="/bedework-fbaggregator/timezones"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- otherwise, show freeBusy -->
                  <xsl:call-template name="utilBar"/>
                  <xsl:apply-templates select="/bedework-fbaggregator/freebusy"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
        <!-- footer -->
        <div id="footer">
          Freebusy Aggregator
        </div>
      </body>
    </html>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="http://www.bedework.org/"><img src="{$resourcesRoot}/resources/bedework-fbaggregatorLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
          <h2>Personal Calendar</h2>
          <a href="{$publicCal}">Public Calendar</a> |
          <a href="http://www.yourschoolhere.edu">School Home</a> |
          <a href="http://www.bedework.org/">Other Link</a> |
          <a href="http://helpdesk.rpi.edu/update.do?catcenterkey=51">
            Example Calendar Help
          </a>
        </td>
      </tr>
    </table>
    <table id="curDateRangeTable"  cellspacing="0">
      <tr>
        <td class="sideBarOpenCloseIcon">
          <xsl:choose>
            <xsl:when test="/bedework-fbaggregator/appvar[key='sidebar']/value='closed'">
              <a href="?setappvar=sidebar(opened)">
                <img alt="open sidebar" src="{$resourcesRoot}/resources/sideBarArrowOpen.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="?setappvar=sidebar(closed)">
                <img alt="close sidebar" src="{$resourcesRoot}/resources/sideBarArrowClose.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="date">
          <xsl:value-of select="/bedework-fbaggregator/firstday/longdate"/>
          <xsl:if test="/bedework-fbaggregator/periodname!='Day'">
            -
            <xsl:value-of select="/bedework-fbaggregator/lastday/longdate"/>
          </xsl:if>
        </td>
        <td class="rssPrint">
          <a href="javascript:window.print()" title="print this view">
            <img alt="print this view" src="{$resourcesRoot}/resources/std-print-icon.gif" width="20" height="14" border="0"/> print
          </a>
          <a class="rss" href="{$setSelection}&amp;setappvar=summaryMode(details)&amp;skinName=rss" title="RSS feed">RSS</a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="fbForm">
    <h3>
      <!--<img alt="manage views" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/>-->
      views
    </h3>
    <ul id="myViews">
      <xsl:choose>
        <xsl:when test="/bedework-fbaggregator/views/view">
          <xsl:for-each select="/bedework-fbaggregator/views/view">
            <xsl:variable name="viewName" select="name"/>
            <xsl:choose>
              <xsl:when test="/bedework-fbaggregator/selectionState/selectionType = 'view'
                              and name=/bedework-fbaggregator/selectionState/view/name">
                <li class="selected"><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:when>
              <xsl:otherwise>
                <li><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no views</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>

    <h3>
      <a href="{$calendar-fetch}">
        <img alt="manage calendars" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/> calendars
      </a>
    </h3>
    <ul class="calendarTree">
      <xsl:apply-templates select="/bedework-fbaggregator/myCalendars/calendars/calendar" mode="myCalendars"/>
    </ul>

    <h3>
      <a href="{$subscriptions-fetch}" title="manage subscriptions">
        <img alt="manage subscriptions" src="{$resourcesRoot}/resources/glassFill-icon-menuButton.gif" width="12" height="11" border="0"/>
        subscriptions
      </a>
    </h3>
    <ul class="calendarTree">
      <xsl:variable name="userPath">user/<xsl:value-of select="/bedework-fbaggregator/userid"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="/bedework-fbaggregator/mySubscriptions/subscription[not(contains(uri,$userPath))]">
          <xsl:apply-templates select="/bedework-fbaggregator/mySubscriptions/subscription[not(contains(uri,$userPath))]" mode="mySubscriptions"/>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no subscriptions</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>

    <h3>options</h3>
    <ul id="sideBarMenu">
      <li><a href="{$manageLocations}">Manage Locations</a></li>
      <li><a href="{$prefs-fetchForUpdate}">Preferences</a></li>
    </ul>
  </xsl:template>

  <xsl:template name="tabs">
    <xsl:choose>
      <xsl:when test="/bedework-fbaggregator/page='eventscalendar' or /bedework-fbaggregator/page='freeBusy'">
        <xsl:variable name="navAction">
          <xsl:choose>
            <xsl:when test="/bedework-fbaggregator/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework-fbaggregator/periodname='Day'">
                  <a href="{$navAction}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-on.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework-fbaggregator/periodname='Week' or /bedework-fbaggregator/periodname=''">
                  <a href="{$navAction}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-on.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
                 </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework-fbaggregator/periodname='Month'">
                  <a href="{$navAction}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-on.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$navAction}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <xsl:choose>
                <!-- don't allow switching to year for free busy view, so only use setViewPeriod action -->
                <xsl:when test="/bedework-fbaggregator/periodname='Year'">
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-on.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="rightCell">
              logged in as
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework-fbaggregator/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}&amp;logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table border="0" cellpadding="0" cellspacing="0" id="tabsTable">
          <tr>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-day-off.gif" width="91" height="20" border="0" alt="DAY"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-week-off.gif" width="92" height="20" border="0" alt="WEEK"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-month-off.gif" width="90" height="20" border="0" alt="MONTH"/></a>
            </td>
            <td>
              <a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-tab-year-off.gif" width="92" height="20" border="0" alt="YEAR"/></a>
            </td>
            <td class="rightCell">
              logged in as
              <xsl:text> </xsl:text>
              <strong><xsl:value-of select="/bedework-fbaggregator/userid"/></strong>
              <xsl:text> </xsl:text>
              <span class="logout"><a href="{$setup}&amp;logout=true">logout</a></span>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="navigation">
    <xsl:variable name="navAction">
      <xsl:choose>
        <xsl:when test="/bedework-fbaggregator/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a href="{$navAction}&amp;date={$prevdate}"><img src="{$resourcesRoot}/resources/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$navAction}&amp;date={$nextdate}"><img src="{$resourcesRoot}/resources/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/bedework-fbaggregator/periodname='Year'">
              <xsl:value-of select="substring(/bedework-fbaggregator/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework-fbaggregator/periodname='Month'">
              <xsl:value-of select="/bedework-fbaggregator/firstday/monthname"/>, <xsl:value-of select="substring(/bedework-fbaggregator/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework-fbaggregator/periodname='Week'">
              Week of <xsl:value-of select="substring-after(/bedework-fbaggregator/firstday/longdate,', ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework-fbaggregator/firstday/longdate"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="todayButton">
          <a href="{$navAction}&amp;viewType=todayView&amp;date={$curdate}">
            <img src="{$resourcesRoot}/resources/std-button-today-off.gif" width="54" height="22" border="0" alt="Go to Today" align="left"/>
          </a>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="get" action="{$navAction}">
             <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <xsl:if test="/bedework-fbaggregator/periodname!='Year'">
                  <td>
                    <select name="viewStartDate.month">
                      <xsl:for-each select="/bedework-fbaggregator/monthvalues/val">
                        <xsl:variable name="temp" select="."/>
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:choose>
                          <xsl:when test="/bedework-fbaggregator/monthvalues[start=$temp]">
                            <option value="{$temp}" selected="selected">
                              <xsl:value-of select="/bedework-fbaggregator/monthlabels/val[position()=$pos]"/>
                            </option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="{$temp}">
                              <xsl:value-of select="/bedework-fbaggregator/monthlabels/val[position()=$pos]"/>
                            </option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </select>
                  </td>
                  <xsl:if test="/bedework-fbaggregator/periodname!='Month'">
                    <td>
                      <select name="viewStartDate.day">
                        <xsl:for-each select="/bedework-fbaggregator/dayvalues/val">
                          <xsl:variable name="temp" select="."/>
                          <xsl:variable name="pos" select="position()"/>
                          <xsl:choose>
                            <xsl:when test="/bedework-fbaggregator/dayvalues[start=$temp]">
                              <option value="{$temp}" selected="selected">
                                <xsl:value-of select="/bedework-fbaggregator/daylabels/val[position()=$pos]"/>
                              </option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="{$temp}">
                                <xsl:value-of select="/bedework-fbaggregator/daylabels/val[position()=$pos]"/>
                              </option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </select>
                    </td>
                  </xsl:if>
                </xsl:if>
                <td>
                  <xsl:variable name="temp" select="/bedework-fbaggregator/yearvalues/start"/>
                  <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                </td>
                <td>
                  <input name="submit" type="submit" value="go"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="utilBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="utilBarTable">
       <tr>
         <td class="leftCell">
           <xsl:choose>
             <xsl:when test="/bedework-fbaggregator/periodname = 'day'">
               <xsl:variable name="date" select="/bedework-fbaggregator/firstday/date"/>
               <a href="{$initEvent}&amp;startdate={$date}" title="add event">
                  <img src="{$resourcesRoot}/resources/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="add event"/>
                  add event
               </a>
             </xsl:when>
             <xsl:otherwise>
               <a href="{$initEvent}" title="add event">
                  <img src="{$resourcesRoot}/resources/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="add event"/>
                  add event
               </a>
             </xsl:otherwise>
           </xsl:choose>
           <a href="{$initUpload}" title="upload event">
              <img src="{$resourcesRoot}/resources/std-icalUpload-icon-small.gif" width="12" height="16" border="0" alt="upload event"/>
              upload
           </a>
         </td>
         <td class="rightCell">

           <!-- show free / busy -->
           <xsl:choose>
             <xsl:when test="/bedework-fbaggregator/periodname!='Year'">
               <xsl:choose>
                 <xsl:when test="/bedework-fbaggregator/page='freeBusy'">
                   <a href="{$setViewPeriod}&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-button-events.gif" width="70" height="21" border="0" alt="show events"/></a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$freeBusy-fetch}&amp;date={$curdate}"><img src="{$resourcesRoot}/resources/std-button-freebusy.gif" width="70" height="21" border="0" alt="show free/busy"/></a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <img src="{$resourcesRoot}/resources/std-button-freebusy-off.gif" width="70" height="21" border="0" alt="show free/busy"/>
             </xsl:otherwise>
           </xsl:choose>

           <!-- toggle list / calendar view -->
           <xsl:choose>
             <xsl:when test="/bedework-fbaggregator/periodname='Day'">
               <img src="{$resourcesRoot}/resources/std-button-listview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
             </xsl:when>
             <xsl:when test="/bedework-fbaggregator/periodname='Year'">
               <img src="{$resourcesRoot}/resources/std-button-calview-off.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
             </xsl:when>
             <xsl:when test="/bedework-fbaggregator/periodname='Month'">
               <xsl:choose>
                 <xsl:when test="/bedework-fbaggregator/appvar[key='monthViewMode']/value='list'">
                   <a href="{$setup}&amp;setappvar=monthViewMode(cal)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=monthViewMode(list)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <xsl:choose>
                 <xsl:when test="/bedework-fbaggregator/appvar[key='weekViewMode']/value='list'">
                   <a href="{$setup}&amp;setappvar=weekViewMode(cal)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-calview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=weekViewMode(list)" title="toggle list/calendar view">
                     <img src="{$resourcesRoot}/resources/std-button-listview.gif" width="46" height="21" border="0" alt="toggle list/calendar view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:otherwise>
           </xsl:choose>

           <!-- summary / detailed mode toggle -->
           <xsl:choose>
             <xsl:when test="/bedework-fbaggregator/periodname='Year' or
                              (/bedework-fbaggregator/periodname='Month' and
                              (/bedework-fbaggregator/appvar[key='monthViewMode']/value='cal' or
                               not(/bedework-fbaggregator/appvar[key='monthViewMode']))) or
                              (/bedework-fbaggregator/periodname='Week' and
                              (/bedework-fbaggregator/appvar[key='weekViewMode']/value='cal' or
                               not(/bedework-fbaggregator/appvar[key='weekViewMode'])))">
               <xsl:choose>
                 <xsl:when test="/bedework-fbaggregator/appvar[key='summaryMode']/value='details'">
                   <img src="{$resourcesRoot}/resources/std-button-summary-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                 </xsl:when>
                 <xsl:otherwise>
                   <img src="{$resourcesRoot}/resources/std-button-details-off.gif" width="62" height="21" border="0" alt="only summaries of events supported in this view"/>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <xsl:choose>
                 <xsl:when test="/bedework-fbaggregator/appvar[key='summaryMode']/value='details'">
                   <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                     <img src="{$resourcesRoot}/resources/std-button-summary.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a href="{$setup}&amp;setappvar=summaryMode(details)" title="toggle summary/detailed view">
                     <img src="{$resourcesRoot}/resources/std-button-details.gif" width="62" height="21" border="0" alt="toggle summary/detailed view"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:otherwise>
           </xsl:choose>

           <!-- refresh button -->
           <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
         </td>
       </tr>
    </table>
  </xsl:template>

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template match="freebusy">
    <h2>Free / Busy</h2>
    <div id="freeBusyWho">for <xsl:value-of select="day/who"/></div>
    <table id="freeBusy">
      <tr>
        <td>&#160;</td>
        <xsl:for-each select="day[position()=1]/period">
          <th>
            <xsl:choose>
              <xsl:when test="number(start) mod 200 = 0">
                <xsl:apply-templates select="start" mode="timeDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="day">
        <tr>
          <th>
            <xsl:value-of select="substring(start,1,4)"/>-<xsl:value-of select="substring(start,5,2)"/>-<xsl:value-of select="substring(start,7,2)"/>
          </th>
          <xsl:for-each select="period">
            <xsl:variable name="startTime"><xsl:apply-templates  select="start" mode="timeDisplay"/></xsl:variable>
            <!-- the start date for the add event link is a concat of the day's date plus the period's time (+ seconds)-->
            <xsl:variable name="startDate"><xsl:value-of select="substring(../start,1,8)"/>T<xsl:value-of select="start"/>00</xsl:variable>
            <xsl:variable name="minutes" select="length"/>
            <xsl:variable name="fbClass">
              <xsl:choose>
                <xsl:when test="fbtype = '0'">busy</xsl:when>
                <xsl:when test="fbtype = '3'">tentative</xsl:when>
                <xsl:otherwise>free</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <td class="{$fbClass}">
              <a href="{$initEvent}&amp;startdate={$startDate}&amp;minutes={$minutes}" title="{$startTime}">*</a>
            </td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>

    <table id="freeBusyKey">
      <tr>
        <td class="free">*</td>
        <td>free</td>
        <td>&#160;</td>
        <td class="busy">*</td>
        <td>busy</td>
        <td>&#160;</td>
        <td class="tentative">*</td>
        <td>tentative</td>
        <td>&#160;</td>
        <td>
          <form name="calendarShareForm" action="{$freeBusy-fetch}">
            View user's free/busy:<br/>
            <input type="text" name="userid" size="20"/>
            <input type="submit" name="submit" value="Submit"/>
          </form>
        </td>
      </tr>
    </table>

    <div id="sharingBox">
      <h3>Sharing</h3>
      <table class="common">
        <tr>
          <th class="commonHeader" colspan="2">Current access:</th>
        </tr>
        <tr>
          <th>Users:</th>
          <td>
            <xsl:choose>
              <xsl:when test="/bedework-fbaggregator/myCalendars/calendars/calendar/acl/ace/principal/href">
                <xsl:for-each select="/bedework-fbaggregator/myCalendars/calendars/calendar/acl/ace[principal/href]">
                  <xsl:value-of select="principal/href"/> (<xsl:value-of select="name(grant/*)"/>)<br/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                free/busy not shared
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
      <form name="calendarShareForm" action="{$freeBusy-setAccess}" id="shareForm">
        <xsl:variable name="calPath" select="/bedework-fbaggregator/myCalendars/calendars/calendar/path"/>
        <input type="hidden" name="calPath" value="{$calPath}"/>
        <p>
          Share my free/busy with:<br/>
          <input type="text" name="who" size="20"/>
          <input type="radio" value="user" name="whoType" checked="checked"/> user
          <input type="radio" value="group" name="whoType"/> group
        </p>
        <p>
          Access rights:<br/>
          <input type="radio" value="F" name="how" checked="checked"/> view my free/busy<br/>
          <input type="radio" value="d" name="how"/> default (reset access)
        </p>
        <input type="submit" name="submit" value="Submit"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template match="start" mode="timeDisplay">
    <xsl:choose>
      <xsl:when test="node()=0000">12am</xsl:when>
      <xsl:when test="node()=0100">1am</xsl:when>
      <xsl:when test="node()=0200">2am</xsl:when>
      <xsl:when test="node()=0300">3am</xsl:when>
      <xsl:when test="node()=0400">4am</xsl:when>
      <xsl:when test="node()=0500">5am</xsl:when>
      <xsl:when test="node()=0600">6am</xsl:when>
      <xsl:when test="node()=0700">7am</xsl:when>
      <xsl:when test="node()=0800">8am</xsl:when>
      <xsl:when test="node()=0900">9am</xsl:when>
      <xsl:when test="node()=1000">10am</xsl:when>
      <xsl:when test="node()=1100">11am</xsl:when>
      <xsl:when test="node()=1200">NOON</xsl:when>
      <xsl:when test="node()=1300">1pm</xsl:when>
      <xsl:when test="node()=1400">2pm</xsl:when>
      <xsl:when test="node()=1500">3pm</xsl:when>
      <xsl:when test="node()=1600">4pm</xsl:when>
      <xsl:when test="node()=1700">5pm</xsl:when>
      <xsl:when test="node()=1800">6pm</xsl:when>
      <xsl:when test="node()=1900">7pm</xsl:when>
      <xsl:when test="node()=2000">8pm</xsl:when>
      <xsl:when test="node()=2100">9pm</xsl:when>
      <xsl:when test="node()=2200">10pm</xsl:when>
      <xsl:when test="node()=2300">11pm</xsl:when>
      <xsl:when test="node()=2400">12am</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
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
</xsl:stylesheet>
