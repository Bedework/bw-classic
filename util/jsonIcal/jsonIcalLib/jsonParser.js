/* 
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
*/

/** Bedework Json javascript functions
 *
 * @author William Gill       gillw3 - rpi.edu
 * @author Mike Douglass       douglm - rpi.edu
 * 
 */
var propInfo = { 
		   "CALSCALE" : {"cardinality": 1},
		   "METHOD" : {"cardinality": 1},
		   "PRODID" : {"cardinality": 1},
		   "VERSION" : {"cardinality": 1},
		   "ATTACH" : {"cardinality": 1},
		   "CATEGORIES" : {"cardinality": 1},
		   "CLASS" : {"cardinality": 1},
		   "COMMENT" : {"cardinality": 1},
		   "DESCRIPTION" : {"cardinality": 1},
		   "GEO" : {"cardinality": 1},
		   "LOCATION" : {"cardinality": 1},
		   "PERCENT-COMPLETE" : {"cardinality": 1},
		   "PRIORITY" : {"cardinality": 1},
		   "RESOURCES" : {"cardinality": 1},
		   "STATUS" : {"cardinality": 1},
		   "SUMMARY" : {"cardinality": 1},
		   "COMPLETED" : {"cardinality": 1},
		   "DTEND" : {"cardinality": 1},
		   "DUE" : {"cardinality": 1},
		   "DTSTART" : {"cardinality": 1},
		   "DURATION" : {"cardinality": 1},
		   "FREEBUSY" : {"cardinality": 1},
		   "TRANSP" : {"cardinality": 1},
		   "TZID" : {"cardinality": 1},
		   "TZNAME" : {"cardinality": 1},
		   "TZOFFSETFROM" : {"cardinality": 1},
		   "TZOFFSETTO" : {"cardinality": 1},
		   "TZURL" : {"cardinality": 1},
		   "ATTENDEE" : {"cardinality": 1},
		   "CONTACT" : {"cardinality": 1},
		   "ORGANIZER" : {"cardinality": 1},
		   "RECURRENCE-ID" : {"cardinality": 1},
		   "RELATED-TO" : {"cardinality": 1},
		   "URL" : {"cardinality": 1},
		   "UID" : {"cardinality": 1},
		   "EXDATE" : {"cardinality": 1},
		   "RDATE" : {"cardinality": 1},
		   "RRULE" : {"cardinality": 1},
		   "ACTION" : {"cardinality": 1},
		   "REPEAT" : {"cardinality": 1},
		   "TRIGGER" : {"cardinality": 1},
		   "CREATED" : {"cardinality": 1},
		   "DTSTAMP" : {"cardinality": 1},
		   "LAST-MODIFIED" : {"cardinality": 1},
		   "SEQUENCE" : {"cardinality": 1}
		   }

function JsonParser() {
	this.parse = function(val) {
		return this.parseComponent(val);
	};
	
	/* The value is a component object as a 3 element array
	 * [ <name>, <properties>, <components> ]
	 * 
	 * The name MUST be "vcalendar"
	 */
    this.parseComponent = function(val) {
    	var properties = this.parseProperties(val[1]);
    	var components = this.parseComponents(val[2]);
		
		return new Component(val[0], properties, components);
    };
    
    this.parseComponents = function(val) {
    	var components = new Array();
    	
    	for (var i in val) {
    		var carray = val[i];
    		
    		components.push(this.parseComponent(carray));
    	}
    	
    	return components;
    };
    
    this.parseProperties = function(val) {
    	var properties = new Array();
    	
    	for (var i in val) {
    		var parray = val[i];
    		parameters = this.parseParameters(parray[1]);
    		value = this.parseValue(parray[2]);
    		
    		properties.push(new Property(parray[0], parameters, value));
    	}
    	
    	return properties;
    };
    
    this.parseParameters = function(val) {
    	var parameters = new Array();
    	
    	for(var key in val){
    		parameters.push(new Parameter(key, val[key]));
    	}
    	
    	return parameters;
    };
    
    this.parseValue = function(val) {
    	var type = val[0];
    	
    	var valPart = new Array();

    	for (i = 1; i < val.length; i++) {
    		valPart.push(val[i]); 
        }

    	return new Value(type, valPart);
    };
};

function Component(name, properties, components) {
	this.name = name;
	this.properties = properties;
	this.components = components;
	
	//alert("Component: props=" + properties);
	
	this.findComponent = function(name) {
		for (i in this.components) {
			var comp = this.components[i]; 

			if (comp.name == name) {
				return comp;
			}
		}
		
		return null;
	}
	
	this.findProperty = function(name) {
		for (i in this.properties) {
			var prop = this.properties[i]; 

			if (prop.name == name) {
				return prop;
			}
		}
		
		return null;
	}
	
	this.toIcal = function() {
		var out = "BEGIN:" + name.toUpperCase() + "\n";
		
		for (i in this.properties) {
			var prop = this.properties[i]; 
			
		    out = out + prop.toIcal();
		}
		
		for (i in this.components) {
			var comp = this.components[i]; 
			
		    out = out + comp.toIcal();
		}
		
		out = out + "END:" + name.toUpperCase() + "\n";
		
		return out;
	}
};

function Property(name, parameters, value) {
	this.name = name;
	this.parameters = parameters;
	this.value = value;

	this.toIcal = function() {
		var out = name.toUpperCase();

		for (i in this.parameters) {
			var param = this.parameters[i]; 
			
			out = out + ";" + param.toIcal();
		}

		out = out + ":" + value.toIcal() + "\n";

		return out;
	}
	
	this.findParameter = function(name) {
		if (this.parameters == null) {
			return null;
		}
		
		for (var k in this.parameters) {
			var param = this.parameters[k];
			
			if (param.name == name) {
				return param.value;
			}
		}
		
		return null;
	}
};

function Parameter(name, value) {
	this.name = name;
	this.value = value;
	
	this.toIcal = function() {
		var out = name.toUpperCase();

		out = out + "=" + value;

		return out;
	}
};

function Value(type, val) {
	this.type = type;
	this.val = val;

	this.toIcal = function() {
		return val;
	}
};


