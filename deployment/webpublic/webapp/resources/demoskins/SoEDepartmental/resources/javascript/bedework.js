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
function fillExportFields(formId) {
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

/*function init() {
  var exportWidget = dojo.widget.byId('bwCalendarExportWidget');
  exportWidget.hide();
}

dojo.addOnLoad(init);
*/
