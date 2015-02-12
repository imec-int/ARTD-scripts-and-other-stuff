#!/bin/bash

previousNrOfdisplays=0

while true
do

	read nrOfDisplays <<<$(system_profiler SPDisplaysDataType | grep Resolution | wc -l)

	echo "> Current number of displays: $nrOfDisplays"

	if [ $nrOfDisplays -ne $previousNrOfdisplays ]
	then
		echo "> Number of displays changed to $nrOfDisplays"
		previousNrOfdisplays=$nrOfDisplays


		echo ""
		echo "> Killing notification center"
		killall NotificationCenter

		echo ""
		echo "> Killing Millumin"
		killall Millumin

		echo ""
		echo "> unloading Notification Center"
		launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist


		if [ $nrOfDisplays -eq 2 ]
		then
			sleep 3

			echo ""
			echo "> starting projection mapping"
			open /Users/demomix/Documents/buda.millu &
		fi
	fi

	sleep 10 # check again in 10 seconds
done