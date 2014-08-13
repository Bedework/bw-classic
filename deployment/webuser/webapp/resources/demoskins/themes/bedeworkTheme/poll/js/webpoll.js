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

// Globals
var gSession = null;
var gViewController = null;
var currentEntity = null;
var locations = new BwLocations;

var choicesTab = 0;
var votersTab = 1;
var resultsTab = 2;
var active_tab = -1;

// Page load
$(function() {

  $("#progressbar").progressbar({
    value : false
  });
  showLoading(true);

  var params = {};
  var ps = window.location.search.split(/\?|&/);
  for (var i = 0; i < ps.length; i++) {
    if (ps[i]) {
      var p = ps[i].split(/=/);
      params[p[0]] = p[1];
    }
  }

  if (currentLocale.length > 0) {
    var loc = currentLocale.toLowerCase();

    loc.replace("_", "-");

    moment.locale(loc);
  }

  // Setup CalDAV session
  gSession = new CalDAVSession(params.user);
  gSession.init(function() {
    $("#title").text($("#title").text() + " for User: " + gSession.currentPrincipal.cn);
    gViewController.refreshed();
  });

  gViewController = new ViewController(gSession);
});

function showLoading(visible) {
  if (visible) {
    $("#progressbar").progressbar("enable");
    $("#loading").show();
  } else {
    $("#progressbar").progressbar("disable");
    $("#loading").hide();
  }
}

// Handles all the view interactions
ViewController = function(session) {
  this.session = session;
  this.ownedPolls = new PollList($("#sidebar-owned"), $("#sidebar-new-poll-count"));
  this.voterPolls = new PollList($("#sidebar-voter"), $("#sidebar-vote-poll-count"));
  this.activePoll = null;
  this.isNewPoll = null;

  this.init();
}

// Setup all the parts of the view
ViewController.prototype.init = function() {
  // Setup title area

  var view = this;

  // Setup sidebar UI widgets
  $("#sidebar").accordion({
    heightStyle : "content"
  });
  $("#sidebar-owned").menu({
    select : function(event, ui) {
      view.clickSelectPoll(event, ui, true);
    }
  });
  $("#sidebar-new-poll").button({
    icons : {
      primary : "ui-icon-plusthick"
    }
  }).click(function() {
    view.clickAddPoll();
  });

  $("#sidebar-voter").menu({
    select : function(event, ui) {
      view.clickSelectPoll(event, ui, false);
    }
  });

  $("#refresh-btn").button({
    icons : {
      primary : "ui-icon-refresh"
    }
  }).click(function() {
    view.clickRefresh();
  });


  // Detail Panel
  this.editSetVisible(false);
  $("#editpoll-title-edit").focus(function() {
    $(this).select();
  });
  $("#editpoll-tabs").tabs({
    beforeActivate : function(event, ui) {
      view.showResults(event, ui);
    }
  });
  $("#editpoll-save").button({
    icons : {
      primary : "ui-icon-check"
    }
  }).click(function() {
    view.clickPollSave();
  });
  $("#editpoll-cancel").button({
    icons : {
      primary : "ui-icon-close"
    }
  }).click(function() {
    view.clickPollCancel();
  });
  $("#editpoll-done").button({
    icons : {
      primary : "ui-icon-arrowreturnthick-1-w"
    }
  }).click(function() {
    view.clickPollCancel();
  });
  $("#editpoll-delete").button({
    icons : {
      primary : "ui-icon-trash"
    }
  }).click(function() {
    view.clickPollDelete();
  });
  $("#editpoll-autofill").button({
    icons : {
      primary : "ui-icon-gear"
    }
  }).click(function() {
    view.clickPollAutofill();
  });
  $("#editpoll-addchoice").button({
    icons : {
      primary : "ui-icon-plus"
    }
  }).click(function() {
    view.clickAddChoice();
  });
  $("#choiceFormFields").tabs();
  $("#editpoll-savechoice").button().click(function() {
    view.activePoll.populateChoice(currentEntity);

    //alert(currentEntity.data.getPropertyValue("summary"));

    // 2. update the vpoll with current entity
    view.activePoll.saveChoice(currentEntity);

    // 3. rewrite ui choice list
    view.activePoll.rewritePanel();

    // 4. close the popup
    $.magnificPopup.close();
  });
  $("#editpoll-cancelchoice").button().click(function() {
    $.magnificPopup.close();
  });
  $("#editpoll-addvoter").button({
    icons : {
      primary : "ui-icon-plus"
    }
  }).click(function() {
    view.clickAddVoter();
  });

  $("#editpoll-autofill").hide();
  $("#response-key").hide();
  $("#response-menu").menu();
  $("#advDateTimeToggle").click(function(){
    if($(this).is(":checked")) {
      $("#bwAdvDateTimeSettings").removeClass("invisible");
    } else {
      $("#bwAdvDateTimeSettings").addClass("invisible");
    }
  });
}

// Add a poll to the UI
ViewController.prototype.addPoll = function(poll) {
  if (poll.owned) {
    this.ownedPolls.addPoll(poll)
  } else {
    this.voterPolls.addPoll(poll)
  }
}

// Switching away from active poll
ViewController.prototype.aboutToClosePoll = function() {
  if (this.activePoll && this.activePoll.editing_poll.changed()) {
    alert("Save or cancel the current poll changes first");
    return false;
  } else {
    return true;
  }
}

// Refresh the side bar - try to preserve currently selected item
ViewController.prototype.clickRefresh = function() {
  if (!this.aboutToClosePoll()) {
    return;
  }

  var currentUID = this.activePoll ? this.activePoll.editing_poll.uid() : null;
  active_tab = $("#editpoll-tabs").tabs("option", "active");
  if (this.activePoll) {
    this.clickPollCancel();
  }
  showLoading(true);
  this.ownedPolls.clearPolls();
  this.voterPolls.clearPolls();
  var this_view = this;
  this.session.currentPrincipal.refresh(function() {
    this_view.refreshed();
    if (currentUID) {
      this_view.selectPollByUID(currentUID);
      $("#editpoll-tabs").tabs("option", "active", active_tab);
      if (active_tab === resultsTab) {
        this.activePoll.buildResults();
      }
    }
  });
}

// Add poll button clicked
ViewController.prototype.clickAddPoll = function() {
  if (!this.aboutToClosePoll()) {
    return;
  }

  // Make sure edit panel is visible
  this.activatePoll(new Poll(CalendarResource.newPoll("New Poll")));
  this.isNewPoll = true;
  $("#editpoll-title-edit").focus();
}

// A poll was selected
ViewController.prototype.clickSelectPoll = function(event, ui, owner) {
  if (!this.aboutToClosePoll()) {
    return;
  }

  this.selectPoll(ui.item.index(), owner);
};

// Select a poll from the list based on its UID
ViewController.prototype.selectPollByUID = function(uid) {
  var result = this.ownedPolls.indexOfPollUID(uid);
  if (result !== null) {
    this.selectPoll(result, true);
    return;
  }

  result = this.voterPolls.indexOfPollUID(uid);
  if (result !== null) {
    this.selectPoll(result, false);
  }
};

//A poll was selected
ViewController.prototype.selectPoll = function(index, owner) {
  // Make sure edit panel is visible
  this.activatePoll(owner ? this.ownedPolls.polls[index] : this.voterPolls.polls[index]);
  if (owner) {
    $("#editpoll-title-edit").focus();
  }
};

// Activate specified poll
ViewController.prototype.activatePoll = function(poll) {
  this.activePoll = poll;
  this.activePoll.setPanel();
  this.isNewPoll = false;
  this.editSetVisible(true);
}

// Save button clicked
ViewController.prototype.clickPollSave = function() {

  // TODO: Actually save it to the server

  if (active_tab === votersTab) {
    // Ensure voters up to date
    this.activePoll.updateVoters();
  }

  this.activePoll.getPanel();
  if (this.isNewPoll) {
    this.ownedPolls.newPoll(this.activePoll);
  } else {
    this.activePoll.list.changePoll(this.activePoll);
  }
}

// Cancel button clicked
ViewController.prototype.clickPollCancel = function() {

  // Make sure edit panel is visible
  this.activePoll.closed();
  this.activePoll = null;
  this.isNewPoll = null;
  this.editSetVisible(false);
}

// Delete button clicked
ViewController.prototype.clickPollDelete = function() {

  // TODO: Actually delete it on the server

  this.activePoll.list.removePoll(this.activePoll);

  // Make sure edit panel is visible
  this.activePoll = null;
  this.isNewPoll = null;
  this.editSetVisible(false);
}

// Autofill button clicked
ViewController.prototype.clickPollAutofill = function() {
  this.activePoll.autoFill();
}

// Add event button clicked
ViewController.prototype.clickAddChoice = function() {
  this.activePoll.addChoice();
}

// Add voter button clicked
ViewController.prototype.clickAddVoter = function() {
  var panel = this.activePoll.addVoter();
  panel.find(".voter-address").focus();
}

// Toggle display of poll details
ViewController.prototype.editSetVisible = function(visible) {

  if (visible) {

    if (this.isNewPoll) {
      $("#editpoll-delete").hide();
      $("#editpoll-tabs").tabs("disable", resultsTab);
    } else {
      $("#editpoll-delete").show();
      $("#editpoll-tabs").tabs("enable", resultsTab);
    }
    if (this.activePoll.owned && this.activePoll.resource.object.mainComponent().editable()) {
      $("#editpoll-title-panel").hide();
      $("#editpoll-organizer-panel").hide();
      $("#editpoll-status-panel").hide();
      $("#editpoll-title-edit-panel").show();
      $("#editpoll-tabs").tabs("enable", choicesTab);
      $("#editpoll-tabs").tabs("enable", votersTab);
      $("#editpoll-tabs").tabs("option", "active", choicesTab);
      active_tab = choicesTab;
      $("#response-key").hide();
    } else {
      $("#editpoll-title-edit-panel").hide();
      $("#editpoll-title-panel").show();
      $("#editpoll-organizer-panel").show();
      $("#editpoll-status-panel").show();
      $("#editpoll-tabs").tabs("option", "active", resultsTab);
      active_tab = resultsTab;
      $("#editpoll-tabs").tabs("disable", choicesTab);
      $("#editpoll-tabs").tabs("disable", votersTab);
      $("#response-key").toggle(this.activePoll.resource.object.mainComponent().editable());
      this.activePoll.buildResults();
    }

    $("#editpoll-save").toggle(this.activePoll.resource.object.mainComponent().editable());
    $("#editpoll-cancel").toggle(this.activePoll.resource.object.mainComponent().editable());
    $("#editpoll-done").toggle(!this.activePoll.resource.object.mainComponent().editable());
    $("#editpoll-autofill").toggle(this.activePoll.resource.object.mainComponent().editable());

    $("#detail-nocontent").hide();
    $("#editpoll").show();
  } else {
    $("#editpoll").hide();
    $("#detail-nocontent").show();
  }
}

ViewController.prototype.refreshed = function() {
  showLoading(false);
  if (this.ownedPolls.polls.length == 0 && this.voterPolls.polls.length != 0) {
    $("#sidebar").accordion("option", "active", 1);
  } else {
    $("#sidebar").accordion("option", "active", 0);
  }
}

// Rebuild results panel each time it is selected
ViewController.prototype.showResults = function(event, ui) {
  var newTab;

  if (ui.newPanel.selector === "#editpoll-results") {
    newTab = resultsTab;
  } else if (ui.newPanel.selector === "#editpoll-events") {
    newTab = choicesTab;
  } else if (ui.newPanel.selector === "#editpoll-voters") {
    newTab = votersTab;
  }

  if (newTab === resultsTab) {
    this.activePoll.buildResults();
  }
  $("#editpoll-autofill").toggle(newTab === resultsTab);
  $("#response-key").toggle(newTab === resultsTab);

  if (active_tab === votersTab) {
    // Moving away from voters - update the state
    this.activePoll.updateVoters();
  }

  active_tab = newTab;
}

// Maintains the list of editable polls and manipulates the DOM as polls are
// added
// and removed.
PollList = function(menu, counter) {
  this.polls = [];
  this.menu = menu;
  this.counter = counter;
}

// Add a poll to the UI.
PollList.prototype.addPoll = function(poll) {
  this.polls.push(poll);
  poll.list = this;
  this.menu.append('<li class="sidebar-list"><a href="#">' + poll.title() + '</a></li>');
  this.menu.menu("refresh");
  this.counter.text(this.polls.length);
}

// Add a poll to the UI and save its resource
PollList.prototype.newPoll = function(poll) {
  this.addPoll(poll);
  poll.saveResource();
  $("#editpoll-delete").show();
}

// Change a poll in the UI and save its resource
PollList.prototype.changePoll = function(poll) {
  var index = this.polls.indexOf(poll);
  this.menu.find("a").eq(index).text(poll.title());
  this.menu.menu("refresh");
  poll.saveResource();
}

// Remove a poll resource and its UI
PollList.prototype.removePoll = function(poll) {
  var this_polllist = this;
  poll.resource.removeResource(function() {
    var index = this_polllist.polls.indexOf(poll);
    this_polllist.polls.splice(index, 1);
    this_polllist.menu.children("li").eq(index).remove();
    this_polllist.menu.menu("refresh");
    this_polllist.counter.text(this_polllist.polls.length);
  });
}

PollList.prototype.indexOfPollUID = function(uid) {
  var result = null;
  $.each(this.polls, function(index, poll) {
    if (poll.resource.object.mainComponent().uid() == uid) {
      result = index;
      return false;
    }
  });
  return result;
}

// Remove all UI items
PollList.prototype.clearPolls = function() {
  this.menu.empty();
  this.menu.menu("refresh");
  this.polls = [];
  this.counter.text(this.polls.length);
}
