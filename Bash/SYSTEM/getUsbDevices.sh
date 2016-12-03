#!/usr/bin/env bash
# Author: Rick van Lieshout
# Contributors: -
# Last modification date: 2016-11-26
# dependencies:

# include general settings
. "$(dirname "$0")/../"Includes/general_settings.sh

get_usb_devices(){

    while read line; do
        declare -A usb_device

        usb_device["bus"]=$(echo "$line" | cut -d ' ' -f 2)
        device=$(echo "$line" | cut -d ' ' -f 4)
        usb_device["device"]=$device
        usb_device["id"]=$(echo "$line" | cut -d ' ' -f 6)
        usb_device["name"]=$(echo "$line" | cut -d ' ' -f 7-)

        #convert this to json
        json="$(get_json "$(declare -p usb_device)" )"

        if [[ $usb_devices == "" ]]; then
            usb_devices=$json
        else
            usb_devices=$usb_devices","$json
        fi
    done < <(echo "$(lsusb)")

	usb_devices="{\"usb_devices\":[$usb_devices]}"
	echo $usb_devices
}

get_usb_devices