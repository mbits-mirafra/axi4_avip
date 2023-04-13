var g_dynamic_z_lastClassOdd;
var g_dynamic_z_lastRowOdd = 0;
var g_dynamic_z_cellClasses      = ["odd",   "even"];
var g_dynamic_z_cellClassesRight = ["odd_r", "even_r"];

/////////////////////////////   Functions  //////////////////////////////////
/* sets "cell class" value */
function coverageToStyle(val) {
	var classOfCell = 0;
	if (val == "undefined") {
		if (g_dynamic_z_lastClassOdd)
			classOfCell = g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd];
		else
			classOfCell = g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd];

	} else {
		if (val < threshL) classOfCell = "bgRed";
		else if (val < threshH) classOfCell = "bgYellow";
    	else classOfCell = "bgGreen";
	}
	g_dynamic_z_lastClassOdd = !g_dynamic_z_lastClassOdd;
	return classOfCell;
};

/* sets "cell class" value, when the coverage type is Assertion Failure */
function coverageToStyleAssertionFailure(val) {
	var assertionCellClass = 0;
	if (val == "undefined") {
		if (g_dynamic_z_lastClassOdd)
			assertionCellClass = g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd];
		else
			assertionCellClass = g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd];

	} else {
		if (val == 0.0) assertionCellClass = "bgGreen";
		else assertionCellClass = "bgRed";
	}
	g_dynamic_z_lastClassOdd = !g_dynamic_z_lastClassOdd;
	return assertionCellClass;
};

/* creats cell and add it to row.*/
function createCell(row, type, classt, span, txt, lnk, filterLabel, c_align) {
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
		newElement.innerHTML = txt;
		newCell.appendChild(newElement);
	} else {
		newCell.innerHTML = txt;
	}
	if (filterLabel) {
		newCell.innerHTML = newCell.innerHTML + '&nbsp;';
		newElement = document.createElement('font');
		newElement.color = "#006699";
		newElement.innerHTML = "(Filtering Active)";
		newCell.appendChild(newElement);
	}
	
	row.appendChild(newCell);
	return;
};

function createCell_2txt(row, type, classt, span, txt1, txt2) {
	var newCell = 0;
	if (type.match("TH")) {
		newCell = document.createElement('TH');
	} else {
		newCell = document.createElement('TD');
	}
	newCell.className = classt;
	if (span > 1) {
		newCell.colSpan = span;
	}
	newCell.innerHTML = txt1;
	var newElement = document.createElement('BR');
	newCell.appendChild(newElement);
	newCell.innerHTML = newCell.innerHTML + txt2;
	row.appendChild(newCell);
	return;
};

/* creats cell and add it to row. and adjusts its backgrnd colod based on coverage value */
function addCoverageTypeCell(theRow, val, notAssertionFailure) {
	var value = 0;
	var cvgCellClass = 0;
	if (val != "undefined") {
		value = val[1] * 100 / val[0] ;
	} else {
		value = val; // which equals "undefined"
	}
	if (notAssertionFailure)
		cvgCellClass = coverageToStyle(value);
	else
		cvgCellClass = coverageToStyleAssertionFailure(value);

	if (val != "undefined") {
		createCell(theRow, "TD", cvgCellClass, 0, value.toFixed(2)+"%", 0, 0, 0);
	} else {
		createCell(theRow, "TD", cvgCellClass, 0, "--", 0, 0, "center");
	}
};

/* creats row and add it to the coverage_summary_by_instance table */
function createRow(table, rowName, link, firstCellSpan, listColsArr, filtering_flag) {
	var aNewRow = document.createElement('tr');
	var classOfCell = 0;

	if (firstCellSpan == 2) {
		createCell(aNewRow, "TD", g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd], firstCellSpan, rowName, 0, filtering_flag, 0);
	} else {
		createCell(aNewRow, "TD", 'invisible', 0, '&nbsp;', 0, 0, 0);
		createCell(aNewRow, "TD", g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd], 0, rowName, link, 0, 0);
	}
	g_dynamic_z_lastClassOdd = true;
	classOfCell = coverageToStyle(w);
	createCell(aNewRow, "TD", classOfCell, 0, w+"%", 0, 0, 0);

	if(listColsArr[0] == 0) {
		try {
			if (typeof g != "undefined") {
				addCoverageTypeCell(aNewRow, g, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[1] == 0) {
		try {
			if (typeof d != "undefined") {
				addCoverageTypeCell(aNewRow, d, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[2] == 0) {
		try {
			if (typeof s != "undefined") {
				addCoverageTypeCell(aNewRow, s, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[3] == 0) {
		try {
			if (typeof b != "undefined") {
				addCoverageTypeCell(aNewRow, b, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[4] == 0) {
		try {
			if (typeof ue != "undefined") {
				addCoverageTypeCell(aNewRow, ue, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[5] == 0) {
		try {
			if (typeof uc != "undefined") {
				addCoverageTypeCell(aNewRow, uc, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[6] == 0) {
		try {
			if (typeof fe != "undefined") {
				addCoverageTypeCell(aNewRow, fe, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[7] == 0) {
		try {
			if (typeof fc != "undefined") {
				addCoverageTypeCell(aNewRow, fc, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[8] == 0) {
		try {
			if (typeof t != "undefined") {
				addCoverageTypeCell(aNewRow, t, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[9] == 0) {
		try {
			if (typeof fs != "undefined") {
				addCoverageTypeCell(aNewRow, fs, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[10] == 0) {
		try {
			if (typeof ft != "undefined") {
				addCoverageTypeCell(aNewRow, ft, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[11] == 0) {
		try {
			if (typeof aa != "undefined") {
				addCoverageTypeCell(aNewRow, aa, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[12] == 0) {
		try {
			if (typeof ap != "undefined") {
				addCoverageTypeCell(aNewRow, ap, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[13] == 0) {
		try {
			if (typeof af != "undefined") {
				addCoverageTypeCell(aNewRow, af, 0);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 0);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}
	if(listColsArr[14] == 0) {
		try {
			if (typeof as != "undefined") {
				addCoverageTypeCell(aNewRow, as, 1);
			} else {
				addCoverageTypeCell(aNewRow, "undefined", 1);
			}
		} catch (err) {
			addCoverageTypeCell(aNewRow, "undefined", 1);
		}
	}

	table.appendChild(aNewRow);
	g_dynamic_z_lastRowOdd = g_dynamic_z_lastRowOdd ? 0 : 1;
};

/* undefine global vars holding coverage values inorder to use them for other scopes */
function removeAllDataVariables() {
	try {
		if (typeof children != "undefined") {
			children = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof w != "undefined") {
			w = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof g != "undefined") {
			g = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof d != "undefined") {
			d = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof s != "undefined") {
			s = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof b != "undefined") {
			b = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof e != "undefined") {
			e = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof c != "undefined") {
			c = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof f != "undefined") {
			f = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof ue != "undefined") {
			ue = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof uc != "undefined") {
			uc = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof fe != "undefined") {
			fe = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof fc != "undefined") {
			fc = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof t != "undefined") {
			t = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof fs != "undefined") {
			fs = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof ft != "undefined") {
			ft = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof as != "undefined") {
			as = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof ap != "undefined") {
			ap = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof af != "undefined") {
			af = undefined;
		}
	} catch (err) {
		;
	}
	try {
		if (typeof aa != "undefined") {
			aa = undefined;
		}
	} catch (err) {
		;
	}
};

/* coverage type names used in the recursive_hier_coverage_details table */


/* creates row and add it to the recursive_hier_coverage_details table */
function createCoverageTypeRow(table, cov, covTypeIndex) {
	var covTypesNames = ["Covergroup", "Directive", "Statement", "Branch",
	                  	"Expressions", "UDP Expressions", "FEC Expressions",
	                  	"Conditions", "UDP Conditions", "FEC Conditions",
	                  	"Toggle", "FSM", "State", "Transition", "Assertion"];
	var MakeThreeRowsExp = 0;
	var MakeThreeRowsCond = 0;
	var thereIsFSM = 0;
	var ColName = "";
	var colspan = 2;

	var classOfTableCell = 0;
	
	var newCvgRow = document.createElement('tr');
	ColName = covTypesNames[covTypeIndex];
	colspan = 2;
	
	if (thereIsFSM > 0) {
		thereIsFSM--;
		colspan = 1;
		createCell(newCvgRow, "TD", 'invisible', 0, '&nbsp;', 0, 0, 0);
	} else if (MakeThreeRowsCond > 0) {
		MakeThreeRowsCond--;
		colspan = 1;
		createCell(newCvgRow, "TD", 'invisible', 0, '&nbsp;', 0, 0, 0);
		if (covTypesNames[covTypeIndex].match ("FEC Conditions") ) {
			ColName = "FEC";		    
		} else { /* covTypesNames[covTypeIndex].match ("FEC Conditions") */
			ColName = "UDP";
		}
	} else if (MakeThreeRowsExp > 0) {
		MakeThreeRowsExp--;
		colspan = 1;
		createCell(newCvgRow, "TD", 'invisible', 0, '&nbsp;', 0, 0, 0);
		if (covTypesNames[covTypeIndex].match ("FEC Expressions") ) {
			ColName = "FEC";		    
		} else { /* covTypesNames[covTypeIndex].match ("FEC Expressions") */
			ColName = "UDP";
		}
	}

	
	if (covTypesNames[covTypeIndex] == "Conditions" ) {
		MakeThreeRowsCond = 2;
	}
	else if (covTypesNames[covTypeIndex] == "Expressions" ) {
		MakeThreeRowsExp = 2;
	}	
	else if (covTypesNames[covTypeIndex] == "FSM" ) {
		thereIsFSM = 2;
	}
	
	createCell(newCvgRow, "TD", g_dynamic_z_cellClasses[g_dynamic_z_lastRowOdd],  colspan, ColName, 0, 0, 0);
	createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd], 0, cov[0], 0, 0, 0);
	createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd],  0, cov[1], 0, 0, 0);

	if (covTypesNames[covTypeIndex] != "Assertion Failures") {
		createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd], 0, cov[0]-cov[1], 0, 0, 0);
		classOfTableCell = coverageToStyle(cov[3]);
	} else {
		createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd], 0, '-', 0, 0, 0);
		classOfTableCell = coverageToStyleAssertionFailure(cov[3]);
	}
	createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd], 0, cov[2], 0, 0, 0);
	createCell(newCvgRow, "TD", g_dynamic_z_cellClassesRight[g_dynamic_z_lastRowOdd], 0, cov[4]+"%", 0, 0, 0);
	createCell(newCvgRow, "TD", classOfTableCell, 0, cov[3]+"%", 0, 0, 0);
		
	table.appendChild(newCvgRow);
	g_dynamic_z_lastRowOdd = g_dynamic_z_lastRowOdd ? 0 : 1;
};
function FillColsList(table, rowName, link, firstCellSpan, listColsArr) {
	try {
		if (typeof g == "undefined")
			listColsArr[0] = 1;		
	} catch (err) {
		listColsArr[0] = 1;
	}
	try {
		if (typeof d == "undefined") 
			listColsArr[1] = 1;		
	} catch (err) {
		listColsArr[1] = 1;
	}
	try {
		if (typeof s == "undefined")
			listColsArr[2] = 1;		
	} catch (err) {
		listColsArr[2] = 1;
	}
	try {
		if (typeof b == "undefined")
			listColsArr[3] = 1;		
	} catch (err) {
		listColsArr[3] = 1;
	}
	try {
		if (typeof ue == "undefined")
			listColsArr[4] = 1;		
	} catch (err) {
		listColsArr[4] = 1;
	}
	try {
		if (typeof uc == "undefined")
			listColsArr[5] = 1;	
	} catch (err) {
		listColsArr[5] = 1;
	}
	try {
		if (typeof fe == "undefined")
			listColsArr[6] = 1;		
	} catch (err) {
		listColsArr[6] = 1;
	}
	try {
		if (typeof fc == "undefined")
			listColsArr[7] = 1;		
	} catch (err) {
		listColsArr[7] = 1;
	}
	try {
		if (typeof t == "undefined")
			listColsArr[8] = 1;		
	} catch (err) {
		listColsArr[8] = 1;
	}
	try {
		if (typeof fs == "undefined")
			listColsArr[9] = 1;		
	} catch (err) {
		listColsArr[9] = 1;
	}
	try {
		if (typeof ft == "undefined")
			listColsArr[10] = 1;		
	} catch (err) {
		listColsArr[10] = 1;
	}
	try {
		if (typeof aa == "undefined")
			listColsArr[11] = 1;	
	} catch (err) {
		listColsArr[11] = 1;
	}
	try {
		if (typeof ap == "undefined")
			listColsArr[12] = 1;		
	} catch (err) {
		listColsArr[12] = 1;
	}
	try {
		if (typeof af == "undefined")
			listColsArr[13] = 1;
	} catch (err) {
		listColsArr[13] = 1;
	}
	try {
		if (typeof as == "undefined")
			listColsArr[14] = 1;	
	} catch (err) {
		listColsArr[14] = 1;
	}	
};
//////////////////////////  End Functions  //////////////////////////////////
/* read the json file for this scope and process its data */

function dynamichtmlBuildSummaryTable() {
	var newTable;
	var newElement;
	var newlook = 1;
	var ListCols = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	
	$.ajax({
		type: "GET",
		url: "h" + id +".json",
		async: false,
		processData: true,
		data: {},
		dataType: "json",
		success: function(data,y,z) {
	
		$.each(data, function(key, val) {
			if (key == "children")
				eval(key+"=\""+val+"\";");
			else if (val[1] != undefined)
				eval(key+"=["+val[0]+","+val[1]+"];");
			else
				eval(key+"="+val+";");
		});
	
		}
	});
	
	var childrenScopes = children; // Comma separated list of children scope IDs and names.
	                               // This variable comes from the db and evaluated in the JS
	                               // interpreter to be a normal JS variable
	
	/* if childrenScopes, then means that this scope has child scopes and hier tables should be created */
	if (childrenScopes) {
		childrenScopes = childrenScopes.split(","); // split the children string into array
		
		var div1 = document.getElementById("coverage_summary_by_instance");
		if (div1) {
			newElement = document.createElement('HR');
			div1.appendChild(newElement);
			newElement = document.createElement('H3');
			newElement.innerHTML = "Coverage Summary By Instance:";
			div1.appendChild(newElement);
	
			// create the coverage_summary_by_instance table and its header
			newTable = document.createElement('TABLE');
			newTable.cellspacing = "2";
			newTable.cellpadding = "2";
			var tblBody = document.createElement("tbody");
	
			newRow = document.createElement('tr');
			
			FillColsList(tblBody, 'TOTAL', 0, 2, ListCols);	
			createCell(newRow, "TH", 'even',  2, 'Scope', 0, 0, 0);		
			createCell(newRow, "TH", 'even', 0, 'TOTAL', 0, 0, 0);
			if (ListCols[0] == 0)
			createCell(newRow, "TH", 'even',  0, 'Cvg', 0, 0, 0);
			if (ListCols[1] == 0)
			createCell(newRow, "TH", 'even', 0, 'Cover', 0, 0, 0);
			if (ListCols[2] == 0)
			createCell(newRow, "TH", 'even',  0, 'Statement', 0, 0, 0);
			if (ListCols[3] == 0)
			createCell(newRow, "TH", 'even', 0, 'Branch', 0, 0, 0);
			if (ListCols[4] == 0)
			createCell_2txt(newRow, "TH", 'even',  0, 'UDP', 'Expression');
			if (ListCols[5] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'UDP', 'Condition');
			if (ListCols[6] == 0)
			createCell_2txt(newRow, "TH", 'even',  0, 'FEC', 'Expression');
			if (ListCols[7] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'FEC', 'Condition');
			if (ListCols[8] == 0)
			createCell(newRow, "TH", 'even',  0, 'Toggle', 0, 0, 0);
			if (ListCols[9] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'FSM', 'State');
			if (ListCols[10] == 0)
			createCell_2txt(newRow, "TH", 'even',  0, 'FSM', 'Trans');
			if (ListCols[11] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'Assertion', 'Attempted');
			if (ListCols[12] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'Assertion', 'Passes');
			if (ListCols[13] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'Assertion', 'Failures');
			if (ListCols[14] == 0)
			createCell_2txt(newRow, "TH", 'even', 0, 'Assertion', 'Successes');
	
			tblBody.appendChild(newRow);		
			g_dynamic_z_lastRowOdd = 0;	
	
			// first row, its data is gotten from the prev call of ajax.
			createRow(tblBody, 'TOTAL', 0, 2, ListCols, 0/*filtering_active*/);
	
			var scopeName = div1.getAttribute('scopeName');
			var localTable = document.getElementById("local_data_table");
			if (scopeName && localTable) {
				removeAllDataVariables();
	
				// adjust the values of the local coverage data. w, g, d, s, b, etc...
				w = localTable.rows[0].cells[1].innerHTML;
				w = w.substring(0, w.length - 1);
	
				for (var i=2; i< localTable.rows.length; i++) {
					switch (localTable.rows[i].cells[0].childNodes[0].innerHTML?localTable.rows[i].cells[0].childNodes[0].innerHTML:localTable.rows[i].cells[0].innerHTML) {
						case "Covergroup": {
							g = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Directive": {
							d = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Statement": {
							s = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Branch": {
							b = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Expression": {
							i= i+1;
							switch (localTable.rows[i].cells[0].childNodes[0].innerHTML?localTable.rows[i].cells[0].childNodes[0].innerHTML:localTable.rows[i].cells[0].innerHTML) {
								case "UDB": {
									ue = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
								case "FEC": {
									fe = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
							}						
						}					
						case "FEC Expression": {
							fe = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Condition": {
							i= i+1;
							switch (localTable.rows[i].cells[0].childNodes[0].innerHTML?localTable.rows[i].cells[0].childNodes[0].innerHTML:localTable.rows[i].cells[0].innerHTML) {
								case "UDB": {
									uc = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
								case "FEC": {
									fc = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
							}	
						}
						case "FEC Condition": {
							fc = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}
						case "Toggle": {
							t = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}					
						case "FSM": {
							i=i+1;
							switch (localTable.rows[i].cells[0].childNodes[0].innerHTML?localTable.rows[i].cells[0].childNodes[0].innerHTML:localTable.rows[i].cells[0].innerHTML) {
								case "State": {
									fs = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
								case "Transition": {
									ft = [localTable.rows[i].cells[2].innerHTML, localTable.rows[i].cells[3].innerHTML]; i=i+1; break;
								}
							}
						}					
						case "Assertion": {
							as = [localTable.rows[i].cells[1].innerHTML, localTable.rows[i].cells[2].innerHTML]; break;
						}					
						default: {
							break;
						}
					}
				}
				createRow(tblBody, scopeName, 0, 2,ListCols, 0);
			}
			var j;
			for(j=0; j < childrenScopes.length -1; j+=2) { // loop on each child id , childrenScopes
				removeAllDataVariables();
	
				if (childrenScopes[j]) {
					/* read the json file for this child and process its data */
					$.ajax({
						type: "GET",
						url: "h" + childrenScopes[j] +".json",
						async: false,
						processData: true,
						data: {},
						dataType: "json",
						success: function(data,y,z) {
	
						$.each(data, function(key, val) {
							if (key == "children")
								eval(key+"=\""+val+"\";");
							else if (val[1] != undefined)
								eval(key+"=["+val[0]+","+val[1]+"];");
							else
								eval(key+"="+val+";");
						});
	
						}
					});
	
					createRow(tblBody, childrenScopes[j+1], "z"+childrenScopes[j]+".htm", 1, ListCols, 0);
				} else {
					// this case means that there is a child, but it doesn't have a page crated for it. so there is no link or data for it
					createRow(tblBody, childrenScopes[j+1], 0, 1, ListCols, 0);
				}
			}
			newTable.appendChild(tblBody);
			div1.appendChild(newTable);
		}
	
		removeAllDataVariables();
		/* read the json file for this scope again for the recursive_hier_coverage_details table */
		$.ajax({
			type: "GET",
			url: "h" + id +".json",
			async: false,
			processData: true,
			data: {},
			dataType: "json",
			success: function(data,y,z) {
	
			$.each(data, function(key, val) {
				if (key == "children")
					eval(key+"=\""+val+"\";");
				else if (val[1] != undefined)
					eval(key+"=["+val[0]+","+val[1]+","+val[2]+","+val[3]+","+val[4]+"];");
				else
					eval(key+"="+val+";");
			});
	
			}
		});
	
		var loc_rec_table = document.getElementById("loc_rec_tables");
		var addTable = 0;
		if (loc_rec_table) {
			addTable = 1;
			newCellTable = document.createElement('TD');
			loc_rec_table.rows[0].appendChild(newCellTable);
		}	
		
		if (addTable) {
			newElement = document.createElement('H3');
			newElement.innerHTML = "Recursive Hierarchical Coverage Details:";
			if (newlook) {
				newCellTable.appendChild(newElement);
			} else {
				div1.appendChild(newElement);
			}
			
			//create the recursive_hier_coverage_details table and its header
			newTable = document.createElement('TABLE');
			var tblBody = document.createElement("tbody");
			newTable.cellspacing = "2";
			newTable.cellpadding = "2";
	
			if (newlook) {
				g_dynamic_z_lastRowOdd = 0;
			}
			newRow = document.createElement('tr');
			createCell(newRow, "TD", 'odd', 6, 'Total Coverage:' , 0, 0, 0);
			
			var cellClass = coverageToStyle(q);
			createCell(newRow, "TD", cellClass, 0, q+"%", 0, 0, 0);
			
			cellClass = coverageToStyle(w);
			createCell(newRow, "TD", cellClass, 0, w+"%", 0, 0, 0);
			
			tblBody.appendChild(newRow);
			
			if (newlook) {
				g_dynamic_z_lastRowOdd = g_dynamic_z_lastRowOdd ? 0 : 1;
			}
	
			newRow = document.createElement('tr');
			createCell(newRow, "TH", 'even',   2, 'Coverage Type', 0, 0, 'left');
			createCell(newRow, "TH", 'even',  0, 'Bins' , 0, 0, 0);
			createCell(newRow, "TH", 'even',   0, 'Hits'   , 0, 0, 0);
			createCell(newRow, "TH", 'even',   0, 'Misses'   , 0, 0, 0);
			createCell(newRow, "TH", 'even',   0, 'Weight'   , 0, 0, 0);
			createCell(newRow, "TH", 'even',   0, '% Hit'   , 0, 0, 0);
			createCell(newRow, "TH", 'even',  0, 'Coverage' , 0, 0, 0);
			tblBody.appendChild(newRow);
			
			if (newlook) {
				g_dynamic_z_lastRowOdd = g_dynamic_z_lastRowOdd ? 0 : 1;
			}
	
			var types = ["g", "d", "s", "b", "e", "ue", "fe", "c", "uc", "fc", "t", "f", "fs", "ft", "as"];
			for(var i=0; i<types.length; i++) {
				try {
					if (eval(types[i]) != undefined) {
						createCoverageTypeRow(tblBody, eval(types[i]), i);
					}
				} catch (err) {
					;
				}
			}
	
			newTable.appendChild(tblBody);
	
			if (newlook) {
				newCellTable.appendChild(newTable);
			} else {
				div1.appendChild(newTable);
			}
		}
	}
}

start_sort = 1;
