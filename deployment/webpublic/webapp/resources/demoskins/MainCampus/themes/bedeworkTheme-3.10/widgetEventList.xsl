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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" media-type="text/html"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    HTML WIDGET - GENERATE HTML EVENT LIST

    ===============================================================  -->

  <!-- Output the event list as an html data island -->
  <xsl:template match="events" mode="widgetEventList">
    <ul>
      <xsl:choose>
        <xsl:when test="not(event)">
          <script type="text/javascript">
            // We have no more events: turn off scrolling update, and remove
            // "Load more events" link (if they exist)
            $(document).ready(function () {
              $(window).off("scroll",bwScroll);
              $("#loadMoreEventsLink").remove();
            });
          </script>
          <li>
             <xsl:copy-of select="$bwStr-LsEv-NoEventsToDisplay"/>
          </li>
        </xsl:when>
        <xsl:otherwise>
          <script type="text/javascript">
            // add more events when we scroll
            $(document).ready(function () {
              $(window).on("scroll",bwScroll);
            });
          </script>
          <xsl:for-each select="event">
            <xsl:variable name="id" select="id"/>
            <xsl:variable name="calPath" select="calendar/encodedPath"/>
            <xsl:variable name="guid" select="guid"/>
            <xsl:variable name="guidEsc" select="translate(guid, '.', '_')"/>
            <xsl:variable name="recurrenceId" select="recurrenceId"/>
            <xsl:variable name="lastStartDate" select="preceding-sibling::event[1]/start/unformatted"/>

            <!-- print out a date separator if enabled in themeSettings.xsl -->
            <xsl:if test="($useDateSeparatorsInList = 'true') and (start/unformatted != $lastStartDate)">
              <li class="bwDateRow"><xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/> :: <xsl:value-of select="$lastStartDate"/></li>
            </xsl:if>

            <!-- generate the event -->
            <li>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
                  <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
                  <xsl:when test="position() mod 2 = 0">even</xsl:when>
                  <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>

              <!-- event icons -->
              <span class="icons">
                <xsl:variable name="gStartdate" select="start/utcdate"/>
                <xsl:variable name="gLocation"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="location/address" /></xsl:call-template></xsl:variable>
                <xsl:variable name="gEnddate" select="end/utcdate"/>
                <xsl:variable name="gText"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="summary" /></xsl:call-template></xsl:variable>
                <xsl:variable name="gDetails" select="$gText"/><!-- this could be changed to better reflect the details -->

                <xsl:if test="$eventIconDownloadIcs = 'true'">
                  <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
                  <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-Download}">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" alt="{$bwStr-SgEv-Download}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconAddToMyCal = 'true'">
                  <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconGoogleCal = 'true'">
                  <a href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
                    <img title="{$bwStr-SgEv-AddToGoogleCalendar}" src="{$resourcesRoot}/images/gcal_small.gif" alt="{$bwStr-SgEv-AddToGoogleCalendar}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconShareThis = 'true'">
                  <xsl:variable name="shareURL"><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?b=de>&amp;calPath=/public/cals/MainCal&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></xsl:variable>
                  <xsl:variable name="encodedShareURL">
                    <xsl:call-template name="url-encode">
                      <xsl:with-param name="str" select="$shareURL"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="noNewLineDetails">
                    <xsl:call-template name="replace">
                      <xsl:with-param name="string" select="description"/>
                      <xsl:with-param name="pattern" select="'&#xa;'"/>
                      <xsl:with-param name="substitution" select="''"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="shareThisId">shareThis-<xsl:value-of select="generate-id()"/><xsl:value-of select="recurrenceId"/></xsl:variable>
                  <span id="{$shareThisId}">
                    <script language="javascript" type="text/javascript">
                      stWidget.addEntry({
                        "service":"sharethis",
                        "element":document.getElementById('<xsl:value-of select="$shareThisId"/>'),
                        "title":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$gText"/></xsl:call-template>',
                        "content":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$noNewLineDetails"/></xsl:call-template>',
                        "summary":'<xsl:value-of select="$shareThisSummary"/>',
                        "url":'<xsl:value-of select="$encodedShareURL"/>'
                      });
                    </script>
                  </span>
                </xsl:if>
              </span>

              <!-- event thumbnail -->
              <xsl:if test="xproperties/X-BEDEWORK-IMAGE or $usePlaceholderThumb = 'true'">
                <xsl:variable name="imgPrefix">
                  <xsl:choose>
                    <xsl:when test="starts-with(xproperties/X-BEDEWORK-IMAGE/values/text,'http')"></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="imgThumbPrefix">
                  <xsl:choose>
                    <xsl:when test="starts-with(xproperties/X-BEDEWORK-THUMB-IMAGE/values/text,'http')"></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <img class="eventThumb img-responsive">
                    <xsl:attribute name="width"><xsl:value-of select="$thumbWidth"/></xsl:attribute>
                    <xsl:attribute name="src">
                      <xsl:choose>
                        <xsl:when test="xproperties/X-BEDEWORK-THUMB-IMAGE"><xsl:value-of select="$imgThumbPrefix"/><xsl:value-of select="xproperties/X-BEDEWORK-THUMB-IMAGE/values/text"/></xsl:when>
                        <xsl:when test="xproperties/X-BEDEWORK-IMAGE and $useFullImageThumbs = 'true'"><xsl:value-of select="$imgPrefix"/><xsl:value-of select="xproperties/X-BEDEWORK-IMAGE/values/text"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$resourcesRoot"/>/images/placeholder.png</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select="summary"/></xsl:attribute>
                  </img>
                </a>
              </xsl:if>

              <div class="eventListContent">
                <xsl:if test="xproperties/X-BEDEWORK-IMAGE or $usePlaceholderThumb = 'true'">
                  <xsl:attribute name="class">eventListContent withImage</xsl:attribute>
                </xsl:if>

                <!-- event title -->
                <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                <xsl:if test="status='TENTATIVE'"><strong><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></strong></xsl:if>
                <h4 class="bwSummary">
                  <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                    <xsl:value-of select="summary"/>
                    <xsl:if test="summary = ''">
                      <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
                    </xsl:if>
                  </a>
                </h4>

                <xsl:value-of select="substring(start/dayname,1,3)"/>,
                <xsl:value-of select="start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:if test="start/allday != 'true'">
                  <xsl:value-of select="start/time"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/shortdate != end/shortdate">
                    -
                    <xsl:value-of select="substring(end/dayname,1,3)"/>,
                    <xsl:value-of select="end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:if test="start/allday != 'true'">
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="start/time != end/time">
                      -
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>

                <br/>
                <xsl:copy-of select="$bwStr-LsVw-Location"/><xsl:text> </xsl:text>
                <xsl:value-of select="location/address"/>
                <xsl:if test="location/subaddress != ''">
                  , <xsl:value-of select="location/subaddress"/>
                </xsl:if>

                <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <br/>
                  <xsl:value-of select="description"/>
                  <xsl:if test="link != ''">
                    <br/>
                    <xsl:variable name="link" select="link"/>
                    <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                  </xsl:if>
                  <xsl:if test="categories/category">
                    <br/>
                    <xsl:copy-of select="$bwStr-LsEv-Categories"/>
                    <xsl:for-each select="categories/category">
                      <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                  <br/>
                  <em>
                    <xsl:if test="cost!=''">
                      <xsl:value-of select="cost"/>.&#160;
                    </xsl:if>
                    <xsl:if test="contact/name!='none'">
                      <xsl:copy-of select="$bwStr-LsEv-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
                    </xsl:if>
                  </em>
                </xsl:if>

                <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                  <br/>
                  <xsl:copy-of select="$bwStr-LsVw-TopicalArea"/><xsl:text> </xsl:text>
                  <span class="eventSubscription">
                    <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                      <xsl:choose>
                        <xsl:when test="parameters/X-BEDEWORK-PARAM-DISPLAYNAME">
                          <xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="substring-afterLastInstanceOf">
                            <xsl:with-param name="string" select="values/text"/>
                            <xsl:with-param name="char">/</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="position()!=last()">, </xsl:if>
                    </xsl:for-each>
                  </span>
                </xsl:if>
              </div>
              <br class="clear"/>

            </li>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

</xsl:stylesheet>
