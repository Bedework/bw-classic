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
  <xsl:variable name="fetchFreeBusy" select="/bedework-fbaggregator/urlPrefixes/fetchFreeBusy"/>
  <xsl:variable name="addUser" select="/bedework-fbaggregator/urlPrefixes/addUser"/>
  <xsl:variable name="getTimeZones" select="/bedework-fbaggregator/urlPrefixes/getTimeZones"/>


  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedework-fbaggregator/urlprefix"/> -->

  <!-- Other generally useful global variables
  <xsl:variable name="prevdate" select="/bedework-fbaggregator/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework-fbaggregator/nextdate"/>
  <xsl:variable name="curdate" select="/bedework-fbaggregator/currentdate/date"/>
  <xsl:variable name="skin">default</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>-->


 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>CalConnect Boeing CalDav Freebusy Aggregator</title>
        <meta name="robots" content="noindex,nofollow"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/default.css" media="screen,all"/>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/resources/bedework.ico" />
        <script type="text/javascript" src="{$resourcesRoot}/resources/includes.js"></script>
        <script type="text/javascript" src="{$resourcesRoot}/resources/dynCalendarWidget.js"></script>
        <link rel="stylesheet" href="{$resourcesRoot}/resources/dynCalendarWidget.css"/>
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
              <xsl:choose>
                <xsl:when test="/bedework-fbaggregator/page='freeBusy'">
                  <xsl:apply-templates select="/bedework-fbaggregator/freebusy"/>
                </xsl:when>
                <xsl:when test="/bedework-fbaggregator/page='timeZones'">
                  <xsl:apply-templates select="/bedework-fbaggregator/timezones"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- otherwise, show main -->
                  <div id="frontPage">
                    <p>
                      <a href="http://www.calconnect.org">
                        <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/calconnect.gif" width="175" height="67" alt="calconnect" border="0"/>
                      </a>
                      <a href="http://www.boeing.com">
                        <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/boeing.gif" width="100" height="67" alt="calconnect" border="0"/>
                      </a>
                    </p>
                    <h2>CalDAV Freebusy Aggregator</h2>
                    <p>To begin, enter a date range on the left and click "aggregate".</p>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td id="logos">
              <h4>participants</h4>
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/fbagg-logos.gif" width="100" height="403" alt="participant logos" usemap="#logoMap" border="0"/>
              <map name="logoMap">
                <area shape="rect" alt="Timebridge" coords="0,340,100,380" href="http://www.timebridge.com/"/>
                <area shape="rect" alt="OSAF" coords="0,260,100,302" href="http://www.osafoundation.org/"/>
                <area shape="rect" alt="Oracle" coords="0,187,100,225" href="http://www.oracle.com"/>
                <area shape="rect" alt="Boeing" coords="0,101,100,153" href="http://www.boeing.com/"/>
                <area shape="rect" alt="Bedework" coords="0,13,100,77" href="http://www.bedework.org/bedework/"/>
              </map>
            </td>
          </tr>
        </table>
        <!-- footer -->
        <div id="footer">
          <a href="/fbagg/getFreeBusy.do?all=true&amp;startdt=20060703&amp;enddt=20060710&amp;refreshXslt=yes">Refresh Freebusy Aggregator</a>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->

  <xsl:template name="headBar">
    <div id="headBar">
      <h1>CALCONNECT BOEING CALDAV FREEBUSY AGGREGATOR</h1>
      <!--<h1>Calconnect Boeing CalDav Freebusy Aggregator</h1>-->
    </div>
    <div id="menuBar">
      <a href="{$setup}">Display Freebusy</a> |
      <a href="">User Management</a>
    </div>
  </xsl:template>

  <xsl:template name="fbForm">
    <xsl:variable name="startdt" select="substring(/bedework-fbaggregator/freebusy/start,1,8)"/>
    <xsl:variable name="enddt" select="substring(/bedework-fbaggregator/freebusy/end,1,8)"/>
    <h4>aggregation</h4>
    <form
       name="freebusyForm"
       method="post"
       action="{$fetchFreeBusy}"
       enctype="multipart/form-data"
       id="freebusyForm">
      <input type="hidden" name="all" value="true"/>
      <p>
        Start date:<br/>
        <input
         type="text"
         name="startdt"
         size="8"
         value="" />
        <span class="calWidget">
          <script language="JavaScript" type="text/javascript">
            startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', 'startDateCalWidgetCallback','<xsl:value-of select="$resourcesRoot"/>/resources/');
          </script>
        </span>
      </p>
      <p>
        End date:<br/>
        <input
         type="text"
         name="enddt"
         size="8"
         value="" />
        <span class="calWidget">
          <script language="JavaScript" type="text/javascript">
            endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback','<xsl:value-of select="$resourcesRoot"/>/resources/');
          </script>
        </span><!--<br />
        <em>yyyymmdd</em>-->
      </p>
       <p class="padTop center">
         <input type="submit" value="aggregate"/>
       </p>
       <!--<input type="reset" value="reset"/>-->
     </form>

     <h4>users</h4>
     <p class="center">
      Add user/group:<br/>
      <input
       type="text"
       name="user"
       size="12"
       value="" /><br/>
       <input type="radio" value="user" name="kind" checked="checked"/>user
      <input type="radio" value="group" name="kind"/>group
     </p>
     <table id="users">
       <tr>
          <td>
            <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
          </td>
          <td>
            <a href="{$fetchFreeBusy}&amp;account=douglm&amp;startdt={$startdt}&amp;enddt={$enddt}" title="fetch douglm's freebusy">douglm</a>
          </td>
          <td>
            <xsl:variable name="acct" select="account"/>
              <!--<a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user" title="remove">-->
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
              <!--</a>-->
          </td>
        </tr>
        <tr>
          <td>
            <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
          </td>
          <td>
            <a href="{$fetchFreeBusy}&amp;account=johnsa&amp;startdt={$startdt}&amp;enddt={$enddt}" title="fetch johnsa's freebusy">johnsa</a>
          </td>
          <td>
            <xsl:variable name="acct" select="account"/>
              <!--<a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user" title="remove">-->
                <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
              <!--</a>-->
          </td>
        </tr>
      <!--<xsl:for-each select="/bedeworkadmin/adminGroup/members/member">
        <xsl:choose>
          <xsl:when test="kind='0'">--><!-- kind = user -->
            <!--<tr>
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
          <xsl:otherwise>--><!-- kind = group -->
            <!--<tr>
              <td>
                <img src="{$resourcesRoot}/resources/groupIcon.gif" width="13" height="13" border="0" alt="group"/>
              </td>
              <td>
                <strong><xsl:value-of select="account"/></strong>
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
      </xsl:for-each> -->
    </table>
  </xsl:template>

  <xsl:template name="utilBar">
    <!-- refresh button -->
    <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
  </xsl:template>

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template match="freebusy">
    <xsl:variable name="startDate">
      <xsl:value-of select="substring(start,1,4)"/>-<xsl:value-of select="substring(start,5,2)"/>-<xsl:value-of select="substring(start,7,2)"/>
    </xsl:variable>
    <xsl:variable name="endDate">
      <xsl:value-of select="substring(end,1,4)"/>-<xsl:value-of select="substring(end,5,2)"/>-<xsl:value-of select="substring(end,7,2)"/>
    </xsl:variable>
    <h2>Freebusy Aggregator</h2>
    <table id="freeBusy">
      <tr>
        <th colspan="16" class="">
          All aggregated
        </th>
        <th colspan="16">
          <xsl:value-of select="$startDate"/> to <xsl:value-of select="$endDate"/>
        </th>
        <th colspan="16">
          America/New_York [<a href="{$getTimeZones}">change</a>]
        </th>
      </tr>
      <tr>
        <td>&#160;</td>
        <td colspan="24" class="morning">AM</td>
        <td colspan="24" class="evening">PM</td>
      </tr>
      <tr>
        <td>&#160;</td>
        <xsl:for-each select="day[position()=1]/period">
          <td class="timeLabels">
            <xsl:choose>
              <xsl:when test="number(start) mod 200 = 0">
                <xsl:apply-templates select="start" mode="timeDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                &#160;
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="day">
        <tr>
          <xsl:choose>
            <xsl:when test="position()=1">
              <td class="dayDate"><xsl:value-of select="substring-after($startDate,'-')"/></td>
            </xsl:when>
            <xsl:when test="position()=last()">
              <td class="dayDate"><xsl:value-of select="substring-after($endDate,'-')"/></td>
            </xsl:when>
            <xsl:otherwise>
              <td></td>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="period">
            <xsl:variable name="startTime" select="start"/>
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
              <a href="/ucal/initEvent.do?startdate={$startDate}&amp;minutes={$minutes}" title="{$startTime}">*</a>
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
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="start" mode="timeDisplay">
    <xsl:choose>
      <xsl:when test="node()=0000">12</xsl:when>
      <xsl:when test="node()=0100">1</xsl:when>
      <xsl:when test="node()=0200">2</xsl:when>
      <xsl:when test="node()=0300">3</xsl:when>
      <xsl:when test="node()=0400">4</xsl:when>
      <xsl:when test="node()=0500">5</xsl:when>
      <xsl:when test="node()=0600">6</xsl:when>
      <xsl:when test="node()=0700">7</xsl:when>
      <xsl:when test="node()=0800">8</xsl:when>
      <xsl:when test="node()=0900">9</xsl:when>
      <xsl:when test="node()=1000">10</xsl:when>
      <xsl:when test="node()=1100">11</xsl:when>
      <xsl:when test="node()=1200">12</xsl:when>
      <xsl:when test="node()=1300">1</xsl:when>
      <xsl:when test="node()=1400">2</xsl:when>
      <xsl:when test="node()=1500">3</xsl:when>
      <xsl:when test="node()=1600">4</xsl:when>
      <xsl:when test="node()=1700">5</xsl:when>
      <xsl:when test="node()=1800">6</xsl:when>
      <xsl:when test="node()=1900">7</xsl:when>
      <xsl:when test="node()=2000">8</xsl:when>
      <xsl:when test="node()=2100">9</xsl:when>
      <xsl:when test="node()=2200">10</xsl:when>
      <xsl:when test="node()=2300">11</xsl:when>
      <xsl:when test="node()=2400">12</xsl:when>
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
