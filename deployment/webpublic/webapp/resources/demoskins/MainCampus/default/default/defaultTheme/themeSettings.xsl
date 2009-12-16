<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bwTheme="my::bwTheme"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- THEME SPECIFIC SETTINGS -->

  <!-- URL of html resources (images, css, other html) for the current theme -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot" />/default/default/defaultTheme</xsl:variable>

  <!-- Features for the current theme -->
  <!-- Note: Set the global calendar suite preferences
       in the administrative web client (default view, default viewPeriod, etc) -->

  <bwTheme:currentThemeSettings>

    <!-- address bar icon -->
    <favicon><xsl:value-of select="$resourcesRoot"/>/images/bedework.ico</favicon>


    <!-- display the featured event images? -->
    <featuredEvents>
      <enabled>true</enabled>
      <forDay>true</forDay>
      <forWeek>true</forWeek>
      <forMonth>false</forMonth>
      <forYear>false</forYear>
      <forEventDisplay>false</forEventDisplay>
    </featuredEvents>


    <!-- use the ongoing events sidebar? -->
    <!-- if ongoing events sidebar is enabled,
     you must set one or both of useCategory
     or useDayRange for ongoing events to appear. -->
    <ongoingEvents>
      <enabled>true</enabled>

      <!-- use the specified category to mark
           an event as ongoing -->
      <useCategory>true</useCategory>
      <catName>Ongoing</catName>
      <catUid></catUid>

      <!-- automatically mark events longer
           than the dayrange (e.g. 12 days)
           as ongoing -->
      <useDayRange>true</useDayRange>
      <dayRange>12</dayRange>

      <!-- always display sidebar, even
           if no events are ongoing? -->
      <alwaysDisplay>false</alwaysDisplay>
    </ongoingEvents>



    <!-- force like-named views into a heirarchy? -->
    <!-- If enabled, views that follow a naming
         convention will appear as children of
         another view in the Calendar Views menu. E.g. views named
         "Arts" and "Arts_Dance Performance" will
         be assembled in a tree structure with "Arts" as the
         parent, and "Dance Performance" as its child
         ("Arts_" will be stripped for display).
         -->
    <makeChildViews>enabled</makeChildViews>


  </bwTheme:currentThemeSettings>

  <!-- make the settings available as a variable -->
  <xsl:variable name="bwTheme" select="document('')/*/bwTheme:*"/>

</xsl:stylesheet>
