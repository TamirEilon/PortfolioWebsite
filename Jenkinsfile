pipeline {
    agent any
    environment {
        // TEST_SERVER_IP = "54.198.88.216"
        TEST_INSTANCE_USER = "ec2-user"
        KEY_PATH = "/Users/tamireilon/Downloads/FinalProjectKey.pem"
    }
    stages {
        stage('Get EC2 Instance TEST IP') {
            steps {
                script {
                    // Retrieve the EC2 instance IP address dynamically using the AWS CLI
                    def ipAddress = sh(returnStdout: true, script: "aws ec2 describe-instances --instance-id FinalProject - Test --query 'Reservations[0].Instances[0].PublicIpAddress' --output text").trim()
                    // Store the IP address in a variable
                    env.TEST_SERVER_IP = ipAddress
                }
            }
        }
        stage('Get EC2 Instance PROD IP') {
            steps {
                script {
                    // Retrieve the EC2 instance IP address dynamically using the AWS CLI
                    def ipAddress = sh(returnStdout: true, script: "aws ec2 describe-instances --instance-id FinalProject - Production --query 'Reservations[0].Instances[0].PublicIpAddress' --output text").trim()
                    // Store the IP address in a variable
                    env.PROD_SERVER_IP = ipAddress
                }
            }
        }
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
                    sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'sudo rm -rf /var/www/html/*'"
                    echo "Clearing /var/www/html folder completed"

                    echo "Copying zip file to EC2 instance"
                    sh "scp -i ${KEY_PATH} -o StrictHostKeyChecking=no PortfolioWebsite.zip ${TEST_INSTANCE_USER}@${TEST_SERVER_IP}:/var/www/html"
                    echo "Copying zip file completed"

                    echo "Unzipping files on EC2 instance"
                    sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'sudo unzip -o /var/www/html/PortfolioWebsite.zip -d /var/www/html'"
                    echo "Unzipping files on EC2 instance completed"
                    
                    echo "Cleaning up zip file on EC2 instance"
                    sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'rm /var/www/html/PortfolioWebsite.zip'"
                }
            }
        }
        stage('Run the Apache server & website') {
                steps {
                    script {
                        echo "Adding permissions to the user"
                        sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'sudo chown -R ec2-user /var/www/html'"
                        echo "Added permissions"
            
                        echo "Running the Apache server and website"
                        sh "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'sudo service httpd restart'"
                        echo "The Apache website is up and running"
                    }
                }
            }
        stage('Curl Test') {
                steps {
                    script {
                        echo "Running curl test"
                        sh "curl ${TEST_SERVER_IP}"
                        // Add any assertions or validations based on the curl response
                    }
                }
            }

    }
}
