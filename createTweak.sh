#!/bin/sh

tweak=$1
packageName=$2
projectName=$3
author=$4
bundleID=$5

/var/theos/bin/nic.pl <<EOF
$tweak
$packageName
$projectName
$author
$bundleID
EOF



if [ -d "/$projectName" ]; then
	mv "/$projectName" "/Applications/iRE.app/tweaks/$AppID/$projectName"
elif [ -d "/Applications/iRE.app/$projectName" ]; then
	mv "/Applications/iRE.app/$projectName" "/Applications/iRE.app/tweaks/$AppID/$projectName"
fi
