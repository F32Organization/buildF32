#!/bin/bash

if pidof -x "buildF32.sh" >/dev/null; then
	echo "Build script is currently running, please wait."
else
	bash faithful.sh
fi
exit 0















