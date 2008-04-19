// Bedework x-property functions

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


// ========================================================================
// Bedework specific x-properties
// ========================================================================

var bwXPropertyImage = "X-BEDEWORK-IMAGE";
var bwXParamDescription = "X-BEDEWORK-PARAM-DESCRIPTION";
var bwXParamWidth = "X-BEDEWORK-PARAM-WIDTH";
var bwXParamHeight = "X-BEDEWORK-PARAM-HEIGHT";

var bwXPropertySubmittedBy = "X-BEDEWORK-SUBMITTEDBY";
var bwXPropertySubmitComment = "X-BEDEWORK-SUBMIT-COMMENT";


// ========================================================================
// x-property functions
// ========================================================================

var bwXProps = new BwXProperties();

/* An xproperty
 * name:   String - name of x-property, e.g. "X-BEDEWORK-IMAGE"
 * params: 2-D Array of parameter name/value pairs,
 *         e.g. params[0] = ["X-BEDEWORK-PARAM-DESCRIPTION","a lovely image"]
 * value:  String - value of x-property
 */
function BwXProperty(name, params, value) {
  this.name = name;
  this.params = params;
  this.value = value;

  this.format = function() {
    var curXparams = "";
    if (this.params.length) {
      for (var i = 0; i < this.params.length; i++) {
        curXparams += ";" + this.params[i][0] + "=" + this.params[i][1];
      }
    }
    return this.name + curXparams + ":" + this.value;
  }
}

function BwXProperties() {
  var xproperties = new Array();

  this.init = function(name, params, value) {
     var xprop = new BwXProperty(name, params, value);
     xproperties.push(xprop);
  }

  this.update = function(name, params, value, isUnique) {
    var xprop = new BwXProperty(name, params, value);
    if (isUnique && this.contains(name)) {
      index = this.getIndex(name);
      xproperties.splice(index,1,xprop);
    } else {
      xproperties.push(xprop);
    }
  }

  this.contains = function(name) {
    for (var i = 0; i < xproperties.length; i++) {
      var curXprop = xproperties[i];
      if (curXprop.name == name) {
        return true;
      }
    }
    return false;
  }

  this.getIndex = function(name) {
    for (var i = 0; i < xproperties.length; i++) {
      var curXprop = xproperties[i];
      if (curXprop.name == name) {
        return i;
      }
    }
    return null;
  }

  this.generate = function(formObj) {
    for (var i = 0; i < xproperties.length; i++) {
      var xpropField = formObj.appendChild(document.createElement("input"));
      xpropField.type = "hidden";
      xpropField.name = "xproperty";
      xpropField.value = xproperties[i].format();
      // alert(xproperties[i].format());
    }
  }

}

function setBedeworkXProperties(formObj,submitter) {
  // set up specific Bedework X-Properties on event form submission

  // X-BEDEWORK-IMAGE and its parameters:
  if (formObj["xBwImageHolder"] && formObj["xBwImageHolder"].value != '') {
    bwXProps.update(bwXPropertyImage,[[bwXParamDescription,''],[bwXParamWidth,''],[bwXParamHeight,'']],formObj["xBwImageHolder"].value,true);
  }
  // X-BEDEWORK-SUBMITTEDBY
  bwXProps.update(bwXPropertySubmittedBy,[],submitter,true);

  // commit all xproperties back to the form
  bwXProps.generate(formObj);
}
