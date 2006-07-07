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
  <xsl:variable name="manageAttendees" select="/bedework-fbaggregator/urlPrefixes/manageUsers"/>
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
        <script language="JavaScript" type="text/javascript">
          <xsl:comment>
          <![CDATA[
          // select first element when the page is loaded
          // if a form exists on the page
          function selectFirstElement() {
            if (window.document.forms[0]) {
              window.document.forms[0].elements[0].select();
            }
          }]]>
          </xsl:comment>
        </script>
      </head>
      <body onload="selectFirstElement()">
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
        <xsl:choose>
          <xsl:when test="/bedework-fbaggregator/page='manageUsers'">
            <xsl:call-template name="manageAttendees"/>
          </xsl:when>
          <xsl:when test="/bedework-fbaggregator/page='timeZones'">
            <xsl:apply-templates select="/bedework-fbaggregator/timezones"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show frontPage or freeBusy -->
            <xsl:call-template name="freebusy"/>
          </xsl:otherwise>
        </xsl:choose>
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
      <a href="{$manageAttendees}&amp;refreshXslt=yes">Manage Attendees</a>
    </div>
  </xsl:template>

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template name="freebusy">
    <xsl:variable name="startdt" select="substring(/bedework-fbaggregator/freebusy/start,1,8)"/>
    <xsl:variable name="enddt" select="substring(/bedework-fbaggregator/freebusy/end,1,8)"/>
    <xsl:variable name="startDate">
      <xsl:value-of select="substring($startdt,1,4)"/>-<xsl:value-of select="substring($startdt,5,2)"/>-<xsl:value-of select="substring($startdt,7,2)"/>
    </xsl:variable>
    <xsl:variable name="endDate">
      <xsl:value-of select="substring($enddt,1,4)"/>-<xsl:value-of select="substring($enddt,5,2)"/>-<xsl:value-of select="substring($enddt,7,2)"/>
    </xsl:variable>
    <form
     name="freebusyForm"
     method="post"
     action="{$fetchFreeBusy}"
     enctype="multipart/form-data"
     id="freebusyForm">
      <table id="bodyBlock" cellspacing="0">
        <tr>
          <td id="fbForm">
            <h4>aggregation</h4>
            <div id="dateForm">
              <p>
                Start date:<br/>
                <input
                 type="text"
                 name="startdt"
                 size="8"
                 value="{$startdt}" />
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
                 value="{$enddt}" />
                <span class="calWidget">
                  <script language="JavaScript" type="text/javascript">
                    endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback','<xsl:value-of select="$resourcesRoot"/>/resources/');
                  </script>
                </span>
              </p>
              <div class="dateFormat">yyyymmdd</div>
              <p class="padTop">
                <input type="submit" value="aggregate" class="aggSubmit"/>
              </p>
            </div>
          </td>
          <td id="bodyContent">
            <xsl:choose>
              <xsl:when test="/bedework-fbaggregator/page='freeBusy'">
                <xsl:for-each select="/bedework-fbaggregator/freebusy">
                <!-- there's only one collection of freebusy; this for-each is
                     being used to pick out just the freebusy node and
                     shorten the select statements below. -->
                  <h2>Freebusy Aggregator</h2>
                  Day count: <xsl:value-of select="count(day)"/>
                  <table id="freeBusy">
                    <tr>
                      <th colspan="16" class="">
                        Freebusy for
                        <span class="who">
                          <xsl:choose>
                            <xsl:when test="who != ''">
                              <xsl:value-of select="who"/>
                            </xsl:when>
                            <xsl:otherwise>
                              all attendees
                            </xsl:otherwise>
                          </xsl:choose>
                        </span>
                      </th>
                      <th colspan="16">
                        <xsl:value-of select="$startDate"/> to <xsl:value-of select="$endDate"/>
                      </th>
                      <th colspan="16">
                        America/New_York <span class="subLink">[<a href="{$getTimeZones}">change</a>]</span>
                        <!--<form name="timezones" action="setTimeZone" method="post">
                          <select name="timezone">
                          <xsl:for-each select="/bedework-fbaggregator/timezones/tzid">
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                              <xsl:value-of select="."/>
                            </option>
                          </xsl:for-each>
                        </select>
                        <input type="submit" value="change"/>
                          <span class="tzLink">[<a href="{$getTimeZones}">map</a>]</span>
                        </form>-->
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
                              <xsl:call-template name="timeFormatter">
                                <xsl:with-param name="timeString" select="start"/>
                                <xsl:with-param name="showMinutes">no</xsl:with-param>
                                <xsl:with-param name="showAmPm">no</xsl:with-param>
                              </xsl:call-template>
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
                        <td class="dayDate"><xsl:value-of select="number(substring(dateString,5,2))"/>-<xsl:value-of select="number(substring(dateString,7,2))"/></td>
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
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <!-- just show the default message -->
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
                  <p>To begin, <a href="{$manageAttendees}">add attendees</a>,
                  <!--<a href="javascript:document.freebusyForm.startdt.select();">-->
                  enter a date range<!--</a>--> on the left and click "aggregate".</p>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td rowspan="2" id="logos">
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
        <tr>
          <td id="userCell" colspan="2">
            <h4>attendees <span class="subLink">[<a href="{$manageAttendees}">manage</a>]</span></h4>
            <p>
              Aggregate for
              <input type="radio" name="all" value="true" checked="checked"/>all attendees
              <input type="radio" name="all" value="false"/>selected attendees
            </p>
             <table id="users">
               <xsl:for-each select="/bedework-fbaggregator/users/user">
                 <xsl:variable name="account" select="account"/>
                 <xsl:variable name="accountClass">
                     <xsl:choose>
                       <xsl:when test="/bedework-fbaggregator/freebusy/who=$account">selected</xsl:when>
                       <xsl:otherwise>none</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <tr>
                    <td>
                      <input type="checkbox" checked="checked" value="{$account}" name="account"/>
                    </td>
                    <td>
                      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="user"/>
                    </td>
                    <td>
                      <a href="{$fetchFreeBusy}&amp;account={$account}&amp;startdt={$startdt}&amp;enddt={$enddt}" title="display {$account}'s freebusy" class="{$accountClass}">
                        <xsl:value-of select="account"/>
                      </a>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                        <!--<a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user" title="remove">-->
                          <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                        <!--</a>-->
                    </td>
                  </tr>
                </xsl:for-each>
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
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="timezones">
    <div id="content">
      <h2>Select Timezone</h2>
      <form name="timezoneForm" action="setTimeZone" method="post">
        <select name="timezone">
          <xsl:for-each select="tzid">
            <option>
              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
              <xsl:value-of select="."/>
            </option>
          </xsl:for-each>
        </select>
        <input type="submit" value="select"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="manageAttendees">
    <div id="content">
      <h2>Manage Attendees</h2>
      <form action="{$addUser}" method="post">
        <fieldset id="modUser">
          <legend>Add user/group:</legend>
          <table>
            <tr>
              <th>Attendee's account:</th>
              <td>
                <input
                 type="text"
                 name="account"
                 size="40"
                 value="" />
                 <xsl:text> </xsl:text>
                 <em>e.g. attendee@somehost.org</em>
               </td>
             </tr>
             <tr>
              <th></th>
              <td>
                 <input type="radio" value="user" name="kind" checked="checked"/>user <!--
              --><input type="radio" value="group" name="kind"/>group
              </td>
            </tr>
            <tr>
              <th>Authorized user:</th>
              <td><input
                 type="text"
                 name="authUser"
                 size="40"
                 value="" />
                 <xsl:text> </xsl:text>
                 <em>user requesting freebusy data</em>
               </td>
            </tr>
            <tr>
              <th>Authorized user's password:</th>
              <td>
                <input
                 type="text"
                 name="authPw"
                 size="40"
                 value="" /></td>
            </tr>
            <tr>
              <th>Host:</th>
              <td>
                <input
                 type="text"
                 name="host"
                 size="60"
                 value="" /></td>
            </tr>
            <tr>
              <th>Port:</th>
              <td>
                <input
                 type="text"
                 name="port"
                 size="8"
                 value="" /></td>
            </tr>
            <tr>
              <th>Secure:</th>
              <td>
                <input
                 type="radio"
                 name="secure"
                 value="true" />yes
                <input
                 type="radio"
                 name="secure"
                 value="false"
                 checked="checked"/>no
               </td>
            </tr>
            <tr>
              <th>URL:</th>
              <td>
                <input
                 type="text"
                 name="url"
                 size="60"
                 value="" /></td>
            </tr>
            <tr>
              <th></th>
              <td>
                <input type="submit" value="add"/>
                <input type="submit" value="cancel"/>
              </td>
            </tr>
          </table>
        </fieldset>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="utilBar">
    <!-- refresh button -->
    <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
  </xsl:template>

  <!--==== UTILITY TEMPLATES ====-->

  <!-- time formatter (should be extended over time) -->
  <xsl:template name="timeFormatter">
    <xsl:param name="timeString"/><!-- required -->
    <xsl:param name="showMinutes">yes</xsl:param>
    <xsl:param name="showAmPm">yes</xsl:param>
    <xsl:param name="hour24">no</xsl:param>
    <xsl:variable name="hour" select="number(substring($timeString,1,2))"/>
    <xsl:variable name="minutes" select="substring($timeString,3,2)"/>
    <xsl:variable name="AmPm">
      <xsl:choose>
        <xsl:when test="$hour &lt; 13">AM</xsl:when>
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
