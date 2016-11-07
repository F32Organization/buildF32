#!/bin/bash

#Name of downloaded 1.10.2 repository.
DL1="1102.zip"
#Name of downloaded 1.7.10 repository.
DL2="1710.zip"
#Folder where script actions take place, downloading and unzipping
GIT="/var/www/f32.me/public_html/git/"
#Folder which contains publicly available packs and checksum files. Also known as web directory.
BASE="/var/www/f32.me/public_html/"
#Final .zip name for 1.10.2
F1102="F32-1.10.2.zip"
#Final .zip name for 1.7.10
F1710="F32-1.7.10.zip"

#Download and initial checksum handling portion.
#Switch to Git directory.
cd $GIT
#Fetch latest Github repositories. --no-verbose reduces output to basic information and error messages. -O will write to a custom file name instead of the same as set by the download server, also automatically sets number of tries to 1.
wget --no-verbose https://github.com/F32Organization/Faithful32-1.10.2/archive/master.zip -O $DL1
wget --no-verbose https://github.com/F32Organization/Faithful32-1.7.10/archive/master.zip -O $DL2
#Generate md5 checksum values for initial zip files. Pipe the output into .txt files. Use replace command to remove names.
md5sum $DL1 &> ./sum1102new.txt
md5sum $DL2 &> ./sum1710new.txt
#replace command to remove names.
replace "1102.zip" "" -- sum1102new.txt
replace "1710.zip" "" -- sum1710new.txt

#Unpack downloaded .zip file. -q performs the operation with less screen output. -qq would be even quieter.
unzip -q $DL1
#Switch to unpacked directory for 1.10.2.
cd ./Faithful32-1.10.2-master
#Remove TODO folder and any *.md files.
rm -r TODO/ ; rm *.md
#Package contents of unpacked directory into .zip file with silent and recursive modes on.
zip -rq $F1102 *
#Copy .zip file to web directory, replacing old version forcefully.
cp -f $F1102 $BASE
#Switch back to Git directory in preparation for removing unpacked folder.
cd $GIT
#Remove unpacked folder.
rm -r Faithful32-1.10.2-master
#Delete the newly downloaded 1.10.2 repository either because its contents match the already built pack or because building off it has finished.
rm $DL1

#Unpack downloaded .zip file. -q performs the operation with less screen output. -qq would be even quieter.
unzip -q $DL2
#Switch to unpacked directory for 1.7.10.
cd ./Faithful32-1.7.10-master
#Remove TODO folder and any *.md files.
rm -r TODO/ ; rm *.md ; rm -r OldModTextures/ ; rm -r DevModTextures/
#Package contents of unpacked directory into .zip file with silent and recursive modes on.
zip -rq $F1710 *
#Copy .zip file to web directory, replacing old version forcefully.
cp -f $F1710 $BASE
#Switch back to Git directory in preparation for removing unpacked folder.
cd $GIT
#Remove unpacked folders.
rm -r Faithful32-1.7.10-master
#Delete the newly downloaded 1.7.10 repository either because its contents match the already built pack or because building off it has finished.
rm $DL2

#Switch back to main web folder to make md5 checksum files.
cd $BASE
#Do md5 value generation for final zip files.
md5sum $F1102 &> ./sum1102.txt
md5sum $F1710 &> ./sum1710.txt
#replace command to remove names.
replace "F32-1.10.2.zip" "" -- sum1102.txt
replace "F32-1.7.10.zip" "" -- sum1710.txt

#Exit the script with code 0 to indicate success. (Not currently used).
exit 0