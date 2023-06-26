pipeline {
    agent any
    
    stages {
        stage('Clean Workspace') {
            steps {
                echo "cleaning workspace"
                cleanWs()
            }
        }
        
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/TamirEilon/PortfolioWebsite.git'
            }
        }
        
        stage('Build and Zip') {
            steps {
                echo "Compressing files"
                sh 'zip -r PortfolioWebsite.zip .'
            }
        }
        
        stage('Upload to S3') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'AWS_NEW') {
                    s3Upload(bucket: 'my-final-project-bucket', file: 'PortfolioWebsite.zip')
                }
            }
        }
        
        stage('Deploy to Test Machine') {
            steps {
                sshagent(['your-ssh-credentials']) {
                    sh 'ssh user@your-test-machine "unzip -o path/to/website.zip -d /var/www/html"'
                }
            }
        }
        
        stage('Deploy Docker with Apache') {
            steps {
                sh 'docker run -d -p 80:80 --name my-apache-container -v /var/www/html:/usr/local/apache2/htdocs httpd:latest'
            }
        }
    }
}
