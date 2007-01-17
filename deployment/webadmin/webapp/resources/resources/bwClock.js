var bwClockHour = null;
var bwClockMinute = null;
var bwClockRequestedType = null;
var bwClockCurrentType = null;

function bwClockLaunch(type) {
  // type: type of clock "eventStartDate" or "eventEndDate"
  if ((document.getElementById("clock").className == "visible") && (bwClockCurrentType == type)) {
    // if the clock with the same type is visible, toggle it off
    changeClass("clock","invisible");
  } else { // otherwise, turn it on and display the correct type
    bwClockRequestedType = type;
    bwClockCurrentType = type;
    changeClass("clock","shown");
    // reset hours and minutes to null
    bwClockHour = null;
    bwClockMinute = null;
   changeClass("eventFormPrefLocationList","hidden");
   changeClass("eventFormLocationList","hidden");
   changeClass("eventFormContactList","hidden");
   changeClass("eventFormPrefContactList","hidden");
    bwClockIndicator = document.getElementById("bwClockDateTypeIndicator");
    bwClockSwitch = document.getElementById("bwClockSwitch");
    document.getElementById("bwClockTime").innerHTML = "select time";
    if (type == 'eventStartDate') {
      bwClockIndicator.innerHTML = "Start Time";
      bwClockSwitch.innerHTML = '<a href="javascript:bwClockLaunch(\'eventEndDate\');">switch to end</a>';
    } else {
      bwClockIndicator.innerHTML = "End Time";
      bwClockSwitch.innerHTML = '<a href="javascript:bwClockLaunch(\'eventStartDate\');">switch to start</a>';
    }
  }
}

function bwClockClose() {
  changeClass("clock","invisible");
  changeClass("eventFormPrefLocationList","shown");
  changeClass("eventFormLocationList","shown");
  changeClass("eventFormContactList","shown");
  changeClass("eventFormPrefContactList","shown");
}

function bwClockUpdateDateTimeForm(valType,val) {
  // valType: "hour" or "minute"
  // val: hour or minute value as integer
  if (bwClockRequestedType) {
    try {
      if (valType == 'minute') {
        var fieldName = bwClockRequestedType + ".minute"
        window.document.eventForm[fieldName].value = val;
        if (val < 10) {
          val = "0" + val; // pad the value for display
        }
        bwClockMinute = val;
      } else {
        var fieldName = bwClockRequestedType + ".hour"
        window.document.eventForm[fieldName].value = val;
        if (val < 10) {
          val = "0" + val; // pad the value for display
        }
        bwClockHour = val;
      }
      if (bwClockHour && bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + ":" + bwClockMinute + " , " + bwClockConvertAmPm(bwClockHour) + ":" + bwClockMinute + " " + bwClockGetAmPm(bwClockHour);
      } else if (bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = ":" + bwClockMinute;
      } else {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + " , " + bwClockConvertAmPm(bwClockHour) + " " + bwClockGetAmPm(bwClockHour);
      }
    } catch(e) {
      alert("There was an error:\n" + e );
    }
  } else {
    alert("The date type is null.");
  }
}

function bwClockConvertAmPm(hour24) {
  hour24 = parseInt(hour24,10);
  if (hour24 == 0) {
    return 12;
  } else if (hour24 > 12) {
    return hour24 - 12;
  } else {
    return hour24;
  }
}

function bwClockGetAmPm(hour24) {
  hour24 = parseInt(hour24,10);
  if (hour24 < 12) {
    return 'a.m.';
  } else {
    return 'p.m.';
  }
}
