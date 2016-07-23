#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors

LANGUAGE=C

# include json functions
. "$(dirname "$0")/../"Includes/json_functions.sh

get_all_info(){
    # make sure all function variables are local ones
    local array; local json;

    # fill it with the relevant information
    array=("$(bash Bash/MEM/getLoad.sh)" "$(bash Bash/MEM/getInfo.sh)")
    json=$(combine_json "${array[@]}")
    echo $json
}


get_all_info
