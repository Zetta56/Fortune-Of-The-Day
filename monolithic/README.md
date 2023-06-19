# Fortune of the Day (Monolithic)
This version of Fortune of the Day runs on monolithic architecture, comprised of EC2 server(s) and a DynamoDB table.


## Setup
### Creating an EC2 Role
1. Navigate to https://console.aws.amazon.com/ec2
2. Go to **Roles** and click **Create Role**
3. Under **Use Case**, select EC2
4. Under **Permissions Policies**, add AmazonDynamoDBFullAccess and AmazonS3FullAccess
5. Click **Next**, and name your role
6. Click **Create Role**
7. Set $ec2RoleName in variables.ps1 to the name of your EC2 role

### Creating a custom Amazon Machine Image
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
11. Set $customAmi in variables.ps1 to the ID of your newly created AMI

### Creating a launch template
1. Create a [custom AMI](<#creating-a-custom-amazon-machine-image>) and [security group](<#creating-a-security-group>) if you haven't done so already
2. Run `cd monolithic/scripts`
3. Load powershell variables with `. ./variables.ps1`
4. Create a launch template with `. ./create_launch_template.ps1`
5. Set $launchTemplate in variables.ps1 to the ID of your newly created launch template


## Deployment
### Basic
If you want to deploy this website on single EC2 instance with an AWS-provided machine image, run:
```
cd monolithic/scripts
./seed_ddb.ps1
./launch_basic_ec2.ps1
```
To terminate your application, run `./terminate.ps1`

### Preset
If you want to deploy this website on single EC2 instance with a pre-configured machine image, create a [custom AMI](<#creating-a-custom-amazon-machine-image>) (if you haven't done so already) and run:
```
cd monolithic/scripts
./seed_ddb.ps1
./launch_preset_ec2.ps1
```
To terminate your application, run `./terminate.ps1`

### Scaled
If you want to deploy this website with an EC2 auto scaling group and a load balancer, create a [custom AMI](<#creating-a-custom-amazon-machine-image>) and [launch template](<#creating-a-launch-template>) (if you haven't done so already) and run:
```
cd monolithic/scripts
./seed_ddb.ps1
./launch_scaled_ec2.ps1
```
To terminate your application, run `./terminate.ps1 scaled`

## Local Usage
1. Install [Python3](https://www.python.org/downloads/) (including pip)
2. Open your CLI
3. Run `cd monolithic/scripts`
5. Create and seed an AWS DynamoDB table with `. ./seed_ddb.ps1`
6. Run `cd server`
7. Create a Python virtual environment with `python -m venv venv`
8. Activate your virtual environment with `./venv/Scripts/activate`
8. Install necessary Python dependencies with `pip install -r requirements.txt`
9. Start your Flask server with `flask run`