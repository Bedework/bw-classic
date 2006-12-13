function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
// show hide items using a checkbox
function swapVisible(obj,id) {
  if (obj.checked) {
    changeClass(id,'shown');
  } else {
    changeClass(id,'invisible');
  }
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
function swapFloatingTime(obj) {
  startTimezone = document.getElementById("startTzid");
  endTimezone = document.getElementById("endTzid");
  startFloating = document.getElementById("startFloating");
  endFloating = document.getElementById("endFloating");
  if (obj.checked) {
    document.getElementById("storeUTCFlag").checked = false;
    startTimezone.disabled = true;
    endTimezone.disabled = true;
    startFloating.value = "on";
    endFloating.value = "on";
  } else {
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startFloating.value = "off";
    endFloating.value = "off";
  }
}
function swapStoreUTC(obj) {
  startTimezone = document.getElementById("startTzid");
  endTimezone = document.getElementById("endTzid");
  startStoreUTC = document.getElementById("startStoreUTC");
  endStoreUTC = document.getElementById("endStoreUTC");
  if (obj.checked) {
    document.getElementById("floatingFlag").checked = false;
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startStoreUTC.value = "on";
    endStoreUTC.value = "on";
  } else {
    startStoreUTC.value = "off";
    endStoreUTC.value = "off";
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
function swapRecurrence(obj) {
  if (obj.checked) {
    changeClass('recurrenceFields','dateStartEndBox');
    changeClass('recurrenceUiSwitch','shown');
  } else {
    changeClass('recurrenceFields','invisible');
    changeClass('recurrenceUiSwitch','invisible');
  }
}
// reveal and hide recurrence fields
function showRecurrence(freq) {
  changeClass('recurrenceUntilRules','shown');

  if (freq == 'NONE') {
    changeClass('noneRecurrenceRules','shown');
    changeClass('recurrenceUntilRules','invisible');
  } else {
    changeClass('noneRecurrenceRules','invisible');
  }
  if (freq == 'HOURLY') {
    changeClass('hourlyRecurrenceRules','shown');
  } else {
    changeClass('hourlyRecurrenceRules','invisible');
  }
  if (freq == 'DAILY') {
    changeClass('dailyRecurrenceRules','shown');
  } else {
    changeClass('dailyRecurrenceRules','invisible');
  }
  if (freq == 'WEEKLY') {
    changeClass('weeklyRecurrenceRules','shown');
  } else {
    changeClass('weeklyRecurrenceRules','invisible');
  }
  if (freq == 'MONTHLY') {
    changeClass('monthlyRecurrenceRules','shown');
  } else {
    changeClass('monthlyRecurrenceRules','invisible');
  }
  if (freq == 'YEARLY') {
    changeClass('yearlyRecurrenceRules','shown');
  } else {
    changeClass('yearlyRecurrenceRules','invisible');
  }
}
function recurSelectWeekends(id) {
  chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value == 'SU' || chkBoxCollection[i].value == 'SA') {
           chkBoxCollection[i].checked = true;
        } else {
          chkBoxCollection[i].checked = false;
        }
      }
    }
  }
}
function recurSelectWeekdays(id) {
  chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value == 'SU' || chkBoxCollection[i].value == 'SA') {
           chkBoxCollection[i].checked = false;
        } else {
          chkBoxCollection[i].checked = true;
        }
      }
    }
  }
}
function selectRecurCountUntil(id) {
  document.getElementById(id).checked = true;
}
// Assemble the recurrence rules if recurrence is specified.
// Request params to set ('freq' is always set):
// interval, count, until (count OR until, not both)
// possibly: byday, bymonthday, bymonth, byyearday
function setRecurrence(formObj) {
  if (formObj.recurrenceFlag.checked) {
    var freq = getSelectedRadioButtonVal(formObj.freq);
    if (freq != 'NONE') {
      // build up recurrence rules
      switch (freq) {
        case "DAILY":
          var bymonth = new Array();
          // get the bymonth values
          bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('dayMonthCheckBoxList').getElementsByTagName('input'),false);
          // set the form values
          formObj.bymonth.value = bymonth.join(',');
          formObj.interval.value = formObj.dailyInterval.value;
          break;
        case "WEEKLY":
          var byday = new Array();
          byday = collectRecurChkBoxVals(byday, document.getElementById('weekRecurFields').getElementsByTagName('input'),false);
          formObj.byday.value = byday.join(',');
          formObj.wkst.value = formObj.weekWkst[formObj.weekWkst.selectedIndex].value;
          formObj.interval.value = formObj.weeklyInterval.value;
          break;
        case "MONTHLY":
          var i = 1;
          var monthByDayId = 'monthRecurFields' + i;
          var byday = new Array();
          var bymonthday = new Array();
          var byyearday = new Array();
          // get the byday values
          while (document.getElementById(monthByDayId)) {
            var monthFields = document.getElementById(monthByDayId);
            var dayPosSelect = monthFields.getElementsByTagName('select');
            var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
            if (dayPos) {
              byday = collectRecurChkBoxVals(byday,monthFields.getElementsByTagName('input'),dayPos);
            }
            monthByDayId = monthByDayId.substring(0,monthByDayId.length-1) + ++i;
          }
          // get the bymonthday values
          bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('monthDaysCheckBoxList').getElementsByTagName('input'),false);
          // set the form values
          formObj.byday.value = byday.join(',');
          formObj.bymonthday.value = bymonthday.join(',');
          formObj.interval.value = formObj.monthlyInterval.value;
          break;
        case "YEARLY":
          var i = 1;
          var yearByDayId = 'yearRecurFields' + i;
          var byday = new Array();
          var bymonthday = new Array();
          var bymonth = new Array();
          var byweekno = new Array();
          var byyearday = new Array();
          // get the byday values
          while (document.getElementById(yearByDayId)) {
            var yearFields = document.getElementById(yearByDayId);
            var dayPosSelect = yearFields.getElementsByTagName('select');
            var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
            if (dayPos) {
              byday = collectRecurChkBoxVals(byday,yearFields.getElementsByTagName('input'),dayPos);
            }
            yearByDayId = yearByDayId.substring(0,yearByDayId.length-1) + ++i;
          }
          // get the bymonth values
          bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('yearMonthCheckBoxList').getElementsByTagName('input'),false);
          // get the bymonthday values
          bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('yearMonthDaysCheckBoxList').getElementsByTagName('input'),false);
          // get the byweekno values
          byweekno = collectRecurChkBoxVals(byweekno,document.getElementById('yearWeeksCheckBoxList').getElementsByTagName('input'),false);
          // get the byyearday values
          byyearday = collectRecurChkBoxVals(byyearday,document.getElementById('yearDaysCheckBoxList').getElementsByTagName('input'),false);

          // set the form values
          formObj.byday.value = byday.join(',');
          formObj.bymonth.value = bymonth.join(',');
          formObj.bymonthday.value = bymonthday.join(',');
          formObj.byweekno.value = byweekno.join(',');
          formObj.byyearday.value = byyearday.join(',');
          formObj.wkst.value = formObj.yearWkst[formObj.yearWkst.selectedIndex].value;
          formObj.interval.value = formObj.yearlyInterval.value;
          break;
      }
      // build up count or until values
      var recur = getSelectedRadioButtonVal(formObj.recurCountUntil);
      switch (recur) {
        case "forever":
          // do nothing
          break;
        case "count":
          formObj.count.value = formObj.countHolder.value;
          break;
        case "until":
          // pad the month and day with zeros if only a single digit
          var paddedMonth = (formObj.untilMonth.value < 10) ? '0'+formObj.untilMonth.value : formObj.untilMonth.value;
          var paddedDay = (formObj.untilDay.value < 10) ? '0'+formObj.untilDay.value : formObj.untilDay.value;
          formObj.until.value = formObj.untilYear.value + paddedMonth + paddedDay;
          break;
      }
    }
  }
  //alert("frequency: " + freq + "\ninterval: " + formObj.interval.value + "\ncount: " + formObj.count.value + "\nuntil: " + formObj.until.value + "\nbyday: " + formObj.byday.value + "\nbymonthday: " + formObj.bymonthday.value + "\nbymonth: " + formObj.bymonth.value + "\nbyyearday: " + formObj.byyearday.value + "\nwkst: " + formObj.wkst.value);
  return true;
}
function getSelectedRadioButtonVal(radioCollection) {
  for(var i = 0; i < radioCollection.length; i++) {
    if(radioCollection[i].checked == true) {
       return radioCollection[i].value;
    }
  }
}
// returns an array of collected checkbox values
function collectRecurChkBoxVals(valArray,chkBoxes,dayPos) {
  if (chkBoxes) {
    if (typeof chkBoxes.length != 'undefined') {
      for (i = 0; i < chkBoxes.length; i++) {
        if (chkBoxes[i].checked == true) {
          if (dayPos) {
            valArray.push(dayPos + chkBoxes[i].value);
          } else {
            valArray.push(chkBoxes[i].value);
          }
        }
      }
    }
  }
  return valArray;
}
// launch a simple window for displaying information; no header or status bar
function launchSimpleWindow(URL) {
  simpleWindow = window.open(URL, "simpleWindow", "width=800,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.simpleWindow.focus();
}

// launch a size parameterized window for displaying information; no header or status bar
function launchSizedWindow(URL,width,height) {
  paramStr = "width=" + width + ",height=" + height + ",scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no";
  sizedWindow = window.open(URL, "sizedWindow", paramStr);
  window.sizedWindow.focus();
}

// launches new browser window with print-friendly version of page when
// print icon is clicked
function launchPrintWindow(URL) {
  printWindow = window.open(URL, "printWindow", "width=640,height=500,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes");
  window.printWindow.focus();
}

function startDateCalWidgetCallback(date, month, year) {
  /*if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }*/
  document.eventForm['eventStartDate.month'].value = month;
  document.eventForm['eventStartDate.day'].value = date;
  document.eventForm['eventStartDate.year'].value = year;
}
function endDateCalWidgetCallback(date, month, year) {
  /*if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }*/

  document.eventForm['eventEndDate.month'].value = month;
  document.eventForm['eventEndDate.day'].value = date;
  document.eventForm['eventEndDate.year'].value = year;
}
function untilDateCalWidgetCallback(date, month, year) {
  /*if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }*/

  document.eventForm['untilMonth'].value = month;
  document.eventForm['untilDay'].value = date;
  document.eventForm['untilYear'].value = year;
  selectRecurCountUntil('recurUntil');
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

function swapScheduleDisplay(val) {
  if (val == "show") {
    changeClass('scheduleLocationDisplay','invisible');
    changeClass('scheduleLocationEdit','shown');
    changeClass('scheduleDateDisplay','invisible');
    changeClass('scheduleDateEdit','shown');
  } else {
    changeClass('scheduleLocationDisplay','shown');
    changeClass('scheduleLocationEdit','invisible');
    changeClass('scheduleDateDisplay','shown');
    changeClass('scheduleDateEdit','invisible');
  }
}

