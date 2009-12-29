<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--======== list events ==========-->
  <!-- This formats a list of events from /bedework/eventscalendar, the default
       day, week, and month views.  Look to eventListDiscrete.xsl for the listing
       produced by the listEvents.do action -->


  <!--==== LIST EVENTS - for listing discrete events ====-->
  <xsl:template match="events" mode="eventListDiscrete">
    <h2 class="bwStatusConfirmed">
      <!-- <form name="bwListEventsForm" action="{$listEvents}" method="post">
        <input type="hidden" name="setappvar"/>-->
        <xsl:copy-of select="$bwStr-LsEv-Next7Days"/>
        <!--
        <span id="bwListEventsFormControls">
          <select name="catuid" onchange="this.form.submit();">
            <option value="">filter by category...</option>
            <xsl:for-each select="/bedework/categories/category">
              <option>
                <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                <xsl:value-of select="value"/>
              </option>
            </xsl:for-each>
          </select>
          <select name="days" onchange="this.form.submit();">
            <xsl:call-template name="buildListEventsDaysOptions">
              <xsl:with-param name="i">1</xsl:with-param>
              <xsl:with-param name="total">31</xsl:with-param>
            </xsl:call-template>
          </select>
        </span>
      </form>-->
    </h2>

    <div id="listEvents">
      <ul>
        <xsl:choose>
          <xsl:when test="not(event)">
            <li><xsl:copy-of select="$bwStr-LsEv-NoEventsToDisplay"/></li>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <li>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
                    <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
                  </xsl:choose>
                </xsl:attribute>

                <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsEv-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                <xsl:if test="status='TENTATIVE'"><em><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></em></xsl:if>

                <a class="title" href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of select="summary"/>
                </a><xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <xsl:if test="location/subaddress != ''">
                    , <xsl:value-of select="location/subaddress"/>
                  </xsl:if>
                </xsl:if>

                <xsl:text> </xsl:text>
                <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                  <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                </a>
                <xsl:text> </xsl:text>
                <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-LsEv-DownloadEvent}">
                  <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsEv-DownloadEvent}"/>
                </a>

                <br/>

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

              </li>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>
