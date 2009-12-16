<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">


  <!--==== Head Section ====-->
  <xsl:template name="head">

    <head>
      <title>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <xsl:value-of select="/bedework/event/summary" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-Root-PageTitle" />
          </xsl:otherwise>
        </xsl:choose>
      </title>

      <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />

      <!-- address bar favicon -->
      <link rel="icon" type="image/ico" href="{$bwTheme/favicon}" />

      <!-- load css -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/fixed.css" />
      <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />

      <!-- Dependencies -->
      <xsl:text disable-output-escaping="yes">
        <![CDATA[
        <!--[if IE 6]>
          <link rel="stylesheet" type="text/css" media="screen" href="/calrsrc.MainCampus/default/default/defaultTheme/css/ie6.css"/>
        <![endif]-->

        <!--[if IE 7]>
          <link rel="stylesheet" type="text/css" media="screen" href="/calrsrc.MainCampus/default/default/defaultTheme/css/ie7.css"/>
        <![endif]-->
        ]]>
      </xsl:text>

      <!-- load javascript -->
      <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/yahoo-dom-event.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/calendar-min.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/yui/animation-min.js">&#160;</script>
      <xsl:if test="/bedework/page='searchResult'">
        <script type="text/javascript" src="{$resourcesRoot}/javascript/catSearch.js">&#160;</script>
      </xsl:if>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/mainCampus.js">&#160;</script>
      <script type="text/javascript">
        <xsl:call-template name="jsonDataObject" />
      </script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/ifs-calendar.js">&#160;</script>
    </head>
  </xsl:template>

</xsl:stylesheet>
