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
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Subscriptions Calendar Tree -->
  <xsl:template name="subscriptionsTree">
    <div class="bwMenu"><!-- was #bwSubs -->
      <div class="bwMenuTitle">
        <span class="caret"><xsl:text> </xsl:text></span><xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-LCol-Calendars"/>
      </div>
      <div class="bwMenuTree"><!-- was #subsTree -->
        <ul><!-- was #subs -->
          <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar" mode="menuTree">
            <xsl:with-param name="isRoot">true</xsl:with-param>
          </xsl:apply-templates>
        </ul>
      </div>

      <script type="text/javascript">
      $(document).ready(function(){

        displayFilters(bwFilters,bwFilterLabels,bwCalFilterName,bwCalClearFilterMarkup);

        // If item is in our selected list - make it bold.
        $(".bwMenuTree ul ul a").each(function() {
          var curCal = $(this).attr("class").substring(2);  // trim off the required "bw" prefix
          <xsl:if test="/bedework/page = 'listEvents'">
            curCal = $(this).attr("href");  // simpler approach for upcoming list
          </xsl:if>
          var itemIndex = $.inArray(curCal,bwFilters);
          if(itemIndex != -1) {
            $(this).css("font-weight","bold");
          }
        });

      });
      </script>
      <noscript><xsl:copy-of select="$bwStr-Error-NoScript"/></noscript>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="menuTree">
    <xsl:param name="isRoot"/>
    <xsl:variable name="isHiddenCalendar"></xsl:variable>
    <xsl:variable name="curPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="/bedework/selectionState/collection/virtualpath"/></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="encVirtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="$virtualPath"/></xsl:call-template></xsl:variable>

    <xsl:variable name="name" select="name"/>
    <xsl:variable name="summary" select="summary"/>
    <xsl:variable name="itemId"><xsl:value-of select="translate(path,'/_- ','')"/></xsl:variable>
    <xsl:variable name="folderState">
      <xsl:choose>
        <xsl:when test="contains(/bedework/appvar[key='opencals']/value,$itemId)">open</xsl:when>
        <xsl:otherwise>closed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li id="{$itemId}">
      <xsl:if test="calendar and not($isRoot = 'true')">
	      <xsl:attribute name="class">
	        <xsl:choose>
	          <xsl:when test="$virtualPath = $curPath">hasChildren selected <xsl:value-of select="$folderState"/></xsl:when>
	          <xsl:when test="contains($curPath,$virtualPath)">hasChildren selectedPath open</xsl:when>
	          <xsl:otherwise>hasChildren <xsl:value-of select="$folderState"/></xsl:otherwise>
	        </xsl:choose>
	      </xsl:attribute>
	      <span class="menuTreeToggle">
	        <xsl:choose>
	          <xsl:when test="$folderState = 'closed'">+</xsl:when>
	          <xsl:otherwise>-</xsl:otherwise>
	        </xsl:choose>
	      </span>
	    </xsl:if>
	    <xsl:if test="not(calendar) and $virtualPath = $curPath">
	      <xsl:attribute name="class">selected</xsl:attribute>
	    </xsl:if>
	    <xsl:choose>
	      <xsl:when test="$isRoot = 'true'">
	        <xsl:attribute name="class">root</xsl:attribute>
	        <a href="{$setSelectionList}">
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="/bedework/page = 'eventscalendar'"><xsl:value-of select="$setSelection"/>&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()</xsl:when>
                <xsl:when test="/bedework/appvar[key='listPage']/value = 'eventscalendar'"><xsl:value-of select="$setSelection"/>&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()</xsl:when>
                <xsl:otherwise><xsl:value-of select="$setSelectionList"/>&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
	          <xsl:copy-of select="$bwStr-LCol-All"/>
	        </a>
	      </xsl:when>
	      <xsl:otherwise>
	        <a href="{$setSelection}">
	          <xsl:attribute name="href">
              <xsl:value-of select="path"/>
              <!--
	            <xsl:choose>
	              < ! - -<xsl:when test="/bedework/page = 'eventList'"><xsl:value-of select="$setSelectionList"/>&amp;virtualPath=<xsl:value-of select="$encVirtualPath"/>&amp;setappvar=curCollection(<xsl:value-of select="$name"/>)</xsl:when>- - >
                <xsl:when test="/bedework/page = 'eventList'"><xsl:value-of select="path"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$setSelection"/>&amp;virtualPath=<xsl:value-of select="$encVirtualPath"/></xsl:otherwise>
	            </xsl:choose>
	            -->
	          </xsl:attribute>
	          <xsl:attribute name="class">bw<xsl:value-of select="path"/></xsl:attribute>
	          <xsl:value-of select="summary"/>
	        </a>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:if test="calendar[(calType &lt; 2) and (name != 'calendar')]"><!-- the test for "calendar" isn't best -->
        <ul>
	        <xsl:apply-templates select="calendar[(calType &lt; 2) and (name != 'calendar') and not(starts-with(name,'.cs'))]" mode="menuTree"><!-- ".cs" calendars hold calendar suite resources -->
            <xsl:with-param name="isRoot">false</xsl:with-param>
	        </xsl:apply-templates>
	      </ul>
	    </xsl:if>
    </li>
  </xsl:template>

  <!--
  <xsl:template match="calendar" mode="limitsTree">
    <xsl:param name="isRoot"/>
    <xsl:variable name="curPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="/bedework/selectionState/collection/virtualpath"/></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="encVirtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="$virtualPath"/></xsl:call-template></xsl:variable>

    <xsl:variable name="name" select="name"/>
    <xsl:variable name="summary" select="summary"/>
    <xsl:variable name="itemId">lim<xsl:value-of select="translate($virtualPath,'()./_- ','')"/></xsl:variable>
    <xsl:variable name="folderState">
      <xsl:choose>
        <xsl:when test="contains(/bedework/appvar[key='opencals']/value,$itemId)">open</xsl:when>
        <xsl:otherwise>closed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li id="{$itemId}">
      <xsl:if test="calendar and not($isRoot = 'true')">
        <xsl:attribute name="class">hasChildren <xsl:value-of select="$folderState"/></xsl:attribute>
        <span class="menuTreeToggle">
          <xsl:choose>
            <xsl:when test="$folderState = 'closed'">+</xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:if>
      <xsl:if test="not(calendar) and $virtualPath = $curPath">
        <xsl:attribute name="class">selected</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$isRoot = 'true'">
          <xsl:attribute name="class">root</xsl:attribute>
          <div id="limitByTitle">Limit By:</div>
        </xsl:when>
        <xsl:when test="path = '/user/agrp_calsuite-MainCampus/Age Group' or
                        path = '/user/agrp_calsuite-MainCampus/Locations'">
          <span class="bwMenuNoLink"><xsl:value-of select="summary"/></span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="filterId">f<xsl:value-of select="$itemId"/></xsl:variable>
          <input type="checkbox" name="{$filterId}" id="{$filterId}"><! - - note: this id will be the translated path prepended with "flim" - - >
            <xsl:if test="contains(path,'/public/aliases/Age Group')">
              <xsl:if test="contains(/bedework/appvar[key='ages']/value,$filterId)">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="class">ages</xsl:attribute>
            </xsl:if>
            <xsl:if test="contains(path,'/public/aliases/Locations')">
              <xsl:if test="contains(/bedework/appvar[key='locations']/value,$filterId)">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="class">locations</xsl:attribute>
            </xsl:if>

          </input>

          <label for="{$filterId}">
            <xsl:value-of select="summary"/>
          </label>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar[contains(path,'/user/agrp_calsuite-MainCampus/Age Group') or
                             contains(path,'/user/agrp_calsuite-MainCampus/Locations') or
                             contains(path,'/public/aliases/Age Group') or
                             contains(path,'/public/aliases/Locations')]">
        <ul><! - - include only "Age Group" and "Locations" calendars - we use these only for filtering at SDPL - - >
          <xsl:apply-templates select="calendar[contains(path,'/user/agrp_calsuite-MainCampus/Age Group') or
                             contains(path,'/user/agrp_calsuite-MainCampus/Locations') or
                             contains(path,'/public/aliases/Age Group') or
                             contains(path,'/public/aliases/Locations')]" mode="limitsTree">
            <xsl:with-param name="isRoot">false</xsl:with-param>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  -->
</xsl:stylesheet>
