function changeClass(id, newClass) {
  identity=document.getElementById(id);
  identity.className=newClass;
}
function swapAllDayEvent(obj) {
  if (obj.checked) {
    //lets keep it simple for now: just show or hide time fields
    changeClass('startTimeFields','hidden');
    changeClass('endTimeFields','hidden');
    changeClass('durationHrMin','hidden');
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
  }
}
function launchClockMap(url) {
  clockWindow = window.open(url, "clockWindow", "width=410,height=430,scrollbars=no,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.clockWindow.focus();
}
function closePopUps() {
  if (window.clockWindow) {
    window.clockWindow.close();
  }
}
function  getCalendarDescription(calId,defaultMessage) {
  div = document.getElementById("calendarDescription");
  if (calId == -1) {
    div.innerHTML = defaultMessage;
  } else {
    div.innerHTML = calId;
  }
}
