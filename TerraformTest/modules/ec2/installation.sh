#!/bin/bash
set -x
sudo su
cd ~

sudo yum update -y
sudo yum install docker -y

# Install AWS CLI
sudo yum install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
