iRET
====
The iOS Reverse Engineering Toolkit is a toolkit designed to automate many of the common tasks associated with iOS penetration testing. It automates a many common tasks including:

 - binary analysis using otool
 - keychain analysis using keychain_dumper
 - reading database content using sqlite
 - reading log and plist files
 - binary decryption using dumpdecrypted
 - dumping binary headers using class_dump_z
 - creating, editing, installing theos tweaks

Installation:
  You can download the files and build the debian package yourself or you can simply install the iRET.deb package onto any jailbroken device using dpkg -i on the command line or by using iFile, which is available from Cydia. After it is installed, respiring the device and you should see a new "iRET" icon on the device.

Usage:
  Must be connected to a wireless network. Launch the application, click the "Start" button. It will then show the ip address and port number you should navigate to on your computer (computer must be connected to same wireless network as device). On first run, it will take a bit of time for the iRET tool to identify all of the required tools.


Dependencies:
  The following apps are required to be installed on the device (in addition to the tools required on the main page)
 - Python (2.5.1 or 2.7) (Need to be Cydia ‘Developer’)
 - coreutils
 - Erica Utilities
 - file
 - adv-cmds
 - Bourne-Again Shell
 - iOS Toolchain (coolstar version)
 - Darwin CC Tools (coolstar version)
 - An iOS SDK (presumably iOS 6.1 or 7.x) installed to $THEOS/sdks


Known Issues:
 - Issue of keeping a selected file in the dropdown, when the name contains a space in it.


Troubleshooting:
  To troubleshoot any issues. You can manually start the listener. First, ssh into the device, navigate to the /Applications/iRE.app directory and execute the "python iRE_Server.py" command.


Credits:

Special thanks to the following people

 - Bucky Spires (@gigabuck)
 - Richard Zuleg
 - Dan DeCloss (@wh33lhouse)
 - Dustin Howett (theos @DHowett)
 - StefanEsser (dumpdecrypted @i0n1c)
 - Patrick Toomey (keychain_dumper @patricktoomey)

All the members on irc.saurik.com #theos channel for their assistance.

For questions feel free to contact me on Twitter at @S3Jensen.
