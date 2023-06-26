# Use the official Apache HTTP Server image as the base image
FROM httpd:2.4

# Copy your HTML and CSS files to the Apache document root directory
COPY . /usr/local/apache2/htdocs/

# (Optional) If you have any additional assets like images or JavaScript files, you can copy them as well
# COPY images/ /usr/local/apache2/htdocs/images/
# COPY scripts/ /usr/local/apache2/htdocs/scripts/

# (Optional) If you need to customize the Apache configuration, you can replace the default configuration file
# COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# (Optional) If you have any additional Apache modules or configurations, you can include them here
# For example, if you need to enable rewrite module:
# RUN sed -i '/#LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Expose port 80 for accessing the Apache server
EXPOSE 80

