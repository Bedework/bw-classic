var tzTbl = {};

var tzsExpanded = [];

var tzsdebug = true;

/** Maintain a table of expanded timezone information
 *
 * @constructor
 */
TzHandler = function() {
  this.url = "/tzsvr";
  this.fetchingStatus = "FETCHING";
  this.errorStatus = "ERROR";
  this.okStatus = "OK";
};

TzHandler.prototype.get = function(tzid) {
  var exp = tzsExpanded[tzid];
  var thisTzHandler = this;

  if (exp != null) {
    return exp;
  }

  exp = new TzExpanded(tzid);
  tzsExpanded[tzid] = exp;

  //alert("about to fetch tz " + tzid);

  var tzreq = $.get(this.url, { "action": "expand", "tzid": tzid },
      function(data) {
        thisTzHandler.parseExpanded(data, tzid);
      })
      .error(function() {
        //alert("error");
        exp.status = errorStatus;
      });

  return exp;
};

TzHandler.prototype.waitFetch = function(tzid) {
  var exp = tzs.get(tzid);

  while (exp.status == tzs.fetchingStatus) {
    alert("Waiting for fetch - status=" + exp.status);
  }

  return exp;
};

var tzs = new TzHandler();

TzHandler.prototype.parseExpanded = function(data, tzid) {
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

function TzObservance(name, onset, from, to) {
  this.name = name;
  this.onset = onset;
  this.from = from;
  this.to = to;

  this.toString = function() {
    return name + ", " + onset + ", " + from + ", " + to + "<br />";
  };

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
};

TzExpanded.prototype.addObservance = function(name, onset, from, to) {
  this.observances.push(new TzObservance(name, onset, from, to));
};

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
};

TzExpanded.prototype.toString = function() {
  var out = this.tzid + "<br />";

  for (i in this.observances) {
    out = out + this.observances[i].toString();
  }

  return out;
};
