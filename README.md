# Fortune of the Day
This is a simple Fortune of the Day website created with Flask and designed for deployment on AWS.

## Prerequisites
- [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
- [Amazon Web Services (AWS) Account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
- [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [AWS Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html)


## Setup
### Installation
1. Run `git clone https://github.com/Zetta56/Fortune-of-the-Day.git`
2. Rename `client/config.template.js` to `config.js`
3. Rename `scripts/variables.template.ps1` to `scripts/variables.ps1`
4. Set the `projectPath` variable in variables.ps1 to the absolute path to your project

### Creating an EC2 key pair
1. Navigate to https://console.aws.amazon.com/ec2
2. Under **Network & Security** on the left sidebar, click **Key Pairs**
3. Click **Create Key Pair**, and name your key pair
4. Under **Private Key File Format**, click .pem
5. Click **Create Key pair**
6. Download your key pair into your scripts folder
7. If you are on Windows, navigate to your key pair file in your file explorer. Then, select Properties > Security > Advanced > Disable Inheritance. Then, click Add > Select Principal, enter your username, and check only the read permission. This will ensure your key pair file is not too permissive.

### Creating a Security Group
1. Navigate to https://console.aws.amazon.com/ec2
2. Under **Security Group Name**, enter a name
3. Under **VPC**, select your created VPC
4. Under **Inbound Rules**, add the following rules:
   - Type: HTTP, Source: Anywhere-IPv4
   - Type: SSH, Source: Anywhere-IPv4
5. Keep everything else as their default values, and click **Create Security Group**
6. Set the `securityGroup` variable in variables.ps1 to the id of your newly created security group

### Creating a custom Amazon Machine Image (AMI)
1. Follow the steps under the [Basic Deployment Section](###Basic)
2. Navigate to https://console.aws.amazon.com/ec2
3. Under **Elastic Block Store** on the left sidebar, click **Snapshots**
4. Click **Create Snapshot**
5. Under **Resource Type**, select Instance
6. Under **Instance ID**, select the instance id of the EC2 instance you deployed in Step 1
7. Click **Create Snapshot**
8. Select your newly created snapshot
9. Under **Actions**, click **Create image from snapshot**
10. Enter a name under **Image Name**, and then click **Create Image**

### Creating a launch template
1. Create a [custom AMI](<###Creating a custom Amazon Machine Image>)
2. Create a [security group](<### Creating a Security Group>) if you haven't done so already
3. Run `cd scripts`
4. Load powershell variables with `. ./variables.ps1`
5. Create a launch template with `. ./create_launch_template.ps1`


## Deployment (Work in Progress)
To deploy this website on AWS, open your CLI and follow the instructions below.

### Basic
If you want to deploy this website on single EC2 instance with an AWS-provided machine image:
1. Run `cd scripts`
2. Load powershell variables with `. ./variables.ps1`
3. Create and seed an AWS DynamoDB table with `. ./seed_ddb.ps1`
4. Launch your AWS EC2 instance with `. ./launch_basic_ec2.ps1`

### Preset
If you want to deploy this website on single EC2 instance with a pre-configured machine image:
1. Create a [custom AMI](<###Creating a custom Amazon Machine Image>) if you haven't done so already
2. Run `cd scripts`
3. Load powershell variables with `. ./variables.ps1`
4. Create and seed an AWS DynamoDB table with `. ./seed_ddb.ps1`
5. Launch your AWS EC2 instance with `. ./launch_preset_ec2.ps1`

### Scaled
If you want to deploy this website with an EC2 auto scaling group and a load balancer:
1. Create a [custom AMI](<###Creating a custom Amazon Machine Image>) if you haven't done so already
2. Create a [launch template](<### Creating a launch template>) if you haven't done so already
3. Run `cd scripts`
4. Load powershell variables with `. ./variables.ps1`
5. Create and seed an AWS DynamoDB table with `. ./seed_ddb.ps1`
6. Launch your AWS EC2 instance with `. ./launch_scaled_ec2.ps1`


## Local Usage
### Client
Open the client/index.html file in a browser.

### Server
1. Install [Python3](https://www.python.org/downloads/) (including pip)
2. Open your CLI
3. Run `cd server`
4. Create a Python virtual environment with `python -m venv venv`
5. Install necessary Python dependencies with `pip install -r requirements.txt`
6. Start your Flask server with `flask run`