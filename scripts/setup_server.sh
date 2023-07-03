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

# Enable wsgi module on Apache
pip install mod_wsgi
mod_wsgi-express install-module | head -n 1 > "/etc/httpd/conf.modules.d/02-wsgi.conf"

# Move application files
mkdir -p ${serverDest}
mv "${serverSource}/fotd.conf" "/etc/httpd/conf.d/fotd.conf"
mv "${serverSource}/*" "${serverDest}"
chown apache:apache "${serverDest}/logs/fotd.log"
rm -r "/home/ec2-user/server"

# Install Python packages
cd "${serverDest}"
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt

# Start Apache server
service httpd start
chkconfig httpd on
EOF