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

var bwAutoCompleteOptions = {
  minChars: 0,
  width: 310,
  matchContains: false,
  autoFill: false,

  extraParams: {
    format: 'json'
  },

  dataType: 'json',

  /* override the parse function to map
     our carddav json object to the expected data
     structure for use with autocomplete */
  parse: function(data) {
    var parsed = [];
    data = data.microformats.vcard;
    for (var i = 0; i < data.length; i++) {
      dataRow = {
        fn: (data[i].fn.value)?data[i].fn.value:"",
        email: (data[i].email[0].value)?data[i].email[0].value:"",
        uri: (data[i].caladruri.value)?data[i].caladruri.value:"",
        type: (data[i].kind.value)?data[i].kind.value:""
      };
      parsed[i] = {
        data: dataRow,
        value: data[i].fn.value,
        result: data[i].email[0].value
      };
    }
    return parsed;
  },
  formatItem: function(item) {
      return " \"" + item.fn + "\" [" + item.email + "]";
  },

  formatMatch: function(item) {
      return " \"" + item.fn + "\" [" + item.email + "]";
  },
  formatResult: function(item) {
    return item.email;
  }
};

// carddavUrl supplied in bedeworkProperties.js
jQuery(document).ready(function($) {
  $('#bwRaUri').autocomplete(carddavUrl, bwAutoCompleteOptions)
});
