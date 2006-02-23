<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.message.cancelled'">
        Action cancelled
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.event.deleted'">
        Event deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event deleted
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events delted
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.event.added'">
        Event added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.event.updated'">
        Event updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.calendar.deleted'">
        Calendar / folder deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.calendar.added'">
        Calendar / folder added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.calendar.updated'">
        Calendar / folder updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.deleted'">
        Contact deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.added'">
        Contact added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.sponsor.updated'">
        Contact updated
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
        Location added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location added
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations added
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.location.deleted'">
        Location deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location deleted
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations delted
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.location.referenced'">
        Location is referenced
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.category.deleted'">
        Category deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.category.added'">
        Cateogory added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.category.updated'">
        Category updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.subscription.removed'">
        Subscription removed
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.view.deleted'">
        View deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.syspars.updated'">
        System preferences updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.event.mailed'">
        Event has been mailed
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.eventalarmset'">
        Alarm has been set
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.authuser.removed'">
        Administrator removed
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.authuser.updated'">
        Administrator updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.admingroup.deleted'">
        Administrative group deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.timezones.imported'">
        Timezones successfully imported
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event reference added
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> event references added
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.admingroup.updated'">
        Administrative group updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.userinfo.updated'">
        User information updated
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
