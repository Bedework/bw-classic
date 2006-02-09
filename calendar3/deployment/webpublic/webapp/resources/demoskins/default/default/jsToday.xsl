<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- usage: call the javascript feed from an html file by embedding the
       following script tag:
       <script src="http://yourservername/cal/setView.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

       e.g.
       <script src="http://localhost:8080/cal/setView.do?viewType=todayView&skinName=jsToday&contentType=text/javascript&contentName=bedework.js" type="text/javascript"></script>

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
    <xsl:variable name="strippedSummary" select='translate(translate(summary,"&apos;","&#180;"),"&#xA;"," ")'/>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;li&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('    &lt;a href="</xsl:text><xsl:value-of select="$urlprefix"/><xsl:text disable-output-escaping="yes">/eventView.do?subid=</xsl:text><xsl:value-of select="subscription/id"/><xsl:text disable-output-escaping="yes">&amp;guid=</xsl:text><xsl:value-of select="guid"/><xsl:text disable-output-escaping="yes">&amp;recurrenceId=</xsl:text><xsl:value-of select="recurrenceId"/><xsl:text disable-output-escaping="yes">&amp;skinName=default" target="_top"&gt;</xsl:text><xsl:value-of select="$strippedSummary" disable-output-escaping="yes"/><xsl:text disable-output-escaping="yes">&lt;/a&gt;');</xsl:text>
    <xsl:text disable-output-escaping="yes">document.writeln('&lt;/li&gt;');</xsl:text>
  </xsl:template>
</xsl:stylesheet>
