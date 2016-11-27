#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-11-24
# dependencies: ip 

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh
  
get_all_info(){
    # make sure all function variables are local ones
    local array; local json;

    # fill it with the relevant information
    array=("$(bash $(dirname "$0")/getInterfaces.sh)" "$(bash $(dirname "$0")/getPorts.sh)")
    json=$(combine_json "${array[@]}")

    echo $json
}

get_all_info
