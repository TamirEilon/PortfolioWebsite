#!/bin/bash

echo 'Clearing up the VM'

docker stop $(docker ps -aq)  # Stop all running containers
docker rm $(docker ps -aq)  # Remove all containers
docker rmi $(docker images -q)  # Remove all images

docker build -t "${IMAGE_NAME}:${VERSION}" .
