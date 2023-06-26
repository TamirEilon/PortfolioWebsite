pipeline {
    agent any
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
                    
                    // Replace 'test-instance-ip' with the actual IP or hostname of your test instance
                    def testInstanceIP = "52.23.224.120"
                    echo "worked"
                    
                    // Replace 'SSH-project' with the ID of your SSH credential in Jenkins
                    def testInstanceCredential = credentials('SSH-project')
                    echo "worked 2"
                    
                    // Replace 'ec2-user' with the appropriate SSH user for your test instance (e.g., 'ubuntu', 'ec2-user')
                    def testInstanceUser = "ec2-user"
                    echo "worked 3"
                    
                    // Replace 'my-final-project-bucket' with the name of your S3 bucket
                    def s3BucketName = "my-final-project-bucket"
                    echo "worked 4"
                    
                    // Copy the zip file from the Jenkins workspace to the test instance using SCP
                    echo "Copying zip file to test instance"
                    sh "scp -i ${testInstanceCredential} -o StrictHostKeyChecking=no PortfolioWebsite.zip ${testInstanceUser}@${testInstanceIP}:~"
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
