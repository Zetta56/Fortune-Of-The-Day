# Fortune of the Day (Monolithic)
This version of Fortune of the Day runs on monolithic architecture, comprised of a DynamoDB table and EC2 server(s).


## Setup
### Installation
1. Run `git clone https://github.com/Zetta56/Fortune-of-the-Day.git`
2. Rename `client/config.template.js` to `config.js`
3. Rename `scripts/variables.template.ps1` to `scripts/variables.ps1`
4. Open the variables.ps1 file
   - Set the projectPath variable to the absolute path to your project. 
   - Set the vpc variable to the ID of your VPC
   - Set the subnetA, subnetB, and subnetC variables to the IDs of your VPC subnets

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
6. Set the `securityGroup` variable in variables.ps1 to the ID of your newly created security group

### Creating a custom Amazon Machine Image (Optional)
1. Follow the steps under the [Basic Deployment Section](#basic)
2. Navigate to https://console.aws.amazon.com/ec2
3. Under **Elastic Block Store** on the left sidebar, click **Snapshots**
4. Click **Create Snapshot**
5. Under **Resource Type**, select Instance
6. Under **Instance ID**, select the instance id of the EC2 instance you deployed in Step 1
7. Click **Create Snapshot**
8. Select your newly created snapshot
9. Under **Actions**, click **Create image from snapshot**
10. Enter a name under **Image Name**, and then click **Create Image**
11. Set the `customAmi` variable in variables.ps1 to the ID of your newly created AMI

### Creating a launch template (Optional)
1. Create a [custom AMI](<#creating-a-custom-amazon-machine-image-optional>) and [security group](<#creating-a-security-group>) if you haven't done so already
2. Run `cd scripts`
3. Load powershell variables with `. ./variables.ps1`
4. Create a launch template with `. ./create_launch_template.ps1`
5. Set the `launchTemplate` variable in variables.ps1 to the ID of your newly created launch template


## Deployment
To deploy this website on AWS, first open your CLI and run the following commands:
1. Run `cd scripts`
2. Load powershell variables with `. ./variables.ps1`
3. Create and seed a DynamoDB table with `. ./seed_ddb.ps1`

Then, follow the instructions below for your desired deployment type.

### Basic
If you want to deploy this website on single EC2 instance with an AWS-provided machine image, run:

`. ./launch_basic_ec2.ps1`

### Preset
If you want to deploy this website on single EC2 instance with a pre-configured machine image, create a [custom AMI](<#creating-a-custom-amazon-machine-image-optional>) (if you haven't done so already) and run:

`. ./launch_preset_ec2.ps1`

### Scaled
If you want to deploy this website with an EC2 auto scaling group and a load balancer, create a [custom AMI](<#creating-a-custom-amazon-machine-image-optional>) and [launch template](<#creating-a-launch-template>) (if you haven't done so already) and run:

`. ./launch_scaled_ec2.ps1`


## Local Usage
1. Install [Python3](https://www.python.org/downloads/) (including pip)
2. Open your CLI
3. Run `cd scripts`
4. Load powershell variables with `. ./variables.ps1`
5. Create and seed an AWS DynamoDB table with `. ./seed_ddb.ps1`
6. Run `cd server`
7. Create a Python virtual environment with `python -m venv venv`
8. Install necessary Python dependencies with `pip install -r requirements.txt`
9. Start your Flask server with `flask run`