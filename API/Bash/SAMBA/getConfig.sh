#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-10-11
# dependencies: smb

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh


get_config(){
	#Config path where we should read from
	configpath="/home/janco/smb.conf"

	#assocotive array which will hold all the informatoin
	declare -A samba_config

	while read line;
	do
		if [[ $line == \[*] ]] 		#Section
		then
			#get the json of the last section if there was one
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
			# declare an associative array
			declare -A share_info
			section=$line
		elif [[ $line != \#* ]] && [[ $line != \;* ]] && [ ! -z "$line" -a "$line" != " " ] #Values
		then
			key=$(echo $line | cut -d"=" -f 1)
			value=$(echo $line | cut -d"=" -f 2)
			share_info[$key]=$value
		fi
	done < $configpath

	#finish up json
	json="$(get_json "$(declare -p share_info)" $section)"	
	array=("$json" "$samba_config")
	samba_config=$(combine_json "${array[@]}")
	samba_config="{\"shares\":$samba_config}"				
	echo $samba_config
}

get_config

