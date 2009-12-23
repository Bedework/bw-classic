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
        To view the interactive calendar, please enable
        Javascript on your browser.
      </p>
    </div>
  </xsl:template>

  <!--============= Display Side Bar ======-->
  <xsl:template name="displaySideBar">
    <div class="sideBarContainer">
      <h4>FILTER ON CALENDARS:</h4>
      <ul class="sideLinks">
        <li>
          <a href="{$fetchPublicCalendars}">
            View All Calendars
          </a>
        </li>
      </ul>
      <xsl:call-template name="leftColumnText"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
