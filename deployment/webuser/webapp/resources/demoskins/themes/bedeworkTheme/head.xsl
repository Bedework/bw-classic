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
  
  <!--==== HEAD SECTION  ====-->
  <xsl:template name="head">
    <title><xsl:copy-of select="$bwStr-Head-PageTitle"/></title>
    <meta name="robots" content="noindex,nofollow"/>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
    <link rel="stylesheet" href="{$resourcesRoot}/css/bedeworkTheme.css"/>
    <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />

    <!-- set globals that must be passed in from the XSLT -->
    <script type="text/javascript">
      <xsl:comment>
      var defaultTzid = "<xsl:value-of select="/bedework/now/defaultTzid"/>";
      var startTzid = "<xsl:value-of select="/bedework/formElements/form/start/tzid"/>";
      var endTzid = "<xsl:value-of select="/bedework/formElements/form/end/dateTime/tzid"/>";
      var resourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";
      </xsl:comment>
    </script>

    <!-- note: the non-breaking spaces in the script bodies below are to avoid
         losing the script closing tags (which avoids browser problems) -->
    <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
    <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
    <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
    <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
    <!-- load bedework personal client javascript libraries -->
    <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">&#160;</script>
    <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkSetup.js">&#160;</script>

    <xsl:if test="/bedework/page='modSchedulingPrefs' or
                  /bedework/page='modPrefs' or
                  /bedework/page='attendeeRespond'">
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkPrefs.js">&#160;</script>
    </xsl:if>

    <xsl:if test="/bedework/page='modCalendar' or
                  /bedework/page='modSchedulingPrefs'">
      <link rel="stylesheet" href="/bedework-common/default/default/bedeworkAccess.css"/>
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkAccess.js">&#160;</script>
      <!-- initialize calendar acls, if present -->
      <xsl:if test="/bedework/currentCalendar/acl/ace">
        <script type="text/javascript">
          <xsl:apply-templates select="/bedework/currentCalendar/acl/ace" mode="initJS"/>
        </script>
      </xsl:if>
    </xsl:if>

    <xsl:if test="/bedework/page='attendees'">
      <!-- script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.2.6.min.js">&#160;</script -->
      <script type="text/javascript" src="/bedework-common/javascript/jquery/autocomplete/bw-jquery.autocomplete.js">&#160;</script>
      <script type="text/javascript" src="/bedework-common/javascript/jquery/autocomplete/jquery.bgiframe.min.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkAttendees.js">&#160;</script>
      <link rel="stylesheet" type="text/css" href="/bedework-common/javascript/jquery/autocomplete/jquery.autocomplete.css" />
    </xsl:if>

    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='editEvent' or
                  /bedework/page='rdates' or
                  /bedework/page='calendarListForExport'">

      <xsl:choose>
        <xsl:when test="$portalFriendly = 'true'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/dynCalendarWidget.js">&#160;</script>
          <link rel="stylesheet" href="{$resourcesRoot}/css/dynCalendarWidget.css"/>
        </xsl:when>
        <xsl:otherwise>
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

            function bwSetupDatePickers() {
              // startdate
              $("#bwEventWidgetStartDate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
              }).attr("readonly", "readonly");
              $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // enddate
              $("#bwEventWidgetEndDate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
              }).attr("readonly", "readonly");
              $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/end/rfc3339DateTime,'T')"/>');

              // recurrence until
              $("#bwEventWidgetUntilDate").datepicker({
                <xsl:choose>
                  <xsl:when test="/bedework/formElements/form/recurrence/until">
                    defaultDate: new Date(<xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(/bedework/formElements/form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,7,2)"/>),
                  </xsl:when>
                  <xsl:otherwise>
                    defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                  </xsl:otherwise>
                </xsl:choose>
                altField: "#bwEventUntilDate",
                altFormat: "yymmdd"
              }).attr("readonly", "readonly");
              $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // rdates and xdates
              $("#bwEventWidgetRdate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                dateFormat: "yymmdd"
              }).attr("readonly", "readonly");
              $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');
            }
            </xsl:comment>
          </script>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='editEvent'">
      
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bwClock.js">&#160;</script>
      <link rel="stylesheet" href="{$resourcesRoot}/css/bwClock.css"/>
      
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkEventForm.js">&#160;</script>
      
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkXProperties.js">&#160;</script>
      
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkScheduling.js">&#160;</script>
      <link rel="stylesheet" href="{$resourcesRoot}/css/bwScheduling.css"/>
      
      <script type="text/javascript" src="/bedework-common/javascript/jquery/autocomplete/bw-jquery.autocomplete.js">&#160;</script>
      <script type="text/javascript" src="/bedework-common/javascript/jquery/autocomplete/jquery.bgiframe.min.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkAttendees.js">&#160;</script>
      <link rel="stylesheet" type="text/css" href="/bedework-common/javascript/jquery/autocomplete/jquery.autocomplete.css" />
      
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkAccess.js">&#160;</script>
      <link rel="stylesheet" href="/bedework-common/default/default/bedeworkAccess.css"/>
      
      <!-- initialize event acls, if present -->
      <xsl:if test="/bedework/editableAccess/access/acl/ace">
        <script type="text/javascript">
          <xsl:apply-templates select="/bedework/editableAccess/access/acl/ace" mode="initJS"/>
        </script>
      </xsl:if>
      
      <script type="text/javascript">
        <xsl:comment>
        // initialize the free/busy grid - values taken directly from the xml
        // send params: displayId, startRange, startHourRange, endHourRange, attendees, workday, zoom, browserResourcesRoot, fbUrl, organizerUri
        // example: var bwGrid = new bwSchedulingGrid("bwFreeBusyDisplay","May 5, 2010",8,17,[{name:"Venerable Bede",uid:"vbede@mysite.edu",role:"CHAIR",status:"ACCEPTED",type:"person"}],true,100,"<xsl:value-of select="$resourcesRoot"/>","<xsl:value-of select="$requestFreeBusy"/>","");
        
        var bwGridSDate = new Date("<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>/<xsl:value-of select="/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value"/>/<xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>");
        var bwGridAttees = new Array({name:"Arlen Johnson",uid:"johnsa@mysite.edu",role:"CHAIR",status:"ACCEPTED",type:"person"},{name:"",uid:"douglm@mysite.edu",role:"REQ-PARTICIPANT",status:"NEEDS-ACTION",type:"person"});
        //var bwGridAttees = new Array();
        var bwGrid = new bwSchedulingGrid("bwFreeBusyDisplay",bwGridSDate,8,17,bwGridAttees,true,100,"<xsl:value-of select="$resourcesRoot"/>","<xsl:value-of select="$requestFreeBusy"/>","johnsa@mysite.edu");
        
        // set the grid size
        function bwGridSetSize() {
          var fbWidth = $("#bwEventTab-Basic").width() - 52;
          $("#bwFreeBusyDisplay").css("width", fbWidth + "px");
        };
        
        </xsl:comment>
      </script>
      
      
    </xsl:if>
    <xsl:if test="/bedework/page='editEvent'">
      <script type="text/javascript">
        <xsl:comment>
        function initRXDates() {
          // return string values to be loaded into javascript for rdates
          <xsl:for-each select="/bedework/formElements/form/rdates/rdate">
            bwRdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
          </xsl:for-each>
          // return string values to be loaded into javascript for rdates
          <xsl:for-each select="/bedework/formElements/form/exdates/rdate">
            bwExdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
          </xsl:for-each>
        }
        function initXProperties() {
          <xsl:for-each select="/bedework/formElements/form/xproperties/node()[text()]">
            bwXProps.init('<xsl:value-of select="name()"/>',[<xsl:for-each select="parameters/node()">['<xsl:value-of select="name()"/>','<xsl:value-of select="node()"/>']<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],'<xsl:call-template name="escapeApos"><xsl:with-param name="str"><xsl:value-of select="values/text"/></xsl:with-param></xsl:call-template>');
          </xsl:for-each>
        }
        </xsl:comment>
      </script>
    </xsl:if>

    <!-- page based jquery initializations -->
    <xsl:if test="/bedework/page='event'">
      <!-- jQuery functions for detailed event view -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkEvent.js">&#160;</script>
    </xsl:if>
    <xsl:if test="/bedework/page='eventscalendar'">
      <!-- jQuery functions for detailed event view -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkCalendarGrid.js">&#160;</script>
    </xsl:if>

    <script type="text/javascript">
      <xsl:comment>
      
      // focuses an element by id
      function focusElement(id) {
        document.getElementById(id).focus();
      }
      
      $(document).ready(function() {
        <xsl:choose>
          <xsl:when test="/bedework/page = 'addEvent' or bedework/page = 'editEvent'">
            focusElement('bwEventTitle');
            bwSetupDatePickers();
            bwGrid.init();
            bwGridSetSize();
          </xsl:when>
          <xsl:when test="/bedework/page = 'editEvent'">
            <xsl:if test="/bedework/formElements/recurrenceId = ''">
              initRXDates();
            </xsl:if>
            initXProperties();
          </xsl:when>
          <xsl:when test="/bedework/page = 'attendees'">
            focusElement('bwRaUri');
          </xsl:when>
          <xsl:when test="/bedework/page = 'modLocation'">
            focusElement('bwLocMainAddress');
          </xsl:when>
        </xsl:choose>
      });
        
      </xsl:comment>
    </script>
  </xsl:template>
  
  
</xsl:stylesheet>