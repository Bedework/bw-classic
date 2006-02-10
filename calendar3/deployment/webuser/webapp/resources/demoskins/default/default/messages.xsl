<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.message.cancelled'">
          Action cancelled.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 public event reference added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> public event references added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.subscriptions'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 subscription added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> subscriptions added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event deleted.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events deleted.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event removed.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events removed.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location removed.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations removed.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.subscriptions'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 subscription removed.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> subscriptions removed.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.nosuchevent'">
          Event <xsl:value-of select="param"/> does not exist.
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

