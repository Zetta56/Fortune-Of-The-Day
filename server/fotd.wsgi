#!/usr/bin/python3
import sys
import logging

logging.basicConfig(
  level=logging.WARN,
  filename="/var/www/flask/server/logs/fotd.log",
  format="%(asctime)s %(message)s"
)
sys.path.insert(0, "/var/www/flask")
sys.path.insert(0, "/var/www/flask/server/venv/lib/python3.9/site-packages")

from server import create_app
application = create_app()