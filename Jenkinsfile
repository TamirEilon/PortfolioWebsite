pipeline {
    agent any

    environment {
    SSH_PRIVATE_KEY = """
        -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAn+5u9TU7tnMMQwTnRghCNcxQA0Gm5uxBu/DzEFuc1/LrG/Ig
03bXaNBwfysWxZVDAAkBJbNM12uT6l6IGYIS0Wye4J2+/DwIS+KSIzszbClla4tJ
TIy5mqKO4AVBHsJ+v7YnQKiVNg2Afm/brGp2egTagB+UgqOfPhGezroupzKwoGeU
NkcYKMQ+uHMtivnH6dtgnq1XwK5D4Z76/nW+tXAXMZ0rfVxaqSIimJj97dINNGdX
w6SZcz8qKyFSqvh73Y5W+X+syYUHP1BfiK7Wk7OvlvcWHM1GV4ai1ytVp/kd3g2I
VUCgQcmRsteMpY0/h87iSHYjrtrsfCGOE8r8oQIDAQABAoIBAEdQ41mkq0PoeYdJ
IHgyJpQmz2ckV3CR2Z4dC8Y3k/EX+Y80oT6qt9OdXwzWAgmJTZ8uZLyS/6jv572S
+c2mGw4YCaDPtuJzQp/UIKZlN8D7lKYoLj9cYUd7RYrPzQISaMLETyyeACtiSfIX
nzV7I+m1UFnhuy+mFtRutwooK7WSSHcZ2Q0fSIDl7vHpLsYJmmiKJXP/hckugMwu
v3sLL6BLODYh4AL1nFnNofPFgxhcNhXauYYjafeWPAkcpjzcsq6eifKXPpcZiHEN
BIrHjbjE+I7ty8CXugvB30HT/wUDfh0zG2UjBvK3q9X6Pi/wpktai/etz3yqNjex
wzkBc4ECgYEA0HA6nJVrP7BnLFhwUx9cDuz0jDW93Tubf4OqeUmgqavM9roxkbhI
rjVXCbmHc+qUaohOhRSc0hI58oJrX6PGlCPYv/VC/xHsRicsp6KV+pelzX5Pv426
fyOoGPd6GVjEV0h43MNL5JTy4VKM23PmRXpC7nN03iLjmLybXdjnwgUCgYEAxGy0
OBxEAR1YGPbAM6NlX/fi2lAVciyYdhCXaL4POYS95IlplamyVuP5Gz3j/1gc7Ab7
mvaJxnERGWP09NZA+erBE/VMt2cTC/yM7bi4SRhprPEkr8i33K+8Pku56wIquhqm
mvWNeGsvs9Sj79Nn2cgFRA2vAXpcfxxPOHmjRu0CgYEAo14zMiMSijqSwvkWILBF
kRU7nuFITKu5droV1TZWDGYxIXhR/ap4nMIF1ANsHPhRFyZ6lGfRefz7Gg4KZk2R
CO8HpXxv5EeB7oIpx8Hw1xYgx+0mSDanY5ro15iwREmEqfyNbkpLo37y1pPC/wXa
B76J0yb/BFRIGqBJDcdB7pkCgYAWK4LH1oDic1JvNuKIsYeOpmbnZySUh24J3WOJ
gfIr9syMD+pn5whnAEIsjfa+6k4RYdRiMDNqv3ZDnGGYhNo+mv2B6CzpgmvG7ZFm
f3PlZCkBSRJv+MKv2PHxQhDQ8qSp7rohQVffYJG4xWZfekf9b7MQdE7tZscr3aEf
abNBHQKBgCyp0L9a60wQghSoz+Im7sZI4ljvq0xs7zeAqlrFH/nBbpKUFT4D/TYP
rbkCBDcxzmAvuF+jIA8GTS2Mzje9os/pKCptGQP4QZuirV3U42O157WtMpfmqqz2
zRq/1T5pcYT5JVHDCBAVkir34BQonFEmr18l/GYngwJNY71u3GUR
-----END RSA PRIVATE KEY-----
    """
}

  
    stages {
      stage('Cleanup') {
            steps {
                // Clean up the workspace before pulling from GitHub
                echo "Cleaning up"
                clean()
            }
        }
       
        stage('Clone') {
            steps {
                // Clone your project repository from GitHub
                echo "Cloning from GitHub
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
                // Configure AWS credentials using environment variables or AWS configuration files
                // Set the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_DEFAULT_REGION environment variables
                
                // Upload the zip file to an S3 bucket using the AWS CLI
                echo "Uploading to the cloud"
                sh 'aws s3 cp archive.zip s3://my-final-project-bucket/'
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
