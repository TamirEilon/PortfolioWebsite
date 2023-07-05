#!/bin/bash

# Update the system packages
sudo apt update

# Install required dependencies
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the Docker repository GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the system packages again
sudo apt update

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add the current user to the 'docker' group
sudo usermod -aG docker $USER

# Start Docker on system boot
sudo systemctl enable docker
