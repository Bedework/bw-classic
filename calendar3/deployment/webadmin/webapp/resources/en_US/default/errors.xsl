<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='org.bedework.error.event.startafterend'">
        The end date for this event occurs before the start date
      </xsl:when>
      <xsl:when test="id='org.bedework.pubevents.error.badfield'">
        Please correct your data input for <em><xsl:value-of select="param"/></em>
      </xsl:when>

      <xsl:when test="id='org.bedework.client.error.nosuchsponsor'">
        Not found: there is no contact identified by that id.
      </xsl:when>

      <xsl:when test="id='org.bedework.client.error.nosuchlocation'">
        Not found: there is no location identified by that id.
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

