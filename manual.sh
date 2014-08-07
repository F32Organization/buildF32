#!/bin/bash

#Check if automated cron-job is currently running faithful.sh; If the output of the instance is being nulled, proceed anyways.
if pidof -x "faithful.sh" >/dev/null; then
	echo "Faithful.sh is currently running, please wait." #If the job is running, exit with this message.
else
	bash faithful.sh #If the job is not running, manually run faithful.sh.
fi
#Exit the script with code reading successful.
exit 0















