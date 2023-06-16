param($scaled)

Write-Output "Deleting DynamoDB table..."

$null = aws dynamodb delete-table --table-name $ddbTableName


Write-Output "Done"