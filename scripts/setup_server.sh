#!/bin/sh
serverSource="/home/ec2-user/server"
serverDest="/var/www/flask/server"

sudo su << EOF
# Install yum packages
yum update -y
yum install httpd -y
yum install httpd-devel -y
yum install python3-pip -y
yum install python3-devel -y

# Add log file
mkdir -p "${serverDest}/logs"
touch "${serverDest}/logs/fotd.log"
chown apache:apache "${serverDest}/logs/fotd.log"

# Move application files
rm -rf ${serverSource}/__pycache__ ${serverSource}/venv
mv "${serverSource}/fotd.conf" "/etc/httpd/conf.d/fotd.conf"
mv "${serverSource}/*" "${serverDest}"
rm -r "/home/ec2-user/server"

# Install Python packages
cd "${serverDest}"
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
pip install mod_wsgi

# Enable wsgi module on Apache
mod_wsgi-express install-module | head -n 1 > "/etc/httpd/conf.modules.d/02-wsgi.conf"

# Start Apache server
service httpd start
chkconfig httpd on
EOF