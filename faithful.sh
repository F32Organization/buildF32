#!/bin/bash

#Switch to fetching directory
cd /var/www/html/faithful/git
#Fetch latest Git repositories.
wget https://github.com/F32Organization/Faithful32-1.6.4/archive/master.zip -O 1.6.4.zip
wget https://github.com/F32Organization/Faithful32-1.7.10/archive/master.zip -O 1.7.10.zip
#Unpack downloaded .zip files.
unzip 1.6.4.zip
unzip 1.7.10.zip
#Switch to unpacked directory for 1.6.4
cd /var/www/html/faithful/git/Faithful32-1.6.4-master
#Remove TODO folder and any *.md files
rm -r TODO/ ; rm *.md
#Package contents of unpacked directory into .zip file with silent and recursive modes on
zip -rq F32-1.6.4.zip *
#Copy .zip file to web directory, replacing old version forcefully
cp -f F32-1.6.4.zip /var/www/html/faithful
#Switch to unpacked directory for 1.7.10
cd /var/www/html/faithful/git/Faithful32-1.7.10-master
#Remove TODO folder and any *.md files
rm -r TODO/ ; rm *.md
#Package contents of unpacked directory into .zip file with silent and recursive modes on
zip -rq F32-1.7.10.zip *
#Copy .zip file to web directory, replacing old version forcefully
cp -f F32-1.7.10.zip /var/www/html/faithful
#Empty fetching directory
cd /var/www/html/faithful/git
rm -r *
#Exit the script with code 0 to indicate success.
exit 0
