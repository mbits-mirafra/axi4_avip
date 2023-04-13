var g_stmtDetailsTable; // This holds the object of the table where we will put
//our annotated source
var g_s_id;
var g_cellClassRight = [ "odd_r", "even_r" ];
var g_cellClass = [ "odd", "even" ];
var g_cellClassGrey = [ "oddGrey", "evenGrey" ];
var g_cellClassRGrey = [ "odd_rGrey", "even_rGrey" ];
var g_linesArr;
var g_filesCount;
var testHitDataScopeId;
var G_ROW_HAS_MISSED_ITEM = 1; // 0x01
var G_ROW_HAS_HIT_ITEM    = 2; //0x10
var G_ROW_HAS_HIT_AND_MISS_ITEMS = 3; // 0x11
var g_s_start_date;


/**
function ReadFilesInArr(g_data) {
     g_linesArr[g_filesCount] = g_data;
}
 **/

//This function is invoked from the json file of the source file.
function countinueBuildStmtTable(g_linesArr) {
	var divObj = document.getElementById("content");
	document.body.insertBefore(
			utils_getPageHeaderH1("Statement"),
			divObj);

	var buttonsTable = utils_getButtonsTable();
	document.body.insertBefore(
			buttonsTable,
			divObj);

	var show_excl_button = 0;
	var linesArr;   
	var t = 0;

	for (var int = 1; int < g_stmtDetailsArray[g_s_id].length; int++) {
		linesArr = g_linesArr;
		var table = document.createElement('table');
		table.cellSpacing = "0";
		table.cellPadding = "0";
		table.id = g_stmtDetailsArray[g_s_id][int]['jsonsrcf'];
		table.width = "93%";
		table.className = "src";
		var detArray = g_stmtDetailsArray[g_s_id][int].items;
		var tbodyElement = document.createElement('tbody');
		var newRow = document.createElement('tr');
		newRow.setAttribute("style", "background-color:black; color:white");
		var newC = stmtHeaderCell(newRow, "srcL sharpEdge", "&nbsp");
		newRow.appendChild(newC);
		newC = stmtHeaderCell(newRow, "srcS sharpEdge", "&nbsp");
		newRow.appendChild(newC);
		newC = stmtHeaderCell(newRow, "sN sharpEdge", "&nbsp");
		newRow.appendChild(newC);
		newC = stmtHeaderCell(newRow, "srcN sharpEdge", "File: " + g_stmtDetailsArray[g_s_id][int]['fname']);
		newC.setAttribute("style", "font-size:110%;")
		newRow.appendChild(newC);
		tbodyElement.appendChild(newRow);
		table.appendChild(tbodyElement);


		tbodyElement = document.createElement('tbody');
		var size = detArray.length;
		var previousRowHasItem = 0;
		for (var i = 1; i < size; i++) {
			newRow = document.createElement('TR');
			var newCells = [];
			var binId = detArray[i]['t'];
			var exComment = detArray[i]['e'];
			var item = detArray[i]['s'];
			var color = detArray[i]['c'];
			var line = detArray[i]['l'];
			var hits = detArray[i]['h'];
			var start = detArray[i]['bs'];
			var end = detArray[i]['be'];
			for (var n = 0; n <= 3; n++) {
				newCells[n] = document.createElement('TD');
				newRow.appendChild(newCells[n]);
			}
			if (start) {
				// a block of statements that has no coverage
				if (end) {
					newCells[0].className = 'srcL sharpEdge';
					newCells[1].className = 'srcS sharpEdge';
					newCells[2].className = 'covN sharpEdge';
					newCells[3].className = 'srcN sharpEdge stmtNoCvgBlock';
					newCells[3].innerHTML = 'Lines from ' + start + ' to ' + end
					+ ' were skipped as they have no coverage.';
					newRow.className = 'lightBlue';
				} else {
					// should never happen
					continue;
				}
			} else {
				newCells[0].innerHTML = line;
				newCells[0].className = 'srcL';
				newCells[1].className = 'srcS';
				if (item) {
					newCells[2].className = 's' + color;
					newCells[3].className = 'srcN';
					newCells[1].innerHTML = '.' + item;
					newCells[3].innerHTML = '&nbsp;';
				} else {
					if (typeof hits === 'undefined') {
						newCells[2].className = 'sN';
					} else {
						newCells[2].className = 's' + color;
					}

					newCells[3].className = 'src' + color;
					newCells[1].innerHTML = '&nbsp;';
					newCells[3].innerHTML = linesArr[line - 1];
				}
				if (hits) {
					if (hits.charAt(0) == 'E') {
						show_excl_button = 1;
						newRow.className = 'excluded';
						if (exComment) {
							newCells[2].innerHTML = hits + '+';
							newCells[2].setAttribute('title', exComment);
						} else {
							newCells[2].innerHTML = hits;
						}
					} else {
						if (binId) {
							var popupWidth = 200;
							var popupHight = 200;
							newRow.cells[2].innerHTML = '<a class=\"stmt_testdata\" href = \"pertest.htm?bin='
									+ binId
									+ '&scope='
									+ testHitDataScopeId
									+ '\" rel=\"popup '
									+ popupWidth
									+ ' '
									+ popupHight + '\">' + hits + '</a>';
						} else {
							newCells[2].innerHTML = hits;
						}                          
						if (hits > 0) {
							newRow.className = 'covered';
						} else {
							newRow.className = 'missing';
						}

						if (item) {
							if (hits > 0) {
								previousRowHasItem |= G_ROW_HAS_HIT_ITEM;
							} else {
								previousRowHasItem |= G_ROW_HAS_MISSED_ITEM;
							}
						}
					}
				} else {
					newCells[1].innerHTML = '&nbsp;';
					newCells[2].innerHTML = '&nbsp;';
					if (previousRowHasItem) {
						// This is a row that has more than one item, which
						// are created in previous iterations
						if (previousRowHasItem == G_ROW_HAS_MISSED_ITEM) {
							newRow.className = 'missing';
						} else if (previousRowHasItem == G_ROW_HAS_HIT_ITEM) {
							newRow.className = 'covered';
						} else {
							newRow.className = 'neutral';
						}
						previousRowHasItem = 0;
					}
				}
			}
			tbodyElement.appendChild(newRow);
		}

		table.appendChild(tbodyElement);           

		if (show_excl_button == 1) {
			if (buttonsTable) {
				newCell = document.createElement('TD');
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
	}
	var date = new Date();
	var diff = date - g_s_start_date;
	if (urlArgsObj.getPerf()) {
		console.save(g_s_id +", " + (diff/1000), "s_console.txt");
	}
}

function stmtHeaderCell(row, classname, inner) {
	var cell = document.createElement('td');
	cell.className = classname;
	cell.innerHTML = inner;
	return cell;
}

function processStatementsData(g_data) {
	g_stmtDetailsArray = g_data;
	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";

	// Should go to the first and then count files
	if (g_data[g_s_id][1]["jsonsrcf"]) { /* note: g_data[g_s_id][0] is a dummy node */
		var srccode = g_data[g_s_id][1]["jsonsrcf"];
		jsonScript.src = srccode;
		headID.appendChild(jsonScript);
	} else {
		continueStmtTableNoSrc();
	}
}

function continueStmtTableNoSrc() {
	var divObj = document.getElementById("content");
	document.body.insertBefore(
			utils_getPageHeaderH1("Statement"),
			divObj);

	var buttonsTable = utils_getButtonsTable();
	document.body.insertBefore(
			buttonsTable,
			divObj);

	var show_excl_button = 0;

	table = document.createElement('table');

	table.cellSpacing = "2";
	table.cellPadding = "2";

	var tbodyElement = document.createElement('tbody');
	var newRow = document.createElement('tr');
	newCell = document.createElement('TH');
	newCell.innerHTML = 'Statement';
	newRow.appendChild(newCell);

	newCell = document.createElement('TH');
	newCell.className = 'even';
	newCell.innerHTML = 'Hits';
	newRow.appendChild(newCell);

	newCell = document.createElement('TH');
	newCell.innerHTML = 'Coverage';
	newRow.appendChild(newCell);
	table.appendChild(newRow);
	var lastRowOdd = 0;
	var detArray = g_stmtDetailsArray[g_s_id][1].items;
	for (var i = 1; i < detArray.length; i++) {
		var tmp;
		var excluded = 0;
		newRow = document.createElement('TR');
		newCell = document.createElement('TD');
		tmp = detArray[i].cr;
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

		if (!excluded) {
			newCell.className = g_cellClass[lastRowOdd];
		} else {
			newCell.className = g_cellClassGrey[lastRowOdd];
		}

		newCell.innerHTML = detArray[i].z;

		newRow.appendChild(newCell);

		newCell = document.createElement('TD');
		tmp = detArray[i].h;
		if (tmp) {
			if (!excluded) {
				newCell.className = g_cellClassRight[lastRowOdd];
			} else {
				newCell.className = g_cellClassRGrey[lastRowOdd];
			}

			var hrefLnk = detArray[i].k;
			if (hrefLnk) {
				var lnktxt = "pertest.htm?bin=s" + hrefLnk + "&scope="
						+ testHitDataScopeId;
				var newElement = document.createElement('a');
				newElement.setAttribute('href', lnktxt);
				newElement.setAttribute('rel', 'popup 200 200');
				newCell.appendChild(newElement);
			}
			var exComment = detArray[i].ec;
			if (exComment) {
				newCell.innerHTML = tmp + ' +';
				newCell.setAttribute('title', exComment);
			} else {
				newCell.innerHTML = tmp;
			}
		} else {
			if (!excluded) {
				newCell.className = g_cellClass[lastRowOdd];
			} else {
				newCell.className = g_cellClassGrey[lastRowOdd];
			}

			newCell.align = "center";
			newCell.innerHTML = "--";
		}
		newRow.appendChild(newCell);

		newCell = document.createElement('TD');
		if (!excluded) {
			tmp = detArray[i].c;
			switch (tmp) {
			case 'g':
				newCell.className = 'green';
				newCell.innerHTML = 'Covered';
				break;
			case 'r':
				newCell.className = 'red';
				newCell.innerHTML = 'ZERO';
				break;
			default:
				newCell.className = '';
			break;
			}
		} else {
			newCell.className = "grey";
			newCell.innerHTML = 'Excluded';
		}
		newRow.appendChild(newCell);
		lastRowOdd = lastRowOdd ? 0 : 1;
		table.appendChild(newRow);

	}

	if (show_excl_button == 1) {
		if (buttonsTable) {
			newCell = document.createElement('TD');
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
	var diff = date - g_s_start_date;
	if (urlArgsObj.getPerf()) {
		console.save(g_s_id +", " + (diff/1000), "s_console.txt");
	}
}

function buildStmtTable() {
	g_s_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();

	g_s_id = "s" + divId;
	testHitDataScopeId = divId;

	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";
	jsonScript.src = "s" + filenum + ".json";
	headID.appendChild(jsonScript);
}
