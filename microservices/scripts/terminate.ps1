param($scaled)

Write-Output "Deleting DynamoDB table..."

$null = aws dynamodb delete-table --table-name $ddbTableName


Write-Output "Deleting S3 bucket..."

aws s3 rm "s3://${assetBucket}" --recursive
aws s3 rb "s3://${assetBucket}"


Write-Output "Deleting Elastic Beanstalk application..."

cd "../server"
eb terminate --all
cd "../scripts"

Write-Output "Done"