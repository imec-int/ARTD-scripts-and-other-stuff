#!/bin/bash

previousWidth=0

while true
do



	read width height <<<$(system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2,$4}')


	echo "> Current resolution: $width x $height"

	if [ $width -ne $previousWidth ]
	then
		echo "> Resolution changed, restarting all..."
		previousWidth=$width

		# pass this to Chrome later on:
		xposSecondscreen=$((width/2))



	fi

	sleep 10 # check again in 10 seconds
done


