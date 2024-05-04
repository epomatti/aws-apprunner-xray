#!/bin/bash

cd ../app/

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
name="apprunner-xray"

docker build -t $name .
