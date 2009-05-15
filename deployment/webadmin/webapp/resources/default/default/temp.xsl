Belongs on line 2951 of default.xsl - needs debugging.

        <form name="eventForm" method="post" action="{$event-update}" onsubmit="bwXProps.generate(this)">

          <!-- output some hidden fields that need not be displayed -->

          <input type="hidden" name="transparency">
            <xsl:attribute name="value"><xsl:value-of select="form/transparency"/></xsl:attribute>
          </input>

          <input type="hidden" name="newCalPath">
            <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option[@selected]/@value"/></xsl:attribute>
          </input>

          <xsl:call-template name="submitEventButtons">
            <xsl:with-param name="eventTitle" select="$eventTitle"/>
            <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
          </xsl:call-template>

          <table class="eventFormTable">
            <tr>
              <td class="fieldName">
                Title:
              </td>
              <td>
                <xsl:hidden name="summary">
                  <xsl:attribute name="value"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
                </xsl:hidden>
                <xsl:value-of select="form/title/input/@value"/>
              </td>
            </tr>

            <tr>
              <td class="fieldName">
                Date &amp; Time:
              </td>
              <td>
                <!-- Set the timefields class for the first load of the page;
                     subsequent changes will take place using javascript without a
                     page reload. -->
                <xsl:variable name="timeFieldsClass">
                  <xsl:choose>
                    <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>timeFields</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="form/allDay/input/@checked='checked'">
                    <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                    <input type="hidden" name="eventStartDate.dateOnly" value="on" id="allDayStartDateField"/>
                    <input type="hidden" name="eventEndDate.dateOnly" value="on" id="allDayEndDateField"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                    <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField"/>
                    <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField"/>
                  </xsl:otherwise>
                </xsl:choose>
                all day

                <!-- floating event: no timezone (and not UTC) -->
                <xsl:choose>
                  <xsl:when test="form/floating/input/@checked='checked'">
                    <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="on" checked="checked"/>
                    <input type="hidden" name="eventStartDate.floating" value="on" id="startFloating"/>
                    <input type="hidden" name="eventEndDate.floating" value="on" id="endFloating"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off"/>
                    <input type="hidden" name="eventStartDate.floating" value="off" id="startFloating"/>
                    <input type="hidden" name="eventEndDate.floating" value="off" id="endFloating"/>
                  </xsl:otherwise>
                </xsl:choose>
                floating

                <!-- store time as coordinated universal time (UTC) -->
                <xsl:choose>
                  <xsl:when test="form/storeUTC/input/@checked='checked'">
                    <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="on" checked="checked"/>
                    <input type="hidden" name="eventStartDate.storeUTC" value="on" id="startStoreUTC"/>
                    <input type="hidden" name="eventEndDate.storeUTC" value="on" id="endStoreUTC"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off"/>
                    <input type="hidden" name="eventStartDate.storeUTC" value="off" id="startStoreUTC"/>
                    <input type="hidden" name="eventEndDate.storeUTC" value="off" id="endStoreUTC"/>
                  </xsl:otherwise>
                </xsl:choose>
                store as UTC

                <br/>
                <div class="dateStartEndBox">
                  <strong>Start:</strong>
                  <div class="dateFields">
                    <span class="startDateLabel">Date </span>
                    <xsl:choose>
                      <xsl:when test="$portalFriendly = 'true'">
                        <xsl:copy-of select="form/start/month/*"/>
                        <xsl:copy-of select="form/start/day/*"/>
                        <xsl:choose>
                          <xsl:when test="/bedework/creating = 'true'">
                            <xsl:copy-of select="form/start/year/*"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:copy-of select="form/start/yearText/*"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <script language="JavaScript" type="text/javascript">
                          <xsl:comment>
                          startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                          </xsl:comment>
                        </script>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetStartDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                          <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                          <xsl:text> </xsl:text>
                        </span-->
                        <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                        <script language="JavaScript" type="text/javascript">
                          <xsl:comment>
                          $("#bwEventWidgetStartDate").datepicker({
                            defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                          }).attr("readonly", "readonly");
                          $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
                          //alert($("#bwEventWidgetStartDate").datepicker("getDate"));
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
                      <a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>

                      <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                        <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
                        <option value="-1">select timezone...</option>
                        <xsl:variable name="startTzId" select="form/start/tzid"/>
                        <xsl:for-each select="/bedework/timezones/timezone">
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                            <xsl:if test="$startTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                            <xsl:value-of select="name"/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </span>
                  </div>
                </div>
                <div class="dateStartEndBox">
                  <strong>End:</strong>
                  <xsl:choose>
                    <xsl:when test="form/end/type='E'">
                      <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" checked="checked" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" onClick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  Date
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
                          <xsl:copy-of select="form/end/dateTime/month/*"/>
                          <xsl:copy-of select="form/end/dateTime/day/*"/>
                          <xsl:choose>
                            <xsl:when test="/bedework/creating = 'true'">
                              <xsl:copy-of select="form/end/dateTime/year/*"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:copy-of select="form/end/dateTime/yearText/*"/>
                            </xsl:otherwise>
                          </xsl:choose>
                          <script language="JavaScript" type="text/javascript">
                            <xsl:comment>
                            endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                          </xsl:comment>
                          </script>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetEndDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                            <xsl:attribute name="value"><xsl:value-of select="form/end/rfc3339DateTime"/></xsl:attribute>
                            <xsl:text> </xsl:text>
                          </span-->
                          <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                          <script language="JavaScript" type="text/javascript">
                            <xsl:comment>
                            $("#bwEventWidgetEndDate").datepicker({
                              defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                            }).attr("readonly", "readonly");
                            $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');
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
                        <a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/resources/clockIcon.gif" width="16" height="15" border="0"/></a>

                        <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                          <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
                          <option value="-1">select timezone...</option>
                          <xsl:variable name="endTzId" select="form/end/dateTime/tzid"/>
                          <xsl:for-each select="/bedework/timezones/timezone">
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                              <xsl:if test="$endTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                              <xsl:value-of select="name"/>
                            </option>
                          </xsl:for-each>
                        </select>
                      </span>
                    </div>
                  </div>
                  <br/>
                  <div id="clock" class="invisible">
                    <xsl:call-template name="clock"/>
                  </div>
                  <div class="dateFields">
                    <xsl:choose>
                      <xsl:when test="form/end/type='D'">
                        <input type="radio" name="eventEndType" value="D" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="radio" name="eventEndType" value="D" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    Duration
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
                            <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                            <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/>days
                            <span id="durationHrMin" class="{$durationHrMinClass}">
                              <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                              <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/>hours
                              <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                              <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/>minutes
                            </span>
                          </div>
                          <span class="durationSpacerText">or</span>
                          <div class="durationBox">
                            <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                            <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                            <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="true"/>weeks
                          </div>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- we are using week format -->
                          <div class="durationBox">
                            <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                            <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                            <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="true"/>days
                            <span id="durationHrMin" class="{$durationHrMinClass}">
                              <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                              <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="true"/>hours
                              <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                              <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="true"/>minutes
                            </span>
                          </div>
                          <span class="durationSpacerText">or</span>
                          <div class="durationBox">
                            <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                            <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                            <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/>weeks
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </div>
                  <br/>
                  <div class="dateFields" id="noDuration">
                    <xsl:choose>
                      <xsl:when test="form/end/type='N'">
                        <input type="radio" name="eventEndType" value="N" checked="checked" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="radio" name="eventEndType" value="N" onClick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    This event has no duration / end date
                  </div>
                </div>
              </td>
            </tr>
            <!-- Recurrence fields -->
            <!-- ================= -->
            <tr>
              <td class="fieldName">
                Recurrence:
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="recurrenceId != ''">
                    <!-- recurrence instances can not themselves recur,
                         so provide access to master event -->
                    <em>This event is a recurrence instance.</em><br/>
                    <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}" title="edit master (recurring event)">edit master event</a>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- has recurrenceId, so is master -->

                    <div id="recurringSwitch">
                      <!-- set or remove "recurring" and show or hide all recurrence fields: -->
                      <input type="radio" name="recurring" value="true" onclick="swapRecurrence(this)">
                        <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      </input> event recurs
                      <input type="radio" name="recurring" value="false" onclick="swapRecurrence(this)">
                        <xsl:if test="form/recurringEntity = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      </input> event does not recur
                    </div>

                    <!-- wrapper for all recurrence fields (rrules and rdates): -->
                    <div id="recurrenceFields" class="invisible">
                      <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

                      <h4>Recurrence Rules</h4>
                      <!-- show or hide rrules fields when editing: -->
                      <xsl:if test="form/recurrence">
                        <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on"/>
                        <span id="rrulesSwitch">
                          change recurrence rules
                        </span>
                      </xsl:if>
                      <span id="rrulesUiSwitch">
                        <xsl:if test="form/recurrence">
                          <xsl:attribute name="class">invisible</xsl:attribute>
                        </xsl:if>
                        <input type="checkbox" name="rrulesUiSwitch" value="advanced" onchange="swapVisible(this,'advancedRrules')"/>
                        show advanced recurrence rules
                      </span>

                      <xsl:if test="form/recurrence">
                        <!-- Output descriptive recurrence rules information.  Probably not
                             complete yet. Replace all strings so can be
                             more easily internationalized. -->
                        <div id="recurrenceInfo">
                          Every
                          <xsl:choose>
                            <xsl:when test="form/recurrence/interval &gt; 1">
                              <xsl:value-of select="form/recurrence/interval"/>
                            </xsl:when>
                          </xsl:choose>
                          <xsl:text> </xsl:text>
                          <xsl:choose>
                            <xsl:when test="form/recurrence/freq = 'HOURLY'">hour</xsl:when>
                            <xsl:when test="form/recurrence/freq = 'DAILY'">day</xsl:when>
                            <xsl:when test="form/recurrence/freq = 'WEEKLY'">week</xsl:when>
                            <xsl:when test="form/recurrence/freq = 'MONTHLY'">month</xsl:when>
                            <xsl:when test="form/recurrence/freq = 'YEARLY'">year</xsl:when>
                          </xsl:choose><xsl:if test="form/recurrence/interval &gt; 1">s</xsl:if>
                          <xsl:text> </xsl:text>

                          <xsl:if test="form/recurrence/byday">
                            <xsl:for-each select="form/recurrence/byday/pos">
                              <xsl:if test="position() != 1"> and </xsl:if>
                              on
                              <xsl:choose>
                                <xsl:when test="@val='1'">
                                  the first
                                </xsl:when>
                                <xsl:when test="@val='2'">
                                  the second
                                </xsl:when>
                                <xsl:when test="@val='3'">
                                  the third
                                </xsl:when>
                                <xsl:when test="@val='4'">
                                  the fourth
                                </xsl:when>
                                <xsl:when test="@val='5'">
                                  the fifth
                                </xsl:when>
                                <xsl:when test="@val='-1'">
                                  the last
                                </xsl:when>
                                <!-- don't output "every" -->
                                <!--<xsl:otherwise>
                                  every
                                </xsl:otherwise>-->
                              </xsl:choose>
                              <xsl:for-each select="day">
                                <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
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
                            in
                            <xsl:for-each select="form/recurrence/bymonth/val">
                              <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
                              <xsl:variable name="monthNum" select="number(.)"/>
                              <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </xsl:if>

                          <xsl:if test="form/recurrence/bymonthday">
                            on the
                            <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                            day<xsl:if test="form/recurrence/bymonthday/val[position()=2]">s</xsl:if> of the month
                          </xsl:if>

                          <xsl:if test="form/recurrence/byyearday">
                            on the
                            <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                            day<xsl:if test="form/recurrence/byyearday/val[position()=2]">s</xsl:if> of the year
                          </xsl:if>

                          <xsl:if test="form/recurrence/byweekno">
                            in the
                            <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                            week<xsl:if test="form/recurrence/byweekno/val[position()=2]">s</xsl:if> of the year
                          </xsl:if>

                          repeating
                          <xsl:choose>
                            <xsl:when test="form/recurrence/count = '-1'">forever</xsl:when>
                            <xsl:when test="form/recurrence/until">
                              until <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="form/recurrence/count"/>
                              time<xsl:if test="form/recurrence/count &gt; 1">s</xsl:if>
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
                            <em>Frequency:</em><br/>
                            <input type="radio" name="freq" value="NONE" onclick="showRrules(this.value)" checked="checked"/>none<br/>
                            <!--<input type="radio" name="freq" value="HOURLY" onclick="showRrules(this.value)"/>hourly<br/>-->
                            <input type="radio" name="freq" value="DAILY" onclick="showRrules(this.value)"/>daily<br/>
                            <input type="radio" name="freq" value="WEEKLY" onclick="showRrules(this.value)"/>weekly<br/>
                            <input type="radio" name="freq" value="MONTHLY" onclick="showRrules(this.value)"/>monthly<br/>
                            <input type="radio" name="freq" value="YEARLY" onclick="showRrules(this.value)"/>yearly
                          </td>
                          <!-- recurrence count, until, forever -->
                          <td id="recurrenceUntil">
                            <div id="noneRecurrenceRules">
                              no recurrence rules
                            </div>
                            <div id="recurrenceUntilRules" class="invisible">
                              <em>Repeat:</em>
                              <p>
                                <input type="radio" name="recurCountUntil" value="forever">
                                  <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                  </xsl:if>
                                </input>
                                forever
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
                                time(s)
                                <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                                  <xsl:if test="form/recurring/until">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                  </xsl:if>
                                </input>
                                until
                                <span id="untilHolder">
                                  <!-- span dojoType="dropdowndatepicker" formatLength="medium" value="today" saveFormat="yyyyMMdd" id="bwEventWidgetUntilDate" iconURL="{$resourcesRoot}/resources/calIcon.gif">
                                    <xsl:attribute name="value"><xsl:value-of select="form/start/rfc3339DateTime"/></xsl:attribute>
                                    <xsl:text> </xsl:text>
                                  </span -->
                                  <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                                  <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
                                  <script language="JavaScript" type="text/javascript">
                                    <xsl:comment>
                                    $("#bwEventWidgetUntilDate").datepicker({
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
                                    $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
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
                                <em>Interval:</em>
                                every
                                <input type="text" name="hourlyInterval" size="2" value="1">
                                  <xsl:if test="form/recurrence/interval">
                                    <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                                  </xsl:if>
                                </input>
                                hour(s)
                              </p>
                            </div>
                            <!-- daily -->
                            <div id="dailyRecurrenceRules" class="invisible">
                              <p>
                                <em>Interval:</em>
                                every
                                <input type="text" name="dailyInterval" size="2" value="1">
                                  <xsl:if test="form/recurrence/interval">
                                    <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                                  </xsl:if>
                                </input>
                                day(s)
                              </p>
                              <p>
                                <input type="checkbox" name="swapDayMonthCheckBoxList" value="" onclick="swapVisible(this,'dayMonthCheckBoxList')"/>
                                in these months:
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
                              </p>
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
                                <em>Interval:</em>
                                every
                                <input type="text" name="weeklyInterval" size="2" value="1">
                                  <xsl:if test="form/recurrence/interval">
                                    <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                                  </xsl:if>
                                </input>
                                week(s) on:
                              </p>
                              <p>
                                <div id="weekRecurFields">
                                  <xsl:call-template name="byDayChkBoxList">
                                    <xsl:with-param name="name">byDayWeek</xsl:with-param>
                                  </xsl:call-template>
                                </div>
                              </p>
                              <p class="weekRecurLinks">
                                <a href="javascript:recurSelectWeekdays('weekRecurFields')">select weekdays</a> |
                                <a href="javascript:recurSelectWeekends('weekRecurFields')">select weekends</a>
                              </p>
                              <p>
                                Week start:
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
                                <em>Interval:</em>
                                every
                                <input type="text" name="monthlyInterval" size="2" value="1">
                                  <xsl:if test="form/recurrence/interval">
                                    <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                                  </xsl:if>
                                </input>
                                month(s)
                              </p>
                              <div id="monthRecurFields">
                                <div id="monthRecurFields1">
                                  on
                                  <select name="bymonthposPos1" width="7em" onchange="changeClass('monthRecurFields2','shown')">
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
                              <p>
                                <input type="checkbox" name="swapMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'monthDaysCheckBoxList')"/>
                                on these days:<br/>
                                <div id="monthDaysCheckBoxList" class="invisible">
                                  <xsl:call-template name="buildCheckboxList">
                                    <xsl:with-param name="current">1</xsl:with-param>
                                    <xsl:with-param name="end">31</xsl:with-param>
                                    <xsl:with-param name="name">monthDayBoxes</xsl:with-param>
                                  </xsl:call-template>
                                </div>
                              </p>
                            </div>
                            <!-- yearly -->
                            <div id="yearlyRecurrenceRules" class="invisible">
                              <p>
                                <em>Interval:</em>
                                every
                                <input type="text" name="yearlyInterval" size="2" value="1">
                                  <xsl:if test="form/recurrence/interval">
                                    <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                                  </xsl:if>
                                </input>
                                years(s)
                              </p>
                              <div id="yearRecurFields">
                                <div id="yearRecurFields1">
                                  on
                                  <select name="byyearposPos1" width="7em" onchange="changeClass('yearRecurFields2','shown')">
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
                              <p>
                                <input type="checkbox" name="swapYearMonthCheckBoxList" value="" onclick="swapVisible(this,'yearMonthCheckBoxList')"/>
                                in these months:
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
                              </p>
                              <p>
                                <input type="checkbox" name="swapYearMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'yearMonthDaysCheckBoxList')"/>
                                on these days of the month:<br/>
                                <div id="yearMonthDaysCheckBoxList" class="invisible">
                                  <xsl:call-template name="buildCheckboxList">
                                    <xsl:with-param name="current">1</xsl:with-param>
                                    <xsl:with-param name="end">31</xsl:with-param>
                                    <xsl:with-param name="name">yearMonthDayBoxes</xsl:with-param>
                                  </xsl:call-template>
                                </div>
                              </p>
                              <p>
                                <input type="checkbox" name="swapYearWeeksCheckBoxList" value="" onclick="swapVisible(this,'yearWeeksCheckBoxList')"/>
                                in these weeks of the year:<br/>
                                <div id="yearWeeksCheckBoxList" class="invisible">
                                  <xsl:call-template name="buildCheckboxList">
                                    <xsl:with-param name="current">1</xsl:with-param>
                                    <xsl:with-param name="end">53</xsl:with-param>
                                    <xsl:with-param name="name">yearWeekBoxes</xsl:with-param>
                                  </xsl:call-template>
                                </div>
                              </p>
                              <p>
                                <input type="checkbox" name="swapYearDaysCheckBoxList" value="" onclick="swapVisible(this,'yearDaysCheckBoxList')"/>
                                on these days of the year:<br/>
                                <div id="yearDaysCheckBoxList" class="invisible">
                                  <xsl:call-template name="buildCheckboxList">
                                    <xsl:with-param name="current">1</xsl:with-param>
                                    <xsl:with-param name="end">366</xsl:with-param>
                                    <xsl:with-param name="name">yearDayBoxes</xsl:with-param>
                                  </xsl:call-template>
                                </div>
                              </p>
                              <p>
                                Week start:
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
                        Recurrence and Exception Dates
                      </h4>
                      <div id="raContent">
                        <div class="dateStartEndBox" id="rdatesFormFields">
                          <!--
                          <input type="checkbox" name="dateOnly" id="rdateDateOnly" onclick="swapRdateAllDay(this)" value="true"/>
                          all day
                          <input type="checkbox" name="floating" id="rdateFloating" onclick="swapRdateFloatingTime(this)" value="true"/>
                          floating
                          store time as coordinated universal time (UTC)
                          <input type="checkbox" name="storeUTC" id="rdateStoreUTC" onclick="swapRdateStoreUTC(this)" value="true"/>
                          store as UTC<br/>-->
                          <div class="dateFields">
                            <!-- input name="eventRdate.date"
                                   dojoType="dropdowndatepicker"
                                   formatLength="medium"
                                   value="today"
                                   saveFormat="yyyyMMdd"
                                   id="bwEventWidgeRdate"
                                   iconURL="{$resourcesRoot}/resources/calIcon.gif"/-->
                            <input type="text" name="eventRdate.date" id="bwEventWidgetRdate" size="10"/>
                            <script language="JavaScript" type="text/javascript">
                              <xsl:comment>
                              $("#bwEventWidgetRdate").datepicker({
                                defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                                dateFormat: "yymmdd"
                              }).attr("readonly", "readonly");
                              $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
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
                              <option value="">select timezone...</option>
                              <xsl:variable name="rdateTzId" select="/bedework/now/defaultTzid"/>
                              <xsl:for-each select="/bedework/timezones/timezone">
                                <option>
                                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                                  <xsl:if test="$rdateTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                                  <xsl:value-of select="name"/>
                                </option>
                              </xsl:for-each>
                            </select>
                          </div>
                          <xsl:text> </xsl:text>
                          <!--bwRdates.update() accepts: date, time, allDay, floating, utc, tzid-->
                          <input type="button" name="rdate" value="add recurrence" onclick="bwRdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>
                          <input type="button" name="exdate" value="add exception" onclick="bwExdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>

                          <input type="hidden" name="rdates" value="" id="bwRdatesField" />
                          <!-- if there are no recurrence dates, the following table will show -->
                          <table cellspacing="0" class="invisible" id="bwCurrentRdatesNone">
                            <tr><th>Recurrence Dates</th></tr>
                            <tr><td>No recurrence dates</td></tr>
                          </table>

                          <!-- if there are recurrence dates, the following table will show -->
                          <table cellspacing="0" class="invisible" id="bwCurrentRdates">
                            <tr>
                              <th colspan="4">Recurrence Dates</th>
                            </tr>
                            <tr class="colNames">
                              <td>Date</td>
                              <td>Time</td>
                              <td>TZid</td>
                              <td></td>
                            </tr>
                          </table>

                          <input type="hidden" name="exdates" value="" id="bwExdatesField" />
                          <!-- if there are no exception dates, the following table will show -->
                          <table cellspacing="0" class="invisible" id="bwCurrentExdatesNone">
                            <tr><th>Exception Dates</th></tr>
                            <tr><td>No exception dates</td></tr>
                          </table>

                          <!-- if there are exception dates, the following table will show -->
                          <table cellspacing="0" class="invisible" id="bwCurrentExdates">
                            <tr>
                              <th colspan="4">Exception Dates</th>
                            </tr>
                            <tr class="colNames">
                              <td>Date</td>
                              <td>Time</td>
                              <td>TZid</td>
                              <td></td>
                            </tr>
                          </table>
                          <p>
                            Exception dates may also be created by deleting an instance
                            of a recurring event.
                          </p>
                        </div>
                      </div>
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
            <!--  Status  -->
            <tr>
              <td class="fieldName">
                Status:
              </td>
              <td>
                <input type="hidden" name="eventStatus">
                  <xsl:attribute name="value"><xsl:value-of select="form/status"/></xsl:attribute>
                </input>
                <xsl:value-of select="form/status"/>
              </td>
            </tr>
            <!--  Description  -->
            <tr>
              <td class="fieldName">
                Description:
              </td>
              <td>
                <input type="hidden" name="description">
                  <xsl:attribute name="value"><xsl:value-of select="form/desc/textarea"/></xsl:attribute>
                </input>
                <xsl:value-of select="form/desc/textarea"/>
              </td>
            </tr>
            <!-- Cost -->
            <tr>
              <td class="optional">
                Cost:
              </td>
              <td>
                <input type="hidden" name="event.cost">
                  <xsl:attribute name="value"><xsl:value-of select="form/cost/input/@value"/></xsl:attribute>
                </input>
                <xsl:value-of select="form/cost/input/@value"/>
              </td>
            </tr>
            <!-- Url -->
            <tr>
              <td class="optional">
                Event URL:
              </td>
              <td>
                <xsl:variable name="link" select="form/link/input/@value"/>
                <input type="hidden" name="eventLink" value="{$link}"/>
                <a href="{$link}"><xsl:value-of select="$link"/></a>
              </td>
            </tr>

            <!-- Image Url -->
            <tr>
              <td class="optional">
                Image URL:
              </td>
              <td>
                <xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/>
              </td>
            </tr>

            <!-- Location -->
            <tr>
              <td class="fieldName">
                Location:
              </td>
              <td>
                <select name="allLocationId" id="bwAllLocationList">
                  <xsl:copy-of select="form/location/all/select/*"/>
                </select>
              </td>
            </tr>

            <!-- Contact -->
            <tr>
              <td class="fieldName">
                Contact:
              </td>
              <td>
                <select name="allContactId" id="bwAllContactList">
                  <xsl:copy-of select="form/contact/all/select/*"/>
                </select>
              </td>
            </tr>

            <!-- Topical area  -->
            <!-- These are the subscriptions (aliases) where the events should show up.
                 By selecting one or more of these, appropriate categories will be set on the event -->
            <tr>
              <td class="fieldName">
                Topical area:
              </td>
              <td>
                <ul class="aliasTree">
                  <xsl:apply-templates select="form/subscriptions/calsuite/calendars/calendar" mode="showEventFormAliases">
                    <xsl:with-param name="root">true</xsl:with-param>
                  </xsl:apply-templates>
                </ul>
              </td>
            </tr>

          </table>
          <xsl:call-template name="submitEventButtons">
            <xsl:with-param name="eventTitle" select="$eventTitle"/>
            <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
          </xsl:call-template>
        </form>
