<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="ongoingEventList">
    <h3 class="secondaryColHeader">Ongoing</h3>
    <ul class="eventList">
      <xsl:for-each
        select="/bedework/eventscalendar/year/month/week/day/event[(categories/category[value|word = 'Main']) and (categories/category[value|word = 'Ongoing']) and not(categories/category[value|word = 'Local'])]">
        <xsl:sort select="start/unformatted" order="ascending"
          data-type="number" />
        <xsl:sort select="id" data-type="number" />
        <xsl:variable name="lastId" select="id" />
        <xsl:if test="not(preceding::event[id=$lastId])">
          <xsl:choose>
            <xsl:when
              test="(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (not(/bedework/appvar[key = 'category']/value) or (/bedework/appvar[key = 'category']/value = 'all'))">
              <xsl:variable name="creator" select="creator" />
              <xsl:variable name="envgroup" select="/bedework/appvar[key = 'group']/value" />
              <xsl:variable name="cosponsor" select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION" />
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key = 'group']/value = $creator">
                  <xsl:call-template name="ongoingEvent" />
                </xsl:when>
                <xsl:when test="contains($cosponsor, concat($envgroup,','))">
                  <xsl:call-template name="ongoingEvent" />
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="not(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value = 'all')">
              <xsl:call-template name="split-for-ongoing">
                <xsl:with-param name="list">
                  <xsl:value-of select="/bedework/appvar[key = 'category']/value" />
                </xsl:with-param>
                <xsl:with-param name="delimiter">
                  ~
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="(/bedework/appvar[key = 'group']/value = /bedework/urlPrefixes/groups/group/eventOwner) and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value = 'all')">
              <xsl:variable name="creator" select="creator" />
              <xsl:variable name="envgroup" select="/bedework/appvar[key = 'group']/value" />
              <xsl:variable name="cosponsor" select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION" />
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key = 'group']/value = $creator">
                  <xsl:call-template name="split-for-ongoing">
                    <xsl:with-param name="list">
                      <xsl:value-of select="/bedework/appvar[key = 'category']/value" />
                    </xsl:with-param>
                    <xsl:with-param name="delimiter">
                      ~
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when
                  test="contains($cosponsor, concat($envgroup,','))">
                  <xsl:call-template
                    name="split-for-ongoing">
                    <xsl:with-param name="list">
                      <xsl:value-of
                        select="/bedework/appvar[key = 'category']/value" />
                    </xsl:with-param>
                    <xsl:with-param
                      name="delimiter">
                      ~
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="ongoingEvent" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template name="split-for-ongoing">
    <xsl:param name="list" />
    <xsl:param name="delimiter" />
    <xsl:variable name="newlist">
      <xsl:choose>
        <xsl:when test="contains($list, $delimiter)">
          <xsl:value-of select="normalize-space($list)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="concat(normalize-space($list), $delimiter)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="first"
      select="substring-before($newlist, $delimiter)" />
    <xsl:variable name="remaining"
      select="substring-after($newlist, $delimiter)" />
    <xsl:choose>
      <xsl:when test="$first = categories/category/value">
        <xsl:call-template name="ongoingEvent" />
      </xsl:when>
      <xsl:when test="$first = categories/category/word">
        <xsl:call-template name="ongoingEvent" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$remaining">
          <xsl:call-template name="split-for-ongoing">
            <xsl:with-param name="list" select="$remaining" />
            <xsl:with-param name="delimiter">
              <xsl:value-of select="$delimiter" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ongoingEvent">
    <li>
      <xsl:variable name="subscriptionId"
        select="subscription/id" />
      <xsl:variable name="calPath" select="calendar/encodedPath" />
      <xsl:variable name="guid" select="guid" />
      <xsl:variable name="recurrenceId" select="recurrenceId" />
      <xsl:variable name="statusClass">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">
            bwStatusCancelled
          </xsl:when>
          <xsl:when test="status='TENTATIVE'">
            bwStatusTentative
          </xsl:when>
          <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="status != 'CONFIRMED'">
        <xsl:value-of select="status" />
        <xsl:text>: </xsl:text>
      </xsl:if>
      <xsl:value-of select="summary" />
      , Ends
      <xsl:value-of select="end/shortdate" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="end/time" />
      <xsl:text> |</xsl:text>
      <a
        href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
        more
      </a>
      <xsl:text>|</xsl:text>
    </li>
  </xsl:template>

  <!-- Notices List -->
  <xsl:template name="noticesList">
    <h3 class="secondaryColHeader">Notices</h3>
    <ul>
      <xsl:for-each
        select="/bedework/eventscalendar/year/month/week/day/event[categories/category/value = 'Reminder']">
        <li>
          <xsl:variable name="subscriptionId"
            select="subscription/id" />
          <xsl:variable name="calPath"
            select="calendar/encodedPath" />
          <xsl:variable name="guid" select="guid" />
          <xsl:variable name="recurrenceId"
            select="recurrenceId" />
          <xsl:variable name="statusClass">
            <xsl:choose>
              <xsl:when test="status='CANCELLED'">
                bwStatusCancelled
              </xsl:when>
              <xsl:when test="status='TENTATIVE'">
                bwStatusTentative
              </xsl:when>
              <xsl:otherwise>
                bwStatusConfirmed
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="status != 'CONFIRMED'">
            <xsl:value-of select="status" />
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="summary" />
          <xsl:text> | </xsl:text>
          <a
            href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
            more
          </a>
          <xsl:text> |</xsl:text>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>
