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

/* An attendee
 * name:     String - name of attendee, e.g. "Venerable Bede"
 * uid:      String - attendee's uid with mailto included, e.g. "mailto:vbede@example.com"
 * freebusy: Array of rfc5545 freebusy reply values for the current attendee in the current date range
 * role:     String - Attendee role, e.g. CHAIR, REQ-PARTICIPANT, etc
 * status:   String - participation status (PARTSTAT)
 */
var bwAttendee = function(name, uid, freebusy, role, status) {
  this.name = name;
  this.uid = uid;
  this.freebusy = freebusy;
  this.role = role;
  this.status = status;
}

/* Object to model the freebusy grid
 * displayId:  ID of html block for display output
 * startRange: js date string - start of date range for grid
 * endRange:   js date string - end of date range for grid
 * startDate:  js date string - start date/time for meeting
 * endDate:    date string - end date/time for meeting
 * attendees:  array   - array of attendee objects; MUST include organizer on first instantiation
 * workday:    boolean - true to display workday hours only, false to display all 24 hours
 * zoom:       integer - scalar value for zooming the grid
 */
var bwFreeBusy = function(displayId, startRange, endRange, startDate, endDate, attendees, workday, zoom) {
  this.displayId = displayId;
  this.startRange = new Date(startRange);
  this.endRange = new Date(endRange);
  this.startDate = new Date(startDate);
  this.endDate = new Date(endDate);
  this.zoom = zoom;
  this.workday = workday;
  this.attendees = attendees;
  
  this.addAttendee = function(name, uid, freebusy, role, status) {
    var newAttendee = new bwAttendee(name, uid, freebusy, role, status);
    attendees.push(newAttendee);
    
    this.display();
  }
  
  this.deleteAttendee = function(index) {
    attendees.splice(index, 1);
    this.diplay();
  }
  
  this.display = function() {
    try {
      // number of days in the range
      var range = dayRange(this.startRange, this.endRange);
      alert(range);
      
    
      // build the entire free/busy table first
      var fbDisplay = document.createElement("table");
      fbDisplay.id = "bwScheduleTable";
      
      // generate the date row
      fbDisplayDateRow = fbDisplay.insertRow(0);
      
      
      var td1 = document.createElement("td");
      var txt1 = document.createTextNode(this.startRange.getDay());
      var td2 = document.createElement("td");
      var txt2 = document.createTextNode(this.startRange.getDay() + 1);
      var td3 = document.createElement("td");
      var txt3 = document.createTextNode(this.startRange.getDay() + 2);
      td1.appendChild(txt1);
      td2.appendChild(txt2);
      td3.appendChild(txt3);
      fbDisplayDateRow.appendChild(td1);
      fbDisplayDateRow.appendChild(td2);
      fbDisplayDateRow.appendChild(td3);
      
      
      // finally, write the table back to the display
      $("#" + displayId).html(fbDisplay);
      
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



/*



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



