#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-10-11
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

get_greyhole_io(){
	if [ $(check_if_installed "greyhole") -eq "1" ]; then
		 
		  # declare an associative array
		  declare -A greyhole_io
		while read line; do 
			if [[ $line == "---" ]]; then
				break
			else
				greyhole_io[$(echo $line | cut -d":" -f1)]=$(echo $line | cut -d":" -f2 | sed "s/^[ \t]*//")
			fi
		done < <(greyhole -i)
	
		json="$(get_json "$(declare -p greyhole_io)")"
		  echo "{\"io\":$json}"
	else
		echo "{\"Error\":\"Greyhole not installed\"}"
	fi
}

get_greyhole_io
