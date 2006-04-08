<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.message.cancelled'">
          <p>Action cancelled.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.locations.added'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 location added.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> locations added.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 event added.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> events added.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 public event reference added.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> public event references added.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.subscriptions'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 subscription added.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> subscriptions added.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.subscription.removed'">
        <p>Subscription removed.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 event deleted.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> events deleted.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 event removed.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> events removed.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 location removed.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> locations removed.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.subscriptions'">
        <xsl:choose>
          <xsl:when test="param='1'">
            <p>1 subscription removed.</p>
          </xsl:when>
          <xsl:otherwise>
            <p><xsl:value-of select="param"/> subscriptions removed.</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.nosuchevent'">
          <p>Event <em><xsl:value-of select="param"/></em> does not exist.</p>
      </xsl:when>
      <xsl:otherwise>
        <p><xsl:value-of select="id"/> = <xsl:value-of select="param"/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

