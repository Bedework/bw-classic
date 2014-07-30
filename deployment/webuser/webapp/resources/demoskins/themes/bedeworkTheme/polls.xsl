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

  <xsl:template name="polls">
    <div id="bwPolls">
      <div id="loading">
        Loading
        <div id="progressbar"><xsl:text> </xsl:text></div>
      </div>
      <div id="refresh">
        <button id="refresh-btn">Refresh</button>
      </div>

      <div id="sidepanel">
        <div id="sidebar">
          <div class="sidebar-title">Your Polls<span id="sidebar-new-poll-count">0</span></div>
          <div>
            <button id="sidebar-new-poll">New Poll</button>
            <ul id="sidebar-owned"></ul>
          </div>
          <div class="sidebar-title">Polls to Vote On<span id="sidebar-vote-poll-count">0</span></div>
          <div>
            <ul id="sidebar-voter"></ul>
          </div>
        </div>
      </div>

      <div id="detail">
        <div id="detail-nocontent" class="ui-widget">Select a poll to view its details.</div>
        <div id="editpoll">
          <div id="editpoll-description">
            <div id="editpoll-title-edit-panel" class="ui-widget">
              <label for="editpoll-title-edit">Title: </label>
              <input id="editpoll-title-edit" type="text"/>
            </div>
            <div id="editpoll-title-panel" class="ui-widget">Title: <span id="editpoll-title"><xsl:text> </xsl:text></span></div>
            <div id="editpoll-organizer-panel" class="ui-widget">Organizer: <span id="editpoll-organizer"><xsl:text> </xsl:text></span></div>
            <div id="editpoll-status-panel" class="ui-widget">Status: <span id="editpoll-status"><xsl:text> </xsl:text></span></div>
          </div>
          <div id="editpoll-details">
            <div id="editpoll-tabs">
              <ul>
                <li id="editpoll-events-tab"><a href="#editpoll-events">Choices</a></li>
                <li id="editpoll-voters-tab"><a href="#editpoll-voters">Voters</a></li>
                <li><a href="#editpoll-results">Results</a></li>
              </ul>
              <div id="editpoll-events">
                <div id="editpoll-choicelist"><xsl:text> </xsl:text></div>
                <div id="editpoll-choice">
                  <button id="editpoll-addchoice">Add Choice</button>
                  <div id="editpoll-choiceType">
                    <input type="radio" name="choiceType" id="choiceTypeEvent" checked="checked"/>
                    <label for="choiceTypeEvent">event</label>
                    <input type="radio" name="choiceType" id="choiceTypeTask"/>
                    <label for="choiceTypeTask">task</label>
                  </div>
                </div>
                <div id="choice-widget" class="mfp-hide">
                  <xsl:call-template name="choiceForm"/>
                </div>
              </div>
              <div id="editpoll-voters">
                <div id="editpoll-voterlist"><xsl:text> </xsl:text></div>
                <div id="editpoll-syncAttendees">
                  <input type="checkbox" name="syncPollAttendees" id="syncPollAttendees" checked="checked"/>
                  <label for="syncPollAttendees">synchronize voters with attendees</label>
                </div>
                <button id="editpoll-addvoter">Add Voter</button>
              </div>
              <div id="editpoll-results">
                <div id="editpoll-resultsbox">
                  <table id="editpoll-resulttable">
                    <thead>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                    </thead>
                    <tbody>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                    </tbody>
                    <tfoot>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                      <tr><td><xsl:text> </xsl:text></td></tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
            <button id="editpoll-save">Save</button>
            <button id="editpoll-cancel">Cancel</button>
            <button id="editpoll-done">Done</button>
            <button id="editpoll-delete">Delete Poll</button>
            <button id="editpoll-autofill">Auto Fill</button>
            <!--
            <div id="response-key" class="ui-widget">
              Possible Responses:
              <ul id="response-menu">
                <li><a href="#"><span class="ui-icon ui-icon-close"><xsl:text> </xsl:text></span>No</a></li>
                <li><a href="#"><span class="ui-icon ui-icon-help"><xsl:text> </xsl:text></span>Maybe</a></li>
                <li><a href="#"><span class="ui-icon ui-icon-check"><xsl:text> </xsl:text></span>Ok</a></li>
                <li><a href="#"><span class="ui-icon ui-icon-circle-check"><xsl:text> </xsl:text></span>Best</a></li>
              </ul>
            </div>
            -->
          </div>
        </div>
      </div>
    </div>
    <div id="pollsFooter">&#160;</div>

  </xsl:template>

  <xsl:template name="choiceForm">
    <form name="eventForm" method="post" action="{$updateEvent}" id="standardForm" onsubmit="setEventFields(this)">
      <h2>Add Choice</h2>
      <xsl:for-each select="form/xproperties/xproperty">
        <xsl:variable name="xprop"><xsl:value-of select="@name"/><xsl:value-of select="pars"/>:<xsl:value-of select="value"/></xsl:variable>
        <input type="hidden" name="xproperty" value="{$xprop}"/>
      </xsl:for-each>

      <input type="hidden" name="endType" value="date"/>

      <div id="choiceFormFields">
        <!-- event form submenu -->
        <ul id="eventFormTabs">
          <li class="selected">
            <a href="#bwEventTab-Basic">
              <xsl:copy-of select="$bwStr-AEEF-Basic"/>
            </a>
          </li>
          <li>
            <a href="#bwEventTab-Details">
              <xsl:copy-of select="$bwStr-AEEF-Details"/>
            </a>
          </li>
          <li>
            <a href="#bwEventTab-Recurrence">
              <xsl:copy-of select="$bwStr-AEEF-Recurrence"/>
            </a>
          </li>
          <li>
            <a href="#bwEventTab-Scheduling">
              <xsl:choose>
                <xsl:when test="form/entityType = '2'"> <!-- "scheduling" for a task -->
                  <xsl:copy-of select="$bwStr-AEEF-Scheduling"/>
                </xsl:when>
                <xsl:otherwise> <!-- "meeting" for a normal event -->
                  <xsl:copy-of select="$bwStr-AEEF-Meetingtab"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </li>
        </ul>

        <div id="bwTabContent">
            <!-- Basic tab -->
            <!-- ============== -->
            <!-- this tab is visible by default -->
            <div id="bwEventTab-Basic">
              <table cellspacing="0" class="common">

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

                  <!-- date only event: anniversary event - often interpreted as "all day event" -->
                  <input type="checkbox" name="allDayFlag" id="allDayFlag" value="off"/>
                  <label for="allDayFlag">
                    <xsl:copy-of select="$bwStr-AEEF-AllDay"/>
                  </label>

                  <div id="bwToggleAdvDateTimeSettings">
                    <input type="checkbox" id="advDateTimeToggle"/>
                    <label for="advDateTimeToggle">advanced</label>
                  </div>
                  <span id="bwAdvDateTimeSettings" class="invisible">
                    <input type="checkbox" name="floatingFlag" id="floatingFlag" value="off"/>
                    <label for="floatingFlag"><xsl:copy-of select="$bwStr-AEEF-Floating"/></label>

                    <!-- store time as coordinated universal time (UTC) -->
                    <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" value="off"/>
                    <label for="storeUTCFlag"><xsl:copy-of select="$bwStr-AEEF-StoreAsUTC"/></label>
                  </span>

                  <br/>
                  <div class="dateStartEndBox">
                    <strong><xsl:copy-of select="$bwStr-AEEF-Start"/></strong><xsl:text> </xsl:text>
                    <div class="dateFields">
                      <span class="startDateLabel"><xsl:copy-of select="$bwStr-AEEF-Date"/><xsl:text> </xsl:text></span>
                      <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                    </div>
                    <div class="timeFields" id="startTimeFields">
                      <span id="calWidgetStartTimeHider" class="show">
                        <select name="eventStartDate.hour" id="eventStartDateHour">
                          <xsl:for-each select="/bedework/hourvalues/val">
                            <xsl:variable name="pos" select="position()"/>
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                              <xsl:value-of select="/bedework/hourlabels/val[position() = $pos]"/>
                            </option>
                          </xsl:for-each>
                        </select>
                        <select name="eventStartDate.minute" id="eventStartDateMinute">
                          <xsl:for-each select="/bedework/minvalues/val">
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                              <xsl:value-of select="."/>
                            </option>
                          </xsl:for-each>
                        </select>
                        <xsl:if test="/bedework/hour24 = 'false'">
                          <select name="eventStartDate.ampm" id="eventStartDateAmpm">
                            <xsl:for-each select="/bedework/ampmvalues/val">
                              <option>
                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                <xsl:value-of select="."/>
                              </option>
                            </xsl:for-each>
                          </select>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0" alt="bwClock" id="bwStartClock"/>

                        <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                          <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                          <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                          <!-- options filled from timezone server.  See bedeworkEventForm.js -->
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
                    <input type="radio" name="eventEndType" id="eventEndTypeDateTime" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                    <label for="eventEndTypeDateTime"><xsl:copy-of select="$bwStr-AEEF-Date"/></label>
                    <xsl:text> </xsl:text>
                    <div class="invisible" id="endDateTime">
                      <div class="dateFields">
                        <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                      </div>
                      <div class="timeFields" id="endTimeFields">
                        <span id="calWidgetEndTimeHider" class="show">
                          <select name="eventEndDate.hour" id="eventEndDateHour">
                            <xsl:for-each select="/bedework/hourvalues/val">
                              <xsl:variable name="pos" select="position()"/>
                              <option>
                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                <xsl:value-of select="/bedework/hourlabels/val[position() = $pos]"/>
                              </option>
                            </xsl:for-each>
                          </select>
                          <select name="eventEndDate.minute" id="eventEndDateMinute">
                            <xsl:for-each select="/bedework/minvalues/val">
                              <option>
                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                <xsl:value-of select="."/>
                              </option>
                            </xsl:for-each>
                          </select>
                          <xsl:if test="/bedework/hour24 = 'false'">
                            <select name="eventEndDate.ampm" id="eventEndDateAmpm">
                              <xsl:for-each select="/bedework/ampmvalues/val">
                                <option>
                                  <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                  <xsl:value-of select="."/>
                                </option>
                              </xsl:for-each>
                            </select>
                          </xsl:if>
                          <xsl:text> </xsl:text>
                          <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0" alt="bwClock" id="bwEndClock"/>

                          <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                            <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                            <!--  Timezone options come from the timezone server.  See bedeworkEventForm.js -->
                          </select>
                        </span>
                      </div>
                    </div>
                    <br/>
                    <div class="dateFields">
                      <input type="radio" checked="checked" name="eventEndType" id="eventEndTypeDuration" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                      <label for="eventEndTypeDuration"><xsl:copy-of select="$bwStr-AEEF-Duration"/></label>
                      <div id="endDuration" class="shown">
                        <!-- day, hour, minute format -->
                        <div class="durationBox">
                          <input type="radio" checked="checked" name="eventDuration.type" id="durationTypeDayTime" value="daytime" onclick="swapDurationType('daytime')" />
                          <input type="text" name="eventDuration.daysStr" size="2" value="0" id="durationDays"/>
                          <xsl:copy-of select="$bwStr-AEEF-Days"/>
                          <xsl:text> </xsl:text>
                          <span id="durationHrMin" class="shown">
                            <input type="text" name="eventDuration.hoursStr" size="2" value="1" id="durationHours"/>
                            <xsl:copy-of select="$bwStr-AEEF-Hours"/>
                            <xsl:text> </xsl:text>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="0" id="durationMinutes"/>
                            <xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                          </span>
                        </div>
                        <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AEEF-Or"/></span>
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" id="durationTypeWeeks" value="weeks" onclick="swapDurationType('week')"/>
                          <input type="text" name="eventDuration.weeksStr" size="2" value="0" id="durationWeeks" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                        </div>
                      </div>
                    </div><br/>
                    <div class="dateFields" id="noDuration">
                      <input type="radio" name="eventEndType" id="eventEndTypeNone" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                      <label for="eventEndTypeNone">
                        <xsl:copy-of select="$bwStr-AEEF-This"/><xsl:text> </xsl:text>
                        <xsl:choose>
                          <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-AEEF-Task"/><xsl:text> </xsl:text></xsl:when>
                          <xsl:otherwise><xsl:copy-of select="$bwStr-AEEF-Event"/><xsl:text> </xsl:text></xsl:otherwise>
                        </xsl:choose>
                        <xsl:copy-of select="$bwStr-AEEF-HasNoDurationEndDate"/>
                      </label>
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
                    <select name="locationUid">
                      <option value=""><xsl:copy-of select="$bwStr-AEEF-Select"/></option>
                    </select>
                  </span>
                  <span class="std-text"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-OrAddNew"/><xsl:text> </xsl:text></span>
                  <input type="text" name="locationAddress.value" value="" />
                </td>
              </tr>

            </table>
          </div>


          <!-- Details tab -->
          <!-- ============== -->
          <div id="bwEventTab-Details">
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
                      <textarea name="description" id="description" cols="60" rows="4"><xsl:text> </xsl:text></textarea>
                      <!-- keep this space to avoid browser
                      rendering errors when the text area is empty -->
                    </xsl:when>
                    <xsl:otherwise>
                      <textarea name="description" id="description" cols="60" rows="4"><xsl:value-of select="form/desc/textarea"/></textarea>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <!--  Status  -->
              <tr>
                <td class="fieldname">
                  <xsl:copy-of select="$bwStr-AEEF-Status"/><xsl:text> </xsl:text>
                </td>
                <td class="fieldval">
                  <input type="radio" name="eventStatus" id="statusConfirmed" value="CONFIRMED">
                    <xsl:if test="form/status = 'CONFIRMED' or /bedework/creating = 'true' or form/status = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                  </input>
                  <label for="statusConfirmed"><xsl:copy-of select="$bwStr-AEEF-Confirmed"/></label>
                  <input type="radio" name="eventStatus" id="statusTentative" value="TENTATIVE">
                    <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                  </input>
                  <label for="statusTentative"><xsl:copy-of select="$bwStr-AEEF-Tentative"/></label>
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

              <!--  Category  -->
              <xsl:if test="categoriesExist"> <!-- XXX Fix this test -->
                <tr>
                  <td class="fieldname">
                    <xsl:copy-of select="$bwStr-AEEF-Categories"/><xsl:text> </xsl:text>
                  </td>
                  <td class="fieldval">
                    <xsl:variable name="catCount" select="count(form/categories/all/category)"/>
                    <table cellpadding="0" id="allCategoryCheckboxes">
                      <tr>
                        <td>
                          <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                            <input type="checkbox" name="catUid">
                              <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                              <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                            </input>
                            <xsl:value-of select="value"/>
                            <br/>
                          </xsl:for-each>
                        </td>
                        <td>
                          <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                            <input type="checkbox" name="catUid">
                              <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                              <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                            </input>
                            <xsl:value-of select="value"/>
                            <br/>
                          </xsl:for-each>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </xsl:if>

            </table>
          </div>


          <!-- Recurrence tab -->
          <!-- ============== -->
          <div id="bwEventTab-Recurrence">

            <div id="recurringSwitch">
              <!-- set or remove "recurring" and show or hide all recurrence fields: -->
              <input type="radio" name="recurring" id="isRecurring" value="true" onclick="swapRecurrence(this)">
                <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <label for="isRecurring"><xsl:copy-of select="$bwStr-AEEF-EventRecurs"/></label>
              <input type="radio" name="recurring" id="isNotRecurring" value="false" onclick="swapRecurrence(this)">
                <xsl:if test="form/recurringEntity = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <label for="isNotRecurring"><xsl:copy-of select="$bwStr-AEEF-EventDoesNotRecur"/></label>
            </div>

            <!-- wrapper for all recurrence fields (rrules and rdates): -->
            <div id="recurrenceFields" class="invisible">

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
                    <xsl:when test="form/recurrence/freq = 'HOURLY'"><xsl:copy-of select="$bwStr-AEEF-Hour"/><xsl:text> </xsl:text></xsl:when>
                    <xsl:when test="form/recurrence/freq = 'DAILY'"><xsl:copy-of select="$bwStr-AEEF-Day"/><xsl:text> </xsl:text></xsl:when>
                    <xsl:when test="form/recurrence/freq = 'WEEKLY'"><xsl:copy-of select="$bwStr-AEEF-Week"/><xsl:text> </xsl:text></xsl:when>
                    <xsl:when test="form/recurrence/freq = 'MONTHLY'"><xsl:copy-of select="$bwStr-AEEF-Month"/><xsl:text> </xsl:text></xsl:when>
                    <xsl:when test="form/recurrence/freq = 'YEARLY'"><xsl:copy-of select="$bwStr-AEEF-Year"/><xsl:text> </xsl:text></xsl:when>
                  </xsl:choose>
                  <xsl:text> </xsl:text>

                  <xsl:if test="form/recurrence/byday">
                    <xsl:for-each select="form/recurrence/byday/pos">
                      <xsl:if test="position() != 1"> <xsl:copy-of select="$bwStr-AEEF-And"/> </xsl:if>
                      <xsl:copy-of select="$bwStr-AEEF-On"/>
                      <xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="@val='1'">
                          <xsl:copy-of select="$bwStr-AEEF-TheFirst"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when test="@val='2'">
                          <xsl:copy-of select="$bwStr-AEEF-TheSecond"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when test="@val='3'">
                          <xsl:copy-of select="$bwStr-AEEF-TheThird"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when test="@val='4'">
                          <xsl:copy-of select="$bwStr-AEEF-TheFourth"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when test="@val='5'">
                          <xsl:copy-of select="$bwStr-AEEF-TheFifth"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when test="@val='-1'">
                          <xsl:copy-of select="$bwStr-AEEF-TheLast"/><xsl:text> </xsl:text>
                        </xsl:when>
                        <!-- don't output "every" -->
                        <!--<xsl:otherwise>
                          every
                        </xsl:otherwise>-->
                      </xsl:choose>
                      <xsl:for-each select="day">
                        <xsl:text> </xsl:text>
                        <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                        <xsl:variable name="dayVal" select="."/>
                        <xsl:variable name="dayPos">
                          <xsl:for-each select="/bedework/recurdayvals/val">
                            <xsl:if test="node() = $dayVal"><xsl:value-of select="position()"/></xsl:if>
                          </xsl:for-each>
                        </xsl:variable>
                        <xsl:value-of select="/bedework/shortdaynames/val[position() = $dayPos]"/>
                        <xsl:if test="position() != last()">, </xsl:if>
                        <xsl:text> </xsl:text>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:if>

                  <xsl:if test="form/recurrence/bymonth">
                    <xsl:copy-of select="$bwStr-AEEF-In"/>
                    <xsl:for-each select="form/recurrence/bymonth/val">
                      <xsl:if test="position() != 1 and position() = last()"> <xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                      <xsl:variable name="monthNum" select="number(.)"/>
                      <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:if>

                  <xsl:if test="form/recurrence/bymonthday">
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-DayOfTheMonth"/>
                    <xsl:text> </xsl:text>
                  </xsl:if>

                  <xsl:if test="form/recurrence/byyearday">
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-DayOfTheYear"/>
                    <xsl:text> </xsl:text>
                  </xsl:if>

                  <xsl:if test="form/recurrence/byweekno">
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-InThe"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-AEEF-WeekOfTheYear"/>
                    <xsl:text> </xsl:text>
                  </xsl:if>

                  <xsl:copy-of select="$bwStr-AEEF-Repeating"/>
                  <xsl:choose>
                    <xsl:when test="form/recurrence/count = '-1'"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Forever"/></xsl:when>
                    <xsl:when test="form/recurrence/until">
                      <xsl:text> </xsl:text>
                      <xsl:copy-of select="$bwStr-AEEF-Until"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="form/recurrence/count"/>
                      <xsl:text> </xsl:text>
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
                          <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                          <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
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
                          <xsl:text> </xsl:text>
                          <select name="bymonthposPos1" size="1" onchange="changeClass('monthRecurFields2','shown')">
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
                          <xsl:text> </xsl:text>
                          <select name="byyearposPos1" size="1" onchange="changeClass('yearRecurFields2','shown')">
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
            </div>
          </div>

          <!-- Meeting / Scheduling tab -->
          <!-- ======================== -->
          <div id="bwEventTab-Scheduling">

            <div id="bwSchedule">
              <div id="bwFreeBusyDisplay">
                attendees here...
              </div>

            </div>
          </div>

        </div>
      </div>

      <div class="eventSubmitButtons">
        <input id="editpoll-savechoice" type="button" value="{$bwStr-AEEF-Save}" class="bwEventFormSubmit"/>
        <input id="editpoll-cancelchoice" type="button" value="{$bwStr-AEEF-Cancel}"/>
      </div>
    </form>
  </xsl:template>
</xsl:stylesheet>