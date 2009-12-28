<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- View List -->
  <xsl:template name="viewList">
    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-LCol-CalendarViews"/></h3>
    </div>
    <ul class="viewList">
      <xsl:for-each select="/bedework/views/view">
        <xsl:variable name="viewName" select="name/text()"/>
        <li>
          <a href="{$setSelection}&amp;viewName={$viewName}">
            <xsl:if test="$viewName = (/bedework/selectionState/view/name)">
              <xsl:attribute name="class">current</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$viewName"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>
