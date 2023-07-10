#!/bin/bash

sudo yum update -y

sudo yum install -y docker

sudo service docker start

sudo systemctl enable docker

sudo usermod -a -G docker ec2-user
