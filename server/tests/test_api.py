import json

def test_pick(app, dynamodb):
  res = app.test_client().get("/api/pick")
  messages = [
      "Don't hold onto things that require a tight grip.",
      "I didn't come this far to only come this far.",
      "Vulnerability sounds like faith and looks like courage."
  ]
  assert res.data.decode("utf-8") in messages

def test_upload(app, dynamodb):
  app.test_client().post(
    "/api/upload", 
    data=json.dumps({ "message": "foo" }), 
    headers={ "Content-Type": "application/json" }
  )
  scan = dynamodb.scan(
    TableName="fotd-ddb",
    FilterExpression="Message = :message",
    ExpressionAttributeValues={ ":message": { "S": "foo" } }
  )
  assert scan["Items"][0]["Message"]["S"] == "foo"
