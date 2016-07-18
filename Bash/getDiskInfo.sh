#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontro, hddtemp

# include json functions
. "$(dirname "$0")/"Includes/json_functions.sh
. "$(dirname "$0")/"Includes/functions.sh

# vars
diskspace=$(df -T -l)
disklist=$(lsblk -ln)

# functions
get_partition_information() {
	local returnjson=''
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
			
			#Add this information to the total json object
			array=("$json" "$returnjson")
			returnjson=$(combine_json "${array[@]}")
		fi
	done < <(echo "$disklist")
	
	#remove last ',' if string is not empty
	if [[ $returnjson != "" ]]
	then
		returnjson="${returnjson::-3}"
	fi
	
	#finish up json
	returnjson="{\"partitions\":$returnjson}}"
	echo $returnjson
}

get_smart_data() {
	local returnjson=''
	currentdevice=$1
	declare -A SmartData
	
	#get smart data
	smartdataraw=$(smartctl -i /dev/$currentdevice)

	#Check if there are any errors
	if [[ $smartdataraw == *"Permission denied"* ]] || [[ $smartdataraw == *"failed"* ]]
	then
		exit 0
	else
		SmartData["modelFamily"]=$(echo "$smartdataraw" | awk '/^Model Family:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["deviceModel"]=$(echo "$smartdataraw" | awk '/^Device Model:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["serialNumber"]=$(echo "$smartdataraw" | awk '/^Serial Number:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["firmwareVersion"]=$(echo "$smartdataraw" | awk '/^Firmware Version:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["sectorSize"]=$(echo "$smartdataraw" | awk '/^Sector Size:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["rotationRate"]=$(echo "$smartdataraw" | awk '/^Rotation Rate:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
		SmartData["temperature"]=$(hddtemp /dev/$currentdevice | awk 'NF>1{print $NF}')
	fi
	
	returnjson="$(get_json "$(declare -p SmartData) smartData")"
	
	#finish up json
	echo "$returnjson"
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
