#!/bin/sh

AppID=$1
Action=$2

if [ "$Action" == "Create" ]; then
	#create the theos tweak
	projectName=$3
	packageName=$4
	author=$5
	bundleID=$6
	lcprojName=${projectName,,}
	create="/Applications/iRE.app/createTweak.sh "5" "$projectName" "$packageName" "$author" "$bundleID""
	eval $create

	if [ ! -d "/Applications/iRE.app/tweaks" ]; then
		eval mkdir /Applications/iRE.app/tweaks
	fi

	if [ ! -d "/Applications/iRE.app/tweaks/$AppID" ]; then
		eval mkdir /Applications/iRE.app/tweaks/$AppID
	fi

	projName=$3
	pName=${projName,,}

	if [ -d "/$pName" ]; then
		moveIt="mv -f /$pName /Applications/iRE.app/tweaks/$AppID/$pName"
	elif [ -d "/Applications/iRE.app/$pName" ]; then
		moveIt="mv -f /Applications/iRE.app/$pName /Applications/iRE.app/tweaks/$AppID/$pName"
	fi

	eval $moveIt
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
        if ( i == 6 ) tabLinks[id].className = "selected";
        i++;
      }

      // Hide all content divs except the first
      var i = 6;

      for ( var id in contentDivs ) {
        if ( i != 6 ) contentDivs[id].className = "tabContent hide";
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
      <li><a href="/Headers?AppID='${AppID}'">Header Files</a></li>
      <li><a href="#">Theos</a></li>
      <li><a href="/Screenshot?AppID='${AppID}'">Screenshot</a></li>
      <li><a href="/">Home</a></li>
    </ul>

    <!-- System Log -->
    <div class="tabContent" id="log">
      <div>'
	if [ ! -d "/Applications/iRE.app/tweaks/$AppID" ]; then
		if [ "$Action" == "New" ]; then

			#Get BundleID for selected Application
			InfoFile=$(find /var/mobile/Applications/"$AppID"/*.app -maxdepth 1 -name Info.plist -type f)
			BundleID=$(plutil -key CFBundleIdentifier "$InfoFile")

			echo '<!-- Create Theos Tweak -->
      		<h2>Below is a form you can use to create a new theos tweak for this application.</h2><br>

			<form id="frmTheos" method="GET" action="/CreateTweak">
					<input type="hidden" name="AppID" value="'"$AppID"'">
			<table width="auto" style="background-color:#ffffff; border:1px solid black;">
				<tr>
					<td>Project Name:</td>
					<td><input type="text" name="ProjectName" size="30"></td>
				</tr>
				<tr>
					<td>Package Name:</td>
					<td><input type="text" name="PackageName" size="30"></td>
				</tr>
				<tr>
					<td>Author:</td>
					<td><input type="text" name="Author" size="30"></td>
				</tr>
				<tr>
					<td>Bundle ID:</td>
					<td><input type="text" name="BundleID" size="30" readonly disabled value="'"$BundleID"'">
						<input type="hidden" name="BundleID" value="'"$BundleID"'">
					</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="submit" value="Submit"></td>
				</tr>
			</table>
			</form>'
		fi
	else

    		echo '<font face="arial black" color="black" size="3">View/Edit an existing theos file below:</font><br><br>
				<form id="form1" method="GET" action="/EditTweak">
					<select name="AppID='${AppID}'&FileName" onchange="checkForm(this.value);">
					<option value="">Select a Theos File</option>'
    				tweakFile=$(find /Applications/iRE.app/tweaks/"$AppID" -name Tweak.xm)
    				makeFile=$(find /Applications/iRE.app/tweaks/"$AppID" -name Makefile)
    				mk=$(basename $makeFile)
    				tk=$(basename $tweakFile)
    				echo "<option value="$makeFile">"$mk"</option>"
    				echo "<option value="$tweakFile">"$tk"</option>"
    		echo '</select></form>'

    	if [ "$Action" == "Edit" -o "$Action" == "Build" ]; then
			fileName=$3
			fileContent=$(cat $fileName)

			echo '<form id="frmSave" method="POST" action="/SaveTweak">
					<input type="hidden" name="AppID" value="'"$AppID"'">
					<input type="hidden" name="fileName" value="'"$fileName"'">
					<textarea name="txtContent" rows="20" cols="100">'
				echo "$fileContent"
			echo '</textarea><br>
				<input type="submit" value="Save">
				</form>
				<form id="frmBuild" method="GET" action="/BuildTweak">
					<input type="hidden" name="AppID" value="'"$AppID"'">
					<input type="hidden" name="FileName" value="'"$fileName"'">
					<input type="submit" value="Build">
				</form>
				</div>'
				if [ "$Action" == "Build" ]; then
    				projName=$(ls /Applications/iRE.app/tweaks/"$AppID"/)
    				cmd=$(make -C /Applications/iRE.app/tweaks/"$AppID"/"$projName" > /Applications/iRE.app/tweaks/"$AppID"/"$projName"/buildResult.txt)
    				eval "$cmd"

					#read the buildResult.txt file
					result=$(cat /Applications/iRE.app/tweaks/"$AppID"/"$projName"/buildResult.txt | tr '\n' '!' | sed 's/!/<br>/g')
					buildDir="/Applications/iRE.app/tweaks/"$AppID"/"$projName"/obj/"

					if [ -d "$buildDir" ]; then
						#copy plist and dylib files
						pFile=$(find /Applications/iRE.app/tweaks/"$AppID"/"$projName" -name '*.plist' -type f)
						dylibFile=$(find /Applications/iRE.app/tweaks/"$AppID"/"$projName"/obj -name '*.dylib' -type f)
						eval cp -f $pFile /Library/MobileSubstrate/DynamicLibraries
						eval cp -f $dylibFile /Library/MobileSubstrate/DynamicLibraries
						echo "<font color=""red"">Tweak has been built and installed in /Library/MobileSubstrate/DynamicLibraries.</font>"
					else
						echo "<font color=""red"">Tweak did not build, check results below.</font>"
					fi

    				echo '<div id="divLog" style="height:300px;position:relative;background-color:#d3d3d3; width:50%; word-wrap: break-word;">
    		  			<div id="divLog2" style="max-height:100%;overflow:auto;border:1px solid black; word-wrap: break-word;">
        	  			<div id="divLog3" style="height:500px; word-wrap: break-word;">'
							echo $result
						echo '</div>
						</div>
					</div>'
				fi

				echo '</div>'

    		fi
    	fi
  echo '</body>
</html>'
