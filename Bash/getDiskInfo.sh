#!/bin/bash
LANGUAGE=en
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontrol, hddtemp

# include functions
. "$(dirname "$0")/"Includes/json_functions.sh
. "$(dirname "$0")/"Includes/functions.sh

# vars
diskspace=$(df -T -l)
disklist=$(lsblk -ln)

# functions
get_partition_information() {
	local partition_json
	currentdevice=$1
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

get_smart_data() {
	local smartdata_json
	local smartdata_raw
	currentdevice=$1
	declare -A smart_data
	
	#get smart data
	if [ $(check_if_installed "smartctl") -eq 1 ]; then
		smartdata_raw=$(smartctl -i /dev/$currentdevice)
	fi

	#Check if there are any errors
	if [[ $smartdata_raw != *"Permission denied"* ]] && [[ $smartdata_raw != *"failed"* ]] && [[ $smartdata_raw != "" ]]; then
		smart_data["modelFamily"]=$(echo "$smartdata_raw" | awk '/^Model Family:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		smart_data["deviceModel"]=$(echo "$smartdata_raw" | awk '/^Device Model:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		smart_data["serialNumber"]=$(echo "$smartdata_raw" | awk '/^Serial Number:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		smart_data["firmwareVersion"]=$(echo "$smartdata_raw" | awk '/^Firmware Version:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		smart_data["sectorSize"]=$(echo "$smartdata_raw" | awk '/^Sector Size:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		smart_data["rotationRate"]=$(echo "$smartdata_raw" | awk '/^Rotation Rate:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		
		if [ $(check_if_installed "hddtemp") -eq 1 ]; then
			smart_data["temperature"]=$(hddtemp /dev/$currentdevice | awk 'NF>1{print $NF}')
		fi
		smartdata_json="$(get_json "$(declare -p smart_data) smartData")"
		echo "$smartdata_json"
	fi
}

# loop through disks connected to the device
while read line; do 
	if [[ $line == *"disk"* ]] #Disk found
	then
		currentdevice=$(echo $line | awk '{print $1}')
		
		#partition information
		partitionjson=$(get_partition_information $currentdevice)
		#smartdata
		smartdatajson=$(get_smart_data $currentdevice)

		array=("$partitionjson" "$smartdatajson")
		json=$(combine_json "${array[@]}")
		json="{\"$currentdevice\":$json}"
		
		if [[ "$diskinfo_json" != "" ]]; then
			array=("$json" "$diskinfo_json")
			diskinfo_json=$(combine_json "${array[@]}")
		else
			diskinfo_json="$json"
		fi
	fi
done < <(echo "$disklist")
echo "$diskinfo_json"
