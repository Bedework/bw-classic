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
      <xsl:variable name="rssCurrDate" select="/bedework/currentdate/date" />
      <xsl:variable name="rssGroups">
        <xsl:choose>
          <xsl:when test="(/bedework/appvar[key = 'group']/value) = 'all' or not(/bedework/appvar[key = 'group']/value)">
            <xsl:text>(all)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="rssCurrGroup"
              select="/bedework/appvar[key = 'group']/value" />
            <xsl:variable name="rssGroupTemplate">
              <xsl:text>(</xsl:text>
              <xsl:value-of select="$rssCurrGroup" />
              <xsl:text>)</xsl:text>
            </xsl:variable>
            <xsl:value-of select="$rssGroupTemplate" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rssCategory">
        <xsl:choose>
          <xsl:when
            test="(/bedework/appvar[key = 'category']/value = 'all') or not(/bedework/appvar[key = 'category']/value)">
            <xsl:text>all</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="rssCurrCategory"
              select="/bedework/appvar[key = 'category']/value" />
            <xsl:variable name="rssCatTemplate">
              <xsl:text />
              <xsl:value-of select="$rssCurrCategory" />
              <xsl:text />
            </xsl:variable>
            <xsl:value-of select="$rssCatTemplate" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rssViewType">
        <xsl:if test="(/bedework/periodname) = 'Day'">
          <xsl:text>dayView</xsl:text>
        </xsl:if>
        <xsl:if test="(/bedework/periodname) = 'Week'">
          <xsl:text>weekView</xsl:text>
        </xsl:if>
        <xsl:if test="(/bedework/periodname) = 'Month'">
          <xsl:text>monthView</xsl:text>
        </xsl:if>
      </xsl:variable>
      <a id="rssRequest" class="rss"
        href="/feed/calendar/{$rssViewType}/rss/{$rssGroups}/details/{$rssCategory}"
        title="RSS feed">
        <img src="{$resourcesRoot}/images/feed-icon-14x14.png"
          alt="RSS Feed Icon" />
      </a>
      <div id="rssPopUp" style="display:none;position:absolute">
      <!-- RSS Popup window -->
        <p id="rssClose"
          onclick="this.parentNode.style.display = 'none'">
          X - Close
        </p>
        <h5 style="padding: 6px;">RSS Feed Details</h5>
        <!-- setappvar=summaryMode(details){$rssGroups}skinName=rss{$rssCategory}viewType={$rssViewType} -->
        <ul style="padding: 6px;">
          <li style="border-bottom: solid 1px #CCC;">
            Time Period: Current
            <xsl:value-of select="/bedework/periodname" />
          </li>
          <li style="border-bottom: solid 1px #CCC;">
            Group:
            <span id="rssDetailGroup">All</span>
          </li>
          <li style="border-bottom: solid 1px #CCC;">
            Calendar Categories:
            <span id="rssDetailCategory">All</span>
          </li>
        </ul>
        <p style="padding: 6px;">
          To subscribe to an RSS feed of your current calendar
          view, copy and paste the entire URL below into your
          preferred RSS reader.
        </p>
        <p style="padding: 6px;">
          <strong>Your RSS URL:</strong>
        </p>
        <input id="rssValue" size="35" type="text" value="" />
        <ul style="padding: 6px;">
          <li>
            <a href="/feed/list/30">
              Click here for 30-day feed of events
            </a>
          </li>
          <li>
            <a href="/feed/list/60">
              Click here for 60-day feed of events
            </a>
          </li>
          <li>
            <a href="/feed/list/90">
              Click here for 90-day feed of events
            </a>
          </li>
        </ul>
      </div>
    </xsl:if>
    <a id="prevViewPeriod"
      href="{$setViewPeriod}&amp;date={$prevdate}">
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
    <a id="nextViewPeriod"
      href="{$setViewPeriod}&amp;date={$nextdate}">
      »
    </a>
  </xsl:template>

</xsl:stylesheet>
