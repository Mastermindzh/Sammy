#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-11-24
# dependencies: ip 

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh
  
  
get_ipaddr_info(){
	ipaddroutput="$(ip -o addr)"$'\n  '
  
	lastinterface=""
	declare -A interface_information

	while read line; do 
		# get the interface id
		interfaceid=$(echo $line | cut -d " " -f 1 | sed 's/:$//')
		
		#check if this is the same interface as the last one
		if [[ $lastinterface != $interfaceid ]] && [[ $lastinterface != "" ]]
		then
			#convert this to json 
			json="$(get_json "$(declare -p interface_information)" $lastinterface)"
			#Combine this to the total json object, if the total json object is not empty
			if [[ "$ipaddr_json" != "" ]]; then
				array=("$json" "$ipaddr_json")
				ipaddr_json=$(combine_json "${array[@]}")
			else
				ipaddr_json="$json"
			fi
			
			declare -A interface_information
		fi
		lastinterface=$interfaceid
	
		name=$(echo $line | cut -d " " -f 2)
		ipv4=$(echo $line | grep -Po '(?<=inet\s)[^\s]*')
		ipv6=$(echo $line | grep -Po '(?<=inet6\s)[^\s]*')
		brd=$(echo $line | grep -Po '(?<=brd\s)[^\s]*')
		interface_information["name"]=$name
	
		if [[ $ipv4 != "" ]]
		then
			interface_information["ipv4"]=$ipv4
		fi
	
		if [[ $ipv6 != "" ]]
		then
			interface_information["ipv6"]=$ipv6
		fi
		
		if [[ $brd != "" ]]
		then
			interface_information["broadcast"]=$brd
		fi
				
	done < <(echo "$ipaddroutput") 
	
	#finish up json
	ipaddr_json="{\"interfaces\":$ipaddr_json}"
	echo $ipaddr_json
}

get_ipaddr_info
