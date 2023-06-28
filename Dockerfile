# Use the official httpd base image
FROM httpd:latest

# Copy your website files to the container
COPY . /usr/local/apache2/htdocs/

