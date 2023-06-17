# Fortune of the Day (Monolithic)
This version of Fortune of the Day runs on microservice architecture, comprised of an Elastic Beanstalk environment and a DynamoDB table.


## Setup
1. Install [EB CLI](https://github.com/aws/aws-elastic-beanstalk-cli-setup)
2. Open the variables.ps1 file
   - Set $profile to the name of your IAM profile on your local computer
   - Set $assetBucket to the desired name of your asset bucket
3. Run `cd microservices/server`
4. Create a .env file containing the line `ASSET_BUCKET=<asset_bucket_name>`
   - Replace `<asset_bucket_name>` with the desired name of your asset bucket

## Deployment
1. Run `cd microservices/scripts`
2. Create and seed a DynamoDB table with `./seed_ddb.ps1`
3. Upload your assets to S3 with `./upload_assets.ps1`
4. Deploy your Elastic Beanstalk environment with `. ./launch_beanstalk.ps1`

To terminate your application, run `. ./terminate.ps1`