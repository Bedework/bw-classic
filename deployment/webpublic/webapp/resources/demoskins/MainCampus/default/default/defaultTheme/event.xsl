<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
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

      <div id="eventIcons">
        <xsl:variable name="gStartdate" select="start/utcdate" />
        <xsl:variable name="gLocation" select="location/address" />
        <xsl:variable name="gEnddate" select="end/utcdate" />
        <xsl:variable name="gText" select="summary" />
        <xsl:variable name="gDetails" select="summary" />
        <a class="eventIcons" href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
          <img title="Add to Google Calendar" src="{$resourcesRoot}/images/gcal.gif" alt="Add to Google Calendar" />
        </a>
        <xsl:choose>
          <xsl:when test="string-length($recurrenceId)">
            <a class="eventIcons" href="http://www.facebook.com/share.php?u={$feederPrefix}/event/cal/html/Public/{$recurrenceId}/{$guidEsc}">
              <img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge.gif" alt="Add to Facebook" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a class="eventIcons" href="http://www.facebook.com/share.php?u={$feederPrefix}/event/cal/html/Public/0/{$guidEsc}">
              <img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge.gif" alt="Add to Facebook" />
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="eventIcalName" select="concat($guid,'.ics')" />
        <a class="eventIcons" href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="Download .ics file for import to other calendars">
          <img src="{$resourcesRoot}/images/std-ical_icon.gif" alt="Download this event" />
        </a>
      </div>

      <h2 class="{$statusClass} eventTitle">
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="summary" />
      </h2>

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

      <span class="eventWhere">
        <span class="infoTitle">Where: </span>
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
            <xsl:variable name="locationLink"
              select="location/link" />
            <a href="{$locationLink}">
              <xsl:value-of select="location/address" />
              <xsl:if test="location/subaddress!=''">
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="location/subaddress" />
              </xsl:if>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </span>

      <xsl:if test="cost!=''">
        <span class="eventCost">
          <span class="infoTitle">Cost: </span>
          <xsl:value-of select="cost" />
        </span>
      </xsl:if>

      <span class="eventLink">
        <xsl:if test="link != ''">
          <xsl:variable name="link" select="link" />
          <span class="infoTitle">
            <a href="{$link}">More Info</a>
          </span>
        </xsl:if>
      </span>

      <br />
      <xsl:if
        test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
        <xsl:variable name="bwImage">
          <xsl:value-of
            select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" />
        </xsl:variable>
        <img src="{$bwImage}" class="bwEventImage" />
      </xsl:if>
      <span class="eventDescription">
        <span class="infoTitle">Description: </span>
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="description" />
          <xsl:with-param name="pattern" select="'&#xA;'" />
          <xsl:with-param name="replacement"></xsl:with-param>
        </xsl:call-template>
      </span>
      <br />

      <!--   <span class="eventListingCal">
        <xsl:if test="calendar/path!=''">
        Calendar:
        <xsl:variable name="calUrl" select="calendar/encodedPath"/>
        <a href="{$setSelection}&amp;calUrl={$calUrl}">
        <xsl:value-of select="calendar/name"/>
        </a>
        </xsl:if>
        </span>-->

      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <span class="eventStatus">
          <span class="infoTitle">Status: </span>
          <xsl:value-of select="status" />
        </span>
      </xsl:if>
      <xsl:choose>
        <xsl:when
          test="xproperties/X-BEDEWORK-CS/values/text != ''">
          <span class="eventContact">
            <span class="infoTitle">Co-sponsors: </span>
            <xsl:if test="creator != ''">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:value-of
                select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name" />
            </xsl:if>
            <xsl:value-of disable-output-escaping="yes"
              select="xproperties/X-BEDEWORK-CS/values/text" />
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span class="eventContact">
            <span class="infoTitle">Sponsor: </span>
            <xsl:if test="creator != ''">
              <xsl:variable name="creator"
                select="creator" />
              <xsl:value-of
                select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name" />
            </xsl:if>
            <xsl:value-of disable-output-escaping="yes"
              select="xproperties/X-BEDEWORK-CS/values/text" />
          </span>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="contact/name!='None'">
        <span class="eventContact">
          <span class="infoTitle">Contact Information: </span>
          <xsl:choose>
            <xsl:when test="contact/link=''">
              <xsl:value-of select="contact/name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="sponsorLink"
                select="contact/link" />
              <a href="{$sponsorLink}">
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
        </span>
      </xsl:if>
      <xsl:if
        test="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/values/text != ''">
        <span class="eventContact">
          <span class="infoTitle">Contact Information: </span>
          <xsl:value-of
            select="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/values/text" />
          <xsl:if
            test="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/parameters/X-BEDEWORK-PARAM-EMAIL != ''">
            <xsl:variable name="emailAddress"
              select="xproperties/node()[name()='X-BEDEWORK-STUDENT-CONTACT']/parameters/X-BEDEWORK-PARAM-EMAIL" />
            <a href="mailto:{$emailAddress}">E-mail</a>
          </xsl:if>
        </span>
      </xsl:if>
      <xsl:if test="categories[1]/category">
        <span class="eventCategories">
          <span class="infoTitle">Categories: </span>
          <xsl:for-each
            select="categories[1]/category[(word != 'Local') and (word != 'Main') and (word != 'Student') and (word != 'calCrossPublish')]">
            <xsl:value-of select="word" />
            <xsl:if test="position() != last()">, </xsl:if>
          </xsl:for-each>
        </span>
      </xsl:if>

      <xsl:if test="comments/comment">
        <span class="eventComments">
          <span class="infoTitle">Comments: </span>
          <xsl:for-each select="comments/comment">
            <p>
              <xsl:value-of select="value" />
            </p>
          </xsl:for-each>
        </span>
      </xsl:if>
    </div>

  </xsl:template>

</xsl:stylesheet>
