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

/** Maintain a local list of locations
 *
 * @constructor
 */
BwLocations = function() {
  this.url = "/ucal/location/all.gdo";
  this.data = "";
  this.locationNames = [];
};

BwLocations.prototype.getDisplayNames = function(flush) {

  var my = this;

  if (flush || this.data == "") {
    $.ajax({
      url: this.url,
      async: false
    })
    .done(function( data ) {
      my.data = data;
      for (i=0; i < my.data.length; i++) {
        my.locationNames[i] = my.data[i].address.value;
      }
      return my.locationNames;
    })
    .fail(function(){
      my.data = {"message" : "ajax error"};
      my.locationNames = ["lookup error"];
      return my.locationNames;
    })
  }

  return my.locationNames;
};

// Debug utility
function print_r(obj) {
  var str = '';
  if (typeof obj === 'object') {
    for (var prop in obj) {
      if (typeof obj[prop] === 'object') {
        str += '<div>[' + prop + '] => ' + typeof(obj) + '</div>';
        str += '<div style="margin-left:2em;">' + print_r(obj[prop]) + '</div>';
      } else {
        str += '<div>[' + prop + '] => ' + obj[prop] + '</div>';
      }
    }
  }
  return str;
}