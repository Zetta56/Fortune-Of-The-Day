Write-Output "Creating table..."

$null = aws dynamodb create-table `
--table-name $ddbTableName `
--attribute-definitions "AttributeName=PK,AttributeType=N" "AttributeName=Id,AttributeType=N"`
--key-schema "AttributeName=PK,KeyType=HASH" "AttributeName=Id,KeyType=RANGE" `
--provisioned-throughput "ReadCapacityUnits=2,WriteCapacityUnits=2" `
--region "us-east-2"

aws dynamodb wait table-exists --table-name $ddbTableName

Write-Output "Adding items..."

$null = aws dynamodb execute-statement `
--statement "INSERT INTO $ddbTableName VALUE {'PK': 1,'Id':$(Get-Random),'Message':'Don''t hold onto things that require a tight grip.'}"
$null = aws dynamodb execute-statement `
--statement "INSERT INTO $ddbTableName VALUE {'PK': 1,'Id':$(Get-Random),'Message':'I didn''t come this far to only come this far.'}"
$null = aws dynamodb execute-statement `
--statement "INSERT INTO $ddbTableName VALUE {'PK': 1,'Id':$(Get-Random),'Message':'Vulnerability sounds like faith and looks like courage.'}"

Write-Output "Done"