<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="error">
    <xsl:choose>
      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
          An exception occurred:<br/>
          <em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nosuchevent'">
          Event does not exist:<br/><em><xsl:value-of select="param"/></em>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.baddate'">
          The date you have entered is out of range.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.noaccess'">
          You have insufficient access to make that request
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.missingsubscriptionid'">
          The request cannot be processed: missing subscription ID.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unknowncalendar'">
          Unknown calendar
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.unknownview'">
          Unknown view
      </xsl:when>
      <xsl:when test="id='org.bedework.client.error.nodefaultview'">
          No default view
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/>
        <xsl:if test="param">
            = <xsl:value-of select="param"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

