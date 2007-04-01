// this toggles various elements in the access control form when
// a checkbox for All, Read, Write, Bind, Schedule, or None is clicked.
// Each howItem (checkbox) has a corresponding allow/deny flag (radio button)
// named after the howItem's value (e.g. "A","R","F","N", etc). We enable
// and disable the corresponding radio buttons as well.
function setupAccessForm(chkBoxObj,formObj) {
  switch (chkBoxObj.value) {
    case "A": // All
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value != "A") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          formObj.howItem[i].disabled = false;
        }
      }
      break;
    case "R": // Read
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "r" ||
              formObj.howItem[i].value == "P" ||
              formObj.howItem[i].value == "F") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "r" ||
              formObj.howItem[i].value == "P" ||
              formObj.howItem[i].value == "F") {
            formObj.howItem[i].disabled = false;
          }
        }
      }
      break;
    case "W": // Write
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "a" ||
              formObj.howItem[i].value == "p" ||
              formObj.howItem[i].value == "c" ||
              formObj.howItem[i].value == "b" ||
              formObj.howItem[i].value == "S" ||
              formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s" ||
              formObj.howItem[i].value == "u") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "a" ||
              formObj.howItem[i].value == "p" ||
              formObj.howItem[i].value == "c" ||
              formObj.howItem[i].value == "b" ||
              formObj.howItem[i].value == "S" ||
              formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s" ||
              formObj.howItem[i].value == "u") {
            formObj.howItem[i].disabled = false;
          }
        }
      }
      break;
    case "b": // Bind (create)
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "S" ||
              formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "S" ||
              formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s") {
            formObj.howItem[i].disabled = false;
          }
        }
      }
      break;
    case "S": // Schedule
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value == "t" ||
              formObj.howItem[i].value == "y" ||
              formObj.howItem[i].value == "s") {
            formObj.howItem[i].disabled = false;
          }
        }
      }
      break;
    case "N": // None
      if (chkBoxObj.checked == true) {
        for (i = 0; i < formObj.howItem.length; i++) {
          if (formObj.howItem[i].value != "N") {
            formObj.howItem[i].checked = false;
            formObj.howItem[i].disabled = true;
            // now iterate over corresponding radio buttons for each howItem
            for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
              formObj[formObj.howItem[i].value][j].disabled = true;
            }
          }
        }
      } else {
        for (i = 0; i < formObj.howItem.length; i++) {
          formObj.howItem[i].disabled = false;
        }
      }
      break;
  }
}
// enable and disable corresponding allow/deny flags when a howItem checkbox is
// clicked
function toggleAllowDenyFlag(chkBoxObj,formObj) {
  if (chkBoxObj.checked == true) {
    activateAllowDenyFlag(chkBoxObj.value, formObj, false);
  } else {
    activateAllowDenyFlag(chkBoxObj.value, formObj, true);
  }
}
// iterate over the allow/deny radio buttons and set them to true or false
function activateAllowDenyFlag(val,formObj,disabledFlag) {
  for (i = 0; i < formObj[val].length; i++) {
    formObj[val][i].disabled = disabledFlag;
  }
}
// Gather up the how values on access form submission and set the how field.
// If in "basic" mode:
//   Set the value of how to the value of the basicHowItem radio button.
// If in "advanced" mode:
//   Each howItem (checkbox) has a corresponding allow/deny flag (radio button)
//   named after the howItem's value (e.g. "A","R","F","N", etc).
//   The allow/deny flag contains the final values to be returned with
//   the "-" switch if we set the value to deny (e.g. "A" or "-A", "R" or "-R").
function setAccessHow(formObj) {
  var howString = "";
  if (formObj.setappvar[0].checked == true) { // "basic" mode is selected
    for (i = 0; i < formObj.basicHowItem.length; i++) {
      if (formObj.basicHowItem[i].checked == true) {
        howString = formObj.basicHowItem[i].value;
      }
    }
  } else { // "advanced" mode is selected
    for (i = 0; i < formObj.howItem.length; i++) {
      if (formObj.howItem[i].checked == true) {
        var howItemVal = formObj.howItem[i].value; // get the howItem value and
        for (j = 0; j < formObj[howItemVal].length; j++) { // look up the value from the corresponding allow/deny flag
          if (formObj[howItemVal][j].checked == true) {
            howString += formObj[howItemVal][j].value;
          }
        }
      }
    }
  }
  // alert("Setting how to: " + howString);
  formObj.how.value = howString;
}
