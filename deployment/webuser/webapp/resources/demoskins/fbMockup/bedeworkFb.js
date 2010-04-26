/*
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
 */
// THE CONTENTS OF THIS FILE WILL MOVE INTO bedeworkAttendees.js


// ========================================================================
// free/busy functions
// ========================================================================

// Constants and RFC-5445 values 
// These should be put some place permanent
var bwAttendeeRoleChair = "CHAIR";
var bwAttendeeRoleRequired = "REQ-PARTICIPANT";
var bwAttendeeRoleOptional = "OPT-PARTICIPANT";
var bwAttendeeRoleNonParticipant = "NON-PARTICIPANT";
var bwAttendeeStatusNeedsAction = "NEEDS-ACTION";
var bwAttendeeStatusAccepted = "ACCEPTED";
var bwAttendeeStatusDeclined = "DECLINED";
var bwAttendeeStatusTentative = "TENTATIVE";
var bwAttendeeStatusDelegated = "DELEGATED";
var bwAttendeeStatusCompleted = "COMPLETED";
var bwAttendeeStatusInProcess = "IN-PROCESS";
var bwAttendeeTypePerson = "person";
var bwAttendeeTypeLocation = "location";
var bwAttendeeTypeResource = "resource";

// display strings for the values above
// should be put with other internationalized strings
// can be translated
var bwAttendeeDispRoleChair = "chair";
var bwAttendeeDispRoleRequired = "required participant";
var bwAttendeeDispRoleOptional = "optional participant";
var bwAttendeeDispRoleNonParticipant = "non-participant";
var bwAttendeeDispStatusNeedsAction = "needs action";
var bwAttendeeDispStatusAccepted = "accepted";
var bwAttendeeDispStatusDeclined = "declined";
var bwAttendeeDispStatusTentative = "tentative";
var bwAttendeeDispStatusDelegated = "delegated";
var bwAttendeeDispStatusCompleted = "completed";
var bwAttendeeDispStatusInProcess = "in-process";
var bwAttendeeDispTypePerson = "person";
var bwAttendeeDispTypeLocation = "location";
var bwAttendeeDispTypeResource = "resource";

/* An attendee
 * name:            String - name of attendee, e.g. "Venerable Bede"
 * uid:             String - attendee's uid with mailto included, e.g. "mailto:vbede@example.com"
 * freebusyStrings: Array of rfc5545 freebusy reply values for the current attendee in the current date range
 * role:            String - Attendee role, e.g. CHAIR, REQ-PARTICIPANT, etc
 * status:          String - participation status (PARTSTAT)
 * type:            String - person, location, other resource
 */
var bwAttendee = function(name, uid, freebusyStrings, role, status, type) {
  this.name = name;
  this.uid = uid;
  this.freebusy = new Array();
  this.role = role;
  this.status = status;
  this.type = type;
  
  //populate the freebusy objects
  for (i = 0; i<freebusyStrings.length; i++) {
    var fb = new bwFreeBusy(freebusyStrings[i]);
    this.freebusy.push(fb);
  }
  
  if (this.type == null || this.type == "") {
    this.type == bwAttendeeTypePerson;
  }
}
/* Freebusy data
 * Provides methods to work on freebusy values
 * fbvals: Array of rfc5545 freebusy values 
 */
var bwFreeBusy = function(fbString) {
  this.name = fbString;  
  
  // set the freebusy start date
  var startDate = new Date();
  startDate.setUTCFullYear(this.name.substring(0,4),this.name.substring(4,6)-1,this.name.substring(6,8));
  startDate.setUTCHours(this.name.substring(9,11),this.name.substring(11,13),this.name.substring(13,15));
  
  // set the start in milliseconds
  this.start = startDate.getTime();

  var endMs; // end in milliseconds
  if (this.name.indexOf("P") > -1) {
    // freebusy value is of the form: 19971015T223000Z/PT6H30M
    // extract the hours and minutes from the strings and cast as numbers  
    var durationHours = this.name.substring(this.name.lastIndexOf("T")+1,this.name.indexOf("H"));
    var durationMins = this.name.substring(this.name.indexOf("H")+1,this.name.indexOf("M"));
    // calculate the duration
    var duration = (Number(durationHours) * 3600000) + (Number(durationMins) * 60000);
    // set start and end in milliseconds 
    endMs = this.start + duration;
  } else { 
    // freebusy value is of the form: 19980314T233000Z/19980315T003000Z
    // set the freebusy end date
    var endDate = new Date();
    endDate.setUTCFullYear(this.name.substring(17,21),this.name.substring(21,23)-1,this.name.substring(23,25));
    endDate.setUTCHours(this.name.substring(26,28),this.name.substring(28,30),this.name.substring(30,32));
    endMs = endDate.getTime();
  }
  
  // set the end in milliseconds
  this.end = endMs;

  
  // example of how to generate a date from the millisecond UTC value  
  // var testDate = new Date(this.fbHash[fbVals[0]].start); //fbVals[0] = a freebusy string
  // alert(testDate.toLocaleString());
    
  /* returns true if date is contained in this freebusy value
   * mils: date/time in milliseconds
   */  
  this.contains = function(mils) {
    if (mils >= this.start && mils < this.end) {
      // should return type of freebusy if available
      return true;
    }
    return false;
  }
}

/* Object to model the freebusy grid
 * displayId:       ID of html block for display output
 * startRange:      js date string - start of date range for grid
 * endRange:        js date string - end of date range for grid
 * startHoursRange: integer, 0-23 - hours of range start time (we'll use all minutes in an hour)
 * endHoursRange:   integer, 0-23 - hours of range end time  (we'll use all minutes in an hour)
 * startDate:       js date string - start date/time for meeting
 * endDate:         date string - end date/time for meeting
 * attendees:       array   - array of attendee objects; MUST include organizer on first instantiation
 * workday:         boolean - true to display workday hours only, false to display all 24 hours
 * zoom:            integer - scalar value for zooming the grid
 */
var bwSchedulingGrid = function(displayId, startRange, endRange, startDate, endDate, startHoursRange, endHoursRange, attendees, workday, zoom) {
  this.displayId = displayId;
  this.startRange = new Date(startRange);
  this.endRange = new Date(endRange);
  this.startHoursRange = startHoursRange;
  this.endHoursRange = endHoursRange; 
  this.startDate = new Date(startDate);
  this.endDate = new Date(endDate);
  this.zoom = zoom;
  this.workday = workday;
  this.attendees = new Array();  // array of bwAttendee objects
  
  // initialize any incoming attendees on first load
  for (i = 0; i < attendees.length; i++) {
    var newAttendee = new bwAttendee(attendees[i].name,attendees[i].uid ,attendees[i].freebusy,attendees[i].role,attendees[i].status,attendees[i].type);
    this.attendees.push(newAttendee); 
  }
    
  // how much will we divide the hour in the grid?
  // this is a constant for now, but could be variable.
  // ALWAYS set as a factor of 60
  this.hourDivision = 4;

  this.addAttendee = function(name, uid, freebusy, role, status, type) {
    var newAttendee = new bwAttendee(name, uid, freebusy, role, status, type);
    this.attendees.push(newAttendee);
    
    this.display();
  }
  
  this.deleteAttendee = function(index) {
    this.attendees.splice(index, 1);
    this.diplay();
  }
  
  this.display = function() {
    try {
      // number of days to display
      var range = dayRange(this.startRange, this.endRange);
      // number of hours to display
      var hourRange = this.endHoursRange - this.startHoursRange;
      var startHour = this.startHoursRange;
      
      if (!workday) {
        // show full 24 hours in grid
        hourRange = 24;
        startHour = 0;
      }
      
      var cellsInDay = hourRange * this.hourDivision;
    
      // build the entire free/busy table
      var fbDisplay = document.createElement("table");
      fbDisplay.id = "bwScheduleTable";
      
      // generate the date row - includes top left empty corner 
      var fbDisplayDateRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayDateRow).html('<td rowspan="2" colspan="3" class="corner"></td><td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.addDays(i);
        $(fbDisplayDateRow).append('<td class="date" colspan="' + cellsInDay + '">' + curDate.getDayName() + ', ' + curDate.getMonthName() + ' ' + curDate.getDate() + ', ' + curDate.getFullYear() + '</td><td class="dayBoundry"></td>');
      }
      
      // generate the times row - each cell spans over the day divisions
      fbDisplayTimesRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayTimesRow).html('<td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          // this is where we could use zoom to increase or decrease tick marks and time labels on the grid
          if (this.zoom == 100) {
            $(fbDisplayTimesRow).append('<td class="hourBoundry" id="' + curDate.getTime() + '-TimeRow" colspan="' + this.hourDivision + '">' + curDate.getHours12() + ':' + curDate.getMinutesFull() + '</td>');
            curDate.addHours(1);
          }
        }
        $(fbDisplayTimesRow).append('<td class="dayBoundry"></td>');
      }
      
      // generate the "All Attendees" row
      fbDisplayTimesRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayTimesRow).addClass("allAttendees");
      $(fbDisplayTimesRow).html('<td class="status"></td><td class="role"></td><td class="name">All Attendees</td><td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            fbCell.id = curDate.getTime() + "-AllAttendees";
            $(fbCell).addClass("fbcell");
              $(fbCell).addClass(curDate.getTime().toString());
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            // set busy if any freebusy in this timeperiod
            loop1: // since we only need to know if anyone is busy, provide a simple means of breaking from the inner loop
            for (att = 0; att < this.attendees.length; att++) {
              for (m = 0; m < this.attendees[att].freebusy.length; m++) {
                var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + tzoffset + (60 / this.hourDivision * 60000);
                if (this.attendees[att].freebusy[m].contains(curDateUTC)) {
                  $(fbCell).addClass("busy");
                  break loop1;
                }
              }
            }
            $(fbDisplayTimesRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayTimesRow).append('<td class="dayBoundry"></td>');
      }
      
      // generate the regular attendees rows
      for (attendee = 0; attendee < this.attendees.length; attendee++) {
        fbDisplayAttendeeRow = fbDisplay.insertRow(fbDisplay.rows.length); 
        var curAttendee = this.attendees[attendee];
        
        // set the status icon and class 
        // the status class is used for rollover descriptions of the icon
        switch (curAttendee.status) {
          case bwAttendeeStatusAccepted : 
            $(fbDisplayAttendeeRow).html('<td class="status accepted"><span class="icon">&#10004;</span><span class="text">' + bwAttendeeDispStatusAccepted + '</span></td>');
            break;
          case bwAttendeeStatusDeclined : 
            $(fbDisplayAttendeeRow).html('<td class="status declined"><span class="icon">x</span><span class="text">' + bwAttendeeDispStatusDeclined + '</span></td>');
            break;
          case bwAttendeeStatusTentative : 
            $(fbDisplayAttendeeRow).html('<td class="status tentative"><span class="icon">-</span><span class="text">' + bwAttendeeDispStatusTentative + '</span></td>');
            break;
          case bwAttendeeStatusDelegated : 
            $(fbDisplayAttendeeRow).html('<td class="status delegated"><span class="icon"></span><span class="text">' + bwAttendeeDispStatusDelegated + '</span></td>');
            break;
          case bwAttendeeStatusCompleted : 
            $(fbDisplayAttendeeRow).html('<td class="status completed"><span class="icon"></span><span class="text">' + bwAttendeeDispStatusCompleted + '</span></td>');
            break;
          case bwAttendeeStatusInProcess : 
            $(fbDisplayAttendeeRow).html('<td class="status inprocess"><span class="icon"></span><span class="text">' + bwAttendeeDispStatusInProcess + '</span></td>');
            break;
          default : // default to bwAttendeeStatusNeedsAction - display question mark
            $(fbDisplayAttendeeRow).html('<td class="status needsaction"><span class="icon">?</span><span class="text">' + bwAttendeeDispStatusNeedsAction + '</span></td>');
        }

        // set the role icon
        // the role class is used for rollover descriptions of the icon
        switch (curAttendee.role) {
          case bwAttendeeRoleChair : // displays writing hand icon
            $(fbDisplayAttendeeRow).append('<td class="role chair"><span class="icon">&#9997;</span><span class="text">' + bwAttendeeDispRoleChair + '</span></td>');
            break;
          case bwAttendeeRoleRequired : // displays right-pointing arrow icon
            $(fbDisplayAttendeeRow).append('<td class="role required"><span class="icon">&#10137;</span><span class="text">' + bwAttendeeDispRoleRequired + '</span></td>');
            break;
          case bwAttendeeRoleNonParticipant : // non-participant
            $(fbDisplayAttendeeRow).append('<td class="role nonparticipant"><span class="icon">x</span><span class="text">' + bwAttendeeDispRoleNonParticipant + '</span></td>');
            break;
          default : // bwAttendeeRoleOptional - no icon (use a space to provide a rollover)
            $(fbDisplayAttendeeRow).append('<td class="role optional"><span class="icon">&#160;</span><span class="text">' + bwAttendeeDispRoleOptional + '</span></td>');
        }
        
        // output the attendee name or address (depending on which we have available)
        if (curAttendee.name && curAttendee.name != "") {
          $(fbDisplayAttendeeRow).append('<td class="name">' + curAttendee.name + '</td><td class="fbBoundry"></td>');
        } else {
          $(fbDisplayAttendeeRow).append('<td class="name">' + curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":")+1) + '</td><td class="fbBoundry"></td>');
        }
        
        // build the time row for an attendee
        for (i = 0; i < range; i++) {
          var curDate = new Date(this.startRange);
          curDate.setHours(startHour);
          curDate.addDays(i);
          // add the time cells by iterating over the hours
          for (j = 0; j < hourRange; j++) {
            for (k = 0; k < this.hourDivision; k++) {
              var fbCell = document.createElement("td");
              fbCell.id = curDate.getTime() + "-" + curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":")+1);
              $(fbCell).addClass("fbcell");
              $(fbCell).addClass(curDate.getTime().toString());
              if (curDate.getMinutes() == 0 && j != 0) {
                $(fbCell).addClass("hourBoundry");
              } 
              for (m = 0; m < curAttendee.freebusy.length; m++) {
                var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + tzoffset + (60 / this.hourDivision * 60000);                
                if (curAttendee.freebusy[m].contains(curDateUTC)) {
                  $(fbCell).addClass("busy");
                  break;
                }
              }
              $(fbDisplayAttendeeRow).append(fbCell);
              curDate.addMinutes(60/this.hourDivision);
            }
          }
          $(fbDisplayAttendeeRow).append('<td class="dayBoundry"></td>');
        }
      }
      
      // generate the "add attendee" row
      fbDisplayAddAttendeeRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayAddAttendeeRow).html('<td class="status"></td><td class="role"></td><td class="name" id="addAttendee">add attendee...</td><td class="fbBoundry"></td>');
      for (i = 0; i < range; i++) {
        var curDate = new Date(this.startRange);
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            fbCell.id = curDate.getTime() + "-" + curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":")+1);
            $(fbCell).addClass("fbcell");
            $(fbCell).addClass(curDate.getTime().toString());
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            $(fbDisplayAddAttendeeRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayAddAttendeeRow).append('<td class="dayBoundry"></td>');
      }
      
      // generate a blank row at the end (this is just for visual padding)
      fbDisplayBlankRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayBlankRow).html('<td class="status"></td><td class="role"></td><td class="name"></td><td class="fbBoundry"></td>');
      for (i = 0; i < range; i++) {
        var curDate = new Date(this.startRange);
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            fbCell.id = curDate.getTime() + "-" + curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":")+1);
            $(fbCell).addClass("fbcell");
            $(fbCell).addClass(curDate.getTime().toString());
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            $(fbDisplayBlankRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayBlankRow).append('<td class="dayBoundry"></td>');
      }
      
      
      // write the table back to the display
      $("#" + displayId).html(fbDisplay);
      
      
      // now add some rollovers and onclick actions 
      // to the elements of the freebusy grid
      $("#bwScheduleTable .icon").hover(
        function () {
          $(this).next(".text").fadeIn(100);
        }, 
        function () {
          $(this).next(".text").fadeOut(100);
        }
      );  
      
      $("#bwScheduleTable .fbcell").click (
        function () {
          var curClass = $(this).attr("class");
          alert(curClass);
          $("#bwScheduleTable ." + curClass).addClass("highlight");
          alert($(this).attr("class"));
        }
      );
      
    } catch (e) {
      alert(e);
    }
    
  }
}



var dayRange = function(startDate, endDate) {  
  // find difference in milliseconds and return number of days.
  // 86400000 is the number of milliseconds in a day;
  return Math.round((Math.abs(startDate.getTime() - endDate.getTime())) / 86400000)
}

// DATE PROTOTYPE OVERRIDES - should be pulled into a library
// the following need to call internationalized strings - from a localeSettings file
Date.prototype.getMonthName = function() {
  var m = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  return m[this.getMonth()];
}
Date.prototype.getDayName = function() {
  var d = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  return d[this.getDay()];
} 
Date.prototype.addDays = function(days) {
  this.setDate(this.getDate() + days);
} 
Date.prototype.addHours = function(hours) {
  this.setHours(this.getHours() + hours);
}
Date.prototype.addMinutes = function(minutes) {
  this.setMinutes(this.getMinutes() + minutes);
}
// return a twelve-hour hour
Date.prototype.getHours12 = function() {
  var hours12 = this.getHours();
  if (hours12 > 12) {
    hours12 = hours12 - 12;
  } 
  return hours12;
}
// prepend minutes with zero if needed
Date.prototype.getMinutesFull = function() {
  var minutesFull = this.getMinutes();
  if (minutesFull < 10) {
    return "0" + minutesFull;
  }  
  return hours12;
}

/*
 * From RFC 5545
 * The following is an example of a "VFREEBUSY" calendar component
 used to reply to the request with busy time information:
 
 BEGIN:VFREEBUSY
 UID:19970901T095957Z-76A912@example.com
 ORGANIZER:mailto:jane_doe@example.com
 ATTENDEE:mailto:john_public@example.com
 DTSTAMP:19970901T100000Z
 FREEBUSY:19971015T050000Z/PT8H30M,
 19971015T160000Z/PT5H30M,19971015T223000Z/PT6H30M
 URL:http://example.com/pub/busy/jpublic-01.ifb
 COMMENT:This iCalendar file contains busy time information for
 the next three months.
 END:VFREEBUSY

 The following is an example of a "VFREEBUSY" calendar component
 used to publish busy time information:

 BEGIN:VFREEBUSY
 UID:19970901T115957Z-76A912@example.com
 DTSTAMP:19970901T120000Z
 ORGANIZER:jsmith@example.com
 DTSTART:19980313T141711Z
 DTEND:19980410T141711Z
 FREEBUSY:19980314T233000Z/19980315T003000Z
 FREEBUSY:19980316T153000Z/19980316T163000Z
 FREEBUSY:19980318T030000Z/19980318T040000Z
 URL:http://www.example.com/calendar/busytime/jsmith.ifb
 END:VFREEBUSY
 *
 */
