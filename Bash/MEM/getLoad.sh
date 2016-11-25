#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors


# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh



get_mem_info(){
    # make sure all function variables are local ones
    local mem_info; local input; local json;

	#declare an associative array
	mem_info=()

	# get memory info, skip first line and strip whitespace
	input=$(free -h | tr -s " " | sed -n '1!p')


    while IFS= read -r line; do
		declare -A tempMemInfo
		counter=0
		array=( $line )
        for word in "${array[@]}"; do
			counter=$(($counter+1))
			if [ $counter -eq 1 ]; then
				name="$word"
			elif [ $counter -eq 2 ]; then
				tempMemInfo["total"]="$word"
			elif [ $counter -eq 3 ]; then
				tempMemInfo["used"]="$word"
			elif [ $counter -eq 4 ]; then
				tempMemInfo["free"]="$word"
			elif [ $counter -eq 5 ]; then
				tempMemInfo["shared"]="$word"
			elif [ $counter -eq 6 ]; then
				tempMemInfo["buff/cache"]="$word"
			elif [ $counter -eq 7 ]; then
				tempMemInfo["available"]="$word"
			fi
        done
        mem_info+=("$(get_json "$(declare -p tempMemInfo)" ${name})")
        unset tempMemInfo
    done < <(echo "$input")

	json="$(combine_json "${mem_info[@]}")"
	echo "$json"
}

get_mem_info