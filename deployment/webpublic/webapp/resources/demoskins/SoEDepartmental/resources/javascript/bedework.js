dojo.require("dojo.event.*");
dojo.require("dojo.widget.*");
dojo.require("dojo.widget.FloatingPane");
dojo.require("dojo.widget.DatePicker");

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
function launchExportWidget(formId,action,name,calPath) {
  var exportWidget = dojo.widget.byId('bwCalendarExportWidget');
  exportWidget.show();
  var formObj = document.getElementById(formId);
  formObj.calPath.value = calPath;
  formObj.contentName.value = name + '.ics';
  document.getElementById('bwCalendarExportWidgetCalName').innerHTML = name;
}
function fillExportFields(formObj) {
  var startDate = new Date();
  startDate = dojo.widget.byId("bwExportCalendarWidgetStartDate").getDate();
  formObj["eventStartDate.year"].value = startDate.getFullYear();
  formObj["eventStartDate.month"].value = startDate.getMonth() + 1;
  formObj["eventStartDate.day"].value = startDate.getDate();

  var endDate = new Date();
  endDate = dojo.widget.byId("bwExportCalendarWidgetEndDate").getDate();
  formObj["eventEndDate.year"].value = endDate.getFullYear();
  formObj["eventEndDate.month"].value = endDate.getMonth() + 1;
  formObj["eventEndDate.day"].value = endDate.getDate();
}
function hideWidget(id) {
  var widget = dojo.widget.byId(id);
  widget.hide();
}
function showLink(urlString) {
  var linkWindow = window.open("", "linkWindow", "width=1100,height=100,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  linkWindow.document.open();
  linkWindow.document.writeln('<html><head><title>Event Link</title>');
  linkWindow.document.writeln('<style type="text/css">body{padding: 1em; font-size: 12px; font-family: Arial,sans-serif;}th{text-align: left;}td{padding-left: 2em;}</style></head>');
  linkWindow.document.writeln('<body onload="document.getElementById(\'linkField\').select()"><strong>Event Link:</strong><br/>');
  linkWindow.document.writeln('<input type="text" value="' + urlString + '" size="170" id="linkField"/>');
  linkWindow.document.writeln('</body></html>');
  linkWindow.document.close();
  linkWindow.focus();
}
/*function init() {
  var widget = dojo.widget.byId("bwCalendarExportWidget");
}

dojo.addOnLoad(init);
*/
