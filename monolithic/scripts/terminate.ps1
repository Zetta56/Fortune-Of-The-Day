param($scaled)

Write-Output "Deleting DynamoDB table..."

$null = aws dynamodb delete-table --table-name $ddbTableName


Write-Output "Terminating instances..."

$instanceIds = aws ec2 describe-instances `
--filters "Name=instance-state-name,Values=pending,running,stopped,stopping" `
--query "Reservations[].Instances[].InstanceId" `
| ConvertFrom-Json 

$null = aws ec2 terminate-instances --instance-ids $instanceIds
aws ec2 wait instance-terminated --instance-ids $instanceIds


if ($scaled -eq "scaled") {
    Write-Output "Deleting load balancer..."

    $balancerArn = aws elbv2 describe-load-balancers `
    --names $loadBalancerName `
    --query "LoadBalancers[0].LoadBalancerArn" `
    | ConvertFrom-Json 
    Write-Output $balancerArn

    aws elbv2 delete-listener --listener-arn $( `
        aws elbv2 describe-listeners `
        --load-balancer-arn $balancerArn `
        --query "Listeners[0].ListenerArn" `
        | ConvertFrom-Json `
    )

    aws elbv2 delete-load-balancer --load-balancer-arn $balancerArn


    Write-Output "Deleting auto-scaling group..."

    aws autoscaling delete-auto-scaling-group `
    --auto-scaling-group-name $autoScalingGroupName `
    --force-delete


    Write-Output "Deleting target group..."

    aws elbv2 delete-target-group --target-group-arn $( `
        aws elbv2 describe-target-groups `
        --names $targetGroupName `
        --query "TargetGroups[0].TargetGroupArn" `
        | ConvertFrom-Json `
    )
}

Write-Output "Done"