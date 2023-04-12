var newWindow = null;

function addEvent(elm, evType, fn, useCapture){
	if(elm.addEventListener){
		elm.addEventListener(evType, fn, useCapture);
		return true;
	}else if (elm.attachEvent){
		var r = elm.attachEvent('on' + evType, fn);
		return r;
	}else{
		elm['on' + evType] = fn;
	}
}

function closeWin(){
	if (newWindow != null){
		if(!newWindow.closed){
			newWindow.close();
		}
	}
}

function popUpWin(url, strWidth, strHeight){
	
	closeWin();
	var tools = "resizable,toolbar=no,location=no,scrollbars=yes,width="+strWidth+",height="+strHeight+",left=0,top=0";
	newWindow = window.open(url, 'newWin', tools);
	newWindow.focus();
}

function doPopUp(e)
{
	//set defaults - if nothing in rel attrib, these will be used
	var w = "400";
	var h = "400";
	
	//look for parameters
	var attribs = this.rel.split(" ");
	if (attribs[1]!='undefined') {w = attribs[1];} // width
	if (attribs[2]!='undefined') {h = attribs[2];} // height
	
	//call the popup script
	popUpWin(this.href,w,h);
	
	//cancel the default link action if pop-up activated
	if (window.event){
		window.event.returnValue = false;
		window.event.cancelBubble = true;
	}else if (e){
		e.stopPropagation();
		e.preventDefault();
	}
}

function findPopUps()
{
	var popups = document.getElementsByTagName("a");
	for (i=0;i<popups.length;i++)
	{
		if (popups[i].rel.indexOf("popup")!=-1)
		{
			// attach popup behaviour
			popups[i].onclick = doPopUp;
		}
	}
}

addEvent(window, 'load', findPopUps, false);
