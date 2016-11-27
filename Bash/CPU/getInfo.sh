#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh


get_cpu_info(){
    # make sure all function variables are local ones
    local input; local first; local json;

	# declare an associative array
	declare -A cpu_info

	input=$(lscpu | tr -s " ")

	#split on : and read all lines
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
      cpu_info[$key]=$val
	done <<< "$input"
	# return the json formatted sensor data
	json="$(get_json "$(declare -p cpu_info)" cpu_info)"
	echo $json
}

get_cpu_info