#!/bin/bash

if [[ -z "$TAG_VERSION" ]]; then
    echo "Must provide TAG_VERSION in environment" 1>&2
    exit 1
fi

cd ../app/

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
tag="javaapp-$TAG_VERSION"
name="apprunner-xray"

docker tag $name "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"
docker push "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"


ServiceArn="arn:aws:apprunner:us-east-1:123456789012:service/python-app/8fe1e10304f84fd2b0df550fe98a71fa"

CONFIG="{\"ImageRepositoryType\":\"ECR\",\"ImageIdentifier\":\"$tag\"}"

aws apprunner update-service \
    --service-arn $ServiceArn \
    --source-configuration "ImageRepositoryType=ECR,ImageIdentifier=$tag"

