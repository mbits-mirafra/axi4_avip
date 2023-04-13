var g_COVERGROUP_TYPE_PA = 0;		
var g_COVERGROUP_TYPE    = 1;		
var g_COVERGROUP_INST    = 2;		
var g_CVP_PA             = 3;		
var g_CVP                = 4;		
var g_CRX                = 5; 		
var g_COVERGROUP_VIEW    = 6;		
// cvg bin types:		
var g_USER_BIN    = 0;		
var g_DEFAULT_BIN = 1;		
var g_ILLEGAL_BIN = 2;		
var g_IGNORE_BIN  = 3;		
var g_AUTO_BIN    = 4;		
var g_BIN_EXCLUSION_COMMENT_INDEX = 0;		
//Notice that if a bin is excluded with no exclusion comment, then it will		
//have "[]" @ the last cell in its array (i.e. an empty array).		
//But if the bin is excluded with a comment, then it will have		
//"['exclusion comment is here']" at the last cell in its array.		
//This is why exclusion comment will always placed @ index Zero		
var g_CVG_CONS_DATA_FILE_NAME_PREFIX = 'gcons';		
var g_CVG_DATA_FILE_NAME_PREFIX = 'g';		
var g_CVG_BINS_DATA_FILE_NAME_PREFIX = 'gbins';		
var g_TABLE_LENGTH_MENUE = [[10, 25, 50, -1], [10, 25, 50, "All"]];		
var g_TABLE_REASONABLE_LENGTH = 100;		
var g_MAX_NAME_LENGTH = 60;		
var g_MAX_NAME_LENGTH_HALF = 30;		
var g_BINS_COUNT_COL = 'g_bins_count';		
var g_PERCENTAGE_COL = 'g_prcntg';		
var g_LoadDataFp;		
var g_urlArgsObj = 0;		
var g_buildCvgIndexTable_startDate;		
var g_buildtypeInstPage_startDate;		
var g_buildCvpCrxPage_startDate;		
var g_buildCvgViewTable_startDate;		
////////////////<start>parsing url arguments</start> ////////////////		
function CvgUrlParserClass() {		
     this.urlArgs = {};		
     var qs = location.search.substring(1, location.search.length);		
     var args = qs.split('&');		
     var pair;		
     		
     for (var i=0 ; i<args.length ; i++) {		
           pair = args[i].split('=');		
           this.urlArgs[pair[0]] = pair[1];		
     }		
}		
CvgUrlParserClass.prototype.getFileNum = function() {		
     return this.urlArgs.f;		
};		
CvgUrlParserClass.prototype.getScopeId = function() {		
     return this.urlArgs.s;		
};		
CvgUrlParserClass.prototype.getCvgSearch = function() {		
     if (this.urlArgs.cvgSearch) {		
           return this.urlArgs.cvgSearch;		
     } else {		
           return "";		
     }		
};		
//////////////// <end>parsing url arguments</end> ////////////////		
jQuery.extend( jQuery.fn.dataTableExt.oSort, {		
     		
     // g_bins_count considers the case when the cell has '--'. This happens		
     // in some columns with excluded rows		
    'g_bins_count-asc': function ( a, b ) {		
    if ( isNaN( a.charAt(0) ) ) {		
           return 1;		
    } else if ( isNaN( b.charAt(0) ) ) {		
           return -1;		
    } else {		
                var inta = parseInt(a);		
                var intb = parseInt(b);		
           return ((inta < intb)? -1 : ((inta > intb)? 1 : 0));		
    }		
    },		
    'g_bins_count-desc': function ( a, b ) {		
    	if ( isNaN( a.charAt(0) ) ) {		
           return 1;		
    	} else if ( isNaN( b.charAt(0) ) ) {		
           return -1;		
    	} else {		
            var inta = parseInt(a);		
            var intb = parseInt(b);		
            return ((inta < intb)? 1 : ((inta > b)? -1 : 0));		
    	}		
    },		
    		
    // g_prcntg comparator considers the case when the cell has '--'. This happens		
     // in some columns with excluded rows		
    'g_prcntg-asc': function ( a, b ) {		
    if ( isNaN( a.charAt(0) ) ) {		
           return 1;		
    } else if ( isNaN( b.charAt(0) ) ) {		
           return -1;		
    } else {		
           var aa = parseFloat(a);		
           var bb = parseFloat(b);		
           return ((aa < bb)? -1 : ((aa > bb)? 1 : 0));		
    }		
    },		
    'g_prcntg-desc': function ( a, b ) {		
    if ( isNaN( a.charAt(0) ) ) {		
           return 1;		
    } else if ( isNaN( b.charAt(0) ) ) {		
           return -1;		
    } else {		
           var aa = parseFloat(a);		
           var bb = parseFloat(b);		
           return ((aa < bb)? 1 : ((aa > bb)? -1 : 0));		
    }		
    }		
} );		
function getTypeInstHyperlink(fileNum,typeInstId) {		
     return 'gTypeInst.htm?f=' + fileNum +'&s=c' + typeInstId;		
}		
function getCvpCrxHyperlink(fileNum, cvpCrxId) {		
     return 'gBins.htm?f=' + fileNum + '&s=c' + cvpCrxId;		
}		
function oth(scopeId, binId) {		
     window.open('pertest.htm?bin=g'+binId+'&scope='+ scopeId, '_blank', 'scrollbars=1,width=200,height=200');		
}		
function loadCvgDataJsonFile(fileNum, filePrefix) {		
     var headObj = document.getElementsByTagName('head')[0];		
     var scriptObj = document.createElement('script');		
     scriptObj.type = 'text/javascript';		
     scriptObj.src = filePrefix + fileNum + '.json';		
     headObj.appendChild(scriptObj);		
}		
function getTableCell(cellType, cellContent) {		
     // cell type is either td or th		
     var element = document.createElement(cellType);		
     element.innerHTML = cellContent;		
     return element;		
}		
function getTableCellWithClass(cellType, cellContent, cellClass) {		
     var element = getTableCell(cellType, cellContent);		
     element.className = cellClass;		
     return element;		
}		
function getTruncatedCvgTypeInstHyperlinkedName(		
           rowData,		
           dataArrayRowIdx,		
           isHyperlink) {		
     return getTruncatedHyperlinkedName(		
                rowData.name,		
                dataArrayRowIdx,		
                isHyperlink,		
                function () {		
                     return getTypeInstHyperlink(rowData.f, rowData.id);		
                });		
}		
function getCvgTypeInstHyperlinkedName(rowData, dataArrayRowIdx) {		
     var result;		
     if (rowData.name.length > g_MAX_NAME_LENGTH) {		
           /* truncate the name */		
           if (g_oCONST.genDetailsCovergroup) {		
                result = getTruncatedCvgTypeInstHyperlinkedName(		
                           rowData,		
                           dataArrayRowIdx,		
                           true);		
           } else {		
                result = getTruncatedCvgTypeInstHyperlinkedName(		
                           rowData,		
                           dataArrayRowIdx,		
                           false);		
           }		
     } else {		
           if (g_oCONST.genDetailsCovergroup) {		
                result = '<a href="'		
                     + getTypeInstHyperlink(rowData.f, rowData.id)		
                     + '">'		
                     + rowData.name		
                     + '</a>';		
           } else {		
                result = rowData.name;		
           }		
     }		
     return result;		
}		
function getCvgViewHyperlinkedName(rowData, dataArrayRowIdx) {		
     var result;		
     var parentPath = rowData.hdlPath;		
     if (parentPath.length > g_MAX_NAME_LENGTH) {		
           /* truncate parent path */		
           parentPath = parentPath.slice(0, g_MAX_NAME_LENGTH_HALF) + '....'		
                           + parentPath.slice((parentPath.length - g_MAX_NAME_LENGTH_HALF),parentPath.length);		
     } 		
     result = '<a href="g.htm?cvgSearch=cvg:'		
                + rowData.name		
                + '&f='		
                + rowData.f		
                + '&s='		
                + rowData.parent		
                + '">'		
                + parentPath		
                + '/'		
                + rowData.name		
                + '</a>';		
     return result;		
}		
function getHdlScopeHyperlinkedPathH4(hash, path) {		
     var h4, span, a;		
     h4 = document.createElement('h4');		
     span = document.createElement('span');		
     span.className = 'nowrap';		
     span.innerHTML = 'Scope: ';		
     		
     a = document.createElement('a');		
     a.href = 'z' + hash + '.htm#g' + hash;		
     a.innerHTML = path;		
     span.appendChild(a);		
     h4.appendChild(span);		
     h4.style.display = 'inline';		
     return h4;		
}		
function enableLongNameTooltip (spanJQueryDomObj, name) {		
     spanJQueryDomObj.tooltipster({		
           theme: 'tooltipster-light',		
           interactive: true,		
           functionInit: function (origin, content) {		
                var div = document.createElement('div');		
                var span = document.createElement('span');		
                span.innerHTML = "Full Name: ";		
                var input = document.createElement('input');		
                input.setAttribute('readonly', 'readonly');		
                input.setAttribute('type', 'text');		
                input.setAttribute('size', '60');		
                input.setAttribute('value', name);		
                div.appendChild(span);		
                div.appendChild(input);		
                return $(div);		
           }		
     });		
}		
function getCommentSection(commentStr) {		
     var ul, li, h4, cmntDiv;		
     ul = document.createElement('ul');		
     ul.className = 'noList';		
     li = document.createElement('li');		
     h4 = document.createElement('h4');		
     h4.style.display = 'inline';		
     h4.innerHTML = 'Comment:';		
     li.appendChild(h4);		
     ul.appendChild(li);		
     		
     li = document.createElement('li');		
     cmntDiv = document.createElement('div');		
     cmntDiv.innerHTML = commentStr;		
     li.appendChild(cmntDiv);		
     ul.appendChild(li);		
     		
     return ul;		
}		
function enableRowTooltip (imgJQueryDomObj, jsonObj) {		
     // the argument is a JQuery object that holds the DOM object of the row		
     imgJQueryDomObj.tooltipster({		
           theme: 'tooltipster-light',		
           position: 'left',		
           interactive: true,		
           functionInit: function (origin, content) {		
                var bigDiv;		
                		
                bigDiv = document.createElement('div');		
                		
                if (jsonObj.lnk) {		
                     var p = document.createElement('p');		
                     p.innerHTML = '<a href="'		
                           + jsonObj.lnk		
                           +'">Go to src</a>';		
                     bigDiv.appendChild(p);		
                }		
                		
                // notice that we will always have a table, because we always have a goal		
                bigDiv.appendChild(getTooltipTable(jsonObj));		
                		
                // cvps of a cross		
                if (jsonObj.cross) {		
                     bigDiv.appendChild(getDivElementForCrossCvps(jsonObj));		
                }		
                		
                // comment		
                if (jsonObj.cmnt) {		
                     bigDiv.appendChild(		
                                getDivElementForComment('Comment:', jsonObj.cmnt));		
                }		
                		
                // exclusion comment		
                if (jsonObj.xcmnt) {		
                     bigDiv.appendChild(		
                                getDivElementForComment('Exclusion Comment:', jsonObj.xcmnt));		
                }		
                		
                return $(bigDiv);		
           }		
     });		
}		
function getCvgIndexTableConfigObj(jsonObj) {		
     var configObj = {		
           paging : false,		
           info   : false,		
           data   : jsonObj,		
           order  : [[0, 'asc' ]], // initially order the table according to 1st column (name)		
           createdRow: function (rowDomObj, rowData, rowDataIdx) {		
                if (rowData.isX) {		
                     $(rowDomObj).addClass('grayFont');		
                }		
           },		
           columns:		
                [
				{		
                     type        : 'num', // sorting is based on g_oCONST.gBinArrIdx.type		
                     title       : 'ID',		
                     visible     : false,		
                     data        : 'id'		
                },
                {		
                     // name column
                     type     : 'string',
                     title    : 'Covergroups/Instances',		
                     className: 'dt-left nowrap',
                     data     : null,		
                     createdCell : function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).find('.tip').each(function () {		
                                enableRowTooltip($(this), rowData);		
                           });		
                           if (cellData.name.length > g_MAX_NAME_LENGTH) {		
                                $(cellDomObj).find('.truncate').each(function () {		
                                     enableLongNameTooltip($(this), rowData.name);		
                                });		
                           }		
                     },		
                     render   : {
						   sort : function (cellData, type, fullRowJsonObj, meta) {		
                                if (fullRowJsonObj.type == g_COVERGROUP_INST) {
                                    return cellData.cvg;		
                                } else if (fullRowJsonObj.type == g_COVERGROUP_VIEW) {
                                    return fullRowJsonObj.hdlPath + '/' + fullRowJsonObj.name;
                                } else {		
                                    return cellData.name;		
                                }
                           },
                           filter : function (cellData, type, fullRowJsonObj, meta) {		
                                var content;		
                                if (fullRowJsonObj.type == g_COVERGROUP_INST) {		
                                     content = 'inst:' + cellData.name + '#cvg:' + cellData.cvg;		
                                } else if (fullRowJsonObj.type == g_COVERGROUP_TYPE) {		
                                     content = 'cvg:' + cellData.name;		
                                } else if (fullRowJsonObj.type == g_COVERGROUP_VIEW) {		
                                     content = 'cvg:' + cellData.name + '#path:' + fullRowJsonObj.hdlPath + '/' + cellData.name;		
                                } else {		
                                     content = cellData.name;		
                                }		
                                // include these keywords while searching		
                                if (fullRowJsonObj.isX) {		
                                     content += '#excl';		
                                     if (fullRowJsonObj.xcmnt) {		
                                           content += 'comment';		
                                     }		
                                } else if (fullRowJsonObj.cmnt) {		
                                     content += '#comment';		
                                }		
                                return content;		
                           },		
                           display: function (cellData, type, fullRowJsonObj, meta) {		
                                var content;		
                                var tooltip = getTooltipIcon(meta.row);		
                                if (fullRowJsonObj.type == g_COVERGROUP_INST) {		
                                     content =		
                                           '<span class="nested nowrap">'		
                                           + tooltip		
                                           + ' Instance '		
                                           + getCvgTypeInstHyperlinkedName(		
                                                     fullRowJsonObj, meta.row)		
                                           + '</span>';		
                                } else if (fullRowJsonObj.type == g_COVERGROUP_VIEW) {		
                                     // covergroup in the consilidated view		
                                     content = tooltip + ' ' + getCvgViewHyperlinkedName(fullRowJsonObj, meta.row);		
                                } else {		
                                     // covergroup_type or covergroup_type_pa		
                                     content = tooltip + ' ';		
                                     if (fullRowJsonObj.type == g_COVERGROUP_TYPE) {		
                                           content += 'Covergroup ';		
                                     } else {		
                                           //g_COVERGROUP_TYPE_PA		
                                           content += '';		
                                     }		
                                     content +=		
                                           getCvgTypeInstHyperlinkedName(		
                                                     fullRowJsonObj, meta.row);		
                                }		
                                return content;		
                           }		
                     }		
                },		
                {		
                     // total bins column		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Total Bins',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'tb'		
                },		
                {		
                     // hits		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Hits',		
                     searchable: false,		
                     className : 'dt-right',		
                     data      : 'h'		
                },		
                {		
                     // misses		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Misses',		
                     searchable: false,		
                     className : 'dt-right',		
                     data      : 'm'		
                },		
                {		
                     // hit percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Hits %',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'hp'		
                },		
                {		
                     // goal percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Goal %',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'gp.0',		
                     createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).addClass(rowData.gp[1]);		
                     }		
                },		
                {		
                     // coverage percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Coverage %',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'cov.0',		
                     createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).addClass(rowData.cov[1]);		
                     }		
                }		
                ]		
     };		
     		
     if (!(g_oCONST.genDetailsCovergroup)) {		
           /* don't show a column for Goal %. Notice that its index is 4 */		
           configObj.columns.splice(4, 1);		
     }		
     		
     if (jsonObj.length > g_TABLE_REASONABLE_LENGTH) {		
           configObj.paging = true;		
           configObj.info   = true;		
           configObj.deferRender = true;		
           configObj.lengthMenu = g_TABLE_LENGTH_MENUE;		
     }		
     		
     if (g_urlArgsObj) {		
           configObj.oSearch = {'sSearch': g_urlArgsObj.getCvgSearch()};		
     }		
     		
     return configObj;		
}		
function getDivElementForComment(title, comment) {		
     var div, ul, li, cmntDiv;		
     div = document.createElement('div');		
     		
     ul = document.createElement('ul');		
     ul.className = 'noList';		
     li = document.createElement('li');		
     li.className = 'fontBold';		
     li.innerHTML = title;		
     ul.appendChild(li);		
     		
     li = document.createElement('li');		
     		
     cmntDiv = document.createElement('div');		
     if (comment.length > 40) {		
           cmntDiv.className = 'htmlFormatedCmnt';		
           cmntDiv.setAttribute('style', 'width:300px;height:100px;overflow:auto');		
     } else {		
           cmntDiv.setAttribute('style', 'width:200px');		
     }		
     cmntDiv.innerHTML = comment;		
     		
     li.appendChild(cmntDiv);		
     ul.appendChild(li);		
     div.appendChild(ul);		
     return div;		
}		
function getTooltipIcon(rowJsonObjIndex) {		
     return '<img src="../icons/information.png" class="tip handMouse" data-idx="'		
           + rowJsonObjIndex		
           + '"></img> ';		
}		
function getTooltipTable(jsonObj)		
{		
     var table, tr;		
    table = document.createElement('table');		
    		
    tr = document.createElement('tr');		
    tr.appendChild(getTableCell('th', 'Data'));		
    tr.appendChild(getTableCell('th', 'Value'));		
    table.appendChild(tr);		
    		
    // Goal		
    tr = document.createElement('tr');		
    tr.appendChild(getTableCell('td', 'Goal'));		
    tr.appendChild(getTableCell('td', jsonObj.g));		
    table.appendChild(tr);		
    		
    // Goal %		
     if (!(g_oCONST.genDetailsCovergroup)) {		
           /* don't show a column for Goal %. Then add it here */		
           		
         tr = document.createElement('tr');		
         tr.appendChild(getTableCell('td', 'Goal %'));		
         tr.appendChild(getTableCellWithClass('td', jsonObj.gp[0], jsonObj.gp[1]));		
         table.appendChild(tr);		
     }		
    		
    // options value items		
    if (jsonObj.opts) {		
         for(var i=1 ; i<jsonObj.opts.length ; i++) {		
         tr = document.createElement('tr');		
             tr.appendChild(getTableCell('td', jsonObj.opts[i][0]));		
             tr.appendChild(getTableCell('td', jsonObj.opts[i][1]));		
             table.appendChild(tr);		
         }		
    }		
    		
    table.className = 'tableTheme whiteGrayRows';		
    return table;		
}		
function getDivElementForCrossCvps(jsonObj) {		
     var div, ul, li, textArea;		
     div = document.createElement('div');		
     		
     ul = document.createElement('ul');		
     ul.className = 'noList fontBold';		
     li = document.createElement('li');		
     li.innerHTML = 'Coverpoints:';		
     ul.appendChild(li);		
     		
     li = document.createElement('li');		
     textArea = document.createElement('textarea');		
     textArea.setAttribute('readonly', 'readonly');		
     textArea.className = 'cmntTxtbox';		
     		
     for (var i=0 ; i<jsonObj.cross.length ; i++) {		
           textArea.innerHTML += jsonObj.cross[i] + '\n';		
     }		
     		
     li.appendChild(textArea);		
     ul.appendChild(li);		
       		
     div.appendChild(ul);		
     return div;		
}		
function drawCvgViewTable(data) {		
     var body = document.getElementsByTagName('body')[0];		
     var div = document.createElement('div');		
     var cvgTable = document.createElement('table');		
     var config = getCvgIndexTableConfigObj(data);		
     div.setAttribute('style', 'width:800px');		
     config.columns[0].title = "Covergroup";		
     config.stateSave = true;		
     cvgTable.id = 'cvgtable';		
     cvgTable.className = 'tableTheme stripe';		
     div.appendChild(cvgTable);		
     body.appendChild(div);		
     $(cvgTable).DataTable(config);		
     var date = new Date();		
    var diff = date - g_buildCvgViewTable_startDate;		
     if (urlArgsObj.getPerf()){		
         console.save("Covergroups Consolidated View, " + (diff/1000), "buildCvgViewTable_console.txt");		
     }		
}		
function buildCvgViewTable() {		
    g_buildCvgViewTable_startDate = new Date();		
     g_LoadDataFp = function(data) {		
           return drawCvgViewTable(data);		
     };		
     loadCvgDataJsonFile(1, g_CVG_CONS_DATA_FILE_NAME_PREFIX);		
}		
function drawCvgIndexTable(dataArray, scopeId) {		
     var jsonObj = dataArray[scopeId];		
     var table, tbody;		
     g_urlArgsObj = new CvgUrlParserClass();		
     jsonObj.shift();		
     table = document.createElement('table');		
     table.className = 'tableTheme stripe';		
     tbody = document.createElement('tbody');		
     table.appendChild(tbody);		
     document.getElementById("content").appendChild(table);		
     		
     $(table).DataTable(getCvgIndexTableConfigObj(jsonObj));		
     var date = new Date();		
     var diff = date - g_buildCvgIndexTable_startDate;		
     if (urlArgsObj.getPerf()) {		
           console.save(g_urlArgsObj.getScopeId() + ", " + (diff/1000), "buildCvgIndexTable_console.txt");		
     }		
}		
function buildCvgIndexTable() {		
     g_buildCvgIndexTable_startDate = new Date();		
     document.getElementById('content').appendChild(utils_getPageHeaderH1("Covergroup"));		
     urlArgsObj = new UrlParserClass();		
     var scopeId = 'g' + urlArgsObj.getScopeId();		
     var fileNum = urlArgsObj.getFileNum();		
     		
     g_LoadDataFp = function(data) {		
           return drawCvgIndexTable(data, scopeId);		
     };		
     loadCvgDataJsonFile(fileNum, g_CVG_DATA_FILE_NAME_PREFIX);		
}		
function drawCvgTypeInstPageHeader(jsonObj) {		
     var div, h2;		
     var instOrTypeString;		
     		
     div = document.getElementById('titleDiv');		
     		
     if (jsonObj.pHash && jsonObj.pPath) {		
           div.appendChild(		
                     getHdlScopeHyperlinkedPathH4(jsonObj.pHash,		
                                jsonObj.pPath));		
     }		
     		
     h2 = document.createElement('h2'); 		
     if (jsonObj.type == g_COVERGROUP_INST) {		
           instOrTypeString = 'Covergroup instance: ';		
     } else if (jsonObj.type == g_COVERGROUP_TYPE) {		
           instOrTypeString = 'Covergroup type: ';		
     } else { // g_COVERGROUP_TYPE_PA		
           instOrTypeString = '';		
     }		
     h2.innerHTML = instOrTypeString;		
     div.appendChild(h2);		
     		
     h2 = document.createElement('h2');		
     h2.innerHTML = jsonObj.name;		
     div.appendChild(h2);		
     		
     if (jsonObj.cmnt) {		
           div.appendChild(getCommentSection(jsonObj.cmnt));		
     }		
}		
function drawCvgTypeInstTotalsTable(jsonObj) {		
     var table, tr, div;		
     		
     table = document.createElement('table');		
     table.className = 'tableTheme cvpcrs';		
     		
     tr = document.createElement('tr');		
     tr.appendChild(getTableCell('th','Summary'));		
     tr.appendChild(getTableCell('th','Total Bins'));		
     tr.appendChild(getTableCell('th','Hits'));		
     tr.appendChild(getTableCell('th','Hit %'));		
     table.appendChild(tr);		
     		
     tr = document.createElement('tr');		
     tr.appendChild(getTableCell('td','Coverpoints'));		
     tr.appendChild(getTableCell('td',jsonObj.totals[0]));		
     tr.appendChild(getTableCell('td',jsonObj.totals[1]));		
     tr.appendChild(getTableCellWithClass('td',jsonObj.totals[2],jsonObj.totals[3]));		
     table.appendChild(tr);		
     		
     tr = document.createElement('tr');		
     tr.appendChild(getTableCell('td','Crosses'));		
     tr.appendChild(getTableCell('td',jsonObj.totals[4]));		
     tr.appendChild(getTableCell('td',jsonObj.totals[5]));		
     tr.appendChild(getTableCellWithClass('td',jsonObj.totals[6],jsonObj.totals[7]));		
     table.appendChild(tr);		
     		
     div = document.getElementById('cvgTypeInstTotals');		
     div.appendChild(table);		
     div.appendChild(document.createElement('br'));		
}		
function getTruncatedHyperlinkedName(		
           name,		
           dataArrayRowIdx,		
           isHyperlink,		
           fnGetHyperlink) {		
     var newName = name.slice(0, g_MAX_NAME_LENGTH_HALF)		
           + '....'		
           + name.slice(		
                (name.length - g_MAX_NAME_LENGTH_HALF),		
                name.length);		
     		
     var result;		
     if (isHyperlink) {		
           result = '<a class="truncate" data-idx="'		
                + dataArrayRowIdx		
                + '" href="'		
                + fnGetHyperlink()		
                + '">' + newName + '</a>';		
     } else {		
           result = '<span class="truncate" data-idx="'		
                + dataArrayRowIdx		
                + '">' + newName + '</span>';		
     } 		
     return result;		
}		
function getTruncatedCvpCrxHyperlinkedName(		
           rowData,		
           dataArrayRowIdx,		
           isHyperlink) {		
     return getTruncatedHyperlinkedName(		
                rowData.name,		
                dataArrayRowIdx,		
                isHyperlink,		
                function () {		
                     return getCvpCrxHyperlink(rowData.f, rowData.id);		
                });		
}		
function getCvpCrxHyperlinkedName(rowData, dataArrayRowIdx) {		
     var result;		
     if (rowData.name.length > g_MAX_NAME_LENGTH) {		
           if (rowData.hasb || g_oCONST.isPaCov) {		
                result = getTruncatedCvpCrxHyperlinkedName(		
                           rowData, dataArrayRowIdx, true);		
           } else {		
                result = getTruncatedCvpCrxHyperlinkedName(		
                           rowData, dataArrayRowIdx, false);		
           }		
           		
     } else {		
           if (rowData.hasb || g_oCONST.isPaCov) {		
                /* if total bins is larger than 0, then add hyperlink */		
                /* Also if it is PA report, then add the link even if		
                * hasb is 0 or undefined */		
                result = '<a href="'		
                     + getCvpCrxHyperlink(rowData.f, rowData.id)		
                     + '">'		
                     + rowData.name		
                     + '</a>';		
           } else {		
                /* no bins for this cvp/crs */		
                result = rowData.name;		
           }		
     }		
     return result;		
}		
function getCvgTypeInstTableConfigObj(dataArr, nameColTitle) {		
     var configObj = {		
           paging : false,		
           info   : false,		
           order  : [[0, 'asc']],		
           data   : dataArr,		
           createdRow: function (rowDomObj, rowData, rowDataIdx) {		
                if (rowData.isX) {		
                     $(rowDomObj).addClass('grayFont');		
                }		
           },		
           columns:		
                [		
                {		
                     // name column		
                     type     : 'string',		
                     title    : nameColTitle,		
                     className: 'dt-left nowrap',		
                     data     : null,		
                     createdCell : function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).find('.tip').each(function () {		
                                enableRowTooltip($(this), rowData);		
                           });		
                           if (cellData.name.length > g_MAX_NAME_LENGTH) {		
                                $(cellDomObj).find('.truncate').each(function () {		
                                     enableLongNameTooltip($(this), rowData.name);		
                                });		
                           }		
                     },		
                     render   : {
                           sort   : 'name',		
                           filter: function (cellData, type, rowData, meta) {		
                                var content = rowData.name;		
                                		
                                // include these keywords while searching		
                                if (rowData.isX) {		
                                     content += ' Excluded';		
                                }		
                                if (rowData.xcmnt) {		
                                     content += ' Exclusion Comment';		
                                }		
                                if (rowData.cmnt) {		
                                     content += ' Comment';		
                                }		
                                return content;		
                           },		
                           display: function (cellData, type, rowData, meta) {		
                                var tipIcon = getTooltipIcon(meta.row);		
                                return tipIcon + getCvpCrxHyperlinkedName(rowData, meta.row);		
                           }		
                     }		
                },		
                {		
                     // total bins colomn		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Total Bins',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'tb'		
                },		
                {		
                     // hits		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Hits',		
                     searchable: false,		
                     className : 'dt-right',		
                     data      : 'h'		
                },		
                {		
                     // misses		
                     type      : g_BINS_COUNT_COL,		
                     title     : 'Misses',		
                      searchable: false,		
                     className : 'dt-right',		
                     data      : 'm'		
                },		
                {		
                     // hit percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Hit %',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'hp'		
                },		
                {		
                     // goal percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Goal %',		
                     searchable: false,		
                     className : 'dt-right nowrap',		
                     data      : 'gp.0',		
                     createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).addClass(rowData.gp[1]);		
                     }		
                },		
                {		
                     // coverage percentage		
                     type      : g_PERCENTAGE_COL,		
                     title     : 'Coverage %',		
                     searchable: false,		
                     className: 'dt-right nowrap',		
                     data     : 'cov.0',		
                     createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           $(cellDomObj).addClass(rowData.cov[1]);		
                     }		
                }		
                ]		
           		
     };		
     		
     if (!(g_oCONST.genDetailsCovergroup)) {		
           /* don't show a column for Goal %. Notice that its index is 4 */		
           configObj.columns.splice(4, 1);		
     }		
     		
     if (dataArr.length > g_TABLE_REASONABLE_LENGTH) {		
           configObj.paging = true;		
           configObj.info   = true;		
           configObj.deferRender = true;		
           configObj.lengthMenu = g_TABLE_LENGTH_MENUE;		
     }		
     		
     return configObj;		
}		
function drawCvgTypeInstTable(jsonObj, nameColTitle) {		
     var table, tbody;		
     		
     table = document.createElement('table');		
     table.className = 'tableTheme stripe';		
     tbody = document.createElement('tbody');		
     table.appendChild(tbody);		
     document.getElementById('cvgTypeInstTotals').appendChild(table);		
     		
     $(table).DataTable(getCvgTypeInstTableConfigObj(jsonObj, nameColTitle));		
}		
function drawTypeInstPage(dataArray, typeInstScopeId) {		
     var typeInstObj = dataArray[typeInstScopeId];		
     drawCvgTypeInstPageHeader(typeInstObj);		
     drawCvgTypeInstTotalsTable(typeInstObj);		
     typeInstObj.cvp.shift();		
     typeInstObj.crx.shift();		
     if (typeInstObj.cvp.length) {		
           if (typeInstObj.type == g_COVERGROUP_TYPE_PA) {		
                drawCvgTypeInstTable(typeInstObj.cvp, 'Power States');		
           } else {		
                drawCvgTypeInstTable(typeInstObj.cvp, 'CoverPoints');		
           }		
          document.getElementById('cvgTypeInstTotals').appendChild(document.createElement('br'));		
     }		
     if (typeInstObj.crx.length) {		
           if (typeInstObj.type == g_COVERGROUP_TYPE_PA) {		
                drawCvgTypeInstTable(typeInstObj.cvp, 'Power State Crosses');		
           } else {		
                drawCvgTypeInstTable(typeInstObj.crx, 'Crosses');		
           }		
     }		
     var date = new Date();		
    var diff = date - g_buildTypeInstPage_startDate;		
     if (urlArgsObj.getPerf()) {     		
           console.save(g_urlArgsObj.getScopeId() + ", " + (diff/1000), "buildTypeInstPage_console.txt");		
     }		
}		
function buildTypeInstPage() {		
     g_buildTypeInstPage_startDate = new Date();		
     g_urlArgsObj = new CvgUrlParserClass();		
     		
     g_LoadDataFp = function(data) {		
           return drawTypeInstPage(data, g_urlArgsObj.getScopeId());		
     };		
     		
     loadCvgDataJsonFile(g_urlArgsObj.getFileNum(), g_CVG_DATA_FILE_NAME_PREFIX);		
}		
function drawCvpCrxPageHeader(jsonObj) {		
     var div, h2, ul, li, cvpOrCrxString;		
     var cvps = '';		
     		
     div = document.getElementById('titleDiv');		
     		
     /* printing a hyperlink to parent scopes */		
     ul = document.createElement('ul');		
     ul.className = 'noList';		
     if (jsonObj[g_oCONST.gBinObjIdx.hdlHash]) {		
           li = document.createElement('li');		
           li.appendChild(		
                     getHdlScopeHyperlinkedPathH4(jsonObj[g_oCONST.gBinObjIdx.hdlHash],		
                                jsonObj[g_oCONST.gBinObjIdx.hdlPath]));		
           ul.appendChild(li);		
     }		
     if (jsonObj[g_oCONST.gBinObjIdx.parentId]) {		
           var h4, span, a;		
           h4 = document.createElement('h4');		
           span = document.createElement('span');		
           span.className = 'nowrap nested';		
           if (jsonObj[g_oCONST.gBinObjIdx.parentType]		
                     == g_COVERGROUP_TYPE) {		
                span.innerHTML = 'Covergroup type: ';		
           } else if (jsonObj[g_oCONST.gBinObjIdx.parentType]		
                     == g_COVERGROUP_INST){		
                //g_COVERGROUP_INST		
                span.innerHTML = 'Covergroup instance: ';		
           } // else: it is g_COVERGROUP_TYPE_PA		
           		
           a = document.createElement('a');		
           a.href = getTypeInstHyperlink(		
                                jsonObj[g_oCONST.gBinObjIdx.parentFileNum],		
                                jsonObj[g_oCONST.gBinObjIdx.parentId]);		
           a.innerHTML = jsonObj[g_oCONST.gBinObjIdx.parentName];		
           		
           span.appendChild(a);		
           h4.appendChild(span);		
           h4.style.display = 'inline';		
           li = document.createElement('li');		
           li.appendChild(h4);		
           ul.appendChild(li);		
     }		
     div.appendChild(ul);		
     		
     h2 = document.createElement('h2');		
     		
     if (jsonObj[g_oCONST.gBinObjIdx.type] == g_CRX) {		
           var indx;		
           cvpOrCrxString = 'Cross: ';		
           cvps = jsonObj[g_oCONST.gBinObjIdx.cvps][0];		
           for (indx = 1; indx < jsonObj[g_oCONST.gBinObjIdx.cvps].length; ++indx) {		
                cvps += ' , ' + jsonObj[g_oCONST.gBinObjIdx.cvps][indx];		
           }		
     } else if (jsonObj[g_oCONST.gBinObjIdx.type] == g_CVP) {		
           cvpOrCrxString = 'Coverpoint: ';		
     } else { // g_CVP_PA		
           cvpOrCrxString = 'Power State ';		
     }		
     h2.innerHTML = cvpOrCrxString + jsonObj[g_oCONST.gBinObjIdx.name];		
     div.appendChild(h2);		
     		
     if (cvps.length) {		
           var h3 = document.createElement('h3');		
           h3.innerHTML = 'Crossed Coverpoints : ' + cvps;		
           div.appendChild(h3);		
     }		
     		
     /* Adding the comment if any */		
     if (jsonObj[g_oCONST.gBinObjIdx.cmnt]) {		
          div.appendChild(getCommentSection(jsonObj[g_oCONST.gBinObjIdx.cmnt]));		
     }		
}		
function getBinTypeStr(type) {		
     var content;		
     switch (type) {		
     case g_IGNORE_BIN:		
           content = 'ignore_bin';		
           break;		
     case g_ILLEGAL_BIN:		
           content = 'illegal_bin';		
           break;		
     case g_DEFAULT_BIN:		
           content = 'default_bin';		
           break;		
     default: 		
           content = '';		
     }		
     return content;		
}		
function getBinNameCellContent(rowData, dataArrayRowIdx) {		
     return getBinTypeStr(rowData[g_oCONST.gBinArrIdx.type])		
                + ' '		
                + rowData[g_oCONST.gBinArrIdx.name];		
}		
function getCvpCrxBinsTableConfigObj(jsonObj, dataIndx, nameColTitles) {		
     var configObj = {		
           paging : false,		
           info   : false,		
           order  : [[0, 'desc' ]],		
           data: jsonObj[dataIndx],		
           createdRow: function (rowDomObj, rowData, rowDataIdx) {		
                if ( (rowData[g_oCONST.gBinArrIdx.type] == g_IGNORE_BIN)		
                           || (rowData[g_oCONST.gBinArrIdx.type] == g_ILLEGAL_BIN)		
                           || (rowData[g_oCONST.showExcluded]		
                                     && rowData[g_oCONST.gBinArrIdx.isExcluded]) ) {		
                     $(rowDomObj).addClass('grayFont');		
                } 		
           },		
           columns:		
                [		
                {		
                     type        : 'num', // sorting is based on g_oCONST.gBinArrIdx.type		
                     title       : "Bin Type",		
                     visible     : false,		
                     data        : g_oCONST.gBinArrIdx.type		
                },		
                {		
                     type        : 'string', // sorting is based on g_oCONST.gBinArrIdx.type		
                     title       : nameColTitles[0],		
                     className   : 'dt-left nowrap',		
                     data        : g_oCONST.gBinArrIdx.name,		
                     createdCell : function (		
                                cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                           /* check exclusion tooltip */		
                           $(cellDomObj).children('.tip').each(function () {		
                                $(this).tooltipster({		
                                     theme: 'tooltipster-light',		
                                     position: 'right',		
                                     functionInit: function (origin, content) {		
                                           var rowData = jsonObj[$(origin).data('idx')];		
                                           return $(getDivElementForComment(		
                                                     'Exclusion Comment:',		
                                                     rowData[g_oCONST.gBinArrIdx.isExcluded][g_BIN_EXCLUSION_COMMENT_INDEX])		
                                                     );		
                                     }		
                                });		
                           });		
                     },		
                     render: {		
                           filter : function (cellData, type, rowData, meta) {		
                                var content;		
                                content = getBinTypeStr(rowData[g_oCONST.gBinArrIdx.type])		
                                     + ' '		
                                     + rowData[g_oCONST.gBinArrIdx.name];		
                                		
                                if (g_oCONST.showExcluded) {		
                                     if (rowData[g_oCONST.gBinArrIdx.isExcluded]) {		
                                           content += ' Excluded ' + rowData[g_oCONST.gBinArrIdx.h];		
                                           if (rowData[g_oCONST.gBinArrIdx.isExcluded][g_BIN_EXCLUSION_COMMENT_INDEX]) {		
                                                content += ' Exclusion Comment';		
                                           }		
                                     }		
                                }		
                                return content;		
                           }, 		
                           display: function (cellData, type, rowData, meta) {		
                                if (g_oCONST.showExcluded) {		
                                     if (rowData[g_oCONST.gBinArrIdx.isExcluded]) {		
                                           if (rowData[g_oCONST.gBinArrIdx.isExcluded][g_BIN_EXCLUSION_COMMENT_INDEX]) {		
                                                /* has exclusion comment */		
                                                return getTooltipIcon(meta.row)		
                                                     + ' '		
                                                     + getBinNameCellContent(rowData, meta.row);		
                                           }		
                                     }		
                                }		
                                return getBinNameCellContent(rowData, meta.row);		
                           }		
                     }		
                }]};		
     for (var indx = 1; indx < nameColTitles.length; ++indx) {		
           configObj.columns.push(		
                {		
                     // at least column,		
                     type: 'string',		
                     title    : nameColTitles[indx],		
                     className: 'dt-left nowrap',		
                     data: g_oCONST.gBinArrIdx.name + indx,		
                });		
     }		
     configObj.columns.push(		
           {		
                // at least column		
                type     : g_BINS_COUNT_COL,		
                title    : 'At Least',		
                className: 'dt-right nowrap',		
                data: g_oCONST.gBinArrIdx.atLeast,		
           });		
     configObj.columns.push(		
           {		
                // hits column		
                type       : g_BINS_COUNT_COL,		
                title      : 'Hits',		
                className  : 'dt-right',		
                data       : g_oCONST.gBinArrIdx.h,		
                render     : {		
                     display : function (cellData, type, rowData, meta) {		
                           var content;		
                           if (rowData[g_oCONST.gBinArrIdx.tHitBinId]) {		
                                content = '<a href="javascript:void(0);" onclick="oth('		
                                     + '\'' + jsonObj[g_oCONST.gBinObjIdx.hdlHash] + '\','		
                                     + '\'' + rowData[g_oCONST.gBinArrIdx.tHitBinId]		
                                     + '\')">'		
                                     + cellData		
                                     + '</a>';		
                           } else {		
                                content = cellData;		
                           }		
                           return content;		
                     }		
                },		
                createdCell: function (cellDomObj, cellData, rowData, rowIdx, collIdx) {		
                     if (rowData[g_oCONST.gBinArrIdx.isRed]) {		
                           $(cellDomObj).addClass('R');		
                     }		
                }		
           });		
     		
     if (g_oCONST.showBinRHS		
                && (jsonObj[g_oCONST.gBinObjIdx.type] == g_CVP) ) {		
           configObj.columns.push({		
                type      : 'string',		
                title     : 'RHS',		
                className : 'dt-center',		
                data      : g_oCONST.gBinArrIdx.rhs,		
                defaultContent: ''		
           });		
     }		
     		
     if (g_oCONST.timeStamp) {		
           configObj.columns.push({		
                type      : g_PERCENTAGE_COL,		
                title     : 'Covered SimTime',		
                className : 'dt-right nowrap',		
                data      : g_oCONST.gBinArrIdx.tstampV,		
                defaultContent: ''		
           });		
           configObj.columns.push({		
                type      : 'string',		
                title     : 'Covered in Test',		
                className : 'dt-center',		
                data      : g_oCONST.gBinArrIdx.tstampT,		
                defaultContent: ''		
           });		
     }		
     		
     if ((jsonObj[dataIndx]).length > g_TABLE_REASONABLE_LENGTH) {		
           configObj.paging = true;		
           configObj.info   = true;		
           configObj.deferRender = true;		
           configObj.lengthMenu = g_TABLE_LENGTH_MENUE;		
     }		
     		
     return configObj;		
}		
function drawCvpCrxBinsTable(jsonObj, indx, nameColTitles) {		
     var table, tbody;		
     table = document.createElement('table');		
     table.className = 'tableTheme stripe';		
     tbody = document.createElement('tbody');		
     table.appendChild(tbody);		
     document.getElementById('titleDiv').appendChild(table);		
     $(table).DataTable(getCvpCrxBinsTableConfigObj(jsonObj, indx, nameColTitles));		
}		
function drawCvpCrxPage(dataArray, cvpCrxId) {		
     var cvpCrxObj = dataArray[cvpCrxId];		
     drawCvpCrxPageHeader(cvpCrxObj);		
     cvpCrxObj[g_oCONST.gBinObjIdx.binArr].shift();		
     cvpCrxObj[g_oCONST.gBinObjIdx.autoBinArr].shift();		
     for (var indx = 0; indx < cvpCrxObj[g_oCONST.gBinObjIdx.binArr].length;) {		
           if (cvpCrxObj[g_oCONST.gBinObjIdx.binArr][indx][g_oCONST.gBinArrIdx.type] == g_AUTO_BIN) {		
                cvpCrxObj[g_oCONST.gBinObjIdx.autoBinArr].push(cvpCrxObj[g_oCONST.gBinObjIdx.binArr][indx]);		
                cvpCrxObj[g_oCONST.gBinObjIdx.binArr].splice(indx,1);		
           } else {		
                ++indx;		
           }		
     }		
     if (cvpCrxObj[g_oCONST.gBinObjIdx.binArr].length) {		
           drawCvpCrxBinsTable(cvpCrxObj, g_oCONST.gBinObjIdx.binArr, ['Bin Name']);		
          document.getElementById('titleDiv').appendChild(document.createElement('br'));		
     }		
     if (cvpCrxObj[g_oCONST.gBinObjIdx.autoBinArr].length) {		
           drawCvpCrxBinsTable(cvpCrxObj, g_oCONST.gBinObjIdx.autoBinArr, cvpCrxObj[g_oCONST.gBinObjIdx.cvps]);		
     }		
     var date = new Date();		
    var diff = date - g_buildCvpCrxPage_startDate;		
     if (urlArgsObj.getPerf()) {		
         console.save(g_urlArgsObj.getScopeId() + ", " + (diff/1000), "buildCvpCrxPage_console.txt");		
     }		
}		
function buildCvpCrxPage() {		
    g_buildCvpCrxPage_startDate = new Date();		
     g_urlArgsObj = new CvgUrlParserClass();		
     		
     g_LoadDataFp = function(data) {		
           return drawCvpCrxPage(data, g_urlArgsObj.getScopeId());		
     };		
     		
     loadCvgDataJsonFile(g_urlArgsObj.getFileNum(), g_CVG_BINS_DATA_FILE_NAME_PREFIX);		
}		
function processCovergroupsData(dataArray) {		
     g_LoadDataFp(dataArray);		
}		
function processConsCovergroupsData(g_data) {		
     g_data.shift();		
     g_LoadDataFp(g_data);		
}

