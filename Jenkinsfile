pipeline {
    agent any
    environment {
        TEST_SERVER_IP = "54.198.88.216"
        TEST_INSTANCE_CREDENTIAL = "/Users/tamireilon/Downloads/FinalProjectKey.pem"
        TEST_INSTANCE_USER = "ec2-user"
        KEY_PATH = "/Users/tamireilon/Downloads/FinalProjectKey.pem"
    }
    stages {
        stage('Cleanup') {
            steps {
                echo "Cleaning up"
                deleteDir()
                echo "cleaning up finished"
            }
        }
        stage('Clone') {
            steps {
                echo "Cloning from GitHub"
                git branch: 'main', url: 'https://github.com/TamirEilon/PortfolioWebsite.git'
                echo "cloning from git finished"
            }
        }
        stage('Zip Files') {
            steps {
                echo "Compressing files"
                sh 'zip -r PortfolioWebsite.zip .'
                echo "zipping files finished"
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
                        echo "uploading to s3 finished"
                    }
                }
            }
        }
        stage('Upload to EC2') {
            steps {
                script {
                    echo "Clearing /var/www/html folder"
                    sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'rm -rf /var/www/html/*'"
                    echo "Clearing /var/www/html folder completed"

                    
                    //echo "Copying zip file to EC2 instance"
                    //sh "scp -i ${KEY_PATH} -o StrictHostKeyChecking=no PortfolioWebsite.zip ${TEST_INSTANCE_USER}@${TEST_SERVER_IP}:/var/www/html"
                    //echo "Copying zip file completed"

                    //echo "Unzipping files on EC2 instance"
                    //sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'unzip PortfolioWebsite.zip -d /var/www/html'"
                    //echo "Unzipping files on EC2 instance completed"
                    //echo "Cleaning up zip file on EC2 instance"
                    //sh "ssh -i ${TEST_INSTANCE_CREDENTIAL} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'rm PortfolioWebsite.zip'"
                }
            }
        }
    }
}
