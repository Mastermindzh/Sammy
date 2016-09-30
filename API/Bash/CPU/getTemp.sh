#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

get_temperatures(){
    # make sure all function variables are local ones
    local vendor; local json;

	# declare an associative array
	declare -A temperatures

	# check wether sensors is installed
	if [ $(check_if_installed "sensors") -eq 1 ]; then
		# get sensor data
		vendor=$(sensors | grep -w "Core 0:")
		if [ -z "$vendor" ]; then
			s=$(sensors | grep "CPU Temperature\|temp1" | sed 's/([^)]*)//g' | tr -s " ")
		else
			s=$(sensors | grep -w Core | sed 's/([^)]*)//g' | tr -s " ")
		fi

			# loop through $s
		while read line; do

			# filter out whatever is between "Core", "temp" and ":"
			var=$(echo "$line" | sed -e 's/Core\(.*\):/\1/' | sed -e 's/temp\(.*\):/\1/')

			first=true
            temperatures["Unit"]=$(echo -n $var | tail -c 1)
			# loop through words in line
			for word in $var; do
				# set the first word as key
				if $first; then
					first=false
					key=$word
				else
					# set second word as value
					value=$(echo "$word" | cut -c 2- | rev | cut -c 6- | rev)
				fi
			done
			# finally put it into an associative array
			temperatures[$key]=$value

		done <<< "$s"

	# sensors is NOT installed
	else
		var=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
		temperatures["0"]=$var
	fi

	# return the json formatted sensor data
	json="$(get_json "$(declare -p temperatures)" temperatures)"
	echo $json
}

get_temperatures