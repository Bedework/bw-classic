<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
          An exception occurred: <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.exc'">
          An exception occurred: <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchevent'">
          Event <xsl:value-of select="param"/> does not exist.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.baddates'">
          Improperly formatted date(s): <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
          You have insufficient access <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.notitle'">
          Please supply a title for your event (required).
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingcalendarid'">
          Missing event's calendar id (required).
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.referenced'">
          Location is in use.  It cannot be deleted while referenced by an event.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.mail.norecipient'">
          You must supply a recipient.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unknown.timezone'">
          Unknown timezone <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

