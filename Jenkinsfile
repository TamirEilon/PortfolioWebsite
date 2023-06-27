pipeline {
    agent any
    environment {
        TEST_SERVER_IP = "54.198.88.216"
        TEST_INSTANCE_CREDENTIAL = "/Users/tamireilon/Downloads/FinalProjectKey.pem"
        TEST_INSTANCE_USER = "ec2-user"
    }
    stages {
        stage('Cleanup') {
            steps {
                echo "Cleaning up"
                deleteDir()
            }
        }
        stage('Clone') {
            steps {
                echo "Cloning from GitHub"
                git branch: 'main', url: 'https://github.com/TamirEilon/PortfolioWebsite.git'
            }
        }
        stage('Zip Files') {
            steps {
                echo "Compressing files"
                sh 'zip -r PortfolioWebsite.zip .'
            }
        }
        stage('Upload to EC2') {
            steps {
                script {
                    echo "Copying zip file to EC2 instance"
                    sh "scp -i /Users/tamireilon/Downloads/FinalProjectKey.pem -o StrictHostKeyChecking=no PortfolioWebsite.zip ec2-user@54.198.88.216:~/"

                    echo "Unzipping files on EC2 instance"
                    sh "ssh -i ${TEST_INSTANCE_CREDENTIAL} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'unzip PortfolioWebsite.zip -d /var/www/html'"

                    echo "Cleaning up zip file on EC2 instance"
                    sh "ssh -i ${TEST_INSTANCE_CREDENTIAL} -o StrictHostKeyChecking=no ${TEST_INSTANCE_USER}@${TEST_SERVER_IP} 'rm PortfolioWebsite.zip'"
                }
            }
        }
    }
}
