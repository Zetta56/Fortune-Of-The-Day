import boto3
from boto3.dynamodb.conditions import Key
from flask import Flask, render_template, request
from flask_cors import CORS
from random import getrandbits

session = boto3.Session(region_name="us-east-2")
dynamodb = session.resource("dynamodb")
messages = dynamodb.Table("fotd")
application = Flask(__name__)
CORS(app)

@application.route("/")
def serve():
    return render_template("index.html")

@application.route("/api/pick")
def pick_message():
    chosen = getrandbits(32)
    # Get the first item after the random id
    res = messages.query(
        KeyConditionExpression=Key("PK").eq(1) & Key("Id").gt(chosen),
        Limit=1
    )
    # If no items are after the random id, get the first item previous
    if (not res["Items"]):
        res = messages.query(
            TableName="fotd",
            KeyConditionExpression=Key("PK").eq(1) & Key("Id").lte(chosen),
            Limit=1
        )
    return res["Items"][0]["Message"]

@application.route("/api/upload", methods=["POST"])
def upload_message():
    item = {
        "PK": 1,
        "Id": getrandbits(32),
        "Message": request.form["message"]
    }
    messages.put_item(Item=item)
    return "Done"

if __name__ == "__main__":
    application.run()