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

gProdID = "-//bedework.org//jcal v1//EN";

jcalparser = {
	PARSER_ALLOW : 0, 	// Pass the "suspect" data through to the object model
	PARSER_IGNORE : 1, 	// Ignore the "suspect" data
	PARSER_FIX: 2, 		// Fix (or if not possible ignore) the "suspect" data
	PARSER_RAISE: 3 	// Raise an exception
}

// Some clients escape ":" - fix
jcalparser.INVALID_COLON_ESCAPE_SEQUENCE = jcalparser.PARSER_FIX;

// Other escape sequences - raise
jcalparser.INVALID_ESCAPE_SEQUENCES = jcalparser.PARSER_RAISE;

// Some client generate empty lines in the body of the data
jcalparser.BLANK_LINES_IN_DATA = jcalparser.PARSER_FIX;

// Some clients still generate vCard 2 parameter syntax
jcalparser.VCARD_2_NO_PARAMETER_VALUES = jcalparser.PARSER_ALLOW;

// Use this to fix v2 BASE64 to v3 ENCODING=b - only PARSER_FIX or PARSER_ALLOW
jcalparser.VCARD_2_BASE64 = jcalparser.PARSER_FIX;

// Allow DATE values when DATETIME specified (and vice versa)
jcalparser.INVALID_DATETIME_VALUE = jcalparser.PARSER_FIX;

// Allow slightly invalid DURATION values
jcalparser.INVALID_DURATION_VALUE = jcalparser.PARSER_FIX;

// Truncate over long ADR and N values
jcalparser.INVALID_ADR_N_VALUES = jcalparser.PARSER_FIX;

// REQUEST-STATUS values with \; as the first separator or single element
jcalparser.INVALID_REQUEST_STATUS_VALUE = jcalparser.PARSER_FIX;

// Remove \-escaping in URI values when parsing - only PARSER_FIX or PARSER_ALLOW
jcalparser.BACKSLASH_IN_URI_VALUE = jcalparser.PARSER_FIX;

/** This class represent an icalendar object in json.
 * The top level is represented by an array with 3 elements:
 *
 * 1.  A string with the name of the iCalendar component, but in lowercase.
 *
 * 2.  An array of jCal properties as described in Section 3.4.
 *
 * 3.  An array of jCal components, representing the sub-components of
 * the component in question.
 *
 * @param caldata - the above 3 element array
 */
jcal = function(caldata) {
	this.caldata = caldata;
};

jcal.newCalendar = function() {
	var calendar = new jcal(["vcalendar", [], []]);
	calendar.newProperty("version", "2.0");
	calendar.newProperty("prodid", gProdID);
	return calendar;
};

jcal.fromString = function(data) {
	return new jcal($.parseJSON(data));
};

jcal.prototype.toString = function() {
	return JSON.stringify(this.caldata);
};

jcal.prototype.duplicate = function() {
	return new jcal($.parseJSON(this.toString()));
};

jcal.prototype.name = function() {
	return this.caldata[0];
};

jcal.prototype.isEvent = function() {
  return this.name() === "vevent";
};

jcal.prototype.isTask = function() {
  return this.name() === "vtodo";
};

// Return the primary (master) component
// TODO: currently ignores recurrence - i.e. assumes one top-level component only
jcal.prototype.mainComponent = function() {
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] != "vtimezone");
	});
	return (results.length == 1) ? new jcal(results[0]) : null;
};

function makeJcal(name, defaultProperties) {
  var jcomp = new jcal([name.toLowerCase(), [], []]);
  if (defaultProperties) {
    // Add UID and DTSTAMP
    jcomp.newProperty("uid", generateUUID());
    jcomp.newProperty("dtstamp", jcalTimestamp(), {}, "date-time");
  }
  return jcomp;
}

jcal.prototype.newComponent = function(name, defaultProperties) {
  return this.addComponent(makeJcal(name, defaultProperties));
};

jcal.prototype.addComponent = function(component) {
	this.caldata[2].push(component.caldata);
	return component;
};

// Get one component
jcal.prototype.getComponent = function(name) {
	name = name.toLowerCase();
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] == name);
	});
	return (results.length == 1) ? new jcal(results[0]) : null;
};

// Get all matching components
jcal.prototype.components = function(name) {
	name = name.toLowerCase();
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] == name);
	});
	return $.map(results, function(component, index) {
		return new jcal(component);
	});
};

// Get all components
jcal.prototype.getComponents = function() {
  return this.caldata[2];
};

// Get the next pollItemId
jcal.prototype.nextPollItemId = function() {
    var pid = 0;
    $.each(this.caldata[2], function(index, component) {
        var itemid = new jcal(component).getPropertyValue("poll-item-id");
        if (itemid != null) {
            if  (itemid > pid) {
                pid = itemid;
            }
        }
    });
    return pid + 1;
};

// Remove all matching components
jcal.prototype.removeComponents = function(name) {
	name = name.toLowerCase();
	this.caldata[2] = $.grep(this.caldata[2], function(comp, index) {
		return comp[0] != name;
	});
};

jcal.prototype.newProperty = function(name, value, params, value_type) {
	var prop = [name.toLowerCase(), params === undefined ? {} : params, value_type == undefined ? "text" : value_type];
	if (value instanceof Array) {
		$.each(value, function(index, single) {
			prop.push(single);
		});
	} else {
		prop.push(value);
	}
	this.caldata[1].push(prop);
	return prop;
};

jcal.prototype.copyProperty = function(name, component) {
	var propdata = component.getProperty(name);
	this.caldata[1].push([propdata[0], propdata[1], propdata[2], propdata[3]]);
	return propdata;
};

jcal.prototype.hasProperty = function(name) {
	var result = false;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, property) {
		if (property[0] == name) {
			result = true;
			return false;
		}
	});
	return result;
};

jcal.prototype.getProperty = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, property) {
		if (property[0] == name) {
			result = property;
			return false;
		}
	});
	return result;
};

jcal.prototype.getPropertyValue = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, propdata) {
		if (propdata[0] == name) {
			result = propdata[3];
			return false;
		}
	});
	return result;
};

jcal.prototype.updateProperty = function(name, value, params, value_type) {
	if (params === undefined) {
		params = {};
	}
	if (value_type === undefined) {
		value_type = "text";
	}
	var props = this.properties(name);
	if (props.length == 1) {
		props[0][1] = params;
		props[0][2] = value_type;
		props[0][3] = value;

		return props[0];
	} else if (props.length == 0) {
		return this.newProperty(name, value, params, value_type);
	}
};

jcal.prototype.properties = function(name) {
	return $.grep(this.caldata[1], function(propdata, index) {
		return propdata[0] == name;
	});
};

jcal.prototype.removeProperties = function(name) {
	name = name.toLowerCase();
	this.caldata[1] = $.grep(this.caldata[1], function(propdata, index) {
		return propdata[0] != name;
	});
};

// Remove properties for which test() returns true
jcal.prototype.removePropertiesMatching = function(test) {
	name = name.toLowerCase();
	this.caldata[1] = $.grep(this.caldata[1], function(propdata, index) {
		return !test(propdata);
	});
};

/**
 * @param hour24
 * @param name "start" or "end"
 * @param datePart string or moment
 * @param allDay
 * @param UTC
 * @param tzidPar
 * @param hours value appropriate for hour24 and am flags - for string datePart
 * @param minutes - for string datePart
 * @param am - for string datePart
 * @constructor
 */
JcalDtTime = function(hour24, name, datePart, allDay, UTC, tzidPar, hours, minutes, am) {
  this.hour24 = hour24;
  this.name = name;
  this.allDay = allDay;
  this.UTC = false;
  this.theTzid = null;
  this.fieldType = "date";
  if (name === "end") {
    this.fieldType = preferredEndType;
  }

  if (datePart === undefined) {
    return;
  }

  if (typeof datePart === "string") {
    this.moment = moment(datePart);

    if (!allDay) {
      this.moment.minutes(minutes);
      this.moment.hours(JcalDtTime.hour24(am, hours));
    }
  } else {
    // Presume a moment
    this.moment = datePart.clone();
  }

  if (!allDay) {
    this.UTC = UTC;
    this.tzid(tzidPar);
  }
};

/** Break up the date and time value to make it usable for form population
 *
 * @param hour24 true for 24 hour
 * @param dtProp valid date or date time property
 *               [name, params, type, value]
 */
JcalDtTime.fromProperty = function(hour24, dtProp) {
  var datePart = null;
  var timePart = null;
  var hours = null;
  var minutes = null;
  var UTC = false;
  var allDay = false;
  var am = false;

  var name;

  if (dtProp[0] === "dtstart") {
    name = "start";
  } else {
    name = "end";
  }

  // Why do I have to assign then use? Does not work otherwise
  var params = dtProp[1];
  var tzid = params.tzid;

//    this.type = dtProp[2];
  var dtTime = dtProp[3];

  if (dtTime.length > 10) {
    timePart = dtTime.substring(11, 19);
    datePart = dtTime.substring(0,10);
  } else {
    datePart = dtTime;
    allDay = true;
  }

  if (allDay) {
    return new JcalDtTime(hour24, name, datePart, true);
  }

  // Set the time fields.
  if ((dtTime.length > 19) && (dtTime.charAt(19) == 'Z')) {
    UTC = true;
  }

  hours = timePart.substring(0, 2);
  minutes = timePart.substring(3,5);

  if (!hour24) {
    var hoursInt = parseInt(hours);

    am = hoursInt < 12;
    if (hoursInt > 12) {
      hoursInt -= 12;
    } else if (hoursInt == 0) {
      hoursInt = 12;
    }

    hours = hoursInt;
  }

  return new JcalDtTime(hour24, name, datePart, false, UTC, tzid, hours, minutes, am);
};

/** Convert the hour value to a 24 hour val
 *
 * @param am true/false
 * @param hours int 1->12
 */
JcalDtTime.hour24 = function(am, hours) {
  if (am && (hours === 12)) {
    return 0;
  }

  if (hours > 12) {
    hours -= 12;
  }

  return hours;
};

JcalDtTime.now = function(hour24, name) {
  var mt = moment();

  mt.minutes(0);
  mt.seconds(0);

  return new JcalDtTime(hour24, name, mt, false, false, defaultTzid);
};

/** Update to reflect the values - switch to date mode.
 *
 * @param datePart string or moment
 * @param allDay
 * @param UTC
 * @param tzidPar
 * @param hours value appropriate for hour24 and am flags - for string datePart
 * @param minutes - for string datePart
 * @param am - for string datePart
 */
JcalDtTime.prototype.update = function(datePart, allDay, UTC, tzidPar, hours, minutes, am) {
  this.moment = moment(datePart, "YYYYMMDD");

  this.allDay = allDay;
  this.UTC = UTC;

  if (this.allDay) {
    return;
  }

  this.moment.minutes(minutes);
  this.moment.hours(JcalDtTime.hour24(am, hours));

  if (!this.UTC) {
    this.tzid(tzidPar);
  }
};

/** Update to reflect the values - switch to duration mode.
 *
 * @param duration a moment.duration object
 * @param start duration is from this
 */
JcalDtTime.prototype.updateFromDuration = function(duration, start) {
  this.allDay = start.allDay;
  this.UTC = start.UTC;

  this.moment = start.moment.clone();
  var offset = duration.asSeconds();
  this.addSeconds(offset);

  if (!this.UTC) {
    this.tzid(start.tzid);
  }
};

JcalDtTime.prototype.tzid = function(val) {
  if (val === undefined) {
    return this.theTzid;
  }

  this.theTzid = val;

  if (this.theTzid === null) {
    this.theTzid = defaultTzid;
  }

  if (this.theTzid === null) {
    // Can't set
  }

  var offset = tzs.getOffset(digits4(this.moment.year()), this.theTzid);

  /* Note the oddity with sign of timezone offset and
     UTC offset
     http://stackoverflow.com/questions/22275025/inverted-zone-in-moment-timezone
     */
  this.moment.utc().zone(-offset).local();
};

/**
 *
 * @param val - number of seconds
 * @returns moment
 */
JcalDtTime.prototype.addSeconds = function(val) {
  return this.moment.add('seconds', val);
};

/**
 *
 * @param val - number of hours
 * @returns moment
 */
JcalDtTime.prototype.addHours = function(val) {
  return this.moment.add('hours', val);
};

/**
 *
 * @param val - number of days
 * @returns moment
 */
JcalDtTime.prototype.addDays = function(val) {
  return this.moment.add('days', val);
};

JcalDtTime.prototype.getDate = function() {
  return this.moment.toDate();
};

/**
 *
 * @param val
 * @returns {*} int from 0-23
 */
JcalDtTime.prototype.hours = function(val) {
  return this.moment.hours(val);
};

/** Return a value suitable for date widgets. If hours24 return 0-23
 * otherwise adjusts for an am/pm style.
 *
 * Caller must call am() to determine the am/pm status
 *
 * @param val
 * @returns {*} 1-12 or 0-23
 */
JcalDtTime.prototype.hoursAmPm24 = function(val) {
  if (val === undefined) {
    var h = this.hours();

    if (this.hour24) {
      return h;
    }

    if (h > 12) {
      return h - 12;
    }

    if (h === 0) {
      return 12;
    }
  }
  return this.moment.hours(val);
};

JcalDtTime.prototype.minutes = function(val) {
  return this.moment.minutes(val);
};

JcalDtTime.prototype.seconds = function(val) {
  return this.moment.seconds(val);
};

JcalDtTime.prototype.milliseconds = function(val) {
  return this.moment.milliseconds(val);
};

JcalDtTime.prototype.am = function() {
  return this.moment.hours() < 12;
};

JcalDtTime.prototype.getPrintableTime = function() {
  if (this.hour24) {
    return this.moment.format("HH:mm")
  }
  return this.moment.format("h:mm:ss a");
};

JcalDtTime.prototype.getLocalizedDate = function() {
  return this.moment.format("LL");
};

JcalDtTime.prototype.getLocalizedShortDate = function() {
  return this.moment.format("ll");
};

/**
 *
 * @returns {String} yyyyMMdd[ThhmmssZ]
 */
JcalDtTime.prototype.getIcalUTC = function() {
  if (this.allDay) {
    return this.moment.format("YYYYMMDD");
  }

  var res = this.moment.utc().format("YYYYMMDD[T]HHmmss[Z]");
  this.moment.local(); // Switch back to local mode
  return res;
};

JcalDtTime.prototype.equals = function(other) {
  return this.milliseconds() === other.milliseconds();
};

JcalDtTime.prototype.dateEquals = function(other) {
  return this.getLocalizedShortDate() === other.getLocalizedShortDate();
};

/**
 * Return a correctly formatted date based on the field values
 */
JcalDtTime.prototype.getDatePart = function() {
  return this.moment.format("YYYY-MM-DD");
}

/**
 * Return a correctly formatted date/time based on the field values
 */
JcalDtTime.prototype.getDtval = function() {
  var datePart = this.getDatePart();
  if (this.allDay) {
    return datePart;
  }

  var res = datePart +
            "T" + digits2(this.hours()) + ":" + digits2(this.minutes()) + ":00";

  if (this.UTC) {
    res += "Z";
  }

  return res;
};

/**
 *
 * @param comp a jcal object
 * @param start a JcalDtTime object so we can calculate duration.
 */
JcalDtTime.prototype.updateProperty = function(comp, start) {
  var params;
  var type;

  if (this.fieldType === "duration") {
    var dur = moment.duration(this.moment.diff(start.moment, "seconds"), "seconds").toISOString();

    comp.updateProperty("duration", dur, {}, "duration");
    // May have switched from end to duration
    comp.removeProperties(this.pname(comp));

    return;
  }

  var val = this.getDtval();

  if (this.theTzid === null) {
    params = {};
  } else {
    params = {"tzid": this.theTzid};
  }

  if (this.allDay) {
    type = "date";
  } else {
    type = "date-time";
  }

  comp.updateProperty(this.pname(comp), val, params, type);
  if (this.name === "end") {
    comp.removeProperties("duration");
  }
};

JcalDtTime.prototype.pname = function(comp) {
  if (this.name === "start") {
    return "dtstart";
  }
  if (comp.isEvent()) {
    return "dtend";
  }

  return pname = "due";
};

JcalDtTime.prototype.duplicateAs = function(name) {
  var that = new JcalDtTime(this.hour24, name);
  that.UTC = this.UTC;
  that.allDay = this.allDay;
  that.theTzid = this.theTzid;
  that.moment = this.moment.clone();

  return that;
};

JcalDtTime.prototype.clone = function() {
  return this.duplicateAs(this.name);
};

/** 'static' date conversion
 *
 * @param date
 * @returns {string}
 */
JcalDtTime.jsDateToiCal = function(date) {
  return date.toISOString().substr(0, 19).replace(/\-/g, "").replace(/\:/g, "");
};

function digits2(val) {
  var i = parseInt(val);
  if (i > 9) {
    return val;
  }

  return "0" + i;
}

function digits4(val) {
  return ("000" + val).substr(-4);
}

function jcalTimestamp() {
  return new Date().toISOString().substr(0, 19);
}

// Duration utility functions
Jcalduration = function(duration) {

	if (duration === undefined) {
		this.mForward = true;

		this.mWeeks = 0;
		this.mDays = 0;

		this.mHours = 0;
		this.mMinutes = 0;
		this.mSeconds = 0;
	} else {
		this.setDuration(duration);
	}
};

Jcalduration.parseText = function(data) {
	var duration = new Jcalduration();
	duration.parse(data);
	return duration;
};

Jcalduration.prototype.getTotalSeconds = function() {
	return (this.mForward ? 1 : -1) * (this.mSeconds + (this.mMinutes + (this.mHours + (this.mDays + (this.mWeeks * 7)) * 24) * 60) * 60);
};

Jcalduration.prototype.setDuration = function(seconds) {
	this.mForward = seconds >= 0;

	var remainder = seconds;
	if (remainder < 0) {
		remainder = -remainder;
	}

	// Is it an exact number of weeks - if so use the weeks value, otherwise
	// days, hours, minutes, seconds
	if (remainder % (7 * 24 * 60 * 60) == 0) {
		this.mWeeks = remainder / (7 * 24 * 60 * 60);
		this.mDays = 0;

		this.mHours = 0;
		this.mMinutes = 0;
		this.mSeconds = 0;
	} else {
		this.mSeconds = remainder % 60;
		remainder -= this.mSeconds;
		remainder /= 60;

		this.mMinutes = remainder % 60;
		remainder -= this.mMinutes;
		remainder /= 60;

		this.mHours = remainder % 24;
		remainder -= this.mHours;

		this.mDays = remainder / 24;

		this.mWeeks = 0;
	}
}

Jcalduration.prototype.parse = function(data) {
	// parse format ([+]/-) "P" (dur-date / dur-time / dur-week)
	try {
		var offset = 0;
		var maxoffset = data.length;

		// Look for +/-
		this.mForward = true;
		if (data[offset] == '+') {
			this.mForward = true;
			offset += 1;
		} else if (data[offset] == '-') {
			this.mForward = false;
			offset += 1;
		}

		// Must have a 'P'
		if (data[offset] != "P")
			throw "Invalid duration";
		offset += 1;

		// Look for time
		if (data[offset] != "T") {
			// Must have a number
			var strnum = data.strtoul(offset);
			var num = strnum.num;
			offset = strnum.offset;

			// Now look at character
			if (data[offset] == "W") {
				// Have a number of weeks
				this.mWeeks = num;
				offset += 1;

				// There cannot be anything else after this so just exit
				if (offset != maxoffset) {
					if (ParserContext.INVALID_DURATION_VALUE != ParserContext.PARSER_RAISE)
						return;
					throw "Invalid duration";
				}
				return;
			} else if (data[offset] == "D") {
				// Have a number of days
				this.mDays = num;
				offset += 1;

				// Look for more data - exit if none
				if (offset == maxoffset)
					return;

				// Look for time - exit if none
				if (data[offset] != "T")
					throw "Invalid duration";
			} else {
				// Error in format
				throw "Invalid duration";
			}
		}

		// Have time
		offset += 1;

		// Strictly speaking T must always be followed by time values, but some clients
		// send T with no additional text
		if (offset == maxoffset) {
			if (jcalparser.INVALID_DURATION_VALUE == jcalparser.PARSER_RAISE)
				throw "Invalid duration";
			else
				return;
		}
		var strnum = data.strtoul(offset);
		var num = strnum.num;
		offset = strnum.offset;

		// Look for hour
		if (data[offset] == "H") {
			// Get hours
			this.mHours = num;
			offset += 1;

			// Look for more data - exit if none
			if (offset == maxoffset)
				return;

			// Parse the next number
			strnum = data.strtoul(offset);
			num = strnum.num;
			offset = strnum.offset;
		}

		// Look for minute
		if (data[offset] == "M") {
			// Get hours
			this.mMinutes = num;
			offset += 1;

			// Look for more data - exit if none
			if (offset == maxoffset)
				return;

			// Parse the next number
			strnum = data.strtoul(offset);
			num = strnum.num;
			offset = strnum.offset;
		}

		// Look for seconds
		if (data[offset] == "S") {
			// Get hours
			this.mSeconds = num;
			offset += 1;

			// No more data - exit
			if (offset == maxoffset)
				return;
		}

		throw "Invalid duration";
	} catch(err) {
		throw "Invalid duration";
	}
}

Jcalduration.prototype.generate = function(self, os) {
	var result = "";

	if (!this.mForward && (this.mWeeks || this.mDays || this.mHours || this.mMinutes || this.mSeconds)) {
		result += "-";
	}
	result += "P";

	if (this.mWeeks != 0) {
		result += this.mWeeks + "W";
	} else {
		if (this.mDays != 0) {
			result += this.mDays + "D";
		}

		if (this.mHours != 0 || this.mMinutes != 0 || this.mSeconds != 0) {
			result += "T";

			if (this.mHours != 0) {
				result += this.mHours + "H";
			}

			if ((this.mMinutes != 0) || ((this.mHours != 0) && (this.mSeconds != 0))) {
				result += this.mMinutes + "M";
			}

			if (this.mSeconds != 0) {
				result += this.mSeconds + "S";
			}
		} else if (this.mDays == 0) {
			result += "T0S";
		}
	}

	return result;
}
