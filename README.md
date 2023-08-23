# Automated Versioning and Deployment with GitHub Actions and GKE

This repository contains a DevOps project that demonstrates an automated versioning and deployment process using GitHub Actions and Google Kubernetes Engine (GKE). The workflow includes building, tagging, and pushing Docker images based on semantic versioning, running and checking containers, and deploying the application to GKE. The project integrates various tools and technologies to streamline the development and deployment lifecycle.

## Workflow Overview

The workflow is divided into three main stages: Build and Push, Run and Check, and Deploy to GKE. Here's how each stage works:

### 1. Build and Push

In this stage, the workflow triggers on every push to the `main` branch. It performs the following steps:

- **Checkout Repository**: Clones the repository to the GitHub Actions runner.

- **Get Last Version**: Retrieves the latest version of the application from Docker Hub using Docker API. This version is used as the starting point for version bumping.

- **Determine Version Bump**: Analyzes the commit message of the latest commit to decide the type of version bump (major, minor, or patch).

- **Bump Version**: Bumps the application version according to the determined bump type. It updates the version number based on semantic versioning rules.

- **Build Docker Image**: Builds a Docker image of the application using the bumped version number.

- **Log in to Docker Hub**: Logs in to Docker Hub using provided credentials.

- **Push Docker Image**: Pushes the built Docker image to Docker Hub with the bumped version tag. It also tags the image as `latest` for convenience.

### 2. Run and Check

This stage starts once the Build and Push stage successfully completes. It performs the following steps:

- **Pull Docker Image**: Pulls the latest Docker image from Docker Hub.

- **Check if Container is Running**: Checks if the containerized application is up and running by sending HTTP requests to the application's endpoint. If the container is not yet running, it waits and retries.

### 3. Deploy to GKE

This stage starts once the Run and Check stage successfully completes. It deploys the application to GKE using Kubernetes manifests. The steps include:

- **Checkout code**: Retrieves the latest code changes from the repository.

- **Set up Google Cloud SDK**: Configures Google Cloud SDK with the necessary authentication and project information.

- **Install GKE Auth Plugin**: Installs the GKE authentication plugin for `kubectl`.

- **Pull image from DockerHub**: Pulls the latest Docker image from Docker Hub.

- **Set kubectl context to GKE**: Sets the `kubectl` context to the GKE cluster.

- **Apply Kubernetes manifests**: Applies the Kubernetes deployment manifest to the GKE cluster.

- **Trigger GKE rollout**: Restarts the deployment to trigger a rollout of the updated application.

## Configuration

To use this workflow for your project, you need to set up the following secrets in your GitHub repository:

- `DOCKER_USERNAME`: Your Docker Hub username.
- `DOCKERHUB_TOKEN`: Your Docker Hub access token.
- `GCP_SA_KEY`: A Google Cloud service account key with appropriate GKE and GCR permissions.

Make sure to adjust any paths, environment variables, or configuration values in the workflow to match your project's structure and requirements.

## Usage

1. Make code changes to your project.

2. Push the changes to the `main` branch.

3. The workflow will be triggered automatically, starting with the Build and Push stage.

4. Upon successful completion of each stage, the workflow will automatically progress to the next stage.

## Conclusion

This DevOps project demonstrates an automated versioning and deployment pipeline using GitHub Actions and GKE. By leveraging semantic versioning, Docker Hub, and Kubernetes, the workflow allows for streamlined development, version management, and deployment of containerized applications.
