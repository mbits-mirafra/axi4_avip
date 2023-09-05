var g_cellClassRight = [ "odd_r", "even_r" ];
var g_cellClass = [ "odd", "even" ];
var g_b_divId;
var testHitDataScopeId;
var g_b_start_date;

function b_createCell(row, type, classt, span, txt, lnk, tooltip, relAttribute,
		filterLabel, c_align, styleColor) {
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
	if (tooltip) {
		var att = document.createAttribute('title');
		att.value = tooltip;
		newCell.setAttributeNode(att);
	}
	var newElement = document.createElement('a');
	if (lnk) {
		newElement.setAttribute("href", lnk);
	}
	if (relAttribute) {
		newElement.setAttribute("rel", relAttribute);
	}
	if (txt) {
		newElement.innerHTML = txt;
	}
	newCell.appendChild(newElement);

	if (filterLabel) {
		newCell.innerHTML = newCell.innerHTML + '&nbsp;';
		newElement = document.createElement('font');
		newElement.color = "#006699";
		newElement.innerHTML = "(Filtering Active)";
		newCell.appendChild(newElement);
	}
	if (styleColor) {
		newCell.style.color = styleColor;
	}

	row.appendChild(newCell);
	return;
};

function buildBranchTables() {
	g_b_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();

	g_b_divId = "b" + divId;
	testHitDataScopeId = divId;
	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";
	jsonScript.src = "b" + filenum + ".json";
	headID.appendChild(jsonScript);
}

function processBranchesData(g_data) {
	var divObj = document.getElementById("content");
	document.body.insertBefore(
			utils_getPageHeaderH1("Branch"),
			divObj);

	var buttonsTable = utils_getButtonsTable();
	document.body.insertBefore(
			buttonsTable,
			divObj);


	var show_excl_button = 0;

	var t = 0;

	var mainArr = g_data[g_b_divId];
	var divOfTable = 0;
	var celltxt = 0;
	var classtype = 0;
	var lnktxt = 0;
	var relAtt = 0;
	var alignTxt = 0;
	var styleTxt = 0;
	var srcInfo = 0;
	var lastRowOdd = 0;
	var grey = 0;
	var scopetooltip = 0;
	for (var int = 1; int < mainArr.length; int++) {
		divOfTable = document.createElement('div');
		if (mainArr[int].divIsX) {
			divOfTable.className = 'excluded';
		}

		table = document.createElement('table');
		table.cellSpacing = "2";
		table.cellPadding = "2";
		table.id = mainArr[int].anchore;

		var newRow = document.createElement('tr');
		var dataArr = mainArr[int].items;
		if (dataArr[0].z) {
			celltxt = dataArr[0]['z'].replace(">", "&gt;").replace("<", "&lt;");
		} else {
			celltxt = 0;
		}

		if (dataArr[0].hf) {
			lnktxt = dataArr[0]['hf'] + "#" + dataArr[0]['l'];
		} else {
			lnktxt = 0;
		}

		if (dataArr[0]['f']) {
			srcInfo = dataArr[0]['f'] + ":" + dataArr[0]['l'];
		} else {
			srcInfo = 0;
		}

		b_createCell(newRow, "TD", 0, 4, celltxt, lnktxt, srcInfo, 0, 0, 0, 0);

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
			var exComment = dataArr[0]['ec'];
			newRow.className = 'excluded';
			if (exComment) {
				celltxt = 'Excluded +';
				scopetooltip = exComment;
			} else {
				celltxt = 'Excluded';
			}
		}
		b_createCell(newRow, "TD", classtype, 0, celltxt, 0, scopetooltip, 0,
				0, 0, 0);
		table.appendChild(newRow);
		var newRow = document.createElement('tr');
		// newRow = table.rows[1];

		b_createCell(newRow, "TH", 'even', 2, 'Branch', 0, 0, 0, 0, 0, 0);
		b_createCell(newRow, "TH", 'even', 0, 'Source', 0, 0, 0, 0, 0, 0);
		b_createCell(newRow, "TH", 'even', 0, 'Hits', 0, 0, 0, 0, 0, 0);
		b_createCell(newRow, "TH", 'even', 0, 'Status', 0, 0, 0, 0, 0, 0);
		table.appendChild(newRow);
		for (var r = 1; r < dataArr.length; r++) {
			var excluded = 0;
			var tooltip = 0;
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
			classtype = 'invisible';
			celltxt = '&nbsp;';
			b_createCell(newRow, "TD", classtype, 0, celltxt, 0, 0, 0, 0, 0, 0);

			// // t is branch type
			tmp = dataArr[r]['t'];
			switch (tmp) {
			case 'I':
				celltxt = "IF";
				break;
			case 'E':
				celltxt = "ELSE";
				break;
			case 'T':
				celltxt = "TRUE";
				break;
			case 'F':
				celltxt = "FALSE";
				break;
			case 'A':
				celltxt = "ALL FALSE";
				break;
			default:
				celltxt = "&nbsp;";
			break;
			}
			b_createCell(newRow, "TD", g_cellClass[lastRowOdd], 0, celltxt, 0,
					0, 0, 0, 0, 0);

			if (dataArr[r]['f']) {
				srcInfo = dataArr[r]['f'] + ":"
				+ dataArr[r]['l'];
			} else {
				srcInfo = 0;
			}

			if (dataArr[r]['hf']) {
				lnktxt = dataArr[r]['hf'] + "#"
				+ dataArr[r]['l'];
			} else {
				lnktxt = 0;
			}

			if (dataArr[r]['z']) {
				celltxt = dataArr[r]['z'].replace(">", "&gt;")
				.replace("<", "&lt;");
			} else {
				celltxt = srcInfo;
			}

			b_createCell(newRow, "TD", g_cellClass[lastRowOdd], 0, celltxt,
					lnktxt, srcInfo, 0, 0, 0, 0);

			tmp = dataArr[r]['h'];
			if (tmp) {
				classtype = g_cellClassRight[lastRowOdd];
				hrefLnk = dataArr[r]['k'];
				if (hrefLnk) {
					lnktxt = "pertest.htm?bin=b" + hrefLnk + "&scope="
					+ testHitDataScopeId;
					relAtt = 'popup 200 200';
				} else {
					lnktxt = relAtt = 0;
				}
				celltxt = tmp;
				alignTxt = 0;
			} else {
				classtype = g_cellClass[lastRowOdd];
				alignTxt = "center";
				celltxt = "--";
			}
			if (excluded) {
				styleTxt = "dimGrey";
				var exComment = dataArr[r]['ec'];
				if (exComment) {
					celltxt = celltxt + ' +';
					tooltip = exComment;
				}
			}
			b_createCell(newRow, "TD", classtype, 0, celltxt, lnktxt, tooltip,
					relAtt, 0, alignTxt, styleTxt);

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
			b_createCell(newRow, "TD", classtype, 0, celltxt, 0, 0, 0, 0, 0, 0);

			lastRowOdd = lastRowOdd ? 0 : 1;
			table.appendChild(newRow);
		}

		divObj.appendChild(document.createElement('hr'));
		divOfTable.appendChild(table);
		divObj.appendChild(divOfTable);
	}
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
	var diff = date - g_b_start_date;
	if (urlArgsObj.getPerf()) {
		console.save(g_b_divId +", " + (diff/1000), "b_console.txt");
	}
}
