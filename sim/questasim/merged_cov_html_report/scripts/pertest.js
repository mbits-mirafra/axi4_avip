function GetScopeIdBinIdClass() {
	this.scopeId;
	this.binId;
	
	var qs = location.search.substring(1, location.search.length);
	var args = qs.split('&');
	var pair;
	
	pair = args[0].split('=');
	this.binId = pair[1];
	
	pair = args[1].split('=');
	this.scopeId = pair[1];
}
GetScopeIdBinIdClass.prototype.getBinId = function() {
	return this.binId;
}
GetScopeIdBinIdClass.prototype.getScopeId = function() {
	return this.scopeId;
}

var myObj = new GetScopeIdBinIdClass();
var scopeId = myObj.getScopeId();
var binId = myObj.getBinId();

var headID = document.getElementsByTagName("head")[0];
var jsonScript = document.createElement('script');
jsonScript.type = "text/javascript";
jsonScript.src = "p" + scopeId + ".json";
headID.appendChild(jsonScript);

function addCell(row, cellData) {
	var newCell = document.createElement('td');
	newCell.innerHTML = cellData;
	row.appendChild(newCell);
}

function processJSON() { /* called by the JSON file */
	var table = document.getElementsByTagName("TABLE")[0]; // single table in the page
	for (var i=1 ; i < binData[binId].length; i++) { // start from 1 to skip the header row
		var newRow = document.createElement('tr');
		if (nonlossy_merge) {
			addCell(newRow, testNames[binData[binId][i][0]]);
			addCell(newRow, testNames[binData[binId][i][1]]);
		} else {
			addCell(newRow, testNames[binData[binId][i]]);
		}
		table.appendChild(newRow);
	}
	start_sort = 1;
}
