from markupsafe import escape
from flask import Flask
import os

app = Flask(__name__)
port = os.environ.get('PORT', '8080')
host = os.environ.get('HOST', '0.0.0.0')


@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'


@app.route("/<name>")
def hello(name):
    return f"Hello, {escape(name)}!"


app.run(debug=False, host=host, port=port)
