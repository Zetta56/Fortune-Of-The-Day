# Common
$ddbTableName = "fotd"
$clientBucket = ""
$keyName = ""
$securityGroup = ""
$vpc = ""
$subnetA = ""
$subnetB = ""
$subnetC = ""

# Monolithic
$loadBalancerName = "fotd-alb"
$autoScalingGroupName = "fotd-asg"
$targetGroupName = "fotd-tg"
$launchTemplateName = "fotd-lt"
$ec2RoleName = ""
$amazonAmi = "ami-01107263728f3bef4"
$customAmi = ""
$launchTemplate = ""

# Microservices
$profile = ""

# Serverless
$gatewayName = "fotd-api"
$gatewayDomain = ""
$lambdaNames = @("pick_message", "upload_message", "handle_cors")
$lambdaRoleArn = ""
$certificateArn = ""