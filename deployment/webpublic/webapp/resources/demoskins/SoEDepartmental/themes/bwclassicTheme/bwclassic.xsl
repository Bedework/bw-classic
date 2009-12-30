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
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- Page subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="header.xsl" />
  <xsl:include href="navigation.xsl" />
  <xsl:include href="eventGrids.xsl" />
  <xsl:include href="eventLists.xsl" />
  <xsl:include href="event.xsl" />
  <xsl:include href="calendarList.xsl" />
  <xsl:include href="search.xsl" />
  <xsl:include href="stats.xsl" />
  <xsl:include href="footer.xsl" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <xsl:call-template name="head"/>
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

</xsl:stylesheet>
