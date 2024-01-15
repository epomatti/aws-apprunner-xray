#!/bin/bash

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
tag="nodeapp"

docker build -t apprunner-javaapp-xray .
docker tag apprunner-javaapp-xray "$account.dkr.ecr.$region.amazonaws.com/ecr-apprunner-java-xray:$tag"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"
docker push "$account.dkr.ecr.$region.amazonaws.com/ecr-apprunner-java-xray:$tag"