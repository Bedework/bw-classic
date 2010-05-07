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
  
  <!--==== ADD EVENT ====-->
  <xsl:template match="formElements" mode="addEvent">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$addEvent}" id="standardForm" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}')">
      <h2>
        <span class="formButtons">
          <xsl:apply-templates select="form" mode="addEditEventFormButtons" />
        </span>
        <xsl:choose>
          <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-AddE-AddTask"/></xsl:when>
          <xsl:when test="form/scheduleMethod = '2'"><xsl:copy-of select="$bwStr-AddE-AddMeeting"/></xsl:when>
          <xsl:otherwise><xsl:copy-of select="$bwStr-AddE-AddEvent"/></xsl:otherwise>
        </xsl:choose>
      </h2>
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="formElements" mode="editEvent">
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$updateEvent}" id="standardForm" onsubmit="setEventFields(this,{$portalFriendly},'{$submitter}')">
      <h2>
        <span class="formButtons">
          <xsl:apply-templates select="form" mode="addEditEventFormButtons" />
        </span>
        <xsl:choose>
          <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-EdtE-EditTask"/></xsl:when>
          <xsl:when test="form/scheduleMethod = '2'"><xsl:copy-of select="$bwStr-EdtE-EditMeeting"/></xsl:when>
          <xsl:otherwise><xsl:copy-of select="$bwStr-EdtE-EditEvent"/></xsl:otherwise>
        </xsl:choose>
      </h2>
      <xsl:for-each select="form/xproperties/xproperty">
        <xsl:variable name="xprop"><xsl:value-of select="@name"/><xsl:value-of select="pars"/>:<xsl:value-of select="value"/></xsl:variable>
        <input type="hidden" name="xproperty" value="{$xprop}"/>
      </xsl:for-each>
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>


  <!--==== ADD and EDIT EVENT FORM ====-->
  <xsl:template match="formElements" mode="eventForm">
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <input type="hidden" name="endType" value="date"/>

      <!-- event info for edit event -->
      <xsl:if test="/bedework/creating != 'true'">
        <table class="common" cellspacing="0">
          <tr>
            <th colspan="2" class="commonHeader">
              <div id="eventActions">
                <xsl:choose>
                  <xsl:when test="recurrenceId != ''">
                    <div id="bwDeleteRecurButton" class="bwMenuButton">
                      <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                      <xsl:copy-of select="$bwStr-AEEF-Delete"/>
                      <div id="bwDeleteRecurWidget" class="bwMenuWidget">
                        <ul>
                          <li>
                            <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-DeleteMaster}" onclick="return confirm('{$bwStr-AEEF-DeleteAllRecurrences}');">
                              <xsl:copy-of select="$bwStr-AEEF-All"/>
                            </a>
                          </li>
                          <li>
                            <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="${bwStr-AEEF-DeleteThisInstance}" onclick="return confirm('{$bwStr-AEEF-DeleteThisEvent}');">
                              <xsl:copy-of select="$bwStr-AEEF-Instance"/>
                            </a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-AEEF-DeleteEvent}" class="bwMenuButton" onclick="return confirm('{$bwStr-AEEF-DeleteThisEvent}');">
                      <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                       <xsl:copy-of select="$bwStr-AEEF-Delete"/>
                      <xsl:if test="form/recurringEntity='true'">
                        <xsl:copy-of select="$bwStr-AEEF-All"/>
                      </xsl:if>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="not(form/recurringEntity = 'true' and recurrenceId = '')">
                  <!-- don't display if a master recurring event (because the master can't be viewed) -->
                  <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/glassFill-icon-viewGray.gif" width="13" height="13" border="0" alt="view"/>
                     <xsl:copy-of select="$bwStr-AEEF-View"/>
                  </a>
                </xsl:if>
              </div>
              <!-- Display type of event -->
              <xsl:variable name="entityType">
                <xsl:choose>
                  <xsl:when test="entityType = '2'"><xsl:copy-of select="$bwStr-AEEF-TASK"/></xsl:when>
                  <xsl:when test="scheduleMethod = '2'"><xsl:copy-of select="$bwStr-AEEF-Meeting"/></xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-AEEF-EVENT"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="form/recurringEntity='true' or recurrenceId != ''">
                 <xsl:copy-of select="$bwStr-AEEF-Recurring"/>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="form">
                  <!-- just a placeholder: need to add owner to the jsp -->
                   <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Personal"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:when test="public = 'true'">
                   <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Public"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entityType"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="form/recurringEntity='true' and recurrenceId = ''">
                <xsl:text> </xsl:text>
                <em><xsl:copy-of select="$bwStr-AEEF-RecurrenceMaster"/></em>
              </xsl:if>
            </th>
          </tr>
        </table>
      </xsl:if>

      <!-- event form submenu -->
      <ul id="eventFormTabs" class="submenu">
        <li class="selected">
          <a href="javascript:setTab('eventFormTabs',0); show('bwEventTab-Basic'); hide('bwEventTab-Details','bwEventTab-Recurrence','bwEventTab-Access','bwEventTab-Scheduling');">
            <xsl:copy-of select="$bwStr-AEEF-Basic"/>
          </a>
        </li>
        <li>
          <a href="javascript:setTab('eventFormTabs',1); show('bwEventTab-Details'); hide('bwEventTab-Basic','bwEventTab-Recurrence','bwEventTab-Access','bwEventTab-Scheduling');">
            <xsl:copy-of select="$bwStr-AEEF-Details"/>
          </a>
        </li>
        <li>
          <a href="javascript:setTab('eventFormTabs',2); show('bwEventTab-Recurrence'); hide('bwEventTab-Details','bwEventTab-Basic','bwEventTab-Access','bwEventTab-Scheduling');">
            <xsl:copy-of select="$bwStr-AEEF-Recurrence"/>
          </a>
        </li>
        <li>
          <a href="javascript:setTab('eventFormTabs',3); show('bwEventTab-Scheduling'); hide('bwEventTab-Basic','bwEventTab-Details','bwEventTab-Recurrence','bwEventTab-Access');">
            <xsl:copy-of select="$bwStr-AEEF-Scheduling"/>
          </a>
        </li>
        <!-- Hide from use.  If you wish to enable the access control form for
         events, uncomment this block.
        <li>
          <a href="javascript:setTab('eventFormTabs',4); show('bwEventTab-Access'); hide('bwEventTab-Details','bwEventTab-Basic','bwEventTab-Recurrence','bwEventTab-Scheduling');">
            access
          </a>
        </li>-->
      </ul>

    <!-- Basic tab -->
    <!-- ============== -->
    <!-- this tab is visible by default -->
    <div id="bwEventTab-Basic">
      <table cellspacing="0" class="common dottedBorder">
      
        <!--  Calendar  -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-Calendar"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <!-- the string "user/" should not be hard coded; fix this -->
            <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
            <xsl:variable name="writableCalendars">
              <xsl:value-of select="
                count(/bedework/myCalendars//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content]) +
                count(/bedework/mySubscriptions//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content and
                       (not(contains(path,$userPath)))])"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$writableCalendars = 1">
                <!-- there is only 1 writable calendar, so find it by looking down both trees at once -->
                <xsl:variable name="newCalPath"><xsl:value-of select="/bedework/myCalendars//calendar[calType = '1' and
                         currentAccess/current-user-privilege-set/privilege/write-content]/path"/><xsl:value-of select="/bedework/mySubscriptions//calendar[calType = '1' and
                       currentAccess/current-user-privilege-set/privilege/write-content and
                       (not(contains(path,$userPath)))]/path"/></xsl:variable>

                <input type="hidden" name="newCalPath" value="{$newCalPath}"/>

                <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>
                <span id="bwEventCalDisplay">
                  <xsl:choose>
                    <xsl:when test="contains($newCalPath,$userFullPath)">
                      <xsl:value-of select="substring-after($newCalPath,$userFullPath)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$newCalPath"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </span>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" name="newCalPath" id="bwNewCalPathField">
                  <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                </input>

                <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>
                <span id="bwEventCalDisplay">
                  <xsl:choose>
                    <xsl:when test="contains(form/calendar/path,$userFullPath)">
                      <xsl:value-of select="substring-after(form/calendar/path,$userFullPath)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="form/calendar/path"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> </xsl:text>
                  <!-- this final text element is required to avoid an empty
                       span element which is improperly rendered in the browser -->
                </span>

                <xsl:call-template name="selectCalForEvent"/>

              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        
        <!--  Summary (title) of event  -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-Title"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <xsl:variable name="title" select="form/title/input/@value"/>
            <input type="text" name="summary" size="80" value="{$title}" id="bwEventTitle"/>
          </td>
        </tr>

        <!--  Date and Time -->
        <!--  ============= -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-DateAndTime"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <!-- Set the timefields class for the first load of the page;
                 subsequent changes will take place using javascript without a
                 page reload. -->
            <xsl:variable name="timeFieldsClass">
              <xsl:choose>
                <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- date only event: anniversary event - often interpreted as "all day event" -->
            <xsl:choose>
              <xsl:when test="form/allDay/input/@checked='checked'">
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="true" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="true" id="allDayEndDateField"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                <input type="hidden" name="eventStartDate.dateOnly" value="false" id="allDayStartDateField"/>
                <input type="hidden" name="eventEndDate.dateOnly" value="false" id="allDayEndDateField"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$bwStr-AEEF-AllDay"/>

            <!-- floating event: no timezone (and not UTC) -->
            <xsl:choose>
              <xsl:when test="form/floating/input/@checked='checked'">
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.floating" value="true" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="true" id="endFloating"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off"/>
                <input type="hidden" name="eventStartDate.floating" value="false" id="startFloating"/>
                <input type="hidden" name="eventEndDate.floating" value="false" id="endFloating"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$bwStr-AEEF-Floating"/>

            <!-- store time as coordinated universal time (UTC) -->
            <xsl:choose>
              <xsl:when test="form/storeUTC/input/@checked='checked'">
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="on" checked="checked"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="true" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="true" id="endStoreUTC"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off"/>
                <input type="hidden" name="eventStartDate.storeUTC" value="false" id="startStoreUTC"/>
                <input type="hidden" name="eventEndDate.storeUTC" value="false" id="endStoreUTC"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$bwStr-AEEF-StoreAsUTC"/>

            <br/>
            <div class="dateStartEndBox">
              <strong><xsl:copy-of select="$bwStr-AEEF-Start"/></strong><xsl:text> </xsl:text>
              <div class="dateFields">
                <span class="startDateLabel"><xsl:copy-of select="$bwStr-AEEF-Date"/><xsl:text> </xsl:text></span>
                <xsl:choose>
                  <xsl:when test="$portalFriendly = 'true'">
                    <xsl:copy-of select="/bedework/formElements/form/start/month/*"/>
                    <xsl:copy-of select="/bedework/formElements/form/start/day/*"/>
                    <xsl:choose>
                      <xsl:when test="/bedework/creating = 'true'">
                        <xsl:copy-of select="/bedework/formElements/form/start/year/*"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="/bedework/formElements/form/start/yearText/*"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <script type="text/javascript">
                      <xsl:comment>
                      startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/images/');
                      </xsl:comment>
                    </script>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                    <script type="text/javascript">
                      <xsl:comment>
                      /*$("#bwEventWidgetStartDate").datepicker({
                        defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                      }).attr("readonly", "readonly");
                      $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                      </xsl:comment>
                    </script>
                    <input type="hidden" name="eventStartDate.year">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.month">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.day">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <xsl:copy-of select="form/start/hour/*"/>
                  <xsl:copy-of select="form/start/minute/*"/>
                  <xsl:if test="form/start/ampm">
                    <xsl:copy-of select="form/start/ampm/*"/>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0" alt="bwClock"/></a>

                  <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                    <!--  deprecated: now calling timezone server.  See bedeworkEventForm.js -->
                    <!--
                    <xsl:variable name="startTzId" select="form/start/tzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$startTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                    -->
                  </select>
                </span>
              </div>
            </div>
            <div class="dateStartEndBox">
              <strong>
                <xsl:choose>
                  <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-AEEF-Due"/><xsl:text> </xsl:text></xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-AEEF-End"/><xsl:text> </xsl:text></xsl:otherwise>
                </xsl:choose>
              </strong>
              <xsl:choose>
                <xsl:when test="form/end/type='E'">
                  <input type="radio" name="eventEndType" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:copy-of select="$bwStr-AEEF-Date"/>
              <xsl:text> </xsl:text>
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>invisible</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:choose>
                    <xsl:when test="$portalFriendly = 'true'">
                      <xsl:copy-of select="/bedework/formElements/form/end/dateTime/month/*"/>
                      <xsl:copy-of select="/bedework/formElements/form/end/dateTime/day/*"/>
                      <xsl:choose>
                        <xsl:when test="/bedework/creating = 'true'">
                          <xsl:copy-of select="/bedework/formElements/form/end/dateTime/year/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="/bedework/formElements/form/end/dateTime/yearText/*"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <script type="text/javascript">
                      <xsl:comment>
                        endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/images/');
                      </xsl:comment>
                      </script>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetEndDate" iconURL="{$resourcesRoot}/images/calIcon.gif">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/rfc3339DateTime"/></xsl:attribute>
                        <xsl:text> </xsl:text>
                      </span-->
                      <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                      <script type="text/javascript">
                        <xsl:comment>
                        /*$("#bwEventWidgetEndDate").datepicker({
                          defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                        }).attr("readonly", "readonly");
                        $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');*/
                        </xsl:comment>
                      </script>
                      <input type="hidden" name="eventEndDate.year">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/yearText/input/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.month">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.day">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <xsl:copy-of select="form/end/dateTime/hour/*"/>
                    <xsl:copy-of select="form/end/dateTime/minute/*"/>
                    <xsl:if test="form/end/dateTime/ampm">
                      <xsl:copy-of select="form/end/dateTime/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0" alt="bwClock"/></a>

                    <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                      <!--  deprecated: now calling timezone server.  See bedeworkEventForm.js -->
                      <!--
                      <xsl:variable name="endTzId" select="form/end/dateTime/tzid"/>
                      <xsl:for-each select="/bedework/timezones/timezone">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                            <xsl:if test="$endTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:for-each>
                      -->
                    </select>
                  </span>
                </div>
              </div><br/>
              <div id="clock" class="invisible">
                <xsl:call-template name="clock"/>
              </div>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="form/end/type='D'">
                    <input type="radio" name="eventEndType" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="$bwStr-AEEF-Duration"/>
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="durationHrMinClass">
                  <xsl:choose>
                    <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>shown</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <xsl:choose>
                    <xsl:when test="form/end/duration/weeks/input/@value = '0'">
                    <!-- we are using day, hour, minute format -->
                    <!-- must send either no week value or week value of 0 (zero) -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                        <input type="text" name="eventDuration.daysStr" size="2" id="durationDays">
                          <xsl:attribute name="value">
                            <xsl:choose>
                              <xsl:when test="/bedework/creating='true' and form/allDay/input/@checked='checked'">1</xsl:when>
                              <xsl:when test="/bedework/creating='true' and form/allDay/input/@checked!='checked'">0</xsl:when>
                              <xsl:otherwise><xsl:value-of select="form/end/duration/days/input/@value"/></xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                        </input>
                        <xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <xsl:text> </xsl:text>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <input type="text" name="eventDuration.hoursStr" size="2" id="durationHours">
                            <xsl:attribute name="value">
                              <xsl:choose>
                                <xsl:when test="/bedework/creating='true'">1</xsl:when>
                                <xsl:otherwise><xsl:value-of select="form/end/duration/hours/input/@value"/></xsl:otherwise>
                              </xsl:choose>
                            </xsl:attribute>
                          </input>
                          <xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <xsl:text> </xsl:text>
                          <input type="text" name="eventDuration.minutesStr" size="2" id="durationMinutes">
                            <xsl:attribute name="value">
                              <xsl:choose>
                                <xsl:when test="/bedework/creating='true'">0</xsl:when>
                                <xsl:otherwise><xsl:value-of select="form/end/duration/minutes/input/@value"/></xsl:otherwise>
                              </xsl:choose>
                            </xsl:attribute>
                          </input>
                          <xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AEEF-Or"/></span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AEEF-Or"/></span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div><br/>
              <div class="dateFields" id="noDuration">
                <xsl:choose>
                  <xsl:when test="form/end/type='N'">
                    <input type="radio" name="eventEndType" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="$bwStr-AEEF-This"/><xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-AEEF-Task"/><xsl:text> </xsl:text></xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-AEEF-Event"/><xsl:text> </xsl:text></xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="$bwStr-AEEF-HasNoDurationEndDate"/>
              </div>
            </div>
          </td>
        </tr>

        <!--  Location  -->
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AEEF-Location"/></td>
          <td class="fieldval">
            <span class="std-text"><xsl:copy-of select="$bwStr-AEEF-Choose"/><xsl:text> </xsl:text></span>
            <span id="eventFormLocationList">
              <!--
              <xsl:choose>
                <xsl:when test="/bedework/creating = 'true'">
                  <select name="locationUid">
                    <option value="-1">select...</option>
                    <xsl:copy-of select="form/location/locationmenu/select/*"/>
                  </select>
                </xsl:when>
                <xsl:otherwise>
                  <select name="eventLocationUid">
                    <option value="-1">select...</option>
                    <xsl:copy-of select="form/location/locationmenu/select/*"/>
                  </select>
                </xsl:otherwise>
              </xsl:choose>
              -->
              <select name="locationUid">
                <option value=""><xsl:copy-of select="$bwStr-AEEF-Select"/></option>
                <xsl:copy-of select="form/location/locationmenu/select/*"/>
              </select>
            </span>
            <span class="std-text"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-OrAddNew"/><xsl:text> </xsl:text></span>
            <input type="text" name="locationAddress.value" value="" />
          </td>
        </tr>
        
        <!--  Percent Complete (only for Tasks)  -->
        <xsl:if test="form/entityType = '2'">
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-AEEF-Complete"/><xsl:text> </xsl:text>
            </td>
            <td class="fieldval" align="left">
              <input type="text" name="percentComplete" size="3" maxlength="3">
                <xsl:attribute name="value"><xsl:value-of select="form/percentComplete"/></xsl:attribute>
              </input>%
            </td>
          </tr>
        </xsl:if>

        <!--  Category  -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-Categories"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <xsl:variable name="catCount" select="count(form/categories/all/category)"/>
            <xsl:choose>
              <xsl:when test="not(form/categories/all/category)">
                <xsl:copy-of select="$bwStr-AEEF-NoCategoriesDefined"/>
                <span class="note">(<a href="{$category-initAdd}"><xsl:copy-of select="$bwStr-AEEF-AddCategory"/></a>)</span>
              </xsl:when>
              <xsl:otherwise>
                <table cellpadding="0" id="allCategoryCheckboxes">
                  <tr>
                    <td>
                      <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                        <input type="checkbox" name="catUid"/>
                          <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:if test="uid = form/categories/current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:value-of select="value"/>
                        <br/>
                      </xsl:for-each>
                    </td>
                    <td>
                      <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                        <input type="checkbox" name="catUid"/>
                          <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                          <xsl:if test="uid = form/categories/current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                          <xsl:value-of select="value"/>
                        <br/>
                      </xsl:for-each>
                    </td>
                  </tr>
                </table>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </div>


    <!-- Details tab -->
    <!-- ============== -->
    <div id="bwEventTab-Details" class="invisible">
      <table cellspacing="0" class="common dottedBorder">

        <!--  Link (url associated with event)  -->
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AEEF-EventLink"/><xsl:text> </xsl:text></td>
          <td class="fieldval">
            <xsl:variable name="link" select="form/link/input/@value"/>
            <input type="text" name="eventLink" size="80" value="{$link}"/>
          </td>
        </tr>

        <!--  Description  -->
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AEEF-Description"/><xsl:text> </xsl:text></td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="normalize-space(form/desc/textarea) = ''">
                <textarea name="description" cols="60" rows="4">
                  <xsl:text> </xsl:text>
                </textarea>
                <!-- keep this space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:when>
              <xsl:otherwise>
                <textarea name="description" cols="60" rows="4">
                  <xsl:value-of select="form/desc/textarea"/>
                </textarea>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>

        <!--<tr>
          <td class="fieldname">
            Type:
          </td>
          <td class="fieldval">
            <input type="radio" name="schedule" size="80" value="none" checked="checked">
              <xsl:if test="form/scheduleMethod = '0'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              my event
            </input>
            <input type="radio" name="schedule" size="80" value="request">
              <xsl:if test="form/scheduleMethod = '2'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              meeting request
            </input>
            <input type="radio" name="schedule" size="80" value="publish">
              <xsl:if test="form/scheduleMethod = '1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              published event
            </input>
            <xsl:if test="/bedework/creating = 'false' and form/scheduleMethod = '2'">
              <br/><input type="checkbox" name="schedule" value="reconfirm "/> ask attendees to reconfirm
            </xsl:if>
          </td>
        </tr>-->
        <!--  Recipients and Attendees  -->
        <!--
        <tr>
          <td class="fieldname">
            Recipients &amp;<br/> Attendees:
          </td>
          <td class="fieldval posrelative">
            <input type="button" value="Manage recipients and attendees" onclick="launchSizedWindow('{$event-showAttendeesForEvent}','500','400')" class="small"/>
          </td>
        </tr>-->

        <!--  Status  -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-Status"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <input type="radio" name="eventStatus" value="CONFIRMED">
              <xsl:if test="form/status = 'CONFIRMED' or /bedework/creating = 'true' or form/status = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-Confirmed"/>
            <input type="radio" name="eventStatus" value="TENTATIVE">
              <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-Tentative"/>
            <input type="radio" name="eventStatus" value="CANCELLED">
              <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-Canceled"/>
          </td>
        </tr>

        <!--  Transparency ("Affects free/busy")  -->
        <xsl:if test="form/entityType != '2'"><!-- no transparency for Tasks -->
          <tr>
            <td class="fieldname padMeTop">
              <xsl:copy-of select="$bwStr-AEEF-AffectsFreeBusy"/><xsl:text> </xsl:text>
            </td>
            <td class="fieldval padMeTop">
              <input type="radio" value="OPAQUE" name="transparency">
                <xsl:if test="form/transparency = 'OPAQUE'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-AEEF-Yes"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AEEF-Opaque"/></span><br/>
  
              <input type="radio" value="TRANSPARENT" name="transparency">
                <xsl:if test="form/transparency = 'TRANSPARENT'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-AEEF-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AEEF-Transparent"/></span><br/>
            </td>
          </tr>
        </xsl:if>
      </table>
    </div>


    <!-- Recurrence tab -->
    <!-- ============== -->
    <div id="bwEventTab-Recurrence" class="invisible">
      <xsl:choose>
        <xsl:when test="recurrenceId != ''">
          <!-- recurrence instances can not themselves recur,
               so provide access to master event -->
          <em><xsl:copy-of select="$bwStr-AEEF-ThisEventRecurrenceInstance"/></em><br/>
          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-EditMaster}"><xsl:copy-of select="$bwStr-AEEF-EditMasterEvent"/></a>
        </xsl:when>
        <xsl:otherwise>
          <!-- has recurrenceId, so is master -->
          
          <!-- wrapper for all recurrence fields (rrules and rdates): -->
          <div id="recurrenceFields">
            <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

            <h4><xsl:copy-of select="$bwStr-AEEF-RecurrenceRules"/></h4>
            <!-- show or hide rrules fields when editing: -->
            <xsl:if test="form/recurrence">
              <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on"/>
              <span id="rrulesSwitch">
                <xsl:copy-of select="$bwStr-AEEF-ChangeRecurrenceRules"/>
              </span>
            </xsl:if>
            <span id="rrulesUiSwitch">
              <xsl:if test="form/recurrence">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <input type="checkbox" name="rrulesUiSwitch" value="advanced" onchange="swapVisible(this,'advancedRrules')"/>
              <xsl:copy-of select="$bwStr-AEEF-ShowAdvancedRecurrenceRules"/>
            </span>

            <xsl:if test="form/recurrence">
              <!-- Output descriptive recurrence rules information.  Probably not
                   complete yet. Replace all strings so can be
                   more easily internationalized. -->
              <div id="recurrenceInfo">
                <xsl:copy-of select="$bwStr-AEEF-EVERY"/><xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="form/recurrence/interval &gt; 1">
                    <xsl:value-of select="form/recurrence/interval"/>
                  </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="form/recurrence/freq = 'HOURLY'"><xsl:copy-of select="$bwStr-AEEF-Hour"/></xsl:when>
                  <xsl:when test="form/recurrence/freq = 'DAILY'"><xsl:copy-of select="$bwStr-AEEF-Day"/></xsl:when>
                  <xsl:when test="form/recurrence/freq = 'WEEKLY'"><xsl:copy-of select="$bwStr-AEEF-Week"/></xsl:when>
                  <xsl:when test="form/recurrence/freq = 'MONTHLY'"><xsl:copy-of select="$bwStr-AEEF-Month"/></xsl:when>
                  <xsl:when test="form/recurrence/freq = 'YEARLY'"><xsl:copy-of select="$bwStr-AEEF-Year"/></xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>

                <xsl:if test="form/recurrence/byday">
                  <xsl:for-each select="form/recurrence/byday/pos">
                    <xsl:if test="position() != 1"> <xsl:copy-of select="$bwStr-AEEF-And"/> </xsl:if>
                    <xsl:copy-of select="$bwStr-AEEF-On"/>
                    <xsl:choose>
                      <xsl:when test="@val='1'">
                        <xsl:copy-of select="$bwStr-AEEF-TheFirst"/>
                      </xsl:when>
                      <xsl:when test="@val='2'">
                        <xsl:copy-of select="$bwStr-AEEF-TheSecond"/>
                      </xsl:when>
                      <xsl:when test="@val='3'">
                        <xsl:copy-of select="$bwStr-AEEF-TheThird"/>
                      </xsl:when>
                      <xsl:when test="@val='4'">
                        <xsl:copy-of select="$bwStr-AEEF-TheFourth"/>
                      </xsl:when>
                      <xsl:when test="@val='5'">
                        <xsl:copy-of select="$bwStr-AEEF-TheFifth"/>
                      </xsl:when>
                      <xsl:when test="@val='-1'">
                        <xsl:copy-of select="$bwStr-AEEF-TheLast"/>
                      </xsl:when>
                      <!-- don't output "every" -->
                      <!--<xsl:otherwise>
                        every
                      </xsl:otherwise>-->
                    </xsl:choose>
                    <xsl:for-each select="day">
                      <xsl:if test="position() != 1 and position() = last()"> <xsl:copy-of select="$bwStr-AEEF-And"/> </xsl:if>
                      <xsl:variable name="dayVal" select="."/>
                      <xsl:variable name="dayPos">
                        <xsl:for-each select="/bedework/recurdayvals/val">
                          <xsl:if test="node() = $dayVal"><xsl:value-of select="position()"/></xsl:if>
                        </xsl:for-each>
                      </xsl:variable>
                      <xsl:value-of select="/bedework/shortdaynames/val[position() = $dayPos]"/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:if>

                <xsl:if test="form/recurrence/bymonth">
                  <xsl:copy-of select="$bwStr-AEEF-In"/>
                  <xsl:for-each select="form/recurrence/bymonth/val">
                    <xsl:if test="position() != 1 and position() = last()"> <xsl:copy-of select="$bwStr-AEEF-And"/> </xsl:if>
                    <xsl:variable name="monthNum" select="number(.)"/>
                    <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </xsl:if>

                <xsl:if test="form/recurrence/bymonthday">
                  <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                  <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                  <xsl:copy-of select="$bwStr-AEEF-DayOfTheMonth"/>
                </xsl:if>

                <xsl:if test="form/recurrence/byyearday">
                  <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                  <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                  <xsl:copy-of select="$bwStr-AEEF-DayOfTheYear"/>
                </xsl:if>

                <xsl:if test="form/recurrence/byweekno">
                  <xsl:copy-of select="$bwStr-AEEF-InThe"/>
                  <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                  <xsl:copy-of select="$bwStr-AEEF-WeekOfTheYear"/>
                </xsl:if>

                <xsl:copy-of select="$bwStr-AEEF-Repeating"/>
                <xsl:choose>
                  <xsl:when test="form/recurrence/count = '-1'"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Forever"/></xsl:when>
                  <xsl:when test="form/recurrence/until">
                    <xsl:copy-of select="$bwStr-AEEF-Until"/> <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="form/recurrence/count"/>
                    <xsl:copy-of select="$bwStr-AEEF-Time"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:if>

            <!-- set these dynamically when form is submitted -->
            <input type="hidden" name="interval" value=""/>
            <input type="hidden" name="count" value=""/>
            <input type="hidden" name="until" value=""/>
            <input type="hidden" name="byday" value=""/>
            <input type="hidden" name="bymonthday" value=""/>
            <input type="hidden" name="bymonth" value=""/>
            <input type="hidden" name="byweekno" value=""/>
            <input type="hidden" name="byyearday" value=""/>
            <input type="hidden" name="wkst" value=""/>
            <input type="hidden" name="setpos" value=""/>

            <!-- wrapper for rrules: -->
            <table id="rrulesTable" cellspacing="0">
              <xsl:if test="form/recurrence">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <tr>
                <td id="recurrenceFrequency" rowspan="2">
                  <em><xsl:copy-of select="$bwStr-AEEF-Frequency"/></em><br/>
                  <input type="radio" name="freq" value="NONE" onclick="showRrules(this.value)" checked="checked"/><xsl:copy-of select="$bwStr-AEEF-None"/><br/>
                  <!--<input type="radio" name="freq" value="HOURLY" onclick="showRrules(this.value)"/>hourly<br/>-->
                  <input type="radio" name="freq" value="DAILY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Daily"/><br/>
                  <input type="radio" name="freq" value="WEEKLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Weekly"/><br/>
                  <input type="radio" name="freq" value="MONTHLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Monthly"/><br/>
                  <input type="radio" name="freq" value="YEARLY" onclick="showRrules(this.value)"/><xsl:copy-of select="$bwStr-AEEF-Yearly"/>
                </td>
                <!-- recurrence count, until, forever -->
                <td id="recurrenceUntil">
                  <div id="noneRecurrenceRules">
                    <xsl:copy-of select="$bwStr-AEEF-NoRecurrenceRules"/>
                  </div>
                  <div id="recurrenceUntilRules" class="invisible">
                    <em><xsl:copy-of select="$bwStr-AEEF-Repeat"/></em>
                    <p>
                      <input type="radio" name="recurCountUntil" value="forever">
                        <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Forever"/>
                      <input type="radio" name="recurCountUntil" value="count" id="recurCount">
                        <xsl:if test="form/recurring/count != '-1'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      <input type="text" value="1" size="2" name="countHolder"  onfocus="selectRecurCountUntil('recurCount')">
                        <xsl:if test="form/recurring/count and form/recurring/count != '-1'">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurring/count"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Time"/>
                      <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                        <xsl:if test="form/recurring/until">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Until"/>
                      <span id="untilHolder">
                        <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetUntilDate" iconURL="{$resourcesRoot}/images/calIcon.gif">
                          <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                          <xsl:text> </xsl:text>
                        </span -->
                        <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                        <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
                        <script type="text/javascript">
                          <xsl:comment>
                          /*$("#bwEventWidgetUntilDate").datepicker({
                            <xsl:choose>
                              <xsl:when test="form/recurrence/until">
                                defaultDate: new Date(<xsl:value-of select="substring(form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(form/recurrence/until,7,2)"/>),
                              </xsl:when>
                              <xsl:otherwise>
                                defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                              </xsl:otherwise>
                            </xsl:choose>
                            altField: "#bwEventUntilDate",
                            altFormat: "yymmdd"
                          }).attr("readonly", "readonly");
                          $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                          </xsl:comment>
                        </script>
                      </span>
                    </p>
                  </div>
                </td>
              </tr>
              <tr>
                <td id="advancedRrules" class="invisible">
                  <!-- hourly -->
                  <div id="hourlyRecurrenceRules" class="invisible">
                    <p>
                      <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                      <xsl:copy-of select="$bwStr-AEEF-Every"/>
                      <input type="text" name="hourlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Hour"/>
                    </p>
                  </div>
                  <!-- daily -->
                  <div id="dailyRecurrenceRules" class="invisible">
                    <p>
                      <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                      <xsl:copy-of select="$bwStr-AEEF-Every"/>
                      <input type="text" name="dailyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Day"/>
                    </p>
                    <div>
                      <input type="checkbox" name="swapDayMonthCheckBoxList" value="" onclick="swapVisible(this,'dayMonthCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/>
                      <div id="dayMonthCheckBoxList" class="invisible">
                        <xsl:for-each select="/bedework/monthlabels/val">
                          <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                          <span class="chkBoxListItem">
                            <input type="checkbox" name="dayMonths">
                              <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                            </input>
                            <xsl:value-of select="."/>
                          </span>
                          <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                    <!--<p>
                      <input type="checkbox" name="swapDaySetPos" value="" onclick="swapVisible(this,'daySetPos')"/>
                      limit to:
                      <div id="daySetPos" class="invisible">
                      </div>
                    </p>-->
                  </div>
                  <!-- weekly -->
                  <div id="weeklyRecurrenceRules" class="invisible">
                    <p>
                      <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                      <xsl:copy-of select="$bwStr-AEEF-Every"/>
                      <input type="text" name="weeklyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-WeekOn"/>
                    </p>
                    <div id="weekRecurFields">
                      <xsl:call-template name="byDayChkBoxList">
                        <xsl:with-param name="name">byDayWeek</xsl:with-param>
                      </xsl:call-template>
                    </div>
                    <p class="weekRecurLinks">
                      <a href="javascript:recurSelectWeekdays('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekdays"/></a> |
                      <a href="javascript:recurSelectWeekends('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekends"/></a>
                    </p>
                    <p>
                      <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
                      <select name="weekWkst">
                        <xsl:for-each select="/bedework/shortdaynames/val">
                          <xsl:variable name="pos" select="position()"/>
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </p>
                  </div>
                  <!-- monthly -->
                  <div id="monthlyRecurrenceRules" class="invisible">
                    <p>
                      <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                      <xsl:copy-of select="$bwStr-AEEF-Every"/>
                      <input type="text" name="monthlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Month"/>
                    </p>
                    <div id="monthRecurFields">
                      <div id="monthRecurFields1">
                        <xsl:copy-of select="$bwStr-AEEF-On"/>
                        <select name="bymonthposPos1" size="7" onchange="changeClass('monthRecurFields2','shown')">
                          <xsl:call-template name="recurrenceDayPosOptions"/>
                        </select>
                        <xsl:call-template name="byDayChkBoxList"/>
                      </div>
                      <xsl:call-template name="buildRecurFields">
                        <xsl:with-param name="current">2</xsl:with-param>
                        <xsl:with-param name="total">10</xsl:with-param>
                        <xsl:with-param name="name">month</xsl:with-param>
                      </xsl:call-template>
                    </div>
                    <div>
                      <input type="checkbox" name="swapMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'monthDaysCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-OnTheseDays"/><br/>
                      <div id="monthDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">31</xsl:with-param>
                          <xsl:with-param name="name">monthDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </div>
                  </div>
                  <!-- yearly -->
                  <div id="yearlyRecurrenceRules" class="invisible">
                    <p>
                      <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                      <xsl:copy-of select="$bwStr-AEEF-Every"/>
                      <input type="text" name="yearlyInterval" size="2" value="1">
                        <xsl:if test="form/recurrence/interval">
                          <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                        </xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-Year"/>
                    </p>
                    <div id="yearRecurFields">
                      <div id="yearRecurFields1">
                        <xsl:copy-of select="$bwStr-AEEF-On"/>
                        <select name="byyearposPos1" size="7" onchange="changeClass('yearRecurFields2','shown')">
                          <xsl:call-template name="recurrenceDayPosOptions"/>
                        </select>
                        <xsl:call-template name="byDayChkBoxList"/>
                      </div>
                      <xsl:call-template name="buildRecurFields">
                        <xsl:with-param name="current">2</xsl:with-param>
                        <xsl:with-param name="total">10</xsl:with-param>
                        <xsl:with-param name="name">year</xsl:with-param>
                      </xsl:call-template>
                    </div>
                    <div>
                      <input type="checkbox" name="swapYearMonthCheckBoxList" value="" onclick="swapVisible(this,'yearMonthCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/>
                      <div id="yearMonthCheckBoxList" class="invisible">
                        <xsl:for-each select="/bedework/monthlabels/val">
                          <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                          <span class="chkBoxListItem">
                            <input type="checkbox" name="yearMonths">
                              <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                            </input>
                            <xsl:value-of select="."/>
                          </span>
                          <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                        </xsl:for-each>
                      </div>
                    </div>
                    <div>
                      <input type="checkbox" name="swapYearMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'yearMonthDaysCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheMonth"/><br/>
                      <div id="yearMonthDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">31</xsl:with-param>
                          <xsl:with-param name="name">yearMonthDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </div>
                    <div>
                      <input type="checkbox" name="swapYearWeeksCheckBoxList" value="" onclick="swapVisible(this,'yearWeeksCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-InTheseWeeksOfTheYear"/><br/>
                      <div id="yearWeeksCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">53</xsl:with-param>
                          <xsl:with-param name="name">yearWeekBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </div>
                    <div>
                      <input type="checkbox" name="swapYearDaysCheckBoxList" value="" onclick="swapVisible(this,'yearDaysCheckBoxList')"/>
                      <xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheYear"/><br/>
                      <div id="yearDaysCheckBoxList" class="invisible">
                        <xsl:call-template name="buildCheckboxList">
                          <xsl:with-param name="current">1</xsl:with-param>
                          <xsl:with-param name="end">366</xsl:with-param>
                          <xsl:with-param name="name">yearDayBoxes</xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </div>
                    <p>
                      <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
                      <select name="yearWkst">
                        <xsl:for-each select="/bedework/shortdaynames/val">
                          <xsl:variable name="pos" select="position()"/>
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </p>
                  </div>
                </td>
              </tr>
            </table>

            <h4>
              <xsl:copy-of select="$bwStr-AEEF-RecurrenceAndExceptionDates"/>
            </h4>
            <div id="raContent">
              <div class="dateStartEndBox" id="rdatesFormFields">
                <!--
                <input type="checkbox" name="dateOnly" id="rdateDateOnly" onclick="swapRdateAllDay(this)" value="true"/>
                all day
                <input type="checkbox" name="floating" id="rdateFloating" onclick="swapRdateFloatingTime(this)" value="true"/>
                floating
                <input type="checkbox" name="storeUTC" id="rdateStoreUTC" onclick="swapRdateStoreUTC(this)" value="true"/>
                store as UTC<br/>-->
                <div class="dateFields">
                  <!-- input name="eventRdate.date"
                         dojoType="dropdowndatepicker"
                         formatLength="medium"
                         value="today"
                         saveFormat="yyyyMMdd"
                         id="bwEventWidgetRdate"
                         iconURL="{$resourcesRoot}/images/calIcon.gif"/-->
                  <input type="text" name="eventRdate.date" id="bwEventWidgetRdate" size="10"/>
                  <script type="text/javascript">
                    <xsl:comment>
                   /* $("#bwEventWidgetRdate").datepicker({
                      defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                      dateFormat: "yymmdd"
                    }).attr("readonly", "readonly");
                    $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                    </xsl:comment>
                  </script>
                </div>
                <div id="rdateTimeFields" class="timeFields">
                 <select name="eventRdate.hour">
                    <option value="00">00</option>
                    <option value="01">01</option>
                    <option value="02">02</option>
                    <option value="03">03</option>
                    <option value="04">04</option>
                    <option value="05">05</option>
                    <option value="06">06</option>
                    <option value="07">07</option>
                    <option value="08">08</option>
                    <option value="09">09</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12" selected="selected">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="23">23</option>
                  </select>
                  <select name="eventRdate.minute">
                    <option value="00" selected="selected">00</option>
                    <option value="05">05</option>
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="35">35</option>
                    <option value="40">40</option>
                    <option value="45">45</option>
                    <option value="50">50</option>
                    <option value="55">55</option>
                  </select>
                 <xsl:text> </xsl:text>

                  <select name="tzid" id="rdateTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value=""><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                    <!--  deprecated: now calling timezone server.  See bedeworkEventForm.js -->
                    <!--
                    <option value="">select timezone...</option>
                    <xsl:variable name="rdateTzId" select="/bedework/now/defaultTzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$rdateTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                    -->
                  </select>
                </div>
                <xsl:text> </xsl:text>
                <!--bwRdates.update() accepts: date, time, allDay, floating, utc, tzid-->
                <input type="button" name="rdate" value="{$bwStr-AEEF-AddRecurance}" onclick="bwRdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>
                <!-- input type="button" name="exdate" value="{$bwStr-AEEF-AddException}" onclick="bwExdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/-->
                <br class="clear"/>
                <input type="hidden" name="rdates" value="" id="bwRdatesField" />
                <!-- if there are no recurrence dates, the following table will show -->
                <table cellspacing="0" class="invisible" id="bwCurrentRdatesNone">
                  <tr><th><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th></tr>
                  <tr><td><xsl:copy-of select="$bwStr-AEEF-NoRecurrenceDates"/></td></tr>
                </table>

                <!-- if there are recurrence dates, the following table will show -->
                <table cellspacing="0" class="invisible" id="bwCurrentRdates">
                  <tr>
                    <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th>
                  </tr>
                  <tr class="colNames">
                    <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                    <td><xsl:copy-of select="$bwStr-AEEF-TIME"/></td>
                    <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                    <td></td>
                  </tr>
                </table>

                <input type="hidden" name="exdates" value="" id="bwExdatesField" />
                <!-- if there are no exception dates, the following table will show -->
                <table cellspacing="0" class="invisible" id="bwCurrentExdatesNone">
                  <tr><th><xsl:copy-of select="$bwStr-AEEF-ExceptionDates"/></th></tr>
                  <tr><td><xsl:copy-of select="$bwStr-AEEF-NoExceptionDates"/></td></tr>
                </table>

                <!-- if there are exception dates, the following table will show -->
                <table cellspacing="0" class="invisible" id="bwCurrentExdates">
                  <tr>
                    <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-ExceptionDates"/></th>
                  </tr>
                  <tr class="colNames">
          <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                    <td><xsl:copy-of select="$bwStr-AEEF-Time"/></td>
                    <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                    <td></td>
                  </tr>
                </table>
                <p>
                  <xsl:copy-of select="$bwStr-AEEF-ExceptionDatesMayBeCreated"/>
                </p>
              </div>
            </div>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>

    <!-- Access tab -->
    <!-- ========== -->
    <div id="bwEventTab-Access" class="invisible">
      <div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>
    </div>

    <!-- Scheduling tab -->
    <!-- ============== -->
    <div id="bwEventTab-Scheduling" class="invisible">
      <div id="scheduling">
        <xsl:if test="form/attendees/attendee">
          <xsl:apply-templates select="form/attendees">
            <xsl:with-param name="trash">no</xsl:with-param>
          </xsl:apply-templates>
        </xsl:if>
        <!-- Recipients are deprecated -->
        <!--
        <xsl:if test="form/recipients/recipient">
          <xsl:apply-templates select="form/recipients">
            <xsl:with-param name="trash">no</xsl:with-param>
          </xsl:apply-templates>
        </xsl:if>
        -->
        <div class="editAttendees">
          <xsl:choose>
            <xsl:when test="form/organizerSchedulingObject">
              <input name="editEventAttendees" type="submit" value="{$bwStr-AEEF-EditAttendees}"/>
            </xsl:when>
            <xsl:when test="form/attendeeSchedulingObject">
              <p>
                <em>
                  <a href="{$schedule-changeStatus}&amp;initUpdate=yes">
                    <xsl:copy-of select="$bwStr-AEEF-ChangeMyStatus"/>
                  </a>
                </em>
              </p>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="form/entityType = '2'">
                  <input name="makeEventIntoMeeting" type="submit" value="{$bwStr-AEEF-ScheduleThisTask}"/>
                </xsl:when>
                <xsl:otherwise>
                  <input name="makeEventIntoMeeting" type="submit" value="{$bwStr-AEEF-MakeIntoMeeting}"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
    </div>

    <div class="eventSubmitButtons">
      <xsl:apply-templates select="form" mode="addEditEventFormButtons" />
    </div>
  </xsl:template>

  <xsl:template match="form" mode="addEditEventFormButtons">
    <xsl:choose>
      <!-- the following test on the organizerSchedulingObject is not good - will need to fix -->
      <xsl:when test="scheduleMethod = '2' and organizerSchedulingObject">
        <input name="submitAndSend" type="submit" value="{$bwStr-AEEF-SaveAndSendInvites}"/>
        <!-- dissalow: at the moment there's no way to send invitations after the first save
        <input name="submit" type="submit" value="{$bwStr-AEEF-SaveDraft}"/> -->
      </xsl:when>
      <xsl:otherwise>
        <input name="submit" type="submit" value="{$bwStr-AEEF-Save}"/>
      </xsl:otherwise>
    </xsl:choose>
    <input name="cancelled" type="submit" value="{$bwStr-AEEF-Cancel}"/>
  </xsl:template>

  <xsl:template match="val" mode="weekMonthYearNumbers">
    <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
    <xsl:value-of select="."/><xsl:choose>
      <xsl:when test="substring(., string-length(.)-1, 2) = '11' or
                      substring(., string-length(.)-1, 2) = '12' or
                      substring(., string-length(.)-1, 2) = '13'">th</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '1'">st</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '2'">nd</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '3'">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

  <xsl:template name="byDayChkBoxList">
    <xsl:param name="name"/>
    <xsl:for-each select="/bedework/shortdaynames/val">
      <xsl:variable name="pos" select="position()"/>
      <input type="checkbox">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      </input>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="buildCheckboxList">
    <xsl:param name="current"/>
    <xsl:param name="end"/>
    <xsl:param name="name"/>
    <xsl:param name="splitter">10</xsl:param>
    <span class="chkBoxListItem">
      <input type="checkbox">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$current"/></xsl:attribute>
      </input>
      <xsl:value-of select="$current"/>
    </span>
    <xsl:if test="$current mod $splitter = 0"><br/></xsl:if>
    <xsl:if test="$current = $end"><br/></xsl:if>
    <xsl:if test="$current &lt; $end">
      <xsl:call-template name="buildCheckboxList">
        <xsl:with-param name="current"><xsl:value-of select="$current + 1"/></xsl:with-param>
        <xsl:with-param name="end"><xsl:value-of select="$end"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="recurrenceDayPosOptions">
    <option value="0"><xsl:copy-of select="$bwStr-RCPO-None"/></option>
    <option value="1"><xsl:copy-of select="$bwStr-RCPO-TheFirst"/></option>
    <option value="2"><xsl:copy-of select="$bwStr-RCPO-TheSecond"/></option>
    <option value="3"><xsl:copy-of select="$bwStr-RCPO-TheThird"/></option>
    <option value="4"><xsl:copy-of select="$bwStr-RCPO-TheFourth"/></option>
    <option value="5"><xsl:copy-of select="$bwStr-RCPO-TheFifth"/></option>
    <option value="-1"><xsl:copy-of select="$bwStr-RCPO-TheLast"/></option>
    <option value=""><xsl:copy-of select="$bwStr-RCPO-Every"/></option>
  </xsl:template>

  <xsl:template name="buildRecurFields">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <xsl:param name="name"/>
    <div class="invisible">
      <xsl:attribute name="id"><xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current"/></xsl:attribute>
      <xsl:copy-of select="$bwStr-BuRF-And"/>
      <select size="12">
        <xsl:attribute name="name">by<xsl:value-of select="$name"/>posPos<xsl:value-of select="$current"/></xsl:attribute>
        <xsl:if test="$current != $total">
          <xsl:attribute name="onchange">changeClass('<xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current+1"/>','shown')</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="recurrenceDayPosOptions"/>
      </select>
      <xsl:call-template name="byDayChkBoxList"/>
    </div>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildRecurFields">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="buildNumberOptions">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <option value="{$current}"><xsl:value-of select="$current"/></option>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildNumberOptions">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="clock">
    <div id="bwClock">
      <!-- Bedework 24-Hour Clock time selection widget
           used with bwClock.js and bwClock.css -->
      <xsl:variable name="hour24" select="/bedework/hour24"/><!-- true or false -->
      <div id="bwClockClock">
        <img id="clockMap" src="{$resourcesRoot}/images/clockMap.gif" width="368" height="368" border="0" alt="bwClock" usemap="#bwClockMap" />
      </div>
      <div id="bwClockCover">
        &#160;
        <!-- this is a special effect div used simply to cover the pixelated edge
             where the clock meets the clock box title -->
      </div>
      <div id="bwClockBox">
        <h2>
          <xsl:copy-of select="$bwStr-Cloc-Bedework24HourClock"/>
        </h2>
        <div id="bwClockDateTypeIndicator">
          <xsl:copy-of select="$bwStr-Cloc-Type"/>
        </div>
        <div id="bwClockTime">
          <xsl:copy-of select="$bwStr-Cloc-SelectTime"/>
        </div>
        <div id="bwClockSwitch">
          <xsl:copy-of select="$bwStr-Cloc-Switch"/>
        </div>
        <div id="bwClockCloseText">
          <xsl:copy-of select="$bwStr-Cloc-Close"/>
        </div>
        <div id="bwClockCloseButton">
          <a href="javascript:bwClockClose();">X</a>
        </div>
      </div>
      <map name="bwClockMap" id="bwClockMap">
        <area shape="rect" alt="close clock" title="{$bwStr-Cloc-CloseClock}" coords="160,167, 200,200" href="javascript:bwClockClose()"/>
        <area shape="poly" alt="minute 00:55" title="minute 00:55" coords="156,164, 169,155, 156,107, 123,128" href="javascript:bwClockUpdateDateTimeForm('minute','55')" />
        <area shape="poly" alt="minute 00:50" title="minute 00:50" coords="150,175, 156,164, 123,128, 103,161" href="javascript:bwClockUpdateDateTimeForm('minute','50')" />
        <area shape="poly" alt="minute 00:45" title="minute 00:45" coords="150,191, 150,175, 103,161, 103,206" href="javascript:bwClockUpdateDateTimeForm('minute','45')" />
        <area shape="poly" alt="minute 00:40" title="minute 00:40" coords="158,208, 150,191, 105,206, 123,237" href="javascript:bwClockUpdateDateTimeForm('minute','40')" />
        <area shape="poly" alt="minute 00:35" title="minute 00:35" coords="171,218, 158,208, 123,238, 158,261" href="javascript:bwClockUpdateDateTimeForm('minute','35')" />
        <area shape="poly" alt="minute 00:30" title="minute 00:30" coords="193,218, 172,218, 158,263, 209,263" href="javascript:bwClockUpdateDateTimeForm('minute','30')" />
        <area shape="poly" alt="minute 00:25" title="minute 00:25" coords="209,210, 193,218, 209,261, 241,240" href="javascript:bwClockUpdateDateTimeForm('minute','25')" />
        <area shape="poly" alt="minute 00:20" title="minute 00:20" coords="216,196, 209,210, 241,240, 261,206" href="javascript:bwClockUpdateDateTimeForm('minute','20')" />
        <area shape="poly" alt="minute 00:15" title="minute 00:15" coords="216,178, 216,196, 261,206, 261,159" href="javascript:bwClockUpdateDateTimeForm('minute','15')" />
        <area shape="poly" alt="minute 00:10" title="minute 00:10" coords="209,164, 216,178, 261,159, 240,126" href="javascript:bwClockUpdateDateTimeForm('minute','10')" />
        <area shape="poly" alt="minute 00:05" title="minute 00:05" coords="196,155, 209,164, 238,126, 206,107" href="javascript:bwClockUpdateDateTimeForm('minute','5')" />
        <area shape="poly" alt="minute 00:00" title="minute 00:00" coords="169,155, 196,155, 206,105, 156,105" href="javascript:bwClockUpdateDateTimeForm('minute','0')" />
        <area shape="poly" alt="11 PM, 2300 hour" title="11 PM, 2300 hour" coords="150,102, 172,96, 158,1, 114,14" href="javascript:bwClockUpdateDateTimeForm('hour','23',{$hour24})" />
        <area shape="poly" alt="10 PM, 2200 hour" title="10 PM, 2200 hour" coords="131,114, 150,102, 114,14, 74,36" href="javascript:bwClockUpdateDateTimeForm('hour','22',{$hour24})" />
        <area shape="poly" alt="9 PM, 2100 hour" title="9 PM, 2100 hour" coords="111,132, 131,114, 74,36, 40,69" href="javascript:bwClockUpdateDateTimeForm('hour','21',{$hour24})" />
        <area shape="poly" alt="8 PM, 2000 hour" title="8 PM, 2000 hour" coords="101,149, 111,132, 40,69, 15,113" href="javascript:bwClockUpdateDateTimeForm('hour','20',{$hour24})" />
        <area shape="poly" alt="7 PM, 1900 hour" title="7 PM, 1900 hour" coords="95,170, 101,149, 15,113, 1,159" href="javascript:bwClockUpdateDateTimeForm('hour','19',{$hour24})" />
        <area shape="poly" alt="6 PM, 1800 hour" title="6 PM, 1800 hour" coords="95,196, 95,170, 0,159, 0,204" href="javascript:bwClockUpdateDateTimeForm('hour','18',{$hour24})" />
        <area shape="poly" alt="5 PM, 1700 hour" title="5 PM, 1700 hour" coords="103,225, 95,196, 1,205, 16,256" href="javascript:bwClockUpdateDateTimeForm('hour','17',{$hour24})" />
        <area shape="poly" alt="4 PM, 1600 hour" title="4 PM, 1600 hour" coords="116,245, 103,225, 16,256, 41,298" href="javascript:bwClockUpdateDateTimeForm('hour','16',{$hour24})" />
        <area shape="poly" alt="3 PM, 1500 hour" title="3 PM, 1500 hour" coords="134,259, 117,245, 41,298, 76,332" href="javascript:bwClockUpdateDateTimeForm('hour','15',{$hour24})" />
        <area shape="poly" alt="2 PM, 1400 hour" title="2 PM, 1400 hour" coords="150,268, 134,259, 76,333, 121,355" href="javascript:bwClockUpdateDateTimeForm('hour','14',{$hour24})" />
        <area shape="poly" alt="1 PM, 1300 hour" title="1 PM, 1300 hour" coords="169,273, 150,268, 120,356, 165,365" href="javascript:bwClockUpdateDateTimeForm('hour','13',{$hour24})" />
        <area shape="poly" alt="Noon, 1200 hour" title="Noon, 1200 hour" coords="193,273, 169,273, 165,365, 210,364" href="javascript:bwClockUpdateDateTimeForm('hour','12',{$hour24})" />
        <area shape="poly" alt="11 AM, 1100 hour" title="11 AM, 1100 hour" coords="214,270, 193,273, 210,363, 252,352" href="javascript:bwClockUpdateDateTimeForm('hour','11',{$hour24})" />
        <area shape="poly" alt="10 AM, 1000 hour" title="10 AM, 1000 hour" coords="232,259, 214,270, 252,352, 291,330" href="javascript:bwClockUpdateDateTimeForm('hour','10',{$hour24})" />
        <area shape="poly" alt="9 AM, 0900 hour" title="9 AM, 0900 hour" coords="251,240, 232,258, 291,330, 323,301" href="javascript:bwClockUpdateDateTimeForm('hour','9',{$hour24})" />
        <area shape="poly" alt="8 AM, 0800 hour" title="8 AM, 0800 hour" coords="263,219, 251,239, 323,301, 349,261" href="javascript:bwClockUpdateDateTimeForm('hour','8',{$hour24})" />
        <area shape="poly" alt="7 AM, 0700 hour" title="7 AM, 0700 hour" coords="269,194, 263,219, 349,261, 363,212" href="javascript:bwClockUpdateDateTimeForm('hour','7',{$hour24})" />
        <area shape="poly" alt="6 AM, 0600 hour" title="6 AM, 0600 hour" coords="269,172, 269,193, 363,212, 363,155" href="javascript:bwClockUpdateDateTimeForm('hour','6',{$hour24})" />
        <area shape="poly" alt="5 AM, 0500 hour" title="5 AM, 0500 hour" coords="263,150, 269,172, 363,155, 351,109" href="javascript:bwClockUpdateDateTimeForm('hour','5',{$hour24})" />
        <area shape="poly" alt="4 AM, 0400 hour" title="4 AM, 0400 hour" coords="251,130, 263,150, 351,109, 325,68" href="javascript:bwClockUpdateDateTimeForm('hour','4',{$hour24})" />
        <area shape="poly" alt="3 AM, 0300 hour" title="3 AM, 0300 hour" coords="234,112, 251,130, 325,67, 295,37" href="javascript:bwClockUpdateDateTimeForm('hour','3',{$hour24})" />
        <area shape="poly" alt="2 AM, 0200 hour" title="2 AM, 0200 hour" coords="221,102, 234,112, 295,37, 247,11" href="javascript:bwClockUpdateDateTimeForm('hour','2',{$hour24})" />
        <area shape="poly" alt="1 AM, 0100 hour" title="1 AM, 0100 hour" coords="196,96, 221,102, 247,10, 209,-1, 201,61, 206,64, 205,74, 199,75" href="javascript:bwClockUpdateDateTimeForm('hour','1',{$hour24})" />
        <area shape="poly" alt="Midnight, 0000 hour" title="Midnight, 0000 hour" coords="172,96, 169,74, 161,73, 161,65, 168,63, 158,-1, 209,-1, 201,61, 200,62, 206,64, 205,74, 198,75, 196,96, 183,95" href="javascript:bwClockUpdateDateTimeForm('hour','0',{$hour24})" />
      </map>
    </div>
  </xsl:template>
  
</xsl:stylesheet>