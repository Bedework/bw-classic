<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--========  Display Events Table =========-->
  <xsl:template name="display-events-table">
        <xsl:param name="node"/>
        <xsl:param name="suite-name"/>
        <xsl:choose>

        <!-- filter on group but not category -->
        <xsl:when test="(/bedework/appvar[key = 'group']/value and not(/bedework/appvar[key = 'group']/value = 'all')) and (not(/bedework/appvar[key = 'category']/value) or (/bedework/appvar[key = 'category']/value='all'))">
        <xsl:for-each  select="event[not(categories/category[value|word ='Ongoing']) and not(categories/category[value|word ='Local'])]"> 
             <xsl:if test="categories/category[value=$suite-name] or categories/category[word=$suite-name]">
                <xsl:call-template name="split-for-groups">
                          <xsl:with-param name="node" select="."/>
                         <xsl:with-param name="list"><xsl:value-of select="/bedework/appvar[key = 'group']/value"/></xsl:with-param>
                         <xsl:with-param name="delimiter">,</xsl:with-param>
                         <xsl:with-param name="suite-name" select="$suite-name"/>
                </xsl:call-template>
             </xsl:if>
        </xsl:for-each>
        </xsl:when>

        <!-- filter on category but not group  -->
        <xsl:when test="(not(/bedework/appvar[key = 'group']/value) or (/bedework/appvar[key = 'group']/value = 'all')) and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value='all')">
        <xsl:for-each  select="event[not(categories/category[value|word ='Ongoing']) and not(categories/category[value|word ='Local'])]"> 
             <xsl:if test="categories/category[value=$suite-name] or categories/category[word=$suite-name]">
                <xsl:call-template name="split-for-events">
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="list"> <xsl:value-of select="/bedework/appvar[key = 'category']/value"/></xsl:with-param>
                        <xsl:with-param name="delimiter">~</xsl:with-param>
                        <xsl:with-param name="suite-name" select="$suite-name"/>
                </xsl:call-template>
             </xsl:if>
      </xsl:for-each>
      </xsl:when>

        <!-- filter on both group and category  -->
        <xsl:when test="(/bedework/appvar[key = 'group']/value) and not(/bedework/appvar[key = 'group']/value = 'all') and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value='all')">
          <xsl:for-each  select="event[not(categories/category[value|word ='Ongoing']) and not(categories/category[value|word ='Local'])]"> 
             <xsl:if test="categories/category[value=$suite-name] or categories/category[word=$suite-name]">
                 <xsl:call-template name="split-for-groups-events-wrapper">
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="list"><xsl:value-of select="/bedework/appvar[key = 'group']/value"/></xsl:with-param>
                        <xsl:with-param name="delimiter">,</xsl:with-param>
                        <xsl:with-param name="suite-name" select="$suite-name"/>
                 </xsl:call-template>
             </xsl:if>
          </xsl:for-each>
        </xsl:when>

        <!-- NO filter (either group or category) -->
        <xsl:otherwise>
        <xsl:for-each  select="event[not(categories/category[value|word ='Ongoing']) and not(categories/category[value|word ='Local'])]"> 
             <xsl:if test="categories/category[value=$suite-name] or categories/category[word=$suite-name]">
                <xsl:call-template name="eventRow"> 
                     <xsl:with-param name="node" select="."/>
                     <xsl:with-param name="suite-name" select="$suite-name"/>
                </xsl:call-template>
             </xsl:if> 
        </xsl:for-each>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--======== list view ==========-->
  <xsl:template name="list-view">
        <xsl:param name="node"/>
        <xsl:param name="suite-name"/>

    <table class="eventList">

      <xsl:choose>
        <!--  User filtered on a group or subset of groups, but not on category -->
        <xsl:when test="not(/bedework/appvar[key = 'group']/value = 'all') and (/bedework/appvar[key = 'group']) and (not(/bedework/appvar[key = 'category']/value) or (/bedework/appvar[key = 'category']/value='all'))">
          <tr> 
              <td class="eventFilterInfo" colspan="3">Displaying Events for Group: <span id="currGroupName" class="displayGroupName">
                  <xsl:value-of select="/bedework/urlPrefixes/groups/group[eventOwner = (/bedework/appvar[key = 'group']/value)]/name"/>
                  </span>
                  <xsl:text> </xsl:text>
                  <xsl:choose>
                  <xsl:when test="$suite-name='Main'">
                       <a id="allView" href="/cal/?setappvar=group(all)">(select all groups)</a>
                  </xsl:when>
                  <xsl:otherwise>
                       <a id="allView" href="/student/?setappvar=group(all)">(select all groups)</a>
                  </xsl:otherwise>
                  </xsl:choose>
               </td>
          </tr>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[not(filler = 'true')]">
              <xsl:call-template name="display-events-table"> 
                 <xsl:with-param name="node" select="."/>
                 <xsl:with-param name="suite-name" select="$suite-name"/>
              </xsl:call-template>
          </xsl:for-each>
        </xsl:when>

        <!--  User filtered on a category or subset of categories, but not on group -->
	<xsl:when test="not(/bedework/appvar[key = 'category']/value = 'all') and (/bedework/appvar[key = 'category']/value) and (not(/bedework/appvar[key = 'group']/value) or (/bedework/appvar[key = 'group']/value = 'all'))">	
	    <tr>
              <td class="eventFilterInfo" colspan="3">Displaying Events for Calendar View 
                    <span class="displayGroupName"><xsl:value-of select="/bedework/appvar[key = 'categoryclass']/value"/>,</span>
		<xsl:choose>
          	<xsl:when test="contains(/bedework/appvar[key = 'category']/value,'~')">
          		Categories:
				<xsl:choose>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
					  <span id="currCategories" class="displayGroupName">Concert/Music, Dance Performance, Exhibit, Masterclass, Movie/Film, Reading, Theater</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
					  <span id="currCategories" class="displayGroupName">Athletics/Intramurals/Recreation, Athletics/Varsity Sports/Men, Athletics/Varsity Sports/Women</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
					  <span id="currCategories" class="displayGroupName">Conference/Symposium, Lecture/Talk, Panel/Seminar/Colloquium</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
					  <span id="currCategories" class="displayGroupName">Commencement, Founders' Day, Holiday, MLK, Parents' and Family Weekend</span>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
          		Category:
			  <span id="currCategories" class="displayGroupName"><xsl:value-of select="/bedework/appvar[key = 'category']/value"/></span>
			</xsl:otherwise>
		  </xsl:choose>
		  <xsl:text> </xsl:text>

                  <xsl:choose>
                  <xsl:when test="$suite-name='Main'">
                       <a id="allView" href="/cal/?setappvar=category(all)&amp;setappvar=categoryclass(all)">(select all categories)</a>
                  </xsl:when>
                  <xsl:otherwise>
                       <a id="allView" href="/student/?setappvar=category(all)&amp;setappvar=categoryclass(all)">(select all categories)</a>
                  </xsl:otherwise>
                  </xsl:choose>
                 </td>
          </tr>  
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[not(filler = 'true')]">
            <xsl:call-template name="display-events-table"> 
                 <xsl:with-param name="node" select="."/>
                 <xsl:with-param name="suite-name" select="$suite-name"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>

        <!-- User filtered on both group and category -->
	<xsl:when test="(/bedework/appvar[key = 'group']) and not(/bedework/appvar[key = 'group']/value = 'all')       and (/bedework/appvar[key = 'category']/value) and not(/bedework/appvar[key = 'category']/value='all')">
          <tr>
            <td class="eventFilterInfo" colspan="3">Displaying Events for Group: <span id="currGroupName" class="displayGroupName">
            <xsl:value-of select="/bedework/urlPrefixes/groups/group[eventOwner = (/bedework/appvar[key = 'group']/value)]/name"/>
            </span><xsl:text> </xsl:text>

                  <xsl:choose>
                  <xsl:when test="$suite-name='Main'">
                       <a id="allView" href="/cal/?setappvar=group(all)">(select all groups)</a>
                  </xsl:when>
                  <xsl:otherwise>
                       <a id="allView" href="/student/?setappvar=group(all)">(select all groups)</a>
                  </xsl:otherwise>
                  </xsl:choose>
             </td>

          </tr>
	  <tr>
            <td class="eventFilterInfo" colspan="3">Displaying Events for Calendar View <span class="displayGroupName"><xsl:value-of select="/bedework/appvar[key = 'categoryclass']/value"/>,</span>
		<xsl:choose>
          	<xsl:when test="contains(/bedework/appvar[key = 'category']/value,'~')">
          		Categories:
				<xsl:choose>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Arts'">
					  <span id="currCategories" class="displayGroupName">Concert/Music, Dance Performance, Exhibit, Masterclass, Movie/Film, Reading, Theater</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Athletics/Recreation'">
					  <span id="currCategories" class="displayGroupName">Athletics/Intramurals/Recreation, Athletics/Varsity Sports/Men, Athletics/Varsity Sports/Women</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'Lectures/Conferences'">
					  <span id="currCategories" class="displayGroupName">Conference/Symposium, Lecture/Talk, Panel/Seminar/Colloquium</span>
					</xsl:when>
					<xsl:when test="/bedework/appvar[key = 'categoryclass']/value = 'University Events'">
					  <span id="currCategories" class="displayGroupName">Commencement, Founders' Day, Holiday, MLK, Parents' and Family Weekend</span>
					</xsl:when>
				</xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
          		Category:
			  <span id="currCategories" class="displayGroupName"><xsl:value-of select="/bedework/appvar[key = 'category']/value"/></span>
		  </xsl:otherwise>
		  </xsl:choose>
	
		  <xsl:text> </xsl:text>
                  <xsl:choose>
                  <xsl:when test="$suite-name='Main'">
		        <a id="allView" href="/cal/?setappvar=category(all)&amp;setappvar=categoryclass(all)">(select all categories)</a>
                  </xsl:when>
                  <xsl:otherwise>
		        <a id="allView" href="/student/?setappvar=category(all)&amp;setappvar=categoryclass(all)">(select all categories)</a>
                  </xsl:otherwise>
                  </xsl:choose>
            </td>
          </tr>
	    <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[not(filler = 'true')]">
               <xsl:call-template name="display-events-table"> 
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="suite-name" select="$suite-name"/>
               </xsl:call-template>
          </xsl:for-each>
        </xsl:when>

        <xsl:when test="(/bedework/selectionState/selectionType = 'calendar')">
          <tr>
            <td class="eventFilterInfo" colspan="3">Only displaying events in calendar: <span class="displayGroupName"><xsl:value-of select="/bedework/selectionState/subscriptions/subscription/calendar/name"/></span><xsl:text> </xsl:text><a id="allView" href="setSelection.do?b=de{$allGroupsAppVar}">(return to all calendars)</a></td>
          </tr>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[not(filler = 'true')]">
             <xsl:call-template name="display-events-table"> 
                  <xsl:with-param name="node" select="."/>
                  <xsl:with-param name="suite-name" select="$suite-name"/>
             </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[not(filler = 'true')]">
             <xsl:call-template name="display-events-table"> 
                   <xsl:with-param name="node" select="."/>
                   <xsl:with-param name="suite-name" select="$suite-name"/>
             </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <tr>
        <td class="fillrow">&#160;</td>
        <td class="fillrow">&#160;</td>
        <td class="fillrow">&#160;</td>
      </tr>
    </table>
  </xsl:template>

  <!--=========  Split for Groups ==========-->
  <xsl:template name="split-for-groups">
        <xsl:param name="node"/>
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        <xsl:param name="suite-name"/>
                 <xsl:variable name="newlist">
                         <xsl:choose>
                                <xsl:when test="contains($list, $delimiter)"><xsl:value-of select="normalize-space($list)"/></xsl:when>
                                 <xsl:otherwise><xsl:value-of select="concat(normalize-space($list), $delimiter)"/></xsl:otherwise>
                         </xsl:choose>
                 </xsl:variable>
                     <xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
                     <xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>
                         <xsl:variable name="cosponsors" select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION"/>
                          <xsl:if test="($first = /bedework/urlPrefixes/groups/group/eventOwner)">
                                  <xsl:choose>
                                   <xsl:when test="$first = creator">
                                                <xsl:call-template name="eventRow"> 
                                                       <xsl:with-param name="node" select="."/>
                                                       <xsl:with-param name="suite-name" select="$suite-name"/>
                                                </xsl:call-template>
                                   </xsl:when>
                                   <xsl:when test="(contains($cosponsors, concat($first,',')) and ($first != ''))">
                                                <xsl:call-template name="eventRow"> 
                                                       <xsl:with-param name="node" select="."/>
                                                       <xsl:with-param name="suite-name" select="$suite-name"/>
                                                </xsl:call-template>
                                  </xsl:when>
                                  <xsl:otherwise>
                                        <xsl:if test="$remaining">
                                            <xsl:call-template name="split-for-groups">
                                                <xsl:with-param name="node" select="."/>
                                                <xsl:with-param name="list" select="$remaining"/>
                                                <xsl:with-param name="delimiter">,</xsl:with-param>
                                                <xsl:with-param name="suite-name" select="$suite-name"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                  </xsl:otherwise>
                                  </xsl:choose>
                        </xsl:if>
  </xsl:template>

  <!--=========  Split for Groups Wrapper ==========-->
 <xsl:template name="split-for-groups-events-wrapper">
          <xsl:param name="node"/>
         <xsl:param name="list"/>
         <xsl:param name="delimiter"/>
         <xsl:param name="suite-name"/>
         <xsl:variable name="newlist">
             <xsl:choose>
             <xsl:when test="contains($list, $delimiter)">
                 <xsl:value-of select="normalize-space($list)"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:value-of select="concat(normalize-space($list), $delimiter)"/>
             </xsl:otherwise>
             </xsl:choose>
         </xsl:variable>

         <xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
         <xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>
         <xsl:variable name="cosponsors" select="xproperties/X-BEDEWORK-CS/parameters/X-BEDEWORK-PARAM-DESCRIPTION"/>
         <xsl:choose>
         <xsl:when test="$first = creator">
                   <xsl:call-template name="split-for-events">
                           <xsl:with-param name="node" select="."/>
                           <xsl:with-param name="list"><xsl:value-of select="/bedework/appvar[key = 'category']/value"/></xsl:with-param>
                           <xsl:with-param name="delimiter">~</xsl:with-param>
                           <xsl:with-param name="suite-name" select="$suite-name"/>
                   </xsl:call-template>
         </xsl:when>
         <xsl:when test="(contains($cosponsors, concat($first,',')) and ($first != ''))">
                    <xsl:call-template name="split-for-events">
                            <xsl:with-param name="node" select="."/>
                            <xsl:with-param name="list"><xsl:value-of select="/bedework/appvar[key = 'category']/value"/></xsl:with-param>
                            <xsl:with-param name="delimiter">~</xsl:with-param>
                            <xsl:with-param name="suite-name" select="$suite-name"/>
                    </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="$remaining">
                   <xsl:call-template name="split-for-groups-events-wrapper">
                             <xsl:with-param name="node" select="."/>
                             <xsl:with-param name="list" select="$remaining"/>
                             <xsl:with-param name="delimiter">,</xsl:with-param>
                             <xsl:with-param name="suite-name" select="$suite-name"/>
                   </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
         </xsl:choose>
  </xsl:template>
  
  <!--=========  Event Row  ==========-->
  <xsl:template name="eventRow">
          <xsl:param name="node"/>
          <xsl:param name="suite-name"/>
    <xsl:variable name="id" select="id"/>
    <xsl:variable name="subscriptionId" select="subscription/id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="guidEsc" select="translate(guid, '.', '_')"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="currentdate" select="parent::day/date"/>
    <!-- <xsl:if test="not(preceding::event[parent::day/date=$currentdate])"> -->
	<tr>
            <td colspan="3" class="dateRow">
	            <xsl:variable name="date" select="parent::day/date"/>
	            <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}"> <xsl:value-of select="parent::day/name"/>, <xsl:value-of select="parent::day/longdate"/> </a>
	    </td>
	</tr>
       <!-- </xsl:if> -->
    	<tr>

      <!-- Event Date / Time column-->
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
      <td class="time {$dateRangeStyle}">
        <xsl:choose>
          <xsl:when test="start/allday = 'true' and start/shortdate = end/shortdate">All day</xsl:when>
          <xsl:when test="start/shortdate = end/shortdate and start/time = end/time">
            <xsl:value-of select="start/time"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="start/allday = 'true' and parent::day/shortdate = start/shortdate"> Today </xsl:when>
              <xsl:when test="parent::day/shortdate != start/shortdate">
                <span class="littleArrow">«</span><xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- <xsl:value-of select="start/time"/> -->
                <!-- Display times without :00 and no AM / PM on first time -->
                <xsl:value-of select="start/hour"/>
                <xsl:if test="start/twodigitminute != '00'">
                  <xsl:text>:</xsl:text>
                  <xsl:value-of select="start/twodigitminute"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/ampm = 1">
                    <xsl:text>pm</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>am</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> - </xsl:text>
            <xsl:choose>
              <xsl:when test="end/allday = 'true' and parent::day/shortdate = end/shortdate"> Today </xsl:when>
              <xsl:when test="parent::day/shortdate != end/shortdate">
                <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                <span class="littleArrow">»</span>
              </xsl:when>
              <xsl:otherwise>
                <!-- <xsl:value-of select="end/time"/> -->
                <!-- Display times without :00 show AM / PM time -->
                <xsl:value-of select="end/hour"/>
                <xsl:if test="end/twodigitminute != '00'">
                  <xsl:text>:</xsl:text>
                  <xsl:value-of select="end/twodigitminute"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="end/ampm = 1">
                    <xsl:text>pm</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>am</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <!-- Event Description Column -->
      <xsl:variable name="descriptionClass">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">description bwStatusCancelled</xsl:when>
          <xsl:when test="status='TENTATIVE'">description bwStatusTentative</xsl:when>
          <xsl:otherwise>description</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- Subscription styles.
        These are set in the add/modify subscription forms in the admin client;
        if present, these override the background-color set by eventClass. The
        subscription styles should not be used for cancelled events (tentative is ok). -->
      <xsl:variable name="subscriptionClass">
        <xsl:if test="status != 'CANCELLED' and                     subscription/subStyle                     != '' and                     subscription/subStyle != 'default'">
          <xsl:value-of select="subscription/subStyle"/>
        </xsl:if>
      </xsl:variable>
      <td class="{$descriptionClass} {$subscriptionClass}">
      <ul>
          <xsl:if test="status='CANCELLED'">
            <strong>CANCELLED: </strong>
          </xsl:if>
	  <xsl:if test="status='TENTATIVE'">
             <strong>TENTATIVE: </strong>
          </xsl:if>

          <xsl:if test="$suite-name='Student'">
              <h5> <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"> <xsl:value-of select="summary"/> </a>  </h5>
              <xsl:if test="location/address != ''"> <li>Location: <xsl:value-of select="location/address"/></li> </xsl:if>
              Categories:
              <xsl:for-each select="categories[1]/category[(value != 'Local') and (value != 'Main') and (value != 'Student') and (value != 'calCrossPublish')]">
                         <xsl:value-of select="value"/>
                         <xsl:if test="position() != last()">, </xsl:if>
              </xsl:for-each>
          </xsl:if>
          <xsl:if test="$suite-name='Main'">
              <h5> <a href="{$eventView}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"/></h5>
              <xsl:choose>
              <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'"> 
                       <li class="titleEvent"><xsl:value-of select="summary"/></li>
                       <xsl:if test="location/address != ''"> <li>Location: <xsl:value-of select="location/address"/></li> </xsl:if>
                       <xsl:if test="cost!=''"><li>Cost: <xsl:value-of select="cost"/></li></xsl:if>
                       <xsl:if test="contact/name!='none'"><li>Contact: <xsl:value-of select="contact/name"/></li></xsl:if>
	   	       <xsl:choose>
	  	       <xsl:when test="xproperties/X-BEDEWORK-CS/values/text != ''">
			 	<li>
			 	<span class="infoTitle">Co-sponsors: </span>
			  	<xsl:if test="creator != ''">
			  		<xsl:variable name="creator" select="creator"/>
		 			<xsl:value-of select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name"/>
			  	</xsl:if>
			 	<xsl:value-of disable-output-escaping="yes" select="xproperties/X-BEDEWORK-CS/values/text"/>
				</li>
	  	       </xsl:when>
	  	       <xsl:otherwise>
	  			<li>
				 <span class="infoTitle">Sponsor: </span>
				  <xsl:if test="creator != ''">
				  	<xsl:variable name="creator" select="creator"/>
			 		<xsl:value-of select="/bedework/urlPrefixes/groups/group[eventOwner = $creator]/name"/>
				  </xsl:if>
				 <xsl:value-of disable-output-escaping="yes" select="xproperties/X-BEDEWORK-CS/values/text"/>
				</li>
	  	      </xsl:otherwise>
		      </xsl:choose>
                      <li>Description: <xsl:value-of select="description"/></li>
                      <xsl:if test="link != ''"><li>Link: <xsl:variable name="link" select="link"/><a href="{$link}" class="moreLink">More Info</a></li></xsl:if>
              </xsl:when>
              <xsl:otherwise>
                   <li class="titleEvent"><xsl:value-of select="summary"/></li>
                   <li> <xsl:if test="location/address != ''"> Location: <xsl:value-of select="location/address"/> </xsl:if> </li>
             </xsl:otherwise>
             </xsl:choose>
        </xsl:if>
	</ul>
      </td>
      <!-- Event Icon Column -->
      <td class="icons">
        <xsl:variable name="gStartdate" select="start/utcdate"/>
        <xsl:variable name="gLocation" select="location/address"/>
        <xsl:variable name="gEnddate" select="end/utcdate"/>
        <xsl:variable name="gText" select="summary"/>
        <xsl:variable name="gDetails" select="summary"/>
        <a style="padding:2px;display:inline" class="eventIcons" href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}"><img title="Add to Google Calendar" src="{$resourcesRoot}/images/gcal_small.gif" alt="Add to Google Calendar"/></a>
        <xsl:choose>
          <xsl:when test="string-length($recurrenceId)">
            <a style="padding:2px;display:inline" class="eventIcons" href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/{$subscriptionId}/Public/{$recurrenceId}/{$guidEsc}"><img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge_small.gif" alt="Add to Facebook"/></a>
          </xsl:when>
          <xsl:otherwise>
            <a style="padding:2px;display:inline" class="eventIcons" href="http://www.facebook.com/share.php?u=http://calendar.duke.edu/feed/event/cal/html/{$subscriptionId}/Public/0/{$guidEsc}"><img title="Add to Facebook" src="{$resourcesRoot}/images/Facebook_Badge_small.gif" alt="Add to Facebook"/></a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
        <a href="{$export}&amp;subid={$subscriptionId}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="Download .ics file for import to other calendars">
          <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" alt="Download event                       as ical - for Outlook, PDAs, iCal,                       and other desktop                       calendars"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <!--=========  Split for Events  ==========-->
 <xsl:template name="split-for-events">
         <xsl:param name="node"/>
         <xsl:param name="list"/>
         <xsl:param name="delimiter"/>
         <xsl:param name="suite-name"/>
         <xsl:variable name="newlist">
            <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
                  <xsl:value-of select="normalize-space($list)"/>
            </xsl:when>
            <xsl:otherwise>
                  <xsl:value-of select="concat(normalize-space($list), $delimiter)"/>
            </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
         <xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>
         <xsl:choose>
                <xsl:when test="$first = categories/category/value">
                        <xsl:call-template name="eventRow">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="suite-name" select="$suite-name"/>
                        </xsl:call-template>
                </xsl:when>
                <xsl:when test="$first = categories/category/word">
                        <xsl:call-template name="eventRow">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="suite-name" select="$suite-name"/>
                        </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:if test="$remaining">
                              <xsl:call-template name="split-for-events">
                                   <xsl:with-param name="suite-name" select="$suite-name"/>
                                   <xsl:with-param name="list" select="$remaining"/>
                                   <xsl:with-param name="delimiter">~</xsl:with-param>
                               </xsl:call-template>
                        </xsl:if>
                </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
