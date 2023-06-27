param($template)

# Ask for parameters
# $vpcId = Read-Host -Prompt "Virtual Private Cloud ID"
$vpcId = "vpc-05d2635b742daac6d"
$assetBucket = "fotd-formation-assets"

# Create a new S3 bucket for lambdas if one does not already exist
aws s3api head-bucket --bucket $assetBucket 2> $null
if (-not $?) {
  aws s3 mb "s3://${assetBucket}"
}

# Upload server files if deploying a single EC2 instance
if ($template -like "*single_ec2.yaml*") {
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
--parameter-overrides "VpcId=${vpcId}" "AssetBucketName=$assetBucket" `
--capabilities "CAPABILITY_NAMED_IAM"

# Clean up
rm output.yaml