<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">


  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <div class="secondaryColHeader">
      <h3>Search Results</h3>
    </div>

    <!-- <xsl:if test="/bedework/searchResults/numPages &gt; 1">
      <span class="resultPages">
      <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
      <xsl:if test="/bedework/searchResults/curPage != 1">
      <xsl:variable name="prevPage" select="number($curPage) - 1"/>
      <a href="{$search-next}&amp;pageNum={$prevPage}">&#171;</a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:call-template name="searchResultPageNav">
      <xsl:with-param name="page">
      <xsl:choose>
      <xsl:when test="number($curPage) - 10 &lt; 1">1</xsl:when>
      <xsl:otherwise>
      <xsl:value-of select="number($curPage) - 6"/>
      </xsl:otherwise>
      </xsl:choose>
      </xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:choose>
      <xsl:when test="$curPage != /bedework/searchResults/numPages">
      <xsl:variable name="nextPage" select="number($curPage) + 1"/>
      <a href="{$search-next}&amp;pageNum={$nextPage}">&#187;</a></xsl:when>
      <xsl:otherwise>
      <span class="hidden">&#171;</span>
      </xsl:otherwise>
      </xsl:choose>
      </span>
      </xsl:if> -->

    <xsl:if test="/bedework/searchResults/curPage &lt; 2">
      <span class="numReturnedResults">
        <xsl:value-of
          select="/bedework/searchResults/resultSize" />
        <xsl:text> result</xsl:text>
        <xsl:if
          test="/bedework/searchResults/resultSize != 1">
          s
        </xsl:if>
        <xsl:text> returned for: </xsl:text>
        <em>
          <xsl:value-of
            select="/bedework/searchResults/query" />
        </em>
      </span>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/searchResult">
      <table id="searchTable" cellpadding="0" cellspacing="0"
        width="100%">
        <tr>
          <th class="search_relevance">Rank</th>
          <th class="search_date">Date</th>
          <th class="search_summary">Summary</th>
          <th class="search_location">Location</th>
        </tr>
        <xsl:for-each
          select="/bedework/searchResults/searchResult[not(event/categories/category/value = 'Local')]">
          <xsl:if test="event/summary">
            <xsl:variable name="calPath"
              select="event/calendar/encodedPath" />
            <xsl:variable name="guid" select="event/guid" />
            <xsl:variable name="recurrenceId"
              select="event/recurrenceId" />
            <tr>
              <td class="search_relevance">
                <xsl:choose>
                  <xsl:when
                    test="contains(score,'E')">
                    1%
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="ceiling(number(score)*100)" />
                    %
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="search_date">
                <xsl:value-of
                  select="event/start/shortdate" />
                <xsl:text> </xsl:text>
              </td>
              <td class="search_summary">
                <a
                  href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of
                    select="event/summary" />
                </a>
              </td>
              <td class="search_location">
                <xsl:value-of
                  select="event/location/address" />
              </td>
            </tr>
          </xsl:if>
        </xsl:for-each>
      </table>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/numPages &gt; 1">
      <span class="resultPages" id="resultsBottom">
        Page(s):
        <xsl:variable name="curPage"
          select="/bedework/searchResults/curPage" />
        <xsl:if test="/bedework/searchResults/curPage != 1">
          <xsl:variable name="prevPage"
            select="number($curPage) - 1" />
          <a href="{$search-next}&amp;pageNum={$prevPage}">
            «
          </a>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:call-template name="searchResultPageNav">
          <xsl:with-param name="page">
            <xsl:choose>
              <xsl:when
                test="number($curPage) - 10 &lt; 1">
                1
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="number($curPage) - 6" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when
            test="$curPage != /bedework/searchResults/numPages">
            <xsl:variable name="nextPage"
              select="number($curPage) + 1" />
            <a
              href="{$search-next}&amp;pageNum={$nextPage}">
              »
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span class="hidden">«</span>
            <!-- occupy the space to keep the navigation from moving around -->
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="advancedSearch">
    <div id="advSearch">
      <h3>Advanced Search</h3>
      <form id="advSearchForm" name="searchForm"
        onsubmit="return initCat()" method="post" action="{$search}">
        Search:
        <input type="text" name="query" size="40" value="" />
        <!--          <xsl:attribute name="value">
          <xsl:value-of select="/bedework/searchResults/query"/>
          </xsl:attribute>
          </input>-->
        <br />
        <label>Limit by:</label>
        <br />
        <xsl:choose>
          <xsl:when
            test="/bedework/searchResults/searchLimits = 'beforeToday'">
            <input type="radio" name="searchLimits"
              value="fromToday" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" checked="checked" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" />
            All dates
            <br />
          </xsl:when>
          <xsl:when
            test="/bedework/searchResults/searchLimits = 'none'">
            <input type="radio" name="searchLimits"
              value="fromToday" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" checked="checked" />
            All dates
            <br />
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="searchLimits"
              value="fromToday" checked="checked" />
            Today forward
            <br />
            <input type="radio" name="searchLimits"
              value="beforeToday" />
            Past dates
            <br />
            <input type="radio" name="searchLimits"
              value="none" />
            All dates
            <br />
          </xsl:otherwise>
        </xsl:choose>

        <input type="submit" name="submit" value="Search" />

        <div id="searchCats">
          <h4>Select Categories to Search (Optional)</h4>
          <p>
            A search term is not required if at least one
            category is selected.
          </p>
          <xsl:variable name="catCount"
            select="count(/bedework/categories/category)" />
          <table>
            <tr>
              <td>
                <ul>
                  <xsl:for-each
                    select="/bedework/categories/category[(position() &lt;= ceiling($catCount div 2)) and (keyword != 'Local') and (creator != 'agrp_public-user') and (keyword != 'Main') and (keyword != 'Student') and (keyword != 'calCrossPublish')]">
                    <xsl:variable name="currId"
                      select="keyword" />
                    <li>
                      <p>
                        <input type="checkbox"
                          name="categoryKey" value="{$currId}" />
                        <xsl:value-of
                          select="keyword" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
              <td>
                <ul>
                  <xsl:for-each
                    select="/bedework/categories/category[(position() &gt; ceiling($catCount div 2)) and (keyword != 'Local') and (creator != 'agrp_public-user') and (keyword != 'Main') and (keyword != 'Student') and (keyword != 'calCrossPublish')]">
                    <xsl:variable name="currId2"
                      select="keyword" />
                    <li>
                      <p>
                        <input type="checkbox"
                          name="categoryKey" value="{$currId2}" />
                        <xsl:value-of
                          select="keyword" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
          </table>
        </div>
        <input type="submit" name="submit" value="Search" />
      </form>
    </div>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage"
      select="/bedework/searchResults/curPage" />
    <xsl:variable name="numPages"
      select="/bedework/searchResults/numPages" />
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when
          test="number($curPage) + 6 &gt; number($numPages)">
          <xsl:value-of select="$numPages" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($curPage) + 6" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <span class="current">
          <xsl:value-of select="$page" />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
      <xsl:call-template name="searchResultPageNav">
        <xsl:with-param name="page" select="number($page)+1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
