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

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event" mode="singleEvent">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="name" select="name"/>
    <xsl:variable name="guidEsc" select="translate(guid, '.', '_')" />
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="singleEvent">

      <div id="eventIcons" class="icons">
        <xsl:variable name="gStartdate" select="start/utcdate" />
        <xsl:variable name="gLocation"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="location/address" /></xsl:call-template></xsl:variable>
        <xsl:variable name="gEnddate" select="end/utcdate" />
        <xsl:variable name="gText"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="summary" /></xsl:call-template></xsl:variable>
        <xsl:variable name="gDetails"><xsl:call-template name="escapeJson"><xsl:with-param name="string" select="description" /></xsl:call-template></xsl:variable>

        <a class="linkBack" href="{$setSelectionList}">
          <xsl:if test="/bedework/appvar[key='listPage']/value = 'eventscalendar'">
            <xsl:attribute name="href"><xsl:value-of select="$setSelection"/></xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$bwStr-HdBr-BackLink"/>
        </a>

        <xsl:if test="$eventIconDownloadIcs = 'true'">
          <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
          <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-Download}">
            <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" alt="{$bwStr-SgEv-Download}"/>
          </a>
        </xsl:if>
        <xsl:if test="$eventIconAddToMyCal = 'true'">
          <a class="eventIcons" href="{$privateCal}/event/addEventSub.do?calPath={$calPath}&amp;eventName={$name}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-AddEventToMyCalendar}" target="myCalendar">
            <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
          </a>
        </xsl:if>
        <xsl:if test="$eventIconGoogleCal = 'true'">
          <a href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
            <img title="{$bwStr-SgEv-AddToGoogleCalendar}" src="{$resourcesRoot}/images/gcal_small.gif" alt="{$bwStr-SgEv-AddToGoogleCalendar}"/>
          </a>
        </xsl:if>
        <xsl:if test="$eventIconShareThis = 'true'">
           <xsl:variable name="shareURL"><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?b=de&amp;calPath=/public/cals/MainCal&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></xsl:variable>
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
           <span id="st_button1_{$guid}_{$recurrenceId}">
             <script language="javascript" type="text/javascript">
                 stWidget.addEntry({
                   "service":"sharethis",
                   "element":document.getElementById('st_button1_<xsl:value-of select="$guid"/>_<xsl:value-of select="$recurrenceId"/>'),
                   "title":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$gText"/></xsl:call-template>',
                   "content":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$noNewLineDetails"/></xsl:call-template>',
                   "summary":'<xsl:value-of select="$shareThisSummary"/>',
                   "url":'<xsl:value-of select="$encodedShareURL"/>'
                 });
             </script>
           </span>
        </xsl:if>
      </div>

      <h2 class="{$statusClass} eventTitle">
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="summary" />
        <xsl:if test="summary = ''">
          <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
        </xsl:if>
      </h2>

      <xsl:if test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
        <xsl:variable name="imgPrefix">
          <xsl:choose>
            <xsl:when test="starts-with(xproperties/X-BEDEWORK-IMAGE/values/text,'http')"></xsl:when>
            <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <img class="bwEventImage img-responsive">
          <xsl:attribute name="src"><xsl:value-of select="$imgPrefix"/><xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" /></xsl:attribute>
        </img>
      </xsl:if>

      <div class="eventWhen">
        <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-When"/><xsl:text> </xsl:text></span>
        <xsl:value-of select="start/dayname" />,
        <xsl:value-of select="start/longdate" />
        <xsl:text> </xsl:text>
        <xsl:if test="start/allday = 'false'">
          <span class="time">
            <xsl:value-of select="start/time" />
          </span>
        </xsl:if>
        <xsl:if
          test="(end/longdate != start/longdate) or
                ((end/longdate = start/longdate) and (end/time != start/time))">
          -
        </xsl:if>
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="substring(end/dayname,1,3)" />
          ,
          <xsl:value-of select="end/longdate" />
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="start/allday = 'true'">
            <span class="time">
              <em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em>
            </span>
          </xsl:when>
          <xsl:when test="end/longdate != start/longdate">
            <span class="time">
              <xsl:value-of select="end/time" />
            </span>
          </xsl:when>
          <xsl:when test="end/time != start/time">
            <span class="time">
              <xsl:value-of select="end/time" />
            </span>
          </xsl:when>
        </xsl:choose>
        <!-- if timezones are not local, or if floating add labels: -->
        <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
          <xsl:text> </xsl:text>
          --
          <strong>
            <xsl:choose>
              <xsl:when test="start/floating = 'true'">
                <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$bwStr-SgEv-LocalTime"/>
              </xsl:otherwise>
            </xsl:choose>
          </strong>
          <br/>
        </xsl:if>
        <!-- display in timezone if not local or floating time) -->
        <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
          <xsl:choose>
            <xsl:when test="start/timezone/id != end/timezone/id">
              <!-- need to display both timezones if they differ from start to end -->
              <div class="tzdates">
                <em><xsl:copy-of select="$bwStr-SgEv-Start"/><xsl:text> </xsl:text></em>
                <xsl:choose>
                  <xsl:when test="start/timezone/islocal='true'">
                    <xsl:value-of select="start/dayname"/>,
                    <xsl:value-of select="start/longdate"/>
                    <xsl:text> </xsl:text>
                    <span class="time"><xsl:value-of select="start/time"/></span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="start/timezone/dayname"/>,
                    <xsl:value-of select="start/timezone/longdate"/>
                    <xsl:text> </xsl:text>
                    <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                  </xsl:otherwise>
                </xsl:choose>
                --
                <strong><xsl:value-of select="start/timezone/id"/></strong>
                <br/>
                <em><xsl:copy-of select="$bwStr-SgEv-End"/><xsl:text> </xsl:text></em>
                <xsl:choose>
                  <xsl:when test="end/timezone/islocal='true'">
                    <xsl:value-of select="end/dayname"/>,
                    <xsl:value-of select="end/longdate"/>
                    <xsl:text> </xsl:text>
                    <span class="time"><xsl:value-of select="end/time"/></span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="end/timezone/dayname"/>,
                    <xsl:value-of select="end/timezone/longdate"/>
                    <xsl:text> </xsl:text>
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:otherwise>
                </xsl:choose>
                --
                <strong><xsl:value-of select="end/timezone/id"/></strong>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <!-- otherwise, timezones are the same: display as a single line  -->
              <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
              <xsl:if test="start/allday = 'false'">
                <span class="time"><xsl:value-of select="start/timezone/time"/></span>
              </xsl:if>
              <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                            ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
              <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="start/allday = 'true'">
                  <span class="time"><em> <xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
                </xsl:when>
                <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                  <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                </xsl:when>
                <xsl:when test="end/timezone/time != start/timezone/time">
                  <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                </xsl:when>
              </xsl:choose>
              <xsl:text> </xsl:text>
              --
              <strong><xsl:value-of select="start/timezone/id"/></strong>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </div>

      <div class="eventWhere">
        <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Where"/><xsl:text> </xsl:text></span>
        <xsl:choose>
          <xsl:when test="location/link=''">
            <xsl:value-of select="location/address" />
            <xsl:text> </xsl:text>
            <xsl:if test="location/subaddress!=''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="location/subaddress" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="location/link"/></xsl:attribute>
              <xsl:value-of select="location/address"/>
              <xsl:if test="location/subaddress!=''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="location/subaddress" />
              </xsl:if>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </div>

      <xsl:if test="cost!=''">
        <div class="eventCost">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Cost"/><xsl:text> </xsl:text></span>
          <xsl:value-of select="cost" />
        </div>
      </xsl:if>

      <xsl:if test="link != ''">
        <div class="eventLink">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-See"/><xsl:text> </xsl:text></span>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
              <xsl:value-of select="link"/>
            </a>
        </div>
      </xsl:if>

      <div class="eventDescription">
        <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Description"/><xsl:text> </xsl:text></span>
        <!-- to preserve line breaks in descriptions, set <br/> as the replacement string
             in this replace template call: -->
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="description" />
          <xsl:with-param name="pattern" select="'&#xA;'" />
          <xsl:with-param name="replacement"><br/></xsl:with-param>
        </xsl:call-template>
      </div>

      <!--   <div class="eventListingCal">
        <xsl:if test="calendar/path!=''">
        Calendar:
        <xsl:variable name="calUrl" select="calendar/encodedPath"/>
        <a href="{$setSelection}&amp;calUrl={$calUrl}">
        <xsl:value-of select="calendar/name"/>
        </a>
        </xsl:if>
        </div>-->

      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <div class="eventStatus">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-STATUS"/><xsl:text> </xsl:text></span>
          <xsl:value-of select="status" />
        </div>
      </xsl:if>

      <xsl:if test="contact/name!='None'">
        <div class="eventContact">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Contact"/><xsl:text> </xsl:text></span>
          <xsl:choose>
            <xsl:when test="contact/link=''">
              <xsl:value-of select="contact/name" />
            </xsl:when>
            <xsl:otherwise>
              <a>
                <xsl:attribute name="href"><xsl:value-of select="contact/link" /></xsl:attribute>
                <xsl:value-of select="contact/name" />
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="contact/phone!=''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="contact/phone" />
          </xsl:if>
          <xsl:if test="contact/link!=''">
            <xsl:text> </xsl:text>
            <xsl:variable name="contactLink"
              select="contact/link" />
            <a href="{$contactLink}">
              <xsl:value-of select="$contactLink" />
            </a>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
        <div class="eventAliases">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-TopicalArea"/><xsl:text> </xsl:text></span>
          <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
            <xsl:variable name="calUrl" select="values/text"/>
            <!-- Check for a display name; this is required for backwards compatibility with old events - possibly with imported events;
                 here we use the alias path value for display (as of 3.7 we use the display name (summary)) -->
            <xsl:variable name="calDisplayName">
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
            </xsl:variable>
            <!--a href="javascript:bwReplaceFilters('{$calUrl}');"-->
              <xsl:value-of select="$calDisplayName"/>
            <!--/a-->
            <xsl:if test="position()!=last()">, </xsl:if>
          </xsl:for-each>
        </div>
      </xsl:if>

      <!-- To enable viewing of categories, uncomment the following block: -->
      <!--
      <xsl:if test="categories[1]/category">
        <div class="eventCategories">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Categories"/><xsl:text> </xsl:text></span>
          <xsl:for-each select="categories/category">
            <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
          </xsl:for-each>
        </div>
      </xsl:if>
      -->

      <xsl:if test="$eventRegEnabled and xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']">
        <div id="bwRegistrationBox">
          <xsl:variable name="eventName"><xsl:value-of select="name"/></xsl:variable>
          <iframe src="{$eventReg}?href={$calPath}%2F{$eventName}" width="300" height="175">
	          <p>
			        <xsl:copy-of select="$bwStr-Error-IframeUnsupported"/>
			      </p>
		      </iframe>
        </div>
      </xsl:if>

      <xsl:if test="comments/comment">
        <div class="eventComments">
          <span class="infoTitle"><xsl:copy-of select="$bwStr-SgEv-Comments"/><xsl:text> </xsl:text></span>
          <xsl:for-each select="comments/comment">
            <p>
              <xsl:value-of select="value" />
            </p>
          </xsl:for-each>
        </div>
      </xsl:if>
    </div>

  </xsl:template>

</xsl:stylesheet>
