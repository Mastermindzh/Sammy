#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: gsmartcontrol, hddtemp

LANGUAGE=en

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

#Current device where we want information from
currentdevice=$1

declare -A smart_data

#get smart data
if [ $(check_if_installed "smartctl") ]; then
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
