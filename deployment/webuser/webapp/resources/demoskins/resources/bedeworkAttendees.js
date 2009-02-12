var carddavUrl = "/ucarddav/find";

var options = {
  minChars: 0,
  width: 310,
  matchContains: false,
  autoFill: false,

  extraParams: {
    format: 'json'
  },

  dataType: 'json',

  /* override the parse function to map
     our carddav json object to the expected data
     structure for use with autocomplete */
  parse: function(data) {
    var parsed = [];
    data = data.microformats.vcard;
    for (var i = 0; i < data.length; i++) {
      dataRow = {
        fn: (data[i].fn.value)?data[i].fn.value:"",
        email: (data[i].email[0].value)?data[i].email[0].value:"",
        uri: (data[i].caladruri.value)?data[i].caladruri.value:"",
        type: (data[i].kind.value)?data[i].kind.value:""
      };
      parsed[i] = {
        data: dataRow,
        value: data[i].fn.value,
        result: data[i].email[0].value
      };
    }
    return parsed;
  },
  formatItem: function(item) {
      return " \"" + item.fn + "\" [" + item.email + "]";
  },

  formatMatch: function(item) {
      return " \"" + item.fn + "\" [" + item.email + "]";
  },
  formatResult: function(item) {
    return item.email;
  }
};

jQuery(document).ready(function($) {
  $('#bwRaUri').autocomplete(carddavUrl, options)
});
