from markupsafe import escape
from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'


@app.route("/<name>")
def hello(name):
    return f"Hello, {escape(name)}!"


app.run(debug=False, host='0.0.0.0', port=8080)
