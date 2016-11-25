#!/usr/bin/env bash

# check for root, if user isn't root display a message and exit
if [[ $EUID -ne 0 ]]; then
   echo "Please use sudo/root to run this script" 1>&2
   exit 1
fi

# install node (and npm)
apt-get install -y nodejs npm node-semver python3-pip smartmontools

# fetch the absolute LATEST pip :)
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

# install flask and meinheld
pip install flask flask_cache flask-cors Meinheld

# keep for now
#npm install -g bower gulp
#
#cd ../../GUI
#
#npm install
#
#bower install --allow-root
#
#echo "All done, execute the run.sh file in the root directory and navigate to localhost:5000 for the api and localhost:8888 for the gui!"
#
