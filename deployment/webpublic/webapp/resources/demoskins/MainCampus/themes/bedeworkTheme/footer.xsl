<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="footer">
    <div id="footer">
      <xsl:if test="$showFootForm = 'true'">
        <div id="footForms">
          <form name="skinSelectForm" method="post"
            action="{$setup}">
            <input type="hidden" name="setappvar"
              value="summaryMode(details)" />
            <select name="skinPicker"
              onchange="window.location = this.value">
              <option
                value="{$setup}&amp;skinNameSticky=default">
                <xsl:copy-of
                  select="$bwStr-Foot-ExampleSkins" />
                :
              </option>
              <option value="{$setup}&amp;skinNameSticky=bwclassic">
                <xsl:copy-of select="$bwStr-Foot-BwClassic" />
              </option>
              <option
                value="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=rss-list&amp;days=3">
                <xsl:copy-of
                  select="$bwStr-Foot-RSSNext3Days" />
              </option>
              <option
                value="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=js-list&amp;days=3&amp;contentType=text/javascript&amp;contentName=bedework.js">
                <xsl:copy-of
                  select="$bwStr-Foot-JavascriptNext3Days" />
              </option>
              <option
                value="{$setViewPeriod}&amp;viewType=todayView&amp;skinName=jsToday&amp;contentType=text/javascript&amp;contentName=bedeworkToday.js">
                <xsl:copy-of
                  select="$bwStr-Foot-JavascriptTodaysEvents" />
              </option>
              <option
                value="{$setup}&amp;browserTypeSticky=PDA">
                <xsl:copy-of
                  select="$bwStr-Foot-ForMobileBrowsers" />
              </option>
              <option
                value="{$setViewPeriod}&amp;viewType=todayView&amp;skinName=videocal">
                <xsl:copy-of
                  select="$bwStr-Foot-VideoFeed" />
              </option>
              <option
                value="{$setup}&amp;skinNameSticky=default">
                <xsl:copy-of
                  select="$bwStr-Foot-ResetToCalendarDefault" />
              </option>
            </select>
          </form>
        </div>
      </xsl:if>
      <xsl:call-template name="footerText"/>
    </div>
  </xsl:template>

</xsl:stylesheet>