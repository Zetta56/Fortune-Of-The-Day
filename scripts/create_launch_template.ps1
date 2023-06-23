param($instanceId)

$amiId = aws ec2 create-image `
--name "fotd-image" `
--instance-id $instanceId `
--query "ImageId" `
| ConvertFrom-Json

$userData = [convert]::ToBase64String((Get-Content -Path ./start_server.sh -Encoding byte))
$templateConfig = @"
{
  "IamInstanceProfile": {
    "Arn": "$ec2RoleArn"
  },
  "ImageId": "$amiId",
  "InstanceType": "t2.micro",
  "KeyName": "$keyName",
  "UserData": "$userData",
  "SecurityGroupIds": [
    "$securityGroup"
  ]
}
"@ -replace "\s","" -replace """","\"""

$templateId = aws ec2 create-launch-template `
--launch-template-name $launchTemplateName `
--launch-template-data $templateConfig `
--query "LaunchTemplate.LaunchTemplateId"

Write-Output "Launch Template Created: $templateId"