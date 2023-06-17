import os
import boto3
from botocore.config import Config
from flask import Flask, render_template, request
from flask_cors import CORS
from random import getrandbits
from dotenv import load_dotenv

load_dotenv()

s3Config = Config(
    s3={ "addressing_style": "path" },
    signature_version="s3v4"
)
s3 = boto3.client("s3", region_name="us-east-2", config=s3Config)
dynamodb = boto3.client("dynamodb", region_name="us-east-2")
application = Flask(__name__)
CORS(application)

@application.route("/")
def serve():
    object_names = ["index.css", "index.js", "fortune.jpg"]
    urls = {}
    for name in object_names:
        urls[name] = s3.generate_presigned_url("get_object", Params={
            "Bucket": os.environ.get("ASSET_BUCKET"),
            "Key": name
        }, ExpiresIn = 60)
    return render_template("index.html", urls=urls)

@application.route("/api/pick")
def pick_message():
    attributes = {
        ":pk": { "N": "1" },
        ":id": { "N": str(getrandbits(32)) }
    }
    # Get the first item after the random id
    res = dynamodb.query(
        TableName="fotd",
        KeyConditionExpression="PK = :pk AND Id > :id",
        ExpressionAttributeValues=attributes,
        Limit=1
    )
    # If no items are after the random id, get the first item previous
    if (not res["Items"]):
        res = dynamodb.query(
            TableName="fotd",
            KeyConditionExpression="PK = :pk AND Id <= :id",
            ExpressionAttributeValues=attributes,
            Limit=1
        )
    return res["Items"][0]["Message"]["S"]

@application.route("/api/upload", methods=["POST"])
def upload_message():
    item = {
        "PK": { "N": "1" },
        "Id": { "N": str(getrandbits(32)) },
        "Message": { "S": request.form["message"] }
    }
    dynamodb.put_item(TableName="fotd", Item=item)
    return "Done"

if __name__ == "__main__":
    application.run()