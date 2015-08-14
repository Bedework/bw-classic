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

  <!--+++++++++++++++ Suggestion Queue Tab ++++++++++++++++++++-->
  <xsl:template name="tabSuggestionQueueEvents">
    <h2><xsl:copy-of select="$bwStr-TaAQ-SuggestionQueueEvents"/></h2>
    <xsl:variable name="bwSuggestTabP"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo") and suggested-to="P:<xsl:value-of
            select="/bedework/currentCalSuite/groupHref"/>")&amp;listAllEvents=true&amp;sort=dtstart.utc:asc&amp;setappvar=suggestType(P)</xsl:variable>
    <xsl:variable name="bwSuggestTabA"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo") and suggested-to="A:<xsl:value-of
            select="/bedework/currentCalSuite/groupHref"/>")&amp;listAllEvents=true&amp;sort=dtstart.utc:asc&amp;setappvar=suggestType(A)</xsl:variable>
    <xsl:variable name="bwSuggestTabR"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo") and suggested-to="R:<xsl:value-of
            select="/bedework/currentCalSuite/groupHref"/>")&amp;listAllEvents=true&amp;sort=dtstart.utc:asc&amp;setappvar=suggestType(R)</xsl:variable>
    <div id="refreshBwList">
      <div id="refreshBwListControls">
        <xsl:copy-of select="$bwStr-TaAQ-View"/>
        <input type="radio" name="suggestedListType" id="bwSuggestTabP" onclick="location.href='{$bwSuggestTabP}'">
          <xsl:if test="not(/bedework/appvar[key='suggestType']) or /bedework/appvar[key='suggestType']/value = 'P'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="bwSuggestTabP"><xsl:copy-of select="$bwStr-TaAQ-Suggested"/></label>
        <input type="radio" name="suggestedListType" id="bwSuggestTabA" onclick="location.href='{$bwSuggestTabA}'">
          <xsl:if test="/bedework/appvar[key='suggestType']/value = 'A'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="bwSuggestTabA"><xsl:copy-of select="$bwStr-TaAQ-Accepted"/></label>
        <input type="radio" name="suggestedListType" id="bwSuggestTabR" onclick="location.href='{$bwSuggestTabR}'">
          <xsl:if test="/bedework/appvar[key='suggestType']/value = 'R'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="bwSuggestTabR"><xsl:copy-of select="$bwStr-TaAQ-Rejected"/></label>
      </div>
    </div>
    <p><xsl:copy-of select="$bwStr-TaAQ-SuggestedEvents"/></p>
    <xsl:call-template name="eventListCommon">
      <xsl:with-param name="suggestionQueue">true</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>