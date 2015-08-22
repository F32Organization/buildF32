#!/bin/bash

#Name of downloaded 1.6.4 repository.
DL1="164.zip"
#Name of downloaded 1.7.10 repository.
DL2="1710.zip"
#Name of md5 checksum file for downloaded 1.6.4 repository before move.
SUM1="/var/www/f32.me/public_html/git/new164sum.md5"
#Name of md5 checksum file for downloaded 1.7.10 repository before move.
SUM2="/var/www/f32.me/public_html/git/new1710sum.md5"
#Name of md5 checksum file for currently available 1.6.4 pack.
SUM3="/var/www/f32.me/public_html/164sum.md5"
#Name of md5 checksum file for currently available 1.7.10 pack.
SUM4="/var/www/f32.me/public_html/1710sum.md5"
#Name of md5 checksum file for downloaded 1.6.4 repository after move.
SUM5="/var/www/f32.me/public_html/new164sum.md5"
#Name of md5 checksum file for downloaded 1.7.10 repository after move.
SUM6="/var/www/f32.me/public_html/new1710sum.md5"
#Folder where script actions take place, downloading and unzipping
GIT="/var/www/f32.me/public_html/git/"
#Folder which contains publicly available packs and checksum files. Also known as web directory.
BASE="/var/www/f32.me/public_html/"

#Download and initial checksum handling portion.
#Switch to Git directory.
cd $GIT
#Fetch latest Github repositories. --no-verbose reduces output to basic information and error messages. -O will write to a custom file name instead of the same as set by the download server, also automatically sets number of tries to 1.
wget --no-verbose https://github.com/F32Organization/Faithful32-1.6.4/archive/master.zip -O $DL1
wget --no-verbose https://github.com/F32Organization/Faithful32-1.7.10/archive/master.zip -O $DL2
#Generate md5 checksums for new downloaded files.
md5sum $DL1 > $SUM1
md5sum $DL2 > $SUM2
#Strip file names from new checksum files before comparing sums. (Depends on replace command installed by package "mysql-server").
replace "164.zip" "" -- $SUM1
replace "1710.zip" "" -- $SUM2
#Move new md5 checksum files to web directory.
mv $SUM1 $BASE
mv $SUM2 $BASE

#Compare new 1.6.4 checksum file to old/public checksum. >/dev/null directs the output redirects the stdout and stderr output to /dev/null, suppressing all process output. 
#If there is no difference the 1.6.4 build portion will be skipped and the new md5 checksum file will be discarded instead of renamed later.
if diff $SUM3 $SUM5 >/dev/null ; then 
	#Set 1.6.4 build variable to false. Stops that section from running.
	B164="false"
	#Discard new md5 checksum file because its identical to old file.
	rm $SUM5
##Set 1.6.4 build variable to true, allows that section to run.
else B164="true" 
fi

#Compare new 1.7.10 checksum file to old/public checksum. >/dev/null directs the output redirects the stdout and stderr output to /dev/null, suppressing all process output.
#If there is no difference the 1.7.10 build portion will be skipped and the new md5 checksum file will be discarded instead of renamed later.
if diff $SUM4 $SUM6 >/dev/null ; then
	#Set 1.7.10 build variable to false. Stops that section from running.
	B1710="false"
	#Discard new md5 checksum file because its identical to old file.
	rm $SUM6
#Set 1.7.10 build variable to true, allows that section to run.
else B1710="true"
fi

#1.6.4 build portion.
#Check to see if build variable is set to true or false, then perform appropriate actions.
if [ "$B164" == "true" ] ; then
	#Unpack downloaded .zip file. -q performs the operation with less screen output. -qq would be even quieter.
	unzip -q $DL1
	#Switch to unpacked directory for 1.6.4.
	cd ./Faithful32-1.6.4-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md ; DevModTextures/
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.6.4.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.6.4.zip $BASE
	#Switch back to Git directory in preparation for removing unpacked folder.
	cd $GIT
	#Remove unpacked folder.
	rm -r Faithful32-1.6.4-master
	#Delete old checksum file then replace it with the new one.
	rm $SUM3
	mv $SUM5 $SUM3	
fi
#Delete the newly downloaded 1.6.4 repository either because its contents match the already built pack or because building off it has finished.
rm $DL1

#Switch back to Git directory
cd $GIT

#1.7.10 build portion.
#Check to see if build variable is set to true or false, then perform appropriate actions.
if [ "$B1710" == "true" ] ; then
	#Unpack downloaded .zip file. -q performs the operation with less screen output. -qq would be even quieter.
	unzip -q $DL2
	#Switch to unpacked directory for 1.7.10.
	cd ./Faithful32-1.7.10-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md ; rm -r OldModTextures/
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.7.10.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.7.10.zip $BASE
	#Switch back to Git directory in preparation for removing unpacked folder.
	cd $GIT
	#Remove unpacked folders.
	rm -r Faithful32-1.7.10-master
	#Delete old checksum file then replace it with the new one.
	rm $SUM4
	mv $SUM6 $SUM4
fi
#Delete the newly downloaded 1.7.10 repository either because its contents match the already built pack or because building off it has finished.
rm $DL2

#Exit the script with code 0 to indicate success. (Not currently used).
exit 0
