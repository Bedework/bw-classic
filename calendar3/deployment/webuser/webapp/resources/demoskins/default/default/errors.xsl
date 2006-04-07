<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
          <p>An exception occurred: <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.exc'">
          <p>An exception occurred: <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchevent'">
          <p>Event <xsl:value-of select="param"/> does not exist.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.baddates'">
          <p>Improperly formatted date(s): <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.event.startafterend'">
          <p>Please correct your dates: the end date/time is before the start date/time.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
          <p>You have insufficient access <xsl:value-of select="param"/>.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.validation.error.notitle'">
          <p>Please supply a title for your event (required).</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingcalendarid'">
          <p>Missing event's calendar id (required).</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.location.referenced'">
          <p>Location is in use.  It cannot be deleted while referenced by an event.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.mail.norecipient'">
          <p>You must supply a recipient.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unknown.timezone'">
          <p>Unknown timezone <em><xsl:value-of select="param"/></em></p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.subscription.reffed'">
          <p>Cannot remove: the subscription is referenced by View "<em><xsl:value-of select="param"/></em>"</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.exception.duplicatesubscription'">
          <p>A subscription by that name already exists.</p>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nodefaultview'">
          <p>No default view defined</p>
      </xsl:when>
      <xsl:otherwise>
        <p><xsl:value-of select="id"/> = <xsl:value-of select="param"/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

