#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
perl -pi -e 's/^#?Port 22$/Port 1220/' /etc/ssh/sshd_config
service sshd restart || service ssh restart