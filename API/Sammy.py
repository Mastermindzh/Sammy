from flask_cache import Cache
from flask import Flask

import subprocess

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
    process = subprocess.Popen("pwd", stdout=subprocess.PIPE, )
    return process.communicate()[0]


# All cpu information
@app.route('/cpu')
def get_cpu_all():
    process = subprocess.Popen(["bash", "Bash/CPU/getAll.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# CPU temperature
@app.route('/cpu/temp')
def get_cpu_temp():
    process = subprocess.Popen(["bash", "Bash/CPU/getTemp.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# CPU load
@app.route('/cpu/load')
def get_cpu_load():
    process = subprocess.Popen(["bash", "Bash/CPU/getLoad.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# CPU info
@app.route('/cpu/info')
def get_cpu_info():
    process = subprocess.Popen(["bash", "Bash/CPU/getInfo.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# all memory info
@app.route('/mem')
def get_mem_all():
    process = subprocess.Popen(["bash", "Bash/MEM/getAll.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# memory info
@app.route('/mem/info')
def get_mem_info():
    process = subprocess.Popen(["bash", "Bash/MEM/getInfo.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


# memory info
@app.route('/mem/load')
def get_mem_load():
    process = subprocess.Popen(["bash", "Bash/MEM/getLoad.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]


@app.route('/sysinfo')
def get_sys_info():
    process = subprocess.Popen("./Bash/getSystemInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]


@app.route('/disk')
def get_disk_info():
    process = subprocess.Popen(["bash", "Bash/DISK/getDiskInfo.sh"], stdout=subprocess.PIPE)
    return process.communicate()[0]    
