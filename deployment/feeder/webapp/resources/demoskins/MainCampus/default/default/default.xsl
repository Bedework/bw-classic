<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
  method="xml"
  indent="yes"
  omit-xml-declaration="no"
  media-type="text/xml"
  standalone="yes"
/>

<!-- =========================================================

              DEMONSTRATION CALENDAR STYLESHEET

     a simple stylesheet to provide a proper xml declaration
     and clean xml for use on other systems.  This is slightly
     more expensive than simply turning off the transform with
     noxslt=yes, but it may play better with some systems.

===============================================================  -->

  <xsl:template match="/">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>