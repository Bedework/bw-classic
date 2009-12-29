<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- === Navigation == -->
  <xsl:template name="navigation">
    <div id="nav">
      <div class="navlink" id="navlink-prev" onclick="gotourl(this,'{$setViewPeriod}&amp;date={$prevdate}');">
        &lt;prev
      </div>
      <div class="navlink" id="navlink-today" onclick="gotourl(this,'{$setViewPeriod}&amp;viewType=todayView&amp;date={$curdate}');">
        today
      </div>
      <div class="navlink" id="navlink-day" onclick="gotourl(this,'{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}');">
        <xsl:if test="/bedework/periodname='Day'">
          <xsl:attribute name="class">navlink selected</xsl:attribute>
        </xsl:if>
        day
      </div>
      <div class="navlink" id="navlink-week" onclick="gotourl(this,'{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}');">
        <xsl:if test="/bedework/periodname='Week'">
          <xsl:attribute name="class">navlink selected</xsl:attribute>
        </xsl:if>
        week
      </div>
      <div class="navlink" id="navlink-month" onclick="gotourl(this,'{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}');">
        <xsl:if test="/bedework/periodname='Month'">
          <xsl:attribute name="class">navlink selected</xsl:attribute>
        </xsl:if>
        month
      </div>
      <div class="navlink" id="navlink-next" onclick="gotourl(this,'{$setViewPeriod}&amp;date={$nextdate}');">
        next&gt;
      </div>

      <xsl:if test="/bedework/selectionState/selectionType = 'calendar'">
        <br/>Calendar: <xsl:value-of select="/bedework/selectionState/subscriptions/subscription/calendar/name"/>
        <span class="link">[<a href="{$setSelection}">show all</a>]</span>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>
