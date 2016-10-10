#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: 

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

#Current device where we want information from
currentdevice=$1

#Check if second parameter exist (lsblk command)
if [ -z "$2" ]; then
	disklist=$(lsblk -ln)
else
	disklist=$2
fi

#Check if third parameter exist (df command)
if [ -z "$3" ]; then
	diskspace=$(df -T -l)
else
	diskspace=$3
fi

get_partition_info(){
	while read line; do 
		if [[ $line == *"part"*  ]] && [[ $line == *"$currentdevice"*  ]]
		then
			#Get disk usage information about this partition
			declare -A partition_information
			currentpartition=$(echo $line | awk '{print $1}')
			partition_information["type"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $2}')
			partition_information["totalsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $3}')
			partition_information["usedsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $4}')
			partition_information["availablesize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $5}')
			partition_information["mountpoint"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $7}')
			
			#convert this to json 
			json="$(get_json "$(declare -p partition_information)" $currentpartition)"

			#Combine this to the total json object, if the total json object is not empty
			if [[ "$partition_json" != "" ]]; then
				array=("$json" "$partition_json")
				partition_json=$(combine_json "${array[@]}")
			else
				partition_json="$json"
			fi
		fi
	done < <(echo "$disklist")

	#finish up json
	partition_json="{\"partitions\":$partition_json}"
	echo $partition_json
}

get_partition_info
