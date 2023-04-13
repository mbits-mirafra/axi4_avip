var TEXTAREA_COLS = 20;
var TEXTAREA_COLS_STR = 20;
var TEXTAREA_ROWS_STR = 2;

var NUM_OF_ATTRIBUTES = 0;

function getLinkStatusToStr(linkStatus) {
	switch (linkStatus) {
		case '1':					return "Unlinked";
		case '2':					return "Clean";
		case '3':					return "Partial";
		case '4':					return "Error";
		default: 					return "";
	}
}

function toggleContentsDisplay(tpTreeNodeObj) {
	if (tpTreeNodeObj.areContentsExpanded) {
		tpTreeNodeObj.collapseNode();
	} else {
		tpTreeNodeObj.expandNode();
	}
}

function showOnlyTpSections() {
	var i;
	for (i=0 ; i<globalTopTpTreeNodesArraySize ; i++) {
		globalTopTpTreeNodesArray[i].displayNode();
		globalTopTpTreeNodesArray[i].displayTpSectionsOnly();
	}
}

function collapseAll() {
	var i;
	for (i=0 ; i<globalTopTpTreeNodesArraySize ; i++) {
		globalTopTpTreeNodesArray[i].displayNode();
		globalTopTpTreeNodesArray[i].forceCollapse();
	}
}

function expandAll() {
	var i;
	for (i=0 ; i<globalTopTpTreeNodesArraySize ; i++) {
		globalTopTpTreeNodesArray[i].displayNode();
		globalTopTpTreeNodesArray[i].forceExpand();
	}
}

function showTpSectionsAndLinks() {
	var i;
	for (i=0 ; i<globalTopTpTreeNodesArraySize ; i++) {
		globalTopTpTreeNodesArray[i].displayNode();
		globalTopTpTreeNodesArray[i].displayTpSectionsAndLinks();
	}
}

function getTaggedItemDataCellClass(isOdd, cntrRightLeft, isMissingLink, isExcluded,colorIsGray) {
	var className = '';
	
	if (isExcluded) {
		className += 'Excl';
	} else if (isMissingLink) {
		className += 'Missing';
	} else if (colorIsGray == 1) {
		className += 'Gray';
	}
	
	className += cntrRightLeft;

	if (isOdd) {
		className += 'Odd';
	} else {
		className += 'Even';
	}
	
	return (className  += 'TgTd');	
}

function getTestplanSectionDataCellClass(isOdd, cntrRightLeft, isExcluded, cellType,colorIsGray) {
	var className = '';
	
	if (isExcluded) {
		className += 'Excl';
	}else if (colorIsGray == 1) {
		className += 'Gray';
	}		
	className += cntrRightLeft;

	if (isOdd) {
		className += 'Odd';
	} else {
		className += 'Even';
	}
	
	return (className  += cellType);
}

function addCell(rowObj, innerHtml, className, colSpan, cellType) {
	var newCell = document.createElement(cellType);
	newCell.className = className;
	newCell.colSpan = colSpan;
	newCell.innerHTML = innerHtml;
	rowObj.appendChild(newCell);
}

function addDataCell(rowObj, innerHtml, className) {
	addCell(rowObj, innerHtml, className, 1, 'TD');
}

function addHeaderCell(rowObj, innerHtml, className, colSpan) {
	addCell(rowObj, innerHtml, className, colSpan, 'TH');
}

function buildHeaderRow(rowObj) {
	addHeaderCell(rowObj, 'Testplan section', 'odd' , rowObj.getAttribute('s'));
	addHeaderCell(rowObj, 'Linked Items'    , 'even', 1);
	addHeaderCell(rowObj, 'Covered Items'   , 'odd' , 1);
	addHeaderCell(rowObj, 'Coverage'        , 'even', 1);
	addHeaderCell(rowObj, '% of Goal'       , 'odd' , 1);
	addHeaderCell(rowObj, 'Type'            , 'even', 1);
	addHeaderCell(rowObj, 'Bins'            , 'odd' , 1);
	addHeaderCell(rowObj, 'Hits'            , 'even', 1);
	addHeaderCell(rowObj, '% Hit'           , 'odd' , 1);
	addHeaderCell(rowObj, 'Link Status'     , 'even', 1);
	addHeaderCell(rowObj, 'Description'     , 'odd' , 1); // this is the last default column
	
	var lastClassOdd = true;
	var i = 1;
	var tmp;
	var className;
	for(; i > 0; i++) {
		tmp = rowObj.getAttribute('x' + i);
		if (!tmp) break;
		if (lastClassOdd) {
			className = 'even';
		} else {
			className = 'odd';
		}
		addHeaderCell(rowObj, tmp, className, 1);	
		lastClassOdd = !lastClassOdd;
	}
	NUM_OF_ATTRIBUTES = i-1;
}

function addIndentationCellsToDataRow(rowObj) {
	var tmp = rowObj.getAttribute('l');
	if (tmp) {
		var newCell;
		for(var i = 0; i < tmp; i++) {
			newCell = document.createElement('TD');
			newCell.innerHTML = '&nbsp;';
			rowObj.appendChild(newCell);
		}
	}
}

function addTaggedItemNameCell(rowObj, isExcluded, isMissingLink, rowNum) {
	var tmp;
	var colorIsGray = rowObj.getAttribute('cl');
	var newCell = document.createElement('TD');

	newCell.className = getTaggedItemDataCellClass(1, '', isMissingLink, isExcluded,colorIsGray);
	
	tmp = rowObj.getAttribute('s');
	if (tmp > 1) {
		newCell.setAttribute("colSpan", tmp);
	} else {
		newCell.setAttribute("colSpan", "1");
	}
	
	tmp = rowObj.getAttribute('i');
	if (tmp) {
		// This means this tagged item has a full path row (the following row in the table)
		var expandCollapseButton = document.createElement('DIV');
		expandCollapseButton.id = 't' + tmp + 'L' + rowObj.getAttribute('in') + "IdB" ;
		expandCollapseButton.className = "btnD";
		expandCollapseButton.setAttribute("onclick", "toggleContentsDisplay(globalTpTreeNodesArray[" + rowNum + '])');
		
		var expandCollapseButtonImage = document.createElement('IMG');
		expandCollapseButtonImage.src = "images/rtr.png";
		expandCollapseButton.appendChild(expandCollapseButtonImage);
		newCell.appendChild(expandCollapseButton);
		
		// initialize the expand/collapse button object in the tree node object
		globalTpTreeNodesArray[rowNum].divButtonDomObj = expandCollapseButton;
	}
	var newElement = document.createElement('DIV');
	newElement.className = "tpD";
	newElement.innerHTML = rowObj.getAttribute('z');
	
	newCell.appendChild(newElement);
	rowObj.appendChild(newCell);
}

function addColoredPcntgDataCell(rowObj, valueAttrName, colorAttrName, isOdd, colorIsGray) {
	var value = rowObj.getAttribute(valueAttrName);
	var color = rowObj.getAttribute(colorAttrName);
	var className = '';
	if (value) {
		if (colorIsGray != 1) {
			switch (color) {
			case 'R':
				className = 'bgRed'; break;
			case 'Y':
				className = 'bgYellow'; break;
			case 'G':
				className = 'bgGreen'; break;
			default:
				className = ''; break;
			}
			addDataCell(rowObj, value+'%', className);
		} else {
			className = 'Gray';
			if (isOdd) {
				addDataCell(rowObj, value+'%', className+'CntrOddTd');
			} else {
				addDataCell(rowObj, value+'%', className+'CntrEvenTd');
			}
		}
		
	} else {
		if (colorIsGray == 1) {
			className = 'Gray';
		}
		if (isOdd) {
			addDataCell(rowObj, '--', className+'CntrOddTd');
		} else {
			addDataCell(rowObj, '--', className+'CntrEvenTd');
		}
	}
}

function addTextBoxCell(rowObj, text, isOdd, isExcluded) {
	var newCell = document.createElement('TD');
	var colorIsGray = rowObj.getAttribute('cl');
	newCell.className = getTestplanSectionDataCellClass(isOdd, '', isExcluded, 'Td',colorIsGray);
	
	if (text) {
		if (text.length > TEXTAREA_COLS) {
			var newElement = document.createElement('textarea');
			newElement.readonly = "readonly";
			newElement.className = getTestplanSectionDataCellClass(isOdd, '', isExcluded, 'TxtBox',colorIsGray);
			
			newElement.cols = TEXTAREA_COLS_STR;
			newElement.rows = TEXTAREA_ROWS_STR;
			newElement.innerHTML = text;
			newCell.appendChild(newElement);
		} else {
			newCell.innerHTML = text;
		}
	} // end if (text)
	
	rowObj.appendChild(newCell);
}

function addTestplanSectionDataCells(rowObj, isExcluded, linkStatusValue) {		
	if (isExcluded) {
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(0, '', isExcluded, 'Td',0));          /*Linked Items*/
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(1 ,'', isExcluded, 'Td',0));          /*Covered Items*/		
		addDataCell(rowObj, '--', //'Excluded'
				getTestplanSectionDataCellClass(0, '', isExcluded, 'Td',0));          /*Coverage*/
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(1 , '',isExcluded, 'Td',0));          /*% of Goal*/
		addDataCell(rowObj, rowObj.getAttribute('t'),
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',0));     /*Type*/
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(1 , 'Cntr', isExcluded, 'Td',0));     /*Bins*/
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',0));     /*Hits*/
		addDataCell(rowObj, '--',
				getTestplanSectionDataCellClass(1 , 'Cntr', isExcluded, 'Td',0));     /* %Hit */
		addDataCell(rowObj, getLinkStatusToStr(linkStatusValue),
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',0));     /*LinkStatus*/
	} else {
		var colorIsGray = rowObj.getAttribute('cl');		
		addDataCell(rowObj, rowObj.getAttribute('c'),
				getTestplanSectionDataCellClass(0 , 'Right', isExcluded, 'Td',colorIsGray));        /*Linked Items*/		
		addDataCell(rowObj, rowObj.getAttribute('v'),
				getTestplanSectionDataCellClass(1 , 'Right', isExcluded, 'Td',colorIsGray));        /*Covered Items*/		
		addColoredPcntgDataCell(rowObj, 'h', 'hc', 0, colorIsGray);                                  /*Coverage*/
		addColoredPcntgDataCell(rowObj, 'p', 'pc', 1, colorIsGray);                                  /*% of Goal*/
		addDataCell(rowObj, rowObj.getAttribute('t'),
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',colorIsGray));         /*Type*/
		addDataCell(rowObj, rowObj.getAttribute('b'),
				getTestplanSectionDataCellClass(1 , 'Cntr', isExcluded, 'Td',colorIsGray));         /*Bins*/
		addDataCell(rowObj, rowObj.getAttribute('ht'),
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',colorIsGray));         /*Hits*/
		addDataCell(rowObj, rowObj.getAttribute('q'),
				getTestplanSectionDataCellClass(1 , 'Cntr', isExcluded, 'Td',colorIsGray));         /* % Hit */
		addDataCell(rowObj, getLinkStatusToStr(linkStatusValue),
				getTestplanSectionDataCellClass(0 , 'Cntr', isExcluded, 'Td',colorIsGray));         /* LinkStatus */
	}
	
	// description:
	addTextBoxCell(rowObj, rowObj.getAttribute('ch'), 1 , isExcluded);
	
	// attributes
	// NOTE: if the default columns are changed, then lastClassOdd should be changed accordingly
	// according to the class of the last column of the default columns
	var lastClassOdd = true;
	for(var i = 1; i <= NUM_OF_ATTRIBUTES; i++) {
		addTextBoxCell(rowObj, rowObj.getAttribute('x' + i), lastClassOdd, isExcluded);
		lastClassOdd = !lastClassOdd;
	} /* end for loop to print attributes */
}

function addTaggedItemDataCells(rowObj, isExcluded, isMissingLink) {		
	if (isMissingLink) {
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 1, 0,0)/*'missingTgTdE'*/);              /* Linked Items */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 1, 0,0)/*'missingTgTdO'*/);              /* Covered Items */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, 'Cntr', 1, 0,0)/*'missingTgTdCntrE'*/);          /* Coverage */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 1, 0,0)/*'missingTgTdCntrO'*/);          /* % of Goal */
		addDataCell(rowObj, rowObj.getAttribute('t'), getTaggedItemDataCellClass(0, 'Cntr', 1, 0,0)/*'missingTgTdCntrE'*/);          /* Type */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 1, 0,0)/*'missingTgTdCntrO'*/);          /* Bins */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, 'Cntr', 1, 0,0)/*'missingTgTdCntrE'*/);          /* Hits */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 1, 0,0)/*'missingTgTdCntrO'*/);          /* % Hits */
		addDataCell(rowObj, getLinkStatusToStr(isMissingLink), getTaggedItemDataCellClass(0, 'Cntr', 1, 0, 'TgTd',0)/*'missingTgTdCntrE'*/);     /* Link Status */
		addDataCell(rowObj, '', getTaggedItemDataCellClass(1, 'Cntr', 1, 0,0)/*'missingTgTdCntrO'*/);            /* Description */
		
		// attributes
		// NOTE: if the default columns are changed, then lastClassOdd should be changed accordingly
		// according to the class of the last column of the default columns
		var lastClassOdd = true;
		for(var i = 1; i <= NUM_OF_ATTRIBUTES; i++) {
			if (lastClassOdd) {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 1, 0,0)/*'missingTgTdE'*/);
			} else {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 1, 0,0)/*'missingTgTdO'*/);
			}
			lastClassOdd = !lastClassOdd;
		} /* end for loop to print attributes */
		
	} else if (isExcluded) {
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 0, 1,0)/*'exclTgTdE'*/);                 /* Linked Items */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 0, 1,0)/*'exclTgTdO'*/);                 /* Covered Items */
		addDataCell(rowObj, 'Excluded', getTaggedItemDataCellClass(0, 'Cntr', 0, 1,0)/*'exclTgTdCntrE'*/);       /* Coverage */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 0, 1,0)/*'exclTgTdCntrO'*/);             /* % of Goal */
		addDataCell(rowObj, rowObj.getAttribute('t'), getTaggedItemDataCellClass(0, 'Cntr', 0, 1,0)/*'exclTgTdCntrE'*/);          /* Type */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 0, 1,0)/*'exclTgTdCntrO'*/);          /* Bins */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, 'Cntr', 0, 1,0)/*'exclTgTdCntrE'*/);          /* Hits */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, 'Cntr', 0, 1,0)/*'exclTgTdCntrO'*/);          /* % Hits */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, 'Cntr', 0, 1,0)/*'exclTgTdCntrE'*/);          /* Link Status */
		addDataCell(rowObj, '', getTaggedItemDataCellClass(1, 'Cntr', 0, 1,0)/*'exclTgTdCntrO'*/);            /* Description */
		
		// attributes
		// NOTE: if the default columns are changed, then lastClassOdd should be changed accordingly
		// according to the class of the last column of the default columns
		var lastClassOdd = true;
		for(var i = 1; i <= NUM_OF_ATTRIBUTES; i++) {
			if (lastClassOdd) {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 0, 1,0)/*'exclTgTdE'*/);
			} else {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 0, 1,0)/*'exclTgTdO'*/);
			}
			lastClassOdd = !lastClassOdd;
		} /* end for loop to print attributes */
		
	} else {
		var colorIsGray = rowObj.getAttribute('cl');
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 0, 0,colorIsGray)/*'tgTdE'*/);                              /* Linked Items */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 0, 0,colorIsGray)/*'tgTdO'*/);                              /* Covered Items */
		addColoredPcntgDataCell(rowObj, 'h', 'hc', 0 /*isOdd*/, colorIsGray);         /* Coverage */
		addColoredPcntgDataCell(rowObj, 'p', 'pc', 1 /*isOdd*/, colorIsGray);         /* % of Goal */
		addDataCell(rowObj, rowObj.getAttribute('t'), getTaggedItemDataCellClass(0, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrE'*/);      /* Type */
		addDataCell(rowObj, rowObj.getAttribute('b'), getTaggedItemDataCellClass(1, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrO'*/);      /* Bins */
		addDataCell(rowObj, rowObj.getAttribute('ht'), getTaggedItemDataCellClass(0, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrE'*/);      /* Hits */
		addDataCell(rowObj, rowObj.getAttribute('q'), getTaggedItemDataCellClass(1, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrO'*/);  /* % Hit */
		addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrE'*/);                          /* Link Status */
		addDataCell(rowObj, '', getTaggedItemDataCellClass(1, 'Cntr', 0, 0,colorIsGray)/*'tgTdCntrO'*/);                            /* Description */
		
		// attributes
		// NOTE: if the default columns are changed, then lastClassOdd should be changed accordingly
		// according to the class of the last column of the default columns
		var lastClassOdd = true;
		for(var i = 1; i <= NUM_OF_ATTRIBUTES; i++) {
			if (lastClassOdd) {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(0, '', 0, 0,colorIsGray)/*'tgTdE'*/);
			} else {
				addDataCell(rowObj, '--', getTaggedItemDataCellClass(1, '', 0, 0,colorIsGray)/*'tgTdO'*/);
			}
			lastClassOdd = !lastClassOdd;
		} /* end for loop to print attributes */
	}
	
	
}

function addTaggedItemRow(rowObj, isExcluded, isMissingLink, rowNum) {
	// tagged items rows are hidden initially
	rowObj.style.display = "none";
	
	addTaggedItemNameCell(rowObj, isExcluded, isMissingLink, rowNum);
	addTaggedItemDataCells(rowObj, isExcluded, isMissingLink);
}

function addFullPathRow(rowObj, isExcluded, isMissingLink, rowNum) {
	// full path rows are hidden initially
	rowObj.style.display = "none";
	
	var isExcluded = rowObj.getAttribute('excl');
	var colorIsGray = rowObj.getAttribute('cl');
	var isMissingLink = rowObj.getAttribute('ls');
	var newCell = document.createElement('TD');
	var tmp;
	
	rowObj.className = "fpTr";
	newCell.className = getTaggedItemDataCellClass(1, '', isMissingLink, isExcluded,colorIsGray);
	
	tmp = rowObj.getAttribute('s');
	if (tmp > 1) {
		newCell.setAttribute("colSpan", tmp);
	} else {
		newCell.setAttribute("colSpan", "1");
	}
	newCell.innerHTML = rowObj.getAttribute('z');
	rowObj.appendChild(newCell);
	
	// initialize the member fullPathRowDomObj of the tree node object of the previous row (tagged item row)
	globalTpTreeNodesArray[rowNum-1].fullPathRowDomObj = rowObj;
}

function addTestplanSectionNameCell(rowObj, rowNum) {
	var newCell = document.createElement('TD');
	var colorIsGray = rowObj.getAttribute('cl');
	newCell.className = getTestplanSectionDataCellClass(1, '', 0, 'Td',colorIsGray)/*'OddTd'*/;
	
	var tmp = rowObj.getAttribute('s');
	if (tmp > 1) {
		newCell.setAttribute("colSpan", tmp);
	} else {
		newCell.setAttribute("colSpan", "1");
	}

	tmp = rowObj.getAttribute('d');
	var newElement;
	var newElement2;
	if (tmp) {
		// this means this testplan section has children and its row can be expanded
		var expandCollapseButton = document.createElement('DIV');
		expandCollapseButton.id = 't' + rowObj.getAttribute('i') + "IdB" ;
		expandCollapseButton.className = "btnD";
		expandCollapseButton.setAttribute("onclick", "toggleContentsDisplay(globalTpTreeNodesArray[" + rowNum + '])');
		
		var expandCollapseButtonImage = document.createElement('IMG');
		expandCollapseButtonImage.src = "images/rtr.png";
		expandCollapseButton.appendChild(expandCollapseButtonImage);
		newCell.appendChild(expandCollapseButton);
		
		// initialize the expand/collapse button object in the tree node object
		globalTpTreeNodesArray[rowNum].divButtonDomObj = expandCollapseButton;
	} else {
		newElement = document.createElement('DIV');
		newElement.className = "dimBtnD";
		newElement2 = document.createElement('IMG');
		newElement2.src = "images/dimrtr.png";
		newElement.appendChild(newElement2);
		newCell.appendChild(newElement);
	}
	
	newElement = document.createElement('DIV');
	newElement.className = "tpD";
	tmp = rowObj.getAttribute('n');
	if (tmp) {
		newElement2 = document.createElement('a');
		newElement2.setAttribute("href", "pages/" + tmp);
		newElement2.innerHTML = rowObj.getAttribute('z');
		newElement.appendChild(newElement2);
	} else {
		newElement.innerHTML = rowObj.getAttribute('z');
	}
	newCell.appendChild(newElement);
	rowObj.appendChild(newCell);
}

function addTestplanSectionRow(rowObj, isExcluded, linkStatusValue, rowNum) {
	addTestplanSectionNameCell(rowObj, rowNum);
	addTestplanSectionDataCells(rowObj, isExcluded, linkStatusValue);
	
	// we need to mark the parent's row (the row of the parent testplan section) as expanded
	// notice that any testplan section are marked as not expanded till parsing its 1st child
	tpTreeNodeObj = globalTpTreeNodesArray[rowNum];
	parentTpTreeNodeObj = tpTreeNodeObj.parent;
	if (parentTpTreeNodeObj) { // a top testplan section doesn't have a parent
		parentTpTreeNodeObj.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
		parentTpTreeNodeObj.areContentsExpanded = 1;
	}
	
}

// The array globalTpTreeNodesArray will hold all tpTreeNode objects
// Notice that the size of this array equals to the size of the table (the array
// is initialized in the method buildPage) but not all its cells will have an object.
// Any row that doesn't need a tpTreeNode object (currently, they are rows that hold the
// full path of a tagged item) will have its equivalent cell in this array set to 0.
var globalTpTreeNodesArray;

// The array globalTopTpTreeNodesArray will hold tpTreeNode objects for top
// testplan sections. Its size is initialized to 6 (assuming it is not common to
// have more than one top testplan section), but notice that the array object
// in java script expands dynamically
var globalTopTpTreeNodesArray = new Array(6);
var globalTopTpTreeNodesArraySize = 0;

// The array globalParentNodesStack will be used as a stack to build the parent/child
// relationship between tpTreeNode objects.
// Its size is initialized to 6 (assuming it is not common to have a testplan
// section with a parent/child depth to more than 6 level, but whatever the shap
// of the testplan, the array object in java script expands dynamically.
var globalParentNodesStack = new Array(6);
var globalTopOfStack = 0;

function createTreeNodeObjForRow(rowCount, rowObj, isTaggedItem) {
	var newNode = globalTpTreeNodesArray[rowCount] = new TpTreeNode(rowObj, 0, isTaggedItem);
	
	newRowIndent = newNode.rowDomObj.getAttribute('l');
	if (newRowIndent == 0) { // a top testplan section
		// clear the stack and place it in the top
		// this node will not be a child to any thing
		globalTopOfStack = 0;
		globalParentNodesStack[globalTopOfStack] = newNode;
		globalTopTpTreeNodesArray[globalTopTpTreeNodesArraySize] = newNode;
		globalTopTpTreeNodesArraySize++;
	} else {
		// not a top testplan section, ie. there must be something in the stack
		
		parentRowIndent = globalParentNodesStack[globalTopOfStack].rowDomObj.getAttribute('l');
		
		if (parentRowIndent == newRowIndent) {
			// the top of stack is a sister to the new node
			globalTopOfStack--;											// pop
			globalParentNodesStack[globalTopOfStack].addChild(newNode);
			newNode.parent = globalParentNodesStack[globalTopOfStack]; 
			globalTopOfStack++;                        					// push
			globalParentNodesStack[globalTopOfStack] = newNode;
			
		} else if (parentRowIndent < newRowIndent) {
			// the new node is a child to the top of stack
			globalParentNodesStack[globalTopOfStack].addChild(newNode);
			newNode.parent = globalParentNodesStack[globalTopOfStack];
			globalTopOfStack++;                        					// push
			globalParentNodesStack[globalTopOfStack] = newNode;
			
		} else /* if (parentRowIndent > newRowIndent) */ {
			// The new node is not a child to the top of stack, we will keep pop from stack till
			// reaching the 1st sister to the new node, then put the new node instead of its sister.
			// The action of keeping pop from stack till the 1st sister, can be implemented by
			// directly put the new node in the index of its sister node and make the top of stack
			// pointing to the new node.
			globalTopOfStack = newRowIndent;
			globalParentNodesStack[globalTopOfStack] = newNode;
			globalParentNodesStack[globalTopOfStack-1].addChild(newNode);
			newNode.parent = globalParentNodesStack[globalTopOfStack-1];
		}
	}
}

function buildPage() {
	var tables = document.getElementsByTagName("TABLE");
	var t=0;
	if (tables[0].className.match('noborder')) {
		// ignore the 1st table which is the table for Expand/Collapse buttons
		t = 1;
	}

	var table = tables[t];
	var newRow = table.rows[0];
	
	buildHeaderRow(newRow);
	
	/* build data rows */
	var isExcluded;
	var linkStatus;
	globalTpTreeNodesArray = new Array(table.rows.length);
	for (var r = 1; r < table.rows.length; r++) {
		newRow = table.rows[r];
		
		addIndentationCellsToDataRow(newRow);
		
		isExcluded = newRow.getAttribute('excl');
		linkStatus = newRow.getAttribute('ls');
		
		if (newRow.id.match(/^t\d+_\d+_\d+L\d+Id$/)) {							// link (tagged item) row
			createTreeNodeObjForRow(r, newRow, 1);
			addTaggedItemRow(newRow, isExcluded, linkStatus, r);
		} else if (newRow.id.match(/^t\d+_\d+_\d+L\d+IdFp$/)) {					// full path row
			globalTpTreeNodesArray[r] = 0;						// no tpTreeNode object for a full path row
			addFullPathRow(newRow, isExcluded, linkStatus, r);
		} else { // if (newRow.id.match(/^t\d+_\d+_\d+Id$/)) 					// testplan section row
			createTreeNodeObjForRow(r, newRow, 0);
			addTestplanSectionRow(newRow, isExcluded, linkStatus, r);
		}
	}
	
	//dumpTree(); // commented, it is for debugging purposes only
}

function dumpTree() {
	var preElement = document.createElement("pre");
	preElement.setAttribute("id", "hh");
	document.getElementsByTagName("body")[0].appendChild(preElement);
	
	var nodeObj = globalTpTreeNodesArray[1];
	dumpNode(nodeObj, 0);
}

function dumpNode(nodeObj, level) {
	var preObj = document.getElementById("hh");
	for (var j=0 ; j<level ; j++) {preObj.innerHTML += "\t";}
	preObj.innerHTML += nodeObj.rowDomObj.id + "\n";
	if (nodeObj.childrenCount > 0) {
		level++;
		for (var i=0 ; i<nodeObj.childrenCount ; i++) {
			dumpNode(nodeObj.children[i],level);
		}
		level--;
	}
	
}

buildPage();
