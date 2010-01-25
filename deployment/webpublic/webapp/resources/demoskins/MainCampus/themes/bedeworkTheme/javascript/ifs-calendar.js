YAHOO.namespace("bw");

var navCalSelectHandler = function(type,args,obj) {
  var selected = args[0];
    if (selected[0][1] < 10) { selected[0][1] = "0" + selected[0][1]; };
    if (selected[0][2] < 10) { selected[0][2] = "0" + selected[0][2]; };

    var newUrl = '/cal/main/setViewPeriod.do?b=de&date=' + selected[0][0] + selected[0][1] + selected[0][2];
  window.location.href = newUrl;
};

YAHOO.bw.init = function() {
// Mini Calendar
  YAHOO.bw.jsNavCal = new YAHOO.widget.Calendar("jsNavCal","jsNavCal", {
    pagedate: navcalendar[0], 
    selected: navcalendar[1] +"/"+ navcalendar[2] +"/"+ navcalendar[3] +"-"+ navcalendar[4]+"/"+ navcalendar[5] +"/"+ navcalendar[6]
  });
  YAHOO.bw.jsNavCal.selectEvent.subscribe(navCalSelectHandler, YAHOO.bw.jsNavCal, true);
  
  // LOCALE SETTINGS:
  // The following function is found in the locale directory in file jsCalendarLocale.xsl
  // (in the same location as strings.xsl, where the template language strings are stored).
  // It is included by the default.xsl file.  The template inside this file is 
  // called by head.xsl making the js function available here.  You can therefore have
  // as many locale settings files as you have locales.
  setJsCalendarLocale(); 
  
  YAHOO.bw.jsNavCal.render();

  // Hide unnecessary date rows
  // ...not currently in use. 
  /*
  try {
    alterDateDisplay();
  } catch (e) {
  }
  */
};

YAHOO.util.Event.onDOMReady(YAHOO.bw.init);

// Hide date rows
function alterDateDisplay() {
  var centerCol = document.getElementById("center_column");
  var modGroupTd = centerCol.getElementsByTagName('td');
  var tdInspector = [];
  var i = undefined;
  var j = undefined;

    for (i = 0; i < modGroupTd.length; i++) {
       if(modGroupTd[i].className === 'dateRow') {
      tdInspector.push(modGroupTd[i].childNodes[0]);
       };
    };
  for (j = 0; j < tdInspector.length; j++) { // Search for dupes
    if(tdInspector[j + 1]) {
        if(tdInspector[j].href === tdInspector[j + 1].href) { // Found a duplicate date. // Hide it.
          tdInspector[j + 1].parentNode.parentNode.style.display = 'none';
          j++;
          while(tdInspector[j + 1] && tdInspector[j].href === tdInspector[j + 1].href) { // Look for more.
            tdInspector[j + 1].parentNode.parentNode.style.display = 'none';
            j++;
          }
        };
      };
  };
}

