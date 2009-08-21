<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  
  <!-- xsl:template match="/" -->
  <xsl:variable name="bwStr-Root-PageTitle">00Bedework Events Calendar</xsl:variable>
  
  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-PublicCalendar">00Public Calendar</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">00Personal Calendar</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">00University Home</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">00School Home</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">00Other Link</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">00Example Calendar Help</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">00print</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">00print this view</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">00RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">00RSS feed</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">00Event Information</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">00logged in as</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">00logout</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">00DAY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">00WEEK</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">00MONTH</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">00YEAR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">00LIST</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">00Week of</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">00go</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">00add...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-View">00View:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-DefaultView">00default view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-AllTopicalAreas">00all topical areas</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Search">00Search:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Go">00go</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleListCalView">00toggle list/calendar view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleSummDetView">00toggle summary/detailed view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-TopicalArea">00Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-CurrentSearch">00Current search:</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">00generate link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">00link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">00Event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">00Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">00Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">00delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">00delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">00delete event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">00all</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">00instance</xsl:variable>
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
  <xsl:variable name="bwStr-SgEv-Copy">00Copy</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">00copy master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">00copy this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">00copy event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">00Edit</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">00edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">00edit this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">00edit event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">00Download</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">00download master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">00download this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Task">00Task</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">00Meeting</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">00Recurring</xsl:variable>
  <!--public, private -->
  <xsl:variable name="bwStr-SgEv-Organizer">00organizer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">00recurrence master</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">00When:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">00(all day)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">00Floating time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">00Local time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">00Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">00End:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">00add to my calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">00Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">00Where:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Complete">00Complete:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">00Organizer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">00Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">00Attendees:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">00Attendee</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">00role</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">00status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">00change my status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">00Cost:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">00See:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">00Contact:</xsl:variable>
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">00Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">00Topical Area:</xsl:variable>
  
  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">00No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">00add...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">00all day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">00today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">00Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">00description</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">00Contact:</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Next7Days">00Next 7 Days</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">00No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">00Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">00TENTATIVE:</xsl:variable>  

  <!--  xsl:template name="buildListEventsDaysOptions" -->
  
  <!--  xsl:template name="weekView" -->

  <!--  xsl:template name="monthView" -->

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">00TENTATIVE:</xsl:variable> 
  <xsl:variable name="bwStr-EvCG-Cont">00(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">00all day:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">00Time:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">00all day</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">00Location:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">00Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Type">00Type:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Task">00task</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Meeting">00meeting</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Event">00event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Recurring">00recurring</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">00personal</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">00public</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">00View details</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">00Download</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">00download master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">00download this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">00all</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">00instance</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">00Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">00edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">00edit this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Edit">00Edit</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditEvent">00edit event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyColon">00Copy:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyMaster">00copy master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyThisInstance">00copy this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Copy">00Copy</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyEvent">00copy event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-LinkColon">00Link:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Link">00Link</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteColon">00Delete:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisEvent">00Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteAllRecurrences">00Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteMaster">00delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisInstance">00delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteEvent">00delete event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Delete">00Delete</xsl:variable>

  <!--  xsl:template name="yearView" -->

  <!--  xsl:template match="month" -->

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-AllTopicalAreas">00All Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectTopicalArea">00Select a topical area from the list below to see only its events.</xsl:variable>

  <!--  xsl:template match="calendar" mode="calTree" -->
  <xsl:variable name="bwStr-Calr-Folder">00folder</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">00calendar</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">00Export Calendars as iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">00Calendar to export:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">00Path:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">00Event date limits:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">00today forward</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">00all dates</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">00date range</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start">00<strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End">00<strong>End:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">00My Calendars</xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">00export</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">00Search:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">00go</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">00Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">00today forward</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">00past dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">00all dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">00Search Result</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">00page:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">00prev</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">00next</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">00result(s) returned for</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">00relevance</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">00summary</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">00date &amp; time</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">00calendar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">00location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">00no title</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">00System Statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">00Stats collection:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">00enable</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">00disable</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">00fetch statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">00dump stats to log</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">00Demonstration calendar; place footer information here.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">00Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">00show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">00refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">00Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">00Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">00production examples</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">00example styles</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">00green</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">00red</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">00blue</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">00example skins</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">00rss: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">00javascript: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">00javascript: today's events</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">00for mobile browsers</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">00video feed</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">00reset to calendar default</xsl:variable>
  
</xsl:stylesheet>
