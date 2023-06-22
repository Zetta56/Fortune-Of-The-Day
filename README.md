# Fortune of the Day
This is a Fortune of the Day website created with Flask and designed for deployment on AWS. This repository contains three different deployment architectures: monolithic, microservices, and serverless.

## Prerequisites
- [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
- [Amazon Web Services (AWS) Account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
- [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [AWS Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html)
- [EC2 Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
- EC2 Security Group

### Creating an EC2 Security Group
1. Navigate to https://console.aws.amazon.com/ec2
2. Under **Security Group Name**, enter a name
3. Under **VPC**, select your created VPC
4. Under **Inbound Rules**, add the following rules:
   - Type: HTTP, Source: Anywhere-IPv4
   - Type: SSH, Source: Anywhere-IPv4
   - Type: HTTPS, Source: Anywhere-IPv4
5. Keep everything else as their default values, and click **Create Security Group**

## Installation
1. Run `git clone https://github.com/Zetta56/Fortune-of-the-Day.git`
2. Rename `variables.template.ps1` to `variables.ps1`
3. Open the variables.ps1 file
   - Set $keyName to the name of your EC2 key pair
   - Set $securityGroup to the ID of your EC2 security group
   - Set $vpc to the ID of your VPC
   - Set $subnetA, $subnetB, and $subnetC to the IDs of your public VPC subnets
   - Set $clientBucket to the desired name of your client bucket (optional for monolithic architecture)
4. Load powershell variables with `. ./variables.ps1`
   - Make sure to run this everytime you work with this repository's powershell scripts