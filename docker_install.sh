#!/bin/bash

sudo curl -fsSL https://get.docker.com -o get-docker.sh

sudo chmod +x get-docker.sh

sudo usermod -aG docker $USER

sudo systemctl enable docker

sudo systemctl start docker

echo Done installing Docker
