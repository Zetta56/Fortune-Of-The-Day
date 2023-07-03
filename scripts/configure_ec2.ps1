aws ec2 create-key-pair `
--key-name $keyName `
--key-type "rsa" `
--key-format "pem" `
--query "KeyMaterial" `
--output "text" > "./config/${keyName}.pem"

$securityGroup = aws ec2 create-security-group `
--group-name "fotd-sg" `
--description "fotd-sg" `
--vpc-id $vpc `
--query "GroupId" `
| ConvertFrom-Json

aws ec2 authorize-security-group-ingress `
--group-id $securityGroup `
--ip-permissions `
IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=0.0.0.0/0}]" `
IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges="[{CidrIp=0.0.0.0/0}]" `
IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges="[{CidrIp=0.0.0.0/0}]"

Write-Output "Security Group Created: $securityGroup"