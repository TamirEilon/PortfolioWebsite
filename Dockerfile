# Use an official httpd (Apache) base image
FROM httpd:latest

# Copy the website files to the Apache document root directory
COPY . /usr/local/apache2/htdocs/

# Expose port 80 to allow incoming HTTP traffic
EXPOSE 80
