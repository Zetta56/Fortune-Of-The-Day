function Generate-Policy {
param($serviceName)
return @"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "${serviceName}.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
"@ -replace """","\"""
}


$ec2RoleName = "FotdRoleForEC2"
$ec2RoleArn = aws iam create-role `
--role-name $ec2RoleName `
--assume-role-policy-document (Generate-Policy "ec2") `
--query "Role.Arn" `
| ConvertFrom-Json

aws iam attach-role-policy `
--role-name $ec2RoleName `
--policy-arn "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
aws iam attach-role-policy `
--role-name $ec2RoleName `
--policy-arn "arn:aws:iam::aws:policy/AmazonS3FullAccess"

$null = aws iam create-instance-profile `
--instance-profile-name $ec2RoleName `
--query "InstanceProfile.Arn" `
| ConvertFrom-Json
aws iam add-role-to-instance-profile `
--instance-profile-name $ec2RoleName `
--role-name $ec2RoleName

Write-Output "EC2 Role Created: $ec2RoleArn"


$lambdaRoleName = "FotdRoleForLambda"
$lambdaRoleArn = aws iam create-role `
--role-name $lambdaRoleName `
--assume-role-policy-document (Generate-Policy "lambda") `
--query "Role.Arn" `
| ConvertFrom-Json

aws iam attach-role-policy `
--role-name $lambdaRoleName `
--policy-arn "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
aws iam attach-role-policy `
--role-name $lambdaRoleName `
--policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
aws iam attach-role-policy `
--role-name $lambdaRoleName `
--policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

Write-Output "Lambda Role Created: $lambdaRoleArn"