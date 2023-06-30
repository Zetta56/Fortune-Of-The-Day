$corsPath = Resolve-Path -Path "../config/s3_cors.json"

aws s3 mb "s3://${clientBucket}" --region $region
aws s3 cp "../client" "s3://${clientBucket}" --recursive --region $region
aws s3 website "s3://${clientBucket}" --index-document "index.html"

aws s3api put-bucket-cors `
--bucket ${clientBucket} `
--cors-configuration "file://${corsPath}"
