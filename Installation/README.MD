# Installing the Sammy API

To install the Sammy API you can either use one of the install scripts in the "Scripts" folder or follow this tutorial.
The first thing you want to do is UPDATE your system. Depending on your distro you'll have to run either one of these commands:

- Ubuntu / Raspbian:   `sudo apt-get -y update && sudo apt-get -y upgrade`
- Fedora:   `sudo dnf -y update && sudo dnf -y upgrade`
- Arch:     `sudo pacman --noconfirm -Syyu`

## Installing Flask.
To install Flask follow the tutorial we've written for Flask by opening the flask folder and looking at the README.md file :)

## Additional packages required to run sammy
Run one of the following:
- Ubuntu / Raspbian:   `sudo apt-get -y install smartmontools`
- Fedora:   `sudo dnf -y install smartmontools`
- Arch:     `sudo pacman --noconfirm -S smartmontools`


# Using sammy-gui with Sammy
To get a nice little gui working we need to install some more software.
We'll start by installing npm:

- Ubuntu / Raspbian:   `sudo apt-get -y install nodejs npm node-semver `
- Fedora:   `sudo dnf -y npm`
- Arch:     `sudo pacman --noconfirm -S npm`

Then we'll use npm to install both bower and gulp globally
`sudo npm install -g bower gulp`

Next make sure you're inside the GUI folder and run:
`npm install && bower install`

Thats it! You've successfully installed sammy and sammy-gui!
Go back to the root folder and run the run.sh file!