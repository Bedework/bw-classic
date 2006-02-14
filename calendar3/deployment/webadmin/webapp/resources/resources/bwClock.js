var bwClockHour = null;
var bwClockMinute = null;
var bwClockRequestedType = null;
var bwClockCurrentType = null;

function bwClockLaunch(type) {
  if ((document.getElementById("clock").className == "shown") && (bwClockCurrentType == type)) {
    changeClass("clock","invisible"); // if the clock with the same type is showing, toggle it off
  } else { // otherwise, turn it on and display the correct type
    bwClockRequestedType = type;
    bwClockCurrentType = type;
    changeClass("clock","shown");
    // the following is for Internet Explorer.  IE draws "windowed" objects
    // and unwindowed objects on seperate "planes"; windowed objects are always
    // drawn obove unwindowed objects and select boxes are "windowed";
    // this is required to make IE not overwrite the clock div with
    // the select boxes that fall below it on the page.  Note: we set them
    // to display:hidden (not none) so their space is still occupied (and the
    // browser window doesn't shift around)
    changeClass("eventFormPrefLocationList","hidden");
    changeClass("eventFormLocationList","hidden");
    changeClass("eventFormSponsorList","hidden");
    changeClass("eventFormPrefSponsorList","hidden");
    bwClockIndicator = document.getElementById("bwClockDateTypeIndicator");
    if (type == 'eventStartDate') {
      bwClockIndicator.innerHTML = "Start Time"
    } else {
      bwClockIndicator.innerHTML = "End Time"
    }
  }
}

function bwClockClose() {
  changeClass("clock","invisible");
  changeClass("eventFormPrefLocationList","shown");
  changeClass("eventFormLocationList","shown");
  changeClass("eventFormSponsorList","shown");
  changeClass("eventFormPrefSponsorList","shown");
}

function bwClockUpdateDateTimeForm(type,val) {
  if (bwClockRequestedType) {
    try {
      if (type == 'minute') {
        var fieldName = bwClockRequestedType + ".minute"
        window.document.peForm[fieldName].value = val;
        bwClockMinute = val;
      } else {
        var fieldName = bwClockRequestedType + ".hour"
        window.document.peForm[fieldName].value = val;
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
