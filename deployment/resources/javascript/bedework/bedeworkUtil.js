/* Bedework Javascript utility functions */

function trim(str) {
  if (str.length < 1) {
    return"";
  }
  str = rightTrim(str);
  str = leftTrim(str);

  if(str == "") {
    return "";
  } else {
    return str;
  }
}

function rightTrim(str) {
  var w_space = String.fromCharCode(32);
  var v_length = str.length;
  var strTemp = "";

  if(v_length < 0) {
    return "";
  }
  var iTemp = v_length - 1;
  while(iTemp > -1){
    if(str.charAt(iTemp) != w_space) {
      strTemp = str.substring(0,iTemp +1);
      break;
    }
    iTemp = iTemp-1;
  }
  return strTemp;
}

function leftTrim(str) {
  var w_space = String.fromCharCode(32);
  if(v_length < 1) {
    return "";
  }
  var v_length = str.length;
  var strTemp = "";
  var iTemp = 0;

  while(iTemp < v_length) {
    if(str.charAt(iTemp) != w_space) {
      strTemp = str.substring(iTemp,v_length);
      break;
    }
    iTemp = iTemp + 1;
  }
  return strTemp;
}

// DHTML email validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
  function echeck(str) {
    var at="@"
    var dot="."
    var lat=str.indexOf(at)
    var lstr=str.length
    var ldot=str.indexOf(dot)
    if (str.indexOf(at)==-1) {
       return false
    }
    if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr) {
       return false
    }
    if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr) {
        return false
    }
    if (str.indexOf(at,(lat+1))!=-1) {
      return false
    }
    if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot) {
      return false
    }
    if (str.indexOf(dot,(lat+2))==-1) {
      return false
    }
    if (str.indexOf(" ")!=-1) {
      return false
    }
   return true
 }
