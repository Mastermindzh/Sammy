#!/bin/bash
# Author: Rick van Lieshout
# Contributors: 
# Last modification date: 2016-07-16
# dependencies: lm_sensors

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh

# get sensor data
vendor=$(sensors | grep -w "Core 0:")
if [ -z "$vendor" ]; then
	s=$(sensors | grep "temp[0-9]" | sed 's/([^)]*)//g' | tr -s " ")
else
	s=$(sensors | grep -w Core | sed 's/([^)]*)//g' | tr -s " ")
fi

# declare an associative array
declare -A temperatures

# loop through $s
while read line; do 

	# filter out whatever is between "Core" and ":"
	var=$(echo "$line" | sed -e 's/Core\(.*\):/\1/' | sed -e 's/temp\(.*\):/\1/')

	first=true
	
	# loop through words in line
	for word in $var; do
		# set the first word as key
		if $first; then
			first=false
			key=$word
		else
			# set second word as value
			value=$word
		fi
	done
	# finally put it into an associative array
	temperatures[$key]=$value
	
done <<< "$s"

# return the json formatted sensor data
json="$(getJson "$(declare -p temperatures)" temperatures)"
echo $json

