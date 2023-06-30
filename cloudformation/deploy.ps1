param($template)

# Ask for parameters
$domainName = Read-Host -Prompt "Enter your domain name:"
$certificateArnCF = Read-Host -Prompt "Enter the ARN of your ACM certificate (us-east-1):"
$certificateArnMain = Read-Host -Prompt "Enter the ARN of your ACM certificate (main region):"
$assetBucket = "fotd-formation-assets"

# Create a new S3 bucket for lambdas if one does not already exist
aws s3api head-bucket --bucket $assetBucket 2> $null
if (-not $?) {
  aws s3 mb "s3://${assetBucket}"
}

# Upload server files if deploying EC2 instance
if ($template -like "*single_ec2.yaml*" -or
    $template -like "*ha_ec2.yaml*") {
  aws s3 cp "../server" "s3://${assetBucket}/server" `
  --exclude "venv/*" `
  --exclude "__pycache__/*" `
  --recursive
}

# Replace local directory references in template to S3 buckets
aws cloudformation package `
--template-file $template `
--s3-bucket $assetBucket `
--output-template-file "output.yaml"

# Deploy CloudFormation template
aws cloudformation deploy `
--stack-name "fotd" `
--template-file "output.yaml" `
--parameter-overrides `
  "AssetBucketName=$assetBucket" `
  "DomainName=$domainName" `
  "CertificateArnCF=$certificateArnCF" `
  "CertificateArnMain=$certificateArnMain" `
--capabilities "CAPABILITY_NAMED_IAM"

# Upload client if deploying S3 static website
if ($template -like "*client.yaml*" -or
    $template -like "*beanstalk.yaml*" -or
    $template -like "*gateway.yaml*") {
  aws s3 cp "../client" "s3://fotd-client" --recursive
}

# Clean up
rm output.yaml