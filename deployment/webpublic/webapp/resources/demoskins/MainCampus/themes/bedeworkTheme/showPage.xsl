<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- branch to an arbitrary page using the
       "appvar" session variable on a link like so:
       /misc/showPage.rdo?setappvar=page(mypage) -->

  <xsl:template name="showPage">
    <xsl:param name="page"/>
    <!-- branch here by adding xsl:when statements -->
    <xsl:choose>
      <xsl:when test="$page = 'urlbuilder'">
        <xsl:call-template name="urlbuilder"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="urlbuilder">
    <!-- call the urlbuilder by its globally defined prefix -->
    <iframe id="feedBuilder" src="{$urlbuilder}">
    </iframe>
  </xsl:template>

</xsl:stylesheet>
