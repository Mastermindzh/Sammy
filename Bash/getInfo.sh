#!/bin/bash
# Author: Rick van Lieshout & Janco Kock
# Contributors:
# Last modification date: 2016-07-16
# dependencies:  

# include json functions
. "$(dirname "$0")/"Includes/jsonFunctions.sh 

# declare an associative array
declare -A output

output["temperatures"]=$("./getCPUTemp.sh")
output["systeminfo"]=$("./getSystemInfo.sh")

json="$(combineJson "$(declare -p output)")"

echo $json
 
