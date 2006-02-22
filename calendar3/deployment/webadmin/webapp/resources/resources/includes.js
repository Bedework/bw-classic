function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
function swapAllDayEvent(obj) {
  allDayField = document.getElementById("allDayField");
  if (obj.checked) {
    //lets keep it simple for now: just show or hide time fields
    changeClass('startTimeFields','invisible');
    changeClass('endTimeFields','invisible');
    changeClass('durationHrMin','invisible');
    allDayField.value = "on";
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
    allDayField.value = "off";
  }
}
function swapDurationType(type) {
  // get the components we need to manipulate
  daysDurationElement = document.getElementById("durationDays");
  hoursDurationElement = document.getElementById("durationHours");
  minutesDurationElement = document.getElementById("durationMinutes");
  weeksDurationElement = document.getElementById("durationWeeks");
  if (type == 'week') {
    weeksDurationElement.disabled = false;
    daysDurationElement.disabled = true;
    hoursDurationElement.disabled = true;
    minutesDurationElement.disabled = true;
  } else {
    daysDurationElement.disabled = false;
    hoursDurationElement.disabled = false;
    minutesDurationElement.disabled = false;
    // we are using day, hour, minute -- zero out the weeks.
    weeksDurationElement.value = "0";
    weeksDurationElement.disabled = true;
  }
}

// launch a simple window for displaying information; no header or status bar
function launchSimpleWindow(URL) {
  simpleWindow = window.open(URL, "simpleWindow", "width=800,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.simpleWindow.focus();
}
