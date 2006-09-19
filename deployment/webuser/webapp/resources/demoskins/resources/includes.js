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
  document.eventForm['eventStartDate.month'].value = month;
  document.eventForm['eventStartDate.day'].value = date;
  document.eventForm['eventStartDate.year'].value = year;
}
function endDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }

  document.eventForm['eventEndDate.month'].value = month;
  document.eventForm['eventEndDate.day'].value = date;
  document.eventForm['eventEndDate.year'].value = year;
}


// launch the calSelect pop-up window for selecting a calendar when creating,
// editing, and importing events
function launchCalSelectWindow(URL) {
  calSelect = window.open(URL, "calSelect", "width=500,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.calSelect.focus();
}
// used to update the calendar in an add or edit event form from
// the calSelect pop-up window.  We must do two things: update the hidden calendar
// input field and update the displayed text.
function updateEventFormCalendar(newCalPath,calDisplay) {
  if (window.opener.document.eventForm) {
    window.opener.document.eventForm.newCalPath.value = newCalPath;
    bwCalDisplay = window.opener.document.getElementById("bwEventCalDisplay");
    bwCalDisplay.innerHTML = calDisplay;
  } else {
    alert("The event form is not available.");
  }
  window.close();
}

// build the workdays parameter as a string when submitting user preferences form
function setWorkDays(formObj) {
  if (formObj) {
    var workDays = "";
    for (i=0; i<7; i++) {
      if (formObj.workDayIndex[i].checked) {
        workDays += "W";
      } else {
        workDays += " ";
      }
    }
    formObj.workDays.value = workDays;
  } else {
    alert("The preferences form is not available.");
  }
}

// build a uri based on user and path in the subscription form
function setSubscriptionUri(formObj) {
  if (formObj) {
    var fullUri = "bwcal:///user/";
    fullUri += formObj.userId.value;
    if (formObj.userPath.value != "") {
      if (formObj.userPath.value.substring(0,1) == "/") {
        fullUri += formObj.userPath.value;
      } else {
        fullUri += "/" + formObj.userPath.value;
      }
    }
    formObj.calUri.value = fullUri;
    return true;
  } else {
    alert("The subscription form is not available.");
    return false;
  }
}

function setScheduleHow(multibox) {
  var accessString = "";
  for (i=0; i<multibox.length; i++) {
    alert(mulitbox[i].value);
  }
}


/*var mouseX = 0;
var mouseY = 0;
window.document.onmousemove = getMousePosition();
function getMousePosition() {
  mouseX = event.clientX + document.body.scrollLeft;
  mouseY = event.clientY + document.body.scrollTop;
}*/

function bwDrag(id) {
  box = document.getElementById(id);
}
function bwDrop(id) {
  box = document.getElementById(id);
}

/****************************************/
/* AJAX-style asynchronous interactions */
/****************************************/

var req;

function postRecipientsAndAttendees(formId,urlActionPrefix,urlRenderPrefix) {
  formObj = document.getElementById(formId);

  var val = escape(formObj.raHolder.value);
  var isRecipient = formObj.recipient.checked;
  var isAttendee = formObj.attendee.checked;
  var role = formObj.role.value;
  var status = formObj.partstat.value;

  var postUrl = urlActionPrefix;
  postUrl += "&uri=" + val;
  if (isRecipient) {
    postUrl += "&recipient=yes";
  }
  if (isAttendee) {
    postUrl += "&attendee=yes&role=" + role + "&status=" + status;
  }

  if (window.XMLHttpRequest) {
    req = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    req = new ActiveXObject("Microsoft.XMLHTTP");
  }
  req.open("GET", postUrl, false);
  req.onreadystatechange = callback();
  req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  req.send(postUrl);

  /* return the data */
  var getUrl = urlRenderPrefix;
  req.open("GET", getUrl, false);
  req.onreadystatechange = callback();
}
function callback() {
  if (req.readyState == 4) {
    if (req.status == 200) {
      /*var recipients = req.responseXML.getElementsByTagName("recipients")[0];
      var attendees = req.responseXML.getElementsByTagName("attendees")[0];
      recipientList = document.getElementById("recipientList");
      attendeeList = document.getElementById("attendeeList");
      recipientList.innerHTML = recipients;
      attendeeList.innerHTML = attendeeList;*/
    }
  }
}
