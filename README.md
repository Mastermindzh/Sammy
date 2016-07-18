# Sammy
Simple python rest api to simplify getting OS information on a linux system.

# How to run
Make sure you have flask installed (see Installation/Flask) and run:
`./run.sh`
or
`bash run.sh`

# URL's
Append the url found below to the address Flask returns.
In my case flasks returns the following:

> Serving Flask app "Sammy"
> Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)

In this case we append the url found below to "[http://127.0.0.1:5000](http://127.0.0.1:5000)" 
We can test this by running: http://127.0.0.1:5000/pwd.
This will return the current working directory of your Flask app

| suffix  | Result |
| ------------- | ------------- |
| /cpu    | CPU information, includes temperatures and load average.  |
| /mem    | Memory information, includes cache.  |

# Coding styleguide
We will be following [Google's shell style guide](https://google.github.io/styleguide/shell.xml) for our Bash scripts.
And we will be following [Pep 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/) for our python api.