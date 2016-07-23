#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors


LANGUAGE=C

# include json functions
. "$(dirname "$0")/../"Includes/json_functions.sh


get_details(){
    # make sure all function variables are local ones
    local input; local json;

	# declare an associative array
	declare -A mem_info

	input=$(cat /proc/meminfo | tr -s " ")
	while IFS=':' read -ra ADDR; do
      first=true
      for i in "${ADDR[@]}"; do
		if $first; then
			first=false
			key="$i"
		else
			val="$i"
		fi
      done
      mem_info[$key]=$(echo $val | tr -s " ")
	done <<< "$input"
	# return the json formatted sensor data
	json="$(get_json "$(declare -p mem_info)" mem_info)"
	echo $json
}

get_details