#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

if [ $(check_if_installed "greyhole") -eq "1" ]; then
	greyhole_que="{\"queue\":"$(greyhole --view-queue --json)"}"
	greyhole_status="{\"status\":\"$(greyhole --status | head -2 | tail -1)\"}"
	
	#Last 10 log entries
	greyhole_log_array=()
	while read line; do
		greyhole_log_array+=("$line")
	done < <(greyhole --status | grep -A10 "Recent log entries:" | tail -n 10)
	greyhole_log=$(json_array "${greyhole_log_array[@]}" "log")
	
	greyhole_statistics="{\"statistics\":"$(greyhole -s --json)"}"
	
	#Combine json
	array=("$greyhole_que" "$greyhole_status" "$greyhole_log" "$greyhole_statistics")
	greyhole_json=$(combine_json "${array[@]}")
	echo "$greyhole_json"
else
	echo "{\"Error\":\"Greyhole not installed\"}"
fi


