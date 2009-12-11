/**
 * @author jeremy
 */
// for initializing (GET) bedework sessions and add new items (POSTING)

// Functions

function retrieveIds(getWhat) { // Order of arrays is important, they must stay in sync
	var myReturn = undefined;
	if (getWhat === 'selects') {
		myReturn = ['eventFormLocationList', 'eventFormPrefContactList', 'allCategoryCheckboxes'];
	} else if (getWhat === 'items') {
		myReturn = ['theLocations', 'theContacts', 'theCategories'];
	} else {
		myReturn = [['location', 'eventFormLocationList'], ['contact','eventFormPrefContactList'], ['category', 'allCategoryCheckboxes']];
	}

	return myReturn;
}
function locateId(find) {
	var returnId = undefined;
	var multiArr = retrieveIds('multiDim');
	for (var p in multiArr) {
		if (p[0] === find) {
			returnId = p[1];
		}
	}
	
	return returnId;
}
function postCallback(type, data, evt){
    if (type == 'error') {
        var errorStr = '';
        //console.log(data);
        for (var p in data) {
            errorStr += p;
        }
        alert('Error when retrieving data from the server! ' + p);
    }
    else {
        //alert(data);
        console.log('Post callback success.');
        //handlePost('submit', 'location', 'addLocationForm');
    }
	
	return;
}

function getPostCallback(type, data, evt){
    if (type == 'error') {
        var errorStr = '';
        //console.log(data);
        for (var p in data) {
            errorStr += p;
        }
        alert('Error when retrieving data from the server! ' + p);
    }
    else {
        //alert(data);
        console.log('Get callback success.');
        //handlePost('submit', 'location', 'addLocationForm');
    }
	
	return;
}

function scrapeData(type, data, evt) {
	 if (type == 'error') {
        var errorStr = '';
        //console.log(data);
        for (var p in data) {
            errorStr += p;
        }
        alert('Error when retrieving data from the server! ' + p);
    }
    else {
        //alert(data);
		var animation = dojo.byId('loadingAnim');
		//alert(animation.style.display)
		animation.style.display ="none";
		var formElement = document.createElement('div');
		formElement.innerHTML = data;
		var selectsArr = formElement.getElementsByTagName("select");
		for (var i=0; i<selectsArr.length; i++) {
			console.log(selectsArr[i])
			};
		};

	return;
}

// Objects

// DataObject for interfacing with bedework
function DataObj(){
    this.itemType = undefined; 	// event, category, location, contact
    this.actionUrl = undefined; // URL for GET or POST operations
    this.formId = undefined; 	// Id of form requesting the Data Object
}
DataObj.prototype.setFormId = function(formId) {
	this.formId = formId;
	
	return this.formId;
}
DataObj.prototype.setItemType = function(itemType) {
	this.itemType = itemType;
	
	return this.itemType;
}
DataObj.prototype.setActionUrl = function(getPost){
  		var preUrl = '/caladmin/' + this.itemType + '/';
        if (getPost === 'init') {
            preUrl += 'initAdd.do';
        }
        else {
			if (getPost === 'submit') {
				preUrl += 'update.do';	
			} else {
				preUrl = 'showModForm.rdo?noxslt=yes';
			}
            
        }
        this.actionUrl = preUrl;
		
        return this.actionUrl;
}


DataObj.prototype.sendReceiveData = function(){	
    if (this.getPost === 'init') {
		//var animation = dojo.byId('loadingAnim');
		//alert(animation.style.display);
		//animation.style.display ="block";
		var mySync = "true";
        //   url: actionUrl,'/caladmin/location/initAdd.do'
        dojo.io.bind({
            sync: mySync,
            method: "GET",
            url: this.actionUrl,
            handler: getPostCallback,
            content: {
                b: 'de'
            }
            //For GET: //content: {name: dojo.byId('name').value }
        });
    } else {
        dojo.io.bind({
            sync: "true",
            method: "POST",
            url: this.actionUrl,
            handler: postCallback,
            formNode: this.formId
            //For POST: //formNode: dojo.byId('myForm')
        });
    }
	
    return;
}

DataObj.prototype.retrieveForm = function() {
	//var formId = this.formId;
	var updateId = locateId(this.itemType);
	//var itemType = this.itemType;
	//var selectIds = retrieveIds('selects');
	var retrieveData = function(type, data, evt) {
		if (type == 'error') {
	        var errorStr = '';
	        //console.log(data);
	        for (var p in data) {
	            errorStr += p;
	        }
	        alert('Error when retrieving data from the server! ' + p);
	    } else {
			alert(foobar);
	        //alert(data);
			var animation = dojo.byId('loadingAnim');
			//alert(animation.style.display)
			animation.style.display ="none";
			var formElement = document.createElement('div');
			formElement.innerHTML = data;
			var selectsArr = formElement.getElementsByTagName("select");
			for (var i=0; i<selectsArr.length; i++) {
					if(selectsArr[i].name === updateId) {
						alert(updateId);
					}
					console.log(selectsArr[i])
				};
			};
			
		return;
	}
	 try {
	 		var animation = dojo.byId('loadingAnim');
			//alert(animation.style.display);
			animation.style.display ="block";
	 		dojo.io.bind({
	            sync: "false",
	            method: "GET",
	            url: this.actionUrl,
	            handler: retrieveData,
	            content: {}
	  		});
	} catch (e) {
		alert("failed form retrieval.")
	}

	 return;
}
// Create links for dynamic forms.  Position and alter display of Add Item Menu.

function BlockHost(){
    this.eleId = 'theHost'; 		// Main div that contacts forms
    this.hostsId = undefined; 		// Array of div ids to host relativeId item forms
    this.relativeId = undefined; 	// Array of Ids
    this.actionId = undefined; 		// # empty href, could be url for non JS browsers
}

BlockHost.prototype.build = function(itemId, itemHosts){
    this.relativeId = itemId;  // Array of Ids
    this.hostsId = itemHosts;  // Array of div ids to host relativeId item forms
    this.actionId = '#';
	var closeLink = dojo.byId('theHostClose');
	
	var closeForm = function() {
		this.parentNode.style.display = 'none';
		
		return false;
	}
	closeLink.onclick = closeForm;
    
    return;
}

BlockHost.prototype.createLink = function(){
    var currArr = this.relativeId;
    var hostEleId = this.eleId;
    var myItemsArr = this.hostsId;
	
	// Internal methods
    var toggleBlock = function(targetId){
        for (var i = 0; i < myItemsArr.length; i++) {
            if (targetId === currArr[i] + 'Link') {
                var currEle = document.getElementById(myItemsArr[i]);
                currEle.style.display = 'block';
            }
            else {
                var nonCurrEle = document.getElementById(myItemsArr[i]);
                nonCurrEle.style.display = 'none';
            }
        }
		
    }
	
    var findPos = function(obj){
        var curleft = curtop = 0;
        if (obj.offsetParent) {
            do {
                curleft += obj.offsetLeft;
                curtop += obj.offsetTop;
            }
            while (obj = obj.offsetParent);
                    }
        else {
            alert('Your browser does not support offsetParent, sorry.')
        }
		
        return [curleft, curtop];
    }
	
    var handleLink = function(){
            var posArr = findPos(this);
            var theHost = document.getElementById(hostEleId);
            toggleBlock(this.id);
            theHost.style.left = posArr[0] + 'px';
            theHost.style.top = posArr[1] + 'px';
            if (theHost.style.display === 'none') {
                theHost.style.display = 'block';
            }
			
			return false;  // To prevent hyperlink href from reacting to click
    }
	
    for (var i = 0; i < currArr.length; i++) {
        var locList = document.getElementById(currArr[i]);
        var contTd = locList.parentNode;
        var addLink = document.createElement('a');
        var formType = currArr[i];
        var addLinkHref = document.createAttribute('href');
        var linkText = document.createTextNode('Add New');
		addLink.className = 'dynamicLink';
		addLink.onclick = handleLink;
        addLinkHref.value = this.actionId;
        addLink.id = currArr[i] + 'Link';
        addLink.setAttributeNode(addLinkHref);
        addLink.appendChild(linkText);
        contTd.appendChild(addLink);
    }
    
    return;
}

// Script

// handles form submission
function handleSubmit(submitterId, submitterType){
    var submitId = submitterId;
    var itemType = submitterType;
    var dataSuccess = false;

    // create new instances of data objects here.
	var dataDo = new DataObj;
	dataDo.setFormId(submitterId);
	dataDo.setItemType(itemType);
	
	// Prepare session for POST
	
	dataDo.setActionUrl('init');

	try {
		dataDo.sendReceiveData();
		dataSuccess = true;
		console.log("Initialization complete!\n\n");
	} catch (e) {
		dataSuccess = false;
		console.log(e);
	}
	
	// Send form variables via post
	if (dataSuccess) {
		dataDo.setActionUrl('submit');
		try {
			dataDo.sendReceiveData();
			dataSuccess = true;
			console.log("Data insert complete!\n\n");
		} catch (e) {
			dataSuccess = false;
			console.log(e);
		}
	} else {
		console.log("No form post attempted, init failed.")
	}

	if (dataSuccess) {
		dataDo.setItemType('event');
		dataDo.setActionUrl('eventForm');
		dataDo.retrieveForm();
	}
	// Todo: scrape /caladmin/event/showModForm.rdo?noxslt=yes for new location, category, or contact information
	
    return;
}

function addToInit(){
    // Keep Arrays in sync
    var idArr = retrieveIds('selects');  // Ids of form elements to add items
    var myItemsArr = retrieveIds('items');							 // Ids of hidden forms for adding
    var buildBlock = new BlockHost;
    buildBlock.build(idArr, myItemsArr);
    buildBlock.createLink();
	
    return;
    
}


