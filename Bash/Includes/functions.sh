#!/bin/bash
# Author: Rick van Lieshout
# Contributors: 
# Last modification date: 2016-07-18
# dependencies: Bash

# check wether software is installed
# Usage: checkIfInstalled "sensors"
checkIfInstalled(){	
	if ! foobar_loc="$(type -p "$1")" || [ -z "$foobar_loc" ]; then
		echo 0
	else
		echo 1
	fi
}


