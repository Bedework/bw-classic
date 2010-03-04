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

  <xsl:template name="featuredEvents">
    <xsl:if test="$featuredEventsAlwaysOn = 'true' or
                 ($featuredEventsForEventDisplay = 'true' and /bedework/page = 'event') or
                 ($featuredEventsForCalList = 'true' and /bedework/page = 'calendarList') or
                 (/bedework/page = 'eventscalendar' and (
                   ($featuredEventsForDay = 'true' and /bedework/periodname = 'Day') or
                   ($featuredEventsForWeek = 'true' and /bedework/periodname = 'Week') or
                   ($featuredEventsForMonth = 'true' and /bedework/periodname = 'Month') or
                   ($featuredEventsForYear = 'true' and /bedework/periodname = 'Year')))">
      <div id="feature">
        <!-- pulls in the first three images from the FeaturedEvent.xml document -->
        <xsl:apply-templates select="document('../../themes/bedeworkTheme/featured/FeaturedEvent.xml')/featuredEvents/image[position() &lt; 4]" mode="featuredEvents" />
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="image" mode="featuredEvents">
    <xsl:choose>
      <xsl:when test="link = ''">
        <img width="241" height="189">
          <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/featured/<xsl:value-of select="name"/></xsl:attribute>
          <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
          <img width="241" height="189">
            <xsl:attribute name="src"><xsl:value-of select="$resourcesRoot"/>/featured/<xsl:value-of select="name"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
          </img>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
