/**
 * @author plarson
 */

 function toggleDiv(id) {
	var divOne = document.getElementById(id);
	if ( divOne.style.display != 'none' ) {
		divOne.style.display = 'none';
	}
	else {
		divOne.style.display = '';
	}
	return false;
} 