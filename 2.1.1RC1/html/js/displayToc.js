var tocRoot, tocBranch, tocSel, tocLoading, tocLastID, tableSel = null, tabHead, data, tocTab, tocInitRoot, tocMemToc,
	rFStatus, oldData, tableSelTable;
var prevPage = "";
var initI;
var icon = new Array();
var preloadIcons =
	new Array(1, 10, 101, 102, 103, 104, 106, 107, 108, 11, 113, 116, 118, 16, 175, 176, 177, 178, 179, 180, 181, 182,
		183, 184, 185, 186, 187, 188, 189, 19, 20, 21, 24, 25, 26, 28, 29, 31, 34, 4, 5, 52, 53, 56, 57, 6, 60, 68, 69,
		7, 8, 82, 9, 99);

var browser = browserCheck();
var content = 0;
var Linkguid = "";

function browserCheck()
{
	browser = navigator.userAgent.toLowerCase();

	if (browser.indexOf('msie') != -1)
	{
		if (browser.substring(browser.indexOf('msie') + 5, browser.indexOf('.', browser.indexOf('msie'))) > 6)
			return ("ie7");

		if (browser.substring(browser.indexOf('msie') + 5, browser.indexOf('.', browser.indexOf('msie'))) > 5)
			return ("ie6");
		else
			return ("ie_old");
	}
	else if (browser.indexOf('firefox') != -1)
		return ("ff");
	else if (browser.indexOf('opera') != -1)
		return ("op");
	else if (browser.indexOf('gecko') != -1)
		return ("ff");
}

function changeCSS(theClass, element, value, target)
{
	var cssRules;
	target = eval(target + '.document.styleSheets');

	if (browser == 'ie6' || browser == 'ie7')
	{
		cssRules = 'rules';
	} else
	{
		cssRules = 'cssRules';
	}

	for (var S = 0; S < target.length; S++)
	{
		for (var R = 0; R < target[S][cssRules].length; R++)
		{
			if (target[S][cssRules][R].selectorText == theClass)
			{
				try
				{
					target[S][cssRules][R].style[element] = value;
				}
				catch (e)
				{
				}
			}
		}
	}
}

function initItem(item)
{
	if (prevPage != cont.document.location.href)
		tableSel = null;

	if (tableSel == null)
	{
		if (cont.document.getElementById('TableGroup') != null)
		{
			toggleItem(cont.document.getElementById('TableGroup').getElementsByTagName('li')[0].id.replace("Title",
				""));
		}

		prevPage = cont.document.location.href;
	}
}

function initLoad(src, toc, home)
{

	var qs = document.location.search.substring(1);

	if (qs.substring(0, qs.indexOf('=')) == 'goto')
	{
		var gotoPage = qs.substring(qs.indexOf('=') + 1).split(':');
		var fExt = home.substring(home.lastIndexOf('.'));
		var home = "./EARoot/";

		for (var i = 0; i < gotoPage.length; i++)
		{
			home += "EA" + gotoPage[i];

			if (i != gotoPage.length - 1)
				home += "/";
			else
				home += fExt;
		}
	}

	content = document.createElement('div');
	content.className = "IndexBody";
	content.innerHTML = "	<iframe src='" + toc + "' name='toc' id='tocIFrame' frameborder='0'></iframe>\n";

	if (qs.substring(0, qs.indexOf('=')) == 'guid')
	{
		Linkguid = qs.substring(qs.indexOf('=') + 1).split('?guid=');
		var sGuid = new String(Linkguid);

		if (sGuid.substring(0, 1) == "{" && sGuid.substring(sGuid.length, sGuid.length - 1) == "}")
			sGuid = sGuid.substring(1, sGuid.length - 1);
		Linkguid = sGuid;
		LoadGuidMap(OnReadyLoadGuidMap);
	} else
	{
		// We don't have a guid in the address bar, so set the default homepage and continue
		content.innerHTML += "	<iframe src='" + home + "' name='cont' id='contentIFrame' frameborder='0'></iframe>";
		content.innerHTML += "	<div id=\"resizeFrames\"></div>";

		// Pass in the guid of the home page or class.
		initPreLoad(content);
	}
}

function LoadGuidMap(ResponseFunc)
{
	// Get the correct file
	var FirstTwoHexDigits = new String(Linkguid);
	FirstTwoHexDigits = FirstTwoHexDigits.slice(0, 2).toLowerCase();
	var src = "js/data/guidmaps/" + "GuidMap" + FirstTwoHexDigits + ".xml";

	RequestPage(src, ResponseFunc); // Request the page passing in the filelocation and the response function.
}

function OnReadyLoadGuidMap()
{
	if (data.readyState == 4)
	{
		try
		{

			var Home = GetPageAddressFromMapString(data.responseText);

			//Set the home page.
			content.innerHTML += "	<iframe src='" + Home + "' name='cont' id='contentIFrame' frameborder='0'></iframe>";
			content.innerHTML += "	<div id=\"resizeFrames\"></div>";

			//Make sure memory for the string is cleared. The browser should do this anyway but just in case.
			Home = null;

			// Continue loading the rest of the page.
			initPreLoad(content);
		}
		catch (e)
		{
			return;
		}
	}
}

function GetPageAddressFromMapString(MapString)
{
	var LG = new String(Linkguid);
	var Page = new String(MapString);

	LG = LG.toLowerCase();             //Make searching case insensitive.
	Page = Page.toLowerCase();

	var Pos1 = Page.search(LG);        // Search the the guid in the string and return the position.
	Page = Page.slice(Pos1);           // Remove the top half of the string.

	var Pos2 = Page.search("/");       //Search for the start of the web address.
	var Pos3 = Page.search(";");       //Search for the end of the web address.
	Page = Page.slice(Pos2 + 1, Pos3); // extract the web address.

	// Leave the page address in the original case as Linux is case sensitive.
	var sExt = ".html";
	Pos1 = Page.search(sExt);

	if (Pos1 == -1)
	{
		sExt = ".htm";
		Pos1 = Page.search(sExt);
	}

	Page = Page.slice(0, Pos1);
	Page = Page.toUpperCase();
	Page = "EARoot/" + Page + sExt; // At the root back onto the page.

	return Page;
}

function guidLink(guid, qs)
{
	guid = guid.substring(1, guid.length - 1); //Remove the brakets
	Linkguid = guid;
	LoadGuidMap(OnReadyGuidLink);
}

function OnReadyGuidLink()
{
	if (data.readyState == 4)
	{
		try
		{
			// Get the page location from the guid map.
			var Page = GetPageAddressFromMapString(data.responseText);

			cont.location = Page;

			//Make sure memory for the string is cleared. The browser should do this anyway but just in case.
			Page = null;
			Linkguid = null;
		}
		catch (e)
		{
			return;
		}
	}
}

function RequestPage(Page, ResponseFunc)
{
	try
	{
		data = new XMLHttpRequest();
		data.onreadystatechange = ResponseFunc;
		data.open("GET", Page, true);
		data.send(null);
	}
	catch (e)
	{
		data = new ActiveXObject("Microsoft.XMLHTTP");
		if (data)
		{
			data.onreadystatechange = ResponseFunc;
			data.open("GET", Page, true);
			data.send();
		}
	}
}

function initPage(src)
{
	if (browser == "ie_old")
		return;

	if (toc.document != top.frames[0].document)
	{
		toc = top.frames[0];
	}
  
	if (cont.document != top.frames[1].document)
	{
		cont = top.frames[1];
	}

	if (!cont.document)
	{
		setTimeout("initPage('" + src + "')", "1000");
		return;
	}

	var curPage = cont.document.location + "";

	if (curPage.indexOf('EARoot') != -1)
		curPage = curPage.substring(curPage.indexOf('EARoot'));
	else
		curPage = curPage.substring(curPage.lastIndexOf('/') + 1);

	for (var j = 0; j < cont.document.getElementsByTagName('div').length; j++)
	{
		if (cont.document.getElementsByTagName('div')[j].className == "ObjectDetailsNotes")
		{
			var tmpStr = cont.document.getElementsByTagName('div')[j].innerHTML;
			//tmpStr=tmpStr.replace(/&nbsp;<WBR>/g," "); //GAS 810 - removed as it adversely affect PreserveWS
			tmpStr = tmpStr.replace(/&gt;/g, ">");
			tmpStr = tmpStr.replace(/&lt;/g, "<");

			tmpStr = tmpStr.replace(/#gt;/g, "&gt;");
			tmpStr = tmpStr.replace(/#lt;/g, "&lt;");

			cont.document.getElementsByTagName('div')[j].innerHTML = tmpStr;
		}
	}

	if (src != null)
		initItem();

	if (curPage.substr(0, curPage.indexOf('.')) == "blank")
		return;

	//Check ToC is loaded
	if (toc.document.body == null)
	{
		setTimeout("initPage('" + src + "')", "1");
		return;
	} else if (toc.document.body.childNodes && toc.document.body.childNodes.length == 1)
	{
		setTimeout("initPage('" + src + "')", "1");
		return;
	} else if (toc.document.body.lastChild && toc.document.body.lastChild.childNodes
		&& toc.document.body.lastChild.childNodes.length == 0)
	{
		setTimeout("initPage('" + src + "')", "1");
		return;
	} else if (!toc.document.body.childNodes || !toc.document.body.lastChild || !toc.document.body.lastChild.childNodes)
	{
		setTimeout("initPage('" + src + "')", "1");
		return;
	}
	else
	{
    var parTree = curPage.substr(0, curPage.lastIndexOf('/')).substr(curPage.indexOf('/') + 1).replace(/EA/g, "").replace(/\//g, ".");
    if (parTree)
    {
      if (parTree.indexOf('0') != 0) parTree = "0." + parTree;
      parTree = parTree.split('.');
      var tocTmp;

      for (var j = 0; parTree.length > j; j++) 
      {
        if (j >= 1)
          tocTmp += "." + parTree[j];
        else 
          tocTmp = parTree[j];

        if (toc.document.getElementById('toc' + tocTmp) == null) 
        {
          setTimeout("initPage('" + src + "')", "1");
          return;
        }

        var tmpCurToc = toc.document.getElementById('toc' + tocTmp).parentNode.childNodes;
        toc.tocMemToc = parTree.length - j;

        if (tmpCurToc.length > 3 && tmpCurToc[tmpCurToc.length - 4].src.substring(tmpCurToc[tmpCurToc.length - 4].src.lastIndexOf('images')).indexOf('plus') != -1) 
        {
          toc.tocClick(tmpCurToc[tmpCurToc.length - 4]);
        }
      }
    }

		if (toc.document.getElementById(curPage) == null)
		{
      setTimeout("initPage('"+src+"')","1");
			return;
		}

		if (toc.document.getElementById(curPage).parentNode.parentNode.parentNode.parentNode
			&& toc.document.getElementById(curPage).parentNode.parentNode.parentNode.parentNode.childNodes.length > 3)
		{
			if (toc.document.getElementById(
				curPage).parentNode.parentNode.parentNode.parentNode.childNodes[toc.document.getElementById(
				curPage).parentNode.parentNode.parentNode.parentNode.childNodes.length - 4].src.indexOf('plus') != -1)
			{
				toc.tocClick(toc.document.getElementById(
					curPage).parentNode.parentNode.parentNode.parentNode.childNodes[toc.document.getElementById(
					curPage).parentNode.parentNode.parentNode.parentNode.childNodes.length - 4]);
			}
		}

		if (toc.document.getElementById(curPage).parentNode.parentNode.childNodes[toc.document.getElementById(
			curPage).parentNode.parentNode.childNodes.length - 4].src.indexOf('plus') != -1)
		{
			toc.tocClick(
				toc.document.getElementById(curPage).parentNode.parentNode.childNodes[toc.document.getElementById(
					curPage).parentNode.parentNode.childNodes.length - 4]);
		}

		if (tocSel)
			tocSel.parentNode.childNodes[tocSel.parentNode.childNodes.length - 2].style.backgroundColor = "";

		//Highlight selected ToC item and store in memory
		if (toc.document.getElementById(curPage))
		{
			tocSel = toc.document.getElementById(curPage).parentNode;
			tocSel.parentNode.childNodes[tocSel.parentNode.childNodes.length - 2].style.backgroundColor = "#B2B4BF";

			if (tocSel.offsetTop < toc.document.body.scrollTop || tocSel.offsetTop > toc.document.body.offsetHeight
				+ toc.document.body.scrollTop)
			{
				toc.scrollTo(0, tocSel.offsetTop - 20);
			}
		}
	}
}

function initPreLoad(content)
{
	var preload = document.getElementById('IndexHeader').parentNode.insertBefore(document.createElement('div'),
		document.getElementById('IndexHeader').nextSibling);
	preload.id = "Preload";
	preload.appendChild(document.createElement('p'));
	preload.firstChild.appendChild(document.createTextNode("Loading..."));

	if (browser == "ie_old")
		return;

	if (browser == "ie6" || browser == "ie7")
		changeCSS('#Preload', 'height', top.document.body.clientHeight - 67 + 'px', 'this');
	else
		changeCSS('#Preload', 'height', top.innerHeight - 67 + 'px', 'this');

	for (var i = 0; i < preloadIcons.length; i++)
	{
		icon[preloadIcons[i]] = new Image();
		icon[preloadIcons[i]].src = "images/" + preloadIcons[i] + ".png";
	}

	var preloader = document.body.appendChild(document.createElement('div'));
	preloader.style.display = "none";
	preloader.id = "preloader";
	preloader.appendChild(content);

	resizeFrames('init');
}

function initPreLoaded()
{
	if (browser == "op")
		setCSS();

	var preloader = document.getElementById('preloader');

	document.getElementById('Preload').parentNode.replaceChild(preloader.firstChild,
		document.getElementById('Preload'));
	preloader.parentNode.removeChild(preloader);

	if (browser != "op")
		setTimeout('setCSS();', '1000');
}

function resizeFrames(str)
{
	var resizeFrames = document.getElementById('resizeFrames');
	if (str == "init")
	{
		resizeFrames.onmousedown = resizeFramesOn;
		resizeFrames.onmouseup = resizeFramesOff;
		resizeFrames.onmouseout = resizeFramesOff;
		resizeFrames.onmousemove = resizeFramesMove;
	}
}

function resizeFramesOn(e)
{
	rFStatus = 1;

	var resizeFrames = document.getElementById('resizeFrames');
	tmpRF = resizeFrames.parentNode.appendChild(document.createElement('div'));
	tmpRF.style.left = (document.getElementById('tocIFrame').clientWidth + 1) + "px";
	tmpRF.id = "tmpRF";
	resizeFrames.style.width = "100%"
	resizeFrames.style.left = "0px";
}

function resizeFramesOff(e)
{
	rFStatus = 0;

	var resizeFrames = document.getElementById('resizeFrames');
	if (document.getElementById('tmpRF') != null)
		document.getElementById('tmpRF').parentNode.removeChild(document.getElementById('tmpRF'));

	resizeFrames.style.width = "5px";
	resizeFrames.style.left = (document.getElementById('tocIFrame').clientWidth + 1) + "px";
}

function resizeFramesMove(e)
{
	if (rFStatus != 0)
	{
		if (rFStatus == 2)
			var posX = e + 2;
		else if (browser == "ff")
			var posX = e.pageX;
		else
			var posX = event.x;

		if (posX <= 150)
			posX = 150;
		else if (posX >= top.document.body.clientWidth / 2)
			posX = top.document.body.clientWidth / 2;

		document.getElementById('contentIFrame').style.left = (posX + 3) + "px";
		document.getElementById('contentIFrame').style.width = (top.document.body.clientWidth - posX - 4) + "px";

		if (document.getElementById('tmpRF') != null)
			document.getElementById('tmpRF').style.left = (posX - 2) + "px";

		if (browser == "ie6")
			document.getElementById('tocIFrame').style.width = (posX - 4) + "px";
		else
			document.getElementById('tocIFrame').style.width = (posX - 3) + "px";

		if (tableSelTable != null)
		{
			if (tableSelTable.childNodes.length > 1 && document.getElementById('tmpRF') != null)
			{
				tableSelTable.style.width = (document.body.clientWidth
					- (document.getElementById('tmpRF').offsetLeft + 6) - 20) + "px";

				if (tableSelTable.childNodes[0].style)
					tableSelTable.childNodes[0].style.width = (tableSelTable.offsetWidth - 19) + "px";

				if (tableSelTable.childNodes[1].style)
					tableSelTable.childNodes[1].style.width = (tableSelTable.offsetWidth - 19) + "px";
			}
		}
	}
}

function resizePage()
{
	if (rFStatus == 1)
		return;
	rFStatus = 2;

	if (document.getElementById('resizeFrames') == null)
		return;

	if (browser == "ie6")
	{
		pHeight = top.document.body.clientHeight;
	} else
	{
		pHeight = top.document.documentElement.clientHeight;
	}

	resizeFramesMove(document.getElementById('resizeFrames').offsetLeft);
	document.getElementById('contentIFrame').style.height = pHeight - 74 + 'px';

	if (browser == "ie7")
	{
		document.getElementById('resizeFrames').style.height = pHeight - 72 + 'px';
		changeCSS('#tmpRF', 'height', pHeight - 72 + 'px', 'this');
	} else
	{
		document.getElementById('resizeFrames').style.height = pHeight - 70 + 'px';
		changeCSS('#tmpRF', 'height', pHeight - 70 + 'px', 'this');
	}
	document.getElementById('tocIFrame').style.height = pHeight - 74 + 'px';
	rFStatus = 0;
}

function setCSS()
{
	if (browser == "ie6")
	{
		pHeight = top.document.body.clientHeight;
	} else
	{
		pHeight = top.document.documentElement.clientHeight;
	}

	if (browser == "ie6" || browser == "ie7")
	{
		changeCSS('.IndexBody', 'width', '', 'this');
		changeCSS('.IndexBody', 'top', '0px', 'this');
		changeCSS('.IndexBody', 'position', 'relative', 'this');
		changeCSS('#contentIFrame', 'height', pHeight - 74 + 'px', 'this');
		changeCSS('#contentIFrame', 'left', '257px', 'this');
		changeCSS('#resizeFrames', 'background', '#000000', 'this');
		changeCSS('#resizeFrames', 'filter', 'progid:DXImageTransform.Microsoft.Alpha(opacity=0)', 'this');
		changeCSS('#resizeFrames', 'height', pHeight - 72 + 'px', 'this');
		changeCSS('#tmpRF', 'border', '0px', 'this');
		changeCSS('#tmpRF', 'height', pHeight - 70 + 'px', 'this');
		changeCSS('#tocIFrame', 'height', pHeight - 74 + 'px', 'this');
	}

	changeCSS('#contentIFrame', 'width', top.document.body.clientWidth - 258 + 'px', 'this');
}

function tocBuild(data)
{

	var tocType = new Array();
	var tocTypes = new Array();
	var tocErrs = new Array();

	for (var i = 0; i < tocTab.length; i++)
	{
		if (!tocTab[i][8])
			tocTab[i][8] = 'misc';

		if (tocTab[i][8].toLowerCase().indexOf('diagram') != -1 && (tocTab[i][6] == "" || tocTab[i][6] == "0"))
			tocTab[i][8] = "0Diagram";

		if (tocTab[i][8].toLowerCase().indexOf('package') != -1)
			tocTab[i][8] = "1Package";

		if (!tocType[tocTab[i][8]])
		{
			tocType[tocTab[i][8]] = new Array();
			tocTypes[tocTypes.length] = tocTab[i][8];
		}
		tocType[tocTab[i][8]][tocType[tocTab[i][8]].length] = i;
	}

	tocTypes.sort();

	for (var i = 0; i < tocTypes.length; i++)
	{
		for (var j = 0; j < tocType[tocTypes[i]].length; j++)
		{
			var build = tocBuildItem(tocType[tocTypes[i]][j]);

			if (build != true)
			{
				build = build.substring(1);
				tocErrs[tocErrs.length] = build;
			}
		}
	}

	var errRuns = 0;
	var errTotal = tocErrs.length;

	while (tocErrs.length != 0)
	{
		if (errNums == tocErrs.length)
		{
			errRuns++;

			if (errRuns > errTotal)
			{
				break;
			}
		}
		var errNums = tocErrs.length;
		var tmp = tocBuildItem(tocErrs.shift());

		if (tmp != true)
		{
			tocErrs[tocErrs.length] = tmp.substring(1);
		}
	}

	while (tocErrs.length != 0)
	{
		tocTab[tocErrs[0]][6] = "0";
		tocBuildItem(tocErrs.shift());
	}

	if (tocLastID != 0)
	{
		var tocLastSrc = document.getElementById("toc"
			+ tocLastID).parentNode.childNodes[document.getElementById("toc" + tocLastID).parentNode.childNodes.length
			- 4];
		tocLastSrc.src = tocLastSrc.src.substring(tocLastSrc.src.lastIndexOf('images')).replace("01", "02");
	}
}

function tocBuildItem(i)
{

	var childItem = false;

	if (tocTab[i][0].indexOf(':') != -1)
		tocBranch = document.getElementById("toc" + tocTab[i][0].substring(0, tocTab[i][0].lastIndexOf(':')));
	else if (tocTab[i][0].indexOf('.') != -1)
		tocBranch = document.getElementById("toc" + tocTab[i][0].substring(0, tocTab[i][0].lastIndexOf('.')));
	else if (tocTab[i][0] != "0")
		tocBranch = document.getElementById("toc0");
	else if (tocTab[i][1] == 3)
		tocBranch = document.getElementById("System").parentNode.lastChild;
	else
		tocBranch = tocRoot;

	//Check if item is child
	if (tocTab[i][5] && tocTab[i][6] && tocTab[i][6] != "0")
	{
		if (document.getElementById(tocTab[i][6]) == null)
			return 'i' + i;
		tocBranch = document.getElementById(tocTab[i][6]).parentNode.lastChild;
		childItem = true;
	}

	tocBranch = tocBranch.appendChild(document.createElement('li'));

	if (tocTab[i][0] != 0 || tocTab[i][1] == 3)
	{
		tocImage = tocBranch.appendChild(document.createElement('img'));

		if (tocTab[i][0].indexOf('.') == -1 && (tocTab[i][0].indexOf(':') == -1 || tocTab[i][0].indexOf('0') == 0))
			tocImage.src = "images/join01.gif";
			else if (tocTab[i][0].indexOf('.') != -1 || tocTab[i][0].indexOf(':') != -1)
		{
			var tocTmp = tocTab[i][0].replace(':', '.');

			for (var m = 0; tocTmp.split('.').length > m + 1; m++)
			{
				if (document.getElementById("toc" + tocTmp.substring(0,
					tocTmp.lastIndexOf('.'))).parentNode.childNodes[m].src.substring(document.getElementById("toc"
					+ tocTmp.substring(0,
						tocTmp.lastIndexOf('.'))).parentNode.childNodes[m].src.lastIndexOf('images')).indexOf('02')
					!= -1 || document.getElementById("toc"
					+ tocTmp.substring(0,
						tocTmp.lastIndexOf('.'))).parentNode.childNodes[m].src.substring(document.getElementById("toc"
					+ tocTmp.substring(0,
						tocTmp.lastIndexOf('.'))).parentNode.childNodes[m].src.lastIndexOf('images')).indexOf('04')
						!= -1)
					tocImage.src = "images/join04.gif";
				else
					tocImage.src = "images/join03.gif";
				tocImage = tocBranch.appendChild(document.createElement('img'));
			}
			tocImage.src = "images/join01.gif";
		}
		tocImage.onclick = function()
		{
			tocClick(this);
		}

		if (tocTab[i][1] == 3)
		{
			tocImage.src = tocImage.src.substring(tocImage.src.lastIndexOf('images')).replace("01", "02");

			if (tocImage.parentNode.parentNode.childNodes.length > 1)
			{
				tocTmp = tocImage.parentNode.previousSibling.childNodes[
					tocImage.parentNode.previousSibling.childNodes.length - 4];
				tocTmp.src = tocTmp.src.substring(tocTmp.src.lastIndexOf('images')).replace("02", "01");
			}
		}

		//Check if item has children data
		if (tocTab[i][1] && tocTab[i][1] != 3)
		{
			tocImage.id = tocTab[i][7];
			tocImage.alt = tocTab[i][7];
		} else if (childItem == true)
		{
			while (tocImage.parentNode.childNodes.length
				< document.getElementById(tocTab[i][6]).parentNode.childNodes.length - 2)
			{
				tocImage.parentNode.insertBefore(document.createElement('img'), tocImage).src = "images/join03.gif";
			}
			tocImage.src = tocImage.src.substring(tocImage.src.lastIndexOf("images")).replace('01', '02');

			if (document.getElementById(tocTab[i][6]).parentNode.lastChild.childNodes.length > 1)
			{
				tocTmpSrc = document.getElementById(
					tocTab[i][6]).parentNode.lastChild.lastChild.previousSibling.childNodes[document.getElementById(
					tocTab[i][6]).parentNode.lastChild.lastChild.previousSibling.childNodes.length - 4];
				tocTmpSrc.src = tocTmpSrc.src.substring(tocTmpSrc.src.lastIndexOf('images')).replace('02', '01');
			}
			tocImage = document.getElementById(
				tocTab[i][6]).parentNode.childNodes[document.getElementById(tocTab[i][6]).parentNode.childNodes.length
				- 4];
			tocImage.parentNode.lastChild.style.display = "none";
		}

		if ((tocTab[i][1] && tocTab[i][1] != 3) || childItem == true)
		{
			tocImage.id = tocImage.id.substr(1, tocImage.id.length - 2);
			tocImage.src = tocImage.src.substring(tocImage.src.lastIndexOf('images')).replace('join', 'plus');
		}
	}

	//Set Icon
	if (tocTab[i][3])
	{
		tocImg = tocBranch.appendChild(document.createElement('a'));
		tocImg.href = tocTab[i][3];
		tocImg.target = top.frames[1].name;
	} else
		tocImg = tocBranch;
	tocTab[i][4] = tocTab[i][4].substring(0, tocTab[i][4].indexOf('.'))

	tocImg = tocImg.appendChild(document.createElement('img'));

	if (top.icon[tocTab[i][4]])
		tocImg.src = top.icon[tocTab[i][4]].src;
	else
		tocImg.src = "images/" + tocTab[i][4] + ".png";

	if (tocTab[i][3])
		tocImg.id = tocTab[i][3];

	//Set Text/Link
	if (tocTab[i][5] && tocTab[i][8] != "0Diagram")
		tocBranch.lastChild.id = tocTab[i][5];
	else
		tocBranch.lastChild.id = "0";
	tocBranch.lastChild.style.marginRight = "4px";

	if (tocTab[i][3])
	{
		tocText = tocBranch.appendChild(document.createElement('a'));
		tocText.href = tocTab[i][3];
		tocText.target = top.frames[1].name;

		if (tocTab[i][9])
			tocText.id = tocTab[i][9];
		else if (tocTab[i][7])
			tocText.id = tocTab[i][7];
	} else
		tocText = tocBranch;
	var j = 0;
	var nodeText;

	//Replace values
	while (tocTab[i][2].indexOf('&quot;') != -1)
		tocTab[i][2] = tocTab[i][2].replace('&quot;', '\"');

	while (tocTab[i][2].indexOf('<br />') != -1)
		tocTab[i][2] = tocTab[i][2].replace('<br />', '\n');

	while (tocTab[i][2].indexOf('&#39;') != -1)
		tocTab[i][2] = tocTab[i][2].replace('&#39;', '\'');

	if (tocTab[i][2] == "")
		tocTab[i][2] = "               ";

	nodeText = tocText.appendChild(document.createTextNode(tocTab[i][2]));

	while (nodeText.nodeValue.indexOf('&lt;') != -1)
		nodeText.nodeValue = nodeText.nodeValue.replace('&lt;', '<');

	while (nodeText.nodeValue.indexOf('&gt;') != -1)
		nodeText.nodeValue = nodeText.nodeValue.replace('&gt;', '>');

	tocBranch.appendChild(document.createElement('ul')).id = "toc" + tocTab[i][0];

	tocLastID = tocTab[i][0];

	return true;
}

function tocClick(tocSrc)
{
	if (tocSrc.src.substring(tocSrc.src.lastIndexOf('images')).indexOf('minus') != -1)
	{

		tocSrc.parentNode.childNodes[tocSrc.parentNode.childNodes.length - 1].style.display = "none";
		tocSrc.src = tocSrc.src.substring(tocSrc.src.lastIndexOf('images')).replace('minus', 'plus');
	}
	else if (tocSrc.src.substring(tocSrc.src.lastIndexOf('images')).indexOf('plus') != -1)
	{
		tocSrc.parentNode.childNodes[tocSrc.parentNode.childNodes.length - 1].style.display = "block";
		tocSrc.src = tocSrc.src.substring(tocSrc.src.lastIndexOf('images')).replace('plus', 'minus');

		//Check if children data built
		if (tocSrc.parentNode.childNodes[tocSrc.parentNode.childNodes.length - 1].childNodes.length == 0)
		{
			tocLoadData(tocSrc.id + ".xml");
		}
	}
}

function tocInit()
{
	if (browser == "ie_old")
	{
		top.document.getElementById(
			'Preload').childNodes[0].innerHTML
			= "<strong>It appears you are using an outdated version of Internet Explorer, please download a later version from <a href=\"http://www.microsoft.com/windows/ie/default.mspx\">Microsoft</a></strong>";
		return;
	}
	tocLoading = document.body.appendChild(document.createElement('div'));
	tocRoot = document.body.appendChild(document.createElement('ul'));
	tocRoot.id = "tocRoot";
	tocInitRoot = 1;
	tocLoadData('root.xml');
}

function tocLoadData(src)
{

	var tmp = document.location + "";
	tmp = tmp.substring(0, tmp.indexOf('toc.'));

	src = tmp + "js/data/" + src;
	tocTab = new Array();

	RequestPage(src, tocLoadDataProcess);
}

function tocLoadDataProcess()
{
	if (data.readyState == 4)
	{
		if (oldData == data)
			return;
		oldData = data;

		try
		{
			eval(data.responseText);
			tocBuild();
			tocInitRoot++;

			if (tocInitRoot == 2)
			{
				tocLoadData(tocTab[0][7].substring(1, tocTab[0][7].length - 1) + ".xml");
			} else if (tocInitRoot == 3 && top.document.getElementById('Preload') != null)
			{
				tocInitRoot = 0;
				top.initPreLoaded();
			}
		}
		catch (e)
		{
			if (top.document.getElementById('Preload') != null)
			{
				var msg =
					"<strong>An error occured while loading data files, please confirm that all files have been generated and are intact.</strong>";

				if (browser == "op")
				{
					msg +=
						"<br\/><br\/><br\/>A possible cause for this error is <strong>'Allow File XMLHttpRequest'</strong> is disabled. This option can be changed via <a href=\"about:config#UserPrefs|AllowFileXMLHttpRequest\">Preferences Editor</a>.<br\/><br\/><i>Note: Ensure you scroll down and click 'save' at the bottom of the page.<\i>";
				}
				top.document.getElementById('Preload').childNodes[0].innerHTML = msg;
			}
			return;
		}
	}
}

function toggleDiv(idDiv, idImage)
{
	var ele = cont.document.getElementById(idDiv);

	if (ele && ele.style.display == "none")
	{
		ele.style.display = "block";
		cont.document.getElementById(idImage).src = cont.document.getElementById(idImage).src.substring(0,
			cont.document.getElementById(idImage).src.lastIndexOf('images'))
			+ cont.document.getElementById(idImage).src.substring(
				cont.document.getElementById(idImage).src.lastIndexOf('images')).replace('plus', 'minus');
	} else if (ele)
	{
		ele.style.display = "none";
		cont.document.getElementById(idImage).src = cont.document.getElementById(idImage).src.substring(0,
			cont.document.getElementById(idImage).src.lastIndexOf('images'))
			+ cont.document.getElementById(idImage).src.substring(
				cont.document.getElementById(idImage).src.lastIndexOf('images')).replace('minus', 'plus');
	}
}

function toggleData(src)
{
	var dataRoot = cont.document.getElementById(src).parentNode.parentNode.parentNode;

	if (cont.document.getElementById(src).src.substring(
		cont.document.getElementById(src).src.lastIndexOf('images')).indexOf('plus') != -1)
		cont.document.getElementById(src).src = cont.document.getElementById(src).src.substring(0,
			cont.document.getElementById(src).src.lastIndexOf('images'))
			+ cont.document.getElementById(src).src.substring(
				cont.document.getElementById(src).src.lastIndexOf('images')).replace('plus', 'minus');
	else
		cont.document.getElementById(src).src = cont.document.getElementById(src).src.substring(0,
			cont.document.getElementById(src).src.lastIndexOf('images'))
			+ cont.document.getElementById(src).src.substring(
				cont.document.getElementById(src).src.lastIndexOf('images')).replace('minus', 'plus');

	for (var i = 0; i < dataRoot.getElementsByTagName('tr').length; i++)
	{
		if (dataRoot.getElementsByTagName('tr')[i].id.indexOf(src)
			!= -1 && cont.document.getElementById(src).src.substring(
				cont.document.getElementById(src).src.lastIndexOf('images')).indexOf('minus')
				!= -1 && dataRoot.getElementsByTagName('tr')[i].getElementsByTagName('td')[1].firstChild != null)
			dataRoot.getElementsByTagName('tr')[i].style.display = "";
		else if (dataRoot.getElementsByTagName('tr')[i].id.indexOf(src) != -1)
			dataRoot.getElementsByTagName('tr')[i].style.display = "none";
	}

	if (cont.document.getElementById('TableGroup') != null)
	{
		toggleItem(tableSel, 2);
	}
}

function toggleItem(item, type)
{
	if (tableSel != null)
	{
		var obj = cont.document.getElementById(tableSel + "Table");

		if (obj != null)
		{
			cont.document.getElementById(tableSel + "Title").style.background = "#FFFFFF";
			cont.document.getElementById(tableSel + "Title").style.color = "#000000";
			obj.style.display = "none";
		}
	}
	tableSel = item;
	tableSelTable = cont.document.getElementById(item + "Table");
	tableSelTitle = cont.document.getElementById(item + "Title");

	tableSelTitle.style.background = "#DDDDDD";
	tableSelTitle.style.color = "#666666";
	tableSelTable.style.display = "block";

	if (browser == "ff" || browser == "op" || browser == "ie7")
	{
		var contWHeight = document.documentElement.clientHeight - 78;
		var contWWidth = cont.document.documentElement.clientWidth;
	} else
	{
		var contWHeight = document.body.clientHeight - 74;
		var contWWidth = document.body.clientWidth - (top.document.getElementById('resizeFrames').offsetLeft + 6);
	}

	if (tableSelTable.id == "LinkedDocumentTable")
		tableSelTable.style.overflow = "scroll";

	if (cont.document.body.offsetHeight - contWHeight > 0)
	{
		if (tableSelTable.id != "LinkedDocumentTable")
			tableSelTable.style.overflow = "scroll";

		if (browser == "ff" || browser == "op")
		{
			tableSelTable.style.height = tableSelTable.offsetHeight
				- (cont.document.body.offsetHeight - cont.innerHeight) - 12 + "px";
		} else
		{

			tableSelTable.style.height = tableSelTable.offsetHeight - (cont.document.body.offsetHeight - contWHeight)
				- 3 + "px";

			if (cont.document.body.offsetWidth > contWWidth || type == null)
			{
				tableSelTable.style.width = contWWidth - 20 + "px";

				if (tableSelTable.getElementsByTagName('table').length != 0)
					tableSelTable.getElementsByTagName(
						'table')[0].style.width = tableSelTable.getElementsByTagName('table')[0].offsetWidth - 18
						+ "px";
			}
		}

		if (tableSelTable.getElementsByTagName('table').length != 0)
		{
			tabHead = tableSelTable.appendChild(tableSelTable.getElementsByTagName('table')[0].cloneNode(true));
			tabHead.style.position = "absolute";

			if (browser == "ff" || browser == "op")
				tabHead.style.width = tableSelTable.offsetWidth + "px";
			tabHead.style.top = tableSelTable.offsetTop + 1 + "px";

			for (var i = 0; i < tabHead.getElementsByTagName('tr').length; i++)
			{
				if (i != 0)
					tabHead.getElementsByTagName('tr')[i].style.display = "none";
			}
		}
	} else if (cont.document.getElementById('TableGroup').offsetHeight
		+ cont.document.getElementById('TableGroup').offsetTop < (contWHeight - 6)
			&& tableSelTable.style.overflow == "scroll")
	{
		if (browser == "ff" || browser == "op")
		{
			tableSelTable.style.height = tableSelTable.offsetHeight
				- (cont.document.body.offsetHeight - cont.innerHeight) - 12 + "px";
		} else
		{
			tableSelTable.style.height = tableSelTable.offsetHeight
				+ ((contWHeight - 8) - (cont.document.getElementById('TableGroup').offsetHeight
					+ cont.document.getElementById('TableGroup').offsetTop)) + "px";
		}
	}

	if (tableSelTable.childNodes.length > 1)
	{
		tableSelTable.style.width = (document.body.clientWidth
			- (top.document.getElementById('resizeFrames').offsetLeft + 6) - 20) + "px";

		if (tableSelTable.childNodes[0].style)
			tableSelTable.childNodes[0].style.width = (tableSelTable.offsetWidth - 19) + "px";

		if (tableSelTable.childNodes[1].style)
			tableSelTable.childNodes[1].style.width = (tableSelTable.offsetWidth - 19) + "px";
	}
}