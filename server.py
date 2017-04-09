#/usr/bin/env python3
from os.path import isfile

from flask import Flask, send_file, abort

app = Flask(__name__)

@app.route('/')
def index():
    return send_file('index.html')

@app.route('/<filename>')
def elm(filename):
    filepath = 'dist/{:s}'.format(filename)
    if isfile(filepath):
        return send_file(filepath)
    else:
        abort(404)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8000)
