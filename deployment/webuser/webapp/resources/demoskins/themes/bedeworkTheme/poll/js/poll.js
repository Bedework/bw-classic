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
}

// Fill the UI with details of the poll
Poll.prototype.setPanel = function() {

  this.editing_object = this.resource.object.duplicate();
  this.editing_poll = this.editing_object.mainComponent();

  this.rewritePanel();
}

// Fill the UI with details of the poll
Poll.prototype.rewritePanel = function() {
  var this_poll = this;

  // Setup the details panel with this poll
  $("#editpoll-title-edit").val(this.editing_poll.summary());
  $("#editpoll-title").text(this.editing_poll.summary());
  $("#editpoll-organizer").text(this.editing_poll.organizerDisplayName());
  $("#editpoll-status").text(this.editing_poll.status());
  $("#editpoll-choicelist").empty();
  $.each(this.editing_poll.events(), function(index, choice) {
    this_poll.addChoicePanel(choice);
  });
  $("#editpoll-voterlist").empty();
  $.each(this.editing_poll.voters(), function(index, voter) {
    this_poll.setVoterPanel(this_poll.addVoterPanel(), voter);
  });
}

// Get poll details from the UI
Poll.prototype.getPanel = function() {
  var this_poll = this;

  // Get values from the details panel
  if (this.owned) {
    this.editing_poll.summary($("#editpoll-title-edit").val());

    var events = this.editing_poll.events();
    $("#editpoll-choicelist").children().each(function(index) {
      this_poll.updateEventFromPanel($(this), events[index]);
    });

    var voters = this.editing_poll.voters();
    $("#editpoll-voterlist").children().each(function(index) {
      this_poll.updateVoterFromPanel($(this), voters[index]);
    });
  }
}

//Add a new event item in the UI
Poll.prototype.addChoicePanel = function(choice) {

  /*var ctr = $("#editpoll-choicelist").children().length + 1;
   var idstart = "event-dtstart-" + ctr;
   var idend = "event-dtend-" + ctr;

   // Add new list item

   var evt = '<div class="event">';
   evt += '<div class="edit-datetime">';
   evt += '<label for="' + idstart + '">Start: </label>';
   evt += '<input type="text" id="' + idstart + '" class="event-dtstart"/>';
   evt += '</div>';
   evt += '<div class="edit-datetime">';
   evt += '<label for="' + idend + '">End:   </label>';
   evt += '<input type="text" id="' + idend + '" class="event-dtend" />';
   evt += '</div>';
   evt += '<button class="input-edit">Edit</button>';
   evt += '<button class="input-remove">Remove</button>';
   evt += '</div>';
   evt = $(evt).appendTo("#editpoll-choicelist");

   //evt.find(".event-dtstart").datetimepicker();
   //evt.find(".event-dtend").datetimepicker();
   evt.find(".input-remove").button({
   icons : {
   primary : "ui-icon-close"
   }
   });*/

  var chc = '<div class="bwChoiceDisplay">' + choice.data.getPropertyValue("summary") + "</div>";
  chc = $(chc).appendTo("#editpoll-choicelist");

  return chc;
}

// Update the UI for this event
// XXX Deprecated?
Poll.prototype.setChoicePanel = function(panel, event) {

  return panel;
}

// Get details of the event from the UI
Poll.prototype.updateEventFromPanel = function(panel, event) {
  event.summary($("#editpoll-title-edit").val());
  //event.dtstart(panel.find(".event-dtstart").datetimepicker("getDate"));
  //event.dtend(panel.find(".event-dtend").datetimepicker("getDate"));
}

// Add choice button clicked
Poll.prototype.addChoice = function() {

  var ctr = $("#editpoll-choicelist").children().length;
  var dtstart = new Date();
  dtstart.setDate(dtstart.getDate() + ctr);
  dtstart.setHours(12, 0, 0, 0);
  var dtend = new Date();
  dtend.setDate(dtend.getDate() + ctr);
  dtend.setHours(13, 0, 0, 0);

  // Add new list item
  currentEntity = this.editing_poll.addChoice(dtstart, dtend);

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
}

//Add a new choice item in the UI
Poll.prototype.populateChoiceForm = function(choice) {
  $("#choice-widget #bwEventTitle").val(choice.data.getPropertyValue("summary"));

  var dtStart = choice.data.getPropertyValue("dtstart");
  var dtSt = new JcalDtTime(hour24, dtStart);
  var hour = 0;
  var hour24Opts = "";
  var locs = new BwLocations;
  var locNames = locs.getDisplayNames();

  $("#choice-widget #bwEventWidgetStartDate").val(dtSt.datePart);

  if(dtSt.allDay) {
    $("#allDayFlag").click();
  } else {
    hour = dtSt.hours;
    $("#storeUTCFlag").attr('checked', dtSt.UTC);
    if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
      $("#choice-widget #eventStartDateAmpm").hide();
      // generate the 24 hour options
      for (i=0; i<24; i++) {
        hour24Opts += '<option value="' + i + '">' + i + '</option>';
      }
      $("#choice-widget #eventStartDateHour").empty();
      $("#choice-widget #eventStartDateHour").html(hour24Opts);
    } else {
      hour = parseInt(dtSt.hours);
      if (hour > 12) {
        hour -= 12;
      }
      if (hour == 0) {
        hour = 12;
      }
      if(!dtSt.am) {
        $("#choice-widget #eventStartDateAmpm").prop("selectedIndex", 1);
      }
    }

    $("#choice-widget #eventStartDateHour").val(hour);
    $("#choice-widget #eventStartDateMinute").val(dtSt.minutes);

  }

  var dur = choice.data.getPropertyValue("duration");

  if (dur != null) {
    // Flag it as end type duration
    $("input[name=eventEndType][value=D]").click();

    var jdur = new jcalduration();

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
    var pname = "dtend";
    if (choice.data.name === "vtodo") {
      pname = "due";
    }
    var dtEnd = choice.data.getPropertyValue(pname);
    var dtE = new JcalDtTime(hour24, dtEnd);

    $("#choice-widget #bwEventWidgetEndDate").val(dtE.datePart);

    if (!dtSt.allDay) {
      hour = parseInt(dtE.hours);
      if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
        $("#choice-widget #eventEndDateAmpm").hide();
        $("#choice-widget #eventEndDateHour").empty();
        $("#choice-widget #eventEndDateHour").html(hour24Opts);
      } else {
        if (hour > 12) {
          hour -= 12;
        }
        if (hour == 0) {
          hour = 12;
        }
        if(!dtE.am) {
          $("#choice-widget #eventEndDateAmpm").prop("selectedIndex", 1);
        }
      }
      $("#choice-widget #eventEndDateHour").val(hour);
      $("#choice-widget #eventEndDateMinute").val(dtE.minutes);
    }
  }

  // setup the location data
  var locationOptions = "";
  for (i=0;i<locNames.length;i++) {
    locationOptions = '<option value="' + i + '">' + locNames[i] + '</options>';
  }

  $("#eventFormLocationList select").append(locationOptions);

}

/** The reverse of populateChoiceForm - takes values from the form and
 * puts them into the given choice
 *
 * @param choice
 */
Poll.prototype.populateChoice = function(choice) {
  choice.data.updateProperty("summary", $("#choice-widget #bwEventTitle").val());

  var dtSt = new JcalDtTime(hour24);

  dtSt.datePart = $("#choice-widget #bwEventWidgetStartDate").val();
  dtSt.allDay = $("#allDayFlag").is(":checked");

  if (!dtSt.allDay) {
    dtSt.UTC = $("#storeUTCFlag").val();
    dtSt.hours = $("#choice-widget #eventStartDateHour").val();
    dtSt.minutes = $("#choice-widget #eventStartDateMinute").val();

    if (!hour24) {
      dtSt.am = $("#eventStartDateAmpm").attr("selectedIndex") == 0;
    }
  }

  choice.data.updateProperty("dtstart", dtSt.getDtval());

  if ($("input[name=eventEndType]").val() == "D") {
    // Duration type
    var jdur = new jcalduration();

    if ($("#choice-widget #durationTypeWeeks").val()) {
      jdur.mWeeks = $("#choice-widget #durationWeeks").val();
    } else {
      jdur.mDays = $("#choice-widget #durationDays").val();

      if (!dtSt.allDay) {
        jdur.mHours = $("#choice-widget #durationHours").val();
        jdur.mMinutes = $("#choice-widget #durationMinutes").val();
      }
    }

    choice.data.updateProperty("duration", jdur.generate());
  } else {
    // Dtend type
    var dtE = new JcalDtTime(hour24);

    dtE.datePart = $("#choice-widget #bwEventWidgetStartDate").val();
    dtE.allDay = dtSt.allDay;

    if (!dtSt.allDay) {
      dtE.UTC = dtSt.UTC;
      dtE.hours = $("#choice-widget #eventStartDateHour").val();
      dtE.minutes = $("#choice-widget #eventStartDateMinute").val();

      if (!hour24) {
        dtE.am = $("#eventStartDateAmpm").attr("selectedIndex") == 0;
      }
    }
    var pname = "dtend";
    if (choice.data.name === "vtodo") {
      pname = "due";
    }

    choice.data.updateProperty(pname, dtE.getDtval());
  }
}

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

//Add a new voter item in the UI
Poll.prototype.addVoterPanel = function() {

  var ctr = $("#editpoll-voterlist").children().length + 1;
  var idvoter = "voter-address-" + ctr;
  var idvoterTypePrefix = "voter-" + ctr;
  var radioName = "voterType" + ctr;

  // Add new list item
  var vtr = '<div class="voter">';
  vtr += '<div class="edit-voter">';
  vtr += '<label for="' + idvoter + '">Voter: </label>';
  vtr += '<input type="text" id="' + idvoter + '" class="voter-address"/>';
  vtr += '<span id="edit-votertype">';
  vtr += '<input type="radio" id="' + idvoterTypePrefix +
      '-typeUser" name="' + radioName + '" value="INDIVIDUAL" checked/>';
  vtr += '<label for="' + idvoterTypePrefix + '-typeUser">user</label>';
  vtr += '<input type="radio" id="' + idvoterTypePrefix +
      '-typeGroup" name="' + radioName + '" value="GROUP"/>';
  vtr += '<label for="' + idvoterTypePrefix + '-typeGroup">group</label>';
  vtr += '<input type="radio" id="' + idvoterTypePrefix +
      '-typeLocation" name="' + radioName + '" value="ROOM"/>';
  vtr += '<label for="' + idvoterTypePrefix + '-typeLocation">location</label>';
  vtr += '</span>';
  vtr += '</div>';
  vtr += '<button class="input-remove">Remove</button>';
  vtr += '</div>';
  vtr = $(vtr).appendTo("#editpoll-voterlist");

  vtr.find(".voter-address").autocomplete({
    minLength : 3,
    extraParams: {
      vtype : function() {
        return  $("input:radio[name=" + radioName + "]:checked").val();
      }
    },
    source : function(request, response) {
      var vtype = this.options.extraParams.vtype();
      gSession.calendarUserSearch(request.term, vtype, function(results) {
        response(results);
      });
    }
  }).focus(function() {
    $(this).select();
  });

  vtr.find(".input-remove").button({
    icons : {
      primary : "ui-icon-close"
    }
  });

  return vtr;
}

// Update UI for this voter
Poll.prototype.setVoterPanel = function(panel, voter) {
  panel.find(".voter-address").val(voter.addressDescription());
  return panel;
}

// Get details of the voter from the UI
Poll.prototype.updateVoterFromPanel = function(panel, voter) {
  voter.addressDescription(panel.find(".voter-address").val());
}

// Add voter button clicked
Poll.prototype.addVoter = function() {
  // Add new list item
  var voter = this.editing_poll.addVoter();
  return this.setVoterPanel(this.addVoterPanel(), voter);
}

// Build the results UI based on the poll details
Poll.prototype.buildResults = function() {

  var this_poll = this;

  // Sync with any changes from other panels
  this.getPanel();

  var event_details = this.editing_poll.events();
  var voter_details = this.editing_poll.voters();

  var thead = $("#editpoll-resulttable").children("thead").first();
  var th_date = thead.children("tr").eq(0).empty();
  var th_start = thead.children("tr").eq(1).empty();
  var th_end = thead.children("tr").eq(2).empty();
  var tf = $("#editpoll-resulttable").children("tfoot").first();
  var tf_overall = tf.children("tr").first().empty();
  var tf_commit = tf.children("tr").last().empty();
  tf_commit.toggle(this.owned || !this_poll.editing_poll.editable());
  var tbody = $("#editpoll-resulttable").children("tbody").first().empty();
  $('<td>Date:</td>').appendTo(th_date);
  $('<td>Start:</td>').appendTo(th_start);
  $('<td>End:</td>').appendTo(th_end);
  $('<td>Overall:</td>').appendTo(tf_overall);
  $('<td />').appendTo(tf_commit);
  $.each(event_details, function(index, event) {
    var td_date = $('<td />').appendTo(th_date).text(event.dtstart().toDateString()).addClass("center-td");
    var td_start = $('<td />').appendTo(th_start).text(event.dtstart().toLocaleTimeString());
    var td_end = $('<td />').appendTo(th_end).text(event.dtend().toLocaleTimeString());
    $('<td />').appendTo(tf_overall).addClass("center-td");
    $('<td />').appendTo(tf_commit).addClass("center-td");
    if (event.ispollwinner()) {
      td_date.addClass("poll-winner-td");
      td_start.addClass("poll-winner-td");
      td_end.addClass("poll-winner-td");
    }
    td_date.hover(
        function() {
          this_poll.hoverDialogOpen(td_date, thead, event);
        },
        this_poll.hoverDialogClose
    );
  });
  $.each(voter_details, function(index, voter) {
    var active = gSession.currentPrincipal.matchingAddress(voter.cuaddr());
    var tr = $("<tr/>").appendTo(tbody);
    $("<td/>").appendTo(tr).text(voter.nameOrAddress());
    $.each(event_details, function(index, event) {
      var response = event.voter_responses()[voter.cuaddr()];
      var td = $("<td />").appendTo(tr).addClass("center-td");
      if (event.ispollwinner()) {
        td.addClass("poll-winner-td");
      }
      if (active && this_poll.editing_poll.editable()) {
        var radios = $('<div id="response-' + index + '" />').appendTo(td).addClass("response-btns");
        $('<input type="radio" id="respond_no-' + index + '" name="response-' + index + '"/>').appendTo(radios);
        $('<label for="respond_no-' + index + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_maybe-' + index + '" name="response-' + index + '"/>').appendTo(radios);
        $('<label for="respond_maybe-' + index + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_ok-' + index + '" name="response-' + index + '"/>').appendTo(radios);
        $('<label for="respond_ok-' + index + '"/>').appendTo(radios);
        $('<input type="radio" id="respond_best-' + index + '" name="response-' + index + '"/>').appendTo(radios);
        $('<label for="respond_best-' + index + '"/>').appendTo(radios);
        radios.buttonset();
        if (response !== undefined) {
          if (response < 40) {
            $('#respond_no-' + index).click();
          } else if (response < 80) {
            $('#respond_maybe-' + index).click();
          } else if (response < 90) {
            $('#respond_ok-' + index).click();
          } else {
            $('#respond_best-' + index).click();
          }
        }
        $('#respond_no-' + index).button({
          icons : {
            primary : "ui-icon-close"
          },
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_maybe-' + index).button({
          icons : {
            primary : "ui-icon-help"
          },
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_ok-' + index).button({
          icons : {
            primary : "ui-icon-check"
          },
          text: false
        }).click(this_poll.clickResponse);
        $('#respond_best-' + index).button({
          icons : {
            primary : "ui-icon-circle-check"
          },
          text: false
        }).click(this_poll.clickResponse);
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
      $('<button id="winner-' + index + '">Pick Winner</button>').appendTo(tf_commit.children()[index + 1]).button({
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
}

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
}

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

  var event = gViewController.activePoll.editing_poll.events()[index];
  event.changeVoterResponse(response);
  gViewController.activePoll.updateOverallResults();
}

// A winner was chosen, make poll changes and create new event and save everything
Poll.prototype.clickWinner = function() {
  var splits = $(this).attr("id").split("-");
  var event = gViewController.activePoll.editing_poll.events()[parseInt(splits[1])];
  var new_resource = event.pickAsWinner();
  new_resource.saveResource(function() {
    gViewController.activePoll.saveResource(function() {
      gViewController.activatePoll(gViewController.activePoll);
    });
  })
}

// Open the event time-range hover dialog
Poll.prototype.hoverDialogOpenClassic = function(td_date, thead, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_date).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: thead },
    show: "fade",
    title: "Your Events for " + event.dtstart().toDateString(),
    width: 400
  });
  var start = new Date(event.dtstart().getTime() - 6 * 60 * 60 * 1000);
  var end = new Date(event.dtend().getTime() + 6 * 60 * 60 * 1000);
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
          return a.dtstart().getTime() - b.dtstart().getTime();
        });
        var relative_offset = 10;
        var last_end = null;
        $.each(results, function(index, result) {
          text = result.dtstart().toLocaleTimeString() + " - ";
          text += result.dtend().toLocaleTimeString() + " : ";
          text += result.summary();
          if (last_end !== null && last_end.getTime() != result.dtstart().getTime()) {
            relative_offset += 10;
          }
          last_end = result.dtend();
          $('<div class="hover-event ui-corner-all" style="top:' + relative_offset + 'px"/>').appendTo(dialog_div).addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(text);
        });
      }
  );
}

// Open the event time-range hover dialog
Poll.prototype.hoverDialogOpenFancy = function(td_date, thead, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_date).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: thead },
    show: "fade",
    title: "Your Events for " + event.dtstart().toDateString(),
    width: 400
  });

  var start = new Date(event.dtstart().getTime() - 6 * 60 * 60 * 1000);
  start.setMinutes(0, 0, 0);
  var startHour = start.getHours();
  var end = new Date(event.dtend().getTime() + 6 * 60 * 60 * 1000);
  end.setMinutes(0, 0, 0);
  var endHour = end.getHours();

  var grid = $('<table id="hover-grid" />').appendTo(dialog_div);
  for(var i = startHour; i < endHour; i++) {
    var text = i > 12 ? i - 12 +":00 pm" : i + ":00 am";
    $('<tr><td class="hover-grid-td-time">' + text + '</td><td class="hover-grid-td-slot" /></tr>').appendTo(grid);
  }
  gSession.currentPrincipal.eventsForTimeRange(
      start,
      end,
      function(results) {
        results = $.map(results, function(result) {
          return result.mainComponent();
        });
        results.push(event);
        results.sort(function(a, b) {
          return a.dtstart().getTime() - b.dtstart().getTime();
        });
        var last_dtend = null;
        $.each(results, function(index, result) {
          var top_offset = (result.dtstart().getHours() - startHour) * 30;
          var height = ((result.dtend().getTime() - result.dtstart().getTime()) * 30) / (60 * 60 * 1000) - 6;
          var styles = "top:" + top_offset + "px;height:" + height + "px";
          if (last_dtend !== null && last_dtend > result.dtstart()) {
            styles += ";left:206px;width:125px";
          }
          last_dtend = result.dtend();
          $('<div class="hover-event ui-corner-all" style="' + styles + '" />').appendTo(grid).addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(result.summary());
        });
      }
  );
}

Poll.prototype.hoverDialogOpen = Poll.prototype.hoverDialogOpenFancy;

// Close the event time-range hover dialog
Poll.prototype.hoverDialogClose = function() {
  $("#hover-cal").dialog("close").remove();
}

Poll.prototype.updateOverallResults = function() {
  var this_poll = this;
  var event_details = this.editing_poll.events();
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
}

Poll.prototype.autoFill = function() {

  var event_details = this.editing_poll.events();
  $.each(event_details, function(index, event) {
    // Freebusy
    gSession.currentPrincipal.isBusy(
        gSession.currentPrincipal.defaultAddress(),
        event.dtstart(),
        event.dtend(),
        function(result) {
          $((result ? "#respond_no-" : "#respond_ok-") + index).click();
        }
    );
  });
}

