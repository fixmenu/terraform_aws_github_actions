#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install docker -y
sudo usermod -a -G docker ec2-user
sudo service docker start