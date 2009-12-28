<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="leftColumn">
    <div class="left_column">
      <xsl:call-template name="jsDateSelectionCal" />
      <div class="clear">&#160;</div>
      <xsl:call-template name="viewList" />
      <xsl:call-template name="displaySideBar" />
      <xsl:call-template name="groupsList" />
    </div>
  </xsl:template>

  <!-- Date Selection Calendar (javascript widget) -->
  <xsl:template name="jsDateSelectionCal">
    <div id="jsNavCal" class="calContainer">
      <xsl:call-template name="dateSelectForm" />
      <p>
        <xsl:copy-of select="$bwStr-LCol-JsMessage"/>
      </p>
    </div>
  </xsl:template>

  <!--============= Display Side Bar ======-->
  <xsl:template name="displaySideBar">
    <div class="sideBarContainer">
      <h4><xsl:copy-of select="$bwStr-LCol-FilterOnCalendars"/></h4>
      <ul class="sideLinks">
        <li>
          <a href="{$fetchPublicCalendars}">
            <xsl:copy-of select="$bwStr-LCol-ViewAllCalendars"/>
          </a>
        </li>
      </ul>
      <xsl:call-template name="leftColumnText"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
