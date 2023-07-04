import pytest
import moto
import boto3
from server import create_app
from random import getrandbits

@pytest.fixture
def app():
    app = create_app()
    yield app

@pytest.fixture
def dynamodb():
    with moto.mock_dynamodb():
        client = boto3.client("dynamodb", region_name="us-east-2")
        client.create_table(
            AttributeDefinitions=[
                { "AttributeName": "PK", "AttributeType": "N" },
                { "AttributeName": "Id", "AttributeType": "N" }
            ],
            TableName="fotd-ddb",
            KeySchema=[
                { "AttributeName": "PK", "KeyType": "HASH" },
                { "AttributeName": "Id", "KeyType": "RANGE" }
            ],
            ProvisionedThroughput={
                "ReadCapacityUnits": 2,
                "WriteCapacityUnits": 2
            }
        )
        messages = [
            "Don't hold onto things that require a tight grip.",
            "I didn't come this far to only come this far.",
            "Vulnerability sounds like faith and looks like courage."
        ]
        for message in messages:
          client.put_item(TableName="fotd-ddb", Item={
              "PK": { "N": "1" },
              "Id": { "N": str(getrandbits(32)) },
              "Message": { "S": message }
          })
        yield client