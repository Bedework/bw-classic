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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  
  <!--== NOTIFICATIONS ==-->
  <xsl:template match="event" mode="schedNotifications">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="eventName" select="name"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="inboxItemAction">
      <xsl:choose>
        <xsl:when test="scheduleMethod=2"><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:when>
        <xsl:when test="scheduleMethod=3"><xsl:value-of select="$eventView"/></xsl:when>
        <xsl:when test="scheduleMethod=6"><xsl:value-of select="$schedule-processRefresh"/></xsl:when>
        <xsl:when test="scheduleMethod=7"><xsl:value-of select="$eventView"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}">
        <xsl:if test="scheduleMethod=3"><xsl:copy-of select="$bwStr-ScN-Re"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="summary"/>
      </a>
    </li>
  </xsl:template>
  
  
</xsl:stylesheet>