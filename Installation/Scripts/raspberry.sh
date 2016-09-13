#!/usr/bin/env bash

# check for root, if user isn't root display a message and exit
if [[ $EUID -ne 0 ]]; then
   echo "Please use sudo/root to run this script" 1>&2
   exit 1
fi

# install requirements
apt-get install -y python-pip smartmontools

# install flask
pip install flask
pip install flask_cache
pip install flask-cors

# install the Meinheld server
pip install Meinheld
