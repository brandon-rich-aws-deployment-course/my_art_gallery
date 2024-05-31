#!/bin/bash

# Update the package repository
sudo yum update -y

# Install Nginx
sudo yum install -y nginx

# Create a simple HTML file using echo
sudo echo "<html><body><h1>Hello, LinkedIn!</h1></body></html>" > /usr/share/nginx/html/index.html

# Start Nginx service
sudo systemctl start nginx
