cd "../beanstalk"

eb init "fotd" `
--region $region `
--platform "python-3.9" `
--keyname $keyName `
--profile $profile

eb create "fotd-env" `
--elb-type "application" `
--vpc.id $vpc `
--vpc.ec2subnets "${subnetA},${subnetB},${subnetC}" `
--vpc.elbsubnets "${subnetA},${subnetB},${subnetC}" `
--vpc.securitygroups $securityGroup `
--vpc.publicip `
--vpc.elbpublic

aws iam attach-role-policy `
--role-name "aws-elasticbeanstalk-ec2-role" `
--policy-arn "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"

aws iam attach-role-policy `
--role-name "aws-elasticbeanstalk-ec2-role" `
--policy-arn "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

cd "../scripts"
