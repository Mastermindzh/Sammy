from flask import Flask
import subprocess

app = Flask(__name__)

@app.route('/')
def hello_world():
    return '<h1>Hello and welcome to Sammy!</h1>'


@app.route('/pwd')
def test():
    process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
    return process.communicate()[0]
    
@app.route('/cpu')
def getCpuInfo():
    process = subprocess.Popen("./Bash/getCPUInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]

@app.route('/mem')
def getMemInfo():
    process = subprocess.Popen("./Bash/getMemInfo.sh", stdout=subprocess.PIPE)
    return process.communicate()[0]