#!/bin/sh

AppID=$1

#get keychain path

keychainPath=$(grep -F keychainDumper /Applications/iRE.app/toolPaths.txt | cut -d":" -f2)
Keys=$($keychainPath -k  | tr '\n' '!' | sed 's/!/<br>/g')
Entitlements=$($keychainPath -e | tr '\n' '!' | sed 's/</\&lt;/g' | sed 's/!/<br>/g')
GPasswords=$($keychainPath -g | tr '\n' '!' | sed 's/!/<br>/g')
IPasswords=$($keychainPath -n | tr '\n' '!' | sed 's/!/<br>/g')
Identities=$($keychainPath -i | tr '\n' '!' | sed 's/!/<br>/g')
Certs=$($keychainPath -c | tr '\n' '!' | sed 's/!/<br>/g')

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
      table.output {background-color:#d3d3d3; border:1px solid black;}
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
        if ( i == 1 ) tabLinks[id].className = "selected";
        i++;
      }

      // Hide all content divs except the first
      var i = 1;

      for ( var id in contentDivs ) {
        if ( i != 1 ) contentDivs[id].className = "tabContent hide";
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

	function hideDivs()
	{

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
      <li><a href="#">Keychain Analysis</a></li>
      <li><a href="/Database?AppID='${AppID}'">Database Analysis</a></li>
      <li><a href="/Log?AppID='${AppID}'">Log Viewer</a></li>
      <li><a href="/PList?AppID='${AppID}'">Plist Viewer</a></li>
      <li><a href="/Headers?AppID='${AppID}'">Header Files</a></li>
      <li><a href="/Theos?AppID='${AppID}'">Theos</a></li>
      <li><a href="/Screenshot?AppID='${AppID}'">Screenshot</a></li>
      <li><a href="/">Home</a></li>
    </ul>

    <div class="tabContent" id="keychain">
      <h2>Below are the contents of the iOS device keychain</h2>
      <div>
      	<b>Keychain Keys</b>
      	<br><br><a href="javascript:showDiv('"'"'divKeychainKeys'"'"')">Show/Hide Keychain Keys</a>
        <div id="divKeychainKeys" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainKeys2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainKeys3" style="height:1500px;">
			<pre class="output">
'${Keys}'
			</pre>
				</div>
			</div>
		</div>
		<br><br><a href="javascript:showDiv('"'"'divKeychainEntitlements'"'"')">Show/Hide Keychain Entitlements</a>
		<div id="divKeychainEntitlements" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainEntitlements2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainEntitlements3" style="height:1500px;">
			<pre class="output">
'${Entitlements}'
			</pre>
			</div>
			</div>
			</div>
			<br><br><a href="javascript:showDiv('"'"'divKeychainGPasswords'"'"')">Show/Hide Keychain Generic Passwords</a>
			<div id="divKeychainGPasswords" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainGPasswords2" style="max-height:100%; overflow:auto; border:1px solid black;">
        		<div id="divKeychainGPasswords3" style="height:1500px;">
			<pre class="output">
'${GPasswords}'
			</pre>
			</div>
			</div>
			</div>
			<br><br><a href="javascript:showDiv('"'"'divKeychainIPasswords'"'"')">Show/Hide Keychain Internet Passwords</a>
			<div id="divKeychainIPasswords" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainIPasswords2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainIPasswords3" style="height:1500px;">
			<pre class="output">
'${IPasswords}'
			</pre>
			</div>
			</div>
			</div>
			<br><br><a href="javascript:showDiv('"'"'divKeychainIdentities'"'"')">Show/Hide Keychain Identities</a>
			<div id="divKeychainIdentities" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainIdentities2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainIdentities3" style="height:1500px;">
			<pre class="output">
'${Identities}'
			</pre>
			</div>
			</div>
			</div>
			<br><br><a href="javascript:showDiv('"'"'divKeychainCertificates'"'"')">Show/Hide Keychain Certificates</a>
			<div id="divKeychainCertificates" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainCertificates2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainCertificates3" style="height:1500px;">
			<pre class="output">
'${Certs}'
			</pre>
			</div>
			</div>
			</div>
			<!--<br><br><a href="javascript:showDiv(divKeychainAllKeys)">Show/Hide All Keychain Keys</a>
		<div id="divKeychainAllKeys" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; display:none">
    		<div id="divKeychainAllKeys2" style="max-height:100%;overflow:auto;border:1px solid black;">
        		<div id="divKeychainAllKeys3" style="height:1500px;">
			<pre class="output">
			{CONTENT}
			</pre>
			</div>
			</div>
			</div>-->


  </body>
</html>'
