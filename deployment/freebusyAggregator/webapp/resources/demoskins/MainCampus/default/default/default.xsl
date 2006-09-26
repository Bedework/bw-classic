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
  <xsl:variable name="showManageGroup" select="/bedework-fbaggregator/urlPrefixes/showManageGroup"/>
  <xsl:variable name="updateGroup" select="/bedework-fbaggregator/urlPrefixes/updateGroup"/>
  <xsl:variable name="selectUsers" select="/bedework-fbaggregator/urlPrefixes/selectUsers"/>
  <xsl:variable name="showAddUser" select="/bedework-fbaggregator/urlPrefixes/showAddUser"/>
  <xsl:variable name="getUser" select="/bedework-fbaggregator/urlPrefixes/getUser"/>
  <xsl:variable name="editUser" select="/bedework-fbaggregator/urlPrefixes/editUser"/>
  <xsl:variable name="addUser" select="/bedework-fbaggregator/urlPrefixes/addUser"/>
  <xsl:variable name="initInvitation" select="/bedework-fbaggregator/urlPrefixes/initInvitation"/>
  <xsl:variable name="makeMeeting" select="/bedework-fbaggregator/urlPrefixes/makeMeeting"/>

  <!-- URL of the web application - includes web context
  <xsl:variable name="urlPrefix" select="/bedework-fbaggregator/urlprefix"/> -->

  <!-- Other generally useful global variables-->
  <xsl:variable name="currentTimezone">America/New_York</xsl:variable><!-- for now just set it -->
  <!--<xsl:variable name="prevdate" select="/bedework-fbaggregator/previousdate"/>
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
          }
          ]]>
          </xsl:comment>
        </script>
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
        <xsl:choose>
          <xsl:when test="/bedework-fbaggregator/page='manageGroup'">
            <xsl:call-template name="manageGroup"/>
          </xsl:when>
          <xsl:when test="/bedework-fbaggregator/page='addUser'">
            <xsl:call-template name="addUser"/>
          </xsl:when>
          <xsl:when test="/bedework-fbaggregator/page='editUser'">
            <xsl:call-template name="editUser"/>
          </xsl:when>
          <xsl:when test="/bedework-fbaggregator/page='invitation'">
            <xsl:call-template name="invitation"/>
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
      <a href="{$setup}&amp;refreshXslt=yes">Display Freebusy</a> |
      <a href="{$showAddUser}&amp;refreshXslt=yes">Register User</a>
    </div>
  </xsl:template>

  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template name="freebusy">
    <xsl:variable name="startdt" select="/bedework-fbaggregator/startDate"/>
    <xsl:variable name="enddt" select="/bedework-fbaggregator/endDate"/>
    <xsl:variable name="formattedStartDate">
      <xsl:value-of select="substring($startdt,1,4)"/>-<xsl:value-of select="number(substring($startdt,5,2))"/>-<xsl:value-of select="number(substring($startdt,7,2))"/>
    </xsl:variable>
    <xsl:variable name="formattedEndDate">
      <xsl:value-of select="substring($enddt,1,4)"/>-<xsl:value-of select="number(substring($enddt,5,2))"/>-<xsl:value-of select="number(substring($enddt,7,2))"/>
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
                 value="{$startdt}"
                 onfocus="enableFbSubmit('start')"/>
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
                 value="{$enddt}"
                 onfocus="enableFbSubmit('end')"/>
                <span class="calWidget">
                  <script language="JavaScript" type="text/javascript">
                    endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', 'endDateCalWidgetCallback','<xsl:value-of select="$resourcesRoot"/>/resources/');
                  </script>
                </span>
              </p>
              <div class="dateFormat">yyyymmdd</div>
              <p class="padTop">
                <input type="submit" name="submitFb" value="aggregate" class="aggSubmit">
                  <xsl:if test="$startdt = '' and $enddt = ''">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
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
                  <xsl:if test="/bedework-fbaggregator/failures/failure">
                    <table id="failures" cellspacing="0">
                      <tr class="title">
                        <th colspan="3">request failures</th>
                      </tr>
                      <tr class="headers">
                        <th>account</th>
                        <th>host:port</th>
                        <th>code</th>
                      </tr>
                      <xsl:for-each select="/bedework-fbaggregator/failures/failure">
                        <tr>
                          <td>
                            <xsl:value-of select="account"/>
                          </td>
                          <td>
                            <xsl:value-of select="host"/>:<xsl:value-of select="port"/>
                            <xsl:if test="message">
                              <br/>message: <em><xsl:value-of select="message"/></em>
                            </xsl:if>
                          </td>
                          <td>
                            <xsl:choose>
                              <xsl:when test="noResponse = 'true'">
                                none
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="respCode"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </table>
                  </xsl:if>
                  <table id="freeBusy">
                    <tr>
                      <td></td>
                      <th colspan="16" class="left">
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
                      <th colspan="32" class="right">
                        <xsl:value-of select="$formattedStartDate"/> to <xsl:value-of select="$formattedEndDate"/>
                        <select name="timezone" id="timezonesDropDown" onchange="submit()">
                          <xsl:for-each select="/bedework-fbaggregator/timezones/tzid">
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                              <xsl:if test="node() = $currentTimezone"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                              <xsl:value-of select="."/>
                            </option>
                          </xsl:for-each>
                        </select>
                        <!--<input type="submit" value="change" id="timezonesButton"/>
                        <span class="subLink">[<a href="{$getTimeZones}">map</a>]</span>-->
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
                          <xsl:variable name="startDate"><xsl:value-of select="../dateString"/>T<xsl:value-of select="start"/>00</xsl:variable>
                          <xsl:variable name="meetingDuration" select="length"/>
                          <td>
                            <xsl:attribute name="class">
                              <xsl:choose>
                                <xsl:when test="fbtype = '0'">busy</xsl:when>
                                <xsl:when test="fbtype = '3'">tentative</xsl:when>
                                <xsl:otherwise>free</xsl:otherwise>
                              </xsl:choose>
                            </xsl:attribute>
                            <a href="{$initInvitation}&amp;meetingStartdt={$startDate}&amp;meetingDuration={$meetingDuration}">
                              <xsl:choose>
                                <xsl:when test="((numBusy &gt; 0) and (numBusy &lt; 9)) or ((numTentative &gt; 0) and (numTentative &lt; 9)) and (number(numBusy) + number(numTentative) &lt; 9)">
                                  <xsl:value-of select="number(numBusy) + number(numTentative)"/>
                                </xsl:when>
                                <xsl:otherwise>*</xsl:otherwise>
                              </xsl:choose>
                              <span class="eventTip">
                                <xsl:value-of select="$formattedStartDate"/><br/>
                                <strong>
                                  <xsl:call-template name="timeFormatter">
                                    <xsl:with-param name="timeString" select="$startTime"/>
                                  </xsl:call-template>
                                </strong>
                                <xsl:if test="numBusy &gt; 0">
                                  <br/><xsl:value-of select="numBusy"/> busy
                                </xsl:if>
                                <xsl:if test="numTentative &gt; 0">
                                  <br/><xsl:value-of select="numTentative"/> tentative
                                </xsl:if>
                                <xsl:if test="numBusy = 0 and numTentative = 0">
                                  <br/><em>all free</em>
                                </xsl:if>
                              </span>
                            </a>
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
                  <p>To begin, select or create a group of attendees,<br/>
                  enter a date range on the left and click "aggregate".</p>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td rowspan="2" id="logos">
            <h4>participants</h4>
            <a href="http://www.apple.com">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/appleIcal.png" width="100" height="88" alt="Apple" border="0"/>
            </a>
            <a href="http://www.bedework.org">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/bedework.png" width="100" height="88" alt="Bedework" border="0"/>
            </a>
            <a href="http://www.boeing.com/">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/boeing.png" width="100" height="67" alt="Boeing" border="0"/>
            </a>
            <a href="http://www.ibm.com">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/ibm.png" width="100" height="85" alt="IBM" border="0"/>
            </a>
            <a href="http://www.oracle.com">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/oracle.png" width="100" height="48" alt="Oracle" border="0"/>
            </a>
            <a href="http://www.osafoundation.org/">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/osaf.png" width="100" height="54" alt="OSAF" border="0"/>
            </a>
            <a href="http://www.egenconsulting.com/">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/pec.png" width="100" height="61" alt="PEC" border="0"/>
            </a>
            <a href="http://www.timebridge.com/">
              <img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/logos/timebridge.png" width="100" height="55" alt="Timebridge" border="0"/>
            </a>
            <!--<img src="http://www.rpi.edu/dept/cct/apps/bedeworkLuwak2/images/freebusy/fbagg-logos2.gif" width="100" height="403" alt="participant logos" usemap="#logoMap" border="0"/>
            <map name="logoMap">
              <area shape="rect" alt="Timebridge" coords="0,340,100,380" href="http://www.timebridge.com/"/>
              <area shape="rect" alt="OSAF" coords="0,260,100,302" href="http://www.osafoundation.org/"/>
              <area shape="rect" alt="Oracle" coords="0,187,100,225" href="http://www.oracle.com"/>
              <area shape="rect" alt="Boeing" coords="0,101,100,153" href="http://www.boeing.com/"/>
              <area shape="rect" alt="Bedework" coords="0,13,100,77" href="http://www.bedework.org/bedework/"/>
            </map>-->
          </td>
        </tr>
        <tr>
          <td id="groupCell" colspan="2">
            <input type="hidden" name="all" value="true" />
            <input type="hidden" name="account" value="" />
            <h4>
              current group
            </h4>
            <div id="groupMenu">
              <select name="selectGroup" action="" onchange="javascript:setGroup(this)">
                <option value="">select group...</option>
                <xsl:for-each select="/bedework-fbaggregator/groups/group">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                    <xsl:if test="/bedework-fbaggregator/currentGroup = node()">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                  </option>
                </xsl:for-each>
              </select>
              <ul>
                <li><a href="{$showManageGroup}">modify</a></li>
                <!--<li>duplicate</li>
                <li>create</li>-->
              </ul>
              <!--<p>
                Aggregate for
                <input type="radio" name="all" value="true" checked="checked"/>all attendees
                <input type="radio" name="all" value="false"/>selected attendees
              </p>-->
            </div>
            <xsl:choose>
              <xsl:when test="/bedework-fbaggregator/attendees/attendee">
                <table id="attendees">
                  <!--<tr>
                   <th>include</th>
                   <th>required</th>
                   <th>type</th>
                   <th>account</th>
                  </tr>-->
                  <xsl:for-each select="/bedework-fbaggregator/attendees/attendee">
                    <xsl:variable name="account" select="account"/>
                    <tr>
                      <!--<td>
                        <input type="checkbox" checked="checked" value="{$account}" name="account"/>
                      </td>
                      <td>
                        <input type="checkbox" checked="checked" value="required" name="required"/>
                      </td>-->
                      <td>
                        <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="attendee"/>
                      </td>
                      <td>
                        <!--<a href="{$fetchFreeBusy}&amp;account={$account}&amp;startdt={$startdt}&amp;enddt={$enddt}" title="display {$account}'s freebusy">-->
                        <a href="javascript:showAccountFreebusy('{$account}')" title="display {$account}'s freebusy">
                          <xsl:if test="/bedework-fbaggregator/freebusy/who=$account">
                            <xsl:attribute name="class">selected</xsl:attribute>
                          </xsl:if>
                          <xsl:value-of select="account"/>
                        </a>
                      </td>
                      <!--<td>
                        <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                      </td>-->
                    </tr>
                  </xsl:for-each>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <p id="attendees">no attendees</p>
              </xsl:otherwise>
            </xsl:choose>
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

  <xsl:template name="manageGroup">
    <div id="content">
      <h2>Manage Group</h2>
      <table cellspacing="0" id="attendeeList">
        <tr class="title">
          <th colspan="6">
            Attendees for group: <em><xsl:value-of select="/bedework-fbaggregator/currentGroup"/></em>
          </th>
          <td>
            <a href="">delete group</a>
          </td>
        </tr>
        <tr class="headers">
          <th>account</th>
          <th>type</th>
          <th>host</th>
          <th>port</th>
          <th>secure</th>
          <th>url</th>
          <th></th>
        </tr>
        <xsl:for-each select="/bedework-fbaggregator/attendees/attendee">
          <xsl:variable name="rowClass">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">a</xsl:when>
              <xsl:otherwise>b</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr class="{$rowClass}">
            <td class="first"><xsl:value-of select="account"/></td>
            <td>
              <xsl:variable name="account" select="account"/>
              <a href="{$getUser}&amp;account={$account}">
                <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="edit"/>
              </a>
              <xsl:text> </xsl:text>
              <xsl:value-of select="type"/>
            </td>
            <td><xsl:value-of select="host"/></td>
            <td><xsl:value-of select="port"/></td>
            <td><xsl:value-of select="secure"/></td>
            <td><xsl:value-of select="url"/></td>
            <td class="last"><img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/></td>
          </tr>
        </xsl:for-each>
      </table>
      <table cellspacing="0" id="searchUsers">
        <tr>
          <th>Search users:</th>
          <th>Search results:</th>
        </tr>
        <tr>
          <td>
            <!--<form name="searchForm" onsubmit="doSearch(this,'{$selectUsers}')">-->
            <form name="searchForm" action="{$selectUsers}" method="post">
              <input type="text" name="term" size="40"/>
              <input type="submit" name="search" value="search"/><br/>
              <input type="radio" name="type" value="account" checked="checked"/>for account, <em>e.g. johndoe@somehost.org</em><br/>
              <input type="radio" name="type" value="prefix"/>by email prefix, <em>e.g. johndoe</em><br/>
              <input type="radio" name="type" value="suffix"/>by email suffix, <em>e.g. somehost.org</em><br/>
            </form>
          </td>
          <td>
            <xsl:if test="not(/bedework-fbaggregator/selectedUsers/user)">
              To add attendees to this group, perform a search and click
              "add search results to current group".  (Individual additions
              to be added later.)
            </xsl:if>
            <ul>
              <xsl:for-each select="/bedework-fbaggregator/selectedUsers/user">
                <li>
                  <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">b</xsl:attribute></xsl:if>
                  <strong><xsl:value-of select="account"/></strong><br/>
                  <xsl:choose>
                    <xsl:when test="secure='true'">https:</xsl:when>
                    <xsl:otherwise>http:</xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="host"/>:<xsl:value-of select="port"/>
                  <xsl:value-of select="url"/>
                </li>
              </xsl:for-each>
            </ul>
            <p>
              <xsl:if test="/bedework-fbaggregator/selectedUsers/user">
                <strong><a href="{$updateGroup}&amp;addSelected=true">Add search results to current group</a></strong>
              </xsl:if>
            </p>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="addUser">
    <div id="content">
      <h2>Register a New User</h2>
      <form action="{$addUser}" method="post">
        <fieldset id="commonForm">
          <legend>Add user:</legend>
          <table cellspacing="0">
            <tr>
              <th>User's account:</th>
              <td>
                <input
                 type="text"
                 name="account"
                 size="40"
                 value="" />
                 <xsl:text> </xsl:text>
                 <em>e.g. user@somehost.org</em>
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
                 <em>user requesting freebusy data (e.g. you)</em>
               </td>
            </tr>
            <tr>
              <th>Authorized user's password:</th>
              <td>
                <input
                 type="password"
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
              <th>Depth:</th>
              <td>
                <select name="depth">
                  <option value="0">0</option>
                  <option value="1">1</option>
                  <option value="infinity">infinity</option>
                </select>
              </td>
            </tr>
            <tr>
              <th></th>
              <td>
                <input type="submit" name="submit" value="add"/>
                <input type="submit" name="cancelled" value="cancel"/>
              </td>
            </tr>
          </table>
        </fieldset>
      </form>
    </div>
    <div id="getUserForm">
      <form action="{$getUser}" method="post">
        Modify existing user (enter account name):
        <input type="text" name="account" size="40"/>
        <input type="submit" value="get user"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="editUser">
    <div id="content">
      <h2>Modify User</h2>
      <form action="{$editUser}" method="post">
        <fieldset id="commonForm">
          <legend>User information:</legend>
          <table cellspacing="0">
            <tr>
              <th>User's account:</th>
              <td>
                <input
                 type="text"
                 name="account"
                 size="40">
                 <xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/user/account"/></xsl:attribute>
                </input>
                <xsl:text> </xsl:text>
                <em>e.g. user@somehost.org</em>
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
                 size="40">
                 <xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/user/authUser"/></xsl:attribute>
                 </input>
                 <xsl:text> </xsl:text>
                 <em>user requesting freebusy data (e.g. you)</em>
               </td>
            </tr>
            <tr>
              <th><strong>Authorized user's password:</strong></th>
              <td>
                <input
                 type="password"
                 name="authPw"
                 size="40"
                 value="" />
                 <xsl:text> </xsl:text>
                 <em>please re-enter</em>
              </td>
            </tr>
            <tr>
              <th>Host:</th>
              <td>
                <input
                 type="text"
                 name="host"
                 size="60">
                 <xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/user/host"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <th>Port:</th>
              <td>
                <input
                 type="text"
                 name="port"
                 size="8">
                <xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/user/port"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <th>Secure:</th>
              <td>
                <input
                 type="radio"
                 name="secure"
                 value="true">
                 <xsl:if test="/bedework-fbaggregator/user/secure = 'true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                 </xsl:if>
                </input>
                 yes
                <input
                 type="radio"
                 name="secure"
                 value="false">
                 <xsl:if test="/bedework-fbaggregator/user/secure = 'false'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                 </xsl:if>
                </input>
                 no
              </td>
            </tr>
            <tr>
              <th>URL:</th>
              <td>
                <input
                 type="text"
                 name="url"
                 size="60">
                <xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/user/url"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <th>Depth:</th>
              <td>
                <select name="depth">
                  <option value="0">
                    <xsl:if test="/bedework-fbaggregator/user/depth = '0'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    0
                  </option>
                  <option value="1">
                    <xsl:if test="/bedework-fbaggregator/user/depth = '1'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    1
                  </option>
                  <option value="infinity">
                    <xsl:if test="/bedework-fbaggregator/user/depth = 'infinity'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    infinity
                  </option>
                </select>
              </td>
            </tr>
            <tr>
              <th></th>
              <td>
                <input type="submit" name="submit" value="update"/>
                <input type="submit" name="cancelled" value="cancel"/>
              </td>
            </tr>
          </table>
        </fieldset>
      </form>
    </div>
    <div id="getUserForm">
      <form action="{$getUser}" method="post">
        Modify existing user (enter account name):<br/>
        <input type="text" name="account" size="40"/>
        <input type="submit" value="get user"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="invitation">
    <div id="content">
      <h2>Send Meeting Invitation</h2>
      <form action="{$makeMeeting}" method="post">
        <input type="hidden" name="skinName" value="ical"/>
        <input type="hidden" name="nocache" value="no"/>
        <input type="hidden" name="contentType" value="text/calendar"/>
        <input type="hidden" name="contentName">
          <xsl:attribute name="value">meeting-<xsl:value-of select="/bedework-fbaggregator/meetingStart"/>.ics</xsl:attribute>
        </input>
        <!--<p>
          <input type="submit" value="send invitation" name="submit"/>
          <xsl:text> </xsl:text>
          <input type="submit" value="cancel" name="cancelled"/>
        </p>-->
        <fieldset id="commonForm">
          <legend>meeting information</legend>
          <table cellspacing="0">
            <tr>
              <th>Start date:</th>
              <td>
                <strong><xsl:value-of select="substring(/bedework-fbaggregator/meetingStart,1,4)"/>-<xsl:value-of select="substring(/bedework-fbaggregator/meetingStart,5,2)"/>-<xsl:value-of select="substring(/bedework-fbaggregator/meetingStart,7,2)"/></strong>
              </td>
            </tr>
            <tr>
              <th>Start time:</th>
              <td>
                <strong>
                  <xsl:call-template name="timeFormatter">
                    <xsl:with-param name="timeString" select="substring(/bedework-fbaggregator/meetingStart,10,4)"/>
                  </xsl:call-template>
                </strong>
              </td>
            </tr>
            <tr>
              <th class="padTop">Duration:</th>
              <td class="padTop">
                <input type="text" name="meetingDuration" size="3"><xsl:attribute name="value"><xsl:value-of select="/bedework-fbaggregator/meetingDuration"/></xsl:attribute></input> minutes
              </td>
            </tr>
            <tr>
              <th>Summary:</th>
              <td><input type="text" name="summary" size="90"/></td>
            </tr>
            <tr>
              <th>Description:</th>
              <td><textarea name="description" rows="6" cols="70"></textarea></td>
            </tr>
            <tr>
              <th>Location:</th>
              <td><input type="text" name="location" size="90"/></td>
            </tr>
            <tr>
              <th>URL:</th>
              <td><input type="text" name="url" size="90"/></td>
            </tr>
            <tr>
              <th></th>
              <td class="padTop">
                <input type="submit" value="send invitation" name="submit"/>
                <xsl:text> </xsl:text>
                <input type="submit" value="cancel" name="cancelled"/>
              </td>
            </tr>
          </table>
        </fieldset>
        <fieldset>
          <legend>attendees</legend>
          <xsl:choose>
            <xsl:when test="/bedework-fbaggregator/attendees/attendee">
              <table id="attendees">
                <xsl:for-each select="/bedework-fbaggregator/attendees/attendee">
                  <xsl:variable name="account" select="account"/>
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/resources/userIcon.gif" width="13" height="13" border="0" alt="attendee"/>
                    </td>
                    <td>
                      <xsl:if test="/bedework-fbaggregator/freebusy/who=$account">
                        <xsl:attribute name="class">selected</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="account"/>
                    </td>
                    <!--<td>
                      <img src="{$resourcesRoot}/resources/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
                    </td>-->
                  </tr>
                </xsl:for-each>
              </table>
            </xsl:when>
            <xsl:otherwise>
              <p id="attendees">no attendees</p>
            </xsl:otherwise>
          </xsl:choose>
        </fieldset>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="utilBar">
    <!-- refresh button -->
    <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
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
