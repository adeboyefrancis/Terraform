#!/bin/bash
yum update -y
yum install httpd -y
echo "This is an ASG test for my instance: $(hostname)" > /var/www/html/index.html
systemctl start httpd