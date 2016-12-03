#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors: -
# Last modification date: 2016-11-26
# dependencies:

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

get_login_info(){
    logins=""

    while read line; do
        declare -A login

        login["UID"]=$(echo "$line" | cut -d '"' -f2)
        login["USER"]=$(echo "$line" | cut -d '"' -f4)
        login["PROC"]=$(echo "$line" | cut -d '"' -f6)
        login["PWD-LOCK"]=$(echo "$line" | cut -d '"' -f8)
        login["PWD-DENY"]=$(echo "$line" | cut -d '"' -f10)
        login["LAST-LOGIN"]=$(echo "$line" | cut -d '"' -f12)
        login["GECOS"]=$(echo "$line" | cut -d '"' -f14)

        #convert this to json
        json="$(get_json "$(declare -p login)" )"

        if [[ $logins == "" ]]; then
            logins=$json
        else
            logins=$logins","$json
        fi
    done < <(echo "$(lslogins -e --noheadings)")

	#finish up json
	json="{\"logins\":[$logins]}"
	echo $json
}

get_login_info