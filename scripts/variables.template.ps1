# VPC
$vpc = ""
$subnetA = ""
$subnetB = ""
$subnetC = ""

# Application
$region = ""
$securityGroup = ""
$launchTemplate = ""
$clientBucket = ""
$gatewayDomain = ""

# Security
$profile = ""
$ec2RoleArn = ""
$lambdaRoleArn = ""
$certificateArn = ""

# Preset
$ddbTableName = "fotd-ddb"
$keyName = "fotd-kp"
$loadBalancerName = "fotd-alb"
$autoScalingGroupName = "fotd-asg"
$targetGroupName = "fotd-tg"
$launchTemplateName = "fotd-lt"
$gatewayName = "fotd-api"
$lambdaNames = @("pick_message", "upload_message", "handle_cors")
$amazonAmi = "ami-01107263728f3bef4"