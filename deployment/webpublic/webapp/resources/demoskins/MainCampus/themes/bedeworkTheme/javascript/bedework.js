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

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
function toggleVisibility(id) {
  var item = document.getElementById(id);
  if ( item.style.display != 'none' ) {
    item.style.display = 'none';
  }
  else {
    item.style.display = '';
  }
  return false;
}
function fillExportFields(formObj) {
  var startDate = new Date();
  startDate = $("bwExportCalendarWidgetStartDate").datepicker("getDate");
  formObj["eventStartDate.year"].value = startDate.getFullYear();
  formObj["eventStartDate.month"].value = startDate.getMonth() + 1;
  formObj["eventStartDate.day"].value = startDate.getDate();

  var endDate = new Date();
  endDate = $("bwExportCalendarWidgetEndDate").datepicker("getDate");
  formObj["eventEndDate.year"].value = endDate.getFullYear();
  formObj["eventEndDate.month"].value = endDate.getMonth() + 1;
  formObj["eventEndDate.day"].value = endDate.getDate();
}
function showLink(urlString,title) {
  var linkWindow = window.open("", "linkWindow", "width=1100,height=100,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  linkWindow.document.open();
  linkWindow.document.writeln('<html><head><title>' + title + '</title>');
  linkWindow.document.writeln('<style type="text/css">body{padding: 1em; font-size: 12px; font-family: Arial,sans-serif;}th{text-align: left;}td{padding-left: 2em;}</style></head>');
  linkWindow.document.writeln('<body onload="document.getElementById(\'linkField\').select()"><strong>' + title + '</strong><br/>');
  linkWindow.document.writeln('<input type="text" value="' + urlString + '" size="170" id="linkField"/>');
  linkWindow.document.writeln('</body></html>');
  linkWindow.document.close();
  linkWindow.focus();
}
// Using the subscriptions tree for navigation (as defined in themeSettings.xsl).
// Get them and load them onto the page.
function loadSubscriptions(containerId,setSelectionAction,curPath) {
  var feederUrl = '/feeder/calendar/fetchPublicCalendars.do?skinName=widget-json-cals&setappvar=setSelectionAction(' + setSelectionAction + ')'; 
  $.getJSON(feederUrl, function(data) {
    var subsTree = '<ul>' + buildSubsTree(data.bwCals.calendars,true,curPath) + '</ul>';
    $(containerId).html(subsTree);
    $("#subsTree .subsTreeToggle").click(function() {
      $(this).parent("li").children("ul").toggle("fast");
    });
  });
}
function buildSubsTree(calObj,isRoot,curPath) {
  var subsTreeHtml = "";
  
  $.each(calObj,function(i) {
    if (this.calType < 2) { // show only calendars and folders
      if (isRoot) {
        subsTreeHtml += '<li><a href="' + this.calendarLink + '">All</a>';
      } else {
        // build the child tree
        if(this.children != undefined) {
          //alert(curPath + "\n" + decodeURI(this.virtualPath) + "\n" + curPath.indexOf(decodeURI(this.virtualPath)));
          // see if we have the selected item
          var itemClass = "";
          if (curPath == decodeURI(this.virtualPath)) {
            itemClass = ' class="hasChildren selected open"';
          } else if (curPath.indexOf(decodeURI(this.virtualPath)) > -1) {
            itemClass = ' class="hasChildren selectedPath open"';
          } else {
            itemClass = ' class="hasChildren closed"';
          }
          subsTreeHtml += '<li'+ itemClass +'><span class="subsTreeToggle">+</span>';
        } else {
          var itemClass = "";
          if (curPath == decodeURI(this.virtualPath)) {
            itemClass = ' class="selected"';
          }
          subsTreeHtml += '<li'+ itemClass +'>';
        }
        subsTreeHtml += '<a href="' + this.calendarLink + '">' + this.name + '</a>';
      }
      if(this.children != undefined) {
        subsTreeHtml += "<ul>";
        subsTreeHtml += buildSubsTree(this.children,false,curPath);
        subsTreeHtml += "</ul>";
      }
      subsTreeHtml += "</li>";
    }
  });
  
  return(subsTreeHtml);
}

// topLink is defined in themeSettings.xsl
$(document).ready(function(){
  $("#title-logoArea").click(function(){
    location.href = headerBarLink;
  });
  $(".additionalUnivClicker").click(function(){
    $("#additionalUnivSub").toggle("fast");
  });
  $(".additionalOptionsClicker").click(function(){
    $("#additionalOptionsSub").toggle("fast");
  });
});
