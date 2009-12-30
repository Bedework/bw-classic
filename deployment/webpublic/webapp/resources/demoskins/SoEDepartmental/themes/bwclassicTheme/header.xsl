<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="/bedework/"><img src="{$resourcesRoot}/images/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
          <h2><xsl:copy-of select="$bwStr-HdBr-SchoolOfEng"/></h2>
          <a href="http://www.youruniversityhere.edu/engineering/"><xsl:copy-of select="$bwStr-HdBr-SchoolOfEngHome"/></a> |
          <a href="http://www.youruniversityhere.edu"><xsl:copy-of select="$bwStr-HdBr-UniversityHome"/></a> |
          <a href="http://www.bedework.org/"><xsl:copy-of select="$bwStr-HdBr-OtherLink"/></a>
        </td>
      </tr>
    </table>
    <table id="curDateRangeTable"  cellspacing="0">
      <tr>
        <td class="sideBarOpenCloseIcon">
          &#160;
          <!--
          we may choose to implement calendar selection in the public calendar
          using a sidebar; leave this comment here for now.
          <xsl:choose>
            <xsl:when test="/bedework/appvar[key='sidebar']/value='closed'">
              <a href="?setappvar=sidebar(opened)">
                <img alt="open sidebar" src="{$resourcesRoot}/images/sideBarArrowOpen.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="?setappvar=sidebar(closed)">
                <img alt="close sidebar" src="{$resourcesRoot}/images/sideBarArrowClose.gif" width="21" height="16" border="0" align="left"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>-->
        </td>
        <td class="date">
          <xsl:choose>
            <xsl:when test="/bedework/page='event'">
              <xsl:copy-of select="$bwStr-HdBr-EventInformation"/>
            </xsl:when>
            <xsl:when test="/bedework/page='showSysStats' or
                            /bedework/page='calendars'">
              &#160;
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/firstday/longdate"/>
              <xsl:if test="/bedework/periodname!='Day'">
                -
                <xsl:value-of select="/bedework/lastday/longdate"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="rssPrint">
          <a href="javascript:window.print()" title="{$bwStr-HdBr-PrintThisView}">
            <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-HdBr-Print"/>
          </a>
          <a class="rss" href="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=rss-list&amp;days=3" title="{$bwStr-HdBr-RSSFeed}"><xsl:copy-of select="$bwStr-HdBr-RSS"/></a>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
