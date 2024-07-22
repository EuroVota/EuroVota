#!/bin/bash
set -x

sudo chmod 777 /var/run/docker.sock

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 259683775580.dkr.ecr.us-east-1.amazonaws.com/eurovota

sudo systemctl start docker

docker pull 259683775580.dkr.ecr.us-east-1.amazonaws.com/eurovota:users

sudo docker run -d -p 9002:9002 --restart unless-stopped --name votes 259683775580.dkr.ecr.us-east-1.amazonaws.com/eurovota/votes:latest
