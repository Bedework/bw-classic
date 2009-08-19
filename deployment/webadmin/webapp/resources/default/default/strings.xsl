<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--  xsl:template match="/" -->
  <xsl:variable name="bwStr-Root-PageTitle">00Calendar Admin: Public Events Administration</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAdminGroup">00No administrative group</xsl:variable>
  <xsl:variable name="bwStr-Root-YourUseridNotAssigned">00Your userid has not been assigned to an administrative group.  Please inform your administrator.</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAccess">00No Access</xsl:variable>
  <xsl:variable name="bwStr-Root-YouHaveNoAccess">00You have no access to the action you just attempted. If you believe you should have access and the problem persists, contact your administrator.</xsl:variable>
  <xsl:variable name="bwStr-Root-Continue">00continue</xsl:variable>
  <xsl:variable name="bwStr-Root-AppError">00Application error</xsl:variable>
  <xsl:variable name="bwStr-Root-AppErrorOccurred">00An application error occurred.</xsl:variable>
 
  <!--  xsl:template name="header" -->
  <xsl:variable name="bwStr-Head-BedeworkPubEventsAdmin">00Bedework Public Events Administration</xsl:variable>
  <xsl:variable name="bwStr-Head-CalendarSuite">00Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-Head-None">00none</xsl:variable>
  <xsl:variable name="bwStr-Head-Group">00Group:</xsl:variable>
  <xsl:variable name="bwStr-Head-Change">00change</xsl:variable>
  <xsl:variable name="bwStr-Head-LoggedInAs">00Logged in as:</xsl:variable>
  <xsl:variable name="bwStr-Head-LogOut">00log out</xsl:variable>
  <xsl:variable name="bwStr-Head-MainMenu">00Main Menu</xsl:variable>
  <xsl:variable name="bwStr-Head-PendingEvents">00Pending Events</xsl:variable>
  <xsl:variable name="bwStr-Head-Users">00Users</xsl:variable>
  <xsl:variable name="bwStr-Head-System">00System</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="mainMenu" -->
  <xsl:variable name="bwStr-MMnu-LoggedInAs">00<strong>You are logged in as superuser.</strong><br/>
    Common event administration is best performed as a typical event administrator.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-YouMustBeOperating">00You must be operating in the context of a calendar suite\nto add or manage events.\n\nYour current group is neither associated with a calendar suite\nnor a child of a group associated with a calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddEvent">00Add Event</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddContact">00Add Contact</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddLocation">00Add Location</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddCategory">00Add Category</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageEvents">00Manage Events</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageContacts">00Manage Contacts</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageLocations">00Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageCategories">00Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-MMnu-EventSearch">00Event search:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Go">00go</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Limit">00Limit:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-TodayForward">00today forward</xsl:variable>
  <xsl:variable name="bwStr-MMnu-PastDates">00past dates</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddDates">00all dates</xsl:variable>

  <!--  xsl:template name="tabPendingEvents" -->
  <xsl:variable name="bwStr-TaPE-PendingEvents">00Pending Events</xsl:variable>
  <xsl:variable name="bwStr-TaPE-EventsAwaitingModeration">00The following events are awaiting moderation:</xsl:variable>

  <!--  xsl:template name="tabCalsuite" -->
  <xsl:variable name="bwStr-TaCS-ManageCalendarSuite">00Manage Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-TaCS-CalendarSuite">00Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Group">00Group:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Change">00change</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageSubscriptions">00Manage subscriptions</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageViews">00Manage views</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManagePreferences">00Manage preferences</xsl:variable>

  <!--  xsl:template name="tabUsers" -->
  <xsl:variable name="bwStr-TaUs-ManageUsersAndGroups">00Manage Users &amp; Groups</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ManageAdminGroups">00Manage admin groups</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ChangeGroup">00Change group...</xsl:variable>
  <xsl:variable name="bwStr-TaUs-EditUsersPrefs">00Edit user preferences (enter userid):</xsl:variable>
  <xsl:variable name="bwStr-TaUs-Go">00go</xsl:variable>

  <!--  xsl:template name="tabSystem" -->
  <xsl:variable name="bwStr-TaSy-ManageSys">00Manage System</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalsAndFolders">00Manage calendars &amp; folders</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCategories">00Manage categories</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalSuites">00Manage calendar suites</xsl:variable>
  <xsl:variable name="bwStr-TaSy-UploadICalFile">00Upload ical file</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysPrefs">00Manage system preferences</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysTZs">00Manage system timezones</xsl:variable>
  <xsl:variable name="bwStr-TaSy-Stats">00Statistics:</xsl:variable>
  <xsl:variable name="bwStr-TaSy-AdminWebClient">00admin web client</xsl:variable>
  <xsl:variable name="bwStr-TaSy-PublicWebClient">00public web client</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalDAVFilters">00Manage CalDAV filters</xsl:variable>

  <!--  xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-ManageEvents">00Manage Events</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SelectEvent">00Select the event that you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-PageTitle">00Add new event</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Show">00Show:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Active">00Active</xsl:variable>
  <xsl:variable name="bwStr-EvLs-All">00All</xsl:variable>
  <xsl:variable name="bwStr-EvLs-FilterBy">00Filter by:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SelectCategory">00select a category</xsl:variable>
  <xsl:variable name="bwStr-EvLs-ClearFilter">00clear filter</xsl:variable>
  
  <!--  xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">00Title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">00Claimed By</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">00Start</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">00End</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Suggested">00Suggested</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">00Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Categories">00Categories</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">00Description</xsl:variable>

  <!--  xsl:template match="event" mode="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">00unclaimed</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ThisEventCrossTagged">00This event is cross-tagged.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ShowTagsByOtherGroups">00Show tags by other groups</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEventEdit">00Recurring event.  Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">00master</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">00instance</xsl:variable>
  
  <!--  xsl:template match="formElements" mode="modEvent" -->
  <xsl:variable name="bwStr-AEEF-Recurrence">00recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RECURRANCE">00Recurrence:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventInfo">00Event Information</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YouMayTag">00You may tag this event by selecting topical areas below.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedBy">00Submitted by</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SendMsg">00send message</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CommentsFromSubmitter">00Comments from Submitter</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowHide">00show/hide</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PopUp">00pop-up</xsl:variable>
  <xsl:variable name="bwStr-AEEF-For">00for</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectColon">00Select:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedEvents">00submitted events</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Preferred">00preferred</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">00all</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-ThisEventHasNoDurationEndDate">00This event has no duration / end date</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">00This event is a recurrence instance.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">00edit master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">00edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">00event recurs</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">00event does not recur</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-Times">00time(s)</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-Time">00time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">00Time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">00TZid</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">00Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">00No exception dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">00Exception dates may also be created by deleting an instance of a recurring event.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">00add recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">00add exception</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">00Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">00confirmed</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">00canceled</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YesOpaque">00yes (opaque)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTransparent">00no (transparent)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EnterPertientInfo">00Enter all pertinent information, including the academic titles of all speakers and/or participants.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CharsMax">00characters max.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cost">00Cost:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalPlaceToPurchaseTicks">00(optional: if any, and place to purchase tickets)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventURL">00Event URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalMoreEventInfo">00(optional: for more information about the event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageURL">00Image URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalEventImage">00(optional: to include an image with the event description)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Location">00Location:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Add">00add</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Address">00Address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IncludeRoom">00Please include room, building, and campus.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-LocationURL">00Location URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalLocaleInfo">00(optional: for information about the location)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Contact">00Contact:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Creator">00Creator</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TopicalArea">00Topical area:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactName">00Contact (name):</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactPhone">00Contact Phone Number:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactURL">00Contact's URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactEmail">00Contact Email Address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Optional">00(optional)</xsl:variable>
  
  <!--  xsl:template match="calendar" mode="showEventFormAliases" -->

  <!--  xsl:template name="submitEventButtons" -->
  <xsl:variable name="bwStr-SEBu-SelectPublishCalendar">00Select a calendar in which to publish this event:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Select">00Select:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-SubmittedEvents">00submitted events</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CalendarDescriptions">00calendar descriptions</xsl:variable>
  <xsl:variable name="bwStr-SEBu-DeleteEvent">00Delete Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-UpdateEvent">00Update Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-PublishEvent">00Publish Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Cancel">00Cancel</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ClaimEvent">00Claim Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-AddEvent">00Add Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CopyEvent">00Copy Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ReleaseEvent">00Release Event</xsl:variable>
  

  <!--  xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!--  xsl:template name="byDayChkBoxList" -->

  <!--  xsl:template name="buildCheckboxList" -->

  <!--  xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">00the first</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">00the second</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">00the third</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">00the fourth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">00the fifth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">00the last</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">00every</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">00none</xsl:variable>

  <!--  xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">00and</xsl:variable>

  <!--  xsl:template name="buildNumberOptions" -->

  <!--  xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">00Bedework 24-Hour Clock</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">00type</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">00select time</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">00switch</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">00close</xsl:variable>

  <!--  xsl:template match="event" mode="displayEvent" -->
  <xsl:variable name="bwStr-DsEv-OkayToDelete">00Ok to delete this event?</xsl:variable>
  <xsl:variable name="bwStr-DsEv-NoteDontEncourageDeletes">00Note: we do not encourage deletion of old but correct events; we prefer to keep old events for historical reasons.  Please remove only those events that are truly erroneous.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-AllDay">00(all day)</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YouDeletingPending">00You are deleting a pending event.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-SendNotification">00Send notification to submitter</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Reason">00Reason (leave blank to exclude):</xsl:variable>
  <xsl:variable name="bwStr-DsEv-EventInfo">00Event Information</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-When">00When:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TopicalAreas">00Topical Areas:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Price">00Price:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-URL">00URL:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Location">00Location:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Contact">00Contact:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Owner">00Owner:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Submitter">00Submitter:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TagEvent">00Tag event with topical areas</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YesDeleteEvent">00Yes: Delete Event</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template name="contactList" -->
  <xsl:variable name="bwStr-Cont-ManageContacts">00Manage Contacts</xsl:variable>
  <xsl:variable name="bwStr-Cont-SelectContact">00Select the contact you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-Cont-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-Cont-Phone">00Phone</xsl:variable>
  <xsl:variable name="bwStr-Cont-Email">00Email</xsl:variable>
  <xsl:variable name="bwStr-Cont-URL">00URL</xsl:variable>
  <xsl:variable name="bwStr-Cont-AddNewContact">00Add new contact</xsl:variable>

  <!--  xsl:template name="modContact" -->
  <xsl:variable name="bwStr-MdCo-ContactInfo">00Contact Information</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactName">00Contact (name):</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactPhone">00Contact Phone Number:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactURL">00Contact's URL:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactEmail">00Contact Email Address:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-Optional">00(optional)</xsl:variable>
  
  <!--  xsl:template name="deleteContactConfirm" -->
  <xsl:variable name="bwStr-DCoC-OKToDelete">00Ok to delete this contact?</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Phone">00Phone</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Email">00Email</xsl:variable>
  <xsl:variable name="bwStr-DCoC-URL">00URL</xsl:variable>
  <xsl:variable name="bwStr-DCoC-DeleteContact">00Delete Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-UpdateContact">00Update Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-AddContact">00Add Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Cancel">00Cancel</xsl:variable>
  
  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LoLi-ManageLocations">00Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SelectLocationToUpdate">00Select the location that you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Address">00Address</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SubAddress">00Subaddress</xsl:variable>
  <xsl:variable name="bwStr-LoLi-URL">00URL</xsl:variable>
  <xsl:variable name="bwStr-LoLi-AddNewLocation">00Add new location</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-MoLo-AddLocation">00Add Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-UpdateLocation">00Update Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address">00Address:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubAddress">00Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Optional">00(optional)</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationURL">00Location's URL:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-DeleteLocation">00Delete Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Cancel">00Cancel</xsl:variable>
  
  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-DeLC-OkDeleteLocation">00Ok to delete this location?</xsl:variable>
  <xsl:variable name="bwStr-DeLC-Address">00Address:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-SubAddress">00Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-LocationURL">00Location's URL:</xsl:variable>

  <!--  xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-CtgL-ManageCategories">00Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-CtgL-SelectCategory">00Select the category you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-CtgL-AddNewCategory">00Add new category</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Keyword">00Keyword</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Description">00Description</xsl:variable>

  <!--  xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MoCa-AddCategory">00Add Category</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Keyword">00Keyword:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Cancel">00Cancel</xsl:variable>
  <xsl:variable name="bwStr-MoCa-UpdateCategory">00Update Category</xsl:variable>
  <xsl:variable name="bwStr-MoCa-DeleteCategory">00Delete Category</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DeCC-CategoryDeleteOK">00Ok to delete this category?</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Keyword">00Keyword:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-YesDelete">00Yes: Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DeCC-NoCancel">00No: Cancel</xsl:variable>

  <!--  xsl:template name="categorySelectionWidget" -->
  <xsl:variable name="bwStr-CaSW-ShowHideUnusedCategories">00show/hide unused categories</xsl:variable>

  <!--  xsl:template match="calendars" mode="calendarCommon" -->
  <xsl:variable name="bwStr-Cals-Collections">00Collections</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectByPath">00Select by path:</xsl:variable>
  <xsl:variable name="bwStr-Cals-PublicTree">00Public Tree</xsl:variable>
  <xsl:variable name="bwStr-Cals-Go">00go</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate" -->
  <xsl:variable name="bwStr-Cals-Alias">00alias</xsl:variable>
  <xsl:variable name="bwStr-Cals-Folder">00folder</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendar">00calendar</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay" -->

  <!--  xsl:template match="calendar" mode="listForMove" -->
  
  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalFileOrSub">00Add Calendar, Folder, or Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAccessSet">00Note: Access may be set on a calendar after it is created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">00Summary:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Filter">00Filter:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesFiltering">00show/hide categories for filtering on output</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Categories">00Categories:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesAutoTagging">00show/hide categories for auto-tagging on input</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">00Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">00calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">00folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FOLDER">00Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">00subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionURL">00Subscription URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">00URL to calendar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">00ID (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">00Password (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAliasCanBeAdded">00Note: An alias can be added to a Bedework calendar using a URL of the form:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">00Add</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">00cancel</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar" -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">00Modify Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">00Modify Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">00Modify Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TopicalArea">00Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-True">00true</xsl:variable>
  <xsl:variable name="bwStr-CuCa-False">00false</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">00Display:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInCollection">00display items in this collection</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">00Disabled:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ItemIsInaccessible">00This item is inaccessible and has been disabled.  You may re-enable it to try again.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">00URL:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">00Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">00Update Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">00Update Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">00Update Calendar</xsl:variable>

  <!--  xsl:template name="calendarList" -->
  <xsl:variable name="bwStr-CaLi-ManageCalendarsAndFolders">00Manage Calendars &amp; Folders</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectItemFromPublicTree">00Select an item from the Public Tree on the left to modify a calendar or folder</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectThe">00Select the</xsl:variable>
  <xsl:variable name="bwStr-CaLi-IconToAdd">00icon to add a new calendar or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-FoldersMayContain">00Folders may only contain calendars and subfolders.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-CalendarsMayContain">00Calendars may only contain events (and other calendar items).</xsl:variable>
  <xsl:variable name="bwStr-CaLi-RetrieveCalendar">00Retrieve a calendar or folder directly by its path using the form to the left.</xsl:variable>

  <!--  xsl:template name="calendarDescriptions" -->
  <xsl:variable name="bwStr-CaLD-CalendarInfo">00Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CaLD-SelectItemFromCalendarTree">00Select an item from the calendar tree on the left to view all information about that calendar or folder.  The tree on the left represents the calendar heirarchy.</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Path">00Path:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Summary">00Summary:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Description">00Description:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar" -->
  <xsl:variable name="bwStr-CuCa-RemoveSubscription">00Remove Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingSubscriptionRemoved">00The following subscription will be removed. Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">00Delete Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingFolderDeleted">00The following folder <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">00Delete Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingCalendarDeleted">00The following calendar will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">00Path:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm" -->
  <xsl:variable name="bwStr-CuCa-YesRemoveSubscription">00Yes: Remove Subscription!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">00Yes: Delete Folder!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">00Yes: Delete Calendar!</xsl:variable>

 <!--  xsl:template name="selectCalForEvent" --> 
  <xsl:variable name="bwStr-SCFE-SelectCal">00Select a calendar</xsl:variable>
  <xsl:variable name="bwStr-SCFE-Calendars">00Calendars</xsl:variable>
 
  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="calendarMove" -->
  <xsl:variable name="bwStr-CaMv-MoveCalendar">00Move Calendar/Folder</xsl:variable>
  <xsl:variable name="bwStr-CaMv-CurrentPath">00Current Path:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-MailingListID">00Mailing List ID:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Summary">00Summary:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-SelectNewParentFolder">00Select a new parent folder:</xsl:variable>

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">00user</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">00group</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Or">00or</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">00owner</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AuthenticatedUsers">00authenticated users</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Anyone">00anyone</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">00all scheduling</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReplies">00scheduling replies</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">00free-busy requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReqs">00scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Cancel">00cancel</xsl:variable>

  <!--  xsl:template match="acl" mode="currentAccess" -->
  <xsl:variable name="bwStr-ACLs-CurrentAccess">00Current Access:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Entry">00Entry</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Access">00Access</xsl:variable>
  <xsl:variable name="bwStr-ACLs-InheritedFrom">00Inherited from</xsl:variable>
  <xsl:variable name="bwStr-ACLs-User">00user</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Group">00group</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Auth">00auth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-UnAuth">00unauth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-All">00all</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Other">00other</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Anyone">00anyone (other)</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Grant">00grant:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Deny">00deny:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Local">00local</xsl:variable>

  <!--  xsl:template match="calendars" mode="subscriptions" -->

  <!--  xsl:template name="subscriptionIntro" -->
  <xsl:variable name="bwStr-Subs-Subscriptions">00Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Subs-ManagingSubscriptions">00Managing Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectAnItem">00Select an item from the tree on the left to modify a subscription.</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectThe">00Select the</xsl:variable>
  <xsl:variable name="bwStr-Subs-IconToAdd">00icon to add a new subscription or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-Subs-TopicalAreasNote">00<ul>
    <li><strong>Topical Areas:</strong><ul><li>
          A subscription marked as a "Topical Area" will be presented to event administrators when creating events.
          These are used for input (tagging) and output (if added to a view).
        </li>
        <li>
          A subscription not marked as a "Topical Area" can be used in Views,
          but will not appear when creating events.  Such subscriptions are used for output only,
          e.g. an ical feed of holidays from an external source.
        </li>
    </ul></li></ul></xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdateSubscription" -->
  <xsl:variable name="bwStr-Cals-AddSubscription">00add a subscription</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="addSubscription" -->
  <xsl:variable name="bwStr-CuCa-AddSubscription">00Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote">00Note: Access may be set on a subscription after it is created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicAlias">00Public alias</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectPublicCalOrFolder">00Select a public calendar or folder</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->
  <xsl:variable name="bwStr-Cals-Trash">00trash</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteSubConfirm" -->

  <!--  xsl:template match="views" mode="viewList" -->
  <xsl:variable name="bwStr-View-ManageViews">00Manage Views</xsl:variable>
  <xsl:variable name="bwStr-View-ViewsAreNamedAggr">00Views are named aggregations of subscriptions used to display sets of events within a calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-View-AddNewView">00Add a new view</xsl:variable>
  <xsl:variable name="bwStr-View-Views">00Views</xsl:variable>
  <xsl:variable name="bwStr-View-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-View-IncludedSubscriptions">00Included subscriptions</xsl:variable>

  <!--  xsl:template name="modView" -->
  <xsl:variable name="bwStr-ModV-UpdateView">00Update View</xsl:variable>
  <xsl:variable name="bwStr-ModV-InSomeConfigs">00In some configurations, changes made here will not show up in the calendar suite until the cache is flushed (approx. 5 minutes) or you start a new session (e.g. clear your cookies).</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeletingAView">00Deleting a view on a production system should be followed by a server restart to clear the cache for all users.</xsl:variable>
  <xsl:variable name="bwStr-ModV-ToSeeUnderlying">00To see underlying subscriptions in a local folder, open the folder in the</xsl:variable>
  <xsl:variable name="bwStr-ModV-ManageSubscriptions">00Manage Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-ModV-Tree">00tree (this will be improved in a later version...).</xsl:variable>
  <xsl:variable name="bwStr-ModV-IfYouInclude">00If you include a folder in a view, you do not need to include its children.</xsl:variable>
  <xsl:variable name="bwStr-ModV-AvailableSubscriptions">00Available subscriptions:</xsl:variable>
  <xsl:variable name="bwStr-ModV-ActiveSubscriptions">00Active subscriptions:</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeleteView">00Delete View</xsl:variable>
  <xsl:variable name="bwStr-ModV-ReturnToViewsListing">00Return to Views Listing</xsl:variable>

  <!--  xsl:template name="deleteViewConfirm" -->
  <xsl:variable name="bwStr-DeVC-RemoveView">00Remove View?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-TheView">00The view</xsl:variable>
  <xsl:variable name="bwStr-DeVC-WillBeRemoved">00will be removed.</xsl:variable>
  <xsl:variable name="bwStr-DeVC-BeForewarned">00Be forewarned: if caching is enabled, removing views from a production system can cause the public interface to throw errors until the cache is flushed (a few minutes).</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Continue">00Continue?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-YesRemoveView">00Yes: Remove View</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Cancel">00No: Cancel</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-UploadICalFile">00Upload iCAL File</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">00Filename:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">00Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-Upld-NoneSelected">00<em>none selected</em></xsl:variable>
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">00Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">00accept event's settings</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">00yes</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">00(opaque: event status affects free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">00no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">00(transparent: event status does not affect free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">00accept event's status</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">00confirmed</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">00canceled</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">00Continue</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">C00ancel</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">00default calendar</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">00Status:</xsl:variable>
  
  <!--  xsl:template name="modSyspars" -->
  <xsl:variable name="bwStr-MdSP-ManageSysParams">00Manage System Preferences/Parameters</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DoNotChangeUnless">00Do not change unless you know what you're doing.<br/>Changes to these parameters have wide impact on the system.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemName">00System name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemNameCannotBeChanged">00Name for this system. Cannot be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultTimezone">00Default timezone:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SelectTimeZone">00select timezone...</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNormallyLocal">00Default timezone id for date/time values. This should normally be your local timezone.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SuperUsers">00Super Users:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-CommaSeparatedList">00Comma separated list of super users. No spaces.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemID">00System id:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemIDNote">00System id used when building uids and identifying users. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-PubCalendarRoot">00Public Calendar Root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-PubCalendarRootNote">00Name for public calendars root directory. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRoot">00User Calendar Root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRootNote">00Name for user calendars root directory. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultName">00User Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultNameNote">00efault name for user calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultName">00Trash Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultNameNote">00Default name for user trash calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-InboxNote">00Default name for user inbox. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultName">00User Outbox Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultNameNote">00Default name for user outbox. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultName">00User Deleted Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultNameNote">00Default name for user calendar used to hold deleted items. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultName">00User Busy Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultNameNote">00Default name for user busy time calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewName">00Default user view name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewNameNote">00Name used for default view created when a new user is added</xsl:variable>
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerUser">00Http connections per user:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerHost">00Http connections per host:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TotalHTTPConnections">00Total http connections:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxLengthPubEventDesc">00Maximum length of public event description:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxLengthUserEventDesc">00Maximum length of user event description:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxSizeUserEntity">00Maximum size of a user entity:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserQuota">00Default user quota:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstances">00Max recurring instances:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstancesNote">00Used to limit recurring events to reasonable numbers of instances.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYears">00Max recurring years:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYearsNotes">00Used to limit recurring events to reasonable period of time.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClass">00User authorization class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClassNote">00Class used to determine authorization (not authentication) for administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClass">00Mailer class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClassNote">00Class used to mail events. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClass">00Admin groups class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClassNote">00Class used to query and maintain groups for administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClass">00User groups class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClassNote">00Class used to query and maintain groups for non-administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowd">00Directory browsing disallowed:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowedNote">00True if the server hosting the xsl disallows directory browsing.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexRoot">00Index root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexRootNote">00Root for the event indexes. Should only be changed if the indexes are moved/copied</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SupportedLocales">00Supported Locales:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-ListOfSupportedLocales">00List of supported locales. The format is a rigid, comma separated list of 2 letter language, underscore, 2 letter country. No spaces. Example: en_US,fr_CA</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template match="calSuites" mode="calSuiteList" -->
  <xsl:variable name="bwStr-CalS-ManageCalendarSuites">00Manage Calendar Suites</xsl:variable>
  <xsl:variable name="bwStr-CalS-AddCalendarSuite">00Add calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-SwitchGroup">00Switch group</xsl:variable>
  <xsl:variable name="bwStr-CalS-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-CalS-AssociatedGroup">00Associated Group</xsl:variable>

  <!--  xsl:template name="addCalSuite" -->
  <xsl:variable name="bwStr-AdCS-AddCalSuite">00Add Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameCalSuite">00Name of your calendar suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Group">00Group:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameAdminGroup">00Name of admin group which contains event administrators and event owner to which preferences for the suite are attached</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Add">00Add</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Cancel">00Cancel</xsl:variable>
  
  <!--  xsl:template match="calSuite" name="modCalSuite" -->
  <xsl:variable name="bwStr-CalS-ModifyCalendarSuite">00Modify Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameColon">00Name:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfCalendarSuite">00Name of your calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Group">00Group:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfAdminGroup">00Name of admin group which contains event administrators and event owner to which preferences for the suite are attached</xsl:variable>
  <xsl:variable name="bwStr-CalS-CurrentAccess">00Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CalS-DeleteCalendarSuite">00Delete Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-CalS-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template name="calSuitePrefs" -->
  <xsl:variable name="bwStr-CSPf-EditCalSuitePrefs">00Edit Calendar Suite Preferences</xsl:variable>
  <xsl:variable name="bwStr-CSPf-CalSuite">00Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredView">00Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredViewPeriod">00Preferred view period:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Day">00day</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Today">00today</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Week">00week</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Month">00month</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Year">00year</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultCategories">00Default Categories:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-ShowHideUnusedCategories">00show/hide unused categories</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template name="uploadTimezones" -->
  <xsl:variable name="bwStr-UpTZ-ManageTZ">00Manage Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-UploadTZ">00Upload Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-Cancel">00Cancel</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZ">00Fix Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-RecalcUTC">00(recalculate UTC values)</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZNote">00Run this to make sure no UTC values have changed due to this upload (e.g. DST changes).</xsl:variable>

  <!--  xsl:template name="authUserList" -->
  <xsl:variable name="bwStr-AuUL-ModifyAdministrators">00Modify Administrators</xsl:variable>
  <xsl:variable name="bwStr-AuUL-EditAdminRoles">00Edit admin roles by userid:</xsl:variable>
  <xsl:variable name="bwStr-AuUL-UserID">00UserId</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Roles">00Roles</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Edit">00edit</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Go">00go</xsl:variable>

  <!--  xsl:template name="modAuthUser" -->
  <xsl:variable name="bwStr-MoAU-UpdateAdmin">00Update Administrator</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Account">00Account:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-PublicEvents">00Public Events:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template name="modPrefs" -->
  <xsl:variable name="bwStr-MoPr-EditUserPrefs">00Edit User Preferences</xsl:variable>
  <xsl:variable name="bwStr-MoPr-User">00User:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredView">00Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredViewPeriod">00Preferred view period:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Day">00day</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Today">00today</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Week">00week</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Month">00month</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Year">00year</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Update">00Update</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Cancel">00Cancel</xsl:variable>

  <!--  xsl:template name="listAdminGroups" -->
  <xsl:variable name="bwStr-LsAG-ModifyGroups">00Modify Groups</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HideMembers">00Hide members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ShowMembers">00Show members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-SelectGroupName">00Select a group name to modify the group owner or description.<br/>Click "membership" to modify group membership.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-AddNewGroup">00Add a new group</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HighlightedRowsNote">00*Highlighted rows indicate a group to which a Calendar Suite is attached.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Members">00Members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ManageMembership">00Manage<br/>Membership</xsl:variable>
  <xsl:variable name="bwStr-LsAG-CalendarSuite">00Calendar Suite*</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Description">00Description</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Membership">00membership</xsl:variable>

  <!--  xsl:template match="groups" mode="chooseGroup" -->
  <xsl:variable name="bwStr-Grps-ChooseAdminGroup">00Choose Your Administrative Group</xsl:variable>
  <xsl:variable name="bwStr-Grps-HighlightedRowsNote">00*Highlighted rows indicate a group to which a Calendar Suite is attached.  Select one of these groups to edit attributes of the associated calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Superuser">00<strong>Superuser:</strong> to dissasociate yourself from all groups, log out and log back in.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Name">00Name</xsl:variable>
  <xsl:variable name="bwStr-Grps-Description">00Description</xsl:variable>
  <xsl:variable name="bwStr-Grps-CalendarSuite">00Calendar Suite*</xsl:variable>
 
  <!--  xsl:template name="modAdminGroup" -->
  <xsl:variable name="bwStr-MoAG-AddGroup">00Add Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-ModifyGroup">00Modify Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-GroupOwner">00Group owner:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-EventsOwner">00Events owner:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-MoAG-AddAdminGroup">00Add Admin Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Cancel">00Cancel</xsl:variable>
  <xsl:variable name="bwStr-MoAG-UpdateAdminGroup">00Update Admin Group</xsl:variable>

  <!--  xsl:template name="modAdminGroupMembers" -->
  <xsl:variable name="bwStr-MAGM-UpdateGroupMembership">00Update Group Membership</xsl:variable>
  <xsl:variable name="bwStr-MAGM-EnterUserID">00Enter a userid (for user or group) and click "add" to update group membership. Click the trash icon to remove a user from the group.</xsl:variable>
  <xsl:variable name="bwStr-MAGM-AddMember">00Add member:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-User">00user</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Group">00group</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Add">00Add</xsl:variable>
  <xsl:variable name="bwStr-MAGM-ReturnToAdminGroupLS">00Return to Admin Group listing</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Members">00Members:</xsl:variable>

  <!--  xsl:template name="deleteAdminGroupConfirm" -->
  <xsl:variable name="bwStr-DAGC-DeleteAdminGroup">00Delete Admin Group?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-GroupWillBeDeleted">00The following group will be deleted. Continue?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-YesDelete">00Yes: Delete!</xsl:variable>
  <xsl:variable name="bwStr-DAGC-NoCancel">00No: Cancel</xsl:variable>

  <!--  xsl:template name="addFilter" -->
  <xsl:variable name="bwStr-AdFi-AddNameCalDAVFilter">00Add a Named CalDAV Filter</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Examples">00examples</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Name">00Name:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Description">00Description:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterDefinition">00Filter Definition:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-AddFilter">00Add Filter</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Cancel">00Cancel</xsl:variable>
  <xsl:variable name="bwStr-AdFi-CurrentFilters">00Current Filters</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterName">00Filter Name</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DescriptionDefinition">00Description/Definition</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-AdFi-ShowHideFilterDef">00show/hide filter definition</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DeleteFilter">00delete filter</xsl:variable>

  <!--  xsl:template match="sysStats" mode="showSysStats" -->
  <xsl:variable name="bwStr-SysS-SystemStatistics">00System Statistics</xsl:variable>
  <xsl:variable name="bwStr-SysS-StatsCollection">00Stats collection:</xsl:variable>
  <xsl:variable name="bwStr-SysS-Enable">00enable</xsl:variable>
  <xsl:variable name="bwStr-SysS-Disable">00disable</xsl:variable>
  <xsl:variable name="bwStr-SysS-FetchRefreshStats">00fetch/refresh statistics</xsl:variable>
  <xsl:variable name="bwStr-SysS-DumpStatsToLog">00dump stats to log</xsl:variable>

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
  <xsl:variable name="bwStr-Srch-Title">00title</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">00date &amp; time</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">00calendar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">00location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">00no title</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">00Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">00show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">00refresh XSLT</xsl:variable>
 
</xsl:stylesheet>