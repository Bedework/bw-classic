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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== Head Section ====-->
  <xsl:template name="head">

    <head>
      <title>BW 3.10:
        <xsl:if test="/bedework/page='event'">
          <xsl:value-of select="/bedework/event/summary" />
          <xsl:text> - </xsl:text>
        </xsl:if>
        <xsl:copy-of select="$bwStr-Root-PageTitle" />
      </title>

      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
      <xsl:if test="$useIE-X-UA-Compatible = 'true'">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
      </xsl:if>

      <!-- address bar favicon -->
      <link rel="icon" type="image/ico" href="{$favicon}" />

      <!-- load library css -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/javascript/bootstrap3/css/bootstrap.min.css" />
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/javascript/jquery/jquery-ui-1.10.3.custom.min.css" />
      <!-- load Bedework css ... you may wish to combine (and minify) these files for a production service. -->
      <link rel="stylesheet" type="text/css" media="all" href="{$resourcesRoot}/css/bwThemeGlobal.css" />
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-00-AllMobile.css" /><!-- @media (max-width: 768px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-01-MobilePortrait.css" /><!-- @media (max-width: 480px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-02-MobileLandscape.css" /><!-- @media (min-width: 480px) and (max-width: 600px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-03-TabletPortrait.css" /><!-- @media (min-width: 600px) and (max-width: 768px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-04-Small.css" /><!-- @media (min-width: 768px) and (max-width: 992px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-05-Medium.css" /><!-- @media (min-width: 992px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-06-Large.css" /><!-- @media (min-width: 1200px) -->
      <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />

      <!--  If special CSS support is needed for IE6, IE7, or IE8, uncomment the following block and
            add the css files as shown below.  When uncommenting this block, you MUST fix the
            comments before and after each if statement. That is, remove the space
            in the "<!- -" and the "- ->".  -->
      <!--
      <xsl:text disable-output-escaping="yes">
        <![CDATA[
        <!- -[if IE 6]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie6.css"/>
        <![endif]- ->
        <!- -[if IE 7]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie7.css"/>
        < ![endif]- ->
        <!- -[if IE 8]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie8.css"/>
        <![endif]- ->
        ]]>
      </xsl:text>
      -->

      <!-- load library javascript -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/modernizr-2.6.2-input.min.js">/* include modernizr */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/jquery/jquery-1.10.2.min.js">/* include jquery */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bootstrap3/js/bootstrap.min.js">/* include bootstrap */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/jquery/jquery-ui-1.10.3.custom.min.js">/* include jquery UI */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bootstrap3/respond.min.js">/* include respond for IE6-8 responsive support */</script>
      <xsl:if test="/bedework/page='searchResult'">
        <script type="text/javascript" src="{$resourcesRoot}/javascript/catSearch.js">/* category search */</script>
      </xsl:if>
      <!-- load Bedework javascript -->
      <xsl:call-template name="themeJavascriptVariables"/><!-- these are defined in themeSettings.xsl  -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/bedework.js">/* bedework */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/navigation.js">/* bedework navigation (menus, links) */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/eventList.js">/* bedework list events widget */</script>
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">/* bedework utilities */</script>

      <!-- Set up list and navigation options for the main events list - must be global.
           The list of URLs is for use by JavaScript functions.  These are
           passed up from the client XML and contain the context.  -->
      <script type="text/javascript">
        var bwPage = "<xsl:value-of select="/bedework/page"/>";
        var bwListPage = "<xsl:value-of select="/bedework/appvar[key='listPage']/value"/>";

        var bwUrls = new Object;
        bwUrls = {
          "setSelection" : "<xsl:value-of select="$setSelection"/>",
          "setSelectionList" : "<xsl:value-of select="$setSelectionList"/>",
          "async" : "<xsl:value-of select="$async"/>"
        }

        // calendar explorers
        var openCals = new Array();
        <xsl:if test="/bedework/appvar[key='opencals']">
          var openCalsRaw = "<xsl:value-of select="/bedework/appvar[key='opencals']/value"/>";
          openCals = openCalsRaw.split(",");
        </xsl:if>

        // set up the filtering objects
        var bwQuery = "";
        var bwFilters = new Array();
        var bwFilterLabels = new Array();

        // search query
        <xsl:if test="/bedework/appvar[key='bwQuery']">
          var bwQuery = "<xsl:value-of select="/bedework/appvar[key='bwQuery']/value"/>";
        </xsl:if>
        var bwQueryName = "<xsl:value-of select="$bwStr-LsEv-Search"/>";
        <xsl:choose>
          <xsl:when test="/bedework/page = 'eventscalendar'">
            var bwClearQueryMarkup = '<a id="bwClearQuery" href="{$setSelection}&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()"><xsl:value-of select="$bwStr-LsEv-ClearSearch"/></a>';
          </xsl:when>
          <xsl:otherwise>
            var bwClearQueryMarkup = '<a id="bwClearQuery" href="javascript:bwClearSearch();"><xsl:value-of select="$bwStr-LsEv-ClearSearch"/></a>';
          </xsl:otherwise>
        </xsl:choose>

        // filters from menus
        <xsl:if test="/bedework/appvar[key='bwFilters']">
          var bwFiltersRaw = "<xsl:value-of select="/bedework/appvar[key='bwFilters']/value"/>";
          bwFilters = bwFiltersRaw.split(",");
        </xsl:if>
        <xsl:if test="/bedework/appvar[key='bwFilterLabels']">
          var bwFilterLabelsRaw = "<xsl:value-of select="/bedework/appvar[key='bwFilterLabels']/value"/>";
          bwFilterLabels = bwFilterLabelsRaw.split(",");
        </xsl:if>
        var bwCalFilterName = "<xsl:value-of select="$bwStr-LsEv-Calendars"/>";
        <xsl:choose>
          <xsl:when test="/bedework/page = 'eventscalendar'">
            var bwCalClearFilterMarkup = '<a id="bwClearCalFilters" href="{$setSelection}&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()"><xsl:value-of select="$bwStr-LsEv-ClearFilters"/></a>';
          </xsl:when>
          <xsl:otherwise>
            var bwCalClearFilterMarkup = '<a id="bwClearCalFilters" href="javascript:bwClearCalFilters();"><xsl:value-of select="$bwStr-LsEv-ClearFilters"/></a>';
          </xsl:otherwise>
        </xsl:choose>

        <!--
        var locations = new Array();
        var locationsLabels = new Array();
        <xsl:if test="/bedework/appvar[key='locations']">
          var locationsRaw = "<xsl:value-of select="/bedework/appvar[key='locations']/value"/>";
          locations = locationsRaw.split(",");
        </xsl:if>
        <xsl:if test="/bedework/appvar[key='locationsLabels']">
          var locationsLabelsRaw = "<xsl:value-of select="/bedework/appvar[key='locationsLabels']/value"/>";
          locationsLabels = locationsLabelsRaw.split(",");
        </xsl:if>
        -->

        <!-- The main list options - only used if the dataType is set to "json" -->
        var bwMainEventsListOptions = {
          title: "<xsl:copy-of select="$bwStr-LsEv-Upcoming"/>",
          showTitle: false,
          displayDescription: false,
          displayEventDetailsInline: false,
          displayDayNameInList: true,
          displayTimeInList: true,
          displayLocationInList: true,
          locationTitle: "<xsl:copy-of select="$bwStr-LsVw-Location"/>",
          displayTopicalAreasInList: true,
          topicalAreasTitle: "<xsl:copy-of select="$bwStr-LsVw-TopicalArea"/>",
          displayThumbnailInList: <xsl:value-of select="$thumbsEnabled"/>,
          thumbWidth: <xsl:value-of select="$thumbWidth"/>,
          useFullImageThumbs: <xsl:value-of select="$useFullImageThumbs"/>,
          usePlaceholderThumb: <xsl:value-of select="$usePlaceholderThumb"/>,
          eventImagePrefix: "<xsl:value-of select="$bwEventImagePrefix"/>",
          resourcesRoot: "<xsl:value-of select="$resourcesRoot"/>",
          limitList: false,
          limit: 5,
          listMode: "byTitle",
          displayContactInDetails: true,
          displayCostInDetails: true,
          displayTagsInDetails: true,
          displayTimezoneInDetails: true,
          displayNoEventText: true,
          showTitleWhenNoEvents: false,
          noEventsText: "<xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>"
        };

        <!-- Retrieve any existing filters -->
        var existingFilters = getCalFilters(bwFilters);
<!--
        <xsl:if test="$ongoingEventsEnabled = 'true'">
          if (existingFilters != "") {
            existingFilters += " and ";
          }
          existingFilters += '(categories.href!="<xsl:value-of select="$ongoingEventsCatPath"/>")';
        </xsl:if>
-->
        <!-- Create the main event list object -->
        var bwMainEventList = new BwEventList("listEvents","html",bwMainEventsListOptions,"<xsl:value-of select="/bedework/currentdate/date"/>",existingFilters,"<xsl:value-of select="$setMainEventList"/>","<xsl:value-of select="$nextMainEventList"/>","bwStartDate","bwResultSize");
      </script>

      <xsl:if test="$eventIconShareThis = 'true'">
        <!-- ShareThis code.  Gets publisher code from variable set in themeSettings.xsl -->
        <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js">&#160;</script>
        <script type="text/javascript">
           stLight.options({
            publisher:'<xsl:value-of select="$shareThisCode"/>',
            offsetTop:'0'
           })
        </script>
      </xsl:if>

    </head>
  </xsl:template>

</xsl:stylesheet>
