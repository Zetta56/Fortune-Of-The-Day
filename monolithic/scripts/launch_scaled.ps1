Write-Output "Creating target group..."

$targetArn = aws elbv2 create-target-group `
--name $targetGroupName `
--protocol HTTP `
--port 80 `
--vpc-id $vpc `
--query "TargetGroups[0].TargetGroupArn" `
| ConvertFrom-Json


Write-Output "Creating load balancer..."

$balancerArn = aws elbv2 create-load-balancer `
--name $loadBalancerName `
--security-groups $securityGroup `
--subnets $subnetA $subnetB $subnetC `
--query "LoadBalancers[0].LoadBalancerArn" `
| ConvertFrom-Json

$null = aws elbv2 create-listener `
--load-balancer-arn $balancerArn `
--protocol HTTP `
--port 80 `
--default-actions "Type=forward,TargetGroupArn=$targetArn"


Write-Output "Creating auto-scaling group..."

aws autoscaling create-auto-scaling-group `
--auto-scaling-group-name $autoScalingGroupName `
--min-size 1 `
--max-size 2 `
--desired-capacity 1 `
--launch-template "LaunchTemplateId=${launchTemplate}" `
--availability-zones "us-east-2a" "us-east-2b" "us-east-2c" `
--target-group-arns $targetArn


Write-Output "Done"