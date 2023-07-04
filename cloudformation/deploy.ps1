param($template)

# Create a new S3 bucket for assets if one does not already exist
$assetBucket = "fotd-formation-assets"
aws s3api head-bucket --bucket $assetBucket 2> $null
if (-not $?) {
  aws s3 mb "s3://${assetBucket}"
}

# Replace local directory references in template to S3 buckets
aws cloudformation package `
--template-file $template `
--s3-bucket $assetBucket `
--output-template-file "output.yaml"

# If deploying over HTTP with EC2 instance...
if ($template -like "*single_ec2.yaml*") {
  # Upload server
  aws s3 cp "../server" "s3://${assetBucket}/server" `
  --exclude "venv/*" `
  --exclude "__pycache__/*" `
  --exclude "tests/*" `
  --recursive

  # Deploy template
  aws cloudformation deploy `
  --stack-name "fotd" `
  --template-file "output.yaml" `
  --parameter-overrides "AssetBucketName=$assetBucket" `
  --capabilities "CAPABILITY_NAMED_IAM"
}

# If deploying highly available EC2 instances
elseif ($template -like "*ha_ec2.yaml*" -or $template -like "*pipeline.yaml*") {

  # Ask for parameters
  $domainName = Read-Host -Prompt "Enter your domain name"
  $certificateArnMain = Read-Host -Prompt "Enter the ARN of your ACM certificate (main region)"

  # Upload server
  aws s3 cp "../server" "s3://${assetBucket}/server" `
  --exclude "venv/*" `
  --exclude "__pycache__/*" `
  --exclude "tests/*" `
  --recursive

  # Deploy template
  aws cloudformation deploy `
  --stack-name "fotd" `
  --template-file "output.yaml" `
  --parameter-overrides `
    "AssetBucketName=$assetBucket" `
    "DomainName=$domainName" `
    "CertificateArnMain=$certificateArnMain" `
  --capabilities "CAPABILITY_NAMED_IAM"
}

# If deploying with S3 client
elseif ($template -like "*client.yaml*" -or
    $template -like "*beanstalk.yaml*" -or
    $template -like "*gateway.yaml*") {

  # Ask for parameters
  $domainName = Read-Host -Prompt "Enter your domain name"
  $certificateArnCF = Read-Host -Prompt "Enter the ARN of your ACM certificate (us-east-1)"
  $certificateArnMain = Read-Host -Prompt "Enter the ARN of your ACM certificate (main region)"

  # Deploy template
  aws cloudformation deploy `
  --stack-name "fotd" `
  --template-file "output.yaml" `
  --parameter-overrides `
    "DomainName=$domainName" `
    "CertificateArnCF=$certificateArnCF" `
    "CertificateArnMain=$certificateArnMain" `
  --capabilities "CAPABILITY_NAMED_IAM"

  # Upload S3 client
  aws s3 cp "../client" "s3://fotd-client" --recursive
}

# If deploying anything else, use default parameters
else {
  aws cloudformation deploy `
  --stack-name "fotd" `
  --template-file "output.yaml" `
  --capabilities "CAPABILITY_NAMED_IAM"
}

# Clean up
rm output.yaml