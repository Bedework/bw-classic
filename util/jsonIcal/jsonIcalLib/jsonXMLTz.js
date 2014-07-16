var tzTbl = {}

var tzs = new TzHandler();

var tzsExpanded = new Array();

var tzsdebug = true;

function TzHandler() {
	this.fetchingStatus = "FETCHING";
	this.errorStatus = "ERROR";
	this.okStatus = "OK";
	
	this.get = function(tzid) {
		var exp = tzsExpanded[tzid];

		if (exp != null) {
			if (tzsdebug) {
				alert("found tzid=" + tzid + " in table");
			}
			
			return exp;
		}
		
		exp = new TzExpanded(tzid);
		tzsExpanded[tzid] = exp;

		//alert("about to fetch tz " + tzid);
	  
		var tzreq = $.get("tzsvr", { "action": "expand", "tzid": tzid },
			function(data) {
				parseExpanded(data);
			})
			.error(function() { 
				alert("error"); 
				exp.status = errorStatus;
		   });
		
		return exp;
	}

	this.waitFetch = function(tzid) {
		var exp = tzs.get(tzid);
		
		while (exp.status == tzs.fetchingStatus) {
			alert("Waiting for fetch - status=" + exp.status);
		}
		
		return exp;
	}
} 

function parseExpanded(xml) {
	var tzid = $(xml).find("tzid").text();
	  
//	if (tzsdebug) {
//		alert("parseExpanded: tzid=" + tzid);
//        
//	    $("#tzstuff").append(tzid + "<br />");
//	}
	
	var exp = tzsExpanded[tzid];

	$(xml).find("observance").each(function() {
		exp.addObservance(
			$(this).find("name").text(),
			$(this).find("onset").text(),
			$(this).find("utc-offset-from").text(),
			$(this).find("utc-offset-to").text());
	  
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
	
function TzExpanded(tzid) {
	this.observances = new Array();
	this.status = tzs.fetchingStatus;
	this.tzid = tzid;
	this.sortedObservances = null;
	
	this.addObservance = function(name, onset, from, to) {
		this.observances.push(new TzObservance(name, onset, from, to));
	}
	
	this.findObservance = function(dt) {
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

	this.toString = function() {
	    var out = tzid + "<br />";

	    for (i in this.observances) {
	    	out = out + this.observances[i].toString();
	    }
	    
		return out;
	}
}	

