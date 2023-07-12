# Use an official PHP with Apache base image
FROM php:apache

# Copy the website files to the Apache document root directory
COPY . /var/www/html/

# Install necessary PHP extensions for your application
RUN docker-php-ext-install mysqli

# Expose port 80 to allow incoming HTTP traffic
EXPOSE 80
