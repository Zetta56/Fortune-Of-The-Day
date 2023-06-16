$userData = [convert]::ToBase64String( `
  (Get-Content -Path ./start_server.sh -Encoding byte) `
)

$config = @"
{
  "IamInstanceProfile": {
    "Name": "$roleName"
  },
  "ImageId": "$customAmi",
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
--launch-template-data $config `
--query "LaunchTemplate.LaunchTemplateId"

Write-Output "Template Created: $templateId"