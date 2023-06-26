pipeline {
    agent any
    
    stages {
        stage('Cleanup') {
            steps {
                script{
                    env.TEST_SERVER_IP = "52.23.224.120"
                    env.PROD_SERVER_IP = ""
                }
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
      
         stage('Deploy to EC2') {
            steps {
                script {
                    env.EC2_INSTANCE_IP = TEST_SERVER_IP
                    env.EC2_INSTANCE_USERNAME = "ec2-user"
                    env.EC2_INSTANCE_KEY = credentials('SSH-project_PRIVATE_KEY')
                }
                // Copy the zip file to the EC2 instance using SCP
                echo "Deploying to EC2 instance"
                sh "scp -i ${env.EC2_INSTANCE_KEY} PortfolioWebsite.zip ${env.EC2_INSTANCE_USERNAME}@${env.EC2_INSTANCE_IP}:/var/www/html/"
                
                // Connect to the EC2 instance and perform deployment steps
                echo "Connecting to EC2 instance"
                sh "ssh -i ${env.EC2_INSTANCE_KEY} ${env.EC2_INSTANCE_USERNAME}@${env.EC2_INSTANCE_IP} 'cd /var/www/html// && unzip -o PortfolioWebsite.zip && ./deploy.sh'"
            }
        }
    }
}
