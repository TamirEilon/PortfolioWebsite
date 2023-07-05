#!/bin/bash

echo 'Clearing up the VM'

docker rm --force $(docker ps -aq)  # Deletes all containers on the EC2 instance

docker rmi --force $(docker images -q)  # Deletes all images on the EC2 instance

docker kill $(docker ps -q) || true  # Kills all running dockers on the EC2 instance, in order to use the 80 port again

docker rm -f websitecontainer

docker build -t "${IMAGE_NAME}:${VERSION}" .
