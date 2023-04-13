/*
 * JavaScript tree widget
 */

function Node(id, pid, idx, text, url, popup, icon, title, open, nodeClass,selectClass) {
	this.id          = id;             // node ID
	this.pid         = pid;            // parent ID
	this.idx         = idx;            // index into aNodes
	this.text        = text;           // node text
	this.url         = url;            // linked URL
	this.popup       = popup;          // link popup text
	this.icon        = icon;           // icon to display
	this.title       = title;          // icon title (Verilog/VHDL)
	this.indent      = '';             // child indentation pattern
	this.isOpen      = open || false;  // true = node is opened
	this.lastChild   = 0;              // index of last child
	this.isRendered  = false;          // true = node HTML generated
	this.isSelected  = false;          // true = node is selected
	this.hasChildren = false;          // true = node is parent
	this.isLastChild = false;          // true = node is last child
	this.selectClass = selectClass;	   // the class of the node when it is selected	
	this.aClass      = nodeClass;     // the class of the node when it is not selected
};

function Tree(tree, incr) {
	this.config = {
		target       : 'text',         // target of href links
		useIcons     :  true,          // true = show node icons
		useLines     :  true,          // true = show tree lines
		useIncrRend  :  incr || true,  // true = incremental rendering
		useSelection :  true           // true = show selection
	}
	this.icon = {                      // list of icons used
		blank        : '../icons/blank.png',
		vline        : '../icons/vline.png',
		join         : '../icons/join.png',
		joinLast     : '../icons/join-last.png',
		plus         : '../icons/plus.png',
		plusLast     : '../icons/plus-last.png',
		plusNolines  : '../icons/plus-nolines.png',
		minus        : '../icons/minus.png',
		minusLast    : '../icons/minus-last.png',
		minusNolines : '../icons/minus-nolines.png'
	};
	this.tree         = tree;              // name of tree (in case there's more than one)
	this.aNodes       = [];                // array of nodes (in order, parents before children)
	this.aNodes[0]    = new Node(0, 0, 0); // node zero is root of tree
	this.treeDrawn    = false;             // true = tree has been drawn
	this.selectedNode = null;
};

/*
 * Return number of nodes in tree (not counting the root)
 */
Tree.prototype.length = function() {
	return(this.aNodes.length - 1);
};

/*
 * Set node's "hasChildren" and "isLastChild" flags
 */
Tree.prototype.analyze = function(node) {
	var papa = this.aNodes[node.pid];
	if (papa.hasChildren == true) {
		this.aNodes[papa.lastChild].isLastChild = false;
	}
	papa.hasChildren = true;     /* my parent has a child...  */
	node.isLastChild = true;     /* ...I'm the last child...  */
	papa.lastChild   = node.idx; /* ...and my parent knows me */
};

/*
 * Add new node to tree (API function)
 */
Tree.prototype.add = function(id, pid, text, url, popup, icon, title, open, nodeClass,selectClass) {
	if (this.treeDrawn == false) { // don't accept new nodes once the tree has been drawn
		var idx = this.aNodes.length; // assign next available slot in aNodes array
		this.aNodes[idx] = new Node(id, pid, idx, text, url, popup, icon, title, open, nodeClass,selectClass);
		this.analyze(this.aNodes[idx]); /* maintain "hasChildren" and "isListChild" */
	}
};

/*
 * Open all nodes (API function)
 */
Tree.prototype.openAll = function() {
	this.setOpenStatusAll(true);
};

/*
 * Close all nodes (API function)
 */
Tree.prototype.closeAll = function() {
	this.setOpenStatusAll(false);
};

/*
 * Indent tree nodes using empty/line icons (don't call this on the root node)
 */
Tree.prototype.indent = function(node, idx, indent) {
	var str = '';
	for (var i = 0; i < indent.length; i++) {
		str += '<img src="' + ((this.config.useLines && (indent.charAt(i) == '1')) ? this.icon.vline
		                                                                           : this.icon.blank);
		str +=    '" alt="" />';
	}
	if (node.hasChildren) {
		str += '<a href="javascript: ' + this.tree + '.o(' + idx + ');"';
		str += ' onmouseover="window.status=\'Toggle node open/closed\'; return true;"';
		str += ' onmouseout="window.status=\'\'; return true;">';
		str += '<img id="j' + this.tree + idx + '" src="';
		if (this.config.useLines) {
			str += (node.isOpen ? (node.isLastChild ? this.icon.minusLast : this.icon.minus)
			                    : (node.isLastChild ? this.icon.plusLast  : this.icon.plus));
		}
		else {
			str += (node.isOpen ? this.icon.minus-nolines
			                    : this.icon.plus-nolines);
		}
		str += '" alt="" /></a>';
	}
	else {
		str += '<img src="' + (this.config.useLines ? (node.isLastChild ? this.icon.joinLast : this.icon.join)
		                                            : this.icon.blank);
		str +=    '" alt="" />';
	}
	return str;
};

/*
 * Create the html for a single node
 */
Tree.prototype.toHtml = function(node, idx, indent) {
	var str = '<div class="mtiTreeNode">' + this.indent(node, idx, indent);

	if (node.url) {
		str += '<a id="s' + this.tree + idx + '"';
		str += ' class="' + ((this.config.useSelection && node.isSelected) ? node.selectClass : node.aClass) + ' underlineNode"';
		str += ' href="' + node.url + '"';
		if (node.popup) str += ' title="' + node.popup + '"';
		if (this.config.target) str += ' target="' + this.config.target + '"';
		if (this.config.useSelection) str += ' onclick="javascript: ' + this.tree + '.s(' + idx + ');"';
		str += '>';
	}
	else if (node.hasChildren && (node.pid > 0)) {
		str += '<a class="node"';
		if (node.popup) str += ' title="' + node.popup + '"';
		str += ' onmouseover="window.status=\'Open this node\'; return true;"';
		str += ' onmouseout="window.status=\'\'; return true;">';
	}
	else /* manhole(JLL): node class should be passed into table */ {
		str += '<span class="darknode">';
	}
	if (this.config.useIcons && node.icon) {
		str += '<img id="i' + this.tree + idx + '" src="' + node.icon + '" title="' + node.title + '" alt="icon" />';
	}
	str += node.text;
	if (node.url || (node.hasChildren && (node.pid > 0))) {
		str += '</a>';
	}
	else {
		str += '</span>';
	}
	str += '</div>';
	if (node.hasChildren) {
		node.indent = indent + (node.isLastChild ? '0' : '1');

		str += '<div id="d' + this.tree + idx + '" class="clip"';
		str += ' style="display:' + (node.isOpen ? 'block' : 'none') + ';">';

		/* possibly defer recursion until [+] is clicked */
		if (this.config.useIncrRend == false) {
			str += this.subTree(node);
		}
		str += '</div>';
	}
	return str;
};

/*
 * No longer needed, as the analysis is now done as the list is built
 */
Tree.prototype.analyzeAll = function() {
	if (this.treeDrawn == false) {
		for (var idx = 1; idx < this.aNodes.length; idx++) {
			this.analyze(this.aNodes[idx]);
		}
		this.treeDrawn = true; // lock out addition of new nodes after analysis
	}
};

/*
 * Recursively generate the tree structure
 */
Tree.prototype.subTree = function(pNode) {
	var str = '';
	for (var idx = pNode.idx + 1; idx < this.aNodes.length; idx++) {
		if (this.aNodes[idx].pid == pNode.id) {
			var node = this.aNodes[idx];
			if (idx == this.selectedNode) {
				node.isSelected = true;
			}
			str += this.toHtml(node, idx, pNode.indent);
			if (node.isLastChild) break;
		}
	}
	pNode.isRendered = true;
	return str;
};

/*
 * Generate string for entire tree (API function -- outputs tree to page)
 */
Tree.prototype.toString = function() {
	var str = '<div class="mtitree">\n';
	if (this.treeDrawn == false) this.analyzeAll();
	if (document.getElementById) str += this.subTree(this.aNodes[0]);
	else                         str += '<h1>Browser not supported.<h1>';
	if (str == '<div class="mtitree">\n') {
		str += '<span class="darknode">&nbsp;-No items in this menu...</span>';
	}
	return str + '</div>';
};

Tree.prototype.drawTreeTo = function(pane) {
	if (this.treeDrawn == false) pane.innerHTML = this.toString();
};

/*
 * Set node's open/closed status
 */
Tree.prototype.setOpenStatus = function(node, open) {
	node.isOpen = open;
	/* find the +/- icon and replace it */
	join = document.getElementById('j' + this.tree + node.idx);
	if (join) {
		join.src = this.config.useLines ? (node.isOpen ? (node.isLastChild ? this.icon.minusLast
		                                                                   : this.icon.minus)
		                                               : (node.isLastChild ? this.icon.plusLast
		                                                                   : this.icon.plus))
		                                : (node.isOpen ? this.icon.minus-nolines
		                                               : this.icon.plus-nolines);
	}
	/* find the block representing the children and show/hide it */
	div = document.getElementById('d' + this.tree + node.idx);
	if (div) {
		if (this.config.useIncrRend && (node.isRendered == false)) {
			/* indent as if called recursively during initial generation */
			div.innerHTML = this.subTree(node);
		}
		div.style.display = node.isOpen ? 'block': 'none';
	}
};

/*
 * Open/close all nodes (except the root node, which is not visible)
 */
var globalIndex = 1;
var drawingInternalId;
var globalLength;
var globalTree;
var globalOpenClose;
var GLBL_NUM_OF_NODES_PER_INTERVAL = 200;
var GLBL_INTERVAL_LENGTH = 400; // the interval will be executed every 400 milli seconds

/* This function will draw GLBL_NUM_OF_NODES_PER_INTERVAL nodes and exist */
function drawSomeNodes(isOpen) {
	var idx,  cnt;
	for (idx = globalIndex, cnt = 0; (idx < globalLength) && (cnt < GLBL_NUM_OF_NODES_PER_INTERVAL); idx++, cnt++) {
		if (globalTree.aNodes[idx].hasChildren) {
			globalTree.setOpenStatus(globalTree.aNodes[idx], isOpen);
		}
	}
	globalIndex = idx;
	if (globalIndex >= globalLength) {
		globalIndex = 1;
		clearInterval(drawingInternalId);
	}
}

Tree.prototype.setOpenStatusAll = function(isOpen) {
	var length = this.aNodes.length;
	globalLength = length;
	globalTree = this;
	drawingInternalId = setInterval(function(){ drawSomeNodes(isOpen) }, GLBL_INTERVAL_LENGTH);
};

/*
 * Toggle node's open/closed status (called from tree elements, uses index into array)
 */
Tree.prototype.o = function(idx) {
	this.setOpenStatus(this.aNodes[idx], (this.aNodes[idx].isOpen ? false : true)); // toggle node status
};

/*
 * Select and highlight node (called from tree elements, uses index into array)
 */
Tree.prototype.s = function(idx) {
	if (this.config.useSelection && (this.selectedNode != idx)) {
		if (this.selectedNode != null) {
			document.getElementById("s" + this.tree + this.selectedNode).className = this.aNodes[this.selectedNode].aClass;
		}
		document.getElementById("s" + this.tree + idx).className = this.aNodes[idx].selectClass;
	}
	this.selectedNode = idx;
};

/*
 * Array push (in case it's not already implemented in browser)
 */
if (!Array.prototype.push) {
	Array.prototype.push = function array_push() {
		for(var arg = 0; arg < arguments.length; arg++) {
			this[this.length] = arguments[arg];
		}
		return this.length;
	}
};

/*
 * Array pop (in case it's not already implemented in browser)
 */
if (!Array.prototype.pop) {
	Array.prototype.pop = function array_pop() {
		lastElement = null;
		if (this.length > 0) {
			lastElement = this[this.length - 1];
			this.length = this.length - 1;
		}
		return lastElement;
	}
};
