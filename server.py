#/usr/bin/env python3
from os import path

from flask import Flask, send_file, abort

app = Flask(__name__)

@app.route('/')
def index():
    return send_file('dist/index.html')

@app.route('/<path:filepath>')
def elm(filepath):
    filepath = path.join('dist', filepath)
    if path.isfile(filepath):
        return send_file(filepath)
    else:
        abort(404)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8000, debug=True)
