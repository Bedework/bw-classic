<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id='org.bedework.message.cancelled'">
        Action cancelled
      </xsl:when>
      <xsl:when test="id='org.bedework.pubevents.message.event.updated'">
        Event updated
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.sponsor.updated'">
        Contact updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.added'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 contact added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> contacts added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.deleted'">
        Contact deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.referenced'">
        Contact is referenced
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.alreadyexists'">
        Contact already exists
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.location.updated'">
        Location updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.locations.added'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.location.deleted'">
        Location deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.location.referenced'">
        Location is referenced
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.prefs.updated'">
        User preferences updated
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
