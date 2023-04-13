function get_browser_info() {
	var ua = navigator.userAgent, tem, M = ua
			.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)
			|| [];
	if (/trident/i.test(M[1])) {
		tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
		return {
			name : 'IE',
			version : (tem[1] || '')
		};
	}
	if (M[1] === 'Chrome') {
		tem = ua.match(/\bOPR\/(\d+)/)
		if (tem != null) {
			return {
				name : 'Opera',
				version : tem[1]
			};
		}
	}
	M = M[2] ? [ M[1], M[2] ]
			: [ navigator.appName, navigator.appVersion, '-?' ];
	if ((tem = ua.match(/version\/(\d+)/i)) != null) {
		M.splice(1, 1, tem[1]);
	}
	return {
		name : M[0],
		version : M[1]
	};
}

function oldVersion(browser) {
	return ((browser.name == "Chrome" && browser.version < 47)
			|| (browser.name == "Firefox" && browser.version < 43)
			|| (browser.name == "Trident" && browser.version < 11)
			|| (browser.name == "Opera" && browser.version < 34) || (browser.name == "Safari" && browser.version < 5))
}

function drawDiv() {
	var div = document.createElement("div");
	div.style.backgroundColor = "red";
	var browser = get_browser_info();
	if (oldVersion(browser)) {
		div.innerHTML = "The report features might not perform well with your browser version! Kindly Consider upgrading.";
		var span = document.createElement("href");
		span.id = "close";
		span.setAttribute("onclick",
					"this.parentNode.parentNode.removeChild(this.parentNode); return false;");
		span.innerHTML = "x";
		span.style.backgroundColor = "red";
		span.style.position = "absolute";
		span.style.to = 0;
		span.style.right = 0;
		div.appendChild(span);
	}
	
	document.body.insertBefore(div, document.body.firstChild);

};
var d = document;
function document_loaded() {
	drawDiv();
}
d.addEventListener("DOMContentLoaded", document_loaded, false);
