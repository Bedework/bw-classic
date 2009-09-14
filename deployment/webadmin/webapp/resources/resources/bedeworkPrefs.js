// populate timezone select boxes in event form
function setTimezones(timezones) {
  var tzList = timezones.split(/\n|\r/);
  tzList.sort();

  var defaultTzOptions = '<option value="-1">select timezone...</option>';

  // create the default options list
  for (i = 0; i < tzList.length; i++) {
    if (tzList[i] != "") {
      // defaultTzid is set in the xslt head
      if (defaultTzid == tzList[i]) {
        defaultTzOptions += '<option value="' + tzList[i] + '" selected="selected">' + tzList[i] + '</option>';
      } else {
        defaultTzOptions += '<option value="' + tzList[i] + '">' + tzList[i] + '</option>';
      }
    }
  }
  $('#defaultTzid').html(defaultTzOptions);
}

/* jQuery initialization */
// timezoneUrl supplied in bedework.js
jQuery(document).ready(function($) {
  // get the timezones from the timezone server
  $.ajax({
    type: "GET",
    url: timezoneUrl,
    dataType: "text",
    success: function(text){
      setTimezones(text);
    }
  });
});
