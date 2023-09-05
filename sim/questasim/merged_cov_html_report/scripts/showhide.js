/*
 * JavaScript functions for show/hide functionality
 *
 *   showAll makes all marked elements visible
 *   showCov makes 'covered' elements visible
 *   showMis makes 'missing' elements visible
 *
 * Note: Unmarked elements are always visible. Elements marked
 *       as 'neutral' are only visible if all elements are set
 *       visible ('tr' elements only).
 */

function showAll()
{
	var x = document.getElementsByTagName('div');
	for (var i = 0; i < x.length; i++)
	{
		if (x[i].className == 'covered') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
		}
		if (x[i].className == 'missing') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
		}
		if (x[i].className == 'excluded') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
		}
	}
	var y = document.getElementsByTagName('tr');
	for (var i = 0; i < y.length; i++)
	{
		if (y[i].className == 'covered') y[i].style.display = '';
		if (y[i].className == 'missing') y[i].style.display = '';
		if (y[i].className == 'neutral') y[i].style.display = '';
		if (y[i].className == 'excluded') y[i].style.display = '';
	}
	var tables = document.getElementsByClassName('buttons');
	for (var i = 0 ; i < tables.length ; i++) {
		var tds = tables[i].getElementsByTagName('td');
		for (var j = 0; j < tds.length ; j++) {
			if (tds[j].id == 'showAll') {
				tds[j].className = 'button_on';
			} else {
				tds[j].className = 'button_off';
			}
		}
	}

	document.cookie = 'showhide=showAll';
}

function showCov()
{
	var x = document.getElementsByTagName('div');
	for (var i = 0; i < x.length; i++)
	{
		if (x[i].className == 'covered') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
		}
		if (x[i].className == 'missing') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
		if (x[i].className == 'excluded') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
	}
	var y = document.getElementsByTagName('tr');
	for (var i = 0; i < y.length; i++)
	{
		if (y[i].className == 'covered') y[i].style.display = '';
		if (y[i].className == 'missing') y[i].style.display = 'none';
		if (y[i].className == 'neutral') y[i].style.display = 'none';
		if (y[i].className == 'excluded') y[i].style.display = 'none';
	}
	var tables = document.getElementsByClassName('buttons');
	for (var i = 0 ; i < tables.length ; i++) {
		var tds = tables[i].getElementsByTagName('td');
		for (var j = 0; j < tds.length ; j++) {
			if (tds[j].id == 'showCov') {
				tds[j].className = 'button_on';
			} else {
				tds[j].className = 'button_off';
			}
		}
	}

	document.cookie = 'showhide=showCov';
}

function showMis()
{
	var x = document.getElementsByTagName('div');
	for (var i = 0; i < x.length; i++)
	{
		if (x[i].className == 'covered') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
		if (x[i].className == 'missing') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
			j++;
		}
		if (x[i].className == 'excluded') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
	}
	var y = document.getElementsByTagName('tr');
	for (var i = 0; i < y.length; i++)
	{
		if (y[i].className == 'missing') y[i].style.display = '';
		if (y[i].className == 'covered') y[i].style.display = 'none';
		if (y[i].className == 'neutral') y[i].style.display = 'none';
		if (y[i].className == 'excluded') y[i].style.display = 'none';
	}
	var tables = document.getElementsByClassName('buttons');
	for (var i = 0 ; i < tables.length ; i++) {
		var tds = tables[i].getElementsByTagName('td');
		for (var j = 0; j < tds.length ; j++) {
			if (tds[j].id == 'showMis') {
				tds[j].className = 'button_on';
			} else {
				tds[j].className = 'button_off';
			}
		}
	}

	document.cookie = 'showhide=showMis';
}

function showExcl()
{
	var x = document.getElementsByTagName('div');
	for (var i = 0; i < x.length; i++)
	{
		if (x[i].className == 'missing') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
		if (x[i].className == 'covered') {
			x[i].style.display = 'none';
			x[i].previousSibling.style.visibility = 'hidden';
		}
		if (x[i].className == 'excluded') {
			x[i].style.display = 'block';
			x[i].previousSibling.style.visibility = '';
		}
	}
	var y = document.getElementsByTagName('tr');
	for (var i = 0; i < y.length; i++)
	{
		if (y[i].className == 'missing') y[i].style.display = 'none';
		if (y[i].className == 'covered') y[i].style.display = 'none';
		if (y[i].className == 'neutral') y[i].style.display = 'none';
		if (y[i].className == 'excluded') y[i].style.display = '';
	}
	var tables = document.getElementsByClassName('buttons');
	for (var i = 0 ; i < tables.length ; i++) {
		var tds = tables[i].getElementsByTagName('td');
		for (var j = 0; j < tds.length ; j++) {
			if (tds[j].id == 'showExcl') {
				tds[j].className = 'button_on';
			} else {
				tds[j].className = 'button_off';
			}
		}
	}

	document.cookie = 'showhide=showExcl';
}

function getCookie(key)
{
	var start = document.cookie.indexOf(key + '=');
	if (start < 0) return(null); /* no such cookie */

	var value = start + key.length + 1;
	return(document.cookie.substring(value, document.cookie.indexOf(';', value)));
}

function showLast()
{
	switch (getCookie('showhide')) {
		case 'showCov': showCov(); break;
		case 'showMis': showMis(); break;
		case 'showExcl': showExcl(); break;
		default:        showAll(); break;
	}
}
