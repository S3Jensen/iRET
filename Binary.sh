#!/bin/sh

AppID=$1

binFile=$(find /var/mobile/Applications/"$AppID"/*.app -type f -exec file {} \; | grep Mach-O | cut -d":" -f1)

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
        if ( i == 0 ) tabLinks[id].className = "selected";
        i++;
      }

      // Hide all content divs except the first
      var i = 0;

      for ( var id in contentDivs ) {
        if ( i != 0 ) contentDivs[id].className = "tabContent hide";
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
      <li><a href="#binary">Binary Analysis</a></li>
      <li><a href="/Keychain?AppID='${AppID}'">Keychain Analysis</a></li>
      <li><a href="/Database?AppID='${AppID}'">Database Analysis</a></li>
      <li><a href="/Log?AppID='${AppID}'">Log Viewer</a></li>
      <li><a href="/PList?AppID='${AppID}'">Plist Viewer</a></li>
      <li><a href="/Headers?AppID='${AppID}'">Header Files</a></li>
      <li><a href="/Theos?AppID='${AppID}'">Theos</a></li>
      <li><a href="/Screenshot?AppID='${AppID}'">Screenshot</a></li>
      <li><a href="/">Home</a></li>
    </ul>

    <div class="tabContent" id="binary">
      <h2>Binary Analysis Results</h2>
      <div>'
      if [ -n "$binFile" ]
	  then
	  		fHeaders=$(otool -fv "$binFile" | grep architecture | tr '\n' '!' | sed 's/!/<br>/g' | sed 's/cputype\ (16777228)\ cpusubtype\ (0)/arm64/g')
			mHeaders=$(otool -hv "$binFile" | tr '\n' '!' | sed 's/!/<br>/g')
			cryptoInfo=$(otool -lv "$binFile" | grep -A 4 LC_ENCRYPTION_INFO | tr '\n' '!' | sed 's/!/<br>/g')
			stackSmashInfo=$(otool -Iv "$binFile" | grep stack_chk | tr '\n' '!' | sed 's/!/<br>/g')
			arcInfo=$(otool -Iv "$binFile" | grep _objc_release | tr '\n' '!' | sed 's/!/<br>/g')

			[ -n $fHeaders ] && fatHeaders="<font color="red"><b>No Fat Headers</b></font>" || fatHeaders=$fHeaders
			[ -n $stackSmashInfo ] && stack="<font color="red"><b>No Stack Smashing Protection</b></font>" || stack=$stackSmashInfo
			[ -n $arcInfo ] && arc="<font color="red"><b>No ARC Protection</b></font>" || arc=$arcInfo


        	echo '<p>Below are the results of the otool analysis.</p>
        	<table>
        		<tr>
        			<td>
        			<!-- If Fat Headers are present, show this -->'

        			if [ -n "$fHeaders" ]
        			then

        				echo '<b>Fat Headers</b><br>
        					<table class="output">
        						<tr>
        							<td>
        								<span class="output">
        									'${fatHeaders}'
        								</span>
        							</td>
        							<!--<td>&nbsp;</td>
        							<td valign="top">On 64-bit devices you can remove an architecture slice from the binary below.<br>
        							Select the arch slice to remove:-->
   								</tr>
   							</table>
   						<!-- End Fath Headers --> <br><br>'
   					fi

   						echo '<b>Mach-O Headers</br>
        				<table class="output">
        					<tr>
        						<td>
        					<span class="output">
        						'${mHeaders}'
        					</span>
        						</td>
   							</tr>
   						</table>
							<br><br>
						<table>
						<tr>
						<!-- Start Encryption Info Table Column -->
						<td valign="top">
							<b>Encryption Info</b>
   							<table class="output">
        						<tr>
        							<td>
        								<!--<pre class="output">-->
        								'${cryptoInfo}'
        								<!--</pre>-->
   									</td>
   								</tr>
   							</table>
   						</td>
   						<!-- End Encryption Info Table Column -->
   						<td valign="top" align="middle">
   						<!-- Start Stack-smashing Info Table Column -->
							<b>Stack Smashing Info</b><br>
							<table class="output">
        						<tr>
        							<td>
        								<span class="output">
        								 '${stack}'
										</span>
   									</td>
   								</tr>
   							</table>
   						<!-- End Stack-Smashing Info Table Column -->
   						</td>
   						<td valign="top" align="middle">
   						<!-- Start ARC Info Table Column -->
							<b>ARC Info</b><br>
							<table class="output">
        						<tr>
        							<td>
        								<span class="output">
											'${arc}'
										</span>
   									</td>
   								</tr>
   							</table>
   						<!-- End ARC Info Table Column -->
   						</td>
   						</tr>
   						</table>
						<!-- Start Load Commands Info
							<br><b>All Load Commands</b>
							<div id="div1" style="height:500px;position:relative;background-color:#d3d3d3;">
    							<div id="div2" style="max-height:100%;overflow:auto;border:1px solid black;">
        							<div id="div3" style="height:1500px;">
        								<pre class="output">
        								{ALL LOAD COMMANDS}
        								</pre>
        							</div>
    							</div>
							</div>
						End Load Commands Info -->
					</td>
        		</tr>
        	</table>'
        else
        		echo "<font color=""red""><b>The Binary Appears to be a Symbolic Link</b></font>"
        fi
      	echo '</div>
      </div>
    </div>
  </body>
</html>'
