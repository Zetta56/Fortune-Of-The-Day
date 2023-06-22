Write-Output "Creating API gateway..."

$gatewayId = aws apigatewayv2 create-api `
--name $gatewayName `
--protocol-type "HTTP" `
--query "ApiId"


Write-Output "Adding GET /pick route..."

Compress-Archive -Path "../lambdas/pick_message.py" -DestinationPath "pick_message.zip"

$pickLambda = aws lambda create-function `
--function-name $lambdaNames[0] `
--runtime "python3.9" `
--role $lambdaRoleArn `
--handler "pick_message.main" `
--zip-file "fileb://pick_message.zip" `
--query "FunctionArn"

$null = aws lambda add-permission `
--function-name $lambdaNames[0] `
--action "lambda:InvokeFunction" `
--statement-id "apigateway" `
--principal "apigateway.amazonaws.com"

$pickIntegration = aws apigatewayv2 create-integration `
--api-id $gatewayId `
--integration-type "AWS_PROXY" `
--integration-uri $pickLambda `
--payload-format-version 2.0 `
--query "IntegrationId"

$null = aws apigatewayv2 create-route `
--api-id $gatewayId `
--route-key "GET /pick" `
--target "integrations/$pickIntegration"

rm "pick_message.zip"


Write-Output "Adding POST /upload route..."

Compress-Archive -Path "../lambdas/upload_message.py" -DestinationPath "upload_message.zip"

$uploadLambda = aws lambda create-function `
--function-name $lambdaNames[1] `
--runtime "python3.9" `
--role $lambdaRoleArn `
--handler "upload_message.main" `
--zip-file "fileb://upload_message.zip" `
--query "FunctionArn"

$null = aws lambda add-permission `
--function-name $lambdaNames[1] `
--action "lambda:InvokeFunction" `
--statement-id "apigateway" `
--principal "apigateway.amazonaws.com"

$uploadIntegration = aws apigatewayv2 create-integration `
--api-id $gatewayId `
--integration-type "AWS_PROXY" `
--integration-uri $uploadLambda `
--payload-format-version 2.0 `
--query "IntegrationId"

$null = aws apigatewayv2 create-route `
--api-id $gatewayId `
--route-key "POST /upload" `
--target "integrations/$uploadIntegration"

rm "upload_message.zip"


Write-Output "Adding OPTIONS routes..."

Compress-Archive -Path "../lambdas/handle_cors.py" -DestinationPath "handle_cors.zip"

$handleCors = aws lambda create-function `
--function-name $lambdaNames[2] `
--runtime "python3.9" `
--role $lambdaRoleArn `
--handler "handle_cors.main" `
--zip-file "fileb://handle_cors.zip" `
--query "FunctionArn"

$null = aws lambda add-permission `
--function-name $lambdaNames[2] `
--action "lambda:InvokeFunction" `
--statement-id "apigateway" `
--principal "apigateway.amazonaws.com"

$corsIntegration = aws apigatewayv2 create-integration `
--api-id $gatewayId `
--integration-type "AWS_PROXY" `
--integration-uri $handleCors `
--payload-format-version 2.0 `
--query "IntegrationId"

$null = aws apigatewayv2 create-route `
--api-id $gatewayId `
--route-key "OPTIONS /pick" `
--target "integrations/$corsIntegration"

$null = aws apigatewayv2 create-route `
--api-id $gatewayId `
--route-key "OPTIONS /upload" `
--target "integrations/$corsIntegration"

rm "handle_cors.zip"


Write-Output "Deploying API gateway..."

$null = aws apigatewayv2 create-stage `
--api-id $gatewayId `
--stage-name "prod" `
--auto-deploy

aws apigatewayv2 create-domain-name `
--domain-name $gatewayDomain `
--domain-name-configurations "CertificateArn=${certificateArn}"


Write-Output "Done"