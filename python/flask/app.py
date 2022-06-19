from markupsafe import escape
from flask import Flask
import os

app = Flask(__name__)
port = os.environ.get('PORT', '8080')
host = os.environ.get('HOST', '0.0.0.0')


@app.route('/')
def root():
    return """
    <html>
        <head>
            <title>Hello from Flask ⚗️!</title>
            <meta name="color-scheme" content="light dark">
        </head>
        <body>
            <h3>Hello from Flask ⚗️!</h3>
            <p>Visit <a href="/foobar">/foobar</a></p>
        </body>
    </html>
    """


@app.route("/<name>")
def hello(name):
    return f"Hello, {escape(name)}!"


app.run(debug=False, host=host, port=port)
