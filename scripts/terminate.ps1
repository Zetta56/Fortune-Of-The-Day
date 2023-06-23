param($mode)

Write-Output "Deleting DynamoDB table..."
$null = aws dynamodb delete-table --table-name $ddbTableName


if ($mode -eq "ec2-single" -or $mode -eq "ec2-scaled") {
    Write-Output "Terminating instances..."
    $instanceIds = aws ec2 describe-instances `
    --filters "Name=instance-state-name,Values=pending,running,stopped,stopping" `
    --query "Reservations[].Instances[].InstanceId" `
    | ConvertFrom-Json 

    $null = aws ec2 terminate-instances --instance-ids $instanceIds
    aws ec2 wait instance-terminated --instance-ids $instanceIds
}

if ($mode -eq "ec2-scaled") {
    Write-Output "Deleting load balancer..."
    $balancerArn = aws elbv2 describe-load-balancers `
    --names $loadBalancerName `
    --query "LoadBalancers[0].LoadBalancerArn" `
    | ConvertFrom-Json

    aws elbv2 delete-listener --listener-arn $( `
        aws elbv2 describe-listeners `
        --load-balancer-arn $balancerArn `
        --query "Listeners[0].ListenerArn" `
        | ConvertFrom-Json `
    )
    $null = aws elbv2 delete-load-balancer --load-balancer-arn $balancerArn

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

if ($mode -eq "beanstalk" -or $mode -eq "gateway") {
    Write-Output "Deleting S3 bucket..."
    aws s3 rm "s3://${clientBucket}" --recursive
    aws s3 rb "s3://${clientBucket}"
}

if ($mode -eq "beanstalk") {
    Write-Output "Deleting Elastic Beanstalk application..."
    cd "../beanstalk"
    eb terminate --all
    cd "../scripts"
}

if ($mode -eq "gateway") {
    Write-Output "Deleting lambda functions..."
    foreach ($name in $lambdaNames) {
      aws lambda delete-function --function-name $name
    }

    Write-Output "Deleting API Gateway..."
    aws apigatewayv2 delete-api-mapping `
    --domain-name $gatewayDomain `
    --api-mapping-id $mappingId $( `
        $mappingId = aws apigatewayv2 get-api-mappings `
        --domain-name $gatewayDomain `
        --query "Items[0].ApiMappingId" `
    )

    aws apigatewayv2 delete-api --api-id $( `
        aws apigatewayv2 get-apis `
        --query "Items[?Name=='${gatewayName}'].ApiId" `
        | ConvertFrom-Json `
    )
}

Write-Output "Done"