<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output
    method="xml"
    omit-xml-declaration="no"
    indent="yes"
    doctype-public="'-//Netscape Communications//DTD RSS 0.91//EN' 'http://my.netscape.com/public/formats/rss-0.91.dtd'"
    media-type="text/xml"
    encoding="ISO-8859-1"
   />
   <!-- =========================================================

                      BEDEWORK RSS FEED (deprecated)

     Deprecated: use rss-list.xsl instead.

     This is an older file used to pull a list of events from the
     day, week, or month views and was originally used to
     produce "Today's Events".  rss-list.xsl takes timezones into
     account.  This file does not.
     .
     Call the feed with the listEvents action like so:
     http://localhost:8080/main/setViewPeriod.do?viewType=todayView&setappvar=summaryMode(details)&skinName=rss

     ===============================================================  -->
<!-- **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

   <xsl:template match="/">
     <rss version="2.0">
      <channel>
        <title>Bedework Events Calendar</title>
        <link><xsl:value-of select="/bedework/urlprefix"/></link>
        <description>My Site's Events</description>
        <language>en-US</language>
        <copyright>Copyright <xsl:value-of select="substring(/bedework/currentdate,1,4)"/>, Your Institution Here</copyright>
        <managingEditor>editor@mysite.edu, Editor Name</managingEditor>
        <xsl:apply-templates select="/bedework/eventscalendar//event"/>
      </channel>
    </rss>
  </xsl:template>
  <xsl:template match="event">
    <item>
      <title><xsl:value-of select="summary"/> - <xsl:value-of select="substring(start/monthname,1,3)"/><xsl:text> </xsl:text><xsl:value-of select="start/day"/></title>
      <link><xsl:value-of select="/bedework/urlprefix"/>/eventView.do?calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></link>
      <pubDate><xsl:value-of select="substring(start/dayname,1,3)"/>,
               <xsl:value-of select="start/twodigitday"/><xsl:text> </xsl:text>
               <xsl:value-of select="substring(start/monthname,1,3)"/><xsl:text> </xsl:text>
               <xsl:value-of select="start/fourdigityear"/><xsl:text> </xsl:text>
               <xsl:value-of select="start/twodigithour24"/>:<xsl:value-of select="start/twodigitminute"/>:00 EST</pubDate>
      <description>
        <xsl:value-of select="substring(start/dayname,1,3)"/>,
        <xsl:value-of select="start/longdate"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="start/time"/>
        <xsl:if test="end/time != ''"> - </xsl:if>
        <xsl:if test="end/dayname != start/dayname"><xsl:value-of select="substring(end/dayname,1,3)"/>, </xsl:if>
        <xsl:if test="end/longdate != start/longdate"><xsl:value-of select="end/longdate"/>,</xsl:if>
        <xsl:if test="end/time != ''"><xsl:value-of select="end/time"/></xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="location/address"/>.
        <xsl:if test="cost!=''"><xsl:value-of select="cost"/>. </xsl:if>
        <xsl:value-of select="description"/>
      </description>
    </item>
  </xsl:template>
</xsl:stylesheet>
