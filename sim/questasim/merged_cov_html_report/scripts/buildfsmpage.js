var g_cellClass = [ "odd", "even" ];
var g_cellClassRight = [ "odd_r", "even_r" ];
var g_fsm_divId;
var testHitDataScopeId;
var g_f_start_date;

function f_createCell(row, type, classt, span, txt, lnk, relAttribute, c_align,
		styleColor, tooltip) {
	var newCell = document.createElement(type);
	if (classt) {
		newCell.className = classt;
	}
	if (span > 1) {
		newCell.colSpan = span;
	}
	if (c_align) {
		newCell.align = c_align;
	}
	if (styleColor) {
		newCell.style.color = styleColor;
	}
	if (lnk) {
		var newElement = document.createElement('a');
		newElement.setAttribute("href", lnk);
		if (relAttribute) {
			newElement.setAttribute("rel", relAttribute);
		}
		newElement.innerHTML = txt;
		newCell.appendChild(newElement);
	} else {
		newCell.innerHTML = txt;
	}
	if (tooltip) {
		newCell.setAttribute("title", tooltip);
	}

	row.appendChild(newCell);
	return;
};

function buildFsmTables() {
	g_f_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();
	
	g_fsm_divId = "f" + divId;
	testHitDataScopeId = divId;
	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";
	jsonScript.src = "f" + filenum + ".json";
	headID.appendChild(jsonScript);
}

function processFsmData(g_data) {
	var show_excl_button = 0;
	var buttonsTable = 0;
	var t = 0;
	var grey = 0;
	var newRow = 0;
	var classtype = 0;
	var celltxt = 0;
	var tmp = 0;

	var divObj = document.getElementById("content");

	// creating the title and header of the page
	if (g_data[g_fsm_divId].isPa) {
		document.body.insertBefore(
			utils_getPageHeaderH1(g_data[g_fsm_divId].isPa.title),
			divObj);

		var h4;
		h4 = document.createElement('h4');
		h4.innerHTML = 'UPF Object Type: ' + g_data[g_fsm_divId].isPa.objType;
		document.body.insertBefore(h4, divObj);
		
		h4 = document.createElement('h4');
		h4.innerHTML = 'UPF Object Path: ' + g_data[g_fsm_divId].isPa.objPath;
		document.body.insertBefore(h4, divObj);
	} else {
		document.body.insertBefore(
			utils_getPageHeaderH1("State-Machine"),
			divObj);
	}

	buttonsTable = utils_getButtonsTable();
	document.body.insertBefore(buttonsTable, divObj);
	
	var dataArr;
	var allFsms = g_data[g_fsm_divId].FSMs;
	var divOfTable = 0;
	var table = 0;
	for (var i=1 ; i<allFsms.length ; i++) {
		divOfTable = document.createElement('div');
		if (allFsms[i].divIsX) {
			divOfTable.className = 'excluded';
		}
		table = document.createElement('table');
		table.cellSpacing = "2";
		table.cellPadding = "2";
		table.id = allFsms[i].anchor;
		dataArr = allFsms[i].items;

		newRow = document.createElement('tr');

		celltxt = dataArr[0]['z'];
		f_createCell(newRow, 'TD', 0, "3", celltxt, dataArr[0]['lnk'], 0, 0, 0, 0);

		tmp = dataArr[0]['c'];
		switch (tmp) {
		case 'R':
			classtype = 'bgRed';
			break;
		case 'Y':
			classtype = 'bgYellow';
			break;
		case 'G':
			classtype = 'bgGreen';
			break;
		case 'e':
			classtype = 'grey';
			grey = 1;
			show_excl_button = 1;
			break;
		default:
			classtype = '';
			break;
		}
		if (grey == 0) {
			celltxt = dataArr[0]['p'] + "%";
		} else {
			celltxt = 'Excluded';
			newRow.className = 'excluded';
		}
		f_createCell(newRow, 'TD', classtype, 0, celltxt, 0, 0, 0, 0, 0);
		table.appendChild(newRow);

		newRow = document.createElement('tr');

		f_createCell(newRow, 'TH', 'even', "2", 'States / Transitions', 0, 0, 0, 0,
				0);
		f_createCell(newRow, 'TH', 'even', 0, 'Hits', 0, 0, 0, 0, 0);
		f_createCell(newRow, 'TH', 'even', 0, 'Status', 0, 0, 0, 0, 0);
		table.appendChild(newRow);
		var lastRowOdd = 0;
		// loop on the rest of the rows
		for (var r = 1; r < dataArr.length; r++) {
			var excluded = 0;
			var exComment = 0;
			var alignTxt = 0;
			var columnSpan = 0;
			var lnktxt = 0;
			var relAtt = 0;

			// newRow = dataArr[r];
			newRow = document.createElement('tr');
			// row class if existing
			tmp = dataArr[r]['cr'];
			switch (tmp) {
			case 'c':
				newRow.className = 'covered';
				break;
			case 'm':
				newRow.className = 'missing';
				break;
			case 'e': // excluded
				excluded = 1;
				newRow.className = 'excluded';
				show_excl_button = 1;
				break;
			default:
				newRow.className = '';
				break;
			}

			if (dataArr[r]['s']) {
				classtype = g_cellClass[lastRowOdd];
				columnSpan = "2";
				celltxt = 'State: ' + dataArr[r]['z'];
			} else {
				f_createCell(newRow, 'TD', 'invisible', 0, '&nbsp;', 0, 0, 0, 0, 0);

				classtype = g_cellClass[lastRowOdd];
				columnSpan = 0;
				celltxt = 'Trans: ' + dataArr[r]['z'];
			}
			f_createCell(newRow, 'TD', classtype, columnSpan, celltxt, 0, 0, 0, 0,
					0);
			tmp = dataArr[r]['h'];
			if (tmp) {
				classtype = g_cellClassRight[lastRowOdd];
				var hrefLnk = dataArr[r]['lnk'];
				if (hrefLnk) {
					lnktxt = "pertest.htm?bin=f" + hrefLnk + "&scope="
							+ testHitDataScopeId;
					relAtt = 'popup 200 200';
				} else {
					lnktxt = relAtt = 0;
				}
				celltxt = tmp;
				if (excluded) {
					exComment = dataArr[r]['ec'];
					if (exComment) {
						celltxt = celltxt + ' +';
					}
				}
				alignTxt = 0;
			} else {
				classtype = g_cellClass[lastRowOdd];
				alignTxt = "center";
				celltxt = "--";
				lnktxt = relAtt = 0;
			}
			f_createCell(newRow, 'TD', classtype, 0, celltxt, lnktxt, relAtt,
					alignTxt, excluded ? "dimGrey" : 0, exComment);

			if (excluded == 0) {
				tmp = dataArr[r]['c'];
				switch (tmp) {
				case 'g':
					classtype = 'green';
					celltxt = 'Covered';
					break;
				case 'r':
					classtype = 'red';
					celltxt = 'ZERO';
					break;
				default:
					classtype = '';
					break;
				}
			} else {
				classtype = 'grey';
				celltxt = 'Excluded';
			}
			f_createCell(newRow, 'TD', classtype, 0, celltxt, 0, 0, 0, 0, 0);
			lastRowOdd = lastRowOdd ? 0 : 1;
			table.appendChild(newRow);
		}
		
		divObj.appendChild(document.createElement('hr'));
		divOfTable.appendChild(table);
		divObj.appendChild(divOfTable);
		
	} // end for (allFsms)
	if (show_excl_button == 1) {
		if (buttonsTable) {
			var newCell = document.createElement('TD');
			newCell.id = "showExcl";
			newCell.width = 106;
			newCell.setAttribute("onclick", "showExcl()");
			newCell.className = "button_off";
			newCell.title = "Display only excluded scopes and bins.";
			newCell.innerHTML = "Show Excluded";
			buttonsTable.rows[0].appendChild(newCell);
		}
	}
	var date = new Date();
    var diff = date - g_f_start_date;
    if (urlArgsObj.getPerf()) {
    console.save(g_fsm_divId +", " + (diff/1000), "f_console.txt");
    }
}
