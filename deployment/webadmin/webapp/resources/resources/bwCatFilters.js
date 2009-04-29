// take the specifically formatted filter expression
// catuid=(uid1,uid2,uid3,uidN)
// and store in an array used for setting category filters
// (checkboxes) on calendar collections
var catFilters = new Array;
function initCatFilters(filterExpression) {
  var uids = "";
  if (filterExpression.indexOf("catuid=(") != -1) {
    uids = substring(filterExpression,filterExpression.indexOf("catuid=(")+8);
    uids = substring(uids,0,uids.indexOf(")")-1);

    catFilters = uids.split(",");
  }
}
function setCatFilters(formObj) {

}
function setCatFilterCheckboxes(formObj) {
/*  if (typeof formObj.filterCatUid.length != 'undefined') {
    for (i = 0; i < formObj.filterCatUid.length; i++) {

      if (formObj.filterCatUid[i].checked) {
        hasACat = true;
        break;
      }
    }
  }*/
}
