<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== HEADER TEMPLATES and NAVIGATION  ====-->
  <!-- these templates are separated out for convenience and to simplify the default template -->

  <xsl:template name="titleBar">
    <div id="head-top">
      <div id="title-logoArea">
        <!-- we attach the logoArea link to this div - do not remove the space -->
        <xsl:text> </xsl:text>
      </div>
      <div id="title-text">
        <h2>
          <xsl:copy-of select="$bwStr-HdBr-PublicCalendar" />
        </h2>
        <a href="{$privateCal}">
          <xsl:copy-of select="$bwStr-HdBr-PersonalCalendar" />
        </a>
        |
        <a href="/bedework">
          <xsl:copy-of select="$bwStr-HdBr-UniversityHome" />
        </a>
        |
        <!-- a href="http://www.bedework.org/"-->
        <a href="?refreshXslt=yes">
          <xsl:copy-of select="$bwStr-HdBr-OtherLink" />
        </a>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="dateSelectForm">
    <form name="calForm" method="post" action="{$setViewPeriod}">
      <xsl:if test="/bedework/periodname!='Year'">
        <select name="viewStartDate.month">
          <xsl:for-each select="/bedework/monthvalues/val">
            <xsl:variable name="temp" select="." />
            <xsl:variable name="pos" select="position()" />
            <xsl:choose>
              <xsl:when
                test="/bedework/monthvalues[start=$temp]">
                <option value="{$temp}"
                  selected="selected">
                  <xsl:value-of
                    select="/bedework/monthlabels/val[position()=$pos]" />
                </option>
              </xsl:when>
              <xsl:otherwise>
                <option value="{$temp}">
                  <xsl:value-of
                    select="/bedework/monthlabels/val[position()=$pos]" />
                </option>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </select>
        <xsl:if test="/bedework/periodname!='Month'">
          <select name="viewStartDate.day">
            <xsl:for-each
              select="/bedework/dayvalues/val">
              <xsl:variable name="temp" select="." />
              <xsl:variable name="pos"
                select="position()" />
              <xsl:choose>
                <xsl:when
                  test="/bedework/dayvalues[start=$temp]">
                  <option value="{$temp}"
                    selected="selected">
                    <xsl:value-of
                      select="/bedework/daylabels/val[position()=$pos]" />
                  </option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="{$temp}">
                    <xsl:value-of
                      select="/bedework/daylabels/val[position()=$pos]" />
                  </option>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </select>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="temp"
        select="/bedework/yearvalues/start" />
      <input type="text" name="viewStartDate.year" maxlength="4"
        size="4" value="{$temp}" />
      <input name="submit" type="submit" value="go" />
    </form>
  </xsl:template>

  <xsl:template name="tabs">
    <div id="nav-search-wrap">
      <form name="searchForm" id="basic_search" method="post"
        onsubmit="if (this.query.value == '') return false;"
        action="{$search}">
        <!--advance search link  -->
        <a href="{$search-next}">Advanced Search</a>
        <input type="text" name="query" id="basicsearchbox">
          <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query" /></xsl:attribute>
        </input>
        <input id="searchSubmit" type="submit" name="submit"
          value="Search" onmouseover="this.style.backgroundColor = '#273E6D'"
          onmouseout="this.style.backgroundColor = '#85C13D'" />
      </form>
      <ul id="nav-main">
        <xsl:variable name="currentClass">current</xsl:variable>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}">
            <xsl:if test="/bedework/periodname='Day'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            DAY
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}">
            <xsl:if test="/bedework/periodname='Week'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            WEEK
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}">
            <xsl:if test="/bedework/periodname='Month'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            MONTH
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}">
            <xsl:if test="/bedework/periodname='Year'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            YEAR
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=todayView">
            <xsl:if test="/bedework/periodname='Today'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            TODAY
          </a>
        </li>
      </ul>
      <div class="clear">&#160;</div>
    </div>
  </xsl:template>

</xsl:stylesheet>
