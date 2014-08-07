#!/bin/bash

#Switch to fetching directory
cd /var/www/html/faithful/git
#Empty fetching directory
rm -r *
#Fetch latest Git repository and name latest.zip
wget https://github.com/smenes/Faithful32/archive/faithful32_1.6.4.zip -O latest.zip
#Unpack latest.zip
unzip latest.zip
#Switch to unpacked directory within fetching directory
cd /var/www/html/faithful/git/Faithful32-faithful32_1.6.4
#Package contents of unpacked directory into F32.zip with compression off, silent mode on, and recursive mode on
zip -0 -rq F32.zip *
#Copy F32.zip to web directory, replacing old version
cp -f F32.zip /var/www/html/faithful
#Exit the script with code reading successful
exit 0
