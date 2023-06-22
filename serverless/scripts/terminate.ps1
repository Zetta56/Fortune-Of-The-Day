Write-Output "Deleting DynamoDB table..."

$null = aws dynamodb delete-table --table-name $ddbTableName


Write-Output "Deleting S3 bucket..."

aws s3 rm "s3://${clientBucket}" --recursive
aws s3 rb "s3://${clientBucket}"


Write-Output "Deleting lambda functions..."

foreach ($name in $lambdaNames) {
  aws lambda delete-function --function-name $name
}


Write-Output "Deleting API Gateway..."

$mappingId = aws apigatewayv2 get-api-mappings `
--domain-name $gatewayDomain `
--query "Items[0].ApiMappingId"

aws apigatewayv2 delete-api-mapping `
--api-mapping-id $mappingId `
--domain-name $gatewayDomain

$gatewayId = aws apigatewayv2 get-apis `
--query "Items[?Name=='${gatewayName}'].ApiId" `
| ConvertFrom-Json

aws apigatewayv2 delete-api --api-id $gatewayId


Write-Output "Done"