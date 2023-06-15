Write-Output "Creating instance..."

$instanceId = aws ec2 run-instances `
--image-id $customAmi `
--count 1 `
--instance-type "t2.micro" `
--key-name $keyName `
--security-group-ids $securityGroup `
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=fotd}]" `
--user-data "file://${projectPath}/scripts/start_server.sh" `
--query "Instances[0].InstanceId" `
| ConvertFrom-Json


Write-Output "Booting instance..."

aws ec2 wait instance-running `
--instance-ids $instanceId


Write-Output "Setting up instance..."

$null = aws ec2 associate-iam-instance-profile `
--instance-id $instanceId `
--iam-instance-profile "Name=${roleName}"


Write-Output "Done"