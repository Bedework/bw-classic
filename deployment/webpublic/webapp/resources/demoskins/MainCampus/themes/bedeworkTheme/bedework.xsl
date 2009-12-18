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
    starting point for development of a customized theme.

    It is based on work by Duke University and Yale University with
    credit also to the University of Chicago.

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
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- theme utility functions -->
  <xsl:include href="themeUtil.xsl" />

  <!-- Page subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="header.xsl" />
  <xsl:include href="leftColumn.xsl" />
  <xsl:include href="views.xsl" />
  <xsl:include href="featuredEvents.xsl"/>
  <xsl:include href="navigation.xsl" />
  <xsl:include href="eventList.xsl" />
  <xsl:include href="event.xsl" />
  <xsl:include href="year.xsl" />
  <xsl:include href="calendarList.xsl" />
  <xsl:include href="search.xsl"/>
  <xsl:include href="ongoing.xsl" />
  <xsl:include href="groups.xsl"/>
  <xsl:include href="systemStats.xsl"/>
  <xsl:include href="footer.xsl" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <xsl:call-template name="head"/>
      <body>
        <div id="wrap">
          <!-- HEADER BAR and TABS -->
          <div id="header">
            <xsl:call-template name="titleBar" />
            <xsl:call-template name="tabs" />
          </div>
          <!-- ERROR MESSAGES -->
          <xsl:if test="/bedework/error">
            <div id="errors">
              <xsl:apply-templates select="/bedework/error" />
            </div>
          </xsl:if>

          <div id="content">
            <div id="contentSection">

              <!-- LEFT COLUMN: calendar widget, views, and links -->
              <xsl:call-template name="leftColumn" />

              <!-- FEATURED EVENTS, if enabled -->
              <xsl:if test="$featuredEventsEnabled = 'true'">
                <xsl:call-template name="featuredEvents"/>
              </xsl:if>

              <!-- MAIN CONTENT: event listings, single events, calendar lists, search results -->
              <div id="center_column">
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="$ongoingEvents = 'true'">center_column</xsl:when>
                    <xsl:otherwise>double_center_column</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>


                <!-- branch on content, as defined by /bedework/page -->
                <xsl:choose>
                  <!-- day, week, month, year event listings -->
                  <xsl:when test="/bedework/page='eventscalendar'">
                    <div class="secondaryColHeader">
                      <xsl:call-template name="navigation" />
                    </div>
                    <xsl:choose>
                      <xsl:when test="/bedework/periodname = 'Year'">
                        <xsl:call-template name="yearView" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="eventList"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>

                  <!-- single event display -->
                  <xsl:when test="/bedework/page = 'event'">
                    <xsl:apply-templates select="/bedework/event" mode="singleEvent"/>
                  </xsl:when>

                  <!-- list of calendar suite's subscriptions -->
                  <xsl:when test="/bedework/page='calendarList'">
                    <xsl:apply-templates select="/bedework/calendars" />
                  </xsl:when>

                  <!-- export calendar form -->
                  <xsl:when test="/bedework/page='displayCalendarForExport'">
                    <xsl:apply-templates select="/bedework/currentCalendar" mode="export" />
                  </xsl:when>

                  <!-- search result -->
                  <xsl:when test="/bedework/page='searchResult'">
                    <xsl:call-template name="searchResult" />
                    <xsl:call-template name="advancedSearch" />
                  </xsl:when>

                  <!-- system statistics -->
                  <xsl:when test="/bedework/page='showSysStats'">
                    <xsl:call-template name="stats" />
                  </xsl:when>

                  <!-- show us what page was requested... -->
                  <xsl:otherwise>
                    <xsl:copy-of select="$bwStr-Error"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="/bedework/page" />
                  </xsl:otherwise>

                </xsl:choose>
              </div>
            </div>

            <!-- ONGOING EVENTS, if enabled -->
            <xsl:if test="$ongoingEvents = 'true'">
              <div class="right_column" id="right_column">
                <xsl:call-template name="ongoingEventList" />
              </div>
            </xsl:if>

            <div class="clear">&#160;</div>
          </div>
          <!-- FOOTER -->
          <xsl:call-template name="footer" />
        </div>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
