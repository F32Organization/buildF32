#!/bin/bash

#Name of downloaded 1.6.4 repository.
DL1="164.zip"
#Name of downloaded 1.7.10 repository.
DL2="1710.zip"
#Name of md5 checksum file for downloaded 1.6.4 repository.
SUM1="new164sum.md5"
#Name of md5 checksum file for downloaded 1.7.10 repository.
SUM2="new1710sum.md5"
#Name of md5 checksum file for currently available 1.6.4 pack.
SUM3="old164sum.md5"
#Name of md5 checksum file for currently available 1.7.10 pack.
SUM4="old1710sum.md5"
#Folder where script actions take place, downloading and unzipping
GIT="/var/www/f32.me/public_html/git"
#Folder which contains publicly available packs and checksum files. Also known as web directory.
BASE="/var/www/f32.me/public_html"

#Switch to Git directory.
cd $GIT
#Fetch latest Github repositories.
wget --no-verbose https://github.com/F32Organization/Faithful32-1.6.4/archive/master.zip -O $DL1
wget --no-verbose https://github.com/F32Organization/Faithful32-1.7.10/archive/master.zip -O $DL2
#Generate MD5 checksums for new downloaded files.
md5sum $DL1 > $SUM1
md5sum $DL2 > $SUM2
#Strip file names from new checksum files before comparing sums. (Depends on replace command installed by package "mysql-server").
replace "164.zip" "" -- $SUM1
replace "1710.zip" "" -- $SUM2
#1.6.4 Handling.
#If there is no difference between the old and new checksum files, skip 1.6.4 pack build.
if diff $SUM3 $SUM1 >/dev/null ; then
	echo Skipping 1.6.4 build portion.
	#Delete the new download and checksum because they are unused.
	rm $DL1
	rm $SUM1
else
	#Unpack downloaded .zip file.
	unzip $DL1
	#Switch to unpacked directory for 1.6.4.
	cd ./Faithful32-1.6.4-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.6.4.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.6.4.zip /var/www/f32.me/public_html
	#Switch to git directory.
	cd $GIT
	#Remove unpacked folders.
	rm -r Faithful32-1.6.4-master
	#Delete old checksum file then replace it with the new one.
	rm $SUM3
	mv $SUM1 $SUM3
	#Strip filename from checksum.
	replace "$164.zip" "" -- $SUM3
	#Delete old downloaded file.
	rm $DL1
fi

#Switch back to git directory.
cd $GIT

#1.7.10 Handling.
#If there is no difference between the old and new checksum files, skip 1.7.10 pack build.
if diff $SUM4 $SUM2 >/dev/null ; then
	echo Skipping 1.7.10 build portion.
	#Delete the new download and checksum because they are unused.
	rm $DL2
	rm $SUM2
else
	#Unpack downloaded .zip file.
	unzip $DL2
	#Switch to unpacked directory for 1.7.10.
	cd ./Faithful32-1.7.10-master
	#Remove TODO folder and any *.md files.
	rm -r TODO/ ; rm *.md ; rm -r OldModTextures/
	#Package contents of unpacked directory into .zip file with silent and recursive modes on.
	zip -rq F32-1.7.10.zip *
	#Copy .zip file to web directory, replacing old version forcefully.
	cp -f F32-1.7.10.zip /var/www/f32.me/public_html
	#Switch to git directory.
	cd $GIT
	#Remove unpacked folders.
	rm -r Faithful32-1.7.10-master
	#Delete old checksum file then replace it with the new one.
	rm $SUM4
	mv $SUM2 $SUM4
	#Strip filename from checksum.
	replace "1710.zip" "" -- $SUM4
	#Delete old downloaded file.
	rm $DL2
fi

#Switch back to main directory.
cd $BASE

#Delete old md5 hash values.
rm 1710sum.md5
rm 164sum.md5

#Calculate new md5 hash values.
md5sum F32-1.6.4.zip > 164sum.md5
md5sum F32-1.7.10.zip > 1710sum.md5

#Strip file names from new checksum files. (Depends on replace command installed by package "mysql-server").
replace "F32-1.6.4.zip" "" -- 164sum.md5
replace "F32-1.7.10.zip" "" -- 1710sum.md5


#Exit the script with code 0 to indicate success. (Not currently used).
exit 0