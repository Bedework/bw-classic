<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- Groups List -->
  <xsl:template name="groupsList">
    <div style="display:none;" id="groupListDiv">
      <div class="groupHeader">
        <h3>Select a Group</h3>
        <a href="#"
          onclick="javascript:toggleVisibility('groupListDiv'); toggleVisibility('right_column'); toggleVisibility('center_column');">
          X - Close
        </a>
      </div>
      <ul class="groupList">
        <li>
          <a href="/cal/?setappvar=group(all)">
            <xsl:if
              test="((/bedework/appvar[key = 'group']/value = 'all') or not(/bedework/appvar[key = 'group']/value))">
              <xsl:attribute name="class">current</xsl:attribute>
            </xsl:if>
            All
          </a>
        </li>
        <xsl:for-each
          select="/bedework/urlPrefixes/groups/group[ memberof/name = 'campusAdminGroups' ]">
          <xsl:variable name="eventOwner"
            select="eventOwner/text()" />
          <xsl:variable name="groupName" select="name/text()" />
          <xsl:variable name="groupDescription"
            select="description/text()" />
          <li>
            <a
              href="/cal/?setappvar=group({$eventOwner})">
              <xsl:if
                test="$eventOwner = (/bedework/appvar[key = 'group']/value)">
                <xsl:attribute name="class">current</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$groupName" />
            </a>
            <xsl:if
              test="$groupName != $groupDescription">
              <div class="groupDesc">
                <xsl:value-of
                  select="$groupDescription" />
              </div>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>
