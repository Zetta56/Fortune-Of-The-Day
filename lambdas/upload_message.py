import boto3
import json
from random import getrandbits

def main(event, context):
    body = json.loads(event["body"])
    dynamodb = boto3.client("dynamodb", region_name="us-east-2")
    item = {
        "PK": { "N": "1" },
        "Id": { "N": str(getrandbits(32)) },
        "Message": { "S": body["message"] }
    }
    dynamodb.put_item(TableName="fotd-ddb", Item=item)
    return {
        "statusCode": 200,
        "headers": { "Access-Control-Allow-Origin": "*" }
    }
