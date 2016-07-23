#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontrol, hddtemp

LANGUAGE=en

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

# vars
diskspace=$(df -T -l)
disklist=$(lsblk -ln)

# loop through disks connected to the device
while read line; do 
	if [[ $line == *"disk"* ]] #Disk found
	then
		currentdevice=$(echo $line | awk '{print $1}')
		
		#partition information
		partitionjson=$(bash Bash/DISK/getPartitionInfo.sh "$currentdevice" "$disklist" "$diskspace")
		#smartdata
		smartdatajson=$(bash Bash/DISK/getSmartData.sh $currentdevice)

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
