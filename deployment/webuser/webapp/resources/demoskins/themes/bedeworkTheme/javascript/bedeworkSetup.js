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

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

// jQuery global stuff : these functions are called on every page
// and should always be loaded.

$(document).ready(function() {

  // main "add..." button
  $("#bwAddButton").click (
    function () {
      $("#bwActionIcons-0").toggle("fast");
    }
  );
  $("#bwActionIcons-0").hover(
    function() {
      // do nothing on mouseover
    },
    function () {
      $("div.bwActionIcons").hide();
    }
  );

});
