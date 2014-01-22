//
//  Licensed to Jasig under one or more contributor license
//  agreements. See the NOTICE file distributed with this work
//  for additional information regarding copyright ownership.
//  Jasig licenses this file to you under the Apache License,
//  Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a
//  copy of the License at:
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.
//

// Bedework Calendar Subscription Explorer Navigation

// NAVIGATIONAL ELEMENTS ONCLICK ACTIONS:
$(document).ready(function () {

  /* CALENDARS EXPLORER MENU
   * The click action for the subscriptions "CALENDARS" tree
   * for filtering the center event list.
   * This is fired when a user clicks a calendar in the explorer
   * navigation in the left column. */
  $(".bwMenuTree ul ul a").click(function (event) {
    event.preventDefault();
    var curFilter = $(this).attr("class").substring(2); // trim off the required "bw" prefix
    var curlabel = $(this).text();
    var itemIndex = $.inArray(curFilter, bwFilters);
    if (itemIndex != -1) {
      bwFilters.splice(itemIndex, 1);
      bwFilterLabels.splice(itemIndex, 1);
      $(this).css("font-weight", "normal");
    } else {
      bwFilters.push(curFilter);
      bwFilterLabels.push(curlabel);
      $(this).css("font-weight", "bold");
    }

    refreshFilterList(bwCalFilterName,bwCalClearFilterMarkup);
    reloadMainEventList();
  });

  /* Open and close the tree (by clicking the + or -) */
  $(".bwMenuTree .menuTreeToggle").click(function () {
    var curItem = $(this).parent("li");
    $(curItem).children("ul").slideToggle("fast", function () {
      if ($(this).is(":visible")) {
        $(this).parent("li").children("span.menuTreeToggle").html("-");
        openCals.push($(curItem).attr("id"));
      } else {
        var itemIndex = $.inArray($(curItem).attr("id"), openCals);
        $(this).parent("li").children("span.menuTreeToggle").html("+");
        openCals.splice(itemIndex, 1);
      }

      sendAjax("setappvar=opencals(" + openCals.toString() + ")");

    });

  });

  /* Add the click handler to filters that are generated on first page load.  */
  $("#bwFilterList").on("click", ".bwfilter a", bwFilterClickHandler);

  /* Add a click handler to the "back to events" link.  */
  $("#eventIcons").on("click", "a.linkBack", bwRangeClickHandler);

  /* Add a click handler to day/week/month links. (If the links are present.) */
  $("#bwDatePickerRangeLinks").on("click", "a.bwRangeLink", bwRangeClickHandler);

  /* Add a click handler to the upcoming link, to pick up the start date from the
     date picker. (If the upcoming link is present.)*/
  $("#bwDatePickerRangeLinks").on("click", "a.bwUpcomingLink", bwUpcomingClickHandler);

});

// DATE PICKER FUNCTIONS:
// The date picker was used to set a start date
function changeStartDate(formObj,eventListObj) {
  if (eventListObj != undefined){
    // We have an eventList object.
    // Update the object and do an ajax call.
    // Do not submit the form.
    var outputContainer = document.getElementById(eventListObj.outputContainerId);
    if (outputContainer != null) {
      eventListObj.setRequestData("start",formObj.start.value);
      eventListObj.display();
      return false;
    }
  }
  // No eventList object was sent - do a normal form submit.
  formObj.submit();
  return true;
}

// SEARCH FUNCTIONS
function bwSearch(val) {
  bwMainEventList.setQuery(val);
  refreshQuery(bwQueryName,bwClearQueryMarkup);
  reloadMainEventList();
  return false;
}

function bwClearSearch() {
  bwMainEventList.setQuery("");
  $("#bwBasicSearchInput").val("");
  refreshQuery(bwQueryName,bwClearQueryMarkup);
  reloadMainEventList();
}

/* Refresh the search query displayed above the main column */
function refreshQuery(bwQueryName,bwClearQueryMarkup) {
  var curQuery = bwMainEventList.getQuery();
  if(curQuery == "") {
    $("#bwQueryContainer").empty();
  } else {
    $("#bwQueryContainer").html('<div id="bwQuery" class="eventFilterInfo">' + bwQueryName + " <strong>\"" + curQuery + "\"</strong> " + bwClearQueryMarkup + '</div>');
  }
}

// CALENDAR FILTER FUNCTIONS
/* Clear the calendar filters. */
function bwClearCalFilters() {
  bwFilters.length = 0;
  bwFilterLabels.length = 0;
  refreshFilterList(bwCalFilterName,bwCalClearFilterMarkup);
  $(".bwMenuTree ul ul a").css("font-weight", "normal");
  reloadMainEventList();
}

/* Refresh the list of filters displayed above the main column */
function refreshFilterList(bwFilterName,bwClearFilterMarkup) {
  if(bwFilters.length == 0) {
    $("#calFilterContainer").empty();
  } else {
    $("#calFilterContainer").html('<div id="bwFilterList" class="eventFilterInfo"></div>');
    displayFilters(bwFilters,bwFilterLabels,bwFilterName,bwClearFilterMarkup);
  }
}

/* Generate an individual filter list.  This is called both when
 * constructing the page on first load and when navigating. */
function displayFilters(bwFilters, bwFilterLabels, bwFilterName, bwClearFilterMarkup) {
  if (bwFilters.length > 0) {
    var filterList = bwFilterName + " ";
    $.each(bwFilters, function (i, value) {
      filterList += renderFilter(bwFilterLabels[i], bwFilters[i], "bwfilter");
    });
    filterList += " " + bwClearFilterMarkup;
    // Write the list back to the screen
    $("#bwFilterList").html(filterList);
    // Add click handlers to the list items
    $("#bwFilterList .bwfilter a").click(bwFilterClickHandler);
  }
}

/* Generate an individual filter */
function renderFilter(label,filter,itemClass) {
  return '<span class="' + itemClass + '"><a href="' + filter + '">x</a> ' + label + '</span> ';
}

// PRIMARY NAVIGATION FUNCTIONS:
function reloadMainEventList() {
  var fexpr = bwMainEventList.getFilterExpression(bwFilters);
  var query = bwMainEventList.getQuery();

  var qstring = new Array();
  qstring.push("setappvar=bwFilters(" + bwFilters.toString() + ")");
  qstring.push("setappvar=bwFilterLabels(" + bwFilterLabels.toString() + ")");
  qstring.push("setappvar=bwQuery(" + query + ")");

  if (bwPage == "eventList") {
    // we're on the eventList - use ajax directly
    var reqData = new Object;
    reqData.fexpr = fexpr;
    reqData.query = query;
    launchAjax(bwMainEventList, reqData);
    sendAjax(qstring);
  } else {
    // build up a query string for full request / response
    qstring.push("fexpr=" + fexpr);
    if (query != "") {
      qstring.push("query=" + query);
    }
    if (bwPage == "eventscalendar" || bwListPage == "eventscalendar") {
      launch(bwUrls.setSelection, qstring);
    } else {
      launch(bwUrls.setSelectionList, qstring);
    }
  }
}

/* Update an event list object from the server */
function launchAjax(listObj,reqData) {
  if (reqData != undefined) {
    $.each(reqData, function (key, value) {
      listObj.setRequestData(key,value);
    });
  }
  listObj.display();
}

/* General purpose ajax send: allows us to place multiple parameters of the
   same name in a query string (e.g. setappvar).
   val can be a string or a simple array of key=value pairs,
   e.g. string: "key=value&key=value&key=value"
      or array: ["key=value","key=value","key=value"] */
function sendAjax(val) {
  var qstring = "";
  if ($.isArray(val)) {
    if ((val != undefined) && (val.length > 0)) {
      for (var i=0; i < val.length; i++) {
        qstring += "&" + val[i];
      }
    }
  } else if (typeof val == 'string') {
    qstring = val;
  }

  if (qstring != "") {
    // only send if we have we have some data to send
    $.ajax({
      url: bwUrls.async,
      data: qstring,
      dataType: 'html'
    });
  }
}

/* JavaScript href redirect for a full request/response; used
 * in the day / week / month views. */
function launch(loc,qstringArray) {
  var url = loc;
  if ((qstringArray != undefined) && (qstringArray.length > 0)) {
    for (var i=0; i < qstringArray.length; i++) {
      url += "&" + qstringArray[i];
    }
  }
  window.location.href = url;
}

/* The generic click handler for main navigation links that should have filters
 * dynamically appended to them. */
function bwRangeClickHandler(event) {
  event.preventDefault();
  var href = $(this).attr("href");
  href += "&date=" + $("#bwDatePickerInput").val().replace(/-/g,"");
  href += "&fexpr=" + bwMainEventList.getFilterExpression(bwFilters);
  launch(href);
}

/* The click handler for the upcoming link. */
function bwUpcomingClickHandler(event) {
  event.preventDefault();
  var href = $(this).attr("href");
  href += "&start=" + $("#bwDatePickerInput").val().replace(/-/g,"");
  launch(href);
}

/* The click handler for filters in the filter list.
   Allows us to remove filters from the list when a user clicks "x" */
function bwFilterClickHandler(event) {
  event.preventDefault();
  var curFilter = $(this).attr("href");
  var itemIndex = $.inArray(curFilter, bwFilters);
  if (itemIndex != -1) {
    bwFilters.splice(itemIndex, 1);
    bwFilterLabels.splice(itemIndex, 1);
  }

  // save the new state information:
  var qstring = new Array();
  qstring.push("setappvar=bwFilters(" + bwFilters.toString() + ")");
  qstring.push("setappvar=bwFilterLabels(" + bwFilterLabels.toString() + ")");

  // retrieve the filter expression:
  var fexpr = bwMainEventList.getFilterExpression(bwFilters);

  // refresh the list for the filters we have
  if (bwPage == "eventList") {
    refreshFilterList(bwCalFilterName,bwCalClearFilterMarkup);
    $(".bwMenuTree ul ul a[href=\"" + curFilter + "\"]").css("font-weight", "normal");
    var reqData = new Object;  // for refreshing the center event list
    reqData.fexpr = fexpr;
    sendAjax(qstring); // pass back the state parameters
    launchAjax(bwMainEventList, reqData); // refresh the bwMainEventList display
  } else { // day, week, month views
    var qstring = new Array();
    if (bwFilters.length == 0) { // we have no more filters
      qstring.push("viewName=All");
    } else { // we have filters
      qstring.push("fexpr=" + fexpr);
    }
    launch(bwUrls.setSelection, qstring); // full request / response - includes state parameters
  }
}

// Return the existing filters
function getCalFilters(filterList) {
  var filters = "";
  if (filterList != undefined && filterList.length) {
    filters += "(";
    $.each(filterList, function (i, value) {
      filters += "(vpath=\"" + value + "\")";
      if (i < bwFilters.length - 1) {
        filters += " or ";
      }
    });
    filters += ")";
  }
  return filters;
}

function addCalFilter(filter, label) {
  // user clicked on a topical area within an event
  // or a calendar from full listing
  var curFilter = filter;
  var curlabel = label;
  var itemIndex = $.inArray(curFilter, bwFilters);
  if (itemIndex != -1) {
    // it's already there; ignore.
  } else {
    bwFilters.push(curFilter);
    bwFilterLabels.push(curlabel);
  }
  var qstring = new Array();
  $.each(bwFilters, function (i, value) {
    qstring.push("vpath=" + value);
  });
  qstring.push("setappvar=bwFilters(" + bwFilters.toString() + ")");
  qstring.push("setappvar=bwFilterLabels(" + bwFilterLabels.toString() + ")");
  launch(bwUrls.setSelectionList, qstring);
}
