#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: 

# include json functions
. "$(dirname "$0")/"Includes/json_functions.sh

# Read uptime in seconds
uptime=$(cat /proc/uptime | awk '{print $1}')

#Read boot up time in unix timestamp
boottime=$(date --date="$(who -s | awk 'NR==1{print $3 " " $4}')" +"%s")

#Read distro information
lsbrelease=$(lsb_release -a)
distributor=$(echo "$lsbrelease" | awk '/^Distributor ID:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
description=$(echo "$lsbrelease" | awk '/^Description:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
release=$(echo "$lsbrelease" | awk '/^Release:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
codename=$(echo "$lsbrelease" | awk '/^Codename:/' | cut -d":" -f2 | sed "s/^[ \t]*//")

# declare an associative array
declare -A SystemInfo

SystemInfo["Uptime"]=$uptime
SystemInfo["Bootup_time"]=$boottime
SystemInfo["Distributor"]=$distributor
SystemInfo["Description"]=$description
SystemInfo["Release"]=$release
SystemInfo["Codename"]=$codename

json="$(get_json "$(declare -p SystemInfo)")"
echo $json
 
