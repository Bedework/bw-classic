var tzTbl = {}

var tzsExpanded = [];

var tzsdebug = true;

TzHandler = function() {
    this.fetchingStatus = "FETCHING";
    this.errorStatus = "ERROR";
    this.okStatus = "OK";
}

TzHandler.prototype.get = function(tzid, year) {
    var exp = tzsExpanded[tzid];

    if (exp != null) {
        if ((year == null) || exp.coversYear(year)) {
	        return exp;
        }
    }

    exp = new TzExpanded(tzid);
    tzsExpanded[tzid] = exp;

    alert("about to fetch tz " + tzid + " for year " + year);

    var tzreq = $.get("/tzsvr", { "action": "expand", "tzid": tzid, "start": year },
        function(data) {
            parseExpanded(data, tzid);
        })
        .error(function() {
            //alert("error");
            exp.status = errorStatus;
        });

    return exp;
}

TzHandler.prototype.waitFetch = function(tzid, year) {
    var exp = tzs.get(tzid, year);

    while (exp.status == tzs.fetchingStatus) {
        alert("Waiting for fetch - status=" + exp.status);
    }

    return exp;
}

var tzs = new TzHandler();

function parseExpanded(data, tzid) {
//	var json = $.parseJSON(data);

    //  alert("data=" + data);
    //alert("json=" + json);

    var exp = tzsExpanded[tzid];

    $.each(data.observances, function(index, single) {
        exp.addObservance(
            single["name"],
            single["onset"],
            single["utc-offset-from"],
            single["utc-offset-to"]);
    });

    exp.status = tzs.okStatus;
    //tzsExpanded[tzid] = exp;
}

/** Given a date and a tzid return the offset for that date
 *
 * @param date - json format date
 * @param tzid - name of timezone
 * @return null if unknown timezone otherwise offset in minutes
 */
function getOffset(date, tzid) {
  if (tzid == null) {
    return null;
	}

  var exptz = tzs.waitFetch(tzid, date.substring(0, 4));
  var offset = null;

  if ((exptz == null) || (exptz.status != tzs.okStatus)) {
	  return null;
  }

  var obs = exptz.findObservance(date);
  
  if (obs == null) {
    return null;
	}

  return obs.to / 60;
}

function TzObservance(name, onset, from, to) {
    this.name = name;
    this.onset = onset;
    this.from = from;
    this.to = to;

    this.toString = function() {
        var out = name + ", " + onset + ", " + from + ", " + to + "<br />";

        return out;
    }

    this.compare = function(thatone) {
        if (this.onset == thatone.onset) {
            return 0;
        }

        if (this.onset > thatone.onset) {
            return 1;
        }

        return -1;
    }
}

function tzObservanceCompare(thisone, thatone) {
    return thisone.compare(thatone);
}

TzExpanded = function(tzid) {
    this.observances = [];
    this.status = tzs.fetchingStatus;
    this.tzid = tzid;
    this.sortedObservances = null;
}

TzExpanded.prototype.addObservance = function(name, onset, from, to) {
    this.observances.push(new TzObservance(name, onset, from, to));
}

TzExpanded.prototype.coversYear = function(year) {
    if (this.sortedObservances == null) {
        this.sortedObservances = this.observances.sort(tzObservanceCompare);
    }

		if (year < this.sortedObservances[0].onset.substring(0, 4)) {
        return false;
    }

    var lastYear = $(this.sortedObservances).get(-1);
    return year <= lastYear;
}
    

TzExpanded.prototype.findObservance = function(dt) {
    if (this.sortedObservances == null) {
        this.sortedObservances = this.observances.sort(tzObservanceCompare);
    }

    for (i in this.sortedObservances) {
        if (dt > this.sortedObservances[i].onset) {
            return this.sortedObservances[i];
        }
    }

    return null;
}

TzExpanded.prototype.toString = function() {
    var out = this.tzid + "<br />";

    for (i in this.observances) {
        out = out + this.observances[i].toString();
    }

    return out;
}

