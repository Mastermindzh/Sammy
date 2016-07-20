#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-20
# dependencies: lm_sensors

# include json functions
. "$(dirname "$0")/../"Includes/json_functions.sh

get_all_info(){
    # make sure all function variables are local ones
    local array; local json;

    # fill it with the relevant information
    array=("$(bash Bash/CPU/getTemp.sh)" "$(bash Bash/CPU/getLoad.sh)" "$(bash Bash/CPU/getInfo.sh)")
    json=$(combine_json "${array[@]}")

    echo $json
}
LANGUAGE=C
get_all_info

