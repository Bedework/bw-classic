<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- usage: call the javascript feed from an html file by embedding the
       following script tag:
       <script src="http://yourservername/cal/setViewPeriod.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

       e.g.
       <script src="http://localhost:8080/cal/setViewPeriod.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

       You should uncomment the code below that reads "Today's Events" and throw
       away the following line.  You should modify this stylesheet if you intend
       to display more than a single day's events.
  -->
  <xsl:variable name="urlprefix" select="/bedework/urlprefix"/>
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;h3&gt;');</xsl:text>
      <!--<xsl:text disable-output-escaping="yes">document.writeln("Today's Events");</xsl:text>-->
      <xsl:text disable-output-escaping="yes">document.writeln("This Period's Events");</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;/h3&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;ul class="eventFeed"&gt;');</xsl:text>
    <xsl:choose>
      <xsl:when test="/bedework/eventscalendar/year/month/week/day/event">
        <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day/event"/>
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
    <!--<xsl:variable name="strippedSummary" select='translate(translate(summary,"&apos;",""),"&#xA;"," ")'/>-->
    <xsl:variable name="aposStrippedSummary">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="summary"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="strippedSummary" select='translate($aposStrippedSummary,"&#xA;"," ")'/>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;li&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('    &lt;a href="</xsl:text><xsl:value-of select="$urlprefix"/><xsl:text disable-output-escaping="yes">/eventView.do?subid=</xsl:text><xsl:value-of select="subscription/id"/><xsl:text disable-output-escaping="yes">&amp;guid=</xsl:text><xsl:value-of select="guid"/><xsl:text disable-output-escaping="yes">&amp;recurrenceId=</xsl:text><xsl:value-of select="recurrenceId"/><xsl:text disable-output-escaping="yes">&amp;calid=</xsl:text><xsl:value-of select="calendar/id"/><xsl:text disable-output-escaping="yes">&amp;skinName=default" target="_top"&gt;</xsl:text><xsl:value-of select="$strippedSummary" disable-output-escaping="yes"/><xsl:text disable-output-escaping="yes">&lt;/a&gt;');</xsl:text>
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
