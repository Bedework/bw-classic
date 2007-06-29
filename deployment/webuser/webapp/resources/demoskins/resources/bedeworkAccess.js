/* Bedework Access control form functions

   Bedework uses to methods to set access control.  The first and older method
   is to send a single access control string per principal in one
   request/response cycle.  The second and more current method (which is
   required in the event form) is to build a javascript object representing
   the acls on an item (e.g. an event), manipulate the object with the GUI, and send
   all the acls in a single request parameter.  Both methods are currently used.
   Method one is used for calendar access, method two for event access.  In time
   we will probably move all access control to use method two.

/* **********************************************************************
    Copyright 2007 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

// This toggles various elements in the access control form when
// a checkbox for All, Read, Write, Bind, Schedule, or None is clicked.
// Each howItem (checkbox) has a corresponding allow/deny flag (radio button)
// named after the howItem's value (e.g. "A","R","F","N", etc). We enable
// and disable the corresponding radio buttons as well.

// ========================================================================
// ========================================================================
//   Language and customization

var authenticatedStr = "authenticated";
var unauthenticatedStr = "unauthenticated";
var ownerStr = "owner";
var otherStr = "other";
var deleteStr = "remove";
var grantStr = "grant";

var howAllVal = "all";

var howReadVal = "read";
var howReadAclVal = "read-acl";
var howReadCurPrivSetVal = "read-curprivset";
var howReadFreebusyVal = "read-freebusy ";

var howWriteVal = "write";
var howWriteAclVal = "write-acl";
var howWritePropertiesVal = "write-properties";
var howWriteContentVal = "write-content";

var howBindVal = "create";
var howScheduleVal = "schedule";
var howScheduleRequestVal = "schedule-request";
var howScheduleReplyVal = "schedule-reply";
var howScheduleFreebusyVal = "schedule-freebusy";

var howUnbindVal = "delete";

var howUnlockVal = "unlock";

var howNoneVal = "none";

// ========================================================================
// ========================================================================

/* Define how values, first par is the how,
   second the contained hows
   third the display name */
function howVals(h, cont, dv) {
  var how;
  var contains;
  var dispVal;

  this.how = h;
  this.contains = cont;
  this.dispVal = dv;

  /* return true if ch is contained in this access */
  this.doesContain = function(ch) {
    return this.contains.match(ch) != null;
  }
}

var hows = new function() {
  var hv = new Array();

  hv.push(new howVals("A", "RrPFWapcbStysuN", howAllVal));

  hv.push(new howVals("R", "rPF", howReadVal));
  hv.push(new howVals("r", "", howReadAclVal));
  hv.push(new howVals("P", "", howReadCurPrivSetVal));
  hv.push(new howVals("F", "", howReadFreebusyVal));

  hv.push(new howVals("W", "apcbStysuN", howWriteVal));
  hv.push(new howVals("a", "", howWriteAclVal));
  hv.push(new howVals("p", "", howWritePropertiesVal));
  hv.push(new howVals("c", "", howWriteContentVal));

  hv.push(new howVals("b", "Stys", howBindVal));
  hv.push(new howVals("S", "tys", howScheduleVal));
  hv.push(new howVals("t", "", howScheduleRequestVal));
  hv.push(new howVals("y", "", howScheduleReplyVal));
  hv.push(new howVals("s", "", howScheduleFreebusyVal));

  hv.push(new howVals("u", "", howUnbindVal));

  hv.push(new howVals("U", "", howUnlockVal));

  hv.push(new howVals("N", "rPFapcbStysu", howNoneVal));

  this. getHows = function(ch) {
    for (var i = 0; i < hv.length; i++) {
      if (hv[i].how == ch) {
        return hv[i];
      }
    }

    return null;
  }
}

function setupAccessForm(chkBoxObj, formObj) {
  var hvs;  // howVals

  /* If we checked/unchecked a value that contains other values we need
     to uncheck and disable the contained boxes. */

  hvs = hows.getHows(chkBoxObj.value);

  if (hvs.contains == "") {
    // Doesn't contain anything
    return;
  }

  for (i = 0; i < formObj.howItem.length; i++) {
    if (hvs.doesContain(formObj.howItem[i].value)) {
      if (chkBoxObj.checked == true) {
        formObj.howItem[i].checked = false;
        formObj.howItem[i].disabled = true;
        // now iterate over corresponding radio buttons for each howItem
        for (j = 0; j < formObj[formObj.howItem[i].value].length; j++) {
          formObj[formObj.howItem[i].value][j].disabled = true;
        }
      } else {
        formObj.howItem[i].disabled = false;
      }
    }
  }
}

// enable and disable corresponding allow/deny flags when a howItem checkbox is
// clicked
function toggleAllowDenyFlag(chkBoxObj,formObj) {
  if (chkBoxObj.checked == true) {
    activateAllowDenyFlag(chkBoxObj.value, formObj, false);
  } else {
    activateAllowDenyFlag(chkBoxObj.value, formObj, true);
  }
}

// iterate over the allow/deny radio buttons and set them to true or false
function activateAllowDenyFlag(val,formObj,disabledFlag) {
  for (i = 0; i < formObj[val].length; i++) {
    formObj[val][i].disabled = disabledFlag;
  }
}
// Gather up the how values on access form submission and set the how field
// (method 1) or return the value (method 2).
// If in "basic" mode:
//   Set the value of how to the value of the basicHowItem radio button.
// If in "advanced" mode:
//   Each howItem (checkbox) has a corresponding allow/deny flag (radio button)
//   named after the howItem's value (e.g. "A","R","F","N", etc).
//   The allow/deny flag contains the final values to be returned with
//   the "-" switch if we set the value to deny (e.g. "A" or "-A", "R" or "-R").
// Method: there are two methods used with this function; method one sets
//   the "how" field in the form used to update a single principal.  Method
//   two returns the assembled how string to the calling function.
function setAccessHow(formObj,method) {
  var howString = "";
  if (formObj.setappvar[0].checked == true) { // "basic" mode is selected
    for (i = 0; i < formObj.basicHowItem.length; i++) {
      if (formObj.basicHowItem[i].checked == true) {
        howString = formObj.basicHowItem[i].value;
      }
    }
  } else { // "advanced" mode is selected
    for (i = 0; i < formObj.howItem.length; i++) {
      if (formObj.howItem[i].checked == true) {
        var howItemVal = formObj.howItem[i].value; // get the howItem value and
        for (j = 0; j < formObj[howItemVal].length; j++) { // look up the value from the corresponding allow/deny flag
          if (formObj[howItemVal][j].checked == true) {
            howString += formObj[howItemVal][j].value;
          }
        }
      }
    }
  }
  if (method == 2) {
    return howString;
  } else {
    formObj.how.value = howString;
  }
}


/* METHOD TWO FUNCTIONS*/
// Acces Control Entry (ACE) object


function bwAce(who,whoType,how,inherited,invert) {
  this.who = who;
  this.whoType = whoType;
  this.how = how;
  this.inherited = inherited;
  this.invert = invert; // boolean

  this.equals = function(ace) {
    if (this.whoType != ace.whoType) {
      return false;
    }

    return (this.formatWho() == ace.formatWho());
  }

  // format the who string for on-screen display
  this.formatWho = function() {
    if (whoType == "user" || whoType == "group") {
      return who;
    }

    if (whoType == "auth") {
      return authenticatedStr;
    }

    if (whoType == "unauth") {
      return unauthenticatedStr;
    }

    if (whoType == "owner") {
      return ownerStr;
    }

    if (whoType == "other") {
      return otherStr;
    }

    return "***************" + whoType;
  }

  this.toXml = function() {
    var res = "<ace><principal>\n";

    if (whoType == "user" || whoType == "group") {
      res += "<href>" + who + "</href>";
    } else if (whoType == "auth") {
      res += "<property>" + who + "</property>";
    }else if (whoType == "unauth") {
      res += "<property>" + who + "</property>";
    } if (whoType == "owner") {
      res += "<property>" + who + "</property>";
    } if (whoType == "other") {
      res += "<invert><principal>" + who + "</principal></invert>";
    }
    res += "</principal>";
    res += "<grant>";
    res += "<read/>";
    res += "</grant>";

    if (this.inherited != '') {
      res += "<inherited><href>" + this.inherited + "</href></inherited>";
    }

    return res + "</ace>";
  }

  // format the how string for on-screen display
  this.formatHow = function() {
    var formattedHow = "";

    for (i = 0; i < how.length; i++) {
      var h = how[i];
      if (h == "-") {
        formattedHow += "not-";
      } else {
        var hvs = hows.getHows(h);

        formattedHow += hvs.dispVal + " ";
      }
    }

    return formattedHow;
  }
}

// Access Control List (ACL) object - an array of ACEs
// The bwAcl object is initialized during the XSLT transform.
var bwAcl = new function() {
  var aces = new Array();

  // Initialize the list.
  // The function expects a comma-separated list of arguments grouped
  // into the five ACE properties.
  this.init = function(who,whoType,how,inherited,invert) {
    aces.push(new bwAce(who,whoType,how,inherited,invert));
  }

  // Add or update an ace
  this.addAce = function(newAce) {
    // expects a bwAce object as parameter
    for (i = 0; i < aces.length; i++) {
      if (aces[i].equals(newAce)) {
        // replace an existing ace
        aces[i] = newAce;
        return;
      }
    }
    // not found: add ace to end of array
    aces.push(newAce);
  }

  // Update the list - expects the browser form object
  this.update = function(formObj) {
    // get the type of ace being set
    var type;
    for (i = 0; i < formObj.whoType.length; i++) {
      if (formObj.whoType[i].checked == true) {
        type = formObj.whoType[i].value;
      }
    }
    // validate for user or group
    if ((type == 'user' || type == 'group') && formObj.who.value == '') {
      alert("you must enter a user or group name");
      formObj.who.focus();
      return;
    }
    // return the how string from the form
    var how = setAccessHow(formObj,2);
    // update the bwAcl
    bwAcl.addAce(new bwAce(formObj.who.value,type,how,"local",false));

    // update the acl form field
    formObj.acl = this.toXml();

    // redraw the display
    this.display();
  }

  this.deleteAce = function(index) {
    bwAcl.aces.splice(index, 1);

    // redraw the display
    this.display();
  }

  // update the ACL table displayed on screen
  this.display = function() {
    try {
      // get the table body
      var aclTableBody = document.getElementById("bwCurrentAccess").tBodies[0];

      // remove existing rows
      for (i = aclTableBody.rows.length - 1; i >= 0; i--) {
        aclTableBody.deleteRow(i);
      }

      // recreate the table rows
      for (var j = 0; j < aces.length; j++) {
        var formattedWho = aces[j].formatWho();
        var formattedHow = aces[j].formatHow();
        var tr = aclTableBody.insertRow(j);

        tr.insertCell(0).appendChild(document.createTextNode(formattedWho));
        tr.insertCell(1).appendChild(document.createTextNode(formattedHow));
        tr.insertCell(2).appendChild(document.createTextNode(aces[j].inherited));
        var td_3 = tr.insertCell(3);
        td_3.appendChild(document.createTextNode(''));
        //<a href="javascript:bwAcl.delete(' + j +')">' + deleteStr + '</a>
      }
    } catch (e) {
      alert(e);
    }
  }

  // generate webDAV ACl XML output
  this.toXml = function() {
    var res = "<acl>\n";

    for (var j = 0; j < aces.length; j++) {
      res += aces[j].toXml();
    }

    return res + "</acl>";
  }
}




