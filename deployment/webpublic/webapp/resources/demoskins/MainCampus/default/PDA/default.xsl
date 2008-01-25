<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xhtml"
    indent="yes"
    media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    standalone="yes"
    omit-xml-declaration="yes"/>

  <!-- ===============================================
             BEDEWORK MOBILE STYLESHEET

        Renders Bedework public client for mobile
        devices.  Call this stylesheet using:

        http://localhost:8080/cal/setup.do?browserTypeSticky=PDA
        to revert to the default browserType, use
        http://localhost:8080/cal/setup.do?browserTypeSticky=default

       ==============================================  -->

  <!-- URL of resources common to all bedework apps (javascript, images) -->
  <xsl:variable name="resourceCommons">../../../bedework-common</xsl:variable>

  <!-- DEFINE INCLUDES -->
  <!-- cannot use the resourceCommons variable in xsl:include paths -->
  <xsl:include href="../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/messages.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
  <xsl:variable name="resourcesRoot" select="/bedework/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection"/>
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export/a/@href"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/main/showPage"/>
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats/stats"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>


  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html xml:lang="en">
      <head>
        <title>Bedework Events Calendar</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="Pragma" content="no-cache"/>
        <meta http-equiv="Expires" content="-1"/>
        <link rel="stylesheet" href="{$resourcesRoot}/default/PDA/pda.css"/>
      </head>
      <body>
        <h1 id="homeTitle">
          Home Title Here
          <span id="homeLink">
            [<a href="{$setup}&amp;browserTypeSticky=default">home</a>]
          </span>
        </h1>
        <div id="titleBar">
          Bedework Events Calendar
        </div>
        <xsl:call-template name="infoAndNavigation"/>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='calendarList'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/bedework/calendars"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show the eventsCalendar -->
            <!-- main eventCalendar content -->
            <xsl:call-template name="listView"/>
          </xsl:otherwise>
        </xsl:choose>
        <!-- footer -->
        <p id="footer">
          <a href="{$setup}&amp;browserTypeSticky=PDA">Events Calendar</a> |
          <a href="{$setup}&amp;browserTypeSticky=default">Home Link</a><br/>
          <small>Footer Text</small>
        </p>
      </body>
    </html>
  </xsl:template>

  <!-- === Date Info and Navigation == -->
  <xsl:template name="infoAndNavigation">
    <div id="dateInfo">
      <xsl:if test="/bedework/page!='calendarList' and /bedework/page!='event'">
        &lt;<a href="{$setViewPeriod}&amp;date={$prevdate}">prev</a>
        <xsl:text> </xsl:text>
        <strong>
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Day'">
              <xsl:value-of select="substring(/bedework/eventscalendar/year/month/week/day/name,1,3)"/>, <xsl:value-of select="/bedework/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/bedework/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
              Week of <xsl:value-of select="/bedework/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/bedework/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:value-of select="/bedework/eventscalendar/year/month/longname"/>, <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/eventscalendar/year/value"/>
            </xsl:otherwise>
          </xsl:choose>
        </strong>
        <xsl:text> </xsl:text>
        <a href="{$setViewPeriod}&amp;date={$nextdate}">next</a>&gt;
        <br />
      </xsl:if>
    </div>
    <div id="mainNav">
      <xsl:choose>
        <xsl:when test="/bedework/page='eventscalendar'">
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Day'">
              day
            </xsl:when>
            <xsl:otherwise>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}">day</a>
            </xsl:otherwise>
          </xsl:choose> |
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
              week
             </xsl:when>
            <xsl:otherwise>
              <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}">week</a>
             </xsl:otherwise>
          </xsl:choose> |
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Month'">
              month
            </xsl:when>
            <xsl:otherwise>
              <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}">month</a>
            </xsl:otherwise>
          </xsl:choose> |
        </xsl:when>
        <xsl:otherwise>
          <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}">day</a> |
          <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}">week</a> |
          <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}">month</a> |
        </xsl:otherwise>
      </xsl:choose>
      <a href="{$setViewPeriod}&amp;viewType=todayView&amp;date={$curdate}">
        today
      </a><br />
      <xsl:choose>
        <xsl:when test="/bedework/selectionState/selectionType = 'calendar'">
          Calendar: <xsl:value-of select="/bedework/selectionState/subscriptions/subscription/calendar/name"/>
          <span class="link">[<a href="{$setSelection}">show all</a>]</span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="/bedework/page != 'calendarList'">
            <span class="calLinks"><a href="{$fetchPublicCalendars}">available calendars</a></span>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2 class="{$statusClass}">
      <xsl:if test="status='CANCELLED'">CANCELLED: </xsl:if>
      <xsl:choose>
        <xsl:when test="link != ''">
          <xsl:variable name="link" select="link"/>
          <a href="{$link}">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <td class="fieldname">When:</td>
        <td class="fieldval">
          <!-- always display local time -->
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <xsl:if test="start/allday = 'false'">
            <span class="time"><xsl:value-of select="start/time"/></span>
          </xsl:if>
          <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate">
            <xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <span class="time"><em>(all day)</em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
          <!-- if timezones are not local, or if floating add labels: -->
          <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
            <xsl:text> </xsl:text>
            --
            <strong>
              <xsl:choose>
                <xsl:when test="start/floating = 'true'">
                  Floating time
                </xsl:when>
                <xsl:otherwise>
                  Local time
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
                <table border="0" cellspacing="0" id="tztable">
                  <tr>
                    <td>
                      <strong>Start:</strong>
                    </td>
                    <td>
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
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="start/timezone/id"/></strong>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <strong>End:</strong>
                    </td>
                    <td>
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
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="end/timezone/id"/></strong>
                    </td>
                  </tr>
                </table>
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
                    <span class="time"><em>(all day)</em></span>
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
        </td>
        <th class="icalIcon" rowspan="2">
          <div id="eventIcons">
            <!--<a href="{$privateCal}/event/addEventRef.do?subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="Add event to MyCalendar" target="myCalendar">
              <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
            add to my calendar</a>-->
            <!--<xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
              <img src="{$resourcesRoot}/images/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
             download</a>-->
          </div>
        </th>
      </tr>
      <tr>
        <td class="fieldname">Where:</td>
        <td class="fieldval">
          <xsl:choose>
            <xsl:when test="location/link=''">
              <xsl:value-of select="location/address"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="locationLink" select="location/link"/>
              <a href="{$locationLink}">
                <xsl:value-of select="location/address"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="location/subaddress!=''">
            <br/><xsl:value-of select="location/subaddress"/>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="fieldname">Description:</td>
        <td colspan="2" class="fieldval description">
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname">Status:</td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname">Cost:</td>
          <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname">See:</td>
          <td colspan="2" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="contact/name!='none'">
        <tr>
          <td class="fieldname">Contact:</td>
          <td colspan="2" class="fieldval">
            <xsl:choose>
              <xsl:when test="contact/link=''">
                <xsl:value-of select="contact/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="contact/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="contact/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="contact/phone!=''">
              <br /><xsl:value-of select="contact/phone"/>
            </xsl:if>
            <!-- If you want to display email addresses, uncomment the
                 following 8 lines. -->
            <!-- <xsl:if test="contact/email!=''">
              <br />
              <xsl:variable name="email" select="contact/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}&amp;subject={$subject}">
                <xsl:value-of select="contact/email"/>
              </a>
            </xsl:if> -->
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="calendar/path!=''">
        <tr>
          <td class="fieldname">Calendar:</td>
          <td class="fieldval">
            <xsl:variable name="calUrl" select="calendar/encodedPath"/>
            <a href="{$setSelection}&amp;calUrl={$calUrl}">
              <xsl:value-of select="calendar/name"/>
            </a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="categories/category">
        <tr>
          <td class="fieldname">Categories:</td>
          <td class="fieldval">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <xsl:choose>
      <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
        <p>No events to display.</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[count(event)!=0]">
          <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
            <h3>
              <xsl:variable name="date" select="date"/>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
                <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
              </a>
            </h3>
          </xsl:if>
          <table class="eventList" border="0" cellpadding="0" cellspacing="0">
            <xsl:for-each select="event">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="subscriptionId" select="subscription/id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
              <xsl:variable name="guid" select="guid"/>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <tr>
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 0">
                    <xsl:attribute name="class">a</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">b</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <td class="date">
                  <xsl:choose>
                    <xsl:when test="start/allday = 'true' and
                                    start/shortdate = end/shortdate">
                      all day
                    </xsl:when>
                    <xsl:when test="start/shortdate = end/shortdate and
                                    start/time = end/time">
                      <xsl:value-of select="start/time"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="start/allday = 'true' and
                                        parent::day/shortdate = start/shortdate">
                          today
                        </xsl:when>
                        <xsl:when test="parent::day/shortdate != start/shortdate">
                          <span class="littleArrow">&#171;</span>
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
                          today
                        </xsl:when>
                        <xsl:when test="parent::day/shortdate != end/shortdate">
                          <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                          <span class="littleArrow">&#187;</span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/time"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="description">
                  <xsl:if test="status='CANCELLED'"><strong>CANCELLED: </strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <strong>
                          <xsl:value-of select="summary"/>:
                        </strong>
                        <xsl:value-of select="description"/>&#160;
                        <em>
                          <xsl:value-of select="location/address"/>
                          <xsl:if test="location/subaddress != ''">
                            , <xsl:value-of select="location/subaddress"/>
                          </xsl:if>.&#160;
                          <xsl:if test="cost!=''">
                            <xsl:value-of select="cost"/>.&#160;
                          </xsl:if>
                          <xsl:if test="contact/name!='none'">
                            Contact: <xsl:value-of select="contact/name"/>
                          </xsl:if>
                        </em>
                        - <xsl:value-of select="calendar/name"/>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="summary"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== CALENDARS PAGE ====-->
  <xsl:template match="calendars">
    <p><b>All Calendars</b><br />
    Select a calendar from the list below to see only that calendar's events.</p>
    <ul class="calendarTree">
      <xsl:apply-templates select="calendar/calendar" mode="calTree"/>
    </ul>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calendarCollection='false'">folder</xsl:when>
        <xsl:otherwise>calendar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="url" select="encodedPath"/>
    <li class="{$itemClass}">
      <a href="{$setSelection}&amp;calUrl={$url}" title="view calendar"><xsl:value-of select="name"/></a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>



  <!--==== NAVIGATION  ====-->

  <xsl:template name="dateSelect">
    <form name="calForm" method="post" action="{$urlPrefix}/setView.do">
      <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <xsl:if test="/bedework/periodname!='Year'">
            <td>
              <select name="viewStartDate.month">
                <xsl:for-each select="/bedework/monthvalues/val">
                  <xsl:variable name="temp" select="."/>
                  <xsl:variable name="pos" select="position()"/>
                  <xsl:choose>
                    <xsl:when test="/bedework/monthvalues[start=$temp]">
                      <option value="{$temp}" selected="selected">
                        <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$temp}">
                        <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
            <xsl:if test="/bedework/periodname!='Month'">
              <td>
                <select name="viewStartDate.day">
                  <xsl:for-each select="/bedework/dayvalues/val">
                    <xsl:variable name="temp" select="."/>
                    <xsl:variable name="pos" select="position()"/>
                    <xsl:choose>
                      <xsl:when test="/bedework/dayvalues[start=$temp]">
                        <option value="{$temp}" selected="selected">
                          <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                        </option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="{$temp}">
                          <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                        </option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </select>
              </td>
            </xsl:if>
          </xsl:if>
          <td>
            <xsl:variable name="temp" select="/bedework/yearvalues/start"/>
            <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
          </td>
          <td>
            <input name="submit" type="submit" value="go"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--==== UTILITY TEMPLATES ====-->

  <!-- search and replace template taken from
       http://www.biglist.com/lists/xsl-list/archives/200211/msg00337.html -->
  <xsl:template name="replace">
    <xsl:param name="string" select="''"/>
    <xsl:param name="pattern" select="''"/>
    <xsl:param name="replacement" select="''"/>
    <xsl:choose>
      <xsl:when test="$pattern != '' and $string != '' and contains($string, $pattern)">
        <xsl:value-of select="substring-before($string, $pattern)"/>
        <xsl:copy-of select="$replacement"/>
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
          <xsl:with-param name="replacement" select="$replacement"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
