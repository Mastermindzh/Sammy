#!/usr/bin/env bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-10-11
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

get_greyhole_statistics(){
	if [ $(check_if_installed "greyhole") -eq "1" ]; then
		echo "{\"statistics\":"$(greyhole -s --json)"}"
	else
		echo "{\"Error\":\"Greyhole not installed\"}"
	fi
}

get_greyhole_statistics
