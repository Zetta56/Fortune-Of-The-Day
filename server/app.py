import boto3
from flask import Flask, render_template, request
from flask_cors import CORS
from random import getrandbits

dynamodb = boto3.client("dynamodb", region_name="us-east-2")
app = Flask(__name__)
CORS(app)

@app.route("/")
def serve():
    return render_template("index.html")

@app.route("/api/pick")
def pick_message():
    attributes = {
        ":pk": { "N": "1" },
        ":id": { "N": str(getrandbits(32)) }
    }
    # Get the first item after the random id
    res = dynamodb.query(
        TableName="fotd-ddb",
        KeyConditionExpression="PK = :pk AND Id > :id",
        ExpressionAttributeValues=attributes,
        Limit=1
    )
    # If no items are after the random id, get the first item previous
    if (not res["Items"]):
        res = dynamodb.query(
            TableName="fotd-ddb",
            KeyConditionExpression="PK = :pk AND Id <= :id",
            ExpressionAttributeValues=attributes,
            Limit=1
        )
    return res["Items"][0]["Message"]["S"]

@app.route("/api/upload", methods=["POST"])
def upload_message():
    item = {
        "PK": { "N": "1" },
        "Id": { "N": str(getrandbits(32)) },
        "Message": { "S": request.json["message"] }
    }
    dynamodb.put_item(TableName="fotd-ddb", Item=item)
    return "Done"

if __name__ == "__main__":
    app.run()