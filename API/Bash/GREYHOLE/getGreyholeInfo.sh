#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-10-11
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

get_all_greyhole_info(){
	if [ $(check_if_installed "greyhole") -eq "1" ]; then
		greyhole_que=$(bash $(dirname "$0")/getQueue.sh)
		greyhole_status="{\"status\":\"$(greyhole --status | head -2 | tail -1)\"}"
		greyhole_log=$(bash $(dirname "$0")/getLog.sh)
		greyhole_statistics=$(bash $(dirname "$0")/getStatistics.sh)
		greyhole_io=$(bash $(dirname "$0")/getIO.sh)
	
		#Combine json
		array=("$greyhole_que" "$greyhole_status" "$greyhole_log" "$greyhole_statistics" "$greyhole_io")
		greyhole_json=$(combine_json "${array[@]}")
		echo "$greyhole_json"
	else
		echo "{\"Error\":\"Greyhole not installed\"}"
	fi
}

get_all_greyhole_info


