aws s3 mb "s3://${assetBucket}" --region "us-east-2"
aws s3 cp "../assets" "s3://${assetBucket}" --recursive --region "us-east-2"
aws s3 website "s3://${assetBucket}" --index-document "index.css"

aws s3api put-bucket-cors `
--bucket ${assetBucket} `
--cors-configuration "file://s3_cors.json"
