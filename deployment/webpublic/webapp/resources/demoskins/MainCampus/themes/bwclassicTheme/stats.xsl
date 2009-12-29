<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->
  <xsl:template name="stats">
    <div id="stats">
      <h2><xsl:copy-of select="$bwStr-Stat-SysStats"/></h2>

      <p>
        <xsl:copy-of select="$bwStr-Stat-StatsCollection"/>
      </p>
      <ul>
        <li>
          <a href="{$stats}&amp;enable=yes"><xsl:copy-of select="$bwStr-Stat-Enable"/></a> |
          <a href="{$stats}&amp;disable=yes"><xsl:copy-of select="$bwStr-Stat-Disable"/></a>
        </li>
        <li><a href="{$stats}&amp;fetch=yes"><xsl:copy-of select="$bwStr-Stat-FetchStats"/></a></li>
        <li><a href="{$stats}&amp;dump=yes"><xsl:copy-of select="$bwStr-Stat-DumpStats"/></a></li>
      </ul>
      <table id="statsTable" cellpadding="0">
        <xsl:for-each select="/bedework/sysStats/*">
          <xsl:choose>
            <xsl:when test="name(.) = 'header'">
              <tr>
                <th colspan="2">
                  <xsl:value-of select="."/>
                </th>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td class="label">
                  <xsl:value-of select="label"/>
                </td>
                <td class="value">
                  <xsl:value-of select="value"/>
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
