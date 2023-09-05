var stIsIE = /*@cc_on!@*/false;
var tables = [];
var atomic_tables=[];
var per_test_page = 0;
var global_intervalId;
// initialization function
function init() {

	try {
		$('#ucdb2html_summary').hide();
		$('#ucdb2html_summary').fadeIn(100);
	} catch (err) {;}
	 // quit if this function has already been called
    if (arguments.callee.alreadyCalled) return;
    // flag this function so we don't do the same thing twice
    arguments.callee.alreadyCalled = true;
    // kill the timer
    if (_timer) clearInterval(_timer);
    
    if (!document.createElement || !document.getElementsByTagName) return;

	global_intervalId = setInterval( 'waitTillTablesAreReady()', 200 );
};

function waitTillTablesAreReady() {
	if ( !((typeof start_sort != "undefined") && (start_sort == 0)) ) {
		clearInterval(global_intervalId);
		continueProcessing();
	}
}

function continueProcessing() {
	
	tables = document.getElementsByTagName("TABLE");
	for(var i =0; i<tables.length; i++) {
		var tableInTable = (tables[i].getElementsByTagName("TABLE")).length > 0;
		if (!tableInTable)
			atomic_tables[atomic_tables.length] = tables[i];
	}
	delete tables;
	for(var table = 0; table < atomic_tables.length; table++) {
		var curr_table = atomic_tables[table];
		
		if (curr_table.className.match("fpw")) {
			continue;
		}
		
		curr_table.table_unique_number = table;
		curr_table.unsorted_rows = []; // array that holds arrays with the first positions of the rows of each table

		for(var row = 0; row < curr_table.rows.length; row++) {
			curr_table.unsorted_rows[row] = curr_table.rows[row];
		}
		// process the head of the table:
		var level = curr_table.rows[0].cells[0].colSpan;
		var headRawCells = [];
		
		if(curr_table.rows[0].cells[0].innerHTML.search("Total Coverage:") != -1) {
			// the tables of the cov_summary page and Recursive Hierarchical Coverage Details and Local Instance Coverage Details
			headRawCells = curr_table.rows[1].cells;
			sortFromRow = 2;
		} else if ((curr_table.rows[0].cells[0].innerHTML.search("Design Scope") != -1) || (curr_table.rows[0].cells[0].innerHTML.search("Testplan") != -1)) {
			// the tables of Coverage Summary By Structure: OR Testplan Coverage Summary:
			headRawCells = curr_table.rows[0].cells;
			sortFromRow = 1;
		} else if (curr_table.rows[0].cells[0].innerHTML.search("Scope") != -1) {
			// the tables of Coverage Summary By Instance:
			headRawCells = curr_table.rows[0].cells;
			sortFromRow = 2;
		} else if (curr_table.rows[0].cells[0].innerHTML.search("Test Name") != -1) {
			headRawCells = curr_table.rows[0].cells;
			sortFromRow = 1;
			per_test_page = 1;
		} else {
			continue;
		}
		var shifted_columns = false;
		for(var i = 0; i < headRawCells.length; i++) {
			if (i == 0) { /* 1st column is always sort by strings */
				headRawCells[i].sorttable_sortfunction = sort_strings;
				
			} else if (per_test_page == 0) { /* columns after the 1st one, if it's not pertest page, then sort by numbers */
				headRawCells[i].sorttable_sortfunction = sort_numbers;
				
			} else if (nonlossy_merge == 0) { /* if it's a pertest page, if it's not nonlossy merge, then merge by strings */
				headRawCells[i].sorttable_sortfunction = sort_strings;
				
			} else { /* if it's a pertest page, if it's nonlossy merge, then merge by numbers */
				headRawCells[i].sorttable_sortfunction = sort_numbers;
				
			}
			headRawCells[i].sorttable_columnindex = i;
			if (shifted_columns) headRawCells[i].sorttable_columnindex = i+1;
			headRawCells[i].sorttable_tbody = curr_table.tBodies[0];
			if (!headRawCells[i].parentNode.to_be_sorted) {
				headRawCells[i].parentNode.to_be_sorted = [];
				for(var j = sortFromRow; j < curr_table.rows.length; j++) {
					curr_table.rows[j].cells_text = [];
					for(var k = 0; k < curr_table.rows[j].cells.length; k++) {
						curr_table.rows[j].cells_text[k] = getInnerText(curr_table.rows[j].cells[k]);
					}
					if(level == 1) {
						headRawCells[i].parentNode.to_be_sorted[headRawCells[i].parentNode.to_be_sorted.length] = curr_table.rows[j];
					} else if (level > 1) {
						if(curr_table.rows[j].cells[0].colSpan == 2) {
							headRawCells[i].parentNode.to_be_sorted[headRawCells[i].parentNode.to_be_sorted.length] = curr_table.rows[j];
						} else /*if(curr_table.rows[j].cells[0].colSpan == 1)*/ {
							if(j > sortFromRow && !shifted_columns) {
								var parent_row = j-1;
								curr_table.rows[parent_row].children_rows = [];
								do {
									curr_table.rows[parent_row].children_rows[curr_table.rows[parent_row].children_rows.length] = curr_table.rows[j];
									curr_table.rows[j].cells_text = [];
									for(var k = 0; k < curr_table.rows[j].cells.length; k++) {
										curr_table.rows[j].cells_text[k] = getInnerText(curr_table.rows[j].cells[k]);
									}
									j++;
								} while (j < curr_table.rows.length && curr_table.rows[j].cells[0].colSpan == 1);
								j--;
							} else /*if(j == sortFromRow || shifted_columns)*/ {
								headRawCells[i].parentNode.to_be_sorted[headRawCells[i].parentNode.to_be_sorted.length] = curr_table.rows[j];
								headRawCells[i].sorttable_columnindex = i+1;
								shifted_columns = true;
							}
						}
					}
				}
			} //else {}
			headRawCells[i].className += ' clickable';
			headRawCells[i].title = "Click to sort";
			sortnone = document.createElement('span');
			sortnone.id = "sorttable_sortnone_" + curr_table.table_unique_number + "_" + headRawCells[i].sorttable_columnindex;
			sortnone.innerHTML = stIsIE ? '&nbsp<font face="webdings">3</font>' : '&nbsp;&#x25C2;';
			headRawCells[i].appendChild(sortnone);
			addEvent_toHeadCell(headRawCells[i],"click", sort_main_fn);
		}
	}
	delete atomic_tables;
}

function sort_numbers (a,b) {
	aa = a[0].toString().replace(/[^0-9.]/g, '');
	bb = b[0].toString().replace(/[^0-9.]/g, '');
	if (isNaN(aa)) aa = 0;
	if (isNaN(bb)) bb = 0;
	return aa - bb;
}

function sort_strings (a,b) {
	if (a[0]==b[0]) return 0;
    if (a[0]<b[0]) return -1;
    return 1;
}

function reverse_rows(tbody, rows, col, headNode) {
	if(!headNode.passed_once){
		headNode.passed_once = true;
		var first_cell = rows[0][0];
		for (var i=0; i<rows.length; i++) {
			if(rows[i][0] != first_cell) {
				headNode.change_parents = true;
			}
			if(rows[i][1].cells[col].children_ascending_order) {
				var first_child_cell = rows[i][1].cells[col].children_ascending_order[0][0];
				for (var j=1; j<rows[i][1].cells[col].children_ascending_order.length; j++) {
					if (first_child_cell != rows[i][1].cells[col].children_ascending_order[j][0]) {
						rows[i][1].cells[col].change_children = true;
						break;
					}
				}
			}
		}
	}
	newrows = [];
	if(headNode.change_parents)
		rows.reverse();
	
	for (var i=0; i<rows.length; i++) {
		newrows[newrows.length] = rows[i];
		if(rows[i][1].cells[col].children_ascending_order) {
			if(rows[i][1].cells[col].change_children)
				rows[i][1].cells[col].children_ascending_order.reverse();
			for (var j=0; j<rows[i][1].cells[col].children_ascending_order.length; j++) {
				newrows[newrows.length] = rows[i][1].cells[col].children_ascending_order[j];
			}
			if(rows[i][1].cells[col].change_children)
				rows[i][1].cells[col].children_ascending_order.reverse();
		}	
	}
	 
	for (var i= 0; i < newrows.length; i++) {
		tbody.appendChild(newrows[i][1]);
    }

    delete newrows;
	if(headNode.change_parents)
		rows.reverse();
}

function sort_main_fn() {
	if (this.className.search(/\bsorted_ascending\b/) != -1) {
		reverse_rows(this.sorttable_tbody, this.ascending_row_order, this.sorttable_columnindex, this);		
		this.className = this.className.replace('sorted_ascending',
												'sorted_descending');
		this.removeChild(document.getElementById('sorttable_sortfwdind_' + this.sorttable_tbody.parentNode.table_unique_number));
		sortrevind = document.createElement('span');
		sortrevind.id = "sorttable_sortrevind_" + this.sorttable_tbody.parentNode.table_unique_number;
		sortrevind.innerHTML = stIsIE ? '&nbsp<font face="webdings">5</font>' : '&nbsp;&#x25B4;';
		this.appendChild(sortrevind);
		return;
	}
	if (this.className.search(/\bsorted_descending\b/) != -1) {
		var this_table = this.sorttable_tbody.parentNode;
		for(var i = 0; i < this_table.unsorted_rows.length; i++) {
			this.sorttable_tbody.appendChild(this_table.unsorted_rows[i]);
		}
        this.className = this.className.replace('sorted_descending','');
        this.removeChild(document.getElementById('sorttable_sortrevind_' + this.sorttable_tbody.parentNode.table_unique_number));

		sortnone = document.createElement('span');
		sortnone.id = "sorttable_sortnone_" + this.sorttable_tbody.parentNode.table_unique_number + "_" + this.sorttable_columnindex;
		sortnone.innerHTML = stIsIE ? '&nbsp<font face="webdings">3</font>' : '&nbsp;&#x25C2;';
		this.appendChild(sortnone);
		return;
	}
	
	// remove sorted_ascending classes
	theadrow = this.parentNode;
    Array.forEach(theadrow.childNodes, function(cell) {
		if (cell.nodeType == 1) { // an element
			cell.className = cell.className.replace('sorted_descending','');
            cell.className = cell.className.replace('sorted_ascending','');
		}
		});
	sortfwdind = document.getElementById('sorttable_sortfwdind_' + this.sorttable_tbody.parentNode.table_unique_number);
    if (sortfwdind) {
		sortnone = document.createElement('span');
		parentCellNode = sortfwdind.parentNode;
		sortnone.id = "sorttable_sortnone_" + parentCellNode.sorttable_tbody.parentNode.table_unique_number + "_" + parentCellNode.sorttable_columnindex;
		sortnone.innerHTML = stIsIE ? '&nbsp<font face="webdings">3</font>' : '&nbsp;&#x25C2;';
		parentCellNode.removeChild(sortfwdind);
		parentCellNode.appendChild(sortnone);
	}
    sortrevind = document.getElementById('sorttable_sortrevind_' + this.sorttable_tbody.parentNode.table_unique_number);
    if (sortrevind) {
		sortnone = document.createElement('span');
		parentCellNode = sortrevind.parentNode;
		sortnone.id = "sorttable_sortnone_" + parentCellNode.sorttable_tbody.parentNode.table_unique_number + "_" + parentCellNode.sorttable_columnindex;
		sortnone.innerHTML = stIsIE ? '&nbsp<font face="webdings">3</font>' : '&nbsp;&#x25C2;';
		parentCellNode.removeChild(sortrevind);
		parentCellNode.appendChild(sortnone);
	}
	
	this.className += ' sorted_ascending';
	this.removeChild(document.getElementById('sorttable_sortnone_' + this.sorttable_tbody.parentNode.table_unique_number + "_" + this.sorttable_columnindex));
    sortfwdind = document.createElement('span');
    sortfwdind.id = "sorttable_sortfwdind_" + this.sorttable_tbody.parentNode.table_unique_number;
    sortfwdind.innerHTML = stIsIE ? '&nbsp<font face="webdings">6</font>' : '&nbsp;&#x25BE;';
	this.appendChild(sortfwdind);
	
	// build an array to sort. This is a Schwartzian transform thing,
	// i.e., we "decorate" each row with the actual sort key,
	// sort based on the sort keys, and then put the rows back in order
	// which is a lot faster because you only do getInnerText once per row
	col = this.sorttable_columnindex;
	if(!this.ascending_row_order){
		row_array = [];
		for(var i = 0; i < this.parentNode.to_be_sorted.length; i++) {
			if (this.parentNode.to_be_sorted[i].children_rows) { // which means that there are children_rows for this cell
				var children_row_array = [];
				for(var k = 0; k < this.parentNode.to_be_sorted[i].children_rows.length; k++) {
					children_row_array[children_row_array.length] = [this.parentNode.to_be_sorted[i].children_rows[k].cells_text[col+1], this.parentNode.to_be_sorted[i].children_rows[k]];
				}
				sort_array(children_row_array, this.sorttable_sortfunction);
				this.parentNode.to_be_sorted[i].cells[col].children_ascending_order = children_row_array;
				delete children_row_array;
			}
			row_array[row_array.length] = [this.parentNode.to_be_sorted[i].cells_text[col], this.parentNode.to_be_sorted[i]];
		}
		sort_array(row_array, this.sorttable_sortfunction);
		
		this.ascending_row_order = row_array;
		delete row_array;
	}
	tb = this.sorttable_tbody;
	
	for (var j=0; j<this.ascending_row_order.length; j++) {
		tb.appendChild(this.ascending_row_order[j][1]);
		if(this.ascending_row_order[j][1].cells[col].children_ascending_order) {
			//append the children_rows too, using for loop
			for(var t = 0; t < this.ascending_row_order[j][1].cells[col].children_ascending_order.length; t++) {
				tb.appendChild(this.ascending_row_order[j][1].cells[col].children_ascending_order[t][1]);
			}
		}
	}
}

/* for Mozilla/Opera9 */
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}

/* for Internet Explorer */
/*@cc_on @*/
/*@if (@_win32)
    document.write("<script id=__ie_onload defer src=javascript:void(0)><\/script>");
    var script = document.getElementById("__ie_onload");
    script.onreadystatechange = function() {
        if (this.readyState == "complete") {
            init(); // call the onload handler
        }
    };
/*@end @*/

/* for Safari */
if (/WebKit/i.test(navigator.userAgent)) { // sniff
    var _timer = setInterval(function() {
        if (/loaded|complete/.test(document.readyState)) {
            init(); // call the onload handler
        }
    }, 10);
}

/* for other browsers */
window.onload = init;

function addEvent_toHeadCell(element, type, handler) {
	if (element.addEventListener) {
		element.addEventListener(type, handler, false);
	} else {
		// assign each event handler a unique ID
		if (!handler.$$guid) handler.$$guid = addEvent_toHeadCell.guid++;
		// create a hash table of event types for the element
		if (!element.events) element.events = {};
		// create a hash table of event handlers for each element/event pair
		var handlers = element.events[type];
		if (!handlers) {
			handlers = element.events[type] = {};
			// store the existing event handler (if there is one)
			if (element["on" + type]) {
				handlers[0] = element["on" + type];
			}
		}
		// store the event handler in the hash table
		handlers[handler.$$guid] = handler;
		// assign a global event handler to do all the work
		element["on" + type] = handleEvent;
	}
};
addEvent_toHeadCell.guid = 1;

function handleEvent(event) {
	var returnValue = true;
	// grab the event object (IE uses a global event object)
	event = event || fixEvent(((this.ownerDocument || this.document || this).parentWindow || window).event);
	// get a reference to the hash table of event handlers
	var handlers = this.events[event.type];
	// execute each event handler
	for (var i in handlers) {
		this.$$handleEvent = handlers[i];
		if (this.$$handleEvent(event) === false) {
			returnValue = false;
		}
	}
	return returnValue;
};

function fixEvent(event) {
	event.preventDefault = fixEvent.preventDefault;
	event.stopPropagation = fixEvent.stopPropagation;
	return event;
};
fixEvent.preventDefault = function() {
	this.returnValue = false;
};
fixEvent.stopPropagation = function() {
  this.cancelBubble = true;
}

if (!Array.forEach) { // mozilla already supports this
	Array.forEach = function(array, block, context) {
		for (var i = 0; i < array.length; i++) {
			block.call(context, array[i], i, array);
		}
	};
}

function sort_array(list, comp_func) {
    var b = 0;
    var t = list.length - 1;
    var swap = true;

    while(swap) {
        swap = false;
        for(var i = b; i < t; ++i) {
            if ( comp_func(list[i], list[i+1]) > 0 ) {
                var q = list[i]; list[i] = list[i+1]; list[i+1] = q;
                swap = true;
            }
        }
        t--;

        if (!swap) break;

        for(var i = t; i > b; --i) {
            if ( comp_func(list[i], list[i-1]) < 0 ) {
                var q = list[i]; list[i] = list[i-1]; list[i-1] = q;
                swap = true;
            }
        }
        b++;

	}
}

  function getInnerText (node) {
    // gets the text we want to use for sorting for a cell.
    // strips leading and trailing whitespace.
	if (typeof node.textContent != 'undefined') {
      return node.textContent.replace(/^\s+|\s+$/g, '');
    }
    else if (typeof node.innerText != 'undefined') {
      return node.innerText.replace(/^\s+|\s+$/g, '');
    }
    else if (typeof node.text != 'undefined') {
      return node.text.replace(/^\s+|\s+$/g, '');
    }
    else {
      return '';
    }
  }

