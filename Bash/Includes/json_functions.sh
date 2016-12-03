#!/bin/bash
# Author: Rick van Lieshout
# Contributors:
# Last modification date: 2016-07-18
# dependencies:  

# Transform array to json
# Usage: get_json "$(declare -p temperatures)"
# Optional second param for json name: get_json "$(declare -p temperatures)"
get_json(){
	if [ -z "$2" ]; then
		func_output="{"
	else
		func_output="{\"$2\":{"
	fi
	
	eval "declare -A assoc_array="${1#*=}
	
	for i in "${!assoc_array[@]}"
	do
		func_output="$func_output \"$i\":\"${assoc_array[$i]}\","
	done
	func_output=$(echo "$func_output" | sed 's/,$//')

	if [ -z "$2" ]; then
	    func_output="$func_output }"
	else
	    func_output="$func_output }}"
	fi

	echo "$func_output"
}

# Combine two outputs from getJson
# Usage: json="$(combine_json "$(declare -p output)")"
combine_json(){
    arr=("$@")

    func_output="{ "

    for i in "${arr[@]}";
        do
            temp=$(echo "$i" | tr -s " " | awk '{print substr($0, 2, length($0) - 2)}')
            func_output="$func_output $temp,"
        done
    func_output="${func_output::-1} }"

    echo $func_output
}

array_with_json_to_json_array(){
    array=("$@")


}

# Bash array to Json array
# Usage: json_array "$(declare -p temperatures)
json_array(){
	
	array=("$@")
	
	#remove the last parameter which we are using as our key
	((last_index=${#array[@]} - 1))
    key=${array[last_index]}
    unset array[last_index]
    
    func_output="{\"$key\":["
	
	for i in "${array[@]}"
	do
		func_output="$func_output \"$i\","
	done
	func_output=$(echo "$func_output" | sed 's/,$//')

    func_output="$func_output ]}"

	echo "$func_output"
}

