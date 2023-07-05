#!/bin/bash

echo 'Clearing up the VM'

docker rm --force \$(docker ps -aq)

// Deletes all images on the EC2 instance
docker rmi --force \$(docker images -q) 

// Kills all runing dockers on the EC2 instance, in order to use the 80 port again
docker kill \$(docker ps -q) || true 

docker rm -f websitecontainer

docker build -t ${IMAGE_NAME}:${VERSION} .
