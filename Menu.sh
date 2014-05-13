#!/bin/sh

function checkInstall()
{
  local path

  case $1 in
        otool)
                path=$(which otool)
		echo "$path"
                ;;
        sqlite3)
                path=$(which sqlite3)
		echo "$path"
                ;;
        file)
                path=$(which file)
		echo "$path"
                ;;
        plutil)
                path=$(which plutil)
		echo "$path"
                ;;
        theos)
                path=$(find / -name theos -type d)
		echo "$path"
                ;;
        dumpdecrypted)
                path=$(find / -name dumpdecrypted.dylib -type f)
		echo "$path"
                ;;
        keychainDumper)
                path=$(find / -name keychain_dumper -type f)
		echo "$path"
         	;;
		classDumpZ)
				path=$(find / -name class-dump-z -type f)
		echo "$path"
			;;
        *) break
  esac

}


#File that stores paths of tools
file="/Applications/iRE.app/toolPaths.txt"

#check if "toolPaths.txt" file exists
if [ -f "$file" ]
then
	#File already exists. Read it and check if any tool paths are missing

	while IFS=$':' read -r -a myArray
	do
        toolName=${myArray[0]}
        toolPath=${myArray[1]}

        if [ ! -n "$toolPath" ]
        then
                toolArray+=($toolName)
        fi
	done < "$file"


	if [ ${#toolArray[@]} -ge "1" ]
	then
        #echo "Inside tool array"
        for i in "${toolArray[@]}"
        do
                #echo $i
                result=$(checkInstall $i)
                #echo "Path: $result"

                if [ "$result" != "" ]
                then
                        sed -i "s,"$i:","$i:$result",g" /Applications/iRE.app/toolPaths.txt
                        #mv temp.txt toolPaths.txt
                fi
        done
	fi

else
	#First time tool has run, check if tools are installed

	#OTOOL
	otoolPath=$(checkInstall otool)
	strTools="otool:$otoolPath\n"

	#SQLITE
	sqlitePath=$(checkInstall sqlite3)
	strTools+="sqlite3:$sqlitePath\n"

	#FILE
	fileToolPath=$(checkInstall file)
	strTools+="file:$fileToolPath\n"

	#PLUTIL
	plutilPath=$(checkInstall plutil)
	strTools+="plutil:$plutilPath\n"

	#THEOS
	theosPath=$(checkInstall theos)
	strTools+="theos:$theosPath\n"

	#DUMPDECRYPTED
	dumpPath=$(checkInstall dumpdecrypted)
	strTools+="dumpdecrypted:$dumpPath\n"

	#KEYCHAIN
	keychainPath=$(checkInstall keychainDumper)
	strTools+="keychainDumper:$keychainPath\n"

	#CLASS-DUMP-Z
	classDumpPath=$(checkInstall classDumpZ)
	strTools+="classDumpZ:$classDumpPath"

	echo -e $strTools > /Applications/iRE.app/toolPaths.txt
fi

#Read if the paths of the tools and show installed or not

#check if "toolPaths.txt" file exists
if [ -f "$file" ]
then

        while IFS=':' read -r f1 f2
        do
                case $f1 in
                        otool)
                                if [ "$f2" != "" ]
                                then
                                        otoolInstalled="<font color="green">Installed</font>"
                                else
                                        otoolInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        sqlite3)
                                if [ "$f2" != "" ]
                                then
                                        sqliteInstalled="<font color="green">Installed</font>"
                                else
                                        sqliteInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        file)
                                if [ "$f2" != "" ]
                                then
                                        fileInstalled="<font color="green">Installed</font>"
                                else
                                        fileInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        plutil)
                                if [ "$f2" != "" ]
                                then
                                        plutilInstalled="<font color="green">Installed</font>"
                                else
                                        plutilInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        theos)
                                if [ "$f2" != "" ]
                                then
                                        theosInstalled="<font color="green">Installed</font>"
                                else
                                        theosInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        dumpdecrypted)
                                if [ "$f2" != "" ]
                                then
                                        dumpInstalled="<font color="green">Installed</font>"
                                else
                                        dumpInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        keychainDumper)
                        		if [ "$f2" != "" ]
                                then
                                        keychainInstalled="<font color="green">Installed</font>"
                                else
                                        keychainInstalled="<font color="red">Not Installed</font>"
                                fi
                                ;;
                        classDumpZ)
                        		if [ "$f2" != "" ]
                        		then
                        				classDumpZInstalled="<font color="green">Installed</font>"
                        		else
                        				classDumpZInstalled="<font color="red">Not Installed</font>"
                        		fi
                        		;;
                        *) break
                    esac

        done < "$file"

else
        echo "/Applications/iRE.app/toolPaths.txt File Does Not Exist"
fi


guids=$(ls /var/mobile/Applications/*/*.app/Info.plist |sort | cut -d"/" -f5)
dropDownList="<option value=>Select Application</option>"

for a in ${guids}
 do
    name=$( ls /var/mobile/Applications/$a/*.app/Info.plist | cut -d"/" -f6 | cut -d. -f1 )
    dropDownList+="<option value="$a">"$name"</option>"
done

echo '<html>
<head>
<meta charset="UTF-8">
<title>iRET - iOS Reverse Engineering Toolkit</title>
</head>
<script type="text/javascript">
	function submitForm(strValue)
	{
		var oForm = document.getElementById("form1");
		oForm.action = "/Binary?" + strValue;
		oForm.submit();
	}
</script>
<body bgcolor="#0377CC">
<table width="100%" height="100%">
  <tr>
    <td align="center" valign="center">
    	<table style="background-color:white;border:1px solid black;" height="90%" width="90%">
    		<tr>
    			<td align="center" valign="top" colspan="2" height="20%"><font face="arial black" color="black" size="6">Welcome to iRET<br>The  iOS Reverse Engineering Toolkit</font></td>
    		</tr>
    		<tr>
    			<td align="center" valign="top" width="50%">
    				<table style="background-color:white;border:1px solid black;" height="90%" width="90%">
						<tr>
							<td align="center" width="50%" cellpadding="4">
								<table style="background-color:white;border:1px solid black;" height="100%" width="100%">
									<tr>
										<td valign="top">
											<center><font face="arial black" color="black" size="3">What is in the toolkit?</font></center><br><br>
												<font face="arial" color="black" size="3">
												<span style="padding:150px">- oTool ('${otoolInstalled}')</span><br>
												<span style="padding:150px">- dumpDecrypted ('${dumpInstalled}')</span><br>
												<span style="padding:150px">- Sqlite ('${sqliteInstalled}')</span><br>
												<span style="padding:150px">- Theos ('${theosInstalled}')</span><br>
                                                <span style="padding:150px">- Keychain_dumper ('${keychainInstalled}')</span><br>
											    <span style="padding:150px">- file ('${fileInstalled}')</span><br>
                                                <span style="padding:150px">- plutil ('${plutilInstalled}')</span><br>
                                                <span style="padding:150px">- class-dump-z ('${classDumpZInstalled}')</span>
												<br><br>
												<span style="padding:100px">Note: All tools listed above must be installed.</span></font>
										</td>
									</tr>
								</table>
							</td>
							<td>
								<table style="background-color:white;border:1px solid black;" height="100%" width="100%">
									<tr>
										<td valign="top">
											<center><font face="arial black" color="black" size="3">To begin, select an app from the list below:</font><br><br>
											<form id="form1" method="GET">
											<select name="AppID" onchange="submitForm(this.value);">'
    											echo ${dropDownList}
    										echo '</select></form></center>
										</td>
									</tr>
								</table>
							</td>
						</tr>
    				</table>
    			</td>
    		<tr>
    	</table>
    </td>
  </tr>
</table>
</body>
</html>'
