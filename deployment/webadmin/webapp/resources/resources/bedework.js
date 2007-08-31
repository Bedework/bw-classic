var debug = false; // very basic debugging for now

/* COMMON and GENERAL FUNCTIONS */

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
// show hide items using a checkbox
function swapVisible(obj,id) {
  if (obj.checked) {
    changeClass(id,'visible');
  } else {
    changeClass(id,'invisible');
  }
}
// hide a group of items
// send IDs as parameters
function hide() {
  if (arguments.length != 0) {
    for (i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'invisible');
    }
  }
}
// show a group of items
// send IDs as parameters
function show() {
  if (arguments.length != 0) {
    for (i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'visible');
    }
  }
}
function setTab(listId,listIndex) {
  var list = document.getElementById(listId);
  var elementArray = new Array();
  for (i = 0; i < list.childNodes.length; i++) {
    if (list.childNodes[i].nodeName == "LI") {
      elementArray.push(list.childNodes[i]);
    }
  }
  for (i = 0; i < elementArray.length; i++) {
    if (i == listIndex) {
      elementArray[i].className = 'selected';
    } else {
      elementArray[i].className = '';
    }
  }
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
// launch the calSelect pop-up window for selecting a calendar when creating,
// editing, and importing events
function launchCalSelectWindow(URL) {
  calSelect = window.open(URL, "calSelect", "width=700,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.calSelect.focus();
}
// used to update the calendar in various forms from
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
// build a uri based on user and path in the subscription form
function setSubscriptionUri(formObj,prefix) {
  if (formObj) {
    var fullUri =  prefix + formObj.userId.value;
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
function exportCalendar(formId,name,calPath) {
  var formObj = document.getElementById(formId);
  formObj.calPath.value = calPath;
  formObj.contentName.value = name + '.ics';
  formObj.submit();
}

// checkboxes for all categories and preferred categories are on the page
// simultaneously.  The use can toggle between which is shown and which is
// hidden.  When a checkbox from one collection is changed, the corresponding
// checkbox should be changed in the other set if it exists.
function setCatChBx(thiscat,othercat) {
  thisCatCheckBox = document.getElementById(thiscat);
  if (document.getElementById(othercat)) {
    otherCatCheckBox = document.getElementById(othercat);
    otherCatCheckBox.checked =  thisCatCheckBox.checked;
  }
}
