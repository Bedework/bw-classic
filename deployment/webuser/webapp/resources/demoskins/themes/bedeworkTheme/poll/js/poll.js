/**
 ##
 # Copyright (c) 2013-2014 Apple Inc. All rights reserved.
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 # http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 ##
 */

// An editable poll. It manipulates the DOM for editing a poll
Poll = function(resource) {
  this.resource = resource;
  this.owned = this.resource.object.mainComponent().isOwned();
  this.editing_object = null;
  this.editing_poll = null;
}

Poll.prototype.title = function() {
  return this.editing_poll ? this.editing_poll.summary() : this.resource.object.mainComponent().summary();
}

Poll.prototype.closed = function() {
  this.editing_poll = null;
}

// Save the editable state
Poll.prototype.saveResource = function(whenDone) {
  // Only if it changed
  if (this.editing_poll.changed()) {
    this.resource.object = this.editing_object;
    var this_poll = this;
    this.resource.saveResource(function() {
      // Reload from the resource as it might change after write to server
      this_poll.editing_object = this_poll.resource.object.duplicate();
      this_poll.editing_poll = this_poll.editing_object.mainComponent();

      if (whenDone) {
        whenDone();
      }
    });
  }
};

// Fill the UI with details of the poll
Poll.prototype.setPanel = function() {

  this.editing_object = this.resource.object.duplicate();
  this.editing_poll = this.editing_object.mainComponent();

  this.writeVpollValues();
};

/** Save the given choice in the current vpoll
 *
 * @param comp - jcal object
 */
Poll.prototype.saveChoice = function(comp) {
  this.editing_poll.saveChoice(comp);
};

// Fill the UI with details of the poll
Poll.prototype.writeVpollValues = function() {
  var this_poll = this;

  // Setup the details panel with this poll
  $("#editpoll-title-edit").val(this.editing_poll.summary());
  $("#editpoll-title").text(this.editing_poll.summary());
  $("#editpoll-organizer").text(this.editing_poll.organizerDisplayName());
  $("#editpoll-status").text(this.editing_poll.status());
  $("#editpoll-choicelist").empty();
  $.each(this.editing_poll.choices(), function(index, choice) {
    this_poll.addChoicePanel(choice);
    //$("#debug").append(print_r(choice) + '<div style="margin: 4em 0;">new choice</div>');
  });
  $("#bwComp-voterlist").empty();
  $.each(this.editing_poll.voters(), function(index, voter) {
    this_poll.setVoterPanel(this_poll.addParticipantPanel(false, "voter", "Voter"), voter);
  });
};

// Get poll details from the UI
Poll.prototype.getVpollValues = function() {
  var this_poll = this;

  // Get values from the details panel
  if (this.owned) {
    this.editing_poll.summary($("#editpoll-title-edit").val());

    //var events = this.editing_poll.choices();
    //$("#editpoll-choicelist").children().each(function(index) {
    //  this_poll.updateEventFromPanel($(this), events[index]);
    //});

  }
};

/** Get voter details from the UI
 *
 */
Poll.prototype.updateVoters = function() {
  if (!this.owned) {
    return;
  }

  var this_poll = this;
  var voters = this.editing_poll.voters();

  $("#bwComp-voterlist").children().each(function(index) {
    var voter = voters[index];
    var radioName = "voterType" + (index + 1);
    var cutype = $("input:radio[name=" + radioName + "]:checked").val();

    this_poll.updateVoterFromPanel($(this), voter, cutype);
  });


  if ($("#syncPollAttendees").is(":checked")) {
    this.editing_poll.syncAttendees();
  }
};

//Add a new event item in the UI
Poll.prototype.addChoicePanel = function(choice) {

  var chc = '<div class="bwChoiceDisplay">';
  chc += '<div class="bwChoiceButtons">';
  chc += '<div class="bwChoiceType">event</div>'; // XXX replace with actual type (e.g. event, task, location)
  chc += '<button id="choice-edit-' + choice.data.getPropertyValue("uid") + '" class="choice-edit">Edit</button>';
  chc += '<button id="choice-delete-' + choice.data.getPropertyValue("uid") + '" class="choice-delete">Delete</button>';
  chc += '</div>';
  chc += '<div class="bwChoiceSummary">' + choice.data.getPropertyValue("summary") + '</div>';

  var rinfo = getRecurrenceInfo(choice);

  if (rinfo !== null) {
    chc += '<div class="bwChoiceRecur">' + rinfo + '</div>';
  }

  chc += '<div class="bwChoiceContent">';
  chc += '<div class="bwChoiceDates">';
  chc += choice.start().getLocalizedDate() + ' ';
  chc += choice.start().getPrintableTime() + ' - ';
  if (!choice.start().dateEquals(choice.end())) {
    chc += choice.end().getLocalizedDate() + ' ';
  }
  chc += choice.end().getPrintableTime();
  chc += '</div>';
  if (choice.data.getPropertyValue("description") != null && choice.data.getPropertyValue("description") != "") {
    chc += '<div class="bwChoiceDesc">' + choice.data.getPropertyValue("description") + '</div>';
  }
  chc += '</div></div>';
  chc = $(chc).appendTo("#editpoll-choicelist");
  $("#editpoll-choicelist .choice-edit").button({
    icons : {
      primary : "ui-icon-pencil",
      text: false
    }
  }).click(function() {
    view.clickChoiceEdit();
  });
  $("#editpoll-choicelist .choice-delete").button({
    icons : {
      primary : "ui-icon-trash",
      text: false
    }
  }).click(function() {
    view.clickChoiceDelete();
  });

  return chc;
};

// Update the UI for this event
// XXX Deprecated?
Poll.prototype.setChoicePanel = function(panel, event) {

  return panel;
};

// Get details of the event from the UI
Poll.prototype.updateEventFromPanel = function(panel, event) {
  event.summary($("#editpoll-title-edit").val());
};

// Add choice button clicked
Poll.prototype.addChoice = function() {
  var choiceType = $("input:radio[name=choiceType]:checked").val();
  this.getVpollValues();

  var choices = this.editing_poll.choices();

  if (choices.length === 0) {
    // Manufacture a new one

    var start = JcalDtTime.now(hour24, "start");
    start.addHours(1);

    var end = JcalDtTime.now(hour24, "end");
    end.addHours(2);

    // Add new list item
    currentEntity = this.editing_poll.makeChoice(choiceType, start, end);
  } else {
    // Clone one from the last one created.
    var prevEntity = choices[choices.length - 1];
    currentEntity = prevEntity.duplicate();

    start = currentEntity.start();
    start.addDays(1);
    start.updateProperty(currentEntity.data);

    end = currentEntity.end();
    if (end.fieldType !== "duration") {
      end.addDays(1);
    }
    end.updateProperty(currentEntity.data, start);
    currentEntity.data.updateProperty("poll-item-id", this.editing_poll.nextPollItemId().toString());
  }

  $.magnificPopup.open({
    items: {
      src: "#choice-widget"
    },
    type:'inline',
    fixedBgPos: true,
    midClick: true,
    focus: "#bwEventTitle",
    callbacks: {
      beforeOpen: this.populateChoiceForm(currentEntity)
    }
  }, 0);

  return true; // this.setEventPanel(this.addChoicePanel(), currentEntity);
};

//Add a new choice item in the UI
Poll.prototype.populateChoiceForm = function(choice) {
  $("#choice-widget #bwEventTitle").val(choice.data.getPropertyValue("summary"));

  var dtSt = choice.start();
  var hour = 0;
  var hour24Opts = "";
  var locNames = locations.getDisplayNames();
  var thisPoll = this;

  $("#choice-widget #bwEventWidgetStartDate").val(dtSt.getDatePart());

  if(dtSt.allDay) {
    $("#allDayFlag").click();
  } else {
    $("#storeUTCFlag").attr('checked', dtSt.UTC);
    if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
      $("#choice-widget #eventStartDateAmpm").hide();
      // generate the 24 hour options
      for (i=0; i<24; i++) {
        hour24Opts += '<option value="' + i + '">' + i + '</option>';
      }
      $("#choice-widget #eventStartDateHour").empty();
      $("#choice-widget #eventStartDateHour").html(hour24Opts);
      $('#eventStartDateHour option[value="' + dtSt.hours() + '"]').prop('selected',true);
    } else {
      if(!dtSt.am()) {
        $("#choice-widget #eventStartDateAmpm").prop("selectedIndex", 1);
      }
    }

    $("#choice-widget #eventStartDateHour").val(dtSt.hoursAmPm24());
//    $("#choice-widget #eventStartDateMinute").val(dtSt.minutes());
    $('#eventStartDateMinute option[value="' + dtSt.minutes() + '"]').prop('selected',true);

    if (dtSt.tzid !== undefined) {
      // Set the tzid from dtSt.tzid
    }
  }

  var dur = choice.data.getPropertyValue("duration");

  if (dur != null) {
    // Flag it as end type duration
    $("input[name=eventEndType][value=D]").click();

    var jdur = new Jcalduration();

    jdur.parse(dur);

    if (jdur.mWeeks != 0) {
      $("#choice-widget #durationTypeWeeks").attr('checked', 'checked');
      $("#choice-widget #durationWeeks").val(jdur.mWeeks);
    } else {
      $("#choice-widget #durationTypeDayTime").attr('checked', 'checked');
      $("#choice-widget #durationDays").val(jdur.mDays);

      // Should hide hours/minutes for all day
      $("#choice-widget #durationHours").val(jdur.mHours);
      $("#choice-widget #durationMinutes").val(jdur.mMinutes);
    }
  } else {
    $("input[name=eventEndType][value=E]").click();

    var dtE = choice.end();

    $("#choice-widget #bwEventWidgetEndDate").val(dtE.getDtval());

    if (!dtSt.allDay) {
      if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
        $("#choice-widget #eventEndDateAmpm").hide();
        $("#choice-widget #eventEndDateHour").empty();
        $("#choice-widget #eventEndDateHour").html(hour24Opts);
      } else {
        if(!dtE.am) {
          $("#choice-widget #eventEndDateAmpm").prop("selectedIndex", 1);
        }
      }
      $("#choice-widget #eventEndDateHour").val(dtE.hoursAmPm24());
      $("#choice-widget #eventEndDateMinute").val(dtE.minutes());

      if (dtE.tzid !== undefined) {
        // Set the tzid from dtE.tzid
      }
    }
  }

  // setup the location data
  var locationOptions = "";
  for (i = 0; i < locNames.length; i++) {
    locationOptions = '<option value="' + i + '">' + locNames[i] + '</options>';
  }

  $("#eventFormLocationList select").append(locationOptions);

  var rinfo = getRecurrenceInfo(choice);

  if (rinfo === null) {
    // Not recurring
    $("#isNotRecurring").click();
  } else {
    $("#recurrenceInfo").text(rinfo);
    this.addFormRecurrenceInfo(choice);
    $("#isRecurring").click();
  }

  $("#bwComp-attendeelist").empty();
  $.each(choice.attendees(), function(index, attendee) {
    thisPoll.setAttendeePanel(thisPoll.addParticipantPanel(true, "attendee", "Attendee"), attendee);
  });
};

/** Add any recurrence info to the form.
 *
 * @param choice
 */
Poll.prototype.addFormRecurrenceInfo = function(choice) {
  // First set to the default state
  $("#freqNONE").click();
  $("#recurCount").click();
  $("#recurCountVal").val(1);
  $("#recurInterval").val(1);
  $('#recurAdvanced').checked = false;

  if (choice.data.getProperty("recurrence-id") !== null) {
    // An instance
    return false;
  }

  var rrules = choice.rrules(); // Array - we only handle 1
  var rdates = choice.rdates();

  if ((rrules.length === 0) && (rdates.length === 0)) {
    // not recurring
    return false;
  }

  var rrule;

  if (rrules[0] instanceof Array) {
    // Multiple rrules - not supported - do the first
    rrule = rrules[0][3];  // value part
  } else {
    rrule = rrules[3];  // value part
  }

  /* Set the frequency */
  var freq = rrule["freq"];
  if (freq === undefined) {
    // Invalid - freq is required.
    return false;
  }

  $("#isRecurring").click();
  $("#freq" + freq).click();

  // until or count or neither
  var until = rrule["until"];
  var count = rrule["count"];

  if (until !== undefined) {
    $("#bwEventWidgetUntilDate").val(until);
    $("#recurUntil").click();
  } else if (count !== undefined) {
    $("#recurCount").click();
    $("#recurCountVal").val(count);
  } else {
    $("#recurForever").click();
  }

  var interval = rrule["interval"];

  var advanced = false;

  if (interval !== undefined) {
    if (interval != 1) {
      advanced = true;
    }

    $("#recurInterval").val(interval);
  }

  var bymonth = rrule["bymonth"];
  if (bymonth !== undefined) {
    asArray(bymonth).forEach(function setByMonth(val) { $("#byMonthItem" + val).click();});
    advanced = true;
  }

  var byday = rrule["byday"];
  if (byday !== undefined) {
    advanced = true;
    byday = asArray(byday);
    for (var i = 0; i < byday.length; i++) {
      // [+/-[n]]day-name
      // SU MO TU etc
      var bydayval = byday[i];
      var dayname;
      var pos = 1;
      if (bydayval.length > 2) {
        dayname = bydayval.substr(-2);
        pos = parseInt(bydayval.substr(0, -2));
      } else {
        dayname = bydayval;
      }

      $('[name=byDayPos' + i + ']').val(pos);
      $('#byDayRecurFields' + (i + 1) + ' [value=' + bydayval + ']').checked = true;
    }
  }

  var wkst = rrule["wkst"];
  if (wkst !== undefined) {
    advanced = true;
    $('#recurWkst option[value="' + wkst + '"]').prop('selected',true);
  }

  var bymonth = rrule["bymonth"];
  if (bymonth !== undefined) {
    advanced = true;
    bymonth = asArray(bymonth);
    for (var i = 0; i < bymonth.length; i++) {
      // 1-12
      var bymonthval = bymonth[i];

      $('#byMonthItem' + bymonthval).checked = true;
    }
  }

  var bymonthday = rrule["bymonthday"];
  if (bymonthday !== undefined) {
    advanced = true;
    bymonthday = asArray(bymonthday);
    for (var i = 0; i < bymonthday.length; i++) {
      // +/-1-31
      var bymonthdayval = bymonthday[i];

      $('#byMonthItem' + bymonthval).checked = true;
    }
  }

  if (advanced) {
    $('#recurAdvanced').checked = true;
  }

  return true;
};

// Update UI for this attendee
Poll.prototype.setAttendeePanel = function(panel, attendee) {
  panel.find(".attendee-address").val(attendee.addressDescription());
  return panel;
};


/** The reverse of populateChoiceForm - takes values from the form and
 * puts them into the given choice
 *
 * @param choice
 */
Poll.prototype.populateChoice = function(choice) {
  choice.data.updateProperty("summary", $("#choice-widget #bwEventTitle").val());
  choice.data.updateProperty("description", $("#choice-widget #description").val());

  var datePart = $("#choice-widget #bwEventWidgetStartDate").val();
  var allDay = $("#allDayFlag").is(":checked");
  var UTC = $("#storeUTCFlag").is(":checked");
  var hours = $("#choice-widget #eventStartDateHour").val();
  var minutes = $("#choice-widget #eventStartDateMinute").val();

  var am = false;
  if (!hour24) {
    am = $("#eventStartDateAmpm").attr("selectedIndex") == 0;
  }

  // Set the tzid from the form if one is selected
  var tzid = defaultTzid;

  choice.start().update(datePart, allDay, UTC, tzid, hours, minutes, am);
  choice.start().updateProperty(choice.data);

  var endType = $("input:radio[name=eventEndType]:checked").val();
  if (endType === "D") {
    // Duration type

    var dur = {};

    var durType = $("input:radio[name=eventDurationType]:checked").val();

    if (durType === "weeks") {
      dur.weeks = parseInt($("#choice-widget #durationWeeks").val());
    } else {
      dur.days = parseInt($("#choice-widget #durationDays").val());

      if (!choice.start().allDay) {
        dur.hours = parseInt($("#choice-widget #durationHours").val());
        dur.minutes = parseInt($("#choice-widget #durationMinutes").val());
      }
    }

    choice.end().updateFromDuration(moment.duration(dur), choice.start());
  } else {
    // Dtend type

    datePart = $("#choice-widget #bwEventWidgetEndDate").val();
    UTC = choice.start().UTC;
    hours = $("#choice-widget #eventEndDateHour").val();
    minutes = $("#choice-widget #eventEndDateMinute").val();

    am = false;
    if (!hour24) {
      am = $("#eventEndDateAmpm").attr("selectedIndex") == 0;
    }

    // Set the tzid from the form if one is selected
    tzid = defaultTzid;

    choice.end().update(datePart, allDay, UTC, tzid, hours, minutes, am);
  }

  choice.end().updateProperty(choice.data, choice.start());

  var rrule = this.populateRRule();

  if (rrule !== null) {
    choice.data.updateProperty("rrule", rrule, {}, "recur");
  }
};

Poll.prototype.populateRRule = function() {
  if (!$("#isRecurring").is(":checked")) {
    return null;
  }

  /* Set the frequency */
  var f1 = $('input:radio[name="recurFreq"]');

  var freq = $('input:radio[name="recurFreq"]:checked').val();

  if (freq === "NONE") {
    return null;
  }

  var rrule = {};

  rrule['freq'] = freq;

  // until or count or neither
  if ($("#recurUntil").is(":checked")) {
    rrule['until'] = $("#bwEventWidgetUntilDate").val();
  } else if ($("#recurCount").is(":checked")) {
    rrule['count'] = parseInt($("#recurCountVal").val());
  }

  if (!$("#recurAdvanced").is(":checked")) {
    return rrule;
  }

  var interval = parseInt($("#recurInterval").val());

  if (interval !== 1) {
    rrule['interval'] = interval;
  }

  if (!$("#byMonthEnabled").is(":checked")) {
    var byMonthVals = $("[name=byMonthItem] :checked");
  }

  var byDayI = 1;

  while (true) {
    var byDayPosField = $('#byDayPos' + byDayI);

    if (byDayPosField.length === 0) {
      break;
    }

    var byDayPos = byDayPosField.val();

    if (byDayPos == 0) {
      break;
    }


    byDayI++;
  }

  var wkst = rrule["wkst"];
  if (wkst !== undefined) {
  }

  return rrule;
};

// 1. iterate over the form elements, update the current entity
/*
 I'm guessing we can get rid of some of the complication around
 the date check boxes. e.g for the "floatingFlag" checkbox we have
 associated hidden fields "eventStartDate.dateOnly",
 "eventEndDate.dateOnly". These can go - they feed the action
 when we return all the values as form elements.

 Also - shouldn't those 3 flags be radio - not checkboxes

 How do we get/set allDayFlag? Just get/set the checkbox?
 $('input[name=allDayFlag]').attr('checked')
 $('input[name=allDayFlag]').attr('checked', true);

 Note: there are no flags in the actual data. Setting the json object
 can just be a matter of updating the date value.

 Setting form values means inspecting the data

 All day - no time part to the value
 Floating - time has no ending "Z" but no timezone specified
 UTC - time ends with "Z"
 Local - no ending "Z" and timezone specified

 How do we get/set floatingFlag?
 $('input[name=floatingFlag]').attr('checked')
 $('input[name=floatingFlag]').attr('checked', true);

 How do we get/set storeUTCFlag?
 $('input[name=storeUTCFlag]').attr('checked')
 $('input[name=storeUTCFlag]').attr('checked', true);

 id=bwEventWidgetStartDate - start date?
 id=eventStartDateHour
 id=eventStartDateMinute
 id=eventStartDateAmpm

 start tzid - appears to require selecting choice

 Fields eventStartDate.xxx are part of the event mod action
 Not needed for this - really only need the sart date as a text field.

 id=bwEventWidgetEndDate
 id=eventEndDateHour
 id=eventEndDateMinute
 id=eventEndDateAmpm

 id=end tzid - appears to require selecting choice

 eventEndTypeDuration  duration checkbox
 id=durationDays
 id=durationHours
 id=durationMinutes

 id=durationWeeks

 id=eventEndTypeNone

 location appears to have no id

 link - ditto

 id=description

 status - no id

 transparency - no id

 categories - no id - how do we multiselect?

 recurring - no id?

 recurring fields - lne 815 - no id?

 many more recurring issues - later...
 */

/** Add a new voter or attendee item in the UI
 *
 * @param readOnly true if this is for display only
 * @param itemType "attendee" or "voter"
 * @param itemLabel currently "Attendee" or "Voter"
 * @returns {string}
 */
Poll.prototype.addParticipantPanel = function(readOnly, itemType, itemLabel) {
  var ctr = $("#bwComp-" + itemType + "list").children().length + 1;
  var iditem = itemType + "-address-" + ctr;
  var iditemTypePrefix = itemType + "-" + ctr;
  var idRemove = itemType + "-remove-" + ctr;
  var idDiv = itemType + "-div-" + ctr;
  var radioName = itemType + "Type" + ctr;

  // Add new list item
  var idiv = '<div class="' + itemType + '" id="' + idDiv + '">';
  idiv += '<div class="edit-' + itemType + '">';
  idiv += '<label for="' + iditem + '">' + itemLabel + ': </label>';
  idiv += '<input type="text" id="' + iditem + '" class="' + itemType + '-address"/>';
  idiv += '<span id="edit-' + itemType + 'type">';
  idiv += '<input type="radio" id="' + iditemTypePrefix +
      '-typeUser" name="' + radioName + '" value="INDIVIDUAL" checked/>';
  idiv += '<label for="' + iditemTypePrefix + '-typeUser">user</label>';
  idiv += '<input type="radio" id="' + iditemTypePrefix +
      '-typeGroup" name="' + radioName + '" value="GROUP"/>';
  idiv += '<label for="' + iditemTypePrefix + '-typeGroup">group</label>';
  idiv += '<input type="radio" id="' + iditemTypePrefix +
      '-typeLocation" name="' + radioName + '" value="ROOM"/>';
  idiv += '<label for="' + iditemTypePrefix + '-typeLocation">location</label>';
  /* Not yet
  idiv += '<input type="radio" id="' + iditemTypePrefix +
      '-typeAny" name="' + radioName + '" value="ANY"/>';
  idiv += '<label for="' + iditemTypePrefix + '-typeAny">Any</label>';
  */
  idiv += '</span>';
  idiv += '</div>';
  idiv += '<button class="input-remove" id="' + idRemove + '">Remove</button>';
  idiv += '</div>';
  idiv = $(idiv).appendTo("#bwComp-" + itemType + "list");

  var this_poll = this;

  var addrField = idiv.find("." + itemType + "-address");
  addrField.hover(
      function() {
        this_poll.hoverCuaddrDialogOpen(addrField);
      },
      this_poll.hoverCuaddrDialogClose
  );

  addrField.autocomplete({
    minLength : 3,
    extraParams: {
      cutype : function() {
        return  $("input:radio[name=" + radioName + "]:checked").val();
      }
    },
    source : function(request, response) {
      var cutype = this.options.extraParams.cutype();
      if (cutype === "ANY") {
        cutype = null;
      }
      gSession.calendarUserSearch(request.term, cutype, function(results) {
        response(results);
      });
    }
  }).focus(function() {
    $(this).select();
  });

  idiv.find(".input-remove").button({
    icons : {
      primary : "ui-icon-trash",
      text: false
    }
  }).click(function() {
    //alert("remove particpant " + ctr);
    this_poll.removeParticipant(itemType, ctr - 1, idDiv)
  });

  return idiv;
};

// Update UI for this voter
Poll.prototype.setVoterPanel = function(panel, voter) {
  panel.find(".voter-address").val(voter.addressDescription());
  return panel;
};

// Get details of the voter from the UI
Poll.prototype.updateVoterFromPanel = function(panel, voter, cutype) {
  voter.addressDescription(panel.find(".voter-address").val());
  voter.cutype(cutype)
};

// Add voter button clicked
Poll.prototype.addVoter = function() {
  // Add new list item
  poll_syncAttendees = $("#syncPollAttendees").is(":checked");

  var voter = this.editing_poll.addVoter();
  return this.setVoterPanel(this.addParticipantPanel(false, "voter", "Voter"), voter);
};

// Remove participant button clicked
Poll.prototype.removeParticipant = function(itemType, index, idDiv) {
  if (itemType !== "voter") {
    alert("Remove attendee not implemented");
    return;
  }

  $("#" + idDiv).remove();

  poll_syncAttendees = $("#syncPollAttendees").is(":checked");

  this.editing_poll.removeVoter(index);
}


// Build the results UI based on the poll details
Poll.prototype.buildResults = function() {

  var this_poll = this;

  // Sync with any changes from other panels
  this.getVpollValues();

  var event_details = this.editing_poll.choices();
  var voter_details = this.editing_poll.voters();

  var thead = $("#editpoll-resulttable").children("thead").first();
  var th_summary = thead.children("tr").eq(0).empty();
  var th_start = thead.children("tr").eq(1).empty();
  var th_end = thead.children("tr").eq(2).empty();
  var th_recur = thead.children("tr").eq(3).empty().addClass("invisible");
  var th_desc = thead.children("tr").eq(4).empty();
  var tf = $("#editpoll-resulttable").children("tfoot").first();
  var tf_overall = tf.children("tr").first().empty();
  var tf_commit = tf.children("tr").last().empty();
  tf_commit.toggle(this.owned || !this_poll.editing_poll.editable());
  var tbody = $("#editpoll-resulttable").children("tbody").first().empty();
  $('<td>Summary:</td>').appendTo(th_summary);
  $('<td>Start:</td>').appendTo(th_start);
  $('<td>End:</td>').appendTo(th_end);
  $('<td>Recurs:</td>').appendTo(th_recur);
  $('<td>Description:</td>').appendTo(th_desc);
  $('<td>Overall (all voters):</td>').appendTo(tf_overall);
  $('<td />').appendTo(tf_commit);
  $.each(event_details, function(index, event) {
    //$("#debug").append(print_r(event));
    var td_summary = $('<td />').appendTo(th_summary).text(event.summary()).addClass("summary-td");;
    var td_start = $('<td />').appendTo(th_start).html(event.start().getLocalizedDate() + ' - ' + event.start().getPrintableTime()).addClass("start-td");
    var endDate = "";
    if (!event.start().dateEquals(event.end())) {
      endDate = event.end().getLocalizedDate() + ' - ';
    }
    var td_end = $('<td />').appendTo(th_end).html(endDate + event.end().getPrintableTime());

    var rinfo = getRecurrenceInfo(event);

    if (rinfo !== null) {
      th_recur.removeClass("invisible");
      var td_recur = $('<td />').appendTo(th_recur).text(rinfo).addClass("recur-td");
    } else {
      var td_recur = $('<td />').appendTo(th_recur).text(i18nStrings["bwStr-AEEF-No"]).addClass("recur-td");
    }

    var td_desc = $('<td />').appendTo(th_desc).text(event.description()).addClass("desc-td");
    $('<td />').appendTo(tf_overall).addClass("center-td");
    $('<td />').appendTo(tf_commit).addClass("center-td");
    if (event.ispollwinner()) {
      td_summary.addClass("poll-winner-td");
      td_start.addClass("poll-winner-td");
      td_end.addClass("poll-winner-td");
    }
    td_summary.hover(
        function() {
          this_poll.hoverCalDialogOpen(td_summary, thead, event);
        },
        this_poll.hoverCalDialogClose
    );
  });
  $.each(voter_details, function(index, voter) {
    var active = gSession.currentPrincipal.matchingAddress(voter.cuaddr());
    var tr = $("<tr/>").appendTo(tbody);
    $("<td/>").appendTo(tr).text(voter.nameOrAddress());
    $.each(event_details, function(index, event) {
      var response = event.voter_responses()[voter.cuaddr()];
      var pollItemId = event.pollitemid();
      var td = $("<td />").appendTo(tr).addClass("center-td");
      if (event.ispollwinner()) {
        td.addClass("poll-winner-td");
      }
      if (active && this_poll.editing_poll.editable()) {
        var radios = $('<div id="response-' + pollItemId + '" />').appendTo(td).addClass("response-btns");
        $('<input type="radio" id="respond_no-' + pollItemId + '" name="response-' + pollItemId + '"/>').appendTo(radios);
        $('<label for="respond_no-' + pollItemId + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_maybe-' + pollItemId + '" name="response-' + pollItemId + '"/>').appendTo(radios);
        $('<label for="respond_maybe-' + pollItemId + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_ok-' + pollItemId + '" name="response-' + pollItemId + '"/>').appendTo(radios);
        $('<label for="respond_ok-' + pollItemId + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_best-' + pollItemId + '" name="response-' + pollItemId + '"/>').appendTo(radios);
        $('<label for="respond_best-' + pollItemId + '"/>').appendTo(radios);
        radios.buttonset();
        if (response !== undefined) {
          if (response < 40) {
            $('#respond_no-' + pollItemId).click();
          } else if (response < 80) {
            $('#respond_maybe-' + pollItemId).click();
          } else if (response < 90) {
            $('#respond_ok-' + pollItemId).click();
          } else {
            $('#respond_best-' + pollItemId).click();
          }
        }
        $('#respond_no-' + pollItemId).button({
          icons : {
            primary : "ui-icon-close"
          },
          label: "No",
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_no-' + pollItemId).next("label").addClass("noButton");
        $('#respond_maybe-' + pollItemId).button({
          icons : {
            primary : "ui-icon-help"
          },
          label: "Maybe",
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_maybe-' + pollItemId).next("label").addClass("maybeButton");
        $('#respond_ok-' + pollItemId).button({
          icons : {
            primary : "ui-icon-check"
          },
          label: "Ok",
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_ok-' + pollItemId).next("label").addClass("okButton");
        $('#respond_best-' + pollItemId).button({
          icons : {
            primary : "ui-icon-circle-check"
          },
          label: "Best",
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_best-' + pollItemId).next("label").addClass("bestButton");
      } else {
        td.text(this_poll.textForResponse(response)[0]);
      }
    });
    if (active) {
      tr.addClass("active-voter");
    }
  });

  $.each(event_details, function(index, event) {
    if (this_poll.editing_poll.editable()) {
      $('<button id="winner-' + event.pollitemid() + '">Pick Winner</button>').appendTo(tf_commit.children()[index + 1]).button({
        icons : {
          primary : "ui-icon-star"
        }
      }).click(this_poll.clickWinner);
    } else {
      if (event.ispollwinner()) {
        $(tf_commit.children()[index + 1]).addClass("poll-winner-td");
        $('<div id="winner-text"><span id="winner-icon-left" class="ui-icon ui-icon-star" />Winner<span id="winner-icon-right" class="ui-icon ui-icon-star" /></div>').appendTo(tf_commit.children()[index + 1]);
      }
    }
  });

  this.updateOverallResults();
};

Poll.prototype.textForResponse = function(response) {
  var result = [];
  if (response === undefined) {
    result.push("No Response");
    result.push("no-response-td");
  } else if (response < 40) {
    result.push("No");
    result.push("no-td");
  } else if (response < 80) {
    result.push("Maybe");
    result.push("maybe-td");
  } else if (response < 90) {
    result.push("Ok");
    result.push("ok-td");
  } else {
    result.push("Best");
    result.push("best-td");
  }
  return result;
};

Poll.prototype.clickResponse = function() {
  var splits = $(this).attr("id").split("-");
  var response_type = splits[0];
  var index = parseInt(splits[1]);
  var response = 0;
  if (response_type == "respond_maybe") {
    response = 50;
  } else if (response_type == "respond_ok") {
    response = 85;
  } else if (response_type == "respond_best") {
    response = 100;
  }

  var event = gViewController.activePoll.editing_poll.getChoice(index);
  event.changeVoterResponse(response);
  gViewController.activePoll.updateOverallResults();
};

// A winner was chosen, make poll changes and create new event and save everything
Poll.prototype.clickWinner = function() {
  var splits = $(this).attr("id").split("-");
  var comp = gViewController.activePoll.editing_poll.getChoice(parseInt(splits[1]));
  var new_resource = comp.pickAsWinner();
  new_resource.saveResource(function() {
    gViewController.activePoll.saveResource(function() {
      gViewController.activatePoll(gViewController.activePoll);
    });
  })
};

// Open the event time-range hover dialog
Poll.prototype.hoverCalDialogOpenClassic = function(td_summary, thead, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_summary).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: thead },
    show: "fade",
    title: "Your Events for " + event.start().getLocalizedDate(),
    width: 400
  });
  var start = event.start().clone().addHours(-6);
  var end = event.end().clone().addHours(6);
  gSession.currentPrincipal.eventsForTimeRange(
      start,
      end,
      function(results) {
        var text = "";
        results = $.map(results, function(result) {
          return result.mainComponent();
        });
        results.push(event);
        results.sort(function(a, b) {
          return a.start().milliseconds() - b.start().milliseconds();
        });
        var relative_offset = 10;
        var last_end = null;
        $.each(results, function(index, result) {
          text = result.start().getPrintableTime() + " - ";
          text += result.end().getPrintableTime() + " : ";
          text += result.summary();
          if (last_end !== null && !last_end.equals(result.start())) {
            relative_offset += 10;
          }
          last_end = result.end();
          $('<div class="hover-event ui-corner-all" style="top:' + relative_offset + 'px"/>').appendTo(dialog_div).addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(text);
        });
      }
  );
}

// Open the event time-range hover dialog
Poll.prototype.hoverCalDialogOpenFancy = function(td_summary, thead, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_summary).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: thead },
    show: "fade",
    title: "Your Events for " + event.start().getPrintableTime(),
    width: 400
  });

  /* get 12 hour span */
  var start = event.start().clone();
  start.subtractHours(6);

  var end = event.end().clone();
  end.addHours(6);

  var gridStart = start.clone();

  var grid = $('<table id="hover-grid" />').appendTo(dialog_div);
  for(var i = 0; i <= 12; i++) {
    var text = gridStart.getPrintableTime();
    gridStart.addHours(1);
    $('<tr><td class="hover-grid-td-time">' + text + '</td><td class="hover-grid-td-slot" /></tr>').appendTo(grid);
  }

  gSession.currentPrincipal.eventsForTimeRange(
      start,
      end,
      function(results) {
        results = $.map(results, function(result) {
          return result.mainComponent();
        });

        /* Add the current event to the result */
        results.push(event);
        results.sort(function(a, b) {
          return a.start().diff(b.start(), 'milliseconds');
        });
        var lastDtend = null;
        $.each(results, function(index, result) {
          result.start().tzid(start.tzid());
          result.end().tzid(start.tzid());

          var hoursOffset = result.start().diff(start, 'hours');
          var topOffset = hoursOffset * 30;

          var seconds = result.end().diff(result.start(), 'seconds');
          var height = (seconds * 30) / (60 * 60) - 6;
          var styles = "top:" + topOffset + "px;height:" + height + "px";
          if ((lastDtend !== null) && (lastDtend.diff(result.start(), 'millisecsonds') > 0)) {
            styles += ";left:206px;width:125px";
          }
          lastDtend = result.end();
          $('<div class="hover-event ui-corner-all" style="' + styles + '" />').appendTo(grid).addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(result.summary());
        });
      }
  );
};

Poll.prototype.hoverCalDialogOpen = Poll.prototype.hoverCalDialogOpenFancy;

// Close the event time-range hover dialog
Poll.prototype.hoverCalDialogClose = function() {
  $("#hover-cal").dialog("close").remove();
};

// Open the participant address hover dialog
Poll.prototype.hoverCuaddrDialogOpen = function(td_addr) {
  var splits = splitAddressDescription(td_addr.val());

  var card = cuaddrVcards[splits[1]];

  if (card === undefined) {
    return;
  }

  if (card === null) {
    return;
  }

  var kind = card.data.getPropertyValue("kind");
  if (kind !== "group") {
    return;
  }

  var dialog_div = $('<div id="hover-cuaddr" />').appendTo(td_addr).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: td_addr },
    show: "fade",
    title: "Card for " + td_addr.val(),
    width: 400
  });

  var grid = $('<table id="hover-grid" />').appendTo(dialog_div);
  var members = card.data.properties("member");
  for (var i = 0; i < members.length; i++) {
    var member = members[i];
    $('<tr><td class="hover-grid-td-time">' + member[3] + '</td><td class="hover-grid-td-slot" /></tr>').appendTo(grid);
  }
};


// Close the participant address hover dialog
Poll.prototype.hoverCuaddrDialogClose = function() {
  $("#hover-cuaddr").dialog("close").remove();
};

Poll.prototype.updateOverallResults = function() {
  var this_poll = this;
  var event_details = this.editing_poll.choices();
  var voter_details = this.editing_poll.voters();
  var tds = $("#editpoll-resulttable").children("tfoot").first().children("tr").first().children("td");

  // Update overall items
  $.each(event_details, function(index, event) {
    var overall = [];
    var responses = event.voter_responses();
    $.each(voter_details, function(index, voter) {
      var response = responses[voter.cuaddr()];
      if (response !== undefined) {
        overall.push(response);
      }
    });
    var response_details = this_poll.textForResponse(overall.average());
    var possible_classes = ["best-td", "ok-td", "maybe-td", "no-td", "no-response-td"];
    possible_classes.splice(possible_classes.indexOf(response_details[1]), 1);
    $(tds[index + 1]).text(response_details[0]);
    $(tds[index + 1]).removeClass(possible_classes.join(" "));
    $(tds[index + 1]).addClass(event.ispollwinner() ? "poll-winner-td" : response_details[1]);
  });
};

/** Fill in the responses based on users freebusy at the time of the choice
 *
 */
Poll.prototype.autoFill = function() {

  var choice_details = this.editing_poll.choices();
  $.each(choice_details, function(index, choice) {
    // Freebusy
    gSession.currentPrincipal.isBusy(
        gSession.currentPrincipal.defaultAddress(),
        choice.start(),
        choice.end(),
        function(result) {
          $((result ? "#respond_no-" : "#respond_ok-") + index).click();
        }
    );
  });
};

