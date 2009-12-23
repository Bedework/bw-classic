YAHOO.namespace("ifs");

var navCalSelectHandler = function(type,args,obj) {
  var selected = args[0];
    if (selected[0][1] < 10) { selected[0][1] = "0" + selected[0][1]; };
    if (selected[0][2] < 10) { selected[0][2] = "0" + selected[0][2]; };

    var newUrl = '/cal/main/setViewPeriod.do?b=de&date=' + selected[0][0] + selected[0][1] + selected[0][2];
  window.location.href = newUrl;
};

var groupSelectHandler = function(e) { // Depricated
  var myTarget = YAHOO.util.Event.getTarget(e);
  window.location.href = 'showMain.rdo?setappvar=group('+ myTarget.value +')';
}

YAHOO.ifs.init = function() {
// Mini Calendar
  YAHOO.ifs.jsNavCal = new YAHOO.widget.Calendar("jsNavCal","jsNavCal", {pagedate: navcalendar[0], selected: navcalendar[1]
        +"/"+ navcalendar[2] +"/"+ navcalendar[3] +"-"+ navcalendar[4]+"/"+ navcalendar[5] +"/"+ navcalendar[6]});
  YAHOO.ifs.jsNavCal.selectEvent.subscribe(navCalSelectHandler, YAHOO.ifs.jsNavCal, true);
  YAHOO.ifs.jsNavCal.render();
  YAHOO.util.Event.addListener("groupSelection", "change", groupSelectHandler); // Depreicated
// Buzz Events Widget
    if(document.getElementById('buzzTrigger')){
        var buzzTrigger = document.getElementById('buzzTrigger');
        var buzzLoaded = false;
        buzzTrigger.onclick = function() {
            if(!buzzLoaded) {
                var baseurl = 'http://calendar.duke.edu/feed/buzz_list/1/jsonp?';
                var surl = baseurl + '&callback=?';
                $.getJSON(surl);
                buzzLoaded = true;
            }
            var buzzTriggerObj = new AnimateDiv;
            buzzTriggerObj.initialize('buzzResult', 'buzzTrigger');
            buzzTriggerObj.actuate();;
            return false;
        };
    };
// Left nav menu initialization
  var initMenu = new Menu;
  initMenu.activate('artsSub', 'artsClicker', 170); // target DOM id to toggle, DOM id of button to activate, max height of target
  initMenu.activate('athleticsSub', 'athleticsClicker', 75);
  initMenu.activate('lecturesSub', 'lecturesClicker', 75);
  initMenu.activate('lifeSub', 'lifeClicker', 135);
  initMenu.activate('otherSub', 'otherClicker', 470);
  initMenu.activate('additionalOptionsSub', 'additionalOptionsClicker', 60);
  initMenu.activate('additionalUnivSub', 'additionalUnivClicker', 125);
// Link header graphic
    var headerHomeClick = document.getElementById('head-top');
    headerHomeClick.onclick = function () { window.location.href = 'http://calendar.duke.edu' };
// RSS widget
  popUpRss();
// Hide unnecessary date rows
  try {
    alterDateDisplay();
  } catch (e) {
    alert('There was a problem altering the display of dates.');
  }
};

YAHOO.util.Event.onDOMReady(YAHOO.ifs.init);

// Callback for JSONP Buzz events widget
function eventsList(listData) {
  var events = listData.bwEventList.events;
  var responseList = '<ul>';
  for (var i = 0; i < events.length; i++) {
    responseList += "<li><a href=\"" + events[i].eventlink + "\">" + events[i].summary +
        " " + events[i].start.shortdate + " " + events[i].start.time + "</a></li>";
  };
  responseList += "</ul>";
  $("#buzzResult").html(responseList);
};
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
/*
function AlterSymbol() { // Alters submenu toggle from one character to another
  this.triggerId = undefined;
  this.symbol = '-';
}
AlterSymbol.prototype.activate = function(triggerId, symbol) {
  this.triggerId = triggerId;
  this.symbol = symbol;
  try {
    var myTriggerId = document.getElementById(this.triggerId);
    var triggerText = myTriggerId.firstChild;
    myTriggerId.removeChild(triggerText);
    var finalSymbol = document.createTextNode(this.symbol);
    myTriggerId.appendChild(finalSymbol);
  } catch(e) {
    alert('There was a problem altering the toggle icon.');
  }


  return;
}
// Menu logic - requires YUI animation library
function Menu() { // Enables the toggling of menu items with submenus via animating the height of the html element.
  this.viewId = 'All';
  this.triggerId = undefined;
  this.duration = .5;
}

Menu.prototype.activate = function(viewId, triggerId, targetHeight) { // Assumes toggle button will be text "+" or "-"
  this.viewId = viewId;
  this.triggerId = triggerId;
  var menuButton = document.getElementById(this.triggerId);
  menuButton.targetId = this.viewId;
  menuButton.targetHeight = targetHeight;
  menuButton.duration = this.duration;
  if (document.getElementById(menuButton.targetId).style.height !== '0px') {
    var toggleSym = new AlterSymbol;
    toggleSym.activate(triggerId, '-');
    toggleSym = undefined; // destroy object
  }

  menuButton.onclick = function() {
    var alterSymbol = function(sym) {
        var toggleSym = new AlterSymbol;
        toggleSym.activate(triggerId, sym);

        return;
      }

    if (this.targetHeight > 200) {
      this.duration = 1;
    }
    try{
      var myId = document.getElementById(this.targetId);
      var menuItemOff = new YAHOO.util.Anim(this.targetId, {
            height:   { to: 0 }
          }, 1, YAHOO.util.Easing.easeOut);
      var menuItemOn = new YAHOO.util.Anim(this.targetId, {
            height: { to: this.targetHeight }
          }, 1, YAHOO.util.Easing.easeOut);
      if (myId.style.height === '0px') {
        menuItemOn.duration = this.duration;
        menuItemOn.animate();
        menuItemOn.onComplete.subscribe(function(){ alterSymbol('-'); });
      } else {
        menuItemOff.duration = this.duration;
        menuItemOff.animate();
        menuItemOff.onComplete.subscribe(function(){ alterSymbol('+'); });
      }

    } catch(e) {
      alert('The menu controls have malfunctioned.');
    }

  }

  return;
}

function popUpRss() {
       var theTrigger = document.getElementById('rssRequest');
     theTrigger.onclick = function() {
       var findPos = function(obj){  // for positioning menu on link click
            var curleft = curtop = 0;
            if (obj.offsetParent) {
                do {
                    curleft += obj.offsetLeft;
                    curtop += obj.offsetTop;
                }
                while (obj = obj.offsetParent);
            } else {
                alert('Your browser does not support offsetParent so we cannot position the menu.')
            };

            return [curleft, curtop];
        };

          var posArr = findPos(this);
          var theHost = document.getElementById('rssPopUp');
      var rssValueObj = document.getElementById('rssValue');
      rssValueObj.value = this.href; //RSS URL with params
          theHost.style.left = (posArr[0] + 15) + 'px';
          theHost.style.top = posArr[1] + 'px';
          if (theHost.style.display === 'none') {
              theHost.style.display = 'block';
          };
       // Format dialogue to reflect current settigns of Group and Category
       if(document.getElementById('currGroupName')) {
        var groupDisplay = document.getElementById('rssDetailGroup');
        var currentGroup = document.createTextNode(document.getElementById('currGroupName').childNodes[0].nodeValue);
        var removeDefault = groupDisplay.childNodes[0];
        var deleteDefault = groupDisplay.replaceChild(currentGroup, removeDefault);
       }
       if(document.getElementById('currCategories')) {
        var catDisplay = document.getElementById('rssDetailCategory');
        var currentCat = document.createTextNode(document.getElementById('currCategories').childNodes[0].nodeValue);
        var removeDefaultCat = catDisplay.childNodes[0];
        var deleteDefaultCat = catDisplay.replaceChild(currentCat, removeDefaultCat);
       }
      return false;

     };

  return;
};

function AnimateDiv() {
    this.divId = undefined;
    this.triggerId = undefined;
};
AnimateDiv.prototype.initialize = function(divId, triggerId) {
    this.divId = divId;
    this.triggerId = triggerId;
};
AnimateDiv.prototype.actuate = function() {
    var myDiv = document.getElementById(this.divId);
    var myTrigger = document.getElementById(this.triggerId);

    var showOrHide = function(targetEle, throwAway) {
        var opacity = YAHOO.util.Dom.getStyle(targetEle, 'opacity');
        if(opacity < '1') {
            targetEle.style.display = 'none';
        };

        var currTextNode = myTrigger.firstChild;
        myTrigger.removeChild(currTextNode);
        var changeText = document.createTextNode(throwAway);
        myTrigger.appendChild(changeText);

    };

        var hideEvents = new YAHOO.util.Anim(myDiv, {
            opacity: {
                to: 0
            }
        }, 1, YAHOO.util.Easing.easeOut);
        var showEvents = new YAHOO.util.Anim(myDiv, {
            opacity: {
                to: 1
            }
        }, 1, YAHOO.util.Easing.easeOut);
        if (myDiv.style.display === 'block') {
            newHTML = 'More >';
            hideEvents.duration = .5;
            hideEvents.animate();
            hideEvents.onComplete.subscribe(function(){
                showOrHide(myDiv, newHTML);
            });
        }
        else {
            myDiv.style.display = 'block';
            newHTML = 'Less >';
            showEvents.duration = .5
            showEvents.animate();
            showEvents.onComplete.subscribe(function(){
                showOrHide(myDiv, newHTML);
            });
        };
    return;
};
*/
