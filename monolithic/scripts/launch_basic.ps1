Write-Output "Creating instance..."

$instanceId = aws ec2 run-instances `
--image-id $amazonAmi `
--count 1 `
--instance-type "t2.micro" `
--key-name $keyName `
--security-group-ids $securityGroup `
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=fotd}]" `
--query "Instances[0].InstanceId" `
| ConvertFrom-Json


Write-Output "Booting instance..."

aws ec2 wait instance-running `
--instance-ids $instanceId

$dns = aws ec2 describe-instances `
--filters "Name=instance-id,Values=${instanceId}" `
--query "Reservations[].Instances[0].PublicDnsName" `
| ConvertFrom-Json


Write-Output "Setting up instance..."

$serverFiles = Get-ChildItem -Path "..\server\" -Exclude venv,__pycache__
$bashScript = Get-Content -Raw "setup_server.sh"

ssh -i fotd-ec2.pem -o StrictHostKeyChecking=accept-new "ec2-user@${dns}" "mkdir server"
scp -r -i fotd-ec2.pem $serverFiles "ec2-user@${dns}:~/server"
ssh -i fotd-ec2.pem "ec2-user@${dns}" $bashScript

$null = aws ec2 associate-iam-instance-profile `
--instance-id $instanceId `
--iam-instance-profile "Name=${roleName}"


Write-Output "Done"