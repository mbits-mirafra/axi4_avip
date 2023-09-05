var g_cellClass = [ "odd", "even" ];
var g_cellClassRight = [ "odd_r", "even_r" ];
var g_cellClassRGrey = [ "odd_rGrey", "even_rGrey" ];
var g_a_divId;
var testHitDataScopeId;
var processAssertionsData;
var processConsData;
var hdlPaths = {};
var assertViewData = [];
var assertViewFileToRead = 0;
var MAX_NAME_LENGTH_HALF = 30;
var MAX_NAME_LENGTH = 80;
var TABLE_REASONABLE_LENGTH = 100;
var TABLE_LENGTH_MENUE = [[25, 50, 100, -1], [25, 50, 100, "All"]];
var g_a_start_date;
/////////////////////////////////////////////////////////////////////////////////////
jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    'debug_assert_col-asc': function ( a, b ) {
		if (isNaN(a)) {
			return 1;
		} else if (isNaN(b)) {
			return -1;
		} else {
			var x, y;
			x = parseInt(a);
			y = parseInt(b);
			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		}
    },
    'debug_assert_col-des': function ( a, b ) {
		if (isNaN(a)) {
			return -1;
		} else if (isNaN(b)) {
			return 1;
		} else {
			var x, y;
			x = parseInt(a);
			y = parseInt(b);
			return ((x < y) ? 1 : ((x > y) ? -1 : 0));
		}
    }
} );
/////////////////////////////////////////////////////////////////////////////////////
/* creats cell and add it to row. */
function a_createCell(row, type, classt, span, txt, lnk, relAttribute,
		filterLabel, c_align, tooltip) {
	var newCell = document.createElement(type);
	newCell.className = classt;
	if (span > 1) {
		newCell.colSpan = span;
	}
	if (c_align) {
		newCell.align = c_align;
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
	if (filterLabel) {
		newCell.innerHTML = newCell.innerHTML + '&nbsp;';
		var newElement = document.createElement('font');
		newElement.color = "#006699";
		newElement.innerHTML = "(Filtering Active)";
		newCell.appendChild(newElement);
	}
	if (tooltip) {
		newCell.setAttribute("title", tooltip);
	}
	row.appendChild(newCell);
	return;
};

function createAssertCell(row, tableCellType, countType, bin_num, isexcluded,
		lastRowIsOdd, data) {
	var exComment = lnktxt = celltxt = relAtt = tmp = celltxt = classtype = 0;
	if (countType) {
		tmp = data.countType;
	}
	if (tmp) {
		switch (tmp) {
		case 'Gr':
			classtype = 'bgGreen_r';
			break;
		case 'Rr':
			classtype = 'bgRed_r';
			break;
		case 'er':
			classtype = g_cellClassRight[lastRowIsOdd];
			break;
		case 'or':
			classtype = g_cellClassRight[lastRowIsOdd];
			break;
		default:
			classtype = '';
		break;
		}
	} else {
		classtype = g_cellClassRight[lastRowIsOdd];
	}
	celltxt = data['h' + bin_num];
	if (celltxt) {
		var hrefLnk = data['t' + bin_num];
		if (hrefLnk) {
			lnktxt = "pertest.htm?bin=a" + hrefLnk + "&scope="
			+ testHitDataScopeId;
			relAtt = 'popup 200 200';
		} else {
			lnktxt = 0;
			relAtt = 0;
		}
	} else {
		celltxt = '-';
	}
	if (isexcluded) {
		// if excluded override the class name
		classtype = g_cellClassRGrey[lastRowIsOdd];
		exComment = data['ec' + bin_num];
		if (exComment) {
			celltxt = celltxt + ' +';
		}
	}
	a_createCell(row, tableCellType, classtype, 0, celltxt, lnktxt, relAtt, 0,
			0, exComment);
};
/////////////////////////////////////////////////////////////////////////////////////
function loadJsonFile(jsonFileName) {
	var headID = document.getElementsByTagName('head')[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = 'text/javascript';
	jsonScript.src = jsonFileName;
	headID.appendChild(jsonScript);
}
function buildAssertionsTables(divId, filenum) {
	g_a_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();
	processAssertionsData = function (data) {
		drawAssertTable(data);
	};
	g_a_divId = 'a' + divId;
	testHitDataScopeId = divId;
	loadJsonFile('a' + filenum + '.json');
}

function drawAssertTable(g_data) {
	var divObj = document.getElementById("content");
	var show_excl_button = 0;

	var table = 0;
	var buttonsTable = 0;
	var t = 0;

	if (g_data[g_a_divId].isPa) {
		document.body.insertBefore(
				utils_getPageHeaderH1(g_data[g_fsm_divId].isPa.title),
				divObj);
		var h4;
		h4 = document.createElement('h4');
		h4.innerHTML = 'UPF Object: ' + g_data[g_fsm_divId].isPa.objType;
		document.body.insertBefore(h4, divObj);
	} else {
		document.body.insertBefore(
				utils_getPageHeaderH1("Assertion"),
				divObj);
	}

	buttonsTable = utils_getButtonsTable();
	divObj.appendChild(buttonsTable);

	table = document.createElement('table');
	table.cellSpacing = "2";
	table.cellPadding = "2";

	var newRow = document.createElement('tr');

	a_createCell(newRow, "TH", 'even', 0, 'Assertions', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Failure Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Pass Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Attempt Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Vacuous Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Disable Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Active Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Peak Active Count', 0, 0, 0, 0, 0);
	a_createCell(newRow, "TH", 'even', 0, 'Status', 0, 0, 0, 0, 0);

	table.appendChild(newRow);
	var lastRowOdd = 0;
	var dataArr = g_data[g_a_divId].assertions;
	for (var r = 1; r < dataArr.length; r++) {
		newRow = document.createElement('tr');
		var tmp = 0;
		var excluded = 0;
		var lnktxt = 0;
		var celltxt = 0;
		var relAtt = 0;

		// row class if existing
		tmp = dataArr[r].cr;
		switch (tmp) {
		case 'c':
			newRow.className = 'covered';
			break;
		case 'm':
			newRow.className = 'missing';
			break;
		case 'e':
			newRow.className = 'excluded';
			excluded = 1;
			show_excl_button = 1;
			break;
		default:
			newRow.className = '';
		break;
		}

		classtype = g_cellClass[lastRowOdd];
		lnktxt = dataArr[r].lnk;

		tmp = dataArr[r].z;
		if (tmp) {
			celltxt = tmp.replace(">", "&gt;").replace("<", "&lt;");
		}
		a_createCell(newRow, "TD", classtype, 0, celltxt, lnktxt, 0, 0, 0, 0);

		createAssertCell(newRow, "TD", 'fc', 0, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 'pc', 1, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 0, 2, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 0, 3, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 0, 4, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 0, 5, excluded, lastRowOdd, dataArr[r]);
		createAssertCell(newRow, "TD", 0, 6, excluded, lastRowOdd, dataArr[r]);

		if (excluded == 0) {
			tmp = dataArr[r].c;
			switch (tmp) {
			case 'F':
				classtype = 'red';
				celltxt = "Failed";
				break;
			case 'Z':
				classtype = 'red';
				celltxt = "ZERO";
				break;
			case 'g':
				classtype = 'green';
				celltxt = "Covered";
				break;
			default:
				classtype = '';
			celltxt = 0;
			break;
			}
		} else {
			classtype = 'grey';
			celltxt = "Excluded";
		}
		a_createCell(newRow, "TD", classtype, 0, celltxt, 0, 0, 0, 0, 0);

		lastRowOdd = lastRowOdd ? 0 : 1;
		table.appendChild(newRow);
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
	divObj.appendChild(document.createElement("hr"));
	divObj.appendChild(table);
	var date = new Date();
	var diff = date - g_a_start_date;
	if (urlArgsObj.getPerf()) {
		console.save(g_a_divId +", " + (diff/1000), "a_console.txt");
	}

}

function getAssertViewTableConfigObj(assertData) {
	var hitCols = [
	               'Attempt Count',
	               'Vacuous Count',
	               'Disable Count',
	               'Active Count',
	               'Peak Active Count'
	               ];
	var configObj = {
			paging : false,
			info   : false,
			data   : assertData,
			order  : [[0, 'asc' ]], // initially order the table according to 1st column (name)
			createdRow: function (rowDomObj, rowData, rowDataIdx) {
				if (rowData.cr == 'e') {
					$(rowDomObj).addClass('grayFont');
				}
			},
			columns:
				[
				 {
					 type     : 'string',
					 title    : 'Assertions',
					 className: 'dt-left nowrap',
					 data     : null,
					 render   : {
						 filter : function (cellData, type, fullRowJsonObj, meta) {
							 var content = hdlPaths[cellData.parent] + '/' + cellData.z;
							 switch (cellData.c) {
							 case 'F':
								 content +=  '#status:Failed';
								 break;
							 case 'Z':
								 content += '#status:ZERO';
								 break;
							 case 'g':
								 content += '#status:Covered';
								 break;
							 default:
								 break;
							 }
							 return content;
						 },
						 display: function (cellData, type, fullRowJsonObj, meta) {
							 var parent = hdlPaths[cellData.parent].path;
							 var fileNum = hdlPaths[cellData.parent].fileNum;
							 var content = '<a href="a.htm?f=' + fileNum + '&s=' + cellData.parent + '">';
							 if (parent.length > MAX_NAME_LENGTH) {
								 content += parent.slice(0, MAX_NAME_LENGTH_HALF)
								 + '....'
								 + parent.slice((parent.length - MAX_NAME_LENGTH_HALF),(parent.length - 1));
							 } else {
								 content += parent;
							 }
							 content += '/' + cellData.z;
							 return content;
						 },
						 sort: function (cellData, type, fullRowJsonObj, meta) {
							 return hdlPaths[cellData.parent].path + '/' + cellData.z;
						 }
					 }
				 },
				 {
					 title     : 'Failure Count',
					 searchable: false,
					 className : 'dt-right',
					 data      : 'h0',
					 defaultContent: '-',
					 createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {
						 $(cellDomObj).addClass(rowData.fc);
					 }
				 },
				 {
					 title     : 'Pass Count',
					 searchable: false,
					 className : 'dt-right',
					 data      : 'h1',
					 defaultContent: '-',
					 createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {
						 $(cellDomObj).addClass(rowData.pc);
					 }
				 }
				 ]
	};
	if (g_assertDebug) {
		for (indx = 0; indx < hitCols.length; ++indx) {
			var dataIndx = 'h' + (indx + 2);
			configObj.columns.push(
					{
						type      : 'debug_assert_col',
						title     : hitCols[indx],
						searchable: false,
						className : 'dt-right',
						data      : dataIndx,
						defaultContent: '-'
					}
			)
		}
	}

	configObj.columns.push(
			{
                type      : 'num',
				title     : 'Status',
				searchable: false,
				className : 'dt-right',
				data      : null,
				render: {
					display: function (cellData, type, fullRowJsonObj, meta) {
						switch (cellData.c) {
						case 'F':
							return 'Failed';
							break;
						case 'Z':
							return 'ZERO';
							break;
						case 'g':
							return 'Covered';
							break;
						default:
							return '';
						break;
						}
					},
					sort: function (cellData, type, fullRowJsonObj, meta) {
						switch (cellData.c) {
						case 'F':
							return 0;
							break;
						case 'Z':
							return 1;
							break;
						case 'g':
							return 2;
							break;
						default:
							return 3;
						break;
						}
					}

				},
				createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {
					switch (cellData.c) {
					case 'F':
						$(cellDomObj).addClass('red');
						break;
					case 'Z':
						$(cellDomObj).addClass('red');
						break;
					case 'g':
						$(cellDomObj).addClass('green');
						break;
					default:
						break;
					}
				}
			}
	);

	if (assertData.length > TABLE_REASONABLE_LENGTH) {
		configObj.paging = true;
		configObj.info   = true;
		configObj.deferRender = true;
		configObj.lengthMenu = TABLE_LENGTH_MENUE;
	}

	return configObj;
}

function drawAssertViewTable() {
	var body = document.getElementsByTagName('body')[0];
	var assertTable = document.createElement('table');
	var config = getAssertViewTableConfigObj(assertViewData);
	assertTable.className = 'tableTheme stripe';
	body.appendChild(assertTable);
	$(assertTable).DataTable(config);
}

function genDataAssertView(data, file_num) {
	for (var scope in data) {
		if(data.hasOwnProperty(scope)) {
			var scopeHash = scope.substr(1);
			var scopeName = "";
			for (var i =0; i < data[scope].scopes.length; i++) {
				scopeName += "/";
				scopeName += data[scope].scopes[i].val;
			}
		}
		var newAsserts = data["a"+scopeHash]['assertions'];
		hdlPaths[scopeHash] = {
				path: scopeName,
				fileNum: file_num
		};
		for(cvgIdx=1;cvgIdx < newAsserts.length; ++cvgIdx) {
			newAsserts[cvgIdx].parent = scopeHash;
			assertViewData.push(newAsserts[cvgIdx]);
		}
	}
	assertViewFileToRead--;
	if (assertViewFileToRead == 0) {
		drawAssertViewTable();
	}
}

function processAssertConsData() {
	assertViewFileToRead = g_assertViews;
	processAssertionsData = function(data, file_num) {
		delete data['dummyEnd'];
		genDataAssertView(data, file_num);
	};
	for (i=1; i <= g_assertViews; ++i) {
		loadJsonFile('a' + i + '.json');
	}
}

function buildAssertViewTable() {
	processAssertConsData();
}
