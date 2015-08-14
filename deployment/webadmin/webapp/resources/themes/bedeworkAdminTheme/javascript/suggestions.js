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

// Set the status of a suggestion in the suggestion queue
//   status: "accept" or "reject"
//   actionPrefix: the action and event parameters
//   rowId: the id of the table row in which the call was made
function setSuggestionRowStatus(status,actionPrefix,rowId,emptyMsg) {
  // color the row first
  if (status == "accept") {
    $('#' + rowId).addClass('suggestion-accepted');
    $('#' + rowId).removeClass('suggestion-rejected');

  } else {
    $('#' + rowId).addClass('suggestion-rejected');
    $('#' + rowId).removeClass('suggestion-accepted');
  }

  $.ajax({
    type: 'GET',
    url: actionPrefix + '&' + status,
    dataType: "text",
    error: function(xobj,msg) {
      alert("Ajax error: " + msg);
      $('#' + rowId).removeClass('suggestion-accepted suggestion-rejected');
    }
  });

}

// Set the status of a suggestion from an event detail page
//   status: "accept" or "reject"
//   actionPrefix: the action and event parameters
//   redirect: url to redirect to (the suggestions queue)
function setSuggestionStatus(status,actionPrefix,redirect) {
  $.ajax({
    type: 'GET',
    url: actionPrefix + '&' + status,
    dataType: "text",
    success: function(){
      location.href = redirect;
    },
    error: function(xobj,msg) {
      alert("Ajax error: " + msg);
    }
  });
}