import os.path
import subprocess

from flask import Flask
from flask_cache import Cache

# store cache values
cache_values={'minute': 60,'hour': 3600,'day': 86400, 'week': 604800}

# initialize app with caching
app = Flask(__name__)
cache = Cache(config={'CACHE_TYPE': 'simple'})
cache.init_app(app)


# Greeter page
@app.route('/')
@cache.cached(timeout=cache_values['week'])
def hello_world():
    return '<h1>Hello and welcome to Sammy!</h1>'


# Test method
@app.route('/pwd')
def test():
    process = subprocess.Popen(["pwd"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# All cpu information
@app.route('/cpu')
def get_cpu_all():
    return run_bash_file("Bash/CPU/getAll.sh")


# CPU temperature
@app.route('/cpu/temp')
def get_cpu_temp():
    return run_bash_file("Bash/CPU/getTemp.sh")


# CPU load
@app.route('/cpu/load')
def get_cpu_load():
    return run_bash_file("Bash/CPU/getLoad.sh")


# CPU info
@app.route('/cpu/info')
def get_cpu_info():
    return run_bash_file("Bash/CPU/getInfo.s")


# all memory info
@app.route('/mem')
def get_mem_all():
    return run_bash_file("Bash/MEM/getAll.sh")


# memory info
@app.route('/mem/info')
def get_mem_info():
    return run_bash_file("Bash/MEM/getInfo.sh")


# memory info
@app.route('/mem/load')
def get_mem_load():
    return run_bash_file("Bash/MEM/getLoad.sh")


@app.route('/sysinfo')
def get_sys_info():
    return run_bash_file("Bash/getSystemInfo.sh")


@app.route('/disk')
def get_disk_info():
    return run_bash_file("Bash/DISK/getDiskInfo.sh")


@app.route('/greyhole')
def get_disk_info():
    return run_bash_file("Bash/GREYHOLE/getGreyholeInfo.sh")


@app.route('/greyhole/io')
def get_disk_info():
    return run_bash_file("Bash/GREYHOLE/getIO.sh")


@app.route('/greyhole/log')
def get_disk_info():
    return run_bash_file("Bash/GREYHOLE/getLog.sh")


@app.route('/greyhole/queue')
def get_disk_info():
    return run_bash_file("Bash/GREYHOLE/getQueue.sh")


@app.route('/greyhole/statistics')
def get_disk_info():
    return run_bash_file("Bash/GREYHOLE/getStatistics.sh")


def run_bash_file(filepath):
    """Execute a bash file and returns the output of the command.
    Arguments: Path to the bash file.
    Will return an error if the file doesn't exist.
    """
    if os.path.isfile(filepath):
        process = subprocess.Popen(["bash", filepath], stdout=subprocess.PIPE)
        return process.communicate()[0]
    else:
        return '{"error":"Bash file not found"}'
