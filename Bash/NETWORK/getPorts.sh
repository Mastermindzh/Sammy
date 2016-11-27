#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-11-25
# dependencies: ip 

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

get_port_info(){
	netstatoutput="$(netstat -tulpn --numeric-ports | tail -n +3)"
	port_information="{\"ports\":["

	while read line; do 
		declare -A port
		
		port["protocol"]="$(echo $line | cut -d " " -f 1 )"
		port["recvq"]="$(echo $line | cut -d " " -f 2 )"
		port["sendq"]="$(echo $line | cut -d " " -f 3 )"		
		port["localip"]="$(echo $line | cut -d " " -f 4 | sed -E  's/(.*):(.*)/\1/' )"
		port["localport"]="$(echo $line | cut -d " " -f 4 | sed -E  's/(.*):(.*)/\2/' )"
		port["foreignip"]="$(echo $line | cut -d " " -f 5 | sed -E  's/(.*):(.*)/\1/' )"
		port["foreignport"]="$(echo $line | cut -d " " -f 5 | sed -E  's/(.*):(.*)/\2/' )"		
		#state="$(echo $line | cut -d " " -f 6 )"		
		
		#if [[ $(echo $line | cut -d " " -f 7) != "-" ]]
		#then
		#	echo "$(echo $line | cut -d " " -f 7 | sed -E  's/(.*)\/(.*)/\2/' )"			
		#fi
		#convert this to json 
		json="$(get_json "$(declare -p port)" $port)"
		#Combine this to the total json object, if the total json object is not empty

		port_information=$port_information$json","
	done < <(echo "$netstatoutput") 
	
	#finish up json
	port_information=${port_information::-1}
	port_information=$port_information"]}"
	echo $port_information
}

get_port_info
