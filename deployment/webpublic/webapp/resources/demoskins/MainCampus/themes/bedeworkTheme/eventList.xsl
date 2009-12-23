<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--======== list events ==========-->
  <!-- This formats a list of events from /bedework/eventscalendar, the default
       day, week, and month views.  Look to eventListDiscrete.xsl for the listing
       produced by the listEvents.do action -->


  <xsl:template name="eventList">

    <table class="eventList">

      <!-- display information about the current selection state if not default -->
      <xsl:choose>
        <xsl:when test="/bedework/selectionState/selectionType = 'collections'">
          <tr>
            <td class="eventFilterInfo" colspan="3">
              <xsl:copy-of select="$bwStr-LsVw-DispEventsForCal"/>
              <xsl:text> </xsl:text>
              <span class="displayFilterName">
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="/bedework/selectionState/collection/virtualpath"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
              </span><xsl:text> </xsl:text>
              <a id="allView" href="{$setSelection}"><xsl:copy-of select="$bwStr-LsVw-ShowAll"/></a></td>
          </tr>
        </xsl:when>
        <xsl:when test="/bedework/selectionState/view/name != 'All'">
          <tr>
            <td class="eventFilterInfo" colspan="3">
              <xsl:copy-of select="$bwStr-LsVw-DispEventsForView"/>
              <xsl:text> </xsl:text>
              <span class="displayFilterName">
                <xsl:value-of select="/bedework/selectionState/view/name"/>
              </span><xsl:text> </xsl:text>
            <a id="allView" href="setSelection.do?b=de{$allGroupsAppVar}"><xsl:copy-of select="$bwStr-LsVw-ShowAll"/></a></td>
          </tr>
        </xsl:when>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
          <tr>
            <td class="noEventsCell">
              <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>
            </td>
          </tr>
        </xsl:when>
        <xsl:when test="$ongoingEventsEnabled = 'true'
               and ($ongoingEventsShowForCollection = 'true' and not(/bedework/selectionState/selectionType = 'collections'))
               and not(/bedework/eventscalendar/year/month/week/day/event[not(categories/category/value = $ongoingEventsCatName)])">
            <tr>
              <td class="noEventsCell">
                <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplayWithOngoing"/>
              </td>
            </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$ongoingEventsEnabled = 'true'
                   and ($ongoingEventsShowForCollection = 'true' and not(/bedework/selectionState/selectionType = 'collections'))">
              <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[event[not(categories/category/value = $ongoingEventsCatName)]]" mode="dayInList"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[event]" mode="dayInList"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <xsl:template match="day" mode="dayInList">
     <tr>
       <td colspan="2" class="dateRow">
          <xsl:variable name="date" select="date"/>
          <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
            <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
          </a>
       </td>
     </tr>
      <xsl:choose>
       <xsl:when test="$ongoingEventsEnabled = 'true'
                  and ($ongoingEventsShowForCollection = 'true' and not(/bedework/selectionState/selectionType = 'collections'))">
         <xsl:apply-templates select="event[not(categories/category/value = $ongoingEventsCatName)]" mode="eventInList"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:apply-templates select="event" mode="eventInList"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

   <xsl:template match="event" mode="eventInList">
    <xsl:variable name="id" select="id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="guidEsc" select="translate(guid, '.', '_')"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <tr>
      <xsl:variable name="dateRangeStyle">
        <xsl:choose>
          <xsl:when test="start/shortdate = parent::day/shortdate">
            <xsl:choose>
              <xsl:when test="start/allday = 'true'">dateRangeCrossDay</xsl:when>
              <xsl:when test="start/hour24 &lt; 6">dateRangeEarlyMorning</xsl:when>
              <xsl:when test="start/hour24 &lt; 12">dateRangeMorning</xsl:when>
              <xsl:when test="start/hour24 &lt; 18">dateRangeAfternoon</xsl:when>
              <xsl:otherwise>dateRangeEvening</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>dateRangeCrossDay</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Event Date / Time Column  -->
      <td class="time {$dateRangeStyle}">
       <xsl:choose>
        <xsl:when test="start/allday = 'true' and start/shortdate = end/shortdate">
            <xsl:copy-of select="$bwStr-LsVw-AllDay"/>
        </xsl:when>
        <xsl:when test="start/shortdate = end/shortdate and start/time = end/time">
          <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
            <xsl:value-of select="start/time"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
            <xsl:choose>
              <xsl:when test="start/allday = 'true' and
                              parent::day/shortdate = start/shortdate">
                <xsl:copy-of select="$bwStr-LsVw-Today"/>
              </xsl:when>
              <xsl:when test="parent::day/shortdate != start/shortdate">
                <span class="littleArrow">&#171;</span>&#160;
                <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="start/time"/>
              </xsl:otherwise>
            </xsl:choose>
            -
           <xsl:choose>
             <xsl:when test="end/allday = 'true' and
                             parent::day/shortdate = end/shortdate">
               <xsl:copy-of select="$bwStr-LsVw-Today"/>
             </xsl:when>
             <xsl:when test="parent::day/shortdate != end/shortdate">
               <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
               &#160;<span class="littleArrow">&#187;</span>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="end/time"/>
             </xsl:otherwise>
           </xsl:choose>
          </a>
       </xsl:otherwise>
     </xsl:choose>
    </td>


    <!-- Event Description Column -->
    <xsl:variable name="descriptionClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">description bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">description bwStatusTentative</xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-LsVw-Description"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Subscription styles.
         These are set in the add/modify subscription forms in the admin client;
         if present, these override the background-color set by eventClass. The
         subscription styles should not be used for canceled events (tentative is ok). -->
    <xsl:variable name="subscriptionClass">
      <xsl:if test="status != 'CANCELLED'">
        <xsl:apply-templates select="categories" mode="customEventColor"/>
      </xsl:if>
    </xsl:variable>
    <td class="{$descriptionClass} {$subscriptionClass}">

      <ul>
        <li class="titleEvent">

          <!-- event icons -->
          <span class="icons">
            <xsl:variable name="gStartdate" select="start/utcdate"/>
            <xsl:variable name="gLocation" select="location/address"/>
            <xsl:variable name="gEnddate" select="end/utcdate"/>
            <xsl:variable name="gText" select="summary"/>
            <xsl:variable name="gDetails" select="summary"/>

            <a href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
              <img title="{$bwStr-SgEv-AddToGoogleCalendar}" src="{$resourcesRoot}/images/gcal_small.gif" alt="Add to Google Calendar"/>
            </a>
            <xsl:choose>
              <xsl:when test="string-length($recurrenceId)">
                <a href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/Public/{$recurrenceId}/{$guidEsc}" title="{$bwStr-SgEv-AddToFacebook}">
                  <img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge_small.gif" alt="{$bwStr-SgEv-AddToFacebook}"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/Public/0/{$guidEsc}" title="{$bwStr-SgEv-AddToFacebook}">
                  <img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge_small.gif" alt="{$bwStr-SgEv-AddToFacebook}"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
              <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
            </a>
            <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-Download}">
              <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" alt="{$bwStr-SgEv-Download}"/>
            </a>
          </span>

          <!-- event title -->
          <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
          <xsl:if test="status='TENTATIVE'"><strong><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></strong></xsl:if>
          <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
            <xsl:value-of select="summary"/>
            <xsl:if test="summary = ''">
              <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
            </xsl:if>
          </a>
        </li>

        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
            <xsl:if test="location/address != ''">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-Location"/><xsl:text> </xsl:text>
                <xsl:value-of select="location/address"/>
                <xsl:if test="location/subaddress != ''">
                  , <xsl:value-of select="location/subaddress"/>
                </xsl:if>
              </li>
            </xsl:if>

            <xsl:if test="cost!=''">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-Cost"/><xsl:text> </xsl:text>
                <xsl:value-of select="cost"/>
              </li>
            </xsl:if>

            <xsl:if test="contact/name!='none'">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-Contact"/><xsl:text> </xsl:text>
                <xsl:value-of select="contact/name"/>
              </li>
            </xsl:if>

            <li>
              <xsl:copy-of select="$bwStr-LsVw-Description"/><xsl:text> </xsl:text>
              <xsl:value-of select="description"/>
            </li>

            <xsl:if test="link != ''">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-Link"/><xsl:text> </xsl:text>
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                  <xsl:value-of select="link"/>
                </a>
              </li>
            </xsl:if>

            <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-TopicalArea"/><xsl:text> </xsl:text>
                <span class="eventSubscription">
                  <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                    <xsl:call-template name="substring-afterLastInstanceOf">
                      <xsl:with-param name="string" select="values/text"/>
                      <xsl:with-param name="char">/</xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="position()!=last()">, </xsl:if>
                  </xsl:for-each>
                </span>
              </li>
            </xsl:if>

          </xsl:when>
          <xsl:otherwise>

            <li>
              <xsl:copy-of select="$bwStr-LsVw-Location"/><xsl:text> </xsl:text>
              <xsl:value-of select="location/address" />
            </li>

            <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
              <li>
                <xsl:copy-of select="$bwStr-LsVw-TopicalArea"/><xsl:text> </xsl:text>
                <span class="eventSubscription">
                  <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                    <xsl:call-template name="substring-afterLastInstanceOf">
                      <xsl:with-param name="string" select="values/text"/>
                      <xsl:with-param name="char">/</xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="position()!=last()">, </xsl:if>
                  </xsl:for-each>
                </span>
              </li>
            </xsl:if>

          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </td>
    <!-- td class="icons">
        keep and place icons here if spacing is an issue
        (but change the day cell to colspan=3)
      </td-->
    </tr>
  </xsl:template>

</xsl:stylesheet>
