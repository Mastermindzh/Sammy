#!/bin/bash
LANGUAGE=en
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontro, hddtemp

# include json functions
. "$(dirname "$0")/"Includes/json_functions.sh

# vars
diskspace=$(df -T -l)
disklist=$(lsblk -ln)

# functions
get_partition_information() {
	local partitionJson
	currentdevice=$1
	while read line; do 
		if [[ $line == *"part"*  ]] && [[ $line == *"$currentdevice"*  ]]
		then
			#Get disk usage information about this partition
			declare -A PartitionInformation
			currentpartition=$(echo $line | awk '{print $1}')
			PartitionInformation["type"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $2}')
			PartitionInformation["totalsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $3}')
			PartitionInformation["usedsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $4}')
			PartitionInformation["availablesize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $5}')
			PartitionInformation["mountpoint"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $7}')
			
			#convert this to json 
			json="$(get_json "$(declare -p PartitionInformation)" $currentpartition)"
			
			#Combine this to the total json object, if the total json object is not empty
			if [[ "$partitionJson" != "" ]]; then
				array=("$json" "$partitionJson")
				partitionJson=$(combine_json "${array[@]}")
			else
				partitionJson="$json"
			fi
		fi
	done < <(echo "$disklist")
	
	#finish up json
	partitionJson="{\"partitions\":$partitionJson}"
	echo $partitionJson
}

get_smart_data() {
	local smartDataJson
	currentdevice=$1
	declare -A SmartData
	
	#get smart data
	smartdataraw=$(smartctl -i /dev/$currentdevice)

	#Check if there are any errors
	if [[ $smartdataraw != *"Permission denied"* ]] || [[ $smartdataraw != *"failed"* ]]; then
		SmartData["modelFamily"]=$(echo "$smartdataraw" | awk '/^Model Family:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["deviceModel"]=$(echo "$smartdataraw" | awk '/^Device Model:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["serialNumber"]=$(echo "$smartdataraw" | awk '/^Serial Number:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["firmwareVersion"]=$(echo "$smartdataraw" | awk '/^Firmware Version:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["sectorSize"]=$(echo "$smartdataraw" | awk '/^Sector Size:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["rotationRate"]=$(echo "$smartdataraw" | awk '/^Rotation Rate:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["temperature"]=$(hddtemp /dev/$currentdevice | awk 'NF>1{print $NF}')
		smartDataJson="$(get_json "$(declare -p SmartData) smartData")"
		echo "$smartDataJson"
	fi
}


# loop through disks connected to the device
endjson="{"
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
		endjson="$endjson \"$currentdevice\":$json,"
	fi
done < <(echo "$disklist")
endjson="${endjson::-1}}"
echo "$endjson"
