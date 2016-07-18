#!/bin/bash
# Author: Rick van Lieshout
# Contributors: 
# Last modification date: 2016-07-18
# dependencies: lm_sensors

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh


getDetails(){
	# declare an associative array
	declare -A memInfo
	
	IN=$(cat /proc/meminfo | tr -s " ")
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
      memInfo[$key]=$(echo $val | tr -s " ")
	done <<< "$IN"
	# return the json formatted sensor data
	json="$(getJson "$(declare -p memInfo)" memInfo)"
	echo $json
}

getMemInfo(){
	
	#declare an associative array	
	declare -A memInfo
	
	# get memory info, skip first line and strip whitespace
	IN=$(free -h | tr -s " " | sed -n '1!p')
	
	
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
        memInfo[${name::-1}]="$(getJson "$(declare -p tempMemInfo)" ${name})"
        unset tempMemInfo
    done < <(echo "$IN")
	
	json="$(combineJson "$(declare -p memInfo)")"
	echo "$json"
}

# declare an associative array
declare -A output

output["1"]="\"info\":"$(getMemInfo)
output["2"]=$(getDetails)
json="$(combineJson "$(declare -p output)")"


echo $json
