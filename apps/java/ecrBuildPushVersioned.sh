#!/bin/bash

if [[ -z "$TAG_VERSION" ]]; then
    echo "Must provide TAG_VERSION in environment" 1>&2
    exit 1
fi

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
tag="javaapp-$TAG_VERSION"
name="apprunner-xray"

docker build -t $name .
docker tag $name "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"
docker push "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"
