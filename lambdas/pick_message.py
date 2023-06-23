import boto3
from random import getrandbits

def main(event, context):
    dynamodb = boto3.client("dynamodb", region_name="us-east-2")
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
    return {
        "statusCode": 200,
        "headers": { "Access-Control-Allow-Origin": "*" },
        "body": res["Items"][0]["Message"]["S"]
    }
