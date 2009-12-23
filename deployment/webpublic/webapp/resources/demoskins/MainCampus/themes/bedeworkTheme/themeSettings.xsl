<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- THEME SPECIFIC SETTINGS -->

  <!-- URL of html resources (images, css, other html) for the current theme -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/approot" />/themes/bedeworkTheme</xsl:variable>

  <!-- Features for the current theme -->
  <!-- Note: Set the global calendar suite preferences
       in the administrative web client (default view, default viewPeriod, etc) -->

  <!-- FAVICON -->
  <!-- address bar icon -->
  <xsl:variable name="favicon"><xsl:value-of select="$resourcesRoot"/>/images/bedework.ico</xsl:variable>

  <!-- FEATURED EVENTS -->
  <!-- display the featured event images? -->
  <xsl:variable name="featuredEventsEnabled">true</xsl:variable>
  <xsl:variable name="featuredEventsAlwaysOn">false</xsl:variable>
  <xsl:variable name="featuredEventsForDay">true</xsl:variable>
  <xsl:variable name="featuredEventsForWeek">true</xsl:variable>
  <xsl:variable name="featuredEventsForMonth">false</xsl:variable>
  <xsl:variable name="featuredEventsForYear">false</xsl:variable>
  <xsl:variable name="featuredEventsForEventDisplay">false</xsl:variable>
  <xsl:variable name="featuredEventsForCalList">false</xsl:variable>


  <!-- ONGOING EVENTS -->
  <!-- use the ongoing events sidebar? -->
  <!-- if ongoing events sidebar is enabled,
   you must set UseCategory for ongoing events to appear. -->
  <xsl:variable name="ongoingEventsEnabled">true</xsl:variable>

  <!-- use the specified category to mark an event as ongoing -->
  <xsl:variable name="ongoingEventsUseCategory">true</xsl:variable>
  <xsl:variable name="ongoingEventsCatName">sys/Ongoing</xsl:variable>

  <!-- always display sidebar, even if no events are ongoing? -->
  <xsl:variable name="ongoingEventsAlwaysDisplayed">true</xsl:variable>

  <!-- reveal ongoing events in the main event list
       when a collection (e.g calendar "Exhibits") is directly selected? -->
  <xsl:variable name="ongoingEventsShowForCollection">true</xsl:variable>


  <!-- JAVASCRIPT CONSTANTS -->
  <xsl:template name="themeJavascriptVariables">
    // URL for the header/logo area
    var headerBarLink = "/bedework";
  </xsl:template>


  <!-- CUSTOM CONTENT: HEADER, LEFT COLUMN, FOOTER -->
  <!-- The three templates below are pulled into the theme as
       described and use internationalized strings
       (found in ../default/strings.xsl).

       If you plan on using only one language, you can safely
       change the <xsl:copy> blocks to plain text below.

       If you plan on using more than one language, use the
       strings.xsl file.  See the manual about setting up a
       strings.xsl for multiple languages. -->

  <!-- HEADER TEXT/LINKS -->
  <!-- the text and links found (by default) in the
       lower right of the header.  -->
  <xsl:template name="headerTextLinks">
    <h2>
      <xsl:copy-of select="$bwStr-HdBr-PublicCalendar" />
    </h2>
    <ul>
      <li>
        <a href="{$privateCal}">
          <xsl:copy-of select="$bwStr-HdBr-PersonalCalendar" />
        </a>
      </li>
      <li>
        <a href="/bedework">
          <xsl:copy-of select="$bwStr-HdBr-UniversityHome" />
        </a>
      </li>
      <li class="last">
        <a href="?refreshXslt=yes">
          <xsl:copy-of select="$bwStr-HdBr-OtherLink" />
        </a>
      </li>
    </ul>
  </xsl:template>

  <!-- FOOTER TEXT/LINKS -->
  <!-- show the skin select box in the footer?
  You may also opt to remove the form in footer.xsl. -->
  <xsl:variable name="showFootForm">true</xsl:variable>

  <!-- text in the footer -->
  <xsl:template name="footerText">
    <xsl:copy-of select="$bwStr-Foot-BasedOnThe" />
    <xsl:text> </xsl:text>
    <a href="http://www.bedework.org/">
      <xsl:copy-of select="$bwStr-Foot-BedeworkCalendarSystem" />
    </a>
    |
    <a
      href="http://www.bedework.org/bedework/update.do?artcenterkey=35">
      <xsl:copy-of select="$bwStr-Foot-ProductionExamples" />
    </a>
    |
    <a href="?noxslt=yes">
      <xsl:copy-of select="$bwStr-Foot-ShowXML" />
    </a>
    |
    <a href="?refreshXslt=yes">
      <xsl:copy-of select="$bwStr-Foot-RefreshXSLT" />
    </a>
    <br/>
    <xsl:copy-of select="$bwStr-Foot-Credits" />
  </xsl:template>


  <!-- LEFT COLUMN TEXT -->
  <!-- custom text in the left column -->
  <xsl:template name="leftColumnText">
    <h4>EVENTS CALENDAR INFO:</h4>
     <ul class="sideLinks">
       <li>
         <a href="/caladmin">Manage Events</a>
       </li>
       <li>
         <a href="/eventsubmit?setappvar=confirmed(no)">
           Submit an Event
         </a>
       </li>
       <li>
         <a href="http://calendar.duke.edu/help">Help</a>
       </li>
     </ul>
     <ul class="sideLinksExpand">
       <li>
         <h4>OTHER UNIVERSITY CALENDARS</h4>
         <span id="additionalUnivClicker">+</span>
         <ul id="additionalUnivSub"
           style="height:0px;overflow:hidden;">
           <li>
             <a href="http://www.bedework.org/">
               Example link
             </a>
           </li>
           <li>
             <a href="http://www.bedework.org/">
               Example link
             </a>
           </li>
           <li>
             <a href="http://www.bedework.org/">
               Example link
             </a>
           </li>
         </ul>
       </li>
       <li>
         <h4>OTHER LINKS</h4>
         <span id="additionalOptionsClicker">+</span>
         <ul id="additionalOptionsSub"
           style="height:0px;overflow:hidden">
           <li>
             <a href="http://www.bedework.org/">
               Example link
             </a>
           </li>
           <li>
             <a href="http://www.bedework.org/">
               Example link
             </a>
           </li>
         </ul>
       </li>
     </ul>
   </xsl:template>



  <!-- NOT YET ENABLED -->
  <!-- the following features did not make the 3.6 release, and are here
       for reference -->

   <!-- DEADLINES/TASKS -->
   <!-- use the deadlines sidebar? -->
   <!-- if deadlines sidebar is enabled, deadlines will appear
        in the sidebar under ongoing events.  Deadlines will
        be presented as tasks and will be treated as such in
        calendar clients. -->
   <!-- <xsl:variable name="deadlinesEnabled">false</xsl:variable> -->

   <!-- always display sidebar, even if no deadlines are present? -->
   <!-- <xsl:variable name="deadlinesAlwaysDisplayed">true</xsl:variable> -->

  <!-- VIEW HIERARCHY -->
  <!-- force views into a heirarchy? -->
  <!-- <xsl:variable name="childViewsEnabled">true</xsl:variable> -->

  <!-- FOR ONGOING EVENTS -->
  <!-- pull events longer than day range into ongoing list? -->
  <!-- <xsl:variable name="ongoingEventsUseDayRange">false</xsl:variable> -->
  <!-- <xsl:variable name="ongoingEventsDayRange">12</xsl:variable> -->

</xsl:stylesheet>
