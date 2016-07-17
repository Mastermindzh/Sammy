#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: 

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh 

#Read uptime in seconds
uptime=$(cat /proc/uptime | awk '{print $1}')

#Read boot up time in unix timestamp
boottime=$(date --date="$(who -s | awk '{print $3 " " $4}')" +"%s")

#Read distro information
distributor=$(lsb_release -a | awk '/^Distributor ID:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
description=$(lsb_release -a | awk '/^Description:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
release=$(lsb_release -a | awk '/^Release:/' | cut -d":" -f2 | sed "s/^[ \t]*//")
codename=$(lsb_release -a | awk '/^Codename:/' | cut -d":" -f2 | sed "s/^[ \t]*//")

# declare an associative array
declare -A SystemInfo

SystemInfo["uptime"]=$uptime
SystemInfo["boottime"]=$boottime
SystemInfo["distributor"]=$distributor
SystemInfo["description"]=$description
SystemInfo["release"]=$release
SystemInfo["codename"]=$codename

json="$(getJson "$(declare -p SystemInfo)" SystemInfo)"
echo $json
 
