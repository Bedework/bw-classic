<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--  xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-PageTitle">00Bedework: Personal Calendar Client</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="headBar" -->
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

  <!--  xsl:template name="sideBar" -->
  <xsl:variable name="bwStr-SdBr-Views">00views</xsl:variable>
  <xsl:variable name="bwStr-SdBr-NoViews">00no views</xsl:variable>
  <xsl:variable name="bwStr-SdBr-SubscribeToCalendarsOrICalFeeds">00subscribe to calendars or iCal feeds</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Subscribe">00subscribe</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ManageCalendarsAndSubscriptions">00manage calendars and subscriptions</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Manage">00manage</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Calendars">00calendars</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Options">00options</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Preferences">00Preferences</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadICal">00Upload iCAL</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ExportCalendars">00Export Calendars</xsl:variable>

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

  <!--  xsl:template name="utilBar" -->
  <xsl:variable name="bwStr-Util-Add">00add...</xsl:variable>
  <xsl:variable name="bwStr-Util-View">00View</xsl:variable>
  <xsl:variable name="bwStr-Util-DefaultView">00default view</xsl:variable>
  <xsl:variable name="bwStr-Util-AllTopicalAreas">00all topical areas</xsl:variable>
  <xsl:variable name="bwStr-Util-Search">00Search</xsl:variable>
  <xsl:variable name="bwStr-Util-Go">00go</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleListCalView">00toggle list/calendar view</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleSummDetView">00toggle summary/detailed view</xsl:variable>

  <!--  xsl:template name="actionIcons" -->
  <xsl:variable name="bwStr-Actn-AddEvent">00add event</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleMeeting">00schedule meeting</xsl:variable>
  <xsl:variable name="bwStr-Actn-AddTask">00add task</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleTask">00schedule task</xsl:variable>
  <xsl:variable name="bwStr-Actn-Upload">00upload</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">00No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">00add...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">00all day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">00today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">00description</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">00Contact:</xsl:variable>

  <!--  <xsl:template name="eventLinks" -->
  <xsl:variable name="bwStr-EvLn-EditMaster">00edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-All">00all</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Instance">00instance</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditInstance">00edit instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Edit">00Edit</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditEvent">00edit event</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditColon">00Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Link">00Link</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteColon">00Delete:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteMaster">00delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteThisEvent">00Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteEvent">00Ddelete event</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteAllRecurrences">00Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteInstance">00delete instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Delete">00Delete</xsl:variable>

  <!-- xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Next7Days">00Next 7 Days</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">00No events to Display</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">00Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">00Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">00CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">00TENTATIVE:</xsl:variable>

  <!-- xsl:template name="weekView" -->
  
  <!-- xsl:template name="monthView" -->

  <!-- xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-Canceled">00CANCELED:</xsl:variable>
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

  <!-- <xsl:template name="yearView" -->

  <!-- <xsl:template match="month" -->

  <!-- <xsl:template name="tasks" -->
  <xsl:variable name="bwStr-Task-Tasks">00tasks</xsl:variable>
  <xsl:variable name="bwStr-Task-Reminders">00reminders</xsl:variable>

  <!-- <xsl:template match="event" mode="tasks" -->
  <xsl:variable name="bwStr-TskE-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-TskE-Start">00Start:</xsl:variable>
  <xsl:variable name="bwStr-TskE-Due">00Due:</xsl:variable>

  <!-- <xsl:template match="event" mode="schedNotifications" -->

  <!-- <xsl:template match="event" -->
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
  <xsl:variable name="bwStr-SgEv-Link">00Link</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddMasterEvent">00add master event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddThisEvent">00add this event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventReference">00add event reference to a calendar</xsl:variable>
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
  <xsl:variable name="bwStr-SgEv-Event">00Event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">00Recurring</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Public">00Public</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Personal">00Personal</xsl:variable>
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
  <xsl:variable name="bwStr-SgEv-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">00Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">00Topical Area:</xsl:variable>

  <!-- <xsl:template match="formElements" mode="addEvent" -->
  <xsl:variable name="bwStr-AddE-AddTask">00Add Task</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddEvent">00Add Event</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddMeeting">00Add Meeting</xsl:variable>
  <xsl:variable name="bwStr-AddE-Save">00save</xsl:variable>
  <xsl:variable name="bwStr-AddE-Cancel">00cancel</xsl:variable>

  <!--  <xsl:template match="formElements" mode="editEvent" -->
  <xsl:variable name="bwStr-EdtE-EditTask">00Edit task</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditEvent">00Edit Event</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditMeeting">00Edit Meeting</xsl:variable>
  <xsl:variable name="bwStr-EdtE-Save">00save</xsl:variable>
  <xsl:variable name="bwStr-EdtE-Cancel">00cancel</xsl:variable>

  <!--  <xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-AEEF-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteMaster">00delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisEvent">00Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteAllRecurrences">00Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisInstance">00delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteEvent">00delete event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">00All</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Instance">00Instance</xsl:variable>
  <xsl:variable name="bwStr-AEEF-View">00View</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TASK">00Task</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meeting">00Meeting</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVENT">00Event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurring">00Recurring</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Personal">00Personal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Public">00Public</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceMaster">00recurrence master</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Basic">00basic</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Details">00details</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurrence">00recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Scheduling">00scheduling</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">00Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">00all day</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">00floating</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">00store at UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">00Start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">00Date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Due">00Due:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">00End:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration">00Duration</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">00days</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">00hours</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">00minutes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">00or</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">00weeks</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">00This</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">00task</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">00event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">00has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">00Complete:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">00Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">00(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">00no</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">00(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">00no categories defined</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">00add category</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">00select timezone...</xsl:variable>

  <!-- Details tab (3153)-->
  <xsl:variable name="bwStr-AEEF-Location">00Location:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Choose">00choose:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Select">00select...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OrAddNew">00or add new:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventLink">00Event Link:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">00Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">00confirmed</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">00canceled</xsl:variable>
  
  <!-- Recurrence tab (3292)-->
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">00This event is a recurrence instance.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">00edit master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">00edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">00event recurs</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">00event does not recur</xsl:variable>

  <!-- wrapper for all recurrence fields (rrules and rdates): -->
  <xsl:variable name="bwStr-AEEF-RecurrenceRules">00Recurrence Rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeRecurrenceRules">00change recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowAdvancedRecurrenceRules">00show advanced recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-And">00and</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVERY">00Every</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Every">00every</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Day">00day(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hour">00hour(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Month">00month(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Week">00week(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Year">00year(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-On">00on</xsl:variable>
  <xsl:variable name="bwStr-AEEF-In">00in</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnThe">00on the</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InThe">00in the</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFirst">00the first</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheSecond">00the second</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheThird">00the third</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFourth">00the fourth</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFifth">00the fifth</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheLast">00the last</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheMonth">00day(s) of the month</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheYear">00day(s) of the year</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOfTheYear">00week(s) of the year</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeating">00repeating</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Forever">00forever</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Until">00until</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Time">00time(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Frequency">00Frequency:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-None">00none</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Daily">00daily</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weekly">00weekly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Monthly">00monthly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yearly">00yearly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceRules">00no recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeat">00Repeat:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Interval">00Interval:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseMonths">00in these months:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOn">00week(s) on</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekdays">00select weekdays</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekends">00select weekends</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekStart">00Week start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDays">00on these days:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheMonth">00on these days of the month:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseWeeksOfTheYear">00in these weeks of the year:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheYear">00on these days of the year:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceAndExceptionDates">00Recurrence and Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceDates">00Recurrence Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceDates">00No recurrence dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">00Time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">00TZid</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">00Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">00No exception dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">00Exception dates may also be created by deleting an instance of a recurring event.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">00add recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">00add exception</xsl:variable>

  <!-- Access tab -->

  <!-- Scheduling tab -->
  <xsl:variable name="bwStr-AEEF-EditAttendees">00edit attendees</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeMyStatus">00change my status</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ScheduleThisTask">00schedule this task with other users</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MakeIntoMeeting">00make into meeting - invite attendees</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Save">00Save</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveAndSendInvites">00save &amp; send invitations</xsl:variable>

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">00the first</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">00the second</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">00the third</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">00the fourth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">00the fifth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">00the last</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">00every</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">00none</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">00and</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->
	
  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">00Bedework 24-Hour Clock</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">00type</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">00select time</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">00switch</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">00close</xsl:variable>

  <!-- xsl:template name="attendees" -->
  <xsl:variable name="bwStr-Atnd-Continue">00continue</xsl:variable>
  <xsl:variable name="bwStr-Atnd-SchedulMeetingOrTask">00Schedule Meeting or Task</xsl:variable>
  <xsl:variable name="bwStr-Atnd-AddAttendees">00Add attendees</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Add">00add</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Recipients">00Recipients</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendee">00attendee</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendees">00Attendees</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RoleColon">00Role:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Role">00role</xsl:variable>
  <xsl:variable name="bwStr-Atnd-StatusColon">00Status:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Status">00status</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RequiredParticipant">00required participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-OptionalParticipant">00optional participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Chair">00chair</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NonParticipant">00non-participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NeedsAction">00needs action</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Accepted">00accepted</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Declined">00declined</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Delegated">00delegated</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Remove">00remove</xsl:variable>

  <!-- xsl:template match="partstat" -->
  <xsl:variable name="bwStr-ptst-NeedsAction">00needs action</xsl:variable>
  <xsl:variable name="bwStr-ptst-Accepted">00accepted</xsl:variable>
  <xsl:variable name="bwStr-ptst-Declined">00declined</xsl:variable>
  <xsl:variable name="bwStr-ptst-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-ptst-Delegated">00delegated</xsl:variable>
  
  <!-- xsl:template match="freebusy" mode="freeBusyGrid"  -->
  <xsl:variable name="bwStr-FrBu-FreebusyFor">00Freebusy for</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllAttendees">00all attendees</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AM">00AM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-PM">00PM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Busy">00busy</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Free">00free</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllFree">00all free</xsl:variable>

  <!-- xsl:template match="attendees" -->
  <!-- Stings defined above -->

  <!-- xsl:template match="recipients"-->
  <xsl:variable name="bwStr-Rcpt-Recipient">00recipient</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Recipients">00Recipients</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Remove">00remove</xsl:variable>

  <!-- xsl:template match="event" mode="addEventRef" -->
  <!-- some strings defined above -->
  <xsl:variable name="bwStr-AEEF-AddEventReference">00Add Event Reference</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventColon">00Event:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IntoCalendar">00Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DefaultCalendar">00default calendar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Continue">00continue</xsl:variable>
  
  <!-- xsl:template match="freebusy" mode="freeBusyPage" -->
  <xsl:variable name="bwStr-FrBu-YouMayShareYourFreeBusy">00You may share your free busy with a user or group by setting access to "read freebusy" on calendars you wish to share. To share all your free busy, grant "read freebusy" access on your root folder.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-FreeBusy">00Free / Busy</xsl:variable>
  <xsl:variable name="bwStr-FrBu-ViewUsersFreeBusy">00View user's free/busy:</xsl:variable>

  <!-- xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-Ctgy-ManagePreferences">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-General">00general</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-ManageCategories">00Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Type">00Add new category</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-NoCategoriesDefined">00No categories defined</xsl:variable>

  <!-- xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MCat-ManagePreferences">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-MCat-General">00general</xsl:variable>
  <xsl:variable name="bwStr-MCat-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-MCat-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-MCat-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-MCat-AddCategory">00Add Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-EditCategory">00Edit Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-UpdateCategory">00Update Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-DeleteCategory">00Delete Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-Keyword">00Keyword:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Cancel">00cancel</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DlCC-OKtoDeleteCategory">00Ok to delete this category?</xsl:variable>
  <xsl:variable name="bwStr-DlCC-DeleteCategory">00Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Keyword">00Keyword:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-YesDeleteCategory">00Yes: Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DlCC-NoCancel">00No: Cancel</xsl:variable>

  <!--  xsl:template match="calendars" mode="manageCalendars" -->
  <xsl:variable name="bwStr-Cals-ManageCalendarsSubscriptions">00Manage Calendars &amp; Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendars">00Calendars</xsl:variable>

  <!--  xsl:template match="calendar" mode="myCalendars"  -->

  <!--  xsl:template match="calendar" mode="mySpecialCalendars" -->

  <!--  xsl:template match="calendar" mode="listForUpdate"  -->

  <!--  xsl:template match="calendar" mode="listForDisplay"  -->

  <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCfE-SelectACalendar">00select a calendar</xsl:variable>
  <xsl:variable name="bwStr-SCfE-NoWritableCals">00no writable calendars</xsl:variable>
	
  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="selectCalForPublicAlias" -->
  <xsl:variable name="bwStr-SCPA-SelectACalendar">00select a calendar</xsl:variable>
	
  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalFolderOrSubscription">00Add Calendar, Folder, or Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">00Summary:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Color">00Color:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">00Display:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInThisCollection">00display items in this collection</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">00Filter Expression:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">00Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">00Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">00Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">00Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionType">00Subscription Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicCalendar">00Public calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UserCalendar">00User calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">00URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectAPublicCalOrFolder">00Select a public calendar or folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UsersID">00User's ID:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CalendarPath">00Calendar Path:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultCalendarOrSomeCalendar">00E.g. "calendar" (default) or "someFolder/someCalendar"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">00URL to calendar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">00ID (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">00Password (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">00Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharingMayBeAdded">00Sharing may be added to a calendar once created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">00Add</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">00cancel</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">00Modify Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">00Modify Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">00Modify Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">00Update Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">00Update Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">00Update Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteSubscription">00Delete Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">00Delete Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">00Delete Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">00Disabled:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ThisItemIsInaccessible">00This item is inaccessible and has been disabled.  You may re-enable it to try again.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">00Filter Expression:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">00Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote"><p><strong>00Note:</strong> If you grant write access to another user, and you wish to see events added by that user in your calendar, <strong>you must explicitly grant yourself access to the same calendar.</strong>  Enter your UserID as a user in the "Who" box with "All" set in the "Rights" box.</p> <p>This is standard access control; the reason you will not see the other user's events without doing this is that the default access is grant:all to "owner" - and you don't own the other user's events.</p></xsl:variable>
  
  <!--  xsl:template name="colorPicker"  -->
  <xsl:variable name="bwStr-CoPi-Pick">00pick</xsl:variable>
  <xsl:variable name="bwStr-CoPi-UseDefaultColors">00use default colors</xsl:variable>

<!--  xsl:template name="calendarList"  -->
  <xsl:variable name="bwStr-CaLi-ManagingCalendars">00Managing Calendars &amp; Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectFromCalendar">00Select an item from the calendar tree on the left to modify a calendar</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Subscription">00subscription</xsl:variable>
  <xsl:variable name="bwStr-CaLi-OrFolder">00, or folder</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Select">00Select the</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Icon">00icon to add a new calendar, subscription, or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Folders">00Folders may only contain calendars and subfolders.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Calendars">00Calendars may only contain events (and other calendar items).</xsl:variable>

  <!--  xsl:template name="calendarDescriptions"  -->
  <xsl:variable name="bwStr-CaDe-CalInfo">00Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CaDe-SelectAnItem">00Select an item from the calendar tree on the left to view all information about that calendar or folder.  The tree on the left represents the calendar heirarchy.</xsl:variable>
  <xsl:variable name="bwStr-CaDe-AllCalDescriptions">00All Calendar Descriptions:</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Description">00Description</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar"  -->
  <xsl:variable name="bwStr-CuCa-CalendarInformation">00Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">00Path:</xsl:variable>
  <!-- The rest found above -->
  
  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm"  -->
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">00Yes: Delete Folder!"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">00Yes: Delete Calendar!"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingFolder">00The following folder <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingCalendar">00The following calendar will be deleted.  Continue?</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="calendars" mode="exportCalendars" -->
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

  <!--  xsl:template match="calendar" mode="buildExportTree"  -->
	
  <!--  xsl:template name="subsMenu"  -->
  <xsl:variable name="bwStr-SuMe-AddSubs">00Add Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeTo">00Subscribe to:</xsl:variable>
  <xsl:variable name="bwStr-SuMe-PublicCal">00a public calendar (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-UserCal">00a user calendar (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-ExternalFeed">00an external iCal feed (e.g. Google, Eventful, etc)</xsl:variable>
	
  <!--  xsl:template name="addPublicAlias"  -->
  <xsl:variable name="bwStr-AdPA-SubscribeToPublicCal">00Subscribe to a Public Calendar</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddPublicSubscription">00Add a public subscription</xsl:variable>
  <xsl:variable name="bwStr-AdPA-SubscriptionNote">00*the subscription name must be unique</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AffectsFreeBusy">00Affects Free/Busy:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-AdPA-No">00no</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Style">00Style:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Default">00default</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddSubscription">00Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Cancel">00cancel</xsl:variable>
 
  <!--  xsl:template match="calendar" mode="subscribe" -->
  <xsl:variable name="bwStr-Calr-Folder">00folder</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">00calendar</xsl:variable>

  <!--  xsl:template name="addAlias" -->
  <xsl:variable name="bwStr-AddA-SubscribeToUserCal">00Subscribe to a User Calendar</xsl:variable>
  <xsl:variable name="bwStr-AddA-SubscriptionMustBeUnique">00*the subsciption name must be unique</xsl:variable>
  <xsl:variable name="bwStr-AddA-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-AddA-UserID">00User ID:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExJaneDoe">00ex: janedoe</xsl:variable>
  <xsl:variable name="bwStr-AddA-CalendarPath">00Calendar path:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExCalendar">00ex: calendar</xsl:variable>
  <xsl:variable name="bwStr-AddA-AddSubscription">00Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-AddA-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-AddA-AffectsFreeBusy">00Affects Free/Busy:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-AddA-No">00no</xsl:variable>
  <xsl:variable name="bwStr-AddA-Style">00Style:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Default">00default</xsl:variable>
  <xsl:variable name="bwStr-AddA-NoteAboutAccess">00<ul class="note" style="margin-left: 2em;">
      <li>You must be granted at least read access to the other user's calendar to subscribe to it.</li>
      <li>The <strong>Name</strong> is anything you want to call your subscription.</li>
      <li>The <strong>User ID</strong> is the user id that owns the calendar</li>
      <li>The <strong>Path</strong> is the name of the folder and/or calendar within the remote user's calendar tree.  For example, to subscribe to janedoe/someFolder/someCalendar, enter "someFolder/someCalendar".  To subscribe to janedoe's root folder, leave this field blank.</li>
      <li>You can add subscriptions to your own calendars to help group and organize collections you may wish to share.</li></ul></xsl:variable>

  <!--  xsl:template match="subscription" mode="modSubscription" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subscriptionList" (Deprecated: Strings left in place)-->

  <!--  xsl:template match="subscription" mode="mySubscriptions" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subInaccessible" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="alarmOptions" -->
  <xsl:variable name="bwStr-AlOp-AlarmOptions">00Alarm options</xsl:variable>
  <xsl:variable name="bwStr-AlOp-AlarmDateTime">00Alarm Date/Time:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-At">00at</xsl:variable>
  <xsl:variable name="bwStr-AlOp-OrBeforeAfterEvent">00or Before/After event:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Days">00days</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Hours">00hours</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Minutes">00minutes</xsl:variable>
  <xsl:variable name="bwStr-AlOp-SecondsOr">00seconds OR:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Weeks">00weeks</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Before">00before</xsl:variable>
  <xsl:variable name="bwStr-AlOp-After">00after</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Start">00start</xsl:variable>
  <xsl:variable name="bwStr-AlOp-End">00end</xsl:variable>
  <xsl:variable name="bwStr-AlOp-EmailAddress">00Email Address:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Subject">00Subject:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Continue">00Continue</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Cancel">00cancel</xsl:variable>  

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">00Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">00(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">00no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">00(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-UploadICalFile">00Upload iCAL File</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">00Filename:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">00Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">00default calendar</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">00accept event's settings</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">00Status:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">00accept event's status</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">00confirmed</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">00canceled</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">00Continue</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">00cancel</xsl:variable>

  <!--  xsl:template name="emailOptions" -->
  <xsl:variable name="bwStr-EmOp-UpdateEmailOptions">00Update email options</xsl:variable>
  <xsl:variable name="bwStr-EmOp-EmailAddress">00Email Address:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Subject">00Subject:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Continue">00Continue</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Cancel">00cancel</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LocL-ManagePreferences">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-LocL-General">00general</xsl:variable>
  <xsl:variable name="bwStr-LocL-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-LocL-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-LocL-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-LocL-ManageLocations">00Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-LocL-AddNewLocation">00Add new location</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-ModL-ManagePreferences">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-ModL-General">00general</xsl:variable>
  <xsl:variable name="bwStr-ModL-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-ModL-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-ModL-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-ModL-AddLocation">00Add Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-EditLocation">00Edit Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-MainAddress">00Main Address:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubAddress">00Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-ModL-LocationLink">00Location Link:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubmitLocation">00Submit Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-DeleteLocation">00Delete Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-Cancel">00cancel</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-OKDL-OKToDeleteLocation">00Ok to delete this location?</xsl:variable>
  <xsl:variable name="bwStr-OKDL-DeleteLocation">00Delete Location</xsl:variable>
  <xsl:variable name="bwStr-OKDL-MainAddress">00Main Address:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Subaddress">00Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-LocationLink">00Location Link:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-YesDeleteLocation">00Yes: Delete Location</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Cancel">00No: Cancel</xsl:variable>


  <!--  xsl:template match="inbox" -->
  <xsl:variable name="bwStr-Inbx-Inbox">00Inbox</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Sent">00sent</xsl:variable>
  <xsl:variable name="bwStr-Inbx-From">00from</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Title">00title</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Start">00start</xsl:variable>
  <xsl:variable name="bwStr-Inbx-End">00end</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Method">00method</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Status">00status</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Unprocessed">00unprocessed</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Publish">00publish</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Request">00request</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Counter">00counter</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Processed">00processed</xsl:variable>

  <!--  xsl:template match="outbox" -->
  <xsl:variable name="bwStr-Oubx-Outbox">00Outbox</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Sent">00sent</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Start">00start</xsl:variable>
  <xsl:variable name="bwStr-Oubx-End">00end</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Method">00method</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Status">00status</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Title">00title</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Organizer">00organizer</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Publish">00publish</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Request">00request</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Counter">00counter</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Unprocessed">00unprocessed</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Processed">00processed</xsl:variable>

  <!--  xsl:template match="scheduleMethod" -->
  <xsl:variable name="bwStr-ScMe-Publish">00publish</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Request">00request</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Reply">00reply</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Add">00add</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Refresh">00refresh</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Counter">00counter</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Declined">00declined</xsl:variable>

  <!--  xsl:template match="formElements" mode="attendeeRespond" -->
  <xsl:variable name="bwStr-AtRe-MeetingCanceled">00Meeting Canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingCounterDeclined">00Meeting Counter Declined</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingRequest">00Meeting Request</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Update">00(update)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Organizer">00Organizer:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisMeetingCanceled">00This meeting has been canceled.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterReqDeclined">00Your counter request has been declined.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Action">00Action:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MarkEventAsCanceled">00mark event as canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DeleteEvent">00delete event</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ReplyAs">00reply as</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Accepted">00accepted</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Declined">00declined</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DelegateTo">00delegate to</xsl:variable>
  <xsl:variable name="bwStr-AtRe-URIOrAccount">00(uri or account)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterSuggest">00counter (suggest a different date, time, and/or location)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewDateTime">00New Date/Time:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Invisible">00invisible</xsl:variable>
  <xsl:variable name="bwStr-AtRe-TimeFields">00timeFields</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDayEvent">00all day event</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Start">00Start:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Date">00Date</xsl:variable>
  <xsl:variable name="bwStr-AtRe-End">00End:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Shown">00shown</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Duration">00Duration</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Days">00days</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Hours">00hours</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Minutes">00minutes</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Weeks">00weeks</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Or">00or</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisEventNoDuration">00This event has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewLocation">00New Location:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Choose">00choose:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Select">00select...</xsl:variable>
  <xsl:variable name="bwStr-AtRe-OrAddNew">00or add new:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Comment">00Comment:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Submit">00Submit</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DateAndTime">00Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDay">00(all day)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Location">00Location:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NotSpecified">00not specified</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendees">00Attendees:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Role">00role</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">00status</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendee">00attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRe-See">00See:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">00Status:</xsl:variable>
  
  <!--  xsl:template match="event" mode="attendeeReply" -->
  <xsl:variable name="bwStr-AtRy-MeetingChangeRequest">00Meeting Change Request (Counter)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-MeetingReply">00Meeting Reply</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Organizer">00Organizer:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Shown">00Attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRy-HasRequestedChange">00has requested a change to this meeting.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Attendee">00Attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Has">00has</xsl:variable>
  <xsl:variable name="bwStr-AtRy-TentativelyAccepted">00TENTATIVELY accepted</xsl:variable>
  <xsl:variable name="bwStr-AtRy-YourInvitation">00your invitation.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-EventNoLongerExists">00Event no longer exists.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-From">00From:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">00Status:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Comments">00Comments:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Action">00Action:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Accept">00accept</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Decline">00decline</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Canceled">00canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Update">00update"</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-AtRy-When">00When:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-AllDay">00(all day)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Where">00Where:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">00Status:</xsl:variable>


  <!--  xsl:template match="event" mode="addEventRef" -->
  <xsl:variable name="bwStr-AERf-AddEventReference">00Add Event Reference</xsl:variable>
  <xsl:variable name="bwStr-AERf-Event">00Event:</xsl:variable>
  <xsl:variable name="bwStr-AERf-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-AERf-IntoCalendar">00Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-AERf-DefaultCalendar">00default calendar</xsl:variable>
  <xsl:variable name="bwStr-AERf-AffectsFreeBusy">00Affects Free/busy:</xsl:variable>
  <xsl:variable name="bwStr-AERf-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-AERf-Opaque">00(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AERf-No">00no</xsl:variable>
  <xsl:variable name="bwStr-AERf-Transparent">00(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AERf-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-AERf-Continue">00Continue</xsl:variable>

  <!--  xsl:template match="prefs" -->
  <xsl:variable name="bwStr-Pref-ManagePrefs">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-Pref-General">00general</xsl:variable>
  <xsl:variable name="bwStr-Pref-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-Pref-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-Pref-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-Pref-UserSettings">00User settings:</xsl:variable>
  <xsl:variable name="bwStr-Pref-User">00User:</xsl:variable>
  <xsl:variable name="bwStr-Pref-EmailAddress">00Email address:</xsl:variable>
  <xsl:variable name="bwStr-Pref-AddingEvents">00Adding events:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredTimeType">00Preferred time type:</xsl:variable>
  <xsl:variable name="bwStr-Pref-12HourAMPM">0012 hour + AM/PM</xsl:variable>
  <xsl:variable name="bwStr-Pref-24Hour">0024 hour</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredEndDateTimeType">00Preferred end date/time type:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Duration">00duration</xsl:variable>
  <xsl:variable name="bwStr-Pref-DateTime">00date/time</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultSchedulingCalendar">00Default scheduling calendar:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdaySettings">00Workday settings:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Workdays">00Workdays:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sun">00Sun</xsl:variable>
  <xsl:variable name="bwStr-Pref-Mon">00Mon</xsl:variable>
  <xsl:variable name="bwStr-Pref-Tue">00Tue</xsl:variable>
  <xsl:variable name="bwStr-Pref-Wed">00Wed</xsl:variable>
  <xsl:variable name="bwStr-Pref-Thu">00Thu</xsl:variable>
  <xsl:variable name="bwStr-Pref-Fri">00Fri</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sat">00Sat</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayStart">00Workday start:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayEnd">00Workday end:</xsl:variable>
  <xsl:variable name="bwStr-Pref-DisplayOptions">00Display options:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredView">00Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredViewPeriod">00Preferred view period:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Day">00day</xsl:variable>
  <xsl:variable name="bwStr-Pref-Today">00today</xsl:variable>
  <xsl:variable name="bwStr-Pref-Week">00week</xsl:variable>
  <xsl:variable name="bwStr-Pref-Month">00month</xsl:variable>
  <xsl:variable name="bwStr-Pref-Year">00year</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezone">00Default timezone:</xsl:variable>
  <xsl:variable name="bwStr-Pref-SelectTimezone">00select timezone...</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezoneNote">00Default timezone id for date/time values. This should normally be your local timezone.</xsl:variable>
  <xsl:variable name="bwStr-Pref-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-Pref-Cancel">00cancel</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ManagePreferences">00Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-ScPr-General">00general</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Categories">00categories</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Locations">00locations</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingMeetings">00scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAccess">00Scheduling access:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetScheduleAccess">00Set scheduling access by modifying acls on your inbox and outbox</xsl:variable>
  <xsl:variable name="bwStr-ScPr-GrantScheduleAccess">00Grant "scheduling" access and "read freebusy".</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AccessNote">00<ul>
	<li>Inbox: users granted scheduling access on your inbox can send you scheduling requests.</li>
    <li>Outbox: users granted scheduling access on your outbox can schedule on your behalf.</li></ul>
    <p class="note">*this approach is temporary and will be improved in upcoming releases.</p></xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAutoProcessing">00Scheduling auto-processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-RespondToSchedReqs">00Respond to scheduling requests:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-True">00true</xsl:variable>
  <xsl:variable name="bwStr-ScPr-False">00false</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AcceptDoubleBookings">00Accept double-bookings:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-CancelProcessing">00Cancel processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DoNothing">00do nothing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetToCanceled">00set event status to CANCELED</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DeleteEvent">00delete the event</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ReponseProcessing">00Response processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-LeaveInInbox">00leave in Inbox for manual processing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ProcessAccepts">00process "Accept" responses - leave the rest in Inbox</xsl:variable>
  <xsl:variable name="bwStr-ScPr-TryToProcessAll">00try to process all responses</xsl:variable>
  <xsl:variable name="bwStr-ScPr-UpdateSchedulingProcessing">00Update scheduling auto-processing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Cancel">00cancel</xsl:variable>

  <!-- xsl:template name="buildWorkdayOptionsList" -->

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">00user</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">00group</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">00owner</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Authenticated">00authenticated</xsl:variable>
  <xsl:variable name="bwStr-ScAF-UnAuthenticated">00unauthenticated</xsl:variable>
  <xsl:variable name="bwStr-ScAF-All">00all</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">00all scheduling</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReqs">00scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReplies">00scheduling replies</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">00free-busy requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">00update</xsl:variable>
  

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

  <!-- xsl:template name="searchResultPageNav" -->
  
  <!-- xsl:template match="calendar" mode="sideList" -->

  <!-- xsl:template name="selectPage" -->

  <!-- xsl:template name="noPage" -->

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">00AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">00PM</xsl:variable>

  <!-- xsl:template name="footer"  -->
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