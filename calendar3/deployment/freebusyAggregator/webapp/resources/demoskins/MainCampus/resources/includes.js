function startDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  document.freebusyForm['startdt'].value = year + month + date;
  enableFbSubmit('start');
}
function endDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  document.freebusyForm['enddt'].value = year + month + date;
  enableFbSubmit('end');
}


// change the group
function setGroup(groupObj) {
  if (groupObj.selectedIndex != 0) {
    window.location = "selectGroup.do?name=" + groupObj.value;
  }
}

// enable submit when we've focused the start or end date fields
// and the other has a value
function enableFbSubmit(field) {
  var checkField = document.freebusyForm.startdt;
  // if we're sending the start field, check the end field and vice versa
  if (field == 'start') {
    checkField = document.freebusyForm.enddt;
  }
  if(checkField.value != '') {
    document.freebusyForm.submitFb.disabled = false;
  }
}

// show freebusy for a specific account
function showAccountFreebusy(account) {
  if (document.freebusyForm.submitFb.disabled == true) {
    alert("You must specify a date range.");
    document.freebusyForm.startdt.focus();
  } else {
    document.freebusyForm.account.value = account;
    document.freebusyForm.all.value = "false";
    document.freebusyForm.submit();
  }
}
