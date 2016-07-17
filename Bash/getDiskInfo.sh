#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: 

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh 

# read disk space
diskspace=$(df -T -l)

# first list all the disks connected to the device
declare -A DiskInfo
currentdevice=""
while read line; do 
	if [[ $line == *"disk"* ]] #Set this as the current disk
	then
		if [[ $currentdevice != "" ]] 
		then
			DiskInfo[$currentdevice] = ${DiskInfo[$currentdevice]}"}"
		fi
		currentdevice=$(echo $line | awk '{print $1}')
		DiskInfo[$currentdevice]="\"partitions\":{"
	elif [[ $line == *"part"* ]] #Get information about this partition and add it to the disk information
	then
		declare -A PartitionInformation
		currentpartition=$(echo $line | awk '{print $1}')
		PartitionInformation["type"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $2}')
		PartitionInformation["totalsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $3}')
		PartitionInformation["usedsize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $4}')
		PartitionInformation["availablesize"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $5}')
		PartitionInformation["mountpoint"]=$(echo "$diskspace" | grep $currentpartition | awk '{print $7}')
		json="$(getJson "$(declare -p PartitionInformation)" $currentpartition)"
		if [[ ${DiskInfo[$currentdevice]} != "\"partitions\":{" ]]
		then
			DiskInfo[$currentdevice]=${DiskInfo[$currentdevice]}","$json
		else
			DiskInfo[$currentdevice]=${DiskInfo[$currentdevice]}$json
		fi
	fi
done < <(lsblk -ln)

if [[ $currentdevice != "" ]] 
then
	DiskInfo[$currentdevice]=${DiskInfo[$currentdevice]}"}"
fi


json="$(combineJson "$(declare -p DiskInfo)")"
echo $json
 
