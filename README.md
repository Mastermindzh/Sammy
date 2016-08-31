# Sammy
Simple python rest api to simplify getting OS information on a linux system.

## tracking development
To track development we use Trello, have a look at what we're doing: [https://trello.com/b/rwl3X5wq/scrumboard](https://trello.com/b/rwl3X5wq/scrumboard)

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

| suffix  | Result | parameters |
| ------------- | ------------- | ------------- |
| /cpu    | CPU information, includes temperatures and load average.  | <ul><li>/temp</li><li>/load</li><li>/info</li></ul>|
| /mem    | Memory information, includes swap.  | <ul><li>/load</li><li>/info</li></ul>|
| /sysinfo    | General system information  | <ul><li>-</li></ul>|
| /disk    | Hard drive information  | <ul><li>-</li></ul>|

# Coding styleguide
We will be following [Google's shell style guide](https://google.github.io/styleguide/shell.xml) for our Bash scripts.
And we will be following [Pep 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/) for our python api.
