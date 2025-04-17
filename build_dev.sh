#!/usr/bin/env bash
set -e
VERSION=$(jq --raw-output '.version' package.json)
AWS_ACCOUNT_ID="359954733328"
REPO=$AWS_ACCOUNT_ID.dkr.ecr.us-east-2.amazonaws.com/trial-workspace
TAG_VERSION=$REPO:$VERSION-dev
TAG_LATEST=$REPO:latest-dev

# login to the AWS ECR
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $REPO

# build and push
echo BUILDING DEV IMAGE
# WARNING: DO NOT MODIFY THESE VALUES DIRECTLY use ./pipeline/<stage>BuildArgs
source ./pipeline/devBuildArgs
DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64 \
    --build-arg VITE_CUSTOMER_CONTROL_URL=${VITE_CUSTOMER_CONTROL_URL} \
    --build-arg VITE_KEYCLOAK_CLIENT_ID=${VITE_KEYCLOAK_CLIENT_ID} \
    --build-arg VITE_KEYCLOAK_URL=${VITE_KEYCLOAK_URL} \
    --build-arg VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL=${VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL} \
    --build-arg VITE_FEATURE_TRAINING_URL=${VITE_FEATURE_TRAINING_URL} \
    --build-arg VITE_HUB_URL=${VITE_HUB_URL} \
    --build-arg VITE_IAP_MODELER_URL=${VITE_IAP_MODELER_URL} \
    --build-arg ORIGIN=${ORIGIN} \
    --build-arg VITE_ARC_API_GATEWAY_URL=${VITE_ARC_API_GATEWAY_URL} \
    --build-arg VITE_TRIAL_DATASET_NUMBER=${VITE_TRIAL_DATASET_NUMBER} \
    --build-arg VITE_GILAB_MODULAR_URL=${VITE_GILAB_MODULAR_URL} \
    --progress=plain \
    --tag $TAG_LATEST \
    --tag "$TAG_VERSION" \
    --secret id=secrets,src=secrets . \
  && docker push "$TAG_VERSION" \
  && docker push $TAG_LATEST
