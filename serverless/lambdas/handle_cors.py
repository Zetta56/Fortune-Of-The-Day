def main(event, context):
    return {
       "statusCode": 200,
       "headers": {
           "Access-Control-Allow-Origin": "*",
           "Access-Control-Allow-Methods": "*",
           "Access-Control-Allow-Headers": "*"
        }
    }