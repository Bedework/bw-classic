<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="text"
  indent="no"
  media-type="text/calendar"
/>

<xsl:strip-space elements="*"/>
  <!-- ================= -->
  <!--  iCAL STYLESHEET  -->
  <!-- ================= -->

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <xsl:apply-templates select="/ucalendar/event"/>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
BEGIN:VCALENDAR
BEGIN:VEVENT
ORGANIZER:<xsl:value-of select="sponsor/name"/>
MAILTO:<xsl:value-of select="sponsor/email"/>
DTSTART:<xsl:value-of select="start/fourdigityear"/><xsl:value-of select="start/twodigitmonth"/><xsl:value-of select="start/twodigitday"/>T<xsl:value-of select="start/twodigithour24"/><xsl:value-of select="start/twodigitminute"/>00
DTEND:<xsl:value-of select="end/fourdigityear"/><xsl:value-of select="end/twodigitmonth"/><xsl:value-of select="end/twodigitday"/>T<xsl:choose><xsl:when test="start/time='' and end/time=''">235959</xsl:when><xsl:when test="(end/longdate = start/longdate) and (end/twodigithour24 &lt; start/twodigithour24)"><xsl:value-of select="start/twodigithour24"/><xsl:value-of select="end/twodigitminute"/>00</xsl:when><xsl:otherwise><xsl:value-of select="end/twodigithour24"/><xsl:value-of select="end/twodigitminute"/>00</xsl:otherwise></xsl:choose>
LOCATION:<xsl:value-of select="location/address"/>
TRANSP:OPAQUE
SEQUENCE:0
UID:<xsl:value-of select="startdate"/><xsl:value-of select="starttime"/>_<xsl:value-of select="id"/>@<xsl:value-of select="/ucalendar/urlprefix"/>
DESCRIPTION:<xsl:value-of select="normalize-space(description)"/><xsl:if test="cost!=''">\nCost: <xsl:value-of select="cost"/></xsl:if><xsl:if test="sponsor/name!=''">\nSponsor: <xsl:value-of select="sponsor/name"/></xsl:if><xsl:if test="sponsor/phone!=''">\nSponsor phone: <xsl:value-of select="sponsor/phone"/></xsl:if>\n
SUMMARY:<xsl:value-of select="summary"/>
PRIORITY:5
CLASS:PUBLIC
END:VEVENT
END:VCALENDAR

  </xsl:template>
</xsl:stylesheet>