/**
 * @author jeremy
 */
function initCat() {
	var handleForm = new CatForm;
	handleForm.validForm();
	handleForm.searchField();
	
	return handleForm.retVal;
}

function CatForm() {
	this.retVal = true;
	this.myCatStr = '';
	this.theForm = document.getElementById('advSearchForm');
}

CatForm.prototype.validForm = function() {
	var currForm = this.theForm;
	for (var i = 0; i < currForm.elements.length; i++) {
		if(currForm.elements[i].type === "checkbox" && currForm.elements[i].checked) {
			this.myCatStr += "category: " + currForm.elements[i].value + " ";
		}
	}
	
	return;
}
CatForm.prototype.searchField = function() {
	var searchVal = this.theForm.query.value;
	var trimmed = searchVal.replace(/^\s+|\s+$/g, '') ;
	if(trimmed === '') {
		if (this.myCatStr === '') {
			this.retVal = false;
		} else {
			this.theForm.query.value = "(" + this.myCatStr + ") AND category:Main";
		}
	} else {
		if(this.myCatStr != '') {
			this.theForm.query.value = "(" + this.theForm.query.value + " AND " + this.myCatStr + ") AND category:Main";
		} else {
			this.theForm.query.value += " AND category:Main";
		}
	}
	
	return;
}
