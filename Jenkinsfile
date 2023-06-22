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
      
        stage('Connect to EC2 Test Server') {
            steps {
                script {
                    def sshUser = 'ec2-user'
                    def sshKey = credentials('AWS_ACCESS_KEY_ID')
                    def serverIp = env.TEST_SERVER_IP
                    
                    // Connect to the EC2 instance using SSH
                    echo "Connecting to EC2 Test Server"
                    sshagent(credentials: [sshKey]) {
                        sh "ssh -o StrictHostKeyChecking=no -i ${sshKey} ${sshUser}@${serverIp} 'echo Connected'"
                    }
                }
            }
        }
    }
}
