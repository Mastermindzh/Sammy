# Installing the Sammy API

To install the Sammy API you can either use one of the install scripts in the "Scripts" folder or follow this tutorial.
The first thing you want to do is UPDATE your system. Depending on your distro you'll have to run either one of these commands:

- Ubuntu / Raspbian:   `sudo apt-get -y update && sudo apt-get -y upgrade`
- Fedora:   `sudo dnf -y update && sudo dnf -y upgrade`
- Arch:     `sudo pacman --noconfirm -Syyu`

## Installing Flask.
Before installing flask you need to establish which version of python you are using. 
Use: `python --version` to check what version you have.

##### if version is lower than 3 do this:
To install pip for python 3 (which is needed for meinheld) we use:
`curl -O https://bootstrap.pypa.io/get-pip.py`
after that we execute:
`sudo python3 get-pip.py`

##### if version is higher than 3 do this:
Depending on your distro you'll have to run either one of these commands:

- Ubuntu:   `sudo apt-get install python-pip`
- Fedora:   `sudo yum install python-pip`
- Arch:     `sudo pacman -S python-pip`
- Raspbian: `sudo apt-get install python-pip`

### Installing Flask systemwide
To install flask systemwide we use:
`sudo pip install flask`
In order for the caching to work we use:
`sudo pip install flask_cache`

### Flask-Cors
This package exposes a Flask extension which by default enables CORS support on all routes, for all origins and methods. It allows parameterization of all CORS headers on a per-resource level. The package also contains a decorator, for those who prefer this approach.
To install it run:
`sudo pip install -U flask-cors`

### Meinheld server
We are going to need a decent webserver to handle all the requests, the simple built-in (debug) server just won't do the trick.
To install "Meinheld" we use:
`sudo pip install Meinheld`

## Additional packages required to run sammy
Run one of the following:
- Ubuntu / Raspbian:   `sudo apt-get -y install smartmontools`
- Fedora:   `sudo dnf -y install smartmontools`
- Arch:     `sudo pacman --noconfirm -S smartmontools`


