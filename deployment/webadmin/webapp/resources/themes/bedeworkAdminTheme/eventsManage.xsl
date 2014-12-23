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

  <!--++++++++++++++++++ Manage Events List ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <h2 class="leftTitle"><xsl:copy-of select="$bwStr-EvLs-ManageEvents"/></h2>
    <button id="bwEventListAddEventButton" onclick="javascript:location.replace('{$event-initAddEvent}')"><xsl:value-of select="$bwStr-EvLs-PageTitle"/></button>

    <div id="bwEventListControls">
      <div class="bwEventListNav">
        <button onclick="location.href='{$event-nextUpdateList}&amp;prev=prev&amp;sort=dtstart.utc:asc'"><span class="searchArrow searchArrowLeft">&#9668;</span> <xsl:copy-of select="$bwStr-EvLs-Previous"/></button>
        <button onclick="location.href='{$event-nextUpdateList}&amp;next=next&amp;sort=dtstart.utc:asc'"><xsl:copy-of select="$bwStr-EvLs-Next"/> <span class="searchArrow searchArrowRight">&#9658;</span></button>
      </div>

      <form name="bwManageEventListControls" id="bwManageEventListControls" method="get" action="{$event-initUpdateEvent}">
        <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
        <input id="bwListWidgetStartDate" type="text" class="noFocus" name="start" size="10" onchange="setListDate(this.form,this.value);"/>
        <input id="bwListWidgetToday" type="submit" value="{$bwStr-EvLs-Today}" onclick="setListDateToday('{$today}',this.form);"/>
        <input type="hidden" name="fexpr" value="(entity_type=&quot;event&quot;|entity_type=&quot;todo&quot;)"/> <!-- fexpr value will be overridden by value in bwFilterEventsForm -->
        <input type="hidden" name="sort" value="dtstart.utc:asc"/>
        <input type="hidden" name="listMode" value="true"/>
        <input type="hidden" name="setappvar" id="curListDateHolder" value="curListDate()"/> <!-- value is set in the setListDate function to maintain date between requests -->
      </form>

      <form name="bwFilterEventsForm"
            id="bwFilterEventsForm"
            action="{$event-initUpdateEvent}"
            method="POST">
        <label for="listEventsCatFilter"><xsl:copy-of select="$bwStr-EvLs-FilterBy"/></label>
        <select name="fexpr" onchange="this.form.setappvar.value = 'catFilter(' + this.form.fexpr.selectedIndex + ')'; this.form.submit();" id="listEventsCatFilter">
          <option>
            <xsl:attribute name="value">(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
            <xsl:copy-of select="$bwStr-EvLs-SelectCategory"/>
          </option>
          <xsl:for-each select="/bedework/categories/category">
            <xsl:sort order="ascending" select="value"/>
            <option>
              <xsl:attribute name="value">(categories.href="<xsl:value-of select="colPath"/><xsl:value-of select="name"/>" and colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
              <xsl:if test="/bedework/appvar[key='catFilter']/value = position()">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="value"/>
            </option>
          </xsl:for-each>
        </select>
        <input type="hidden" name="setappvar" value=""/>
        <input type="hidden" name="start" value="{$curListDate}"/>
        <input type="hidden" name="sort" value="dtstart.utc:asc"/>
        <!--input type="hidden" name="limitdays" value="true"/-->
        <!--input type="hidden" name="useDbSearch" value="true"/-->
        <xsl:if test="/bedework/appvar[key='catFilter'] and /bedework/appvar[key='catFilter']/value != '0'">
          <input type="button" value="{$bwStr-EvLs-ClearFilter}" onclick="this.form.fexpr.selectedIndex = 0; this.form.setappvar.value = 'catFilter(0)'; this.form.submit();"/>
        </xsl:if>
      </form>
    </div>
    <xsl:call-template name="eventListCommon"/>

    <div class="bwEventListNav">
      <button onclick="location.href='{$event-nextUpdateList}&amp;prev=prev&amp;sort=dtstart.utc:asc'">&#9668; <xsl:copy-of select="$bwStr-EvLs-Previous"/></button>
      <button onclick="location.href='{$event-nextUpdateList}&amp;next=next&amp;sort=dtstart.utc:asc'"><xsl:copy-of select="$bwStr-EvLs-Next"/> &#9658;</button>
    </div>
  </xsl:template>

  <xsl:template name="buildListDays">
    <xsl:param name="index">1</xsl:param>
    <xsl:variable name="max" select="/bedework/maxdays"/>
    <xsl:if test="number($index) &lt; number($max)">
      <option value="{$index}">
        <xsl:if test="$index = $curListDays"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:value-of select="$index"/>
      </option>
      <xsl:call-template name="buildListDays">
        <xsl:with-param name="index"><xsl:value-of select="number($index)+1"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>