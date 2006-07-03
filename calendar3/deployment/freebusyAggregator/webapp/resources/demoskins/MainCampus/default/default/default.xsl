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

        <xsl:value-of select="$appRoot"/><br/>
        <xsl:value-of select="$resourcesRoot"/>

        <table id="bodyBlock" cellspacing="0">
          <tr>
            <td id="fbForm">
              <xsl:call-template name="fbForm"/>
            </td>
            <td id="bodyContent">
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
            <td id="logos">

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
  </xsl:template>

  <xsl:template name="fbForm">
    form here
  </xsl:template>

  <xsl:template name="utilBar">
    <!-- refresh button -->
    <a href="{$setup}"><img src="{$resourcesRoot}/resources/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a>
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
