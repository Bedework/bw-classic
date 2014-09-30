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

/**
 * Classes to model a CalDAV service using XHR requests.
 */

// Do an AJAX request
function Ajax(params) {
	$.extend(params, {
		processData : false,
		crossDomain: true,
		username: gSession.auth,
		password: gSession.auth
	});
	return $.ajax(params);
}

// A generic PROPFIND request
/**
 *
 * @param url
 * @param depth
 * @param props
 * @returns {*}
 * @constructor
 */
function Propfind(url, depth, props) {
	var nsmap = {};
	addNamespace("D", nsmap);

	var propstr = addElements(props, nsmap);

	return Ajax({
		url : url,
		type : "PROPFIND",
		contentType : "application/xml; charset=utf-8",
		headers : {
			"Prefer" : "return=minimal",
			"Depth" : depth
		},
		data : '<?xml version="1.0" encoding="utf-8" ?>' + '<D:propfind' + buildXMLNS(nsmap) + '>' + '<D:prop>' + propstr + '</D:prop>' + '</D:propfind>'
	});
}

// A calendar-query REPORT request for VPOLLs only
function PollQueryReport(url, props) {
	var nsmap = {};
	addNamespace("D", nsmap);
	addNamespace("C", nsmap);

	var propstr = addElements(props, nsmap);
	propstr += '<C:calendar-data content-type="application/calendar+json" />';

	return Ajax({
		url : url,
		type : "REPORT",
		contentType : "application/xml; charset=utf-8",
		headers : {
			"Prefer" : "return=minimal",
			"Depth" : "1"
		},
		data : '<?xml version="1.0" encoding="utf-8" ?>' +
			'<C:calendar-query' + buildXMLNS(nsmap) + '>' +
				'<D:prop>' + propstr + '</D:prop>' +
				'<C:filter>' +
					'<C:comp-filter name="VCALENDAR">' +
						'<C:comp-filter name="VPOLL" />' +
					'</C:comp-filter>' +
				'</C:filter>' +
			'</C:calendar-query>'
	});
}

/** A calendar-query REPORT request for VEVENTs or VTODOs in time-range, expanded
 *
 * @param url
 * @param start
 * @param end
 * @param events - true for events, false for tasks
 * @returns jquery XMLHttpRequest object
 * @constructor
 */
function TimeRangeExpandedSummaryQueryReport(url, start, end, events) {
	var nsmap = {};
	addNamespace("D", nsmap);
	addNamespace("C", nsmap);

  var compName;
  var endName;

  if (events) {
    compName = "VEVENT";
    endName = "DTEND";
  } else {
    compName = "VTODO";
    endName = "DUE";
  }

	return Ajax({
		url : url,
		type : "REPORT",
		contentType : "application/xml; charset=utf-8",
		headers : {
			"Prefer" : "return=minimal",
			"Depth" : "1"
		},
		data : '<?xml version="1.0" encoding="utf-8" ?>' +
			'<C:calendar-query' + buildXMLNS(nsmap) + '>' +
				'<D:prop>' +
				'<C:calendar-data content-type="application/calendar+json">' +
					'<C:expand start="' + start.getIcalUTC() + '" end="' + end.getIcalUTC() + '"/>' +
					'<C:comp name="VCALENDAR">' +
						'<C:allprop/>' +
						'<C:comp name="' + compName + '">' +
							'<C:prop name="UID"/><C:prop name="DTSTART"/><C:prop name="' + endName + '"/><C:prop name="DURATION"/><C:prop name="SUMMARY"/>' +
						'</C:comp>' +
					'</C:comp>' +
				'</C:calendar-data>' +
				'</D:prop>' +
				'<C:filter>' +
					'<C:comp-filter name="VCALENDAR">' +
						'<C:comp-filter name="' + compName + '">' +
							'<C:time-range start="' + start.getIcalUTC() + '" end="' + end.getIcalUTC() + '"/>' +
						'</C:comp-filter>' +
					'</C:comp-filter>' +
				'</C:filter>' +
			'</C:calendar-query>'
	});
}

// A freebusy POST request
function Freebusy(url, fbrequest) {
	return Ajax({
		url : url,
		type : "POST",
		contentType : "application/calendar+json; charset=utf-8",
		data : fbrequest.toString()
	});
}

// A calendar-user-search REPORT request
function UserSearchReport(url, cutype, text) {
	var nsmap = {};
	addNamespace("D", nsmap);
	addNamespace("C", nsmap);
  addNamespace("CD", nsmap);
	addNamespace("CS", nsmap);

  var reqData =
      '<?xml version="1.0" encoding="utf-8" ?>' +
//			+ '<CS:calendarserver-principal-search context="user"' + buildXMLNS(nsmap) + '>' + '<CS:search-token>' + xmlEncode(text) + '</CS:search-token>'
//			+ '<CS:limit><CS:nresults>20</CS:nresults></CS:limit>' + '<D:prop>' + '<D:displayname />' + '<C:calendar-user-address-set />' + '</D:prop>'
//			+ '</CS:calendarserver-principal-search>',
      '<D:principal-property-search' + buildXMLNS(nsmap) + '>';

  if (cutype != null) {
    reqData +=
        '<D:property-search>' +
        '<D:prop>' +
        '<C:calendar-user-type />' +
        '</D:prop>' +
        '<D:match>' + xmlEncode(cutype) + '</D:match>' +
        '</D:property-search>';
  }

  reqData +=
      '<D:property-search>' +
      '<D:prop>' +
      '<D:displayname />' +
      '</D:prop>' +
      '<D:match>' + xmlEncode(text) + '</D:match>' +
      '</D:property-search>' +
      '<D:prop>' +
      '<D:displayname />' +
      '<C:calendar-user-address-set />' +
      '<CD:address-data content-type="application/vcard+json" />' +
      '</D:prop>' +
//				'<D:apply-to-principal-collection-set />' +
      '</D:principal-property-search>';

	return Ajax({
		url : url,
		type : "REPORT",
		contentType : "application/xml; charset=utf-8",
		headers : {
			"Depth" : "0"
		},
		data : reqData
	});
}

// Multistatus response processing
MultiStatusResponse = function(response, parent_url) {
	this.response = response;
	this.parentURL = parent_url;
};

// Get property text value from the overall multistatus
MultiStatusResponse.prototype.getPropertyText = function(prop) {
	return this._getPropertyText($(this.response), prop, "D:multistatus/D:response/D:propstat/D:prop/");
};

// Get property href text value from the overall multistatus
MultiStatusResponse.prototype.getPropertyHrefTextList = function(prop) {
	return this._getPropertyHrefTextList($(this.response), prop, "D:multistatus/D:response/D:propstat/D:prop/");
};

// Get property text value from the specified response node
MultiStatusResponse.prototype.getResourcePropertyText = function(response_node, prop) {
	return this._getPropertyText(response_node, prop, "D:propstat/D:prop/");
};

// Get property href text value from the specified response node
MultiStatusResponse.prototype.getResourcePropertyHrefTextList = function(response_node, prop) {
	return this._getPropertyHrefTextList(response_node, prop, "D:propstat/D:prop/");
};

// Get property text value from the specified node
MultiStatusResponse.prototype._getPropertyText = function(node, prop, prefix) {
	return getElementText(node, prefix + prop);
};

// Get all property href text values as an array from the specified node
MultiStatusResponse.prototype._getPropertyHrefTextList = function(node, prop, prefix) {
	var items = findElementPath(node, prefix + prop + "/D:href");
	if (items.length == 0) {
		return null;
	} else {
		var results = [];
		$.each(items, function(index, item) {
			results.push(item.text());
		});
		return results;
	}
};

// Apply specified function to each response (other than the parent)
MultiStatusResponse.prototype.doToEachChildResource = function(doIt) {
	var items = findElementPath($(this.response), "D:multistatus/D:response");
	var msr = this;
	$.each(items, function(index, item) {
		var href = getElementText(item, "D:href");
		if (!compareURLs(href, msr.parentURL)) {
			doIt(href, item);
		}
	});
};

// Schedule response processing
ScheduleResponse = function(response) {
	this.response = response;
};

// Apply specified function to each recipient response
ScheduleResponse.prototype.doToEachRecipient = function(doIt) {
	var items = findElementPath($(this.response), "C:schedule-response/C:response");
	$.each(items, function(index, item) {
		doIt(getElementText(item, "C:recipient/D:href"), item);
	});
};

// A CalDAV session for a specific principal
CalDAVSession = function(user) {
	this.currentPrincipal = null;
	//this.host = "http://172.16.105.104:8080/ucaldav";
	//this.host = "https://cyrus.local:8543";
	this.host = "";

	if (user === undefined) {
		this.auth = null;
	} else {
		this.auth = user;
	}
};

// Setup session
CalDAVSession.prototype.init = function(whenDone) {
	this.currentUserPropfind(whenDone);
};

//gWellKnown = "/.well-known/caldav";
gWellKnown = "/ucal/caldav";
//gWellKnown = "/";

// Discover current principal from /.well-known/caldav, then load the principal data
CalDAVSession.prototype.currentUserPropfind = function(whenDone) {
	var session = this;
	Propfind(joinURLs(this.host, gWellKnown), "0", [
		"D:current-user-principal"
	]).done(function(response) {
		var msr = new MultiStatusResponse(response, gWellKnown);
		var href = msr.getPropertyText("D:current-user-principal/D:href");
		if (href == null) {
			alert("Could not determine current user.");
		} else {
			// Load the principal
			session.currentPrincipal = new CalDAVPrincipal(href);
			session.currentPrincipal.init(whenDone);
		}
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

var cuaddrVcards = {};

/** Search for calendar users matching a string
 *
 * @param item
 * @param cutype
 * @param whenDone
 */
CalDAVSession.prototype.calendarUserSearch = function(item, cutype, whenDone) {
//	UserSearchReport(joinURLs(this.host, "/principals/"), item).done(function(response) {
//		var msr = new MultiStatusResponse(response, "/principals/");
	var principalurl = this.currentPrincipal.url;
	UserSearchReport(joinURLs(this.host, gWellKnown + "/principals/"), cutype, item).done(function(response) {
		var msr = new MultiStatusResponse(response, principalurl);
		var results = [];
		msr.doToEachChildResource(function(url, response_node) {
			var cn = msr.getResourcePropertyText(response_node, "D:displayname");
			var cuaddr = CalDAVPrincipal.bestCUAddress(msr.getResourcePropertyHrefTextList(response_node, "C:calendar-user-address-set"));
			if (cuaddr) {
				results.push((cn ? cn + " " : "") + "<" + cuaddr + ">");
			}
      var jcard = msr.getResourcePropertyText(response_node, "CD:address-data");
      if (jcard !== null) {
        var carddata = jcal.fromString(jcard);
        cuaddrVcards[cuaddr] = new CardObject(cutype, cuaddr, carddata);
      }
		});

		if (whenDone) {
			whenDone(results.sort());
		}
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

// Represents a calendar user on the server
CalDAVPrincipal = function(url) {
	this.url = url;
	this.cn = null;
	this.home_url = null;
	this.inbox_url = null;
	this.outbox_url = null;
	this.calendar_user_addresses = [];
	this.default_address = null;
	this.poll_calendars = [];
	this.event_calendars = [];
  this.taskCalendars = [];
};

// Return the best calendar user address from the set. Prefer mailto over urn over anything else.
CalDAVPrincipal.bestCUAddress = function(cuaddress_set) {
	var results = $.grep(cuaddress_set, function(cuaddr, index) {
		return cuaddr.startsWith("mailto:");
	});
	if (results.length == 0) {
		results = $.grep(cuaddress_set, function(cuaddr, index) {
			return cuaddr.startsWith("urn:uuid:");
		});
	}

	if (results.length != 0) {
		return results[0];
	}
	return null;
};

// Load principal details for this user, then load all the calendars
CalDAVPrincipal.prototype.init = function(whenDone) {
		// Get useful properties
	var principal = this;
	Propfind(joinURLs(gSession.host, principal.url), "0", [
		"D:displayname", "C:calendar-home-set", "C:schedule-inbox-URL", "C:schedule-outbox-URL", "C:calendar-user-address-set"
	]).done(function(response) {
		var msr = new MultiStatusResponse(response, principal.url);
		principal.cn = msr.getPropertyText("D:displayname");
		principal.home_url = msr.getPropertyText("C:calendar-home-set/D:href");
		principal.inbox_url = msr.getPropertyText("C:schedule-inbox-URL/D:href");
		principal.outbox_url = msr.getPropertyText("C:schedule-outbox-URL/D:href");
		principal.calendar_user_addresses = msr.getPropertyHrefTextList("C:calendar-user-address-set");
		// Load the calendars
		principal.loadCalendars(whenDone);
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

// For a reload of all calendar data
CalDAVPrincipal.prototype.refresh = function(whenDone) {
	this.poll_calendars = [];
	this.event_calendars = [];
	this.loadCalendars(whenDone);
};

// The most suitable calendar user address for the user
CalDAVPrincipal.prototype.defaultAddress = function() {
	if (!this.default_address) {
		this.default_address = CalDAVPrincipal.bestCUAddress(this.calendar_user_addresses);
	}
	return this.default_address;
};

// Indicate whether the specified calendar-user-address matches the current user
CalDAVPrincipal.prototype.matchingAddress = function(cuaddr) {
	return this.calendar_user_addresses.indexOf(cuaddr) != -1;
};

/** Load all VPOLL, VEVENT and VTODO capable calendars for this user
 *
 * NOTE: we only seem to be looking at the first VEVENT collection
 *
 * @param whenDone
 */
CalDAVPrincipal.prototype.loadCalendars = function(whenDone) {
	var this_principal = this;
	Propfind(joinURLs(gSession.host, this.home_url), "1", [
		"D:resourcetype", "D:displayname", "D:add-member", "C:supported-calendar-component-set"
	]).done(function(response) {
		var msr = new MultiStatusResponse(response, this_principal.home_url);
		msr.doToEachChildResource(function(url, response_node) {
			if (!hasElementPath(response_node, "D:propstat/D:prop/D:resourcetype/D:collection")
				|| !hasElementPath(response_node, "D:propstat/D:prop/D:resourcetype/C:calendar"))
				return;

			// Separate out support for VPOLL and VEVENT
			var comps = findElementPath(response_node, "D:propstat/D:prop/C:supported-calendar-component-set/C:comp");
			var hasVpoll = false;
			var hasVevent = false;
      var hasVtodo = false;
			if (comps.length != 0) {
				$.each(comps, function(index, comp) {
					if (comp.attr("name") == "VPOLL") {
						hasVpoll = true;
					}
					if (comp.attr("name") == "VEVENT") {
						hasVevent = true;
					}
          if (comp.attr("name") == "VTODO") {
            hasVtodo = true;
          }
				});
			}

			// Build the calendar and assign to appropriate arrays
			var cal = new CalendarCollection(url);
			cal.displayname = getElementText(response_node, "D:propstat/D:prop/D:resourcetype/D:displayname")
			if (!cal.displayname) {
				cal.displayname = basenameURL(url);
			}
			cal.addmember = getElementText(response_node, "D:propstat/D:prop/D:add-member/D:href")
			if (hasVpoll) {
				this_principal.poll_calendars.push(cal);
			}
			if (hasVevent) {
				this_principal.event_calendars.push(cal);
			}
      if (hasVtodo) {
        this_principal.taskCalendars.push(cal);
      }
		});
		// Load the resources from all VPOLL calendars
		this_principal.loadResources(whenDone);
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

// Start loading all VPOLL resources
CalDAVPrincipal.prototype.loadResources = function(whenDone) {
	var principal = this;
	var process = [].concat(principal.poll_calendars);
	process.reverse();
	this.loadCalendarResources(whenDone, process);
};

// Iteratively load all resources from VPOLL calendars
CalDAVPrincipal.prototype.loadCalendarResources = function(whenDone, process) {
	var this_principal = this;
	var calendar = process.pop();
	calendar.loadResources(function() {
		if (process.length != 0) {
			this_principal.loadCalendarResources(whenDone, process);
		} else {
			this_principal.addResources(whenDone);
		}
	});
};

// After all resources are loaded, add each VPOLL to view controller
CalDAVPrincipal.prototype.addResources = function(whenDone) {

	// Scan each resource to see if it is organized or not
	$.each(this.poll_calendars, function(index1, calendar) {
		$.each(calendar.resources, function(index2, resource) {
			var poll = new Poll(resource);
			gViewController.addPoll(poll);
		})
	});
	if (whenDone) {
		whenDone();
	}
};

// Do a freebusy query for the specified user for the specified time range and indicate whether busy or not
CalDAVPrincipal.prototype.isBusy = function(user, start, end, whenDone) {
	var fbrequest = jcal.newCalendar();
	fbrequest.newProperty("method", "REQUEST");
	var fb = fbrequest.newComponent("vfreebusy", true);
	fb.newProperty(
		"organizer",
		this.defaultAddress(),
		{ "cn" : this.cn },
		"cal-address"
	);
	fb.newProperty(
		"attendee",
		user,
		{},
		"cal-address"
	);
	fb.newProperty(
		"dtstart",
		start.getIcalUTC(),
		{},
		"date-time"
	);
	fb.newProperty(
		"dtend",
		end.getIcalUTC(),
		{},
		"date-time"
	);

	Freebusy(
		joinURLs(gSession.host, this.outbox_url),
		fbrequest
  	).done(function(response) {
  		var sched = new ScheduleResponse(response);
  		var result = null;
  		sched.doToEachRecipient(function(url, response_node) {
  			var caldata = getElementText(response_node, "C:calendar-data");
  			if (caldata) {
  				caldata = jcal.fromString(caldata);
  				if (caldata.mainComponent().name() == "vfreebusy") {
  					// Any FREEBUSY property means busy sometime during the requested period
  					result = caldata.mainComponent().hasProperty("freebusy")
  				}
  			}
  		});

  		if (whenDone) {
  			whenDone(result)
  		}
  	}).fail(function(jqXHR, status, error) {
  		alert(status + error);
  	});
};

// Get a summary of events for the specified time-range
CalDAVPrincipal.prototype.eventsForTimeRange = function(start, end, whenDone) {
	var this_principal = this;
  var url = joinURLs(gSession.host, this.event_calendars[0].url);

	var tresqr = TimeRangeExpandedSummaryQueryReport(url,
      start, end,
      true);

  tresqr.done(function(response) {
		var results = [];
		var msr = new MultiStatusResponse(response, this_principal.event_calendars[0].url);
		msr.doToEachChildResource(function(url, response_node) {
			var caldata = jcal.fromString(msr.getResourcePropertyText(response_node, "C:calendar-data"));
			results.push(new CalendarObject(caldata));
		});
		if (whenDone) {
			whenDone(results);
		}

	}).fail(function(jqXHR, status, error) {
  		alert(status + error);
  	});
};

// A calendar collection on the server
CalendarCollection = function(url) {
	this.url = url;
	this.displayname = null;
	this.addmember = null;
	this.resources = [];
}

// Load a calendar's VPOLL resources
CalendarCollection.prototype.loadResources = function(whenDone) {
	var calendar = this;
	PollQueryReport(joinURLs(gSession.host, calendar.url), [
		"D:getetag"
	]).done(function(response) {
		var msr = new MultiStatusResponse(response, calendar.url);
		msr.doToEachChildResource(function(url, response_node) {
			var etag = msr.getResourcePropertyText(response_node, "D:getetag");
			var caldata = jcal.fromString(msr.getResourcePropertyText(response_node, "C:calendar-data"));
			calendar.resources.push(new CalendarResource(calendar, url, etag, caldata));
		});
		if (whenDone) {
			whenDone();
		}
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

// A calendar resource object
CalendarResource = function(calendar, url, etag, data) {
	this.calendar = calendar;
	this.url = url;
	this.etag = etag;
	this.object = (data instanceof CalendarObject ? data : new CalendarObject(data));
};

// Create a brand new poll and add to the default calendar
CalendarResource.newPoll = function(title) {
	// Add to calendar
	resource = new CalendarResource(gSession.currentPrincipal.poll_calendars[0], null, null, CalendarPoll.newPoll(title));
	resource.calendar.resources.push(resource);
	return resource;
};

// Save this resource to the server - might be brand new or an update
CalendarResource.prototype.saveResource = function(whenDone) {

	if (!this.object.changed())
		return;

	// Always set to accepted
	if (this.object.mainComponent().data.name() == "vpoll") {
		this.object.mainComponent().acceptInvite();
	}

  var thisRes = this;

	if (!this.url) {
		if (this.calendar.addmember) {
			// Do POST;add-member
			Ajax({
				context : this,
				url : joinURLs(gSession.host, this.calendar.addmember),
				type : "POST",
				contentType : "application/calendar+json; charset=utf-8",
				headers : {
					"Prefer" : "return=representation",
					"Accept" : "application/calendar+json"
				},
				data : this.object.toString()
			}).done(function(response, textStatus, jqXHR) {
				// Get Content-Location header as new url
				thisRes.url = jqXHR.getResponseHeader("Content-Location");

				// Check for returned data and ETag
				thisRes.etag = jqXHR.getResponseHeader("Etag");
				thisRes.object = new CalendarObject(response);

				if (whenDone) {
					whenDone();
				}

			}).fail(function(jqXHR, status, error) {
				alert(status + error);
			});

			return;
		}

		// Have to PUT a new resource
		this.url = joinURLs(this.calendar.url, this.data.getComponent("vpoll").getPropertyText("uid") + ".ics");
	}

	// Do conditional PUT
	Ajax({
		context : this,
		url : joinURLs(gSession.host, this.url),
		type : "PUT",
		contentType : "application/calendar+json; charset=utf-8",
		headers : {
			"Prefer" : "return=representation",
			"Accept" : "application/calendar+json"
		},
		data : this.object.toString()
	}).done(function(response, textStatus, jqXHR) {
		// Check for returned data and ETag
		thisRes.etag = jqXHR.getResponseHeader("Etag");
		thisRes.object = new CalendarObject(response);

		if (whenDone) {
			whenDone();
		}

	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

// Remove this resource from the server
CalendarResource.prototype.removeResource = function(whenDone) {
	if (!this.url) {
		if (whenDone) {
			whenDone();
		}
		return;
	}

  var thisRes = this;

  Ajax({
		context : this,
		url : joinURLs(gSession.host, this.url),
		type : "DELETE"
	}).done(function(response) {
		var index = thisRes.calendar.resources.indexOf(this);
		thisRes.calendar.resources.splice(index, 1);
		if (whenDone) {
			whenDone();
		}
	}).fail(function(jqXHR, status, error) {
		alert(status + error);
	});
};

/** A generic container for an iCalendar component
 *
 * @param caldata jcal or data for jcal
 * @param parent of this component
 */
CalendarComponent = function(caldata, parent) {
	this.data = (caldata instanceof jcal ? caldata : new jcal(caldata));
	this.parent = parent;
};

// Maintain a registry of component types so the right class can be created when parsing
CalendarComponent.createComponentType = {};

CalendarComponent.registerComponentType = function(name, cls) {
	CalendarComponent.createComponentType[name] = cls;
};

CalendarComponent.buildComponentType = function(caldata, parent) {
	return new CalendarComponent.createComponentType[caldata.name()](caldata, parent);
};

CalendarComponent.prototype.duplicate = function(parent) {
	if (parent === undefined) {
		parent = this.parent;
	}
	return CalendarComponent.buildComponentType(this.data.duplicate(), parent);
};

CalendarComponent.prototype.toString = function() {
	return this.data.toString();
};

// Tell component whether it has changed or not
CalendarComponent.prototype.changed = function(value) {
	if (value === undefined) {
		return this.parent ? this.parent.changed() : false;
	} else {
		if (this.parent) {
			this.parent.changed(value);
		}
	}
};

CalendarComponent.prototype.uid = function() {
	return this.data.getPropertyValue("uid");
};

CalendarComponent.prototype.isTask = function() {
  return this.data.isTask();
};

// Indicate whether this object is owned by the current user.
CalendarComponent.prototype.isOwned = function() {
	return gSession.currentPrincipal.matchingAddress(this.organizer());
};

CalendarComponent.prototype.organizer = function() {
	return this.data.getPropertyValue("organizer");
};

CalendarComponent.prototype.organizerDisplayName = function() {
	return new CalendarUser(this.data.getProperty("organizer"), this).nameOrAddress();
};

CalendarComponent.prototype.status = function() {
	return this.data.getPropertyValue("status");
};

CalendarComponent.prototype.summary = function(value) {
	if (value === undefined) {
		return this.data.getPropertyValue("summary");
	} else {
		if (this.summary() != value) {
			this.data.updateProperty("summary", value);
			this.changed(true);
		}
	}
};

/**
 *
 * @returns {JcalDtTime} representing the start time of the entity
 */
CalendarComponent.prototype.start = function() {
  if (this.startObj === undefined) {
    this.startObj = JcalDtTime.fromProperty(hour24, this.data.getProperty("dtstart"));
  }

  this.startObj.fieldType = "date";

  return this.startObj;
};

/**
 *
 * @returns {JcalDtTime} representing the end time of the entity
 */
CalendarComponent.prototype.end = function() {
  if (this.endObj !== undefined) {
    return this.endObj;
  }

  var pname = "dtend";
  if (this.isTask()) {
    pname = "due";
  }
  var dtend = this.data.getPropertyValue(pname);
  if (dtend !== null) {
    this.endObj = JcalDtTime.fromProperty(hour24, this.data.getProperty("dtend"));

    return this.endObj;
  }

  this.endObj = this.start().duplicateAs("end");

  var duration = this.data.getPropertyValue("duration");
  if (duration === null) {
    /* No dtend or duration -
       below is wrong - it's appropriate for DATE but for DATETIME
       it should be the same as the start,
       */
    if (this.endObj.allDay) {
      this.endObj.addDays(1);
    }
    this.endObj.fieldType = preferredEndType;
  } else {
    var offset = Jcalduration.parseText(duration).getTotalSeconds();
    this.endObj.addSeconds(offset);
    this.endObj.fieldType = "duration";
  }
  return this.endObj;
};

CalendarComponent.prototype.description = function(value) {
  if (value === undefined) {
    return this.data.getPropertyValue("description");
  } else {
    if (this.description() != value) {
      this.data.updateProperty("description", value);
      this.changed(true);
    }
  }
};

CalendarComponent.prototype.pollitemid = function(value) {
	if (value === undefined) {
		return this.data.getPropertyValue("poll-item-id");
	} else {
		if (this.politemid() != value) {
			this.data.updateProperty("poll-item-id", value);
			this.changed(true);
		}
	}
};

CalendarComponent.prototype.voter_responses = function() {
	var voter_results = {};
	$.each(this.data.properties("voter"), function(index, voter) {
		voter_results[voter[3]] = parseInt(voter[1]["response"]);
	});
	return voter_results;
};

// Change active user's response to this event
CalendarComponent.prototype.changeVoterResponse = function(response) {
	if (response !== null) {
		var matches = $.grep(this.data.properties("voter"), function(voter, index) {
			return gSession.currentPrincipal.matchingAddress(voter[3]);
		});
		if (matches.length == 1) {
			new CalendarUser(matches[0], this).response(response.toString());
		} else {
			this.data.newProperty(
				"voter",
				gSession.currentPrincipal.defaultAddress(),
				{ "response" : response.toString() },
				"cal-address"
			);
			this.changed(true);
		}
	} else {
		this.data.removePropertiesMatchingValue(function(propdata) {
			return propdata[0] == "voter" && gSession.currentPrincipal.matchingAddress(propdata[3]);
		});
	}
};

// A container class for VCALENDAR objects
CalendarObject = function(caldata) {
	CalendarComponent.call(this, caldata, null);
	this._changed = false;
};

CalendarObject.prototype = new CalendarComponent();
CalendarObject.prototype.constructor = CalendarObject;
CalendarComponent.registerComponentType("vcalendar", CalendarObject);

// A container class for VCARD objects
CardObject = function(cutype, cuaddr, carddata) {
  CalendarComponent.call(this, carddata, null);
  this._changed = false;
  this.cutype = cutype;
  this.cuaddr = cuaddr;
};

CardObject.prototype.cutype = function() {
  return this.cutype;
};

CardObject.prototype.cuaddr = function() {
  return this.cuaddr;
};

/**
 * If this is a group returns an array of members
 */
CardObject.prototype.members = function() {
};

CardObject.prototype = new CalendarComponent();
CardObject.prototype.constructor = CardObject;
CalendarComponent.registerComponentType("vcard", CardObject);

// This is the top-level object for changing tracking
CalendarObject.prototype.changed = function(value) {
	if (value === undefined) {
		return this._changed;
	} else {
		this._changed = value;
	}
};

// Get the main component type as one of our model classes
CalendarObject.prototype.mainComponent = function() {
	var main = this.data.mainComponent();
	return new CalendarComponent.buildComponentType(main, this);
};

// A container class for VPOLL objects
CalendarPoll = function(caldata, parent) {
	CalendarComponent.call(this, caldata, parent);
};

CalendarPoll.prototype = new CalendarComponent();
CalendarPoll.prototype.constructor = CalendarPoll;
CalendarComponent.registerComponentType("vpoll",  CalendarPoll);

// Create a brand new poll, defaulting various properties
CalendarPoll.newPoll = function(title) {
	var calendar = jcal.newCalendar();
	var vpoll = calendar.newComponent("vpoll", true);
	vpoll.newProperty("summary", title);
	vpoll.newProperty("poll-mode", "BASIC");
	vpoll.newProperty("poll-properties", ["DTSTART","DTEND"]);
	vpoll.newProperty(
		"organizer",
		gSession.currentPrincipal.defaultAddress(),
		{ "cn" : gSession.currentPrincipal.cn },
		"cal-address"
	);
	vpoll.newProperty(
		"voter",
		gSession.currentPrincipal.defaultAddress(),
		{
			"cn" : gSession.currentPrincipal.cn,
			"partstat" : "ACCEPTED"
		},
		"cal-address"
	);

	return new CalendarObject(calendar);
};

// Whether or not current user can make changes (depends on their role as owner too)
CalendarPoll.prototype.editable = function() {
	var status = this.status();
	return status ? status == "IN-PROCESS" : true;
};

CalendarComponent.prototype.pollwinner = function(value) {
	if (value === undefined) {
		return this.data.getPropertyValue("poll-winner");
	} else {
		if (this.pollwinner() != value) {
			this.data.updateProperty("poll-winner", value);
			this.changed(true);
		}
	}
};

CalendarComponent.prototype.ispollwinner = function() {
	var pollid = this.pollitemid();
	return pollid === undefined ? false : pollid == this.parent.pollwinner();
};

// Get an array of choices in the VPOLL
CalendarPoll.prototype.choices = function() {
	var this_vpoll = this;
	return $.map(this.data.getComponents(), function(compData, index) {
    var comp = new jcal(compData);

    var pi = comp.getPropertyValue("poll-item-id");
    if (pi === null) {
      return null;
    }

    if (comp.name() === "vevent") {
      return new CalendarEvent(comp, this_vpoll);
    }

    return new CalendarTask(comp, this_vpoll);
	});
};

// Get the designated choice
CalendarPoll.prototype.getChoice = function(itemId) {
  var comps = this.data.getComponents();
  for (var i = 0; i < comps.length; i++) {
    var comp = new jcal(comps[i]);

    var pi = comp.getPropertyValue("poll-item-id");
    if (pi === null) {
      continue;
    }

    if (parseInt(pi) === itemId) {
      if (comp.name() === "vevent") {
        return new CalendarEvent(comp, this);
      }

      return new CalendarTask(comp, this);
    }
  }

  return null;
};

/** Make a new choice for the VPOLL
 *
 * @param type
 * @param start
 * @param end
 * @returns {*}
 */
CalendarPoll.prototype.makeChoice = function(type, start, end) {
	//this.changed(true);
	var comp = makeJcal(type, true);

  var dtPars = {"tzid": defaultTzid};

  start.updateProperty(comp);
  end.updateProperty(comp, start);

	comp.newProperty("summary", this.summary());
	comp.newProperty("poll-item-id", this.nextPollItemId().toString());
	comp.newProperty(
		"voter",
		this.organizer(),
		{"response" : "80"},
		"cal-address"
	);

  comp.copyProperty("organizer", this.data);
  this.syncAttendees(comp);

  var choice;

  if (comp.isEvent()) {
    choice = new CalendarEvent(comp, this);
  } else {
    choice = new CalendarTask(comp, this);
  }

  choice.startObj = start;
  choice.endObj = end;

  return choice;
};

/** Get the next free poll-item-id
 *
 * @returns int
 */
CalendarPoll.prototype.nextPollItemId = function() {
  return this.data.nextPollItemId()
};

/** Save a choice in the VPOLL
 *
 * @param comp - the choice
 */
CalendarPoll.prototype.saveChoice = function(comp) {
  // May already be there
  if (this.getChoice(comp.pollitemid()) != null) {
    return;
  }

  this.data.addComponent(comp.data);
  this.changed(true);
};

// Get an array of voters in the VPOLL
CalendarPoll.prototype.voters = function() {
	var this_vpoll = this;
	return $.map(this.data.properties("voter"), function(voter) {
		return new CalendarUser(voter, this_vpoll);
	});
};

/** Add a voter to the VPOLL
 *
 * @returns {CalendarUser}
 */
CalendarPoll.prototype.addVoter = function() {
	this.changed(true);
	return new CalendarUser(this.data.newProperty("voter", "", {}, "cal-address"), this);
}

/** Remove nth voter from the VPOLL
 *
 * @returns {CalendarUser}
 */
CalendarPoll.prototype.removeVoter = function(index) {
  if (this.voters().length === 1) {
    alert("Must have at least 1 voter");
  }
  this.changed(true);
  this.data.removePropertyMatching("voter", index);
}

// Mark current user as accepted
CalendarPoll.prototype.acceptInvite = function() {
	if (!this.isOwned()) {
		var voters = $.grep(this.data.properties("voter"), function(voter) {
			return gSession.currentPrincipal.matchingAddress(voter[3]);
		});
		$.each(voters, function(index, voter) {
			voter[1]["partstat"] = "ACCEPTED";
			delete voter[1]["rsvp"];
		})
	}
};

/** Make component attendees match poll voters
 *
 * @param comp jcal object
 */
CalendarPoll.prototype.syncAttendees = function(comp) {
  if (comp == undefined) {
    // Do all choices
    var this_vpoll = this;

    // Flag this with an x-prop
    this.data.updateProperty("x-bw-syncattendees", "on");

    $.each(this.data.getComponents(), function(index, compData) {
      var comp = new jcal(compData);

      var pi = comp.getPropertyValue("poll-item-id");
      if (pi === null) {
        return;
      }

      this_vpoll.syncAttendees(comp);
    });
    return;
  }

  comp.removeProperties("attendee");
  $.each(this.data.properties("voter"), function(index, voter) {
    var attendee = comp.newProperty(
        "attendee",
        voter[3],
        {},
        "cal-address"
    );
    $.each(voter[1], function(key, value) {
      if (key == "cn") {
        attendee[1][key] = value
      }
    });
    if (gSession.currentPrincipal.matchingAddress(voter[3])) {
      attendee[1]["partstat"] = "ACCEPTED";
    } else {
      attendee[1]["partstat"] = "NEEDS-ACTION";
      attendee[1]["rsvp"] = "TRUE";
    }
  });
};

// An actual VEVENT object we can manipulate
CalendarEvent = function(caldata, parent) {
	CalendarComponent.call(this, caldata, parent);
};

CalendarEvent.prototype = new CalendarComponent();
CalendarEvent.prototype.constructor = CalendarEvent;
CalendarComponent.registerComponentType("vevent", CalendarEvent);

CalendarTask = function(caldata, parent) {
  CalendarComponent.call(this, caldata, parent);
};

CalendarTask.prototype = new CalendarComponent();
CalendarTask.prototype.constructor = CalendarTask;
CalendarComponent.registerComponentType("vtodo", CalendarTask);

// Duplicate this component as the poll winner
CalendarComponent.prototype.pickAsWinner = function() {
	// Adjust VPOLL to mark winner and set status
	var vpoll = this.parent;
	vpoll.data.updateProperty("status", "CONFIRMED");
	vpoll.data.newProperty("poll-winner", this.pollitemid());
	vpoll.changed(true);

  // Create the new event resource with voters mapped to attendees
  var calendar = new CalendarObject(jcal.newCalendar());

  var winner = this.duplicate();

  calendar.data.addComponent(winner.data);
  calendar.changed(true);

	return new CalendarResource(gSession.currentPrincipal.event_calendars[0], null, null, calendar);
};

// Get an array of attendees
CalendarComponent.prototype.attendees = function() {
  var thisComp = this;
  return $.map(this.data.properties("attendee"), function(attendee) {
    return new CalendarUser(attendee, thisComp);
  });
};

// Get an array of recurrence info
CalendarComponent.prototype.rrules = function() {
  return $.map(this.data.properties("rrule"), function(rrule) {
    return rrule;
  });
};

// Get an array of rdates
CalendarComponent.prototype.rdates = function() {
  return $.map(this.data.properties("rdate"), function(val) {
    return val;
  });
};

// Get an array of rdates
CalendarComponent.prototype.exdates = function() {
  return $.map(this.data.properties("exdate"), function(val) {
    return val;
  });
};

// An iCalendar calendar user (ORGANIZER/ATTENDEE/VOTER) property
CalendarUser = function(caldata, parent) {
	this.data = caldata;
	this.parent = parent;
};

// Get or set the user name and/or cu-address
/** update this from the value
 *
 * @param value
 */
CalendarUser.prototype.updateFrom = function(value) {
  this.data[1] = value.data[1];
  this.data[2] = value.data[2];
  this.data[3] = value.data[3];
};

// Get or set the user name and/or cu-address
CalendarUser.prototype.addressDescription = function(value) {
	if (value === undefined) {
		var cn = this.data[1]["cn"] ? this.data[1]["cn"] + " " : "";
		return addressDescription(cn, this.data[3]);
	}

  if (this.addressDescription() != value) {
    var splits = splitAddressDescription(value);
    if (splits[0]) {
      this.data[1]["cn"] = splits[0];
    } else {
      delete this.data[1]["cn"];
    }
    this.data[3] = splits[1];
    this.parent.changed(true);
  }
};

// Get or set the user cutype
CalendarUser.prototype.cutype = function(value) {
  var cur = this.data[1]["cutype"];

  if (value === undefined) {
    return cur;
  }

  // We don't want cutype present if it's default of individual
  var isDefault = value === "INDIVIDUAL";

  if (cur === undefined) {
    if (!isDefault) {
      this.data[1]["cutype"] = value;
    }
    return;
  }

  if (isDefault) {
    delete this.data[1]["cutype"];
    return;
  }

  this.data[1]["cutype"] = value;
};

// Get a suitable display string for this user
CalendarUser.prototype.nameOrAddress = function() {
	return this.data[1]["cn"] ? this.data[1]["cn"] : this.data[3];
};

CalendarUser.prototype.cuaddr = function() {
	return this.data[3];
};

// Get or set the voter response
CalendarUser.prototype.response = function(value) {
	if (value === undefined) {
		return this.data[1]["response"];
	} else {
		if (this.response != value) {
			this.data[1]["response"] = value;
			this.parent.changed(true);
		}
	}
};
