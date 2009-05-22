<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- Javascript feed of the day's events,
       Bedework v3.0, Arlen Johnson

       Usage: call the javascript feed from an html file by embedding the
       following script tag:
       <script src="http://yourservername/cal/setViewPeriod.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

       e.g.
       <script src="http://localhost:8080/cal/setViewPeriod.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

       You should uncomment the code below that reads "Today's Events" and throw
       away the following line.  You should modify this stylesheet if you intend
       to display more than a single day's events.
  -->

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

  <xsl:variable name="urlprefix" select="/bedework/urlprefix"/>
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;h3&gt;');</xsl:text>
      <!--<xsl:text disable-output-escaping="yes">document.writeln("Today's Events");</xsl:text>-->
      <xsl:text disable-output-escaping="yes">document.writeln("Current Events");</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;/h3&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;ul class="eventFeed"&gt;');</xsl:text>
    <xsl:choose>
      <xsl:when test="/bedework/events/event">
        <xsl:apply-templates select="/bedework/events/event"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes">document.writeln('&lt;li&gt;');</xsl:text>
        <xsl:text disable-output-escaping="yes">document.writeln('There are no events posted today');</xsl:text>
        <xsl:text disable-output-escaping="yes">document.writeln('&lt;/li&gt;');</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;/ul&gt;');</xsl:text>
  </xsl:template>
  <xsl:template match="event">
    <!-- first, escape apostrophes -->
    <xsl:variable name="aposStrippedSummary">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="summary"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, strip line breaks -->
    <xsl:variable name="strippedSummary" select='translate($aposStrippedSummary,"&#xA;"," ")'/>
    <!-- finally, produce the javascript -->
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;li&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('    &lt;a href="</xsl:text><xsl:value-of select="$urlprefix"/><xsl:text disable-output-escaping="yes">/event/eventView.do?guid=</xsl:text><xsl:value-of select="guid"/><xsl:text disable-output-escaping="yes">&amp;recurrenceId=</xsl:text><xsl:value-of select="recurrenceId"/><xsl:text disable-output-escaping="yes">&amp;calPath=</xsl:text><xsl:value-of select="calendar/encodedPath"/><xsl:text disable-output-escaping="yes">&amp;skinName=default" target="_top"</xsl:text><xsl:if test="status = 'CANCELLED'"> class="cancelled" </xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:if test="status = 'CANCELLED'">CANCELED: </xsl:if><xsl:value-of select="$strippedSummary" disable-output-escaping="yes"/><xsl:text disable-output-escaping="yes">&lt;/a&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;/li&gt;');</xsl:text>
  </xsl:template>

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
