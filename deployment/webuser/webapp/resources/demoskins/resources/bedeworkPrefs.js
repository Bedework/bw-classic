/* Preferences and Scheduling */
// build the workdays parameter as a string when submitting user preferences form
function setWorkDays(formObj) {
  if (formObj) {
    var workDays = "";
    for (i=0; i<7; i++) {
      if (formObj.workDayIndex[i].checked) {
        workDays += "W";
      } else {
        workDays += "n";
      }
    }
    formObj.workDays.value = workDays;
  } else {
    alert("The preferences form is not available.");
  }
}
function setScheduleHow(formObj) {
  if (formObj.howSetter[0].checked == true) {
    formObj.how.value = formObj.howSetter[0].value;
  } else {
    var access = new Array();
    // gather up the access characters - begin on the second element
    for (i = 1; i < formObj.howSetter.length; i++) {
      if (formObj.howSetter[i].checked == true) {
        access.push(formObj.howSetter[i].value);
      }
    }
    formObj.how.value = access.join('');
  }

  if (debug) {
    alert(formObj.how.value);
  }
}
function toggleScheduleHow(formObj,chkBox) {
  if (chkBox.checked == false) {
    // we start on the second checkbox element
    for (i = 1; i < formObj.howSetter.length; i++) {
      formObj.howSetter[i].disabled = false;
    }
  } else {
    for (i = 1; i < formObj.howSetter.length; i++) {
      formObj.howSetter[i].checked = true;
      formObj.howSetter[i].disabled = true;
    }
  }
}
function swapScheduleDisplay(val) {
  if (val == "show") {
    changeClass('scheduleLocationEdit','visible');
    changeClass('scheduleDateEdit','visible');
  } else {
    changeClass('scheduleLocationEdit','invisible');
    changeClass('scheduleDateEdit','invisible');
  }
}
function toggleAutoRespondFields(val) {
  if (val == "true") {
    document.getElementById("scheduleDoubleBookTrue").disabled = false;
    document.getElementById("scheduleDoubleBookFalse").disabled = false;
    document.getElementById("scheduleAutoCancelAction").disabled = false;
  } else {
    document.getElementById("scheduleDoubleBookTrue").disabled = true;
    document.getElementById("scheduleDoubleBookFalse").disabled = true;
    document.getElementById("scheduleAutoCancelAction").disabled = true;
  }
}
