<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- xsl:template match="/" -->

  <!-- xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-BedeworkSubmitPubEv">00Bedework: Submit a Public Event</xsl:variable>

  <!-- xsl:template name="header" -->
  <xsl:variable name="bwStr-Hedr-BedeworkPubEventSub">00Bedework Public Event Submission</xsl:variable>
  <xsl:variable name="bwStr-Hedr-LoggedInAs">00logged in as</xsl:variable>
  <xsl:variable name="bwStr-Hedr-Logout">00logout</xsl:variable>

  <!-- xsl:template name="messagesAndErrors" -->

  <!-- xsl:template name="menuTabs" -->
  <xsl:variable name="bwStr-MeTa-Overview">00Overview</xsl:variable>
  <xsl:variable name="bwStr-MeTa-AddEvent">00Add Event</xsl:variable>
  <xsl:variable name="bwStr-MeTa-MyPendingEvents">00My Pending Events</xsl:variable>

  <!-- xsl:template name="home" -->
  <xsl:variable name="bwStr-Home-Start">00start</xsl:variable>
  <xsl:variable name="bwStr-Home-EnteringEvents">00Entering Events</xsl:variable>
  <xsl:variable name="bwStr-Home-BeforeSubmitting">00Before submitting a public event,</xsl:variable>
  <xsl:variable name="bwStr-Home-SeeIfItHasBeenEntered">00see if it has already been entered</xsl:variable>
  <xsl:variable name="bwStr-Home-ItIsPossible">00It is possible that an event may be created under a different title than you'd expect.</xsl:variable>
  <xsl:variable name="bwStr-Home-MakeYourTitles">00Make your titles descriptive: rather than "Lecture" use "Music Lecture Series: 'Uses of the Neapolitan Chord'". "Cinema Club" would also be too vague, while "Cinema Club: 'Citizen Kane'" is better. Bear in mind that your event will "share the stage" with other events in the calendar - try to be as clear as possible when thinking of titles. Express not only what the event is, but (briefly) what it's about. Elaborate on the event in the description field, but try not to repeat the same information.  Try to think like a user when suggesting an event: use language that will explain your event to someone who knows absolutely nothing about it.</xsl:variable>
  <xsl:variable name="bwStr-Home-DoNotInclude">00Do not include locations and times in the description field (unless it is to add extra information not already displayed).</xsl:variable>

  <!-- xsl:template match="formElements" mode="addEvent" -->
  <!-- xsl:template match="formElements" mode="editEvent" -->
  <!-- xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-FoEl-DeleteColon">00Delete:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Instance">00instance</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Delete">00Delete</xsl:variable>
  <xsl:variable name="bwStr-FoEl-All">00all</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TASK">00Task</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Task">00task</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Meeting">00Meeting</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EVENT">00Event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Event">00event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Recurring">00Recurring</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Personal">00Personal</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Public">00Public</xsl:variable>
  <xsl:variable name="bwStr-FoEl-RecurrenceMaster">00(recurrence master)</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Next">00next</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step1">00<strong>Step 1:</strong> Enter Event Details. <em>Optional fields are italicized.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Previous">00previous</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step2">00<strong>Step 2:</strong> Select Location.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step3">00<strong>Step 3:</strong> Select Contact.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step4">00<strong>Step 4:</strong> Suggest Topical Areas. <em>Optional.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step5">00<strong>Step 5:</strong> Contact Information and Comments.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Calendar">00Calendar:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Title">00Title:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeTitle">00You must include a title.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DateAndTime">00Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-AllDay">00all day</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Start">00Start:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Date">00Date</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectTimezone">00select timezone</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Due">00Due:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-End">00End:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Date">00Date</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Duration">00Duration</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Days">00days</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Hours">00hours</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Minutes">00minutes</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Weeks">00weeks</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Or">00or</xsl:variable>
  <xsl:variable name="bwStr-FoEl-This">00This</xsl:variable>
  <xsl:variable name="bwStr-FoEl-HasNoDurationEndDate">00has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Description">00Description</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeDescription">00You must include a description.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Status">00Status:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Confirmed">00confirmed</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Tentative">00tentative</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Canceled">00canceled</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cost">00Cost:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CostOptional">00optional: if any, and place to purchase tickets</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURL">00Event URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURLOptional">00optional: for more information about the event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURL">00Image URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURLOptional">00optional: to include an image with the event description</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectLocation">00You must either select a location or suggest one below.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingLocation">00select an existing location...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindLocation">00Didn't find the location?  Suggest a new one:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Address">00Address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubAddress">00Sub-address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Optional">00optional</xsl:variable>
  <xsl:variable name="bwStr-FoEl-URL">00URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectContact">00You must either select a contact or suggest one below.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingContact">00select an existing contact...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindContact">00Didn't find the contact you need?  Suggest a new one:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-OrganizationName">00Organization Name:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-PleaseLimitContacts">00Please limit contacts to organizations, not individuals.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Phone">00Phone:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Email">00Email:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MissingTopicalArea">00Missing a topical area?  Please describe what type of event you're submitting:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TypeOfEvent">00Type of event:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeEmail">00You must include your email address.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-InvalidEmailAddress">00This does not appear to be a valid email address.  Please correct.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EnterEmailAddress">00Enter your email address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-FinalNotes">00Please supply any final notes or instructions regarding your event:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubmitForApproval">00submit for approval</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cancel">00cancel</xsl:variable>

  <!-- xsl:template match="calendar" mode="showEventFormAliases" -->

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->
  <xsl:variable name="bwStr-WMYN-Next">00and</xsl:variable>
 
  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RDPO-None">00none</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFirst">00the first</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheSecond">00the second</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheThird">00the third</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFourth">00the fourth</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFifth">00the fifth</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheLast">00the last</xsl:variable>
  <xsl:variable name="bwStr-RDPO-Every">00every</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BReF-And">00and</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">00Bedework 24-Hour Clock</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">00type</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">00select time</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">00switch</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">00close</xsl:variable>

  <!-- xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-PendingEvents">00Pending Events</xsl:variable>
  <xsl:variable name="bwStr-EvLs-EventsBelowWaiting">00The events below are waiting to be published by a calendar administrator.  You may edit or delete the events until they have been accepted.  Once your event is published, you will no longer see it in your list.</xsl:variable>
  
  <!-- xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">00Title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">00Claimed By</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">00Start</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">00End</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">00Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">00Description</xsl:variable>
  <xsl:variable name="bwStr-EvLC-NoTitle">00no title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">00unclaimed</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEvent">00Recurring event.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Edit">00Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">00master</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">00instance</xsl:variable>

  <!-- xsl:template name="upload" -->
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
  
  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">00AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">00PM</xsl:variable>

  <!-- xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">00Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">00show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">00refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">00Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">00Bedework Calendar System</xsl:variable>

</xsl:stylesheet>