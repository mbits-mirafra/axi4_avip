var g_z_divId;
var g_z_start_date;

function z_createCell(row, type, classt, txt, lnk, tooltip, c_align, colsp) {
	var newCell = document.createElement(type);
	if (colsp) {
		newCell.colSpan = colsp;
	}
	if (classt) {
		newCell.className = classt;
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
	if (tooltip) {
		newCell.setAttribute("title", tooltip);
	}
	row.appendChild(newCell);
	return;
};

function buildSummarySection() {
	g_z_start_date = new Date();
	document.title = g_oCONST.prod + ' Coverage Report';
	urlArgsObj = new UrlParserClass();
	var divId = urlArgsObj.getScopeId();
	var filenum = urlArgsObj.getFileNum();
	var dbnum = urlArgsObj.getDbNum();
	g_z_divId = "z" + divId;
	if (filenum) {
		var headID = document.getElementsByTagName("head")[0];
		var jsonScript = document.createElement('script');
		jsonScript.type = "text/javascript";
		jsonScript.src = "z" + filenum + ".json";
		headID.appendChild(jsonScript);
		// loop on the rest of the rows
	} else {
		var headID = document.getElementsByTagName("head")[0];
		var jsonScript = document.createElement('script');
		jsonScript.type = "text/javascript";
		jsonScript.src = "sdb" + dbnum+".json";
		headID.appendChild(jsonScript);
	}
}

function createPageTop(scopes, prod, report) {
	var head = document.createElement("h1");
	var span = document.createElement("span");
	span.className = "strip";
	span.innerHTML = g_oCONST.prod;
	head.appendChild(span);
	
	var h3;
	if (report == "du") {
		head.innerHTML += " Design Unit Coverage";
		h3 = document.createElement("h3");
		h3.innerHTML = "Design Unit: " + scopes;
	} else {
		head.innerHTML += " Design Coverage";
		h3 = printScopes(scopes, "h3");
	}
	document.body.insertBefore(head, document.getElementById("content"));
	document.body.insertBefore(h3, document.getElementById("content"));
}

function printScopes(scopes, element) {
	var ele = document.createElement(element);
	ele.innerHTML = "Scope: /"
	for (var int = 0; int < scopes.length - 1; int++) {
		var newElement = document.createElement('a');
		if (scopes[int].link) {
			newElement.setAttribute("href", scopes[int].link);
		} else {
			var link = "z.htm?b=" + scopes[int].b+"&s="+scopes[int].s;
			newElement.setAttribute("href", link);
		}
		newElement.innerHTML = scopes[int].val;
		ele.appendChild(newElement);
		ele.innerHTML += "/";
	}
	var newElement = document.createElement('a');
	if (scopes[scopes.length -1].link) {
		newElement.setAttribute("href", scopes[scopes.length - 1].link);
	}
	newElement.innerHTML = scopes[scopes.length - 1].val;
	ele.appendChild(newElement);
	return ele;
}

function makeSummaryView(scopes, dulink) {
	var table = document.createElement("table");
	var body = document.createElement("tbody");
	table.className = "fpw";
	var newRow = document.createElement("tr");
	var cell = document.createElement("td");
	cell.className = "styleNone";
	var div1;
	var div2 = document.createElement("div");
	var span = document.createElement("span");
	span.style.fontSize = "250%";
	span.innerHTML = "Summary";
	div2.appendChild(span);
	if (dulink == 0)
		div1 = printScopes(scopes, "div");
	else {
		div1 = document.createElement("div");
		div1.innerHTML = "Design Unit: " + scopes;
		div1.setAttribute("href", dulink);
	}
	cell.appendChild(div1);
	cell.appendChild(div2);
	newRow.appendChild(cell);
	body.appendChild(newRow);
	table.appendChild(body);
	document.body.insertBefore(table, document.getElementById("content"));

}

function infoPage(scopes, du, lang, src, report) {
	var dl = document.createElement("dl");

	var dt2 = document.createElement("dt");
	var dd2 = document.createElement("dd");
	var b2 = document.createElement("b");

	var dt3 = document.createElement("dt");
	var dd3 = document.createElement("dd");
	var b3 = document.createElement("b");

	var dt4 = document.createElement("dt");
	var dd4 = document.createElement("dd");
	var b4 = document.createElement("b");

	if (du) {
		b2.innerHTML = "Design Unit Name:";
		dt2.appendChild(b2);
		dd2 = document.createElement("dd");
	}
	if (report != "du") {
		var dt1 = document.createElement("dt");
		var dd1 = document.createElement("dd");
		var b1 = document.createElement("b");
		b1.innerHTML = "Instance Path:";
		dt1.appendChild(b1);
		for (var int = 0; int < scopes.length; int++) {
			dd1.innerHTML += "/" + scopes[int].val;
		}
		dl.appendChild(dt1);
		dl.appendChild(dd1);

		if (du) {
			var a1 = document.createElement("a");
			a1.href = du.link;
			a1.innerHTML = du.val;
			dd2.appendChild(a1);
		}
	} else {
		if (du) {
			dd2.innerHTML = du;
		}
	}

	dl.appendChild(dt2);
	dl.appendChild(dd2);

	b3.innerHTML = "Language:";
	dt3.appendChild(b3);
	dl.appendChild(dt3);

	dd3 = document.createElement("dd");
	dd3.innerHTML = lang;
	dl.appendChild(dd3);

	b4.innerHTML = "Source File:";
	dt4.appendChild(b4);
	dl.appendChild(dt4);

	dd4 = document.createElement("dd");
	var a = document.createElement("a");
	a.innerHTML = src.z;
	if (src.lnk)
		a.href = src.lnk;
	dd4.appendChild(a);
	dl.appendChild(dd4);
	document.body.insertBefore(dl, document.getElementById("content"));
	for (var i = 0; i < 4; i++) {
		document.body.insertBefore(document.createElement("br"), document
				.getElementById("content"));
	}
}

function processSummaryData(g_data) {
	createSummaryPage();
}

function processScopesDbFile(g_db_data) {
	var id = g_z_divId.slice(1);
	var filenum = g_db_data[id];
	var headID = document.getElementsByTagName("head")[0];
	var jsonScript = document.createElement('script');
	jsonScript.type = "text/javascript";
	jsonScript.src = "z" + filenum + ".json";
	headID.appendChild(jsonScript);
}

function createSummaryPage (){	
	var data = g_data[g_z_divId];
	if (data) {
		if (data.reporttype != 'du') {
			createPageTop(data.scopes, data.prod, data.reporttype);
			infoPage(data.scopes, data.du, data.lang, data.src, data.reporttype);
		} else {
			createPageTop(data.duname, data.prod, data.reporttype);
			infoPage(data.scopes, data.duname, data.lang, data.src,
					data.reporttype);
		}
	}
	if (data.summaryTables) {	
		if (data.summaryTables.headers) {
			covSummaryByInstance(data.summaryTables, data.reporttype);
		}
		if (data.summaryTables.loctable || data.summaryTables.rectable) {
			covSummaryTables(data.summaryTables, data.reporttype);
		}
	}
    var date = new Date();
    var diff = date - g_z_start_date;
    if (urlArgsObj.getPerf()) {
    console.save(g_z_divId +", " + (diff/1000), "z_console.txt");
    }
}

function printTable(dataArr) {
	var headers = dataArr.headers;
	var table = document.createElement("table");
	table.cellSpacing = "2";
	table.cellPadding = "2";
	var tbody = document.createElement('tbody');
	var newRow = document.createElement("tr");

	z_createCell(newRow, 'Td', 'odd', 'Total Coverage:', 0, 0, 0, 6);
	z_createCell(newRow, 'Td', dataArr.totalhits.class, dataArr.totalhits.val,
			0, 0, 0, 0);
	z_createCell(newRow, 'Td', dataArr.avgw.class, dataArr.avgw.val, 0, 0, 0, 0);
	tbody.appendChild(newRow);
	newRow = document.createElement("tr");
	z_createCell(newRow, 'TH', 0, headers[0], 0, 0, 'left', 2);
	for (var int = 1; int < headers.length; int++) {
		z_createCell(newRow, 'TH', 0, headers[int], 0, 0, 0, 0);
	}
	tbody.appendChild(newRow);
	var objArr = dataArr.data;
	for (var i = 0; i < objArr.length; i++) {
		newRow = document.createElement('tr');
		var instance = objArr[i];
		var name = instance.link.val.split(",")[1];
		var link = instance.link.val.split(",")[0];
		if (!name) {
			name = link;
			link = null;
		} else {
			link = link;
		}
		if (instance.link.indent) {
			z_createCell(newRow, 'TD', 'invisible', '&nbsp;', 0, 0, 0, 0);
			z_createCell(newRow, 'TD', instance.link.class, name, link, 0, 0, 1);
		} else {
			z_createCell(newRow, 'TD', instance.link.class, name, link, 0, 0, 2);
		}
		z_createCell(newRow, 'TD', instance.tb.class, instance.tb.val, 0, 0, 0,
				0);
		z_createCell(newRow, 'TD', instance.cb.class, instance.cb.val, 0, 0, 0,
				0);
		z_createCell(newRow, 'TD', instance.ms.class, instance.ms.val, 0, 0, 0,
				0);
		z_createCell(newRow, 'TD', instance.wt.class, instance.wt.val, 0, 0, 0,
				0);
		z_createCell(newRow, 'TD', instance.hp.class, instance.hp.val, 0, 0, 0,
				0);
		z_createCell(newRow, 'TD', instance.cp.class, instance.cp.val, 0, 0, 0,
				0);
		tbody.appendChild(newRow);
	}
	table.appendChild(tbody);
	return table;
}

function covSummaryTables(dataArr, type) {
	var divObj = document.getElementById("content");

	var table = 0;

	divObj.appendChild(document.createElement("hr"));

	table = document.createElement('table');
	table.id = "loc_rec_tables";
	table.cellSpacing = "5";
	var tbody = document.createElement('tbody');
	var newRow = document.createElement('tr');
	var nRow = document.createElement('tr');
	if (dataArr.loctable) {
		var loc = document.createElement('td');
		var h = document.createElement("h3");
		if(type !="du") {
			h.innerHTML = "Local Instance Coverage Details:";
		}
		else {
			h.innerHTML = "Design Unit Coverage Details:";
		}
		loc.appendChild(h);
		loc.style.verticalAlign = "top";
		var loctable = printTable(dataArr.loctable);
		loc.appendChild(loctable);
		newRow.appendChild(loc);

	}
	if (dataArr.rectable) {
		var rec = document.createElement('td');
		var h = document.createElement("h3");
		h.innerHTML = "Recursive Hierarchical Coverage Details:";
		rec.appendChild(h);
		var rectable = printTable(dataArr.rectable);
		rec.appendChild(rectable);
		newRow.appendChild(rec);
	}
	tbody.appendChild(newRow);
	table.appendChild(tbody);

	divObj.appendChild(table);
}

function covSummaryByInstance(dataArr, type) {
	var divObj = document.getElementById("content");
	var h = document.createElement("h3");
	if(type !="du") {
		h.innerHTML = "Coverage Summary By Instance:";
	}
	else {
		h.innerHTML = "Design Unit Hierarchical Summary:";
	}
	divObj.appendChild(h);
	var table = 0;

	table = document.createElement('table');

	table.cellSpacing = "2";
	table.cellPadding = "2";

	var tbody = document.createElement('tbody');
	var newRow = document.createElement('tr');

	z_createCell(newRow, 'TH', 0, 'Scope', 0, 0, 0, 2);
	z_createCell(newRow, 'TH', 0, 'TOTAL', 0, 0, 0, 0);
	var headers = dataArr.headers;
	for (var int = 0; int < headers.length; int++) {
		z_createCell(newRow, 'TH', 0, headers[int], 0, 0, 0);
	}
	tbody.appendChild(newRow);
	var lastRowOdd = 0;
	objArr = dataArr.instances;
	for (var i = 0; i < objArr.length; i++) {
		newRow = document.createElement('tr');
		var instance = objArr[i];
		if (instance.parent == '1') {
			z_createCell(newRow, 'TD', 'invisible', '&nbsp;', 0, 0, 0, 0);
			z_createCell(newRow, 'TD', 0, instance.ln, instance.link,
					instance.tt, 0, 0);
		} else {
			z_createCell(newRow, 'TD', 0, instance.ln, instance.link,
					instance.tt, 0, 2);
		}

		var values = instance.covs;
		for (var j = 0; j < values.length; j++) {
			z_createCell(newRow, 'TD', values[j].class, values[j].val, 0, 0, 0,
					0);
		}
		tbody.appendChild(newRow);
	}
	table.appendChild(tbody);
	divObj.appendChild(table);
}
