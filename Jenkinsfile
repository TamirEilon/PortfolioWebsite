pipeline {
    agent any
    environment {
        // Server's IPs
        BUILD_VM_IP = "34.165.155.165"
        TEST_VM_IP = "34.165.121.250"
        PROD_VM_IP = "34.165.90.247"

        // Variables for GCE
        GCE_PROJECT_ID = 'MyFinalProject'
        GCE_VM_INSTANCE_NAME = 'build'

        // Variables for DockerHub
        DOCKERHUB_REPONAME = "final-project"
        IMAGE_NAME = "website"
    }
    
    stages {
        stage('Cleaning the workspace') {
            steps {
                echo "Cleaning up the workspace on the Jenkins VM"
                deleteDir()
                echo "Cleaning up finished"
            }
        }

        stage('Clone Repository') {
            steps {
                echo "Cloning the repository from GitHub"
                git branch: 'main', url: 'https://github.com/TamirEilon/PortfolioWebsite.git'
                echo "Cloning from GitHub finished"
            }
        }

        stage('Cleaning the build VM') {
            steps {
                script {
                    def runningContainers = sh(
                        script: "docker ps --format '{{.Names}}'",
                        returnStdout: true
                    ).trim()
        
                    if (runningContainers) {
                        sh 'docker stop $(docker ps -a -q)'
                    } else {
                        echo 'No running containers found.'
                    }

                    def stoppedContainers = sh(
                        script: "docker ps -a --filter 'status=exited' --format '{{.Names}}'",
                        returnStdout: true
                    ).trim()
        
                    if (stoppedContainers) {
                        sh 'docker rm $(docker ps -a -q)'
                    } else {
                        echo 'No stopped containers found.'
                    }

                    sh 'docker image prune -a --force'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_LOGIN', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Build the image with the updated version
                        sh "docker build -t $DOCKER_USERNAME/${DOCKERHUB_REPONAME}:latest ."
                    }
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_LOGIN', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh "docker push $DOCKER_USERNAME/${DOCKERHUB_REPONAME}:latest"
                        sh "docker run -d -p 8000:80 $DOCKER_USERNAME/${DOCKERHUB_REPONAME}:latest"
                    }
                }
            }
        }
    }       
}
