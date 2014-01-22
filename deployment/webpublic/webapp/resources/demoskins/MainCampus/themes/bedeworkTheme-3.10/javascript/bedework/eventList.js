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


// Bedework Event List

/* An event list
 * outputContainerId    String - id of output container
 * dataType             String - the kind of widget we are requesting,
 *                               either "html" or "json".
 *
 *    If json, additional formatting options (beyond those set in
 *    the themeSettings.xsl file) can be supplied when the list object
 *    is created. Json formatting and options are defined at the bottom
 *    of this file in the insertBwEvents() function.
 *
 *    If html, formatting options are set only by the themeSettings.xsl file,
 *    and formatting is defined in the widgetEventList.xsl file.
 *
 * options              Object - json list of options for display
 *                               (can be empty for html dataType)
 * filterPrefix         String - pass in any fexpr filters when first creating
 *                               the object, esp. if they already exist
 * startDate            String - the initial start date for the list - passed
 *                               in from Bedework global state to more easily
 *                               move between list and day/week/month views
 *
 * fetchUri             URI    - the URI for the primary ajax request
 * fetchNextUri         URI    - the URI to fetch the next page of event via ajax
 *
 *    The fetchUri and fetchNextUri values must be passed in - each list to be
 *    rendered must use its own back-end client, and you must create new paths
 *    in the web client's struts-config.xml file to create new clients (which
 *    requires a full rebuild).  At this time, only the main listing and the
 *    ongoing lists are supported.  We hope to make this more flexible in time.
 *
 * htmlDateContainerId  String - id of container for display of starting date at
 *                               the top of the html list; we get the fully
 *                               internationalized start date from the Bedework
 *                               back-end.
 */
function BwEventList(outputContainerID,dataType,options,startDate,filterPrefix,fetchUri,fetchNextUri,htmlDateContainerId,htmlCountContainerId) {
  this.outputContainerId = outputContainerID;
  this.dataType = dataType;
  this.options = options;
  this.startDate = startDate;
  this.fetchUri = fetchUri;
  this.fetchNextUri = fetchNextUri;
  this.htmlDateContainerId = htmlDateContainerId;
  this.htmlCountContainerId = htmlCountContainerId;
  this.skinName = "widget-html";
  this.events = "";
  this.fexprPrefix = filterPrefix;
  this.fexprSuffix = "(entity_type=\"event\"|entity_type=\"todo\")";
  this.fexpr = "";
  this.query = "";

  if (this.dataType == "json") {
    this.skinName = "widget-json-eventList";
  }

  if (this.fexprPrefix != undefined && this.fexprPrefix.length) {
    this.fexpr += this.fexprPrefix + " and ";
  }
  this.fexpr += this.fexprSuffix;

  this.requestData = {
    skinNameSticky: this.skinName,
    start: this.startDate,
    sort: "dtstart.utc:asc",
    fexpr: this.fexpr
  };

  this.display = function() {
    var me = this;
    $.ajax({
      url: this.fetchUri,
      data: this.requestData,
      type: "POST",
      dataType: this.dataType
    }).done(function(eventListObject) {
        me.setEvents(eventListObject);
        me.render();
    });
  }

  this.displayCount = function(countOutputId) {
    var list = this.events.bwEventList;
    //if ((list != undefined) && (list.resultSize != undefined)) {
      $(countOutputId).html("(" + list.resultSize + ")");
    //}
  }

  this.setEvents = function(eventsObj) {
    this.events = eventsObj;
  }

  this.appendEvents = function() {
    // this is done synchronously to avoid race conditions
    var me = this;
    var appendReqData = this.requestData;
    appendReqData.next = "next";
    $.ajax({
      url: this.fetchNextUri,
      data: appendReqData,
      type: "POST",
      async: false,
      dataType: this.dataType
    }).done(function(eventListObject) {
      me.setEvents(eventListObject);
      me.render("append");
    });
  }

  this.setRequestData = function(key,val) {
    this.requestData[key] = val;
  }

  this.getFilterExpression = function(filters) {
    var fexpr = this.fexprSuffix;
    // if we've been passed filters, build the full filter expression
    if (filters.length) {
      fexpr = "(";
      $.each(filters, function (i, value) {
        fexpr += "(vpath=\"" + value + "\")";
        if (i < filters.length - 1) {
          fexpr += " or ";
        }
      });
      fexpr += ") and " + bwMainEventList.fexprSuffix;
    }
    return fexpr;
  }

  this.setFexprSuffix = function(val) {
    this.fexprSuffix = val;
  }

  this.getFexprSuffix = function() {
    return this.fexprSuffix;
  }

  this.setQuery = function(val) {
    this.query = val;
  }

  this.getQuery = function() {
    return this.query;
  }

  /* action - optional string representing the kind of render we want.
              Values are "append" or "replace" (default action if not supplied) */
  this.render = function(action) {
    if (this.dataType == "html") {
      // we have an html data island
      insertBwHtmlEvents(this.outputContainerId,this.htmlDateContainerId,htmlCountContainerId,this.events,action);
    } else {
      // we have a json object - pass along javascript options and render it
      insertBwEvents(this.outputContainerId,this.events,this.options,action);
    }
  }
}

/* Insert Bedework calendar events list from an HTML data island.
   We simply embed what the server provides as a raw HTML widget.
   Includes social media icons and internationalization strings.
   ThemeSettings options are honored on the server before being delivered,
   although a few strings are passed into JavaScript variables in themeSettings.xsl
   for use below. */
function insertBwHtmlEvents(outputContainerID,dateContainerId,countContainerId,bwObject,action) {
  var outputContainer = document.getElementById(outputContainerID);
  var eventList = $(bwObject).find("div.bwWidgetBody");
  // Send the html object to the container:
  if (action == "append") {
    $(outputContainer).append(eventList);
  } else {
    // Full replacement
    $(outputContainer).html(eventList);
    // Set the starting date above the list
    var displayDate = $(bwObject).find("div.bwWidgetGlobals ul.bwwgCurrentDate li.bwwgCdLongDate").html();
    $("#" + dateContainerId).html(displayDate);
    var resultSize = $(bwObject).find("div.bwWidgetHeader span.bwwhResultSize").html();
    var resultSizeInt = Number(resultSize);
    var eventStr = bwStrEvents; // bwStrEvent comes from themeSettings.xsl
    if (resultSizeInt == 1) {
      eventStr = bwStrEvent;
    }
    $("#" + countContainerId).html(resultSize + " " + eventStr);
    $("#" + countContainerId).show();
  }
}

/* Insert Bedework calendar events list from a json feed.
   Does not include social media icon rendering. */
function insertBwEvents(outputContainerID,bwObject,options,action) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;
  var bwListOptions;

  var defaults = {
    title: 'Upcoming Events',
    showTitle: true,
    showCount: true,
    displayDescription: false,
    calendarServer: '',
    calSuiteContext: '/cal',
    listMode: 'byTitle', // values: 'byDate' or 'byTitle' - highlights the date or title first (sort is always by date)
    displayDayNameInList: false, // display Monday, Tuesday, Wednesday, etc.
    displayDayNameTruncated: true, // shorten day names to three characters 'Mon','Tue','Wed' etc
    displayEndDateInList: true,
    suppressStartDateInList: false,
    suppressEndDateInList: false,
    untilText: 'Ends',
    displayTimeInList: true,
    displayLocationInList: false,
    locationTitle: 'Location:',
    displayTopicalAreasInList: false,
    topicalAreasTitle: 'Topical Areas:',
    displayThumbnailInList: false,
    thumbWidth: 80,
    useFullImageThumbs: true,
    usePlaceholderThumb: false,
    eventImagePrefix: '/pubcaldav',
    resourcesRoot: '',
    displayEventDetailsInline: false,
    displayContactInDetails: true,
    displayCostInDetails: true,
    displayTagsInDetails: true,
    displayTimezoneInDetails: true,
    displayNoEventText: true,
    showTitleWhenNoEvents: true,
    noEventsText: 'No events to display',
    limitList: false,
    limit: 5
  };

  // merge in user-defined options
  if (typeof options == "object") {
    bwListOptions = $.extend(defaults, options);
  } else {
    bwListOptions = defaults;
  }

  // Check first to see if whe have events:
  if ((bwObject == undefined) ||
      (bwObject.bwEventList == undefined) ||
      (bwObject.bwEventList.events == undefined) ||
      (bwObject.bwEventList.events.length == 0)) {

    if (bwListOptions.showTitleWhenNoEvents) {
      output += "<h3 class=\"bwEventsTitle\">" + bwListOptions.title + "</h3>";
    }
    if (bwListOptions.displayNoEventText) {
      output += "<ul class=\"bwEventList\"><li>" + bwListOptions.noEventsText + "</li></ul>";
    }

  } else {
    // get events
    for (i = 0; i < bwObject.bwEventList.events.length; i++) {
      eventlist[eventIndex] = i;
      eventIndex++;
    }

    // GENERATE OUTPUT
    // This is where you may wish to customize the output.  To see what
    // fields are available for events, look at the json source file included
    // by the widget code.  The core formatting is done in formatDateTime()
    // and formatSummary()

    // The title is included because you may wish to hide it when
    // no events are present.
    if (bwListOptions.showTitle) {
      output += "<h3 class=\"bwEventsTitle\">";
      output += bwListOptions.title;
      if (bwListOptions.showCount) {
        output += " <span class=\"bwEventsCount\">(" + bwObject.bwEventList.resultSize + ")</span>";
      }
      output += "</h3>";
    }

    // Output the list
    output += "<ul class=\"bwEventList\">";

    // Now, iterate over the events:
    for(var i in eventlist){
      // stop if we've reached a limit on the number of events
      if(bwListOptions.limitList && bwListOptions.limit == i) {
        break;
      }

      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];

      // create the list item:
      if (event.status == "CANCELLED") {
        output += '<li class="bwStatusCancelled">';
      } else if (event.status == "TENTATIVE") {
        output += '<li class="bwStatusTentative">';
      } else {
        output += "<li>";
      }

      // event thumbnail
      if (bwListOptions.displayThumbnailInList) {
        output += formatBwThumbnail(event,bwListOptions);
      }

      // output date and summary either byDate first or byTitle first
      if (bwListOptions.listMode == 'byDate') {
        output += formatBwDateTime(event,bwListOptions);
        output += "<br/>"
        output += formatBwSummary(event,outputContainerID,i,bwListOptions);
      } else {
        output += formatBwSummary(event,outputContainerID,i,bwListOptions);
        output += "<br/>"
        output += formatBwDateTime(event,bwListOptions);
      }

      // add locations
      if (bwListOptions.displayLocationInList) {
        output += "<div class=\"bwLoc\">";
        output += "<span class=\"bwLocTitle\">" + bwListOptions.locationTitle + "</span> ";
        output += event.location.address + "</div>";
      }

      // add full description
      if (bwListOptions.displayDescription) {
        output += "<div class=\"bwEventDescription\"><p>";
        output += event.description.replace(/\n/g,'<br />');
        output += "</p></div>";
      }

      // add topical areas
      if (bwListOptions.displayTopicalAreasInList) {
        output += "<div class=\"bwTopicalAreas\">";
        output += "<span class=\"bwTaTitle\">" + bwListOptions.topicalAreasTitle + "</span> ";
        // iterate over the x-properties and pull out the aliases
        for (var j in event.xproperties) {
          if (event.xproperties[j]["X-BEDEWORK-ALIAS"] != undefined) {
            if (event.xproperties[j]["X-BEDEWORK-ALIAS"].parameters["X-BEDEWORK-PARAM-DISPLAYNAME"] != undefined) {
              output +=  event.xproperties[j]["X-BEDEWORK-ALIAS"].parameters["X-BEDEWORK-PARAM-DISPLAYNAME"];
              output += ", ";
            }
          }
        }
        // trim off the final ", " if we have one
        if (output.substr(output.length-2) == ", ") {
          output = output.substr(0,output.length-2);
        }
        output += "</div>";
      }
      output += "</li>";
    }
    output += "</ul>";
  }
  // Finally, send the output to the container:
  if (action == "append") {
    $(outputContainer).append(output);
  } else {
    outputContainer.innerHTML = output;
  }
}

function formatBwThumbnail(event,bwListOptions) {

  var output = "";
  var bwEventLink = "";
  var imgPrefix = "";
  var imgSrc = "";
  var imgObj;
  var thumbObj;

  // iterate over the x-properties to see if we have an image or a thumbnail
  for (var i in event.xproperties) {
    if (event.xproperties[i]["X-BEDEWORK-THUMB-IMAGE"] != undefined) {
      thumbObj = event.xproperties[i]["X-BEDEWORK-THUMB-IMAGE"];
    }
    if (event.xproperties[i]["X-BEDEWORK-IMAGE"] != undefined) {
      imgObj = event.xproperties[i]["X-BEDEWORK-IMAGE"];
    }
  }

  if (thumbObj != undefined) {
    // use the thumbnail image
    if (!thumbObj.values.text.startsWith('http')) {
      imgPrefix = bwListOptions.eventImagePrefix;
    }
    imgSrc = imgThumbPrefix + thumbObj.values.text;
  } else if (imgObj != undefined && bwListOptions.useFullImageThumbs) {
    // use the full image for thumbnail
    if (!imgObj.values.text.startsWith('http')) {
      imgPrefix = bwListOptions.eventImagePrefix;
    }
    imgSrc = imgPrefix + imgObj.values.text;
  } else if(bwListOptions.usePlaceholderThumb) {
    // use a placeholder thumbnail
    imgSrc = bwListOptions.resourcesRoot + "/images/placeholder.png";
  }

  // did we end up with an image?
  if (imgSrc != "") {
    bwEventLink = getBwEventLink(event,bwListOptions);
    output += "<a href=\"" + bwEventLink + "\">";
    output += "<img class=\"eventThumb img-responsive\" width=\"" + bwListOptions.thumbWidth + "\" src=\"" + imgSrc + "\" alt=\" + event.summary + \"/>";
    output += "</a>";
  }

  return output;
}

function formatBwDateTime(event,bwListOptions) {

  var output = "";
  output += "<span class=\"bwDateTime\">";

  if (bwListOptions.listMode == 'byDate') {
    output +="<strong>";
  }

  if (!bwListOptions.suppressStartDateInList) {
    // display the start date
    if (bwListOptions.displayDayNameInList) {
      if (bwListOptions.displayDayNameTruncated) {
        output += event.start.dayname.substr(0,3);
      } else {
        output += event.start.dayname;
      }
      output += ", ";
    }

    output += event.start.longdate;
    if ((event.start.allday == 'false') && bwListOptions.displayTimeInList) {
      output += " " + event.start.time;
    }
  }
  if (!bwListOptions.suppressEndDateInList) {
    if(bwListOptions.suppressStartDateInList) {
      output += bwListOptions.untilText + " ";
    }
    if (bwListOptions.displayEndDateInList) {
      if (event.start.shortdate != event.end.shortdate || bwListOptions.suppressStartDateInList) {
        if(!bwListOptions.suppressStartDateInList) {
          output += " - ";
        }
        if (bwListOptions.displayDayNameInList) {
          if (bwListOptions.displayDayNameTruncated) {
            output += event.end.dayname.substr(0,3);
          } else {
            output += event.end.dayname;
          }
          output += ", ";
        }
        output += event.end.longdate;
        if ((event.start.allday == 'false') && bwListOptions.displayTimeInList) {
          output += " " + event.end.time;
        }
      } else if ((event.start.allday == 'false') &&
          bwListOptions.displayTimeInList &&
          (event.start.time != event.end.time)) {
        // same date, different times
        output += " - " + event.end.time;
      }
    }
  }

  if (bwListOptions.listMode == 'byDate') {
    output +="</strong>";
  }
  output += "</span>";

  return output;
}

function formatBwSummary(event,outputContainerID,i,bwListOptions) {

  var output = "";
  output += "<span class=\"bwSummary\">";

  if (bwListOptions.listMode == 'byTitle') {
    output +="<strong>";
  }

  if (bwListOptions.displayEventDetailsInline) {
    // don't link back to the calendar - display event details in the widget
    output += "<a href=\"javascript:showBwEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a>";

  } else {
    // link back to the calendar
    var bwEventLink = getBwEventLink(event,bwListOptions);

    output += "<a href=\"" + bwEventLink + "\">" + event.summary + "</a>";
  }

  if (bwListOptions.listMode == 'byTitle') {
    output +="</strong>";
  }
  output += "</span>";

  return output;
}

function getBwEventLink(event,bwListOptions) {

  // Include the urlPrefix for links back to events in the calendar.
  var urlPrefix = bwListOptions.calendarServer + bwListOptions.calSuiteContext + "/event/eventView.do";

  // generate the query string parameters that get us back to the
  // event in the calendar:
  var eventQueryString = "?subid=" + event.subscriptionId;
  eventQueryString += "&amp;calPath=" + event.calPath;
  eventQueryString += "&amp;guid=" + event.guid;
  eventQueryString += "&amp;recurrenceId=" + event.recurrenceId;

  return urlPrefix + eventQueryString;
}

function showBwEvent(outputContainerID,eventId,bwListOptions) {
  // Style further with CSS

  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  // provide a shorthand reference to the event:
  var event = bwObject.bwEventList.events[eventId];

  // create the event
  output += "<h3 class=\"bwEventsTitle\">" + event.summary + "</h3>";

  output += "<div class=\"bwEventLogistics\">";

  // output date/time
  output += "<div class=\"bwEventDateTime\">";
  output += event.start.longdate;
  if ((event.start.allday == 'false') && bwListOptions.displayTimeInList) {
    output += " " + event.start.time;
    if ((event.start.timezone != event.end.timezone) &&
        bwListOptions.displayTimezoneInDetails) {
      output += " " + event.start.timezone;
    }
  }
  if (event.start.shortdate != event.end.shortdate) {
    output += " - ";
    output += event.end.longdate;
    if (event.start.allday == 'false') {
      output += " " + event.end.time;
      if (bwListOptions.displayTimezoneInDetails) {
        output += " " + event.end.timezone;
      }
    }
  } else if ((event.start.allday == 'false') &&
      (event.start.time != event.end.time)) {
    // same date, different times
    output += " - " + event.end.time;
    if (bwListOptions.displayTimezoneInDetails) {
      output += " " + event.end.timezone;
    }
  }
  output += "</div>";

  // output location
  output += "<div class=\"bwEventLoc\">";
  if (event.location.link != "") {
    output += "<a href=\""+ event.location.link + "\">" + event.location.address + "</a>";
  } else {
    output += event.location.address;
  }
  output += "</div>";

  // output description
  output += "<div class=\"bwEventDesc\">";
  output += event.description.replace(/\n/g,'<br />');
  output += "</div>";

  // output contact
  if (bwListOptions.displayContactInDetails) {
    output += "<div class=\"bwEventContact\">";
    if (event.contact.link != "") {
      output += "Contact: <a href=\"" + event.contact.link + "\">" + event.contact.name + "</a>";
    } else {
      output += "Contact: " + event.contact.name;
    }
    output += "</div>";
  }

  // output cost
  if (event.cost != "" && bwListOptions.displayCostInDetails) {
    output += "<div class=\"bwEventCost\">";
    output += "Cost: " + event.cost;
    output += "</div>";
  }

  // output tags (categories)
  if (event.categories != "" && bwListOptions.displayTagsInDetails) {
    output += "<div class=\"bwEventCats\">";
    output += "Tags: " + event.categories;
    output += "</div>";
  }

  // output link
  if (event.link != "") {
    output += "<div class=\"bwEventLink\">";
    output += "See: <a href=\"" + event.link + "\">" + event.link + "</a>";
    output += "</div>";
  }
  output += "</div>";

  // create a link back to the main view
  output += "<p class=\"bwEventsListLink\"><a href=\"javascript:insertBwEvents('" + outputContainerID + "')\">Return</a>";

  // Send the output to the container:
  outputContainer.innerHTML = output;
}

/* EVENT HANDLING */
/* List related browser event handling */
function bwScroll() {
  // append events if we scroll to the last pixel on the page
  if ($(window).scrollTop() > ($(document).height() - $(window).height() - 1)) {
    bwMainEventList.appendEvents();
  }
}