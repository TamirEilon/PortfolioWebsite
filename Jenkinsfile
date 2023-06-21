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
      
       stage('Deploy to EC2') {
            steps {
                // Configure SSH key credentials for connecting to the EC2 instance
                // Set the SSH_PRIVATE_KEY and SSH_USER environment variables
                
                // Connect to the EC2 instance and execute commands remotely
                echo "Deploying to the test server"
                sh '''
                    ssh -i "$SSH_PRIVATE_KEY" "ec2-user@54.163.27.236" '
                        # Navigate to the desired directory
                        cd /var/www/html/
                        
                        # Download the zip file from S3
                        aws s3 cp s3://my-final-project-bucket/PortfolioWebsite.zip .
                        
                        # Unzip the file
                        unzip -o PortfolioWebsite.zip
                        
                        # Clean up the zip file
                        rm PortfolioWebsite.zip
                        
                        # Install & start Apache
                        sudo yum install httpd php -y
                        sudo service httpd start
                        
                        # Change permissions & ownerships
                        sudo chown -R apache:apache /var/www/html/
                        sudo chmod -R 755 /var/www/html/
                        
                        # Restart the Apache service
                        sudo service httpd restart
                        
                        # Enable & start the service
                        sudo systemctl enable apache.service
                        sudo systemctl start apache.service
                        
                        # Fix the limit-hit issue
                        sudo systemctl reset-failed apache.service
                        sudo systemctl start apache.service
                    '
                '''
            }
        }

      
        // Additional stages and steps
    }
}
