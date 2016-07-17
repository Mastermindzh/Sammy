#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: 

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh 

# declare some other functions
getPartitionInformation() {
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
			json="$(getJson "$(declare -p PartitionInformation)" $currentpartition)"
			
			#Add this information to the total json object
			returnjson=$returnjson$json","
		fi
	done < <(lsblk -ln)
	
	#remove last ','
	returnjson="${returnjson::-1}"
	
	#finish up json
	returnjson="\"partitions\":{$returnjson}"
	echo $returnjson
}

# read disk space
diskspace=$(df -T -l)

# loop through disks connected to the device
declare -A DiskInfo
while read line; do 
	if [[ $line == *"disk"* ]] #Disk found
	then
		currentdevice=$(echo $line | awk '{print $1}')
		DiskInfo[$currentdevice]="\"$currentdevice\": {"
		
		#partition information
		DiskInfo[$currentdevice]=${DiskInfo[$currentdevice]}$(getPartitionInformation $currentdevice)
		#smartdata
		#finish object
		DiskInfo[$currentdevice]=${DiskInfo[$currentdevice]}"}"
	fi
done < <(lsblk -ln)

json="$(combineJson "$(declare -p DiskInfo)")"
echo $json
