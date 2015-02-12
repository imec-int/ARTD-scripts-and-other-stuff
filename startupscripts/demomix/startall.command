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
		echo "> unloading Notification Center"
		launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist

		echo ""
		echo "> Killing Google Chrome"
		killall "Google Chrome"

		echo ""
		echo "> Killing MongoDB"
		killall mongod

		echo ""
		echo "> Killing Node.js"
		killall node #kills forever scripts too

		if [ $nrOfDisplays -eq 2 ]
		then
			sleep 3

			echo ""
			echo "> Starting MongoDB"
			mongod &

			sleep 10

			echo ""
			echo "> Starting Node.js server using forever"
			cd ~/projects/ARTD-SortTool/
			forever start ~/projects/ARTD-SortTool/app.js

			sleep 3

			echo ""
			echo "> Starting screen on table"
			open -n /Applications/Google\ Chrome.app --args --new-window  --window-position=1920,0 --user-data-dir="/Users/demomix/chromedata" --start-fullscreen "http://demomix.local:3000/table" &

			sleep 15

			echo ""
			echo "> Starting screen on projection screen"
			open -n /Applications/Google\ Chrome.app --args --new-window --window-position=0,0 --chrome-frame --start-fullscreen "http://demomix.local:3000/livesort" &
		fi
	fi

	sleep 10 # check again in 10 seconds
done
