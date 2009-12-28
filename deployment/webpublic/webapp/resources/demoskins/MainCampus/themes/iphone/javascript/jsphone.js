function gotourl(e, url){
 e.style.color = '#900';
 setTimeout('go(\'' + e.id + '\', \'' + url + '\')', 400);
}
function go(eid, url){
   document.getElementById(eid).style.color = '';
   window.location = url;
}