# Delete client bucket if it exists
aws s3api head-bucket --bucket "fotd-client" 2> $null
if ($?) {
  aws s3 rm "s3://fotd-client" --recursive
}

aws cloudformation delete-stack --stack-name "fotd"