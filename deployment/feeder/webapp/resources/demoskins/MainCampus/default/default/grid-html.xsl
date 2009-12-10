<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

<!-- **********************************************************************
    Copyright 2009 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits. -->

  <!-- URL of resources common to all bedework apps (javascript, images) -->
  <xsl:variable name="resourceCommons">../../../bedework-common</xsl:variable>

  <!-- DEFINE INCLUDES -->
  <!-- cannot use the resourceCommons variable in xsl:include paths -->
  <xsl:include href="../../../bedework-common/default/default/errors.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/messages.xsl"/>
  <xsl:include href="../../../bedework-common/default/default/util.xsl"/>
  <xsl:include href="./config.xsl"/>
  <xsl:include href="./strings.xsl"/>

  <!-- DEFINE GLOBAL CONSTANTS -->

  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root -->
  <xsl:variable name="resourcesRoot" select="/bedework/approot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

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
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <xsl:variable name="calendar-fetchForExport" select="/bedework/urlPrefixes/calendar/fetchForExport"/>
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  
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
    <html lang="en">
      <head>
        <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title> 
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
        <!-- load css -->
        <link rel="stylesheet" href="{$resourcesRoot}/default/default/blue.css"/>
        <link rel="stylesheet" href="../../../bedework-common/default/default/subColors.css"/>
        <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/default/default/print.css" />
        <!-- load javascript -->
        <xsl:if test="/bedework/page='event' or /bedework/page='displayCalendarForExport'">
          <script type="text/javascript" src="../../../bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
          <script type="text/javascript" src="../../../bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
          <link rel="stylesheet" href="../../../bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
          <link rel="stylesheet" href="../../../bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
          <script type="text/javascript" src="{$resourcesRoot}/resources/javascript/bedework.js">&#160;</script>
          <xsl:if test="/bedework/page='displayCalendarForExport'">
            <script type="text/javascript">
              <xsl:comment>
              $.datepicker.setDefaults({
                constrainInput: true,
                dateFormat: "yy-mm-dd",
                showOn: "both",
                buttonImage: "<xsl:value-of select='$resourcesRoot'/>/images/calIcon.gif",
                buttonImageOnly: true,
                gotoCurrent: true,
                duration: ""
              });
              $(document).ready(function() {
                $("#bwExportCalendarWidgetStartDate").datepicker({
                }).attr("readonly", "readonly");
                $("#bwExportCalendarWidgetEndDate").datepicker({
                }).attr("readonly", "readonly");
              });
              </xsl:comment>
            </script>
          </xsl:if>
        </xsl:if>
        <!-- address bar icon -->
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
      </head>
      <body>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <xsl:call-template name="listView"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="weekView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="monthView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="yearView"/>
              </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>
  
  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
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
      <a id="linkToEvent" href="javascript:showLink('{$urlPrefix}/event/eventView.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')" title="{$bwStr-SgEv-GenerateLinkToThisEvent}">
       <xsl:copy-of select="$bwStr-SgEv-LinkToThisEvent"/>
     </a>
      <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
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
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-When"/></td>
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
              <span class="time"><em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
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
                <table border="0" cellspacing="0" id="tztable">
                  <tr>
                    <td>
                      <strong><xsl:copy-of select="$bwStr-SgEv-Start"/></strong>
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
                      <strong><xsl:copy-of select="$bwStr-SgEv-End"/></strong>
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
        </td>
        <th class="icalIcon" rowspan="2">
          <div id="eventIcons">
            <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-AddEventToMyCalendar}" target="myCalendar">
              <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
              <xsl:copy-of select="$bwStr-SgEv-AddToMyCalendar"/>
            </a>
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-DownloadEvent}">
              <img src="{$resourcesRoot}/images/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
             <xsl:copy-of select="$bwStr-SgEv-Download"/></a>
          </div>
        </th>
      </tr>
      <tr>
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Where"/></td>
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
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Description"/></td>
        <td colspan="2" class="fieldval description">
          <xsl:if test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
            <xsl:variable name="bwImage"><xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:variable>
            <img src="{$bwImage}" class="bwEventImage"/>
          </xsl:if>
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="description"/>
            <xsl:with-param name="pattern" select="'&#xA;'"/>
            <xsl:with-param name="replacement"><br/></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-STATUS"/></td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Cost"/></td>
          <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-See"/></td>
          <td colspan="2" class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="contact/name!='none'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Contact"/></td>
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
      <xsl:if test="comments/comment">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Comments"/></td>
          <td class="fieldval comments">
            <xsl:for-each select="comments/comment">
              <p><xsl:value-of select="value"/></p>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-TopicalArea"/></td>
          <td class="fieldval">
            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
              <xsl:variable name="calUrl" select="values/text"/>
              <a href="{$setSelection}&amp;virtualPath={$calUrl}&amp;setappvar=curCollection({$calUrl})">
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="values/text"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
              </a><xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="categories/category">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Categories"/></td>
          <td class="fieldval">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <!--  xsl:if test="calendar/path!=''">
        <tr>
          <td class="fieldname">Calendar:</td>
          <td class="fieldval">
            <xsl:variable name="calUrl" select="calendar/encodedPath"/>
            <a href="{$setSelection}&amp;calUrl={$calUrl}">
              <xsl:value-of select="calendar/name"/>
            </a>
          </td>
        </tr>
      </xsl:if-->
    </table>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <table id="listTable" border="0" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
          <tr>
            <td class="noEventsCell">
              <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[event]">
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="5" class="dateRow">
                   <xsl:variable name="date" select="date"/>
                   <!-- <a href="{$listEvents}&amp;startDate={$date}&amp;endDate={$date}"> -->
                  
	               <xsl:choose>
		            <xsl:when test="/bedework/appvar/key = 'filter'">
  		              <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
		              <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
		              <!-- Define filters here: -->
		              <xsl:choose>
		                <xsl:when test="$filterName = 'grpAndCats'">
			              <xsl:variable name="group" select="substring-before($filterVal, '~')" /> 
					      <xsl:variable name="cats" select="substring-after($filterVal, '~')" />
						  <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$date}/grid-html/{$group}/{$cats}">
			                <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
			              </a>
		                </xsl:when>
		                <xsl:otherwise>
		                  <!-- Filter name not defined? Turn off filtering. -->
		                  <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$date}/grid-html/all/all">
			                <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
			              </a>
	  	                </xsl:otherwise>
		              </xsl:choose>
		            </xsl:when>
		            <xsl:otherwise>
		              <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$date}/grid-html/all/all">
			            <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
	                  </a>
		            </xsl:otherwise>
		           </xsl:choose>
		   
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event">
	              
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
              <xsl:variable name="guid" select="guid"/>
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
                <xsl:choose>
                  <xsl:when test="start/allday = 'true' and
                                  start/shortdate = end/shortdate">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <xsl:copy-of select="$bwStr-LsVw-AllDay"/>
                    </td>
                  </xsl:when>
                  <xsl:when test="start/shortdate = end/shortdate and
                                  start/time = end/time">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <!--<a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="start/time"/> -->
                      <a href="{$bwCacheHostUrl}/v1.0/event/blah2/list-html/{$recurrenceId}/{$guid}">
                      </a>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
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
                      </a>
                    </td>
                    <td class="{$dateRangeStyle} center">
	                  <a href="{$bwCacheHostUrl}/v1.0/event/blah3/list-html/{$recurrenceId}/{$guid}"></a>
                      <!-- <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a> -->
                    </td>
                    <td class="{$dateRangeStyle} left">
	                  <a href="{$bwCacheHostUrl}/v1.0/event/blah4/list-html/{$recurrenceId}/{$guid}">
                      <!-- <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"> -->
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
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
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
                  <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
	                  <a href="{$bwCacheHostUrl}/v1.0/event/blah/5/list-html/{$recurrenceId}/{$guid}">
                      <!-- ><a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"> -->
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
                            <xsl:copy-of select="$bwStr-LsVw-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
                          </xsl:if>
                        </em>
                        -
                        <span class="eventSubscription">
                          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                              <xsl:call-template name="substring-afterLastInstanceOf">
                                <xsl:with-param name="string" select="values/text"/>
                                <xsl:with-param name="char">/</xsl:with-param>
                              </xsl:call-template>
                              <xsl:if test="position()!=last()">, </xsl:if>
                            </xsl:for-each>
                          </xsl:if>
                        </span>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- ><a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"> -->
	                  <a href="{$bwCacheHostUrl}/v1.0/event/blah6/list-html/{$recurrenceId}/{$guid}">
                        <xsl:value-of select="summary"/>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                         -
                        <span class="eventSubscription">
                          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                            <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                              <xsl:call-template name="substring-afterLastInstanceOf">
                                <xsl:with-param name="string" select="values/text"/>
                                <xsl:with-param name="char">/</xsl:with-param>
                              </xsl:call-template>
                              <xsl:if test="position()!=last()">, </xsl:if>
                            </xsl:for-each>
                          </xsl:if>
                        </span>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="icons">
                  <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                  </a>
                  <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
                  <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-LsVw-DownloadEvent}">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-DownloadEvent}"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
  </xsl:template>

  <!--==== LIST EVENTS - for listing discrete events ====-->
  <xsl:template match="events" mode="eventList">
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
                <xsl:value-of select="keyword"/>
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
                <a href="{$bwCacheHostUrl}/v1.0/event/blah7/list-html/{$recurrenceId}/{$guid}">
                <!-- <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">  -->
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
                      <xsl:value-of select="word"/><xsl:if test="position() != last()">, </xsl:if>
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

  <xsl:template name="buildListEventsDaysOptions">
    <xsl:param name="i">1</xsl:param>
    <xsl:param name="total">31</xsl:param>
    <xsl:param name="default">7</xsl:param>
    <xsl:variable name="selected"><xsl:value-of select="/bedework/appvar[key='listEventsDays']/value"/></xsl:variable>

    <option onclick="this.form.setappvar.value='listEventsDay({$i})'">
      <xsl:attribute name="value"><xsl:value-of select="$i"/></xsl:attribute>
      <xsl:if test="($selected != '' and $i = $selected) or ($selected = '' and $i = $default)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
      <xsl:value-of select="$i"/>
    </option>

    <xsl:if test="$i &lt; $total">
      <xsl:call-template name="buildListEventsDaysOptions">
        <xsl:with-param name="i"><xsl:value-of select="$i + 1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="default"><xsl:value-of select="$default"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each select="/bedework/eventscalendar/year/month/week/day">
          <xsl:variable name="dayPos" select="position()"/>
          <xsl:if test="filler='false'">
            <td>
              <xsl:if test="/bedework/now/date = date">
                <xsl:attribute name="class">today</xsl:attribute>
              </xsl:if>
              <xsl:variable name="dayDate" select="date"/>
              <!-- ><a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink">  -->
	            <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$dayDate}/grid-html/all/all" class="dayLink">
                <xsl:value-of select="value"/>
              </a>
              <xsl:if test="event">
                <ul>
	              <xsl:choose>
			            <xsl:when test="/bedework/appvar/key = 'filter'">
	  		              <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
			              <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
			              <!-- Define filters here: -->
			              <xsl:choose>
			                <xsl:when test="$filterName = 'grpAndCats'">
			  	              <xsl:call-template name="processGrpAndCats">
				                <xsl:with-param name="list" select="$filterVal"/>
				                <xsl:with-param name="dayPos" select="$dayPos"/>
				              </xsl:call-template>
			                </xsl:when>
			                <xsl:otherwise>
			                  <!-- Filter name not defined? Turn off filtering. -->
			                  <xsl:apply-templates select="event" mode="calendarLayout">
				              	<xsl:with-param name="dayPos" select="$dayPos"/>
			                  </xsl:apply-templates>
		  	                </xsl:otherwise>
			              </xsl:choose>
			            </xsl:when>
			            <xsl:otherwise>
			              <xsl:apply-templates select="event" mode="calendarLayout">
				            <xsl:with-param name="dayPos" select="$dayPos"/>
			              </xsl:apply-templates>
			            </xsl:otherwise>
			      </xsl:choose>
                </ul>
              </xsl:if>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>

  <!--==== MONTH CALENDAR VIEW ====-->
  <xsl:template name="monthView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="/bedework/eventscalendar/year/month/week">
        <tr>
          <xsl:for-each select="day">
            <xsl:variable name="dayPos" select="position()"/>
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:if test="/bedework/now/date = date">
                    <xsl:attribute name="class">today</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate" select="date"/>
                  <xsl:choose>
				    <xsl:when test="/bedework/appvar/key = 'filter'">
		              <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
		              <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
		              <!-- Define filters here: -->
		              <xsl:choose>
		                <xsl:when test="$filterName = 'grpAndCats'">
			              <xsl:variable name="group" select="substring-before($filterVal, '~')" /> 
					      <xsl:variable name="cats" select="substring-after($filterVal, '~')" />
						  <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{dayDate}/grid-html/{$group}/{$cats}">
			                <xsl:value-of select="value"/>
			              </a>
		                </xsl:when>
		                <xsl:otherwise>
		                  <!-- Filter name not defined? Turn off filtering. -->
		                  <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$dayDate}/grid-html/all/all">
			                <xsl:value-of select="value"/>
			              </a>
	  	                </xsl:otherwise>
		              </xsl:choose>
		            </xsl:when>
		            <xsl:otherwise>
		              <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$dayDate}/grid-html/all/all">
			            <xsl:value-of select="value"/>
	                  </a>
		            </xsl:otherwise>
		          </xsl:choose>
                  <xsl:if test="event">
                    <ul>
	                  <xsl:choose>
			            <xsl:when test="/bedework/appvar/key = 'filter'">
	  		              <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
			              <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
			              <!-- Define filters here: -->
			              <xsl:choose>
			                <xsl:when test="$filterName = 'grpAndCats'">
			  	              <xsl:call-template name="processGrpAndCats">
				                <xsl:with-param name="list" select="$filterVal"/>
				                <xsl:with-param name="dayPos" select="$dayPos"/>
				              </xsl:call-template>
			                </xsl:when>
			                <xsl:otherwise>
			                  <!-- Filter name not defined? Turn off filtering. -->
			                  <xsl:apply-templates select="event" mode="calendarLayout">
				              	<xsl:with-param name="dayPos" select="$dayPos"/>
			                  </xsl:apply-templates>
		  	                </xsl:otherwise>
			              </xsl:choose>
			            </xsl:when>
			            <xsl:otherwise>
			              <xsl:apply-templates select="event" mode="calendarLayout">
				            <xsl:with-param name="dayPos" select="$dayPos"/>
			              </xsl:apply-templates>
			            </xsl:otherwise>
			          </xsl:choose>
                    </ul>
                  </xsl:if>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--== EVENTS IN THE CALENDAR GRID ==-->
  <xsl:template match="event" mode="calendarLayout">
    <xsl:param name="dayPos"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <!-- Default alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
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
    <li>
      <!-- <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" class="{$eventClass} {$subscriptionClass}"> -->
	    <a href="{$bwCacheHostUrl}/v1.0/event/list-html/{$recurrenceId}/{$guid}" class="{$eventClass} {$subscriptionClass}">
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/><xsl:text> </xsl:text></xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            <xsl:copy-of select="$bwStr-EvCG-Cont"/>
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-EvCG-AllDayColon"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="summary"/>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/></span></xsl:if>
          <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative"><xsl:copy-of select="$bwStr-EvCG-Tentative"/></span></xsl:if>
          <strong><xsl:value-of select="summary"/></strong><br/>
          <xsl:copy-of select="$bwStr-EvCG-Time"/>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <xsl:copy-of select="$bwStr-EvCG-AllDay"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="start/shortdate != ../shortdate">
                <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="start/time"/>
              <xsl:if test="(start/time != end/time) or (start/shortdate != end/shortdate)">
                -
                <xsl:if test="end/shortdate != ../shortdate">
                  <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            <xsl:copy-of select="$bwStr-EvCG-Location"/><xsl:text> </xsl:text><xsl:value-of select="location/address"/><br/>
          </xsl:if>
          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
            <xsl:copy-of select="$bwStr-EvCG-TopicalArea"/>
              <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="values/text"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="position()!=last()">, </xsl:if>
              </xsl:for-each>
          </xsl:if>
        </span>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="categories" mode="customEventColor">
    <!-- Set custom color schemes here.
         This template looks at the categories found in the event and
         returns a color class for use with the "subscriptionClass" variable.
         The classes suggested below come from bwColors.css found in the bedework-common directory. -->
    <xsl:choose>
       <!--
       <xsl:when test="category/value = 'Athletics'">bwltpurple</xsl:when>
       <xsl:when test="category/value = 'Arts'">bwltsalmon</xsl:when>
       -->
       <xsl:otherwise></xsl:otherwise> <!-- do nothing -->
    </xsl:choose>
  </xsl:template>

  <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <table id="yearCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &lt;= 3]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 3) and (position() &lt;= 6)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 6) and (position() &lt;= 9)]"/>
      </tr>
      <tr>
        <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &gt; 9]"/>
      </tr>
    </table>
  </xsl:template>

  <!-- year view month tables -->
  <xsl:template match="month">
    <td>
      <table class="yearViewMonthTable" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td colspan="8" class="monthName">
            <xsl:variable name="firstDayOfMonth" select="week/day/date"/>
            <a href="{$bwCacheHostUrl}/v1.0/v1.0/genFeedPeriod/month/{$firstDayOfMonth}/grid-html/all/all">
            <!-- <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$firstDayOfMonth}">  -->
              <xsl:value-of select="longname"/>
            </a>
          </td>
        </tr>
        <tr>
          <th>&#160;</th>
          <xsl:for-each select="/bedework/shortdaynames/val">
            <th><xsl:value-of select="."/></th>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="week">
          <tr>
            <td class="weekCell">
              <xsl:variable name="firstDayOfWeek" select="day/date"/>
              <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/week/{$firstDayOfWeek}/grid-html/all/all">
              <!-- <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$firstDayOfWeek}"> -->
                <xsl:value-of select="value"/>
              </a>
            </td>
            <xsl:for-each select="day">
              <xsl:choose>
                <xsl:when test="filler='true'">
                  <td class="filler">&#160;</td>
                </xsl:when>
                <xsl:otherwise>
                  <td>
                    <xsl:if test="/bedework/now/date = date">
                      <xsl:attribute name="class">today</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="dayDate" select="date"/>
                    <a href="{$bwCacheHostUrl}/v1.0/genFeedPeriod/day/{$dayDate}/grid-html/all/all">
                    <!-- <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}"> -->
                      <xsl:attribute name="class">today</xsl:attribute>
                      <xsl:value-of select="value"/>
                    </a>
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </table>
    </td>
  </xsl:template>

  <!--==== CALENDARS ====-->  

  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <h2 class="bwStatusConfirmed"><xsl:copy-of select="$bwStr-Cals-ExportCals"/></h2>
    <div id="export">
      <p>
        <strong><xsl:copy-of select="$bwStr-Cals-CalendarToExport"/></strong>
      </p>
      <div class="indent">
        <xsl:copy-of select="$bwStr-Cals-Name"/><xsl:text> </xsl:text><strong><em><xsl:value-of select="name"/></em></strong><br/>
        <xsl:copy-of select="$bwStr-Cals-Path"/><xsl:text> </xsl:text><xsl:value-of select="path"/>
      </div>
      <p>
        <strong><xsl:copy-of select="$bwStr-Cals-EventDateLimits"/></strong>
      </p>
      <form name="exportCalendarForm" id="exportCalendarForm" action="{$export}" method="post">
        <input type="hidden" name="calPath">
          <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year" value=""/>
        <input type="hidden" name="eventStartDate.month" value=""/>
        <input type="hidden" name="eventStartDate.day" value=""/>
        <input type="hidden" name="eventEndDate.year" value=""/>
        <input type="hidden" name="eventEndDate.month" value=""/>
        <input type="hidden" name="eventEndDate.day" value=""/>
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no"/>
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of select="name"/>.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-TodayForward"/>
        <input type="radio" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-AllDates"/>
        <input type="radio" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Cals-DateRange"/>
        <div id="exportDateRange" class="invisible">
          <xsl:copy-of select="$bwStr-Cals-Start"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetStartDate" id="bwExportCalendarWidgetStartDate" size="10"/>
          <span id="bwExportEndField">E<xsl:copy-of select="$bwStr-Cals-End"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetEndDate" id="bwExportCalendarWidgetEndDate" size="10"/></span>
        </div>
        <p><input type="submit" value="{$bwStr-Cals-Export}" class="bwWidgetSubmit" onclick="fillExportFields(this.form)"/></p>
      </form>
    </div>
  </xsl:template>

  <xsl:template name="processGrpAndCats">
    <xsl:param name="list" /> 
    <xsl:param name="dayPos" />
    <xsl:variable name="group" select="substring-before($list, '~')" /> 
    <xsl:variable name="remaining" select="substring-after($list, '~')" />
    <xsl:call-template name="processCategories">
	  <xsl:with-param name="group" select="$group" />
      <xsl:with-param name="list" select="$remaining" /> 
      <xsl:with-param name="dayPos" select="$remaining" /> 
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="processCategories">
	<xsl:param name="group" />
    <xsl:param name="list" /> 
    <xsl:param name="dayPos" />
    <xsl:choose>
	  <xsl:when test="contains($list, '~')">
		<!-- Grab the first off the list and process -->
	  	<xsl:variable name="catid" select="substring-before($list, '~')" /> 
	    <xsl:variable name="remaining" select="substring-after($list, '~')" />
	    <xsl:choose>
		  <xsl:when test="$group = 'all'">
	        <xsl:apply-templates select="event[categories/category/id = $catid]">  
	          <xsl:with-param name="dayPos" select="$dayPos"/>
	        </xsl:apply-templates> 
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:apply-templates select="event[categories/category/id = $catid]">
	          <xsl:with-param name="dayPos" select="$dayPos"/>
	        </xsl:apply-templates>
	      </xsl:otherwise>
	    </xsl:choose>

		<!-- now use recursion to process the remaining categories -->
	    <xsl:call-template name="processCategories">
	      <xsl:with-param name="list" select="$remaining" /> 
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- No more tildes, so this is the last category.  Process it -->
		<xsl:choose>
		  <xsl:when test="$group = 'all'">
			<xsl:choose>
			  <xsl:when test="$list = 'all'">
	            <xsl:apply-templates select="event">
		          <xsl:with-param name="dayPos" select="$dayPos"/>
		        </xsl:apply-templates>
	          </xsl:when>
	          <xsl:otherwise>
		        <xsl:apply-templates select="event[categories/category/id = $list]" mode="calendarLayout">
			      <xsl:with-param name="dayPos" select="$dayPos"/>
		        </xsl:apply-templates>
		      </xsl:otherwise>
	        </xsl:choose>
	      </xsl:when>
	      <xsl:otherwise>
		    <xsl:choose>
			  <xsl:when test="$list = 'all'">
	            <xsl:apply-templates select="event[creator = $group]" />
	          </xsl:when>
	          <xsl:otherwise>
		        <xsl:choose>
		          <xsl:when test="event/creator = $group">
			        <xsl:apply-templates select="event[categories/category/id = $list]" mode="calendarLayout">
				      <xsl:with-param name="dayPos" select="$dayPos"/>
			        </xsl:apply-templates>
		          </xsl:when>
		        </xsl:choose>
		      </xsl:otherwise>
			</xsl:choose>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

</xsl:stylesheet>