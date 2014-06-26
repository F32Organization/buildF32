#!/bin/bash

#Restart web server
/usr/bin/nginx -s stop
/usr/bin/nginx
GIT_DIR="/usr/share/nginx/faithful/git"
WWW_DIR="/usr/share/nginx/faithful/www"
ZIP_FILE="latest.zip"
# Fetch changes.
cd "$GIT_DIR"
if (( $(git pull | grep -c 'Already up-to-date') ))
then
  if [ -e "$WWW_DIR/$ZIP_FILE" ]
  then
    exit 0
  fi
fi
# Package resource pack
rm "$ZIP_FILE"
zip -0 -rq "$ZIP_FILE" assets Reika pack.mcmeta pack.png README.md

if [ -e "$WWW_DIR/$ZIP_FILE" ]
then
  if [ $(md5sum "$ZIP_FILE" | awk '{print $1}') == $(md5sum "$WWW_DIR/$ZIP_FILE" | awk '{print $1}') ]
  then
    exit 0
  fi
fi

cp -f "$ZIP_FILE" "$WWW_DIR/$ZIP_FILE"
exit 0
