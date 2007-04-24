<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output
    method="xml"
    omit-xml-declaration="no"
    indent="yes"
    doctype-public="'-//Netscape Communications//DTD RSS 0.91//EN' 'http://my.netscape.com/public/formats/rss-0.91.dtd'"
    media-type="text/xml"
    encoding="UTF-8"
   />
   <xsl:template match="/">
     <rss version="2.0">
      <channel>
        <title>Bedework Events Calendar</title>
        <link><xsl:value-of select="/bedework/urlprefix"/></link>
        <description><xsl:choose>
          <xsl:when test="/bedework/firstday/longdate = /bedework/lastday/longdate"><xsl:value-of select="/bedework/firstday/longdate"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="/bedework/firstday/longdate"/> - <xsl:value-of select="/bedework/lastday/longdate"/></xsl:otherwise></xsl:choose></description>
        <pubDate><xsl:value-of select="substring(/bedework/eventscalendar/year/month/week/day[event]/event/start/dayname,1,3)"/>,<xsl:text> </xsl:text><!--
          --><xsl:value-of select="/bedework/eventscalendar/year/month/week/day[event]/event/start/twodigitday"/><xsl:text> </xsl:text><!--
          --><xsl:value-of select="substring(/bedework/eventscalendar/year/month/week/day[event]/event/start/monthname,1,3)"/><xsl:text> </xsl:text><!--
          --><xsl:value-of select="/bedework/eventscalendar/year/month/week/day[event]/event/start/fourdigityear"/><xsl:text> </xsl:text><!--
          --><xsl:value-of select="/bedework/eventscalendar/year/month/week/day[event]/event/start/twodigithour24"/>:<xsl:value-of select="/bedework/eventscalendar/year/month/week/day[event]/event/start/twodigitminute"/>:00 EST</pubDate>  
        <language>en-US</language>
        <copyright>Copyright <xsl:value-of select="substring(/bedework/currentdate/date,1,4)"/>, Rensselaer Polytechnic Institute</copyright>
        <managingEditor>editor@mysite.edu, Editor Name</managingEditor>
        <xsl:choose>
           <xsl:when test="/bedework/page='searchResult'">
             <xsl:apply-templates select="/bedework/searchResults/searchResult"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:apply-templates select="/bedework/eventscalendar//event"/>
           </xsl:otherwise>
        </xsl:choose>
      </channel>
    </rss>
  </xsl:template>
  <xsl:template match="event">
    <item>
      <title><xsl:if test="status = 'CANCELLED'">CANCELLED: </xsl:if><xsl:value-of select="summary"/> - <xsl:value-of select="substring(start/dayname,1,3)"/>, <xsl:value-of select="start/longdate"/></title>
      <link><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?subid=<xsl:value-of select="subscription/id"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></link>
      <pubDate><xsl:value-of select="substring(start/dayname,1,3)"/>,<xsl:text> </xsl:text><!--
               --><xsl:value-of select="start/twodigitday"/><xsl:text> </xsl:text><!--
               --><xsl:value-of select="substring(start/monthname,1,3)"/><xsl:text> </xsl:text><!--
               --><xsl:value-of select="start/fourdigityear"/><xsl:text> </xsl:text><!--
               --><xsl:value-of select="start/twodigithour24"/>:<xsl:value-of select="start/twodigitminute"/>:00 EST</pubDate>
      <description><!--
        --><xsl:value-of select="substring(start/dayname,1,3)"/>,<xsl:text> </xsl:text><!--
        --><xsl:value-of select="start/longdate"/><!--
        --><xsl:text> </xsl:text><!--
        --><xsl:value-of select="start/time"/><!--
        --><xsl:if test="end/time != ''"> - </xsl:if><!--
        --><xsl:if test="end/dayname != start/dayname"><xsl:value-of select="substring(end/dayname,1,3)"/>, </xsl:if><!--
        --><xsl:if test="end/longdate != start/longdate"><xsl:value-of select="end/longdate"/>, </xsl:if><!--
        --><xsl:if test="end/time != ''"><xsl:value-of select="end/time"/></xsl:if><!--
        --><xsl:text> </xsl:text><!--
        --><xsl:value-of select="location/address"/>.<!--
        --><xsl:text> </xsl:text><!--
        --><xsl:if test="cost!=''"><xsl:value-of select="cost"/>.</xsl:if><!--
        --><xsl:text> </xsl:text><!--
        --><xsl:value-of select="description"/><!--
        --><xsl:text> </xsl:text><xsl:if test="status = 'CANCELLED'">(CANCELLED)</xsl:if><!--
      --></description>
    </item>
  </xsl:template>
</xsl:stylesheet>
