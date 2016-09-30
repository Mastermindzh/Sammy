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


# System info
@app.route('/sysinfo/')
def get_sys_info():
    process = subprocess.Popen("./Bash/SYSTEM/getSystemInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]


# Disk info
@app.route('/disks/')
def get_disk_info():
    process = subprocess.Popen(["bash", "Bash/DISK/getAll.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


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


meinheld.listen(("0.0.0.0", 5000))
meinheld.run(app)