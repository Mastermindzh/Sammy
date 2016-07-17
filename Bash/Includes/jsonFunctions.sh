#!/bin/bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-17
# dependencies:  

# Transform array to json
# Usage: getJson "$(declare -p temperatures)"
# Optional second param for json name: getJson "$(declare -p temperatures)"
getJson(){
	if [ -z "$2" ]; then
		func_output="{"
	else
		func_output="\"$2\":{"
	fi
	
	eval "declare -A assoc_array="${1#*=}
	
	for i in "${!assoc_array[@]}"
	do
		func_output="$func_output \"$i\":\"${assoc_array[$i]}\","
	done
	func_output=$(echo "$func_output" | sed 's/,$//')
	func_output="$func_output }"
	echo $func_output    
}

# Combine two outputs from getJson
# Usage: json="$(combineJson "$(declare -p output)")"
combineJson(){
	func_output="{"
	
	eval "declare -A assoc_array="${1#*=}
	
	for i in "${!assoc_array[@]}"
	do
		func_output="$func_output ${assoc_array[$i]},"
	done
	func_output=$(echo "$func_output" | sed 's/,$//')
	func_output="$func_output }"
	echo $func_output
}
