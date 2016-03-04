#!/bin/sh

AppID=$1
SearchText=$3
HeaderName=$2

if [ ! -d "$AppID"_headers ]; then
	#logic to check if the binfile is encrypted
  iOSVersionLoc=$(grep -n 'ProductVersion' /System/Library/CoreServices/SystemVersion.plist | sed 's/:.*//')
  ((iOSVersionLoc+=1))
  iOSVersion=$(cat /System/Library/CoreServices/SystemVersion.plist | sed -n "${iOSVersionLoc}p" | sed 's/^.*<string>//' | sed 's/<\/string>.*//')
  iOSShortVersion=$(echo "$iOSVersion" | cut -c 1)

  if [[ $iOSShortVersion > 7 ]] ;then
    binFile=$(find /private/var/mobile/Containers/Bundle/Application/"$AppID"/*.app -type f -exec file {} \; | grep Mach-O | cut -d":" -f1)
  else
    binFile=$(find /var/mobile/Applications/"$AppID"/*.app -type f -exec file {} \; | grep Mach-O | cut -d":" -f1)
  fi
	
	mkdir /Applications/iRE.app/"$AppID"_headers
	isEncrypted=$(otool -lv "$binFile" | grep cryptid | sed 's/^ *//g' | tr ' ' ':' | cut -d":" -f4)
	classDumpPath=$(grep -F classDumpZ /Applications/iRE.app/toolPaths.txt | cut -d":" -f2)

	if [ $isEncrypted == 1 ]; then
		#binary is encrypted
		dumpPath=$(grep -F dumpdecrypted /Applications/iRE.app/toolPaths.txt | cut -d":" -f2)
		newBin=$(echo "$binFile" | sed 's/ /\\ /g')
		dumpit="DYLD_INSERT_LIBRARIES=$dumpPath "
		dumpit2=$dumpit$newBin
		eval $dumpit2
		binFile2=$(basename "$newBin")

		fileLoc=$(find / -name "$binFile2".decrypted -type f)
		nFile=$( echo "$fileLoc" | sed 's/ /\\ /g' )
		eval mv "$nFile" "/Applications/iRE.app/"
		eval $classDumpPath /Applications/iRE.app/"$binFile2".decrypted -H -o /Applications/iRE.app/"$AppID"_headers
	else
		eval $classDumpPath "$binFile" -H -o /Applications/iRE.app/"$AppID"_headers
	fi
fi


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
        if ( i == 5 ) tabLinks[id].className = "selected";
        i++;
      }

      // Hide all content divs except the first
      var i = 5;

      for ( var id in contentDivs ) {
        if ( i != 5 ) contentDivs[id].className = "tabContent hide";
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
      <li><a href="/PList?AppID='${AppID}'">Plist Viewer</a></li>
      <li><a href="#">Header Files</a></li>
      <li><a href="/Theos?AppID='${AppID}'">Theos</a></li>
      <li><a href="/Screenshot?AppID='${AppID}'">Screenshot</a></li>
      <li><a href="/">Home</a></li>
    </ul>

    <!-- System Log -->
    <div class="tabContent" id="log">
      <div>

		<!-- Application Header Files -->
      <h2>Below are the header files that were dumped for the selected application.</h2><br>'


Headers=$(ls /Applications/iRE.app/"$AppID"_headers)

if [ -n "$Headers" ]
then
	dropDownList="<option value=>Select A Header File</option>"

	OIFS="$IFS"
	IFS=$'\n'
	for i in ${Headers}
 	do
 		fName="/Applications/iRE.app/"$AppID"_headers/"$i

 		if [ "$HeaderName" = "$fName" ]; then
    		dropDownList+="<option value='"/Applications/iRE.app/"$AppID"_headers/$i"' selected>"$i"</option>"
    	else
    		dropDownList+="<option value='"/Applications/iRE.app/"$AppID"_headers/$i"'>"$i"</option>"
    	fi
	done
	IFS="$OIFS"

    echo '<font face="arial black" color="black" size="3">To begin, select a header file from the list below:</font><br><br>
		<form id="form1" method="GET" action="/ShowHeader">
			<select name="AppID='${AppID}'&HeaderName" onchange="checkForm(this.value);">'
    echo $dropDownList
    echo '</select></form>
      		<div>
      		<br>'

	if [ -n "$HeaderName" ]
	then
		#Use theos to logify the header
		tmpDir="/Applications/iRE.app/tmp/"
		file="/Applications/iRE.app/tmp/Tweak.xm"

		#check if tmp directory exists
		if [ ! -d "$tmpDir" ]; then
			eval mkdir /Applications/iRE.app/tmp
		fi

		#check if "Tweak.xm" file exists
		if [ -f "$file" ]; then
			eval rm "$file"
		fi

		#nHeader=$(echo "$HeaderName" | sed 's/\\//g')
		#nHeaderName=$(echo "$nHeader" | sed 's/ /\\ /g')

		theosPath=$(grep -F theos /Applications/iRE.app/toolPaths.txt | cut -d":" -f2)
		eval "$theosPath/bin/logify.pl $HeaderName > /Applications/iRE.app/tmp/Tweak.xm"

		content=$(cat /Applications/iRE.app/tmp/Tweak.xm | sed 's/</\&lt;/g' | tr '\n' '!' | sed 's/!/<br>/g')

		echo '<div id="divLog" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; word-wrap: break-word;">
    		  <div id="divLog2" style="max-height:100%;overflow:auto;border:1px solid black; word-wrap: break-word;">
        	  <div id="divLog3" style="height:1500px; word-wrap: break-word;">
			  <pre class="output">'

		if [ "$content" != "" ]
		then
			echo $content
		else
			echo "<font color="red"><b>No Content To Logify</b></font>"
		fi
			echo '</pre>
			</div>
			</div>
			</div>'
	fi
fi
		echo '</div>
    </div>


  </body>
</html>'
