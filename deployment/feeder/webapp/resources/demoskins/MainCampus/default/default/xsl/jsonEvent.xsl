<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="event">
    <!-- first, escape apostrophes -->
    <xsl:variable name="aposStrippedSummary">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="summary"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedDescription">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="description"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedLocAddress">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="location/address"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, strip line breaks -->
    <xsl:variable name="strippedSummary" select='translate($aposStrippedSummary,"&#xA;"," ")'/>
    <xsl:variable name="strippedDescription" select='translate($aposStrippedDescription,"&#xA;"," ")'/>
    <xsl:variable name="strippedLocAddress" select='translate($aposStrippedLocAddress,"&#xA;"," ")'/>
    <!-- finally, produce the JSON output -->
                  {
                    "summary" : "<xsl:value-of select="$strippedSummary"/>",
                    "subscriptionId" : "<xsl:value-of select="subscription/id"/>",
                    "calPath" : "<xsl:value-of select="calendar/encodedPath"/>",
                    "guid" : "<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>",
                    "recurrenceId" : "<xsl:value-of select="recurrenceId"/>",
                    "link" : "<xsl:value-of select='link'/>",
                    "eventlink" : "<xsl:value-of select="$urlPrefix"/><xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>",
                    "status" : "<xsl:value-of select='status'/>",
                    "start" : {
                      "allday" : "<xsl:value-of select='start/allday'/>",
                      "shortdate" : "<xsl:value-of select='start/shortdate'/>",
                      "longdate" : "<xsl:value-of select='start/longdate'/>",
                      "dayname" : "<xsl:value-of select='start/dayname'/>",
                      "time" : "<xsl:value-of select='start/time'/>",
                      "utcdate" : "<xsl:value-of select='start/utcdate'/>",
                      "datetime" : "<xsl:value-of select='start/unformatted'/>",
                      "timezone" : "<xsl:value-of select='start/timezone/id'/>"
                    },
                    "end" : {
                      "allday" : "<xsl:value-of select='end/allday'/>",
                      "shortdate" : "<xsl:value-of select='end/shortdate'/>",
                      "longdate" : "<xsl:value-of select='end/longdate'/>",
                      "dayname" : "<xsl:value-of select='end/dayname'/>",
                      "time" : "<xsl:value-of select='end/time'/>",
                      "utcdate" : "<xsl:value-of select='end/utcdate'/>",
                      "datetime" : "<xsl:value-of select='end/unformatted'/>",
                      "timezone" : "<xsl:value-of select='end/timezone/id'/>"
                    },
                    "location" : {
                      "address" : "<xsl:value-of select="$strippedLocAddress"/>",
                      "link" : "<xsl:value-of select='location/link'/>"
                    },
                    "calendar" : {
                      "name" : "<xsl:value-of select='calendar/name'/>",
                      "path" : "<xsl:value-of select='calendar/path'/>",
                      "encodedPath" : "<xsl:value-of select='calendar/encodedPath'/>"
                    },
                    "categories" : [
                      <xsl:for-each select='categories/category'>"<xsl:value-of select='value'/>"<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>
                    ],
                    "description" : "<xsl:value-of select='$strippedDescription'/>",
                    "cost" : "<xsl:value-of select='cost'/>",
                    "xproperties" : [
                      <xsl:for-each select="xproperties/node()[name() != '']">
                      {
                        "<xsl:value-of select='name()'/>" : {
                          "values" : {
                             <xsl:for-each select="values/node()[name() != '']">
                               "<xsl:value-of select='name()'/>" : "<xsl:call-template name="replace"><xsl:with-param name="string" select="."/><xsl:with-param name="pattern" select='"&apos;"'/><xsl:with-param name="replacement" select='"\&apos;"'/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if>
                             </xsl:for-each>
                          }
                        }
                      }<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>

                    ]
                 }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
