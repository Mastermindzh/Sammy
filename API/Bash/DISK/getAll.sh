#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontrol, hddtemp

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

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

        if [ -n "$smartdatajson" ]; then
            array=("$partitionjson" "$smartdatajson")
            json=$(combine_json "${array[@]}")
        else
            json=("$partitionjson")
        fi

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
