#!/bin/bash

rem This sets the directory that Git is in.
GIT_DIR="/usr/share/nginx/faithful/git"
rem This sets the directory the web server serves to the public
WWW_DIR="/usr/share/nginx/faithful/www"
rem This sets the name of the zip file.
ZIP_FILE="F32.zip"

rem Switch to Git directory.
cd "$GIT_DIR"
rem If Git is already up to date and the output zip already exists, cancel.
if (( $(git pull | grep -c 'Already up-to-date') ))
then
  if [ -e "$WWW_DIR/$ZIP_FILE" ]
  then
    exit 0
  fi
fi

rem Delete old zip output.
rm "$ZIP_FILE"
rem Create output zip with no compression and only include the selected files.
zip -0 -rq "$ZIP_FILE" assets pack.mcmeta pack.png README.md

rem If existing zip output matches new output, cancel.
if [ -e "$WWW_DIR/$ZIP_FILE" ]
then
  if [ $(md5sum "$ZIP_FILE" | awk '{print $1}') == $(md5sum "$WWW_DIR/$ZIP_FILE" | awk '{print $1}') ]
  then
    exit 0
  fi
fi

rem Copy new output zip to public location.
cp -f "$ZIP_FILE" "$WWW_DIR/$ZIP_FILE"
exit 0
