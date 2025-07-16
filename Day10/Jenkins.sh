#!/bin/bash

# install_jenkins.sh - Script to install Jenkins with Java 17 on RHEL/Amazon Linux

set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating system packages..."
sudo yum update -y

echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Upgrading all packages..."
sudo yum upgrade -y

echo "Installing Java 17 (Amazon Corretto)..."
sudo yum install java-17-amazon-corretto -y

echo "Installing Jenkins..."
sudo yum install jenkins -y

echo "Enabling and starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Jenkins service status:"
sudo systemctl status jenkins

echo "Jenkins installation completed. Access it via: http://<your-server-ip>:8080"
