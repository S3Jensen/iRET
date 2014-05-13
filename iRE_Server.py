#iRET web server project
#Authors: Richard Zuleg, Steve Jensen
#Version 0.9_1

import string,cgi,time,os,urllib
from os import curdir, sep
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

applicationPath = "/Applications/iRE.app/"
logFile = applicationPath + "iRE_Server.log"

class SimpleHandler(BaseHTTPRequestHandler):

    def Menu(self):
        try:
              	import subprocess as sub

                currentPath = applicationPath + "Menu.sh"
            	p = sub.Popen(["sh", currentPath],stdout=sub.PIPE,stderr=sub.PIPE)
                output, errors = p.communicate()

                print errors
                f=open(logFile, 'w')
                #f.write('Menu.sh was called #1')
                f.write(errors)
                #f.write(output)
                f.close()


            	self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	return
        except:
            	return


    def do_GET(self):
        try:
            print self.path
            if ( self.path == "/" ):
               	import subprocess as sub
                currentPath = applicationPath + "Menu.sh"
            	p = sub.Popen(["sh", currentPath],stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                print errors
                f=open(logFile, 'w')
                #self.wfile.write('Menu.sh was called #2')
                f.write(errors)
                #f.write(output)
                f.close()


                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	return

			#BINARY TAB

            if ( self.path.startswith("/Binary") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Binary.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		#print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

            #BINARY TAB

            if ( self.path.startswith("/Screenshot") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Screenshot.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		#print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#KEYCHAIN TAB

            if ( self.path.startswith("/Keychain") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Keychain.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		#print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#LOG TAB

            if ( self.path.startswith("/Log") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Log.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		#print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#VIEW LOG

            if ( self.path.startswith("/ViewLog") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		print "about to split"
		db=appTo.split("&Log=")[1].split("&EOFname=")[0]
		print db
		print appTo
		print "and again"
            	app=appTo.split("AppID=")[1].split("&")[0]
		print app
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Log.sh'+' '+'\''+app+'\''+' '+'\''+db+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#DATABASE TAB

            if ( self.path.startswith("/Database") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Database.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#SHOW DATABASE
            if ( self.path.startswith("/ShowTables") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		print "about to split"
		db=appTo.split("&DB=")[1].split("&EOFname=")[0]
		print db
		print appTo
		print "and again"
            	app=appTo.split("AppID=")[1].split("&")[0]
		print app
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Database.sh'+' '+'\''+app+'\''+' '+'\''+db+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

            #PLIST TAB

            if ( self.path.startswith("/PList") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'PList.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#SHOW PLIST FILE
            if ( self.path.startswith("/PFile") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		print "about to split"
		db=appTo.split("&PFile=")[1].split("&EOFname=")[0]
		print db
		print appTo
		print "and again"
            	app=appTo.split("AppID=")[1].split("&")[0]
		print app
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'PList.sh'+' '+'\''+app+'\''+' '+'\''+db+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

            #HEADERS TAB

            if ( self.path.startswith("/Headers") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Headers.sh'+' '+'\''+app+'\''
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#SEARCH HEADERS
            if ( self.path.startswith("/SearchHeaders") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		print "about to split"
		db=appTo.split("&SearchText=")[1].split("&EOFname=")[0]
		print db
		print appTo
		print "and again"
            	app=appTo.split("AppID=")[1].split("&")[0]
		print app
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'PList.sh'+' '+'\''+app+'\''+' '+'\''+db+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

            		#SHOW HEADER CONTENT
            if ( self.path.startswith("/ShowHeader") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		print "about to split"
		db=appTo.split("&HeaderName=")[1].split("&EOFname=")[0]
		print db
		print appTo
		print "and again"
            	app=appTo.split("AppID=")[1].split("&")[0]
		print app
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Headers.sh'+' '+'\''+app+'\''+' '+'\''+db+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return


            #THEOS TAB

            if ( self.path.startswith("/Theos") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
            	app=appTo.split("AppID=")[1].split("&EOFname=")[0]
            	#print app
            	if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Theos.sh'+' '+'\''+app+'\''+' \"New\"'
                command_line='\''+'sh'+'\' '+command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()

                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)

            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return


			#THEOS TWEAK - CREATE
            if ( self.path.startswith("/CreateTweak") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	#print appTo
            	appTo=appTo.replace("+",'\\ ')
		bundle=appTo.split("&BundleID=")[1].split("&EOFname=")[0]
		auth=appTo.split("&Author=")[1].split("&")[0]
		package=appTo.split("&PackageName=")[1].split("&")[0]
		project=appTo.split("&ProjectName=")[1].split("&")[0]
            	app=appTo.split("AppID=")[1].split("&")[0]
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Theos.sh'+' '+'\''+app+'\''+' \"Create\"'+' '+'\''+project+'\''+' '+'\''+package+'\''+' '+'\''+auth+'\''+' '+'\''+bundle+'\''
                command_line='\''+'sh'+'\' '+command_line
		#print command_line
            	import shlex
            	args = shlex.split(command_line)
		#print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	if (errors):
            		#print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#THEOS TWEAK - EDIT
            if ( self.path.startswith("/EditTweak") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		filename=appTo.split("&FileName=")[1].split("&EOFname=")[0]
            	app=appTo.split("AppID=")[1].split("&")[0]
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Theos.sh'+' '+'\''+app+'\''+' \"Edit\"'+' '+'\''+filename+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return

			#THEOS TWEAK - SAVE
            if ( self.path.startswith("/SaveTweak") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
		filename=appTo.split("&FileName=")[1].split("&EOFname=")[0]
            	app=appTo.split("AppID=")[1].split("&")[0]
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Theos.sh'+' '+'\''+app+'\''+' \"Save\"'+' '+'\''+filename+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return


			#THEOS TWEAK - BUILD
            if ( self.path.startswith("/BuildTweak") ):
            	import subprocess as sub
            	appTo=urllib.unquote(self.path)
            	print appTo
            	appTo=appTo.replace("+",'\\ ')
            	filename=appTo.split("&FileName=")[1].split("&EOFname=")[0]
            	app=appTo.split("AppID=")[1].split("&")[0]
		if ( app.startswith("/") ):
            		app="--direct "+app.rpartition("/")[0]+"/"
            	command_line=applicationPath+'Theos.sh'+' '+'\''+app+'\''+' \"Build\"'+' '+'\''+filename+'\''
                command_line='\''+'sh'+'\' '+command_line
		print command_line
            	import shlex
            	args = shlex.split(command_line)
		print args
            	p = sub.Popen(args,stdout=sub.PIPE,stderr=sub.PIPE)
            	output, errors = p.communicate()
                self.send_response(200)
            	self.send_header('Content-type',        'text/html')
            	self.end_headers()
            	self.wfile.write(output)
            	if (errors):
            		print errors
            		f=open(logFile, 'w')
                	f.write(errors)
                	f.close()
            		return
	except:
		return

    def do_POST(self):
    	try:
    		if ( self.path.startswith("/SaveTweak") ):
        		form = cgi.FieldStorage(  fp=self.rfile, headers=self.headers, environ={'REQUEST_METHOD':'POST', 'CONTENT_TYPE':self.headers['Content-Type'], })
			app=form["AppID"].value
			fileName=form["fileName"].value
			content=form["txtContent"].value
        		d = open(fileName,'w')
        		d.write(content)
        		d.close()
            	self.send_response(301)
            	self.end_headers()
            	self.wfile.write("<html><head><meta http-equiv='refresh' content='2;URL=/EditTweak?AppID="+app+"&FileName="+fileName+"'/></head><body bgcolor=""#377CC2""><h2><font color=""#ffffff"">Changes Saved!</font></h2></html>");
        	if (errors):
        		print errors
        		f=open(logFile, 'w')
                f.write(errors)
                f.close()
        	return
        except:
        	return

def main():
    try:
        server = HTTPServer(('', 5555), SimpleHandler)
        print 'Starting Server...'

            #f=open(logFile, 'w')
            #f.write('START UP! -- \n')
            #f.close()

        server.serve_forever()
    except KeyboardInterrupt:
        print '^C -> stopping server'
        server.socket.close()

if __name__ == '__main__':
    main()
