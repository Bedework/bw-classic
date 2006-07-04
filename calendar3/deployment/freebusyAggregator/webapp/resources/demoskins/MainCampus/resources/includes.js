function startDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  document.freebusyForm['startDate'].value = month + "/" + date + "/" + year;
}
function endDateCalWidgetCallback(date, month, year) {
  if (String(month).length == 1) {
      month = '0' + month;
  }
  if (String(date).length == 1) {
      date = '0' + date;
  }
  today = new Date();
  document.freebusyForm['endDate'].value = month + "/" + date + "/" + year;
}
