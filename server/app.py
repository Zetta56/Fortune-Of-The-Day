from flask import Flask, render_template
from flask_cors import CORS
from .api import api

app = Flask(__name__)
app.register_blueprint(api, url_prefix="/api")
CORS(app)

@app.route("/")
def serve():
    return render_template("index.html")
