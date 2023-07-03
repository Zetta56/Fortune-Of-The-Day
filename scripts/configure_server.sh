#!/bin/sh
cd /var/www/flask/server
mv fotd.conf /etc/httpd/conf.d/fotd.conf
chown apache:apache logs/fotd.log
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt