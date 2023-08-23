# DevOps Project README

Welcome to the README file for my final DevOps project. This document will guide you through the setup, usage, and components of my project, which utilizes GitHub Actions, Helm, Google Kubernetes Engine (GKE), and an automated versioning method.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Automated Versioning](#automated-versioning)
- [GitHub Actions](#github-actions)
- [Google Kubernetes Engine (GKE)](#google-kubernetes-engine-gke)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

## Project Overview

The purpose of this project is to showcase a DevOps workflow for deploying applications to Google Kubernetes Engine (GKE) using GitHub Actions. The project also includes an automated versioning mechanism to streamline the deployment process and image tracking in DockerHub.

## Prerequisites

Before you begin, ensure you have the following tools and accounts set up:

1. **GitHub Account**: You need a GitHub account to create and manage your repository.
2. **Google Cloud Platform (GCP) Account**: Set up a GCP account and create a GKE cluster for deployment.
3. **Docker**: Install Docker to build and manage container images.
4. **kubectl**: Install the Kubernetes command-line tool to interact with your GKE cluster.
5. **Helm**: Install Helm, a package manager for Kubernetes applications.
6. **DockerHub**: You need a DockerHub account to create and manage your image repository

## Getting Started

1. **Repository Setup**: Create a new GitHub repository for your project.

2. **Clone Repository**: Clone the repository to your local development environment:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

3. **Application Code**: Place your application code in the repository directory.

## Automated Versioning

The automated versioning method of the project uses a semantic versioning method (3-digit), that updates the version according to the user's commit message - in the commit message the user (AKA the developer), is asked to use a keyword according to the change he did to the app (major/minor/patch).
If the user won't use any of the keywords specified, then the function will automatically see it as a patch and will change the version accordingly. 

In order for the function to work, it needs to pull the latest version that exists in DockerHub. These few lines pull all the versions that were pushed to DockerHub and organize them so it will show only the latest.
```bash
last_version=$(curl -s "https://registry.hub.docker.com/v2/repositories/${{ secrets.DOCKER_USERNAME }}/portfolio-website/tags/?page_size=10" | jq -r '.results[].name' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)
        echo "::set-output name=last_version::$last_version"
```


This section 
      
```bash
        commit_message=$(git log -1 --pretty=%B)
        if echo "$commit_message" | grep -qiE 'major'; then
          echo "::set-output name=bump_type::major"
        elif echo "$commit_message" | grep -qiE 'minor'; then
          echo "::set-output name=bump_type::minor"
        else
          echo "::set-output name=bump_type::patch"
        fi
```


## GitHub Actions

Explain how GitHub Actions are set up in your project to automate the deployment process. Include information about the workflow files, how they are triggered, and any environment variables or secrets required.

## Google Kubernetes Engine (GKE)

Describe how to set up a GKE cluster using GCP, including any specific configurations or settings you've chosen for your deployment. Explain how to authenticate `kubectl` with your GKE cluster and ensure smooth communication between your deployment pipeline and the cluster.

## Troubleshooting

List common issues that users might encounter and provide solutions. Include steps for debugging deployment problems, diagnosing GitHub Actions failures, and resolving GKE-related issues.

## Conclusion

In conclusion, this DevOps project demonstrates an end-to-end workflow for deploying applications using GitHub Actions, Helm, and Google Kubernetes Engine. By following the instructions in this README, you'll be able to effectively set up and manage a CI/CD pipeline with automated versioning. If you encounter any issues or have questions, don't hesitate to reach out for assistance.

Happy DevOps-ing! 🚀
