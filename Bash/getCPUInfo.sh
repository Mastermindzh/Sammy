#!/bin/bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-16
# dependencies: lm_sensors

# include json functions
. "$(dirname "$0")/"Includes/json_functions.sh
. "$(dirname "$0")/"Includes/functions.sh

get_load(){
    # declare an associative array
	declare -A load_array

	input=$(uptime | grep -ohe 'load average[s:][: ].*' | awk '{ print $3 $4 $5}' | tr "," "\n")

	counter=0
	# for each word in $input do...
	for load in $input
	do
		counter=$(($counter + 1))
		if [ $counter -eq 1 ]; then
			load_array["5min"]=$load
		elif [ $counter -eq 2 ]; then
			load_array["10min"]=$load
		else
			load_array["15min"]=$load
		fi
	done

    # grab the cpu utilization percentage
	percentage=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) "%"}')
	load_array["percentage"]=$percentage

	# return the json formatted sensor data
	json="$(get_json "$(declare -p load_array)" load_array)"
	echo $json
}

get_temperatures(){
	# declare an associative array
	declare -A temperatures

	# check wether sensors is installed
	if [ $(check_if_installed "sensors") -eq 1 ]; then
		# get sensor data
		vendor=$(sensors | grep -w "Core 0:")
		if [ -z "$vendor" ]; then
			s=$(sensors | grep "CPU Temperature" | sed 's/([^)]*)//g' | tr -s " ")
		else
			s=$(sensors | grep -w Core | sed 's/([^)]*)//g' | tr -s " ")
		fi

			# loop through $s
		while read line; do

			# filter out whatever is between "Core", "temp" and ":"
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

	# sensors is NOT installed
	else
		var=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
		temperatures["0"]=$var
	fi

	# return the json formatted sensor data
	json="$(get_json "$(declare -p temperatures)" temperatures)"
	echo $json
}

get_cpu_info(){
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



# fill it with the relevant information
array=("$(get_temperatures)" "$(get_load)" "$(get_cpu_info)"  )
json=$(combine_json "${array[@]}")

echo $json
