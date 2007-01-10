var bwClockHour = null;
var bwClockMinute = null;
var bwClockRequestedType = null;
var bwClockCurrentType = null;

function bwClockLaunch(type) {
  if ((document.getElementById("clock").className == "visible") && (bwClockCurrentType == type)) {
    changeClass("clock","invisible"); // if the clock with the same type is showing, toggle it off
  } else { // otherwise, turn it on and display the correct type
    bwClockRequestedType = type;
    bwClockCurrentType = type;
    changeClass("clock","visible");
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
}

function bwClockUpdateDateTimeForm(type,val) {
  if (bwClockRequestedType) {
    try {
      if (type == 'minute') {
        var fieldName = bwClockRequestedType + ".minute"
        window.document.eventForm[fieldName].value = val;
        bwClockMinute = val;
      } else {
        var fieldName = bwClockRequestedType + ".hour"
        window.document.eventForm[fieldName].value = val;
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
