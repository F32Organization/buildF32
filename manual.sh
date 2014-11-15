#!/bin/bash

if pidof -x "faithful.sh" >/dev/null; then
	echo "Faithful.sh is currently running, please wait."
else
	bash faithful.sh
fi
exit 0















