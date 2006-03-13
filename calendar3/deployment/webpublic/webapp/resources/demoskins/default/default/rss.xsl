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
   <xsl:template match="/">
     <rss version="2.0">
      <channel>
        <title>Bedework Events Calendar</title>
        <link><xsl:value-of select="/bedework/urlprefix"/></link>
        <description>My Site's Events</description>
        <language>en-US</language>
        <copyright>Copyright <xsl:value-of select="substring(/bedework/currentdate,1,4)"/>, Your Institution Here</copyright>
        <managingEditor>editor@mysite.edu, Editor Name</managingEditor>
        <xsl:apply-templates select="/bedework//event"/>
      </channel>
    </rss>
  </xsl:template>
  <xsl:template match="event">
    <item>
      <title><xsl:value-of select="summary"/> - <xsl:value-of select="substring(start/monthname,1,3)"/><xsl:text> </xsl:text><xsl:value-of select="start/day"/></title>
      <link><xsl:value-of select="/bedework/urlprefix"/>/eventView.do?subid=<xsl:value-of select="subscription/id"/>&amp;calid=<xsl:value-of select="calendar/id"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></link>
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
