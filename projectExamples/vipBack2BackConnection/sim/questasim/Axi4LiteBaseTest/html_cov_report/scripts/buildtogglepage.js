var g_cellClass = [ "odd", "even" ];
var g_cellClassRight = [ "odd_r", "even_r" ];
var g_cellClassGrey = [ "oddGrey", "evenGrey" ];
var g_t_divId;
var g_t_start_date;
var testHitDataScopeId;

function t_createCell(row, type, classt, rspan, cspan, txt, lnk, relAttribute,
		c_align, styleColor, titleText, preTxtVal, exTxt) {
	var newCell = document.createElement(type);
	var newElement;
	if (classt) {
		newCell.className = classt;
	}
	if (cspan > 1) {
		newCell.colSpan = cspan;
	}
	if (rspan > 1) {
		newCell.rowSpan = rspan;
	}
	if (c_align) {
		newCell.align = c_align;
	}
	if (styleColor) {
		newCell.style.color = styleColor;
	}
	if (titleText) {
		newCell.setAttribute("title", titleText);
	}
	if (lnk) {
		newElement = document.createElement('a');
		newElement.setAttribute("href", lnk);
		if (relAttribute) {
			newElement.setAttribute("rel", relAttribute);
		}
		if (titleText) {
			newElement.setAttribute("title", titleText);
		}
		newElement.innerHTML = txt;
		newCell.appendChild(newElement);
	} else {
		newCell.innerHTML = txt;
	}
	if (preTxtVal) {
		newCell.innerHTML = newCell.innerHTML + preTxtVal;
	}
	if (exTxt) {
		newCell.innerHTML = newCell.innerHTML + '&nbsp;' + exTxt;
	}
	row.appendChild(newCell);
	return;
};
function createToggleCell(row, type, toggleCount, h_count, exComment, sTxt,
		excluded, lastRowIsOdd, data) {
	var tmp = data[toggleCount];
	var alignTxt = styleTxt = 0;
	var classOfTheCell;
	var lnktxt;
	var relAtt;
	var celltxt;
	var exCommentTxt = 0;
	var preTxt = 0;
	if (tmp) {
		classOfTheCell = g_cellClassRight[lastRowIsOdd];
		lnktxt = "pertest.htm?bin=t" + tmp + "&scope=" + testHitDataScopeId;
		relAtt = 'popup 200 200';
		celltxt = data.h1;
	} else {
		var bin_excluded = 0;
		lnktxt = relAtt = 0;
		tmp = data[h_count];
		if (tmp) {
			classOfTheCell = g_cellClassRight[lastRowIsOdd];
			celltxt = tmp;
			if (tmp.charAt(0) == 'E') {
				bin_excluded = 1;
			}
		} else {
			classOfTheCell = g_cellClass[lastRowIsOdd];
			alignTxt = 'center';
			celltxt = '--';
		}
		if (excluded || bin_excluded) {
			styleTxt = "dimGrey";
			exCommentTxt = data[exComment];
			if (exCommentTxt) {
				preTxt = "&nbsp;+";
			}
		}
	}
	t_createCell(row, type, classOfTheCell, 0, 0, celltxt, lnktxt, relAtt,
			alignTxt, styleTxt, exCommentTxt, preTxt, sTxt);
	return;
};

function buildToggleTable() {
	g_t_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();

	g_t_divId = "t" + divId;
	testHitDataScopeId = divId;
	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";
	jsonScript.src = "t" + filenum + ".json";
	headID.appendChild(jsonScript);

}

function processTogglesData(g_data) {
	var divObj = document.getElementById("content");
	document.body.insertBefore(
		utils_getPageHeaderH1("Toggle"),
		divObj);
		
	var buttonsTable = utils_getButtonsTable();
	document.body.insertBefore(
		buttonsTable,
		divObj);

	var show_excl_button = 0;
	var table = 0;
	var t = 0;
	table = document.createElement('table');
	var tbody = document.createElement('tbody');
    // adjust the table attributes
	table.cellSpacing = "2";
	table.cellPadding = "2";

	var newRow = document.createElement('tr');
	/**
	 * **************************** Start of row 0
	 * **********************************
	 */
	// create the table header cells and append them
	t_createCell(newRow, 'TH', 'odd', '2', '2', 'Signal / Value', 0, 0,
			0, 0, 0, 0, 0);
	t_createCell(newRow, 'TH', 'odd', 0, '6', 'Hits', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'odd', '2', 0, 'ExtMode', 0, 0, 0, 0, 0,
			0, 0);
	t_createCell(newRow, 'TH', 'odd', '2', 0, 'Status', 0, 0, 0, 0, 0,
			0, 0);
	tbody.appendChild(newRow);
	/**
	 * **************************** End of row 0
	 * **********************************
	 */
	newRow = document.createElement('tr');
	t_createCell(newRow, 'TH', 'even', 0, 0, '0L->1H', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'even', 0, 0, '1H->0L', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'even', 0, 0, '0L->Z', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'even', 0, 0, 'Z->1H', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'even', 0, 0, '1H->Z', 0, 0, 0, 0, 0, 0,
			0);
	t_createCell(newRow, 'TH', 'even', 0, 0, 'Z->0L', 0, 0, 0, 0, 0, 0,
			0);
	tbody.appendChild(newRow);
	/**
	 * **************************** End of row 1
	 * **********************************
	 */

	var lastRowOdd = 0;
	// Loop on the rows of the table
	var dataArr = g_data[g_t_divId].items;
	for (var r = 1; r < dataArr.length; r++) {
		newRow = document.createElement('tr');	
		var tmp;
		var excluded = 0;
		var columnSpan;
		var classtype;
		var celltxt;
		
		newRow.id = dataArr[r].id;
		tmp = dataArr[r].s;
		if (tmp)
			columnSpan = tmp;
		else
			columnSpan = 0;

		// row class if existing
		tmp = dataArr[r].cr;
		switch (tmp) {
		case 'c':
			newRow.className = 'covered';
			break;
		case 'm':
			newRow.className = 'missing';
			break;
		case 'n':
			newRow.className = 'neutral';
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

		tmp = dataArr[r].st;
		if (tmp) {
			/* colSpan is 1 */
			/* simple toggle */
			t_createCell(newRow, 'TD', 'invisible', 0, columnSpan, '&nbsp;', 0,
					0, 0, 0, 0, 0, 0);

			t_createCell(newRow, 'TD',
					(excluded == 1) ? g_cellClassGrey[lastRowOdd]
							: g_cellClass[lastRowOdd], 0, 0, dataArr[r].z, 0, 0, 0, 0, 0, 0, 0);
		} else {
			var preTxt;
			var titleTxt;
			var lnktxt;

			classtype = g_cellClass[lastRowOdd];
			tmp = dataArr[r].lnk;
			if (tmp) {
				lnktxt = tmp;
				tmp = dataArr[r].t;
				celltxt = dataArr[r].z;
				if (tmp) {
					// in case there is a text in the cell i.e [alias]
					titleTxt = tmp;
					preTxt = '&nbsp;[alias]';
				} else {
					preTxt = titleTxt = 0;
				}
			} else {
				preTxt = lnktxt = 0;
				tmp = dataArr[r].t;
				if (tmp) {
					// in case there is a text in the cell i.e [alias]
					celltxt = dataArr[r]['z'] + '&nbsp;[alias]';
					titleTxt = tmp;
				} else {
					celltxt = dataArr[r].z;
					titleTxt = 0;
				}
			}
			if (excluded == 1) {
				classtype = g_cellClassGrey[lastRowOdd];
				tmp = dataArr[r].ec;
				if (tmp) {
					if (preTxt) {
						preTxt = preTxt + "&nbsp;+";
					} else {
						preTxt = "&nbsp;+";
					}
					if (titleTxt) {
						titleTxt = "Canonical Name: " + titleTxt
								+ " \nExclusion Comment: \n" + tmp;
					} else {
						titleTxt = tmp;
					}
				}
			}
			t_createCell(newRow, 'TD', classtype, 0, columnSpan, celltxt,
					lnktxt, 0, 0, 0, titleTxt, preTxt, 0);
		}
		// ///////////////////////////////////////////////////////////////////////////////////////////////
		if (columnSpan != 9) { /* i.e. columnSpan == 2 or 1 */
			createToggleCell(newRow, 'TD', 'LH', 'h1', 'ec1', 0, excluded,
					lastRowOdd, dataArr[r]);
			createToggleCell(newRow, 'TD', 'HL', 'h2', 'ec2', 0, excluded,
					lastRowOdd, dataArr[r]);
			createToggleCell(newRow, 'TD', 'LZ', 'h3', 'ec3', dataArr[r].s1, excluded, lastRowOdd, dataArr[r]);
			createToggleCell(newRow, 'TD', 'ZH', 'h4', 'ec4', dataArr[r].s2, excluded, lastRowOdd, dataArr[r]);
			createToggleCell(newRow, 'TD', 'HZ', 'h5', 'ec5', dataArr[r].s3, excluded, lastRowOdd, dataArr[r]);
			createToggleCell(newRow, 'TD', 'ZL', 'h6', 'ec6', dataArr[r].s4, excluded, lastRowOdd, dataArr[r]);

			tmp = dataArr[r].em; // External Mode
			if (tmp) {
				celltxt = tmp;
			} else {
				celltxt = '--';
			}
			if (!dataArr[r].st) {
				classtype = g_cellClassRight[lastRowOdd];
			} else {
				classtype = g_cellClass[lastRowOdd];
			}
			t_createCell(newRow, 'TD', classtype, 0, 0, celltxt, 0, 0, 0,
					excluded ? "dimGrey" : 0, 0, 0, 0);
		}

		if (excluded == 0) {
			tmp = dataArr[r].c;
			switch (tmp) {
			case 'R':
				classtype = 'bgRed';
				celltxt = dataArr[r].p+ "%";
				break;
			case 'Y':
				classtype = 'bgYellow';
				celltxt = dataArr[r].p + "%";
				break;
			case 'G':
				classtype = 'bgGreen';
				celltxt = dataArr[r].p + "%";
				break;
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
		t_createCell(newRow, 'TD', classtype, 0, 0, celltxt, 0, 0, 0, 0, 0, 0,
				0);
		/* end of Row */
		tbody.appendChild(newRow);
		lastRowOdd = lastRowOdd ? 0 : 1;
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
	table.appendChild(tbody);
	divObj.appendChild(document.createElement('hr'));
	divObj.appendChild(table);
	var date = new Date();
    var diff = date - g_t_start_date;
    if (urlArgsObj.getPerf()) {
    console.save(g_t_divId +", " + (diff/1000), "t_console.txt");
    }
}
