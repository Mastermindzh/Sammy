#!/usr/bin/env bash

# navigate to the correct folder
cd API

# set Sammy.py as the flask app var
export FLASK_APP="Sammy.py"

# Set the debug flag to 1
export FLASK_DEBUG=1

# Run the api
flask run