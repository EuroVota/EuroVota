#!/bin/bash
set -x

sudo chmod 777 /var/run/docker.sock

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 259683775580.dkr.ecr.us-east-1.amazonaws.com/users

sudo systemctl start docker

docker pull 259683775580.dkr.ecr.us-east-1.amazonaws.com/users:latest

sudo docker run -d -p 9000:9000 --restart unless-stopped 259683775580.dkr.ecr.us-east-1.amazonaws.com/users:latest
