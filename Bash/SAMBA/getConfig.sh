#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-11-25
# dependencies: smb

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh


get_config(){
	#Samba config file path where we should read from
	configpath="/etc/samba/smb.conf"

	#If config file doesn't exist, return a error
	if [ ! -f $configpath ]; then
		echo '{"error":"Samba configuration file not found"}'
	else
		#Assocotive array which will hold all the informatoin
		declare -A samba_config

		while read line;
		do
		    #If this is a section header
			if [[ $line == \[*] ]]
			then
				#Parse json from last section if there was one
				if [ ! -z "$section" -a "$section" != " " ]
				then
					json="$(get_json "$(declare -p share_info)" "$section")"				
					#Combine this to the total json object, if the total json object is not empty
					if [[ "$samba_config" != "" ]]; then
						array=("$json" "$samba_config")
						samba_config=$(combine_json "${array[@]}")
					else
						samba_config="$json"
					fi
					unset share_info
				fi
				# declare an new associative array
				declare -A share_info
				section=$line

			#If this line is a value
			elif [[ $line != \#* ]] && [[ $line != \;* ]] && [ ! -z "$line" -a "$line" != " " ]
			then
			    #Split line on "="
				key=$(echo $line | cut -d"=" -f 1)
				value=$(echo $line | cut -d"=" -f 2)
				#Add information to current share
				share_info[$key]=$value
			fi
		done < $configpath

		#finish up json
		json="$(get_json "$(declare -p share_info)" $section)"	
		array=("$json" "$samba_config")
		samba_config=$(combine_json "${array[@]}")
		samba_config="{\"shares\":$samba_config}"				
		echo $samba_config
	fi
}

get_config

