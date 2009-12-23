<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- Display the Date and Provide Navigation -->
  <xsl:template name="navigation">
    <xsl:if test="/bedework/periodname != 'Year'">
      <ul id="calDisplayOptions">
        <li>
          <xsl:choose>
            <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
              <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                <xsl:copy-of select="$bwStr-SrcB-Summary"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$setup}&amp;setappvar=summaryMode(details)" title="toggle summary/detailed view">
                <xsl:copy-of select="$bwStr-SrcB-Details"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </ul>
      <a id="rssRequest" class="rss" href="/feeder/showMain.rdo?skinName=list-rss" title="RSS feed">
        <img src="{$resourcesRoot}/images/feed-icon-14x14.png" alt="RSS Feed Icon" />
      </a>
    </xsl:if>
    <a id="prevViewPeriod" href="{$setViewPeriod}&amp;date={$prevdate}">
      «
    </a>
    <h3>
      <xsl:choose>
        <xsl:when test="/bedework/periodname='Year'">
          <xsl:value-of
            select="substring(/bedework/firstday/date,1,4)" />
        </xsl:when>
        <xsl:when test="/bedework/periodname='Month'">
          <xsl:value-of select="/bedework/firstday/monthname" />
          ,
          <xsl:value-of
            select="substring(/bedework/firstday/date,1,4)" />
        </xsl:when>
        <xsl:when test="/bedework/periodname='Week'">
          Week of
          <xsl:value-of
            select="substring-after(/bedework/firstday/longdate,', ')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/bedework/firstday/longdate" />
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <a id="nextViewPeriod" href="{$setViewPeriod}&amp;date={$nextdate}">
      »
    </a>
  </xsl:template>

</xsl:stylesheet>