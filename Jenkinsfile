pipeline {
    agent any
    environment {
        TEST_SERVER_IP = "54.198.88.216"
        PROD_SERVER_IP = ""
        TEST_INSTANCE_CREDENTIAL = credentials('SSH-project')
        TEST_INSTANCE_USER = "ec2-user"
        S3_BUCKET_NAME = "my-final-project-bucket"
        TEST_REGION = "us-east-1a"
        
        // Add more environment variables as needed
    }
    stages {
        stage('Cleanup') {
            steps {
                
                // Clean up the workspace before pulling from GitHub
                echo "Cleaning up"
                deleteDir()
            }
        }
        stage('Clone') {
            steps {
                // Clone your project repository from GitHub
                echo "Cloning from GitHub"
                git branch: 'main', url: 'https://github.com/TamirEilon/PortfolioWebsite.git'
            }
        }
        stage('Zip Files') {
            steps {
                // Zip the files from the cloned repository
                echo "Compressing files"
                sh 'zip -r PortfolioWebsite.zip .'
            }
        }
        stage('Upload to S3') {
            steps {
                script {
                    withCredentials([
                        [
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'AWS',
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]) {
                        // Upload the zip file to an S3 bucket using the AWS CLI
                        echo "Uploading to the cloud"
                        sh '/usr/local/bin/aws s3 cp PortfolioWebsite.zip s3://my-final-project-bucket/'
                    }
                }
            }
        }
        stage('Push to Test Instance') {
            steps {
                script {
                    // Copy the zip file from the Jenkins workspace to the test instance using SCP
                    echo "Copying zip file to test instance"
                    sh "ssh -i ${TEST_INSTANCE_CREDENTIAL.username} StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'unzip PortfolioWebsite.zip -d /var/www/html'"
                    echo "worked 5"
                    // SSH into the test instance and unzip the files
                    echo "Unzipping files on test instance"
                    sh "ssh -i ${testInstanceCredential} -o StrictHostKeyChecking=no ${testInstanceUser}@${testInstanceIP} 'unzip PortfolioWebsite.zip -d /var/www/html'"
                    echo "worked 6"
                    // Clean up the zip file on the test instance
                    echo "Cleaning up zip file on test instance"
                    sh "ssh -i ${testInstanceCredential} -o StrictHostKeyChecking=no ${testInstanceUser}@${testInstanceIP} 'rm PortfolioWebsite.zip'"
                    echo "worked 7"
                }
            }
        }
    }
}
