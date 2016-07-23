import configparser as configparser
import sys
from flask import Flask
import subprocess

#
# Parse config file
#
config = configparser.ConfigParser()
try:
    config.read("Sammy.cnf")
    http_port = int(config.get("client", "port"))
    http_address = str(config.get("client", "bind-address"))
except Exception as e:
    print(e.with_traceback())
    sys.exit(1)

app = Flask(__name__)


@app.route('/')
def hello_world():
    return '<h1>Hello and welcome to Sammy!</h1>'


@app.route('/pwd')
def test():
    process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
    return process.communicate()[0]


@app.route('/cpu')
def get_cpu_info():
    process = subprocess.Popen("./Bash/getCPUInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]


@app.route('/mem')
def get_mem_info():
    process = subprocess.Popen("./Bash/getMemInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]


@app.route('/disk')
def get_disk_info():
    process = subprocess.Popen("./Bash/getDiskInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]


if __name__ == '__main__':
    app.run(host=http_address, port=http_port)
