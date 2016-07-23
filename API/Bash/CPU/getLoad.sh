#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors

LANGUAGE=C

# include json functions
. "$(dirname "$0")/../"Includes/json_functions.sh

get_load(){
    # make sure all function variables are local ones
    local counter; local percentage; local json;

    # declare an associative array
	declare -A load_array

	input=$(uptime | grep -ohe 'load average[s:][: ].*' | awk '{ print $3 $4 $5}' | tr "," "\n")

	counter=0
	# for each word in $input do...
	for load in $input
	do
		counter=$(($counter + 1))
		if [ $counter -eq 1 ]; then
			load_array["5min"]=$load
		elif [ $counter -eq 2 ]; then
			load_array["10min"]=$load
		else
			load_array["15min"]=$load
		fi
	done

    # grab the cpu utilization percentage
	percentage=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) "%"}')
	load_array["percentage"]=$percentage

	# return the json formatted sensor data
	json="$(get_json "$(declare -p load_array)" load_array)"
	echo $json
}

get_load