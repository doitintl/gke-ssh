#!/bin/bash

IMAGE_NAME=gke-sshd
IMAGE_VERSION=latest
PROJECT_ID=...

docker build -t ${IMAGE_NAME} .
docker tag ${IMAGE_NAME} gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_VERSION}
docker push gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_VERSION}