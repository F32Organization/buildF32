#!/bin/bash

#Switch to fit directory.
cd ./git
#Fetch latest Git repositories.
wget --no-verbose https://github.com/F32Organization/Faithful32-1.6.4/archive/master.zip -O 164.zip
wget --no-verbose https://github.com/F32Organization/Faithful32-1.7.10/archive/master.zip -O 1710.zip
#Generate MD5 checksums for new downloaded files.
md5sum 164.zip > new164sum.md5
md5sum 1710.zip > new1710sum.md5
#Strip file names from new checksum files before comparing sums. (Depends on replace command installed by package "mysql-server").
replace "164.zip" "" -- new164sum.md5
replace "1710.zip" "" -- new1710sum.md5
#Compare MD5 checksums of new downloaded files to old downloaded files. This decides which (if any) portions of the script need to run.
#1.6.4 Handling.
if diff old164sum.md5 new164sum.md5 >/dev/null ; then
	echo Skipping 1.6.4 build portion.
	#Delete the new download and checksum because they are unused.
	rm 164.zip
	rm new164sum.md5
else
	#Unpack downloaded .zip file.
	unzip 164.zip
	#Switch to unpacked directory for 1.6.4.
	cd ./Faithful32-1.6.4-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.6.4.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.6.4.zip /var/www/html/faithful
	#Switch to git directory.
	cd /var/www/html/faithful/git
	#Remove unpacked folders.
	rm -r Faithful32-1.6.4-master
	#Delete old checksum file then replace it with the new one.
	rm old164sum.md5
	mv new164sum.md5 old164sum.md5
	#Strip filename from checksum.
	replace "164.zip" "" -- old164sum.md5
	#Delete old downloaded file.
	rm 164.zip
fi

#Switch back to git directory.
cd /var/www/html/faithful/git

#1.7.10 Handling.
if diff old1710sum.md5 new1710sum.md5 >/dev/null ; then
	echo Skipping 1.7.10 build portion.
	#Delete the new download and checksum because they are unused.
	rm 1710.zip
	rm new1710sum.md5
else
	#Unpack downloaded .zip file.
	unzip 1710.zip
	#Switch to unpacked directory for 1.7.10.
	cd ./Faithful32-1.7.10-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.7.10.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.7.10.zip /var/www/html/faithful
	#Switch to git directory.
	cd /var/www/html/faithful/git
	#Remove unpacked folders.
	rm -r Faithful32-1.7.10-master
	#Delete old checksum file then replace it with the new one.
	rm old1710sum.md5
	mv new1710sum.md5 old1710sum.md5
	#Strip filename from checksum.
	replace "1710.zip" "" -- old1710sum.md5
	#Delete old downloaded file.
	rm 1710.zip
fi

#Exit the script with code 0 to indicate success. (Not currently used)
exit 0
