var row = document.getElementsByTagName("TT")[0];
for (var i = 0; i<row.childNodes.length -1; i++) {
	var child = row.childNodes[i];
	for (var j = 0; j < child.childNodes.length - 1 ; j++) {
		if (child.childNodes[j].nodeType == 1) {
			child.childNodes[j].innerHTML = child.childNodes[j].innerHTML.replace(/%s%/g,"&nbsp;");
			child.childNodes[j].innerHTML = child.childNodes[j].innerHTML.replace(/%t%/g,"&nbsp;&nbsp;&nbsp;&nbsp;");
		} else if (child.childNodes[j].nodeType == 3) {
			child.childNodes[j].nodeValue = child.childNodes[j].nodeValue.replace(/%s%/g," ");
			child.childNodes[j].nodeValue = child.childNodes[j].nodeValue.replace(/%t%/g,"    ");
		}
	}
}
//this part if for the last child only because it assumes the SCRIPT is another child, and last <br/> may or may not exist
//so we need to stop the loop with different condition
var child = row.childNodes[row.childNodes.length -1];
for (var j = 0; j < child.childNodes.length ; j++) {
	if (child.childNodes[j].nodeName.match(/.*script.*/i) || child.childNodes[j].nodeName.match(/.*br.*/i))
	{		
		continue;
	}
	if (child.childNodes[j].nodeType == 1) {
		child.childNodes[j].innerHTML = child.childNodes[j].innerHTML.replace(/%s%/g,"&nbsp;");
		child.childNodes[j].innerHTML = child.childNodes[j].innerHTML.replace(/%t%/g,"&nbsp;&nbsp;&nbsp;&nbsp;");
	} else if (child.childNodes[j].nodeType == 3) {
			child.childNodes[j].nodeValue = child.childNodes[j].nodeValue.replace(/%s%/g," ");
			child.childNodes[j].nodeValue = child.childNodes[j].nodeValue.replace(/%t%/g,"    ");
		}
}
	
var body = document.getElementsByTagName("BODY")[0];
for (var k = 0; k < 100; k++) {
	var br = document.createElement('BR');
	body.appendChild(br);
}
