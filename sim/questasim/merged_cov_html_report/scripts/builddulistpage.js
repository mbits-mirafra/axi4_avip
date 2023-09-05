var dulist; 
var titlelist;
jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "ducovcol-asc": function ( a, b ) {
	var x, y;
		if ((a[1].charAt(0)=='-') || (a[1].charAt(0)=='E')) {
			x = 101.00;
		} else {
			x = parseFloat(a[1]);
		}
		if ((b[1].charAt(0)=='-') || (b[1].charAt(0)=='E')) {
			y = 101.00
		} else {
			y = parseFloat(b[1]);
		}
		return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    },
 
    "ducovcol-desc": function ( a, b ) {
		var x, y;
		if ((a[1].charAt(0)=='-') || (a[1].charAt(0)=='E')) {
			x = 0.00;
		} else {
			x = parseFloat(a[1]);
		}
		if ((b[1].charAt(0)=='-') || (b[1].charAt(0)=='E')) {
			y = 0.00
		} else {
			y = parseFloat(b[1]);
		}
		return ((x < y) ? 1 : ((x > y) ? -1 : 0));
    }
} );
function getDataTableConfigArr(dataArr, titleArr) {
	var colindx;
	var columns = [];
	var targets = [];
	columns.push({
		title: titleArr[0][0],
		data: titleArr[0][1],
		render: {
			display: function (cellData, type, fullRowJsonObj, meta) {
				if (cellData.length < 4 && cellData[1]) {
					return '<a href="pages/' + cellData[1] + '">' + cellData[0] + '</a>';
				} else {
					return cellData[0];
				}
			},
			filter: function (cellData, type, fullRowJsonObj, meta) {
				return cellData[0];
			}
		},
		createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {
			if (cellData.length < 4)
				$(cellDomObj).attr('title', cellData[2]);
			else
				$(cellDomObj).addClass(cellData[3]);
		}
	});
	for (colindx = 1; colindx < titleArr.length ; colindx++) {
		columns.push({
			title: titleArr[colindx][0],
			data: titleArr[colindx][1],
			render: {
				display: function (cellData, type, fullRowJsonObj, meta) {
					if ((cellData[1].charAt(0) == '-') || (cellData[1].charAt(0) == 'E')) {
						return cellData[1];
					} else {
						return cellData[1] + '%';
					}
				}
			},
			createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {
				$(cellDomObj).addClass(cellData[0]);
            }
		});
		targets.push(colindx);
	}
	return {
		data: dataArr,
		paging:false,
		info:false,
		columnDefs: [
			{ type: 'ducovcol', targets: targets}
		],
		columns: columns
	};
}

function buildDuListTable()
{
        var body = document.getElementsByTagName('body')[0];
        var overall = document.createElement('h3');
        overall.innerHTML = "Overall Design Unit Coverage Summary:";
        body.appendChild(overall);
        var duSumm = document.createElement('table');
        duSumm.className = 'tableTheme stripe';
        body.appendChild(duSumm);
	var summary = getDataTableConfigArr(dusummary, newtitlelist);
        summary.searching = false;
	summary.bSort = false;
        $(duSumm).DataTable(summary);

        body.appendChild(document.createElement('br'));
        body.appendChild(document.createElement('hr'));
        body.appendChild(document.createElement('br'));


        var all = document.createElement('h3');
        all.innerHTML = "Coverage Summary by Design Unit:";
        body.appendChild(all);
        var duTable = document.createElement('table');
        duTable.className = 'tableTheme stripe';
        body.appendChild(duTable);
        $(duTable).DataTable(getDataTableConfigArr(dulist, titlelist));
}
