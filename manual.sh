#!/bin/bash

if pidof -x "buildF32.sh" >/dev/null; then
	echo "Build script is currently running, please wait."
else
	bash buildF32.sh
fi
exit 0















