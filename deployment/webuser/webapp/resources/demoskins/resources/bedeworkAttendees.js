var entries = [
  { name: "Peter Pan", address: "peter@pan.de", uri: "someUri", type: "user"},
  { name: "Molly", address: "molly@yahoo.com", uri: "someUri", type: "user"},
  { name: "Forneria Marconi", address: "live@japan.jp", uri: "someUri", type: "user"},
  { name: "VCC 301", address: "vcc301@rpi.edu", uri: "someUri", type: "resource"},
  { name: "CMT Communication and Middleware Technologies", address: "cmt@rpi.edu", uri: "someUri", type: "group"},
  { name: "Don Corleone", address: "don@vegas.com", uri: "someUri", type: "user"},
  { name: "Mc Chick", address: "info@donalds.org", uri: "someUri", type: "user"},
  { name: "Donnie Darko", address: "dd@timeshift.info", uri: "someUri", type: "user"},
  { name: "Quake The Net", address: "webmaster@quakenet.org", uri: "someUri", type: "user"},
  { name: "Dr. Write", address: "write@writable.com", uri: "someUri", type: "user"}
];

$(document).ready(function(){

  function formatItem(row) {
    return row[0] + " (<strong>id: " + row[1] + "</strong>)";
  }

  function formatResult(row) {
    return row[0].replace(/(<.+?>)/gi, '');
  }

  $("#bw-attendee").autocomplete(entries, {
    minChars: 0,
    width: 310,
    matchContains: false,
    autoFill: false,
    formatItem: function(row, i, max) {
      return " \"" + row.name + "\" [" + row.address + "]";
    },
    formatMatch: function(row, i, max) {
      return row.name + " " + row.address;
    },
    formatResult: function(row) {
      return row.address;
    }
  });

    $("#bw-attendee").autocomplete(entries, {
    minChars: 0,
    width: 310,
    matchContains: false,
    autoFill: false,
    formatItem: function(row, i, max) {
      return " \"" + row.name + "\" [" + row.address + "]";
    },
    formatMatch: function(row, i, max) {
      return row.name + " " + row.address;
    },
    formatResult: function(row) {
      return row.address;
    }
  });

});

