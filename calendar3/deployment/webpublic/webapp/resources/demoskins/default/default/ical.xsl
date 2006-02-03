<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="text"
  indent="no"
  media-type="text/calendar"
  standalone="yes"
/>

<xsl:strip-space elements="*"/>
<!-- ================= -->
<!--  iCAL STYLESHEET  -->
<!-- ================= -->
<xsl:template match="/"><xsl:value-of select="/ucalendar/vcalendar"/></xsl:template>
</xsl:stylesheet>
