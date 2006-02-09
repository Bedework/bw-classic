function changeClass(id, newClass) {
  identity=document.getElementById(id);
  identity.className=newClass;
}
function swapAllDayEvent(obj) {
  if (obj.checked) {
    changeClass('startTimeFields','hidden');
    changeClass('endTimeFields','hidden');
    changeClass('noDuration','hidden');
    changeClass('endDateTime','shown');
    changeClass('endDuration','hidden');
    // set the end date time fields = start date time fields
    window.document.peForm.endType[0].checked = true;
    // window.document.peForm['eventEndDate.month'].value = window.document.peForm['eventStartDate.month'].value;
    // window.document.peForm['eventEndDate.day'].value = window.document.peForm['eventStartDate.day'].value;
    // window.document.peForm['eventEndDate.year'].value = window.document.peForm['eventStartDate.year'].value;
    // window.document.peForm['eventEndDate.hour'].value = window.document.peForm['eventStartDate.hour'].value;
    // window.document.peForm['eventEndDate.minute'].value = window.document.peForm['eventStartDate.minute'].value;
    // set the duration (hidden by default on first click of all day event checkbox) to 1 day
    window.document.peForm.durationType[0].checked = true;
    window.document.peForm['duration.day'].value = 1;
    window.document.peForm['duration.hour'].value = 0;
    window.document.peForm['duration.minute'].value = 0;
    window.document.peForm['duration.weeks'].value = 0;
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('noDuration','shown');
    changeClass('endDateTime','shown');
    changeClass('endDuration','hidden');
    window.document.peForm.endType[0].checked = true;
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
