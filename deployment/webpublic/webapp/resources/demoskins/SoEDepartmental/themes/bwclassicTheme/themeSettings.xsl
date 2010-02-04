<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- URL of html resources (images, css, other html); by default this is
       set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot"/>/themes/bwclassicTheme</xsl:variable>
  
  <!-- Location of the urlbuilder application; this is set to the 
       default quickstart location. If you move it, you must change this
       value. -->
  <xsl:variable name="urlbuilder">http://localhost:9090/urlbuilder</xsl:variable>

</xsl:stylesheet>
