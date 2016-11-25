#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-10-11
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

get_greyhole_log(){
	if [ $(check_if_installed "greyhole") -eq "1" ]; then
		greyhole_log_array=()
		while read line; do
			greyhole_log_array+=("$line")
		done < <(greyhole --status | grep -A10 "Recent log entries:" | tail -n 10)
		echo $(json_array "${greyhole_log_array[@]}" "log")
	else
		echo "{\"Error\":\"Greyhole not installed\"}"
	fi
}

get_greyhole_log
