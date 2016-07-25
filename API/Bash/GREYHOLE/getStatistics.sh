#!/bin/bash
# Author: Janco Kock
# Contributors: Rick van Lieshout
# Last modification date: 2016-07-16
# dependencies: greyhole

LANGUAGE=C

# include functions
. "$(dirname "$0")/../"Includes/json_functions.sh
. "$(dirname "$0")/../"Includes/functions.sh

if [ $(check_if_installed "greyhole") -eq "1" ]; then
	echo "{\"statistics\":"$(greyhole -s --json)"}"
else
	echo "{\"Error\":\"Greyhole not installed\"}"
fi


