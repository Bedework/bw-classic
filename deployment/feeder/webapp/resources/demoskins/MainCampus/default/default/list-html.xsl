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

  <!-- URL of resources common to all bedework apps (javascript, images) -->
  <xsl:variable name="resourceCommons">../../../bedework-common</xsl:variable>

  <!-- DEFINE INCLUDES -->
  <!-- cannot use the resourceCommons variable in xsl:include paths -->
  <xsl:include href="../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/messages.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/util.xsl"/>
  <xsl:include href="./strings.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
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
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/blue.css"/>
        <link rel="stylesheet" href="../../../bedework-common/default/default/subColors.css"/>
        <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/default/default/print.css" />
        <!-- load javascript -->
        <xsl:if test="/bedework/page='event'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
          <script type="text/javascript" src="{$resourcesRoot}/resources/javascript/bedework.js">&#160;</script>
        </xsl:if>
        <!-- address bar icon -->
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
      </head>
      <body>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='eventList'">
            <!-- show a list of discrete events in a time period -->
            <xsl:apply-templates select="/bedework/events" mode="eventList"/>
          </xsl:when>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2 class="{$statusClass}">
      <a id="linkToEvent" href="javascript:showLink('{$urlPrefix}/event/eventView.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')" title="{$bwStr-SgEv-GenerateLinkToThisEvent}">
       <xsl:copy-of select="$bwStr-SgEv-LinkToThisEvent"/>
     </a>
      <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
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
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-When"/></td>
        <td class="fieldval">
          <!-- always display local time -->
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
              <span class="time"><em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
          <!-- if timezones are not local, or if floating add labels: -->
          <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
            <xsl:text> </xsl:text>
            --
            <strong>
              <xsl:choose>
                <xsl:when test="start/floating = 'true'">
                  <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="$bwStr-SgEv-LocalTime"/>
                </xsl:otherwise>
              </xsl:choose>
            </strong>
            <br/>
          </xsl:if>
          <!-- display in timezone if not local or floating time) -->
          <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
            <xsl:choose>
              <xsl:when test="start/timezone/id != end/timezone/id">
                <!-- need to display both timezones if they differ from start to end -->
                <table border="0" cellspacing="0" id="tztable">
                  <tr>
                    <td>
                      <strong><xsl:copy-of select="$bwStr-SgEv-Start"/></strong>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="start/timezone/islocal='true'">
                          <xsl:value-of select="start/dayname"/>,
                          <xsl:value-of select="start/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="start/timezone/dayname"/>,
                          <xsl:value-of select="start/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="start/timezone/id"/></strong>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <strong><xsl:copy-of select="$bwStr-SgEv-End"/></strong>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="end/timezone/islocal='true'">
                          <xsl:value-of select="end/dayname"/>,
                          <xsl:value-of select="end/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/timezone/dayname"/>,
                          <xsl:value-of select="end/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="end/timezone/id"/></strong>
                    </td>
                  </tr>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <!-- otherwise, timezones are the same: display as a single line  -->
                <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
                <xsl:if test="start/allday = 'false'">
                  <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                </xsl:if>
                <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                              ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
                <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                  <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/allday = 'true'">
                    <span class="time"><em> <xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/time != start/timezone/time">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
                --
                <strong><xsl:value-of select="start/timezone/id"/></strong>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </td>
        <th class="icalIcon" rowspan="2">
          <div id="eventIcons">
            <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-AddEventToMyCalendar}" target="myCalendar">
              <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
              <xsl:copy-of select="$bwStr-SgEv-AddToMyCalendar"/>
            </a>
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-DownloadEvent}">
              <img src="{$resourcesRoot}/images/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
             <xsl:copy-of select="$bwStr-SgEv-Download"/></a>
          </div>
        </th>
      </tr>
      <tr>
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Where"/></td>
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
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Description"/></td>
        <td colspan="2" class="fieldval description">
          <xsl:if test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
            <xsl:variable name="bwImage"><xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:variable>
            <img src="{$bwImage}" class="bwEventImage"/>
          </xsl:if>
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-STATUS"/></td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Cost"/></td>
          <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-See"/></td>
          <td colspan="2" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="contact/name!='none'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Contact"/></td>
          <td colspan="2" class="fieldval">
            <xsl:choose>
              <xsl:when test="contact/link=''">
                <xsl:value-of select="contact/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="contact/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="contact/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="contact/phone!=''">
              <br /><xsl:value-of select="contact/phone"/>
            </xsl:if>
            <!-- If you want to display email addresses, uncomment the
                 following 8 lines. -->
            <!-- <xsl:if test="contact/email!=''">
              <br />
              <xsl:variable name="email" select="contact/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}&amp;subject={$subject}">
                <xsl:value-of select="contact/email"/>
              </a>
            </xsl:if> -->
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="comments/comment">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Comments"/></td>
          <td class="fieldval comments">
            <xsl:for-each select="comments/comment">
              <p><xsl:value-of select="value"/></p>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-TopicalArea"/></td>
          <td class="fieldval">
            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
              <xsl:variable name="calUrl" select="values/text"/>
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="values/text"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
              <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="categories/category">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Categories"/></td>
          <td class="fieldval">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <!--  xsl:if test="calendar/path!=''">
        <tr>
          <td class="fieldname">Calendar:</td>
          <td class="fieldval">
            <xsl:variable name="calUrl" select="calendar/encodedPath"/>
            <a href="{$setSelection}&amp;calUrl={$calUrl}">
              <xsl:value-of select="calendar/name"/>
            </a>
          </td>
        </tr>
      </xsl:if-->
    </table>
  </xsl:template>

    <!--==== LIST EVENTS - for listing discrete events ====-->
  <xsl:template match="events" mode="eventList">
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
                      <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
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

</xsl:stylesheet>