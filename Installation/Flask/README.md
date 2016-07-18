#Flask installation
In this little tutorial we'll take a look at installing Flask.
We'll do this by installing "pip" on top of python first and then we'll install flask itself.

##Requirements:
- Python
- Pip
- sudo


### Installing pip
Depending on your distro you'll have to run either one of these commands:

- Ubuntu:   `sudo apt-get install python-pip`
- Fedora:   `sudo yum install python-pip`
- Arch:     `sudo pacman -S python-pip`
- Raspbian: `sudo apt-get install python-pip`

### Installing Flask systemwide
To install flask systemwide we use:
`sudo pip install flask`


### Installing Flask in a virtualenv
To install the virtualenv you need pip. If you've got pip installed simply run:
`sudo pip install virtualenv`

Once you have virtualenv installed, just fire up a shell and create your own environment. 
I usually create a project folder and a venv folder within:
```
mkdir SammyEnv
cd SammyEnv
virtualenv venv
```
The last command can take quite a while depending on your internet connection and your machine's speed.
Now we just run the virtual environment with:
`. venv/bin/activate`
You'll see the command prompt change a bit and after that you have to run the following command to install Flask:
`sudo pip install flask`