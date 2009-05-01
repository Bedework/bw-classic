/* **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits. */

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

var debug = false; // very basic debugging for now

/* COMMON and GENERAL FUNCTIONS */

function changeClass(id, newClass) {
  var identity = document.getElementById(id);
  if (identity == null) {
    alert("No element with id: " + id + " to set to class: " + newClass);
  }
  identity.className=newClass;
}
// set a field's value by ID
// typically used to set the value of a hidden field
function setField(id,val) {
  field = document.getElementById(id);
  field.value = val;
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
// show and hide an item based on its current
// visibility; if visible, hide it; if invisible
// show it.
function toggleVisibility(id,newClass) {
  if (document.getElementById(id).className == 'invisible') {
    if (newClass != "") {
      changeClass(id,newClass);
    } else {
      changeClass(id,'visible');
    }
  } else {
    changeClass(id,'invisible');
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
  calSelect = window.open(URL, "calSelect", "width=500,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
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
// used to update a calendar subscription (alias) We must do two things: update the hidden
// calendar input field and update the displayed text
function updatePublicCalendarAlias(newCalPath,calDisplay,calendarCollection) {
  var calendarAliasHolder = document.getElementById("publicAliasHolder");
  var bwCalDisplay = document.getElementById("bwPublicCalDisplay");
  calendarAliasHolder.value = newCalPath;
  bwCalDisplay.innerHTML = '<strong>' + calDisplay + '</strong> <button type="button" onclick="showPublicCalAliasTree();">change</button>';
  changeClass("publicSubscriptionTree","invisible");
}
function showPublicCalAliasTree() {
  changeClass("publicSubscriptionTree","calendarTree");
}
// set the subscription URI when creating or updating a subscription
function setCalendarAlias(formObj) {
  if (!formObj) {
    alert("The subscription form is not available.");
    return false;
  }

  // set the aliasUri to an empty string.  Only set it if user
  // has requested a subscription.
  formObj.aliasUri.value == "";

  if (formObj.type.value == "folder") {
    formObj.calendarCollection.value = "false";
  } else if (formObj.type.value == "subscription") {
    switch (formObj.subType.value) {
      case "public":
        formObj.aliasUri.value = "bwcal://" + formObj.publicAliasHolder.value;
        break;
      case "user":
        //the "/user/" string is temporary; it needs to be passed as a param.
        formObj.aliasUri.value = "bwcal:///user/" + formObj.userIdHolder.value + "/" + formObj.userCalHolder.value;
        break;
      case "external":
        formObj.aliasUri.value = formObj.aliasUriHolder.value;
        break;
    }
  }
  return true;
}
// build a uri based on user and path in the subscription form
// DEPRECATED - use setCalendarAlias() above.
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
function checkPrefCategories(formObj){
  var hasACat = false;

  if (typeof formObj.defaultCategory.length != 'undefined') {
    for (i = 0; i < formObj.defaultCategory.length; i++) {
      if (formObj.defaultCategory[i].checked) {
        hasACat = true;
        break;
      }
    }
  }
  if (!hasACat) {
    // no category is checked;
    // create an empty catUid element to alert the backend
    // so we can clear the cats
    var hiddenCat = document.createElement("div");
    hiddenCat.innerHTML = '<input type="hidden" name="defaultCategory" value=""/>';
    formObj.appendChild(hiddenCat);
  }
}
// set category filters on calendar collections
function setCatFilters(formObj) {
  if (typeof formObj.filterCatUid.length != 'undefined') {
    var filterExpression = "catuid=(";
    var filterExists = false;
    for (i = 0; i < formObj.filterCatUid.length; i++) {
      if (formObj.filterCatUid[i].checked) {
        filterExists = true;
        filterExpression += formObj.filterCatUid[i].value + ",";
      }
    }
    alert(filterExists);
    if (filterExists) {
      // remove the last comma and close off the expression
      filterExpression = filterExpression.substring(0,filterExpression.length-1) + ")";
      // set the form value
      formObj.fexpr.value = filterExpression;
    }
  }
}
