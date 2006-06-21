<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="text"
  indent="no"
  media-type="text/x-vCalendar"
  standalone="yes"
/>

<xsl:strip-space elements="*"/>
<!-- ================= -->
<!--  vCAL STYLESHEET  -->
<!-- ================= -->
<xsl:template match="/"><xsl:value-of select="/bedework/vcalendar"/></xsl:template>
</xsl:stylesheet>
