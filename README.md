# Fortune of the Day
This is a Fortune of the Day website created with Flask and designed for deployment on AWS.

## Prerequisites
- [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
- [Amazon Web Services (AWS) Account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS IAM Identity Center User](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)

## Installation
1. Run `git clone https://github.com/Zetta56/Fortune-of-the-Day.git`
2. Register a domain name (ex. [AWS Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html), [Google Domain](https://domains.google/))
3. Navigate to https://console.aws.amazon.com/route53
4. Click Hosted Zones > Create Hosted Zone, and then create a public hosted zone with the same domain name as in step 1
5. Add your Route 53 nameservers (found in your hosted zone NS records) to your domain
6. Modify the first line in client/index.js to `const backendURL = "https://api.<your_domain>"`
   - Replace <your_domain> with the domain name you registered in step 2

### Obtaining SSL Certificates
Complete the following steps on us-east-1 and your main region.
1. Navigate to https://console.aws.amazon.com/acm/home
2. Click **Request Certificate**, and then request a public certificate with the following attributes:
   - Fully Qualified Domain Name: \<Your Domain Name\>, *.\<Your Domain Name\>
   - Validation Method: DNS
   - Key Algorithm: RSA 2048
3. Click on your certificate, and then click **Create Record in Route 53**

## Deployment
1. Run `cd cloudformation`
2. Run `./deploy.ps1 <template>`, where \<template\> is one of the following CloudFormation templates:
   - `./single_ec2.yaml`: deploy using a single EC2 instance
   - `./ha_ec2.yaml`: deploy using highly available EC2 instances (including a load balancer and auto scaling group)
   - `./beanstalk.yaml`: deploy using a highly available Elastic Beanstalk environment and S3 static website
   - `./gateway.yaml`: deploy using an API gateway and S3 static website
3. Enter your domain name and certificate ARNs
4. To terminate your website, run `./terminate`
