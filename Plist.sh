#!/bin/sh

AppID=$1
PList=$2

echo ' <html>
  <head>
    <title>iRET - iOS Reverse Engineering Toolkit</title>

    <style type="text/css">
      body { font-size: 80%; font-family: Lucida Grande, Verdana, Arial, Sans-Serif; }
      ul#tabs { list-style-type: none; margin: 10px 0 0 0; padding: 0 0 0.3em 0; }
      ul#tabs li { display: inline; }
      ul#tabs li a { color: #000000; background-color: #d3d3d3; border: 1px solid #000000; border-bottom: none; padding: 0.3em; text-decoration: none; }
      ul#tabs li a:hover { background-color: #377CC2; }
      ul#tabs li a.selected { color: #000000; background-color: #FFFFFF; font-weight: bold; padding: 0.7em 0.3em 0.38em 0.3em; }
      div.tabContent { border: 1px solid #000000; padding: 0.5em; background-color: #FFFFFF; }
      div.tabContent.hide { display: none; }
      .output {font-family: Times New Roman; font-size:12pt; word-wrap:break-word;}
      table.output {background-color:#d3d3d3; border:1px solid black; font-family: Times New Roman; font-size:12pt; word-wrap:break-word;}
      table.dboutput {background-color:#d3d3d3; border:1px solid black;}
      tr.output {border:1px solid black; text-align:left; vertical-align:top;}
      td.output {border:1px solid black; text-align:left; vertical-align:top;}
      div#expand{display:block; width:500px;}
      .boxsizingBorder
      {
    		-moz-appearance: textfield-multiline;
    		-webkit-appearance: textarea;
    		border: 1px solid gray;
    		font: medium -moz-fixed;
    		font: -webkit-small-control;
    		height: 100%;
    		overflow: auto;
    		padding: 2px;
    		resize: both;
    		width: 100%;
		}
    </style>

    <script type="text/javascript">
    //<![CDATA[

    var tabLinks = new Array();
    var contentDivs = new Array();

    function init() {

      // Grab the tab links and content divs from the page
      var tabListItems = document.getElementById("tabs").childNodes;
      for ( var i = 0; i < tabListItems.length; i++ ) {
        if ( tabListItems[i].nodeName == "LI" ) {
          var tabLink = getFirstChildWithTagName( tabListItems[i], "A" );
          var id = getHash( tabLink.getAttribute("href") );
          tabLinks[id] = tabLink;
          contentDivs[id] = document.getElementById( id );
        }
      }

      // Assign onclick events to the tab links, and
      // highlight the first tab
      var i = 0;

      for ( var id in tabLinks ) {
        tabLinks[id].onclick = showTab;
        tabLinks[id].onfocus = function() { this.blur() };
        if ( i == 4 ) tabLinks[id].className = "selected";
        i++;
      }

      // Hide all content divs except the first
      var i = 4;

      for ( var id in contentDivs ) {
        if ( i != 4 ) contentDivs[id].className = "tabContent hide";
        i++;
      }
    }

    function showTab() {
      var selectedId = getHash( this.getAttribute("href") );

      // Highlight the selected tab, and dim all others.
      // Also show the selected content div, and hide all others.
      for ( var id in contentDivs ) {
        if ( id == selectedId ) {
          tabLinks[id].className = "selected";
          contentDivs[id].className = "tabContent";
        } else {
          tabLinks[id].className = "";
          contentDivs[id].className = "tabContent hide";
        }
      }

      // Stop the browser following the link
      return false;
    }

    function getFirstChildWithTagName( element, tagName ) {
      for ( var i = 0; i < element.childNodes.length; i++ ) {
        if ( element.childNodes[i].nodeName == tagName ) return element.childNodes[i];
      }
    }

    function getHash( url ) {
      var hashPos = url.lastIndexOf ( "#" );
      return url.substring( hashPos + 1 );
    }

 	function showDiv(divName)
	{
		if(document.getElementById(divName).style.display == "none")
			document.getElementById(divName).style.display = "block";
		else
			document.getElementById(divName).style.display = "none";
	}

	function checkForm(strValue)
	{
		var oForm = document.getElementById("form1");
		oForm.submit();
	}

    //]]>
    </script>
  </head>
  <body onload="init();" bgcolor="#377CC2">
  <table width="100%" height="100%">
  <tr>
    <td align="center" valign="center">
    	<table style="background-color:white;border:1px solid black;" height="90%" width="90%">
    		<tr>
    			<td align="center" valign="top" height="1%"><font face="arial black" color="black" size="6">Welcome to iRET<br>The  iOS Reverse Engineering Toolkit</font></td>
    		</tr>
    		<tr>
			<td valign="top">
    <ul id="tabs">
      <li><a href="/Binary?AppID='${AppID}'">Binary Analysis</a></li>
      <li><a href="/Keychain?AppID='${AppID}'">Keychain Analysis</a></li>
      <li><a href="/Database?AppID='${AppID}'">Database Analysis</a></li>
      <li><a href="/Log?AppID='${AppID}'">Log Viewer</a></li>
      <li><a href="#">Plist Viewer</a></li>
      <li><a href="/Headers?AppID='${AppID}'">Header Files</a></li>
      <li><a href="/Theos?AppID='${AppID}'">Theos</a></li>
      <li><a href="/Screenshot?AppID='${AppID}'">Screenshot</a></li>
      <li><a href="/">Home</a></li>
    </ul>

    <!-- System Log -->
    <div class="tabContent" id="log">
      <div>

		<!-- Application PList Files -->
      <h2>Below are the plist files that were found for the selected application.</h2><br>'


PLists=$(find /var/mobile/Applications/$AppID -name '*.plist' -type f)

if [ -n "$PLists" ]
then
	dropDownList="<option value=>Select A PList File</option>"

	OIFS="$IFS"
	IFS=$'\n'
	for i in ${PLists}
 	do
 		PListName=$(basename $i)

 		if [ "$PList" = "$i" ]; then
    		dropDownList+="<option value='"$i"' selected>"$PListName"</option>"
    	else
    		dropDownList+="<option value='"$i"'>"$PListName"</option>"
    	fi
	done
	IFS="$OIFS"

    echo '<font face="arial black" color="black" size="3">To begin, select a plist file from the list below:</font><br><br>
		<form id="form1" method="GET" action="/PFile">
			<select name="AppID='${AppID}'&PFile" onchange="checkForm(this.value);">'
    echo "$dropDownList"
    echo '</select></form>
      		<div>
      		<br>'

	if [ -n "$PList" ]
	then
		nPList=$(echo "$PList" | sed 's/\\//g')
		convert=$(plutil -convert xml1 "$nPList")
		content=$(cat "$nPList" | sed 's/</\&lt;/g' | tr '\n' '!' | sed 's/!/<br>/g')

		echo '<div id="divLog" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; word-wrap: break-word;">
    		  <div id="divLog2" style="max-height:100%;overflow:auto;border:1px solid black; word-wrap: break-word;">
        	  <div id="divLog3" style="height:1500px; word-wrap: break-word;">
			  <pre class="output">'

		if [ "$content" != "" ]
		then
			echo $content
		else
			echo "<font color="red"><b>No Content</b></font>"
		fi
			echo '</pre>
			</div>
			</div>
			</div>'
	fi
else
	echo "<font color="red"><b>No Log Files Found</b></font>"
fi
		echo '</div>
    </div>


  </body>
</html>'
