function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
function swapAllDayEvent(obj) {
  allDayStartDateField = document.getElementById("allDayStartDateField");
  allDayEndDateField = document.getElementById("allDayEndDateField");
  if (obj.checked) {
    //lets keep it simple for now: just show or hide time fields
    changeClass('startTimeFields','invisible');
    changeClass('endTimeFields','invisible');
    changeClass('durationHrMin','invisible');
    allDayStartDateField.value = "on";
    allDayEndDateField.value = "on";
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
    allDayStartDateField.value = "off";
    allDayEndDateField.value = "off";
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

// launches new browser window with print-friendly version of page when
// print icon is clicked
function launchPrintWindow(URL) {
  printWindow = window.open(URL, "printWindow", "width=640,height=500,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes");
  window.printWindow.focus();
}

function startDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  if (year < today.getFullYear()) {
    alert("You may not create an event in a previous year.");
  } else {
    document.peForm['eventStartDate.month'].value = month;
    document.peForm['eventStartDate.day'].value = date;
    document.peForm['eventStartDate.year'].value = year;
  }
}
function endDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  if (year < today.getFullYear()) {
    alert("You may not create an event in a previous year.");
  } else {
    document.peForm['eventEndDate.month'].value = month;
    document.peForm['eventEndDate.day'].value = date;
    document.peForm['eventEndDate.year'].value = year;
  }
}
