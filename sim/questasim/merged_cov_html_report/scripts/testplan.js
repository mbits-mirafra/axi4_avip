function TpTreeNode(rowObj, areContentsExpanded, isLinkNode) {
	this.childrenCount = 0;
	this.isLinkNode = isLinkNode;
	this.children = []; /* empty array */
	this.parent = 0;
	
	this.areContentsExpanded = areContentsExpanded;
	/* Contents of this tpSection is expanded */
	
	this.contentsLastStateIsExpanded = false;
	/* This variable will hold the last display status before the current
	 * display status.
	 * By display status we mean, tpSection contents is expanded or not
	 * 1: means contents are expanded
	 * 0: means contents are collapsed
	 * 
	 * This variable is important to know the status of subsections of the
	 * current section so that we can restore their status when displaying
	 * contents of the current section
	 */
	
	
	this.rowDomObj = rowObj;
	this.divButtonDomObj = null;	// it will be initialized later while building the html page in buildtestplanpage.js
	
	this.fullPathRowDomObj = null;	// it will be initialized later while building the html page in buildtestplanpage.js
									// notice that this member exists only for a link node that has a long path such that
									// we will put its full path in a separate new row underneath.
};
TpTreeNode.prototype.addChild = function(tpTreeNodeObj) {
	this.children[this.childrenCount] = tpTreeNodeObj;
	this.childrenCount ++;
};
TpTreeNode.prototype.expandNode = function () {
	var i=0;
	if (!this.isLinkNode && this.childrenCount == 0) return;
	if (this.areContentsExpanded) return;
	
	if (this.isLinkNode) {
		if (this.fullPathRowDomObj) {
			this.fullPathRowDomObj.style.display = "table-row";
			this.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
		}
	} else {
		for (i ; i<this.childrenCount ; i++) {
			this.children[i].displayNode();
			if ( this.children[i].contentsLastStateIsExpanded ) {
				this.children[i].expandNode();
			}
		}
		this.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
	}
	
	this.areContentsExpanded = true;
};
TpTreeNode.prototype.collapseNode = function () {
	var i=0;
	if (!this.isLinkNode && this.childrenCount == 0) return;
	if (!this.areContentsExpanded) {
		this.contentsLastStateIsExpanded = false;
		return;
	}
	
	if (this.isLinkNode) {
		if (this.fullPathRowDomObj) {
			this.fullPathRowDomObj.style.display = "none";
			this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
		}
	} else {
		for (i ; i<this.childrenCount ; i++) {
			this.children[i].collapseNode();
			this.children[i].hideNode();
		}
		this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
	}
	
	this.areContentsExpanded = false;
	this.contentsLastStateIsExpanded = true;
};
TpTreeNode.prototype.hideNode = function () {
	this.rowDomObj.style.display = "none";
};
TpTreeNode.prototype.displayNode = function () {
	this.rowDomObj.style.display = "table-row";
};
TpTreeNode.prototype.displayTpSectionsOnly = function () {
	var i;
	var isExpanded = false;
	var isCollapsed = false;
	
	if (!this.isLinkNode && this.childrenCount == 0) return;
	
	for (i=0 ; i<this.childrenCount ; i++) {
		if (this.children[i].isLinkNode) { /* Hide Link nodes */
			this.children[i].collapseNode();
			this.children[i].hideNode();
			isCollapsed = true;
		} else {
			this.children[i].displayNode();
			this.children[i].displayTpSectionsOnly();
			isExpanded = true;
		}
	}
	
	if (isExpanded) {
		this.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
		this.areContentsExpanded = true;
	} else if (isCollapsed) {
		this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
		this.contentsLastStateIsExpanded = false; /* any child node is collapsed */
		this.areContentsExpanded = false;
	}
};
TpTreeNode.prototype.forceCollapse = function () {
	/* 
	 * The difference between this function and collpaseNode() is that this
	 * function will set the previous state of child nodes to be "Collapsed"
	 */
	var i;
	
	if (!this.isLinkNode && this.childrenCount == 0) return;
	
	if (this.isLinkNode) {
		if (this.fullPathRowDomObj) {
			this.fullPathRowDomObj.style.display = "none";
			this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
		}
	} else {
		for (i=0 ; i<this.childrenCount ; i++) {
			this.children[i].hideNode();
			this.children[i].forceCollapse();
		}
		this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
	}
	
	this.areContentsExpanded = false;
	this.contentsLastStateIsExpanded = false;
};
TpTreeNode.prototype.forceExpand = function () {
	/* 
	 * The difference between this function and expandNode() is that this
	 * function will not consider the property TpTreeNode.contentsLastStateIsExpanded
	 * while expanding child nodes.
	 */
	var i;
	var isExpanded = false;
	if (this.isLinkNode) {
		if (this.fullPathRowDomObj) {
			this.fullPathRowDomObj.style.display = "table-row";
			isExpanded = true;
		}
	} else {
		for (i=0 ; i<this.childrenCount ; i++) {
			this.children[i].displayNode();
			this.children[i].forceExpand();
			isExpanded = true;
		}
	}
	
	if (isExpanded) {
		this.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
		this.areContentsExpanded = true;
	}
};

TpTreeNode.prototype.displayTpSectionsAndLinks = function() {
	var i;
	var isExpanded = false;
	if (this.isLinkNode) {
		if (this.fullPathRowDomObj) { /* hide */
			this.fullPathRowDomObj.style.display = "none";
			this.divButtonDomObj.innerHTML = "<img src=\"images/rtr.png\"/>";
			this.areContentsExpanded = false;
		}
	} else {
		for (i=0 ; i<this.childrenCount ; i++) {
			this.children[i].displayNode();
			this.children[i].displayTpSectionsAndLinks();
			isExpanded = true;
		}
	}
	
	if (isExpanded) {
		this.divButtonDomObj.innerHTML = "<img src=\"images/dtr.png\"/>";
		this.areContentsExpanded = true;
	}
};
