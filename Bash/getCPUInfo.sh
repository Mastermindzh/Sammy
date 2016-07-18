#!/bin/bash
# Author: Rick van Lieshout
# Contributors: 
# Last modification date: 2016-07-16
# dependencies: lm_sensors

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh
. "$(dirname "$0")/"Includes/functions.sh

getLoad(){
	declare -A loadArray
	
	IN=$(uptime | grep -ohe 'load average[s:][: ].*' | awk '{ print $3 $4 $5}' | tr "," "\n")
	
	counter=0
	for load in $IN
	do
		counter=$(($counter + 1))
		if [ $counter -eq 1 ]; then
			loadArray["5min"]=$load
		elif [ $counter -eq 2 ]; then
			loadArray["10min"]=$load
		else 
			loadArray["15min"]=$load
		fi
	done
	
	percentage=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) "%"}')
	loadArray["percentage"]=$percentage
	
	# return the json formatted sensor data
	json="$(getJson "$(declare -p loadArray)" loadArray)"
	echo $json
}

getTemperatures(){	
	# declare an associative array
	declare -A temperatures
	
	# check wether sensors is installed
	if [ $(checkIfInstalled "sensors") -eq 1 ]; then
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
	json="$(getJson "$(declare -p temperatures)" temperatures)"
	echo $json
}

getCPUInfo(){
	# declare an associative array
	declare -A cpuInfo
	
	IN=$(lscpu | tr -s " ")
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
      cpuInfo[$key]=$val
	done <<< "$IN"
	# return the json formatted sensor data
	json="$(getJson "$(declare -p cpuInfo)" cpuInfo)"
	echo $json
}

# declare an associative array
declare -A output

output["3"]=$(getCPUInfo)
output["1"]=$(getTemperatures)
output["2"]=$(getLoad)
json="$(combineJson "$(declare -p output)")"

echo $json
