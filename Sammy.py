from flask_cache import Cache
from flask import Flask, render_template, request
from flask_cors import CORS, cross_origin
import os.path, time
import meinheld

import subprocess

cache_values = {'minute': 60, 'hour': 3600, 'day': 86400, 'week': 604800}

# initialize app with caching
app = Flask(__name__)
cache = Cache(config={'CACHE_TYPE': 'simple'})
cache.init_app(app)
CORS(app)

# Greeter page
@app.route('/')
@cache.cached(timeout=cache_values['day'])
def hello_world():
    return render_template('index.html', info=getInfo())

# CPU info
@app.route('/cpu/', defaults={"info": "Bash/CPU/getAll.sh"})
@app.route('/cpu/<info>')
def get_cpu_info(info=None):
    try:
        routes = {
            "temp": "Bash/CPU/getTemp.sh",
            "info": "Bash/CPU/getInfo.sh",
            "load": "Bash/CPU/getLoad.sh",
        }
        route = routes[info]
    except Exception:
        route = info

    return run_bash_file(route)


# Mem info
@app.route('/mem/', defaults={"info": "Bash/MEM/getAll.sh"})
@app.route('/mem/<info>')
def get_mem_info(info=None):
    try:
        routes = {
            "info": "Bash/MEM/getInfo.sh",
            "load": "Bash/MEM/getLoad.sh",
        }
        route = routes[info]
    except Exception:
        route = info

    return run_bash_file(route)


# Disk info
@app.route('/disks/')
def get_disk_info():
    return run_bash_file("Bash/DISK/getAll.sh")


# System info
@app.route('/sysinfo/')
def get_sys_info():
    return run_bash_file("./Bash/SYSTEM/getSystemInfo.sh")


@app.route('/system/shutdown')
def system_shutdown():
    return run_bash_file("Bash/SYSTEM/shutdown.sh")


@app.route('/system/reboot')
def system_reboot():
    return run_bash_file("Bash/SYSTEM/reboot.sh")

# Samba
@app.route('/samba/')
def get_samba_info():
    process = subprocess.Popen(["bash", "Bash/SAMBA/getAll.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]

# Greyhole
@app.route('/greyhole/', defaults={"info": "Bash/GREYHOLE/getGreyholeInfo.sh"})
@app.route('/greyhole/<info>')
def get_greyhole_info(info=None):
    try:
        routes = {
            "info": "Bash/GREYHOLE/getGreyholeInfo.sh",
            "statistics": "Bash/GREYHOLE/getStatistics.sh",
            "queue": "Bash/GREYHOLE/getQueue.sh",
            "log": "Bash/GREYHOLE/getLog.sh",
            "io": "Bash/GREYHOLE/getIO.sh",
        }
        route = routes[info]
    except Exception:
        route = info

    return run_bash_file(route)



# custom methods
def run_bash_file(filepath):
    """Execute a bash file and returns the output of the command.
    Arguments: Path to the bash file.
    Will return an error if the file doesn't exist.
    """
    if os.path.isfile(filepath):
        process = subprocess.Popen(["bash", filepath], stdout=subprocess.PIPE)
        return process.communicate()[0]
    else:
        return '{"Error":"no such route."}'

def getInfo():
    pwd = subprocess.Popen("pwd", stdout=subprocess.PIPE, )
    dict = {'Host': request.host, 'Working directory': pwd.communicate(0)[0]}
    return dict

@app.route('/shutdownsammy/')
def shutdownSammy():
    meinheld.stop()

meinheld.listen(("0.0.0.0", 5000))
meinheld.run(app)
