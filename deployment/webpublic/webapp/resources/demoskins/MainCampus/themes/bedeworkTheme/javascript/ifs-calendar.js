YAHOO.namespace("ifs");

var navCalSelectHandler = function(type,args,obj) {
  var selected = args[0];
    if (selected[0][1] < 10) { selected[0][1] = "0" + selected[0][1]; };
    if (selected[0][2] < 10) { selected[0][2] = "0" + selected[0][2]; };

    var newUrl = '/cal/main/setViewPeriod.do?b=de&date=' + selected[0][0] + selected[0][1] + selected[0][2];
  window.location.href = newUrl;
};

YAHOO.ifs.init = function() {
// Mini Calendar
  YAHOO.ifs.jsNavCal = new YAHOO.widget.Calendar("jsNavCal","jsNavCal", {pagedate: navcalendar[0], selected: navcalendar[1]
        +"/"+ navcalendar[2] +"/"+ navcalendar[3] +"-"+ navcalendar[4]+"/"+ navcalendar[5] +"/"+ navcalendar[6]});
  YAHOO.ifs.jsNavCal.selectEvent.subscribe(navCalSelectHandler, YAHOO.ifs.jsNavCal, true);
  YAHOO.ifs.jsNavCal.render();
// Hide unnecessary date rows
  try {
    alterDateDisplay();
  } catch (e) {
    alert('There was a problem altering the display of dates.');
  }
};

YAHOO.util.Event.onDOMReady(YAHOO.ifs.init);

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

