var RANK_RES_TABLE_LENGTH_MENU = [[25, 50, 100, -1], [25, 50, 100, "All"]];
var GROUP_TABLE_LENGTH_MENU = [[10, 25, 50, -1], [10, 25, 50, "All"]];
function getSummaryTableConfigArr(dataArr) {
	var colConfigArr = [];
	colConfigArr.push({
		title: 'Parameter',
		data: 0
	});
	colConfigArr.push({
		title: 'Value',
		data: 1,
		className: 'right'
	});
	return {
		data: dataArr,
		paging: false,
		info: false,
		searching: false,
		ordering: false,
		columns: colConfigArr
	};
}

function getGroupTableConfigArr(dataArr,titleArr) {
	var configObj = {};
	var colIndx;
	var colConfigArr = [];
	colConfigArr.push( {
			title: titleArr[0][0],
			data: titleArr[0][1],
			className: titleArr[0][2],
			searchable: true,
			render: {
				filter: function (cellData, type, fullRowJsonObj, meta) {
					return fullRowJsonObj[titleArr[0][1]];
				}
			}
	} );
	for(colIndx = 1; colIndx < titleArr.length; ++colIndx) {
		colConfigArr.push( {
			title: titleArr[colIndx][0],
			data: titleArr[colIndx][1],
			className: titleArr[colIndx][2],
			searchable: false,
			defaultContent: '-'
		} );
	}
	configObj = {
		data: dataArr,
		searching: true,
		ordering: false,
		createdRow: function (rowDomObj, rowData, rowDataIdx) {
			if (rowData.cl) {
				$(rowDomObj).addClass(rowData.cl);
			}
		},
		columns: colConfigArr
	};
	if (dataArr.length > 10) {
		configObj.paging = true;
		configObj.info = true;
		configObj.deferRender = true;
		configObj.lengthMenu = GROUP_TABLE_LENGTH_MENU;
	} else {
		configObj.paging = false;
		configObj.info = false;
		configObj.deferRender = false;
	}
	return configObj;
}

function getResultTableConfigArr(dataArr,titleArr) {
	var configObj = {};
	var colIndx;
	var colConfigArr = [];
	colConfigArr.push( {
			title: titleArr[0][0],
			data: titleArr[0][1],
			className: titleArr[0][2],
			searchable: true,
			render: {
				filter: function (cellData, type, fullRowJsonObj, meta) {
					var content = searchConfig[0][0] + ':' + fullRowJsonObj[searchConfig[0][1]];
					for (colIndx = 1; colIndx < searchConfig.length; ++colIndx) {
						content += '#' + searchConfig[colIndx][0] + ':' + fullRowJsonObj[searchConfig[colIndx][1]];
					}
					return content;
				}
			}
	} );
	for(colIndx = 1; colIndx < titleArr.length; ++colIndx) {
		colConfigArr.push( {
			title: titleArr[colIndx][0],
			data: titleArr[colIndx][1],
			className: titleArr[colIndx][2],
			searchable: false,
			defaultContent: '-'
		} );
	}
	configObj = {
		data: dataArr,
		searching: true,
		ordering: false,
		createdRow: function (rowDomObj, rowData, rowDataIdx) {
			if (rowData.cl) {
				$(rowDomObj).addClass(rowData.cl);
			}
		},
		columns: colConfigArr
	};
	if (usePaging == true) {
		configObj.paging = true;
		configObj.info = true;
		configObj.deferRender = true;
		configObj.lengthMenu = RANK_RES_TABLE_LENGTH_MENU;
	} else {
		configObj.paging = false;
		configObj.info = false;
		configObj.deferRender = false;
	}
	return configObj;
}

function addSepLine() {
	return document.createElement('hr');
}

function createHeader(title) {
	var header = document.createElement('h2');
	header.innerHTML = title;
	header.className = 'rankBlockHeader';
	return header;
}

function buildRankSummarySec() {
	var sumSecDiv = document.createElement('div');
	var table = document.createElement('table');
	var row = document.createElement('tr');
	sumSecDiv.appendChild(createHeader('Ranking Summary'));
	if (typeof(rankSummary) != 'undefined') {
		var tableCell = document.createElement('td');
		tableCell.className = 'sumTableTd';
		tableCell.appendChild(buildRankSummaryTable());
		row.appendChild(tableCell);
	}
	if (typeof(contPieData) != 'undefined') {
		var pieCell = document.createElement('td');
		var legendCell = document.createElement('td');
		pieCell.className = 'sumChartTd';
		legendCell.className = 'sumLegendTd';
		pieCell.appendChild(buildContPieChart());
		legendCell.appendChild(buildContPieChartLegend());
		row.appendChild(pieCell);
		row.appendChild(legendCell);
		buildContPieChart();
	}
	table.appendChild(row);
	sumSecDiv.appendChild(table);
	return sumSecDiv;
}

function buildRankSummaryTable() {
	var sumDiv = document.createElement('div');
	var rankSummaryTable = document.createElement('table');
	sumDiv.id = 'sum';
	sumDiv.className = 'sumTableDiv';
	rankSummaryTable.className = 'tableTheme stripe';
	sumDiv.appendChild(rankSummaryTable);
	$(rankSummaryTable).DataTable(getSummaryTableConfigArr(rankSummary));
	return sumDiv;
}
function buildContPieChart() {
	var pieDiv = document.createElement('div');
	var pieCanvas = document.createElement('canvas');
	pieCanvas.setAttribute('height','300');
	pieCanvas.setAttribute('width','300');
	var pieContext = pieCanvas.getContext('2d');
	var pieChart = new Chart(pieContext).Pie(contPieData);
	pieDiv.id = 'contPie';
	pieCanvas.id = 'contPieCanvas';
	pieDiv.appendChild(pieCanvas);
	return pieDiv;
}
function addLegendRow(color, text) {
	var row = document.createElement('tr');
	var colCell = document.createElement('td');
	var txtCell = document.createElement('td');
	var span = document.createElement('span');
	colCell.style.backgroundColor = color;
	span.className = 'legendSpan';
	span.innerHTML = ' ';
	txtCell.innerHTML = text;
	colCell.appendChild(span);
	row.appendChild(colCell);
	row.appendChild(txtCell);
	return row;
}
function buildContPieChartLegend() {
	var table = document.createElement('tr');
	for (var indx in contPieData) {
		table.appendChild(addLegendRow(contPieData[indx].color, contPieData[indx].label));
	}
	return table;
}
function buildCovChartSec() {
	var secDiv = document.createElement('div');
	var covTable = document.createElement('table');
	var topRow = document.createElement('tr');
	var verAxisCell = document.createElement('td');
	var chartCell = document.createElement('td');
	var bottomRow = document.createElement('tr');
	var horAxisCell = document.createElement('td');
	secDiv.id = 'covSecDiv';
	verAxisCell.innerHTML = covChartData.verlabel;
	verAxisCell.className = 'verAxisTd';
	horAxisCell.innerHTML = covChartData.horlabel;
	horAxisCell.className = 'horAxisTd';
	chartCell.appendChild(buildCovChart());
	bottomRow.appendChild(document.createElement('td'));
	bottomRow.appendChild(horAxisCell);
	topRow.appendChild(verAxisCell);
	topRow.appendChild(chartCell);
	covTable.appendChild(topRow);
	covTable.appendChild(bottomRow);
	secDiv.appendChild(createHeader('Total Coverage Chart'));
	secDiv.appendChild(covTable);
	return secDiv;
}
function buildCovChart() {
	var chartDiv = document.createElement('div');
	var chartCanvas = document.createElement('canvas');
	chartCanvas.setAttribute('height','500');
	chartCanvas.setAttribute('width','800');
	var chartContext = chartCanvas.getContext('2d');
	var chartChart = new Chart(chartContext).Line(covChartData, {
		showXLabels: 50
	});
	chartDiv.id = 'covChart';
	chartCanvas.id = 'covChartCanvas';
	chartDiv.appendChild(chartCanvas);
	return chartDiv;
}
function buildGroupSummaryTable() {
	var groupDiv = document.createElement('div');
	var tableDiv = document.createElement('div');
	var groupTable = document.createElement('table');
	groupDiv.id = 'gSum';
	groupDiv.className = 'rankdiv';
	tableDiv.id = 'gTableDiv';
	tableDiv.className = 'rankTableDiv';
	groupTable.className = 'tableTheme';
	tableDiv.appendChild(groupTable);
	groupDiv.appendChild(createHeader('Group Summary'));
	groupDiv.appendChild(tableDiv);
	$(groupTable).DataTable(getGroupTableConfigArr(groupSummary,groupSummaryTitle));
	return groupDiv;
}
function buildRankResTable() {
	var resDiv = document.createElement('div');
	var tableDiv = document.createElement('div');
	var rankResTable = document.createElement('table');
	resDiv.id = 'res';
	resDiv.className = 'rankdiv';
	tableDiv.id = 'resTableDiv';
	tableDiv.className = 'rankTableDiv';
	rankResTable.className = 'tableTheme';
	tableDiv.appendChild(rankResTable);
	resDiv.appendChild(createHeader('Ranktest Results'));
	resDiv.appendChild(tableDiv);
	$(rankResTable).DataTable(getResultTableConfigArr(rankResults,rankResTitles));
	return resDiv;
}
function buildfooter() {
	var footerDiv = document.createElement('div');
	footerDiv.innerHTML = footer;
	return footerDiv;
}
function buildRankPage() {
	var body = document.getElementsByTagName('body')[0];
	body.appendChild(buildRankSummarySec());
	if (typeof(covChartData) != 'undefined') {
		body.appendChild(buildCovChartSec());
	}
	if (typeof(groupSummary) != 'undefined') {
		body.appendChild(buildGroupSummaryTable());
	}
	if (typeof(rankResults) != 'undefined') {
		body.appendChild(buildRankResTable());
	}
	if (typeof(footer) != 'undefined') {
		body.appendChild(addSepLine());
		body.appendChild(buildfooter());
	}
}
