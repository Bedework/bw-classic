dojo.require("dojo.event.*");
dojo.require("dojo.widget.*");
dojo.require("dojo.widget.FloatingPane");
dojo.require("dojo.widget.DatePicker");

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
function launchExportWidget(formId,name,calPath) {
  var exportWidget = dojo.widget.byId('bwCalendarExportWidget');
  exportWidget.show();
  var formObj = document.getElementById(formId);
  formObj.calPath.value = calPath;
  formObj.contentName.value = name + '.ics';
  document.getElementById('bwCalendarExportWidgetCalName').innerHTML = name;
}
function fillExportFields(formId) {
   var formObj = document.getElementById(formId);
   formObj.eventStartDate.value = dojo.widget.byId('bwExportCalendarWidgetStartDate').getValue();
   formObj.eventEndDate.value = dojo.widget.byId('bwExportCalendarWidgetEndDate').getValue();
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
