var entries = {
  "microformats": {
    "vcard": [
    {
      "version": {
        "value": "4.0"
      },

      "rev": {
        "value": "20080811051937Z"
      },

      "source": [{
        "value": "\/ucarddav\/douglm.vcf"
      }],
      "uid": {
        "value": "\/ucarddav\/douglm.vcf"
      },
      "mail": [{
        "value": "douglm@mysite.org"
      }],

      "kind": {
        "value": "individual"
      },

      "fn": {
        "value": "Douglass, Mike"
      }

    }, {
      "version": {
        "value": "4.0"
      },

      "rev": {
        "value": "20080812153529Z"
      },

      "source": [{
        "value": "\/ucarddav\/johnsa.vcf"
      }],
      "uid": {
        "value": "\/ucarddav\/johnsa.vcf"
      },

      "mail": [{
        "value": "johnsa@rpi.edu",
        "value": "johnsa@mysite.org"
      }],

      "kind": {
        "value": "individual"
      },

      "fn": {
        "value": "Johnson, Arlen"
      }

    }, {
      "version": {
        "value": "4.0"
      },

      "rev": {
        "value": "20081103181729Z"
      },

      "source": [{
        "value": "\/ucarddav\/calowner01.vcf"
      }],
      "uid": {
        "value": "\/ucarddav\/calowner01.vcf"
      },

      "mail": [{
        "value": "bogus@mysite.org"
      }],

      "kind": {
        "value": "individual"
      },

      "fn": {
        "value": "last, first"
      }

    }]
  }
}

//alert(entries.microformats.vcard[0].fn.value);

var options = {
  minChars: 0,
  width: 310,
  matchContains: false,
  autoFill: false,
  extraParams: {
    format: 'json'
  },
  parse: function(data) {
    var parsed = [];
    data = data.microformats.vcard;
    for (var i = 0; i < data.length; i++) {
      parsed[parsed.length] = {
        data: data[i],
        value: data[i].fn.value,
        result: data[i].mail.value };
      }
    return parsed;
  },
  formatItem: function(item, i, max) {
    return " \"" + item.fn.value + "\" [" + item.mail.value + "]";
  },
  formatMatch: function(item, i, max) {
      return item.fn.value + " " + item.mail.value;
  },
  formatResult: function(item, i, max) {
    return item.mail.value;
  }
};

jQuery(document).ready(function($) {
  $('#bwRaUri').autocomplete(entries, options)
});

/*

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

  $("#bwRaUri").autocomplete(entries, {
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


*/
