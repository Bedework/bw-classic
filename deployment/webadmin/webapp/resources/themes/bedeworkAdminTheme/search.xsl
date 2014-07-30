<?xml version="1.0" encoding="UTF-8"?>
<!--
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--++++ SEARCH ++++-->
  <!-- templates:
         - searchResult
         - upperSearchForm
         - searchResultPageNav
   -->
  <xsl:template name="searchResult">
    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <h2 class="bwStatusConfirmed"><xsl:copy-of select="$bwStr-Srch-SearchResult"/></h2>
    <div id="searchResultSize">
      <strong><xsl:value-of select="/bedework/searchResults/resultSize"/></strong>
      <xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-Srch-ResultReturnedFor"/><xsl:text> </xsl:text>
      "<strong><em><xsl:value-of select="substring-after(/bedework/appvar[key='bwQuery']/value,'|')"/></em></strong>"
    </div>

    <div class="bwEventListNav">
      <button class="searchPrevious" onclick="location.href='{$search-next}&amp;prev=prev'"><span class="searchArrow searchArrowLeft">◄</span> <xsl:copy-of select="$bwStr-Srch-PrevFull"/></button>
      <button class="searchNext" onclick="location.href='{$search-next}&amp;next=next'"><xsl:copy-of select="$bwStr-Srch-NextFull"/> <span class="searchArrow searchArrowRight">►</span></button>
    </div>

    <form name="bwSearchEventListControls" id="bwSearchEventListControls" method="post" action="{$search}" onsubmit="return setBwQuery(this,this.start.value);">
      <label for="bwSearchWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
      <input id="bwSearchWidgetStartDate" type="text" class="noFocus" name="start" size="10" onchange="setBwQuery(this.form,this.value,true);"/>
      <input id="bwSearchWidgetToday" type="button" value="{$bwStr-EvLs-Today}" onclick="setBwQuery(this.form,'today',true);"/>

      <xsl:copy-of select="$bwStr-Srch-Search"/>
      <xsl:text> </xsl:text>
      <input type="text" name="query" size="27">
        <xsl:attribute name="value"><xsl:value-of select="substring-after(/bedework/appvar[key='bwQuery']/value,'|')"/></xsl:attribute>
      </input>
      <input type="submit" value="{$bwStr-Srch-Go}"/>
      <input type="hidden" name="setappvar" id="curQueryHolder" value="bwQuery()"/>
      <input type="hidden" name="sort" value="dtstart.utc:asc"/>
      <input type="hidden" name="count" value="{$searchResultSize}"/>
    </form>

    <table id="searchTable">
      <xsl:choose>
        <xsl:when test="/bedework/searchResults/searchResult">
          <tr class="fieldNames">
            <th>
              <xsl:copy-of select="$bwStr-Srch-Title"/>
            </th>
            <th>
              <xsl:copy-of select="$bwStr-Srch-DateAndTime"/>
            </th>
            <!-- <td>  XXX would like to restore these
              topical areas
            </td>-->
            <th>
              <xsl:copy-of select="$bwStr-Srch-Location"/>
            </th>
          </tr>
          <xsl:for-each select="/bedework/searchResults/searchResult">
            <xsl:variable name="calPath" select="event/calendar/encodedPath"/>
            <xsl:variable name="guid" select="event/guid"/>
            <xsl:variable name="recurrenceId" select="event/recurrenceId"/>
            <tr>
              <td>
                <a href="{$event-fetchForDisplay}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of select="event/summary"/>
                  <xsl:if test="event/summary = ''"><em><xsl:copy-of select="$bwStr-Srch-NoTitle"/></em></xsl:if>
                </a>
              </td>
              <td>
                <xsl:value-of select="event/start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="event/start/time"/>
                <xsl:choose>
                  <xsl:when test="event/start/longdate != event/end/longdate">
                    - <xsl:value-of select="event/end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="event/end/time"/>
                  </xsl:when>
                  <xsl:when test="event/start/time != event/end/time">
                    - <xsl:value-of select="event/end/time"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <!--
              <td>
                <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                  <xsl:call-template name="substring-afterLastInstanceOf">
                    <xsl:with-param name="string" select="values/text"/>
                    <xsl:with-param name="char">/</xsl:with-param>
                  </xsl:call-template><br/>
                </xsl:for-each>
              </td>-->
              <td>
                <xsl:value-of select="event/location/address"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/searchResults/resultSize = '0'"><xsl:copy-of select="$bwStr-Srch-NoResults"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="$bwStr-Srch-NoMoreResults"/></xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </table>
    <div class="bwEventListNav">
      <button class="searchPrevious" onclick="location.href='{$search-next}&amp;prev=prev'"><span class="searchArrow searchArrowLeft">&#9668;</span> <xsl:copy-of select="$bwStr-Srch-PrevFull"/></button>
      <button class="searchNext" onclick="location.href='{$search-next}&amp;next=next'"><xsl:copy-of select="$bwStr-Srch-NextFull"/> <span class="searchArrow searchArrowRight">&#9658;</span></button>
    </div>
  </xsl:template>

  <xsl:template name="upperSearchForm">
    <xsl:param name="toggleLimits">false</xsl:param>
    <div id="searchFilter">
      <form name="searchForm" method="post" action="{$search}" onsubmit="return setBwQuery(this);">
        <div class="searchQueryBlock">
          <xsl:copy-of select="$bwStr-Srch-Search"/>
          <xsl:text> </xsl:text>
          <input type="text" name="query" size="27">
            <xsl:attribute name="value"><xsl:value-of select="substring-after(/bedework/appvar[key='bwQuery']/value,'|')"/></xsl:attribute>
            <xsl:attribute name="class">noFocus</xsl:attribute>
          </input>
          <input type="hidden" name="count" value="{$searchResultSize}"/>
          <input type="hidden" name="start" value="today"/>
          <input type="hidden" name="sort" value="dtstart.utc:asc"/>
          <input type="hidden" name="setappvar" value="bwQuery()"/>
          <input type="submit" name="submit" value="{$bwStr-Srch-Go}" class="noFocus"/>
        </div>

        <!--
        <div class="searchLimitBlock">
          <xsl:if test="$toggleLimits = 'true'">
            <xsl:attribute name="class">searchLimitBlock searchLimitBlockToggle</xsl:attribute>
          </xsl:if>
          <label for="bwSearchWidgetStartDate"><xsl:copy-of select="$bwStr-Srch-Starting"/></label>
          <input id="bwSearchWidgetStartDate" type="text" class="noFocus" name="start" size="10" onchange="setSearchDate(this.form,this.value);"/>
          <input id="bwSearchWidgetToday" type="button" value="{$bwStr-EvLs-Today}" onclick="setSearchDate(this.form,'{$searchToday}');"/>
        </div>
        -->

      </form>
    </div>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
    <xsl:variable name="numPages" select="/bedework/searchResults/numPages"/>
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when test="number($curPage) + 6 &gt; number($numPages)"><xsl:value-of select="$numPages"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="number($curPage) + 6"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <xsl:value-of select="$page"/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
       <xsl:call-template name="searchResultPageNav">
         <xsl:with-param name="page" select="number($page)+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>